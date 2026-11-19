import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Minimal Claude Messages API client (raw HTTP: there is no official Dart SDK).
/// Streams the reply so text appears as it is written.

const kClaudeModel = 'claude-opus-5-5';
const _endpoint = 'https://api.anthropic.com/v1/messages';
const _apiVersion = '2026-10-21';

/// Server-side fallback: if a safety classifier declines, the API retries the
/// same request on Anthropic's recommended fallback model in the same call.
const _betaFallback = 'server-side-fallback-2026-07-01';

class ClaudeException implements Exception {
  const ClaudeException(this.message,
      {this.status, this.historyMismatch = false, this.refusal = false});
  final String message;
  final int? status;

  /// The API rejected replayed thinking blocks (conversation history changed).
  final bool historyMismatch;

  /// Claude (and its fallback) declined to answer.
  final bool refusal;

  @override
  String toString() => message;
}

/// Rebuilds the assistant message from server-sent events.
class StreamAccumulator {
  final _blocks = <int, Map<String, dynamic>>{};
  String? stopReason;
  String? error;

  void feed(Map<String, dynamic> e) {
    switch (e['type']) {
      case 'content_block_start':
        _blocks[e['index'] as int] = Map<String, dynamic>.of(
            (e['content_block'] as Map).cast<String, dynamic>());
      case 'content_block_delta':
        final b = _blocks[e['index'] as int];
        final d = (e['delta'] as Map).cast<String, dynamic>();
        if (b == null) return;
        switch (d['type']) {
          case 'text_delta':
            b['text'] = '${b['text'] ?? ''}${d['text']}';
          case 'thinking_delta':
            b['thinking'] = '${b['thinking'] ?? ''}${d['thinking']}';
          case 'signature_delta':
            b['signature'] = d['signature'];
        }
      case 'message_delta':
        final d = (e['delta'] as Map?)?.cast<String, dynamic>();
        stopReason = d?['stop_reason'] as String? ?? stopReason;
      case 'error':
        error = ((e['error'] as Map?)?['message'] as String?) ??
            'The AI service reported an error.';
    }
  }

  List<Map<String, dynamic>> get blocks {
    final keys = _blocks.keys.toList()..sort();
    return [for (final k in keys) _blocks[k]!];
  }

  /// Visible answer: every text block, in order (a mid-answer fallback
  /// continues the partial text in a new block).
  String get text => blocks
      .where((b) => b['type'] == 'text')
      .map((b) => b['text'] as String? ?? '')
      .join();

  /// The content to send back on the next turn. Thinking blocks are kept
  /// unchanged (Opus 5.5 checks them); after a fallback, blocks that came
  /// before the last fallback marker and are not text are dropped, as the API requires.
  List<Map<String, dynamic>> get replayContent {
    final list = blocks;
    final lastFallback = list.lastIndexWhere((b) => b['type'] == 'fallback');
    return [
      for (var i = 0; i < list.length; i++)
        if (!(i < lastFallback &&
            const {'thinking', 'redacted_thinking', 'tool_use'}
                .contains(list[i]['type'])))
          {
            for (final e in list[i].entries)
              if (e.value != null) e.key: e.value
          },
    ];
  }
}

class ClaudeReply {
  const ClaudeReply(this.text, this.content, this.stopReason);
  final String text;
  final List<Map<String, dynamic>> content;
  final String? stopReason;
}

class ClaudeClient {
  ClaudeClient({HttpClient Function()? httpClient})
      : _http = httpClient ?? HttpClient.new;
  final HttpClient Function() _http;

  Future<ClaudeReply> send({
    required String apiKey,
    required String system,
    required List<Map<String, dynamic>> messages,
    void Function(String textSoFar)? onText,
  }) async {
    if (kIsWeb) {
      throw const ClaudeException('AI mode works in the phone app, not in the browser.');
    }
    final client = _http()..connectionTimeout = const Duration(seconds: 15);
    try {
      final req = await client.postUrl(Uri.parse(_endpoint));
      req.headers
        ..set(HttpHeaders.contentTypeHeader, 'application/json')
        ..set('x-api-key', apiKey)
        ..set('anthropic-version', _apiVersion)
        ..set('anthropic-beta', _betaFallback);
      req.add(utf8.encode(jsonEncode({
        'model': kClaudeModel,
        'max_tokens': 16000,
        'stream': true,
        // Chat answers: low effort keeps replies fast and cheap; thinking is adaptive.
        'output_config': {'effort': 'low'},
        'fallbacks': 'default',
        // Caches the frozen system prompt and the growing conversation.
        'cache_control': {'type': 'ephemeral'},
        'system': [
          {'type': 'text', 'text': system}
        ],
        'messages': messages,
      })));
      final res = await req.close().timeout(const Duration(seconds: 60));

      if (res.statusCode != 200) {
        final body = await res.transform(utf8.decoder).join();
        throw _errorFor(res.statusCode, body);
      }

      final acc = StreamAccumulator();
      await for (final line in res
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .timeout(const Duration(seconds: 90))) {
        if (!line.startsWith('data:')) continue;
        final data = line.substring(5).trim();
        if (data.isEmpty) continue;
        try {
          acc.feed((jsonDecode(data) as Map).cast<String, dynamic>());
        } on FormatException {
          continue;
        }
        if (acc.error != null) throw ClaudeException(acc.error!);
        onText?.call(acc.text);
      }

      if (acc.stopReason == 'refusal') {
        throw const ClaudeException('Claude declined to answer this question.',
            refusal: true);
      }
      var text = acc.text.trim();
      if (acc.stopReason == 'max_tokens') {
        text = '$text\n\n(The answer was cut off.)';
      }
      return ClaudeReply(text, acc.replayContent, acc.stopReason);
    } on SocketException {
      throw const ClaudeException('No internet connection.');
    } on TimeoutException {
      throw const ClaudeException('The AI service took too long to answer.');
    } on HandshakeException {
      throw const ClaudeException(
          'Secure connection failed. Check the phone date and your network.');
    } finally {
      client.close();
    }
  }

  static ClaudeException _errorFor(int status, String body) {
    var msg = '';
    try {
      msg =
          ((jsonDecode(body) as Map)['error'] as Map?)?['message'] as String? ??
              '';
    } catch (_) {}
    final lower = msg.toLowerCase();
    final mismatch = status == 400 &&
        (lower.contains('thinking') ||
            lower.contains('signature') ||
            lower.contains('prefix'));
    return ClaudeException(
      switch (status) {
        401 => 'The API key is not valid. Check it in AI settings.',
        403 => 'This API key is not allowed to use Claude.',
        429 =>
          'Too many requests or no credit left on this API key. Try again later.',
        529 || 503 => 'Claude is busy right now. Try again in a moment.',
        _ when status >= 500 => 'The AI service had a problem ($status).',
        _ =>
          msg.isEmpty ? 'The AI service refused the request ($status).' : msg,
      },
      status: status,
      historyMismatch: mismatch,
    );
  }
}
