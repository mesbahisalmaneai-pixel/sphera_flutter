import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/google_repository.dart';
import '../../data/providers.dart';

final _emailRe = RegExp(r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$');

/// Add (account == null) or edit a Google account.
class GoogleAccountForm extends ConsumerStatefulWidget {
  const GoogleAccountForm({super.key, this.account, this.initialStatuses = const {}});
  final GoogleAccount? account;
  final Map<String, BoxStatus> initialStatuses;

  @override
  ConsumerState<GoogleAccountForm> createState() => _GoogleAccountFormState();
}

class _GoogleAccountFormState extends ConsumerState<GoogleAccountForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late Grade _grade;
  late Map<String, BoxStatus> _statuses;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.account != null;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.account?.email ?? '');
    _grade = widget.account?.grade ?? Grade.bronze;
    _statuses = Map.of(widget.initialStatuses);
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final repo = ref.read(googleRepoProvider);
    try {
      if (_isEdit) {
        await repo.updateAccount(widget.account!.id,
            email: _email.text, grade: _grade, statuses: _statuses);
      } else {
        await repo.createAccount(email: _email.text, grade: _grade, statuses: _statuses);
      }
      if (mounted) Navigator.of(context).pop(true);
    } on DuplicateEmailException catch (e) {
      setState(() => _error = e.toString());
    } catch (e) {
      setState(() => _error = 'Could not save: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(activeGamesProvider).value ?? <Game>[];
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Google Account' : 'Add Google Account')),
      body: Form(
        key: _formKey,
        child: ListView(padding: EdgeInsets.all(20), children: [
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (v) {
              final t = (v ?? '').trim();
              if (t.isEmpty) return 'Email is required';
              if (!_emailRe.hasMatch(t)) return 'Enter a valid email address';
              return null;
            },
          ),
          SizedBox(height: 24),
          Text('Grade', style: TextStyle(color: SpheraColors.muted)),
          SizedBox(height: 8),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (final g in Grade.values)
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _grade = g),
                child: Container(
                  width: 96,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _grade == g
                        ? gradeColor(g).withValues(alpha: 0.15)
                        : SpheraColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: _grade == g ? gradeColor(g) : SpheraColors.border,
                        width: _grade == g ? 2 : 1),
                  ),
                  child: Column(children: [
                    GradeMedal(g, size: 44),
                    SizedBox(height: 6),
                    Text(gradeLabel(g),
                        style: TextStyle(
                            fontSize: 12,
                            color: _grade == g ? gradeColor(g) : SpheraColors.ivory)),
                  ]),
                ),
              ),
          ]),
          SizedBox(height: 24),
          Text('Game boxes', style: TextStyle(color: SpheraColors.muted)),
          SizedBox(height: 8),
          for (final game in games)
            Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(game.name, style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 6, children: [
                    for (final s in BoxStatus.values)
                      ChoiceChip(
                        label: Text(boxLabel(s)),
                        selected: (_statuses[game.id] ?? BoxStatus.empty) == s,
                        selectedColor: boxColor(s).withValues(alpha: 0.3),
                        side: BorderSide(color: boxColor(s)),
                        onSelected: (_) => setState(() => _statuses[game.id] = s),
                      ),
                  ]),
                ]),
              ),
            ),
          if (_error != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(_error!, style: TextStyle(color: SpheraColors.danger)),
            ),
          SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : Text(_isEdit ? 'Save changes' : 'Add account'),
          ),
        ]),
      ),
    );
  }
}
