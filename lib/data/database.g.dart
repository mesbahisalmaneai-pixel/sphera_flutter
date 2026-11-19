// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _logoAssetPathMeta =
      const VerificationMeta('logoAssetPath');
  @override
  late final GeneratedColumn<String> logoAssetPath = GeneratedColumn<String>(
      'logo_asset_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountImagePathMeta =
      const VerificationMeta('accountImagePath');
  @override
  late final GeneratedColumn<String> accountImagePath = GeneratedColumn<String>(
      'account_image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerId,
        name,
        logoAssetPath,
        accountImagePath,
        createdAt,
        updatedAt,
        archivedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(Insertable<Game> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('logo_asset_path')) {
      context.handle(
          _logoAssetPathMeta,
          logoAssetPath.isAcceptableOrUnknown(
              data['logo_asset_path']!, _logoAssetPathMeta));
    }
    if (data.containsKey('account_image_path')) {
      context.handle(
          _accountImagePathMeta,
          accountImagePath.isAcceptableOrUnknown(
              data['account_image_path']!, _accountImagePathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      logoAssetPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_asset_path']),
      accountImagePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}account_image_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}archived_at']),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class Game extends DataClass implements Insertable<Game> {
  final String id;
  final String ownerId;
  final String name;
  final String? logoAssetPath;
  final String? accountImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const Game(
      {required this.id,
      required this.ownerId,
      required this.name,
      this.logoAssetPath,
      this.accountImagePath,
      required this.createdAt,
      required this.updatedAt,
      this.archivedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || logoAssetPath != null) {
      map['logo_asset_path'] = Variable<String>(logoAssetPath);
    }
    if (!nullToAbsent || accountImagePath != null) {
      map['account_image_path'] = Variable<String>(accountImagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      name: Value(name),
      logoAssetPath: logoAssetPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoAssetPath),
      accountImagePath: accountImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(accountImagePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Game.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      name: serializer.fromJson<String>(json['name']),
      logoAssetPath: serializer.fromJson<String?>(json['logoAssetPath']),
      accountImagePath: serializer.fromJson<String?>(json['accountImagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'name': serializer.toJson<String>(name),
      'logoAssetPath': serializer.toJson<String?>(logoAssetPath),
      'accountImagePath': serializer.toJson<String?>(accountImagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Game copyWith(
          {String? id,
          String? ownerId,
          String? name,
          Value<String?> logoAssetPath = const Value.absent(),
          Value<String?> accountImagePath = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> archivedAt = const Value.absent()}) =>
      Game(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        name: name ?? this.name,
        logoAssetPath:
            logoAssetPath.present ? logoAssetPath.value : this.logoAssetPath,
        accountImagePath: accountImagePath.present
            ? accountImagePath.value
            : this.accountImagePath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
      );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      name: data.name.present ? data.name.value : this.name,
      logoAssetPath: data.logoAssetPath.present
          ? data.logoAssetPath.value
          : this.logoAssetPath,
      accountImagePath: data.accountImagePath.present
          ? data.accountImagePath.value
          : this.accountImagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('logoAssetPath: $logoAssetPath, ')
          ..write('accountImagePath: $accountImagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, name, logoAssetPath,
      accountImagePath, createdAt, updatedAt, archivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.name == this.name &&
          other.logoAssetPath == this.logoAssetPath &&
          other.accountImagePath == this.accountImagePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> name;
  final Value<String?> logoAssetPath;
  final Value<String?> accountImagePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.logoAssetPath = const Value.absent(),
    this.accountImagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesCompanion.insert({
    required String id,
    required String ownerId,
    required String name,
    this.logoAssetPath = const Value.absent(),
    this.accountImagePath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Game> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? name,
    Expression<String>? logoAssetPath,
    Expression<String>? accountImagePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (logoAssetPath != null) 'logo_asset_path': logoAssetPath,
      if (accountImagePath != null) 'account_image_path': accountImagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? name,
      Value<String?>? logoAssetPath,
      Value<String?>? accountImagePath,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? archivedAt,
      Value<int>? rowid}) {
    return GamesCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      logoAssetPath: logoAssetPath ?? this.logoAssetPath,
      accountImagePath: accountImagePath ?? this.accountImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (logoAssetPath.present) {
      map['logo_asset_path'] = Variable<String>(logoAssetPath.value);
    }
    if (accountImagePath.present) {
      map['account_image_path'] = Variable<String>(accountImagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('logoAssetPath: $logoAssetPath, ')
          ..write('accountImagePath: $accountImagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoogleAccountsTable extends GoogleAccounts
    with TableInfo<$GoogleAccountsTable, GoogleAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoogleAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Grade, int> grade =
      GeneratedColumn<int>('grade', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Grade>($GoogleAccountsTable.$convertergrade);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ownerId, email, grade, favorite, createdAt, updatedAt, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'google_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<GoogleAccount> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoogleAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoogleAccount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      grade: $GoogleAccountsTable.$convertergrade.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade'])!),
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $GoogleAccountsTable createAlias(String alias) {
    return $GoogleAccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Grade, int, int> $convertergrade =
      const EnumIndexConverter<Grade>(Grade.values);
}

class GoogleAccount extends DataClass implements Insertable<GoogleAccount> {
  final String id;
  final String ownerId;
  final String email;
  final Grade grade;
  final bool favorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const GoogleAccount(
      {required this.id,
      required this.ownerId,
      required this.email,
      required this.grade,
      required this.favorite,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['email'] = Variable<String>(email);
    {
      map['grade'] =
          Variable<int>($GoogleAccountsTable.$convertergrade.toSql(grade));
    }
    map['favorite'] = Variable<bool>(favorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  GoogleAccountsCompanion toCompanion(bool nullToAbsent) {
    return GoogleAccountsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      email: Value(email),
      grade: Value(grade),
      favorite: Value(favorite),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GoogleAccount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoogleAccount(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      email: serializer.fromJson<String>(json['email']),
      grade: $GoogleAccountsTable.$convertergrade
          .fromJson(serializer.fromJson<int>(json['grade'])),
      favorite: serializer.fromJson<bool>(json['favorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'email': serializer.toJson<String>(email),
      'grade': serializer
          .toJson<int>($GoogleAccountsTable.$convertergrade.toJson(grade)),
      'favorite': serializer.toJson<bool>(favorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  GoogleAccount copyWith(
          {String? id,
          String? ownerId,
          String? email,
          Grade? grade,
          bool? favorite,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      GoogleAccount(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        email: email ?? this.email,
        grade: grade ?? this.grade,
        favorite: favorite ?? this.favorite,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  GoogleAccount copyWithCompanion(GoogleAccountsCompanion data) {
    return GoogleAccount(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      email: data.email.present ? data.email.value : this.email,
      grade: data.grade.present ? data.grade.value : this.grade,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoogleAccount(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('email: $email, ')
          ..write('grade: $grade, ')
          ..write('favorite: $favorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, ownerId, email, grade, favorite, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoogleAccount &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.email == this.email &&
          other.grade == this.grade &&
          other.favorite == this.favorite &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class GoogleAccountsCompanion extends UpdateCompanion<GoogleAccount> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> email;
  final Value<Grade> grade;
  final Value<bool> favorite;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const GoogleAccountsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.email = const Value.absent(),
    this.grade = const Value.absent(),
    this.favorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoogleAccountsCompanion.insert({
    required String id,
    required String ownerId,
    required String email,
    required Grade grade,
    this.favorite = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        email = Value(email),
        grade = Value(grade),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<GoogleAccount> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? email,
    Expression<int>? grade,
    Expression<bool>? favorite,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (email != null) 'email': email,
      if (grade != null) 'grade': grade,
      if (favorite != null) 'favorite': favorite,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoogleAccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? email,
      Value<Grade>? grade,
      Value<bool>? favorite,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return GoogleAccountsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      email: email ?? this.email,
      grade: grade ?? this.grade,
      favorite: favorite ?? this.favorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(
          $GoogleAccountsTable.$convertergrade.toSql(grade.value));
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoogleAccountsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('email: $email, ')
          ..write('grade: $grade, ')
          ..write('favorite: $favorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoogleGameBoxesTable extends GoogleGameBoxes
    with TableInfo<$GoogleGameBoxesTable, GoogleGameBox> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoogleGameBoxesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _googleAccountIdMeta =
      const VerificationMeta('googleAccountId');
  @override
  late final GeneratedColumn<String> googleAccountId = GeneratedColumn<String>(
      'google_account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
      'game_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<BoxStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<BoxStatus>($GoogleGameBoxesTable.$converterstatus);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, googleAccountId, gameId, status, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'google_game_boxes';
  @override
  VerificationContext validateIntegrity(Insertable<GoogleGameBox> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('google_account_id')) {
      context.handle(
          _googleAccountIdMeta,
          googleAccountId.isAcceptableOrUnknown(
              data['google_account_id']!, _googleAccountIdMeta));
    } else if (isInserting) {
      context.missing(_googleAccountIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {googleAccountId, gameId},
      ];
  @override
  GoogleGameBox map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoogleGameBox(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      googleAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}google_account_id'])!,
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}game_id'])!,
      status: $GoogleGameBoxesTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $GoogleGameBoxesTable createAlias(String alias) {
    return $GoogleGameBoxesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BoxStatus, int, int> $converterstatus =
      const EnumIndexConverter<BoxStatus>(BoxStatus.values);
}

class GoogleGameBox extends DataClass implements Insertable<GoogleGameBox> {
  final String id;
  final String googleAccountId;
  final String gameId;
  final BoxStatus status;
  final DateTime updatedAt;
  const GoogleGameBox(
      {required this.id,
      required this.googleAccountId,
      required this.gameId,
      required this.status,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['google_account_id'] = Variable<String>(googleAccountId);
    map['game_id'] = Variable<String>(gameId);
    {
      map['status'] =
          Variable<int>($GoogleGameBoxesTable.$converterstatus.toSql(status));
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GoogleGameBoxesCompanion toCompanion(bool nullToAbsent) {
    return GoogleGameBoxesCompanion(
      id: Value(id),
      googleAccountId: Value(googleAccountId),
      gameId: Value(gameId),
      status: Value(status),
      updatedAt: Value(updatedAt),
    );
  }

  factory GoogleGameBox.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoogleGameBox(
      id: serializer.fromJson<String>(json['id']),
      googleAccountId: serializer.fromJson<String>(json['googleAccountId']),
      gameId: serializer.fromJson<String>(json['gameId']),
      status: $GoogleGameBoxesTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'googleAccountId': serializer.toJson<String>(googleAccountId),
      'gameId': serializer.toJson<String>(gameId),
      'status': serializer
          .toJson<int>($GoogleGameBoxesTable.$converterstatus.toJson(status)),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GoogleGameBox copyWith(
          {String? id,
          String? googleAccountId,
          String? gameId,
          BoxStatus? status,
          DateTime? updatedAt}) =>
      GoogleGameBox(
        id: id ?? this.id,
        googleAccountId: googleAccountId ?? this.googleAccountId,
        gameId: gameId ?? this.gameId,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  GoogleGameBox copyWithCompanion(GoogleGameBoxesCompanion data) {
    return GoogleGameBox(
      id: data.id.present ? data.id.value : this.id,
      googleAccountId: data.googleAccountId.present
          ? data.googleAccountId.value
          : this.googleAccountId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoogleGameBox(')
          ..write('id: $id, ')
          ..write('googleAccountId: $googleAccountId, ')
          ..write('gameId: $gameId, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, googleAccountId, gameId, status, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoogleGameBox &&
          other.id == this.id &&
          other.googleAccountId == this.googleAccountId &&
          other.gameId == this.gameId &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt);
}

class GoogleGameBoxesCompanion extends UpdateCompanion<GoogleGameBox> {
  final Value<String> id;
  final Value<String> googleAccountId;
  final Value<String> gameId;
  final Value<BoxStatus> status;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GoogleGameBoxesCompanion({
    this.id = const Value.absent(),
    this.googleAccountId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoogleGameBoxesCompanion.insert({
    required String id,
    required String googleAccountId,
    required String gameId,
    this.status = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        googleAccountId = Value(googleAccountId),
        gameId = Value(gameId),
        updatedAt = Value(updatedAt);
  static Insertable<GoogleGameBox> custom({
    Expression<String>? id,
    Expression<String>? googleAccountId,
    Expression<String>? gameId,
    Expression<int>? status,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (googleAccountId != null) 'google_account_id': googleAccountId,
      if (gameId != null) 'game_id': gameId,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoogleGameBoxesCompanion copyWith(
      {Value<String>? id,
      Value<String>? googleAccountId,
      Value<String>? gameId,
      Value<BoxStatus>? status,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return GoogleGameBoxesCompanion(
      id: id ?? this.id,
      googleAccountId: googleAccountId ?? this.googleAccountId,
      gameId: gameId ?? this.gameId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (googleAccountId.present) {
      map['google_account_id'] = Variable<String>(googleAccountId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $GoogleGameBoxesTable.$converterstatus.toSql(status.value));
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoogleGameBoxesCompanion(')
          ..write('id: $id, ')
          ..write('googleAccountId: $googleAccountId, ')
          ..write('gameId: $gameId, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameAccountsTable extends GameAccounts
    with TableInfo<$GameAccountsTable, GameAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
      'game_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idCompteMeta =
      const VerificationMeta('idCompte');
  @override
  late final GeneratedColumn<String> idCompte = GeneratedColumn<String>(
      'id_compte', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
      'purchase_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _salePriceMeta =
      const VerificationMeta('salePrice');
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
      'sale_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<GameAccountStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<GameAccountStatus>(
              $GameAccountsTable.$converterstatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _playerPhotoIdsMeta =
      const VerificationMeta('playerPhotoIds');
  @override
  late final GeneratedColumn<String> playerPhotoIds = GeneratedColumn<String>(
      'player_photo_ids', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerId,
        gameId,
        idCompte,
        name,
        purchasePrice,
        salePrice,
        status,
        notes,
        playerPhotoIds,
        photoPath,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<GameAccount> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('id_compte')) {
      context.handle(_idCompteMeta,
          idCompte.isAcceptableOrUnknown(data['id_compte']!, _idCompteMeta));
    } else if (isInserting) {
      context.missing(_idCompteMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
          _purchasePriceMeta,
          purchasePrice.isAcceptableOrUnknown(
              data['purchase_price']!, _purchasePriceMeta));
    } else if (isInserting) {
      context.missing(_purchasePriceMeta);
    }
    if (data.containsKey('sale_price')) {
      context.handle(_salePriceMeta,
          salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta));
    } else if (isInserting) {
      context.missing(_salePriceMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('player_photo_ids')) {
      context.handle(
          _playerPhotoIdsMeta,
          playerPhotoIds.isAcceptableOrUnknown(
              data['player_photo_ids']!, _playerPhotoIdsMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameAccount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}game_id'])!,
      idCompte: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_compte'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_price'])!,
      salePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sale_price'])!,
      status: $GameAccountsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      playerPhotoIds: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}player_photo_ids'])!,
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $GameAccountsTable createAlias(String alias) {
    return $GameAccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameAccountStatus, int, int> $converterstatus =
      const EnumIndexConverter<GameAccountStatus>(GameAccountStatus.values);
}

class GameAccount extends DataClass implements Insertable<GameAccount> {
  final String id;
  final String ownerId;
  final String gameId;
  final String idCompte;
  final String name;
  final double purchasePrice;
  final double salePrice;
  final GameAccountStatus status;
  final String? notes;
  final String playerPhotoIds;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const GameAccount(
      {required this.id,
      required this.ownerId,
      required this.gameId,
      required this.idCompte,
      required this.name,
      required this.purchasePrice,
      required this.salePrice,
      required this.status,
      this.notes,
      required this.playerPhotoIds,
      this.photoPath,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['game_id'] = Variable<String>(gameId);
    map['id_compte'] = Variable<String>(idCompte);
    map['name'] = Variable<String>(name);
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['sale_price'] = Variable<double>(salePrice);
    {
      map['status'] =
          Variable<int>($GameAccountsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['player_photo_ids'] = Variable<String>(playerPhotoIds);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  GameAccountsCompanion toCompanion(bool nullToAbsent) {
    return GameAccountsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      gameId: Value(gameId),
      idCompte: Value(idCompte),
      name: Value(name),
      purchasePrice: Value(purchasePrice),
      salePrice: Value(salePrice),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      playerPhotoIds: Value(playerPhotoIds),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GameAccount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameAccount(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      gameId: serializer.fromJson<String>(json['gameId']),
      idCompte: serializer.fromJson<String>(json['idCompte']),
      name: serializer.fromJson<String>(json['name']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      salePrice: serializer.fromJson<double>(json['salePrice']),
      status: $GameAccountsTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      notes: serializer.fromJson<String?>(json['notes']),
      playerPhotoIds: serializer.fromJson<String>(json['playerPhotoIds']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'gameId': serializer.toJson<String>(gameId),
      'idCompte': serializer.toJson<String>(idCompte),
      'name': serializer.toJson<String>(name),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'salePrice': serializer.toJson<double>(salePrice),
      'status': serializer
          .toJson<int>($GameAccountsTable.$converterstatus.toJson(status)),
      'notes': serializer.toJson<String?>(notes),
      'playerPhotoIds': serializer.toJson<String>(playerPhotoIds),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  GameAccount copyWith(
          {String? id,
          String? ownerId,
          String? gameId,
          String? idCompte,
          String? name,
          double? purchasePrice,
          double? salePrice,
          GameAccountStatus? status,
          Value<String?> notes = const Value.absent(),
          String? playerPhotoIds,
          Value<String?> photoPath = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      GameAccount(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        gameId: gameId ?? this.gameId,
        idCompte: idCompte ?? this.idCompte,
        name: name ?? this.name,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        salePrice: salePrice ?? this.salePrice,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        playerPhotoIds: playerPhotoIds ?? this.playerPhotoIds,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  GameAccount copyWithCompanion(GameAccountsCompanion data) {
    return GameAccount(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      idCompte: data.idCompte.present ? data.idCompte.value : this.idCompte,
      name: data.name.present ? data.name.value : this.name,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      playerPhotoIds: data.playerPhotoIds.present
          ? data.playerPhotoIds.value
          : this.playerPhotoIds,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameAccount(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('gameId: $gameId, ')
          ..write('idCompte: $idCompte, ')
          ..write('name: $name, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('playerPhotoIds: $playerPhotoIds, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ownerId,
      gameId,
      idCompte,
      name,
      purchasePrice,
      salePrice,
      status,
      notes,
      playerPhotoIds,
      photoPath,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameAccount &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.gameId == this.gameId &&
          other.idCompte == this.idCompte &&
          other.name == this.name &&
          other.purchasePrice == this.purchasePrice &&
          other.salePrice == this.salePrice &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.playerPhotoIds == this.playerPhotoIds &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class GameAccountsCompanion extends UpdateCompanion<GameAccount> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> gameId;
  final Value<String> idCompte;
  final Value<String> name;
  final Value<double> purchasePrice;
  final Value<double> salePrice;
  final Value<GameAccountStatus> status;
  final Value<String?> notes;
  final Value<String> playerPhotoIds;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const GameAccountsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.idCompte = const Value.absent(),
    this.name = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.playerPhotoIds = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameAccountsCompanion.insert({
    required String id,
    required String ownerId,
    required String gameId,
    required String idCompte,
    required String name,
    required double purchasePrice,
    required double salePrice,
    required GameAccountStatus status,
    this.notes = const Value.absent(),
    this.playerPhotoIds = const Value.absent(),
    this.photoPath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        gameId = Value(gameId),
        idCompte = Value(idCompte),
        name = Value(name),
        purchasePrice = Value(purchasePrice),
        salePrice = Value(salePrice),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<GameAccount> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? gameId,
    Expression<String>? idCompte,
    Expression<String>? name,
    Expression<double>? purchasePrice,
    Expression<double>? salePrice,
    Expression<int>? status,
    Expression<String>? notes,
    Expression<String>? playerPhotoIds,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (gameId != null) 'game_id': gameId,
      if (idCompte != null) 'id_compte': idCompte,
      if (name != null) 'name': name,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (salePrice != null) 'sale_price': salePrice,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (playerPhotoIds != null) 'player_photo_ids': playerPhotoIds,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameAccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? gameId,
      Value<String>? idCompte,
      Value<String>? name,
      Value<double>? purchasePrice,
      Value<double>? salePrice,
      Value<GameAccountStatus>? status,
      Value<String?>? notes,
      Value<String>? playerPhotoIds,
      Value<String?>? photoPath,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return GameAccountsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      gameId: gameId ?? this.gameId,
      idCompte: idCompte ?? this.idCompte,
      name: name ?? this.name,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      playerPhotoIds: playerPhotoIds ?? this.playerPhotoIds,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (idCompte.present) {
      map['id_compte'] = Variable<String>(idCompte.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $GameAccountsTable.$converterstatus.toSql(status.value));
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (playerPhotoIds.present) {
      map['player_photo_ids'] = Variable<String>(playerPhotoIds.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameAccountsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('gameId: $gameId, ')
          ..write('idCompte: $idCompte, ')
          ..write('name: $name, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('playerPhotoIds: $playerPhotoIds, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayerPhotosTable extends PlayerPhotos
    with TableInfo<$PlayerPhotosTable, PlayerPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetPathMeta =
      const VerificationMeta('assetPath');
  @override
  late final GeneratedColumn<String> assetPath = GeneratedColumn<String>(
      'asset_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, assetPath, displayName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_photos';
  @override
  VerificationContext validateIntegrity(Insertable<PlayerPhoto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_path')) {
      context.handle(_assetPathMeta,
          assetPath.isAcceptableOrUnknown(data['asset_path']!, _assetPathMeta));
    } else if (isInserting) {
      context.missing(_assetPathMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerPhoto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      assetPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_path'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
    );
  }

  @override
  $PlayerPhotosTable createAlias(String alias) {
    return $PlayerPhotosTable(attachedDatabase, alias);
  }
}

class PlayerPhoto extends DataClass implements Insertable<PlayerPhoto> {
  final String id;
  final String assetPath;
  final String? displayName;
  const PlayerPhoto(
      {required this.id, required this.assetPath, this.displayName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_path'] = Variable<String>(assetPath);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    return map;
  }

  PlayerPhotosCompanion toCompanion(bool nullToAbsent) {
    return PlayerPhotosCompanion(
      id: Value(id),
      assetPath: Value(assetPath),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
    );
  }

  factory PlayerPhoto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerPhoto(
      id: serializer.fromJson<String>(json['id']),
      assetPath: serializer.fromJson<String>(json['assetPath']),
      displayName: serializer.fromJson<String?>(json['displayName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetPath': serializer.toJson<String>(assetPath),
      'displayName': serializer.toJson<String?>(displayName),
    };
  }

  PlayerPhoto copyWith(
          {String? id,
          String? assetPath,
          Value<String?> displayName = const Value.absent()}) =>
      PlayerPhoto(
        id: id ?? this.id,
        assetPath: assetPath ?? this.assetPath,
        displayName: displayName.present ? displayName.value : this.displayName,
      );
  PlayerPhoto copyWithCompanion(PlayerPhotosCompanion data) {
    return PlayerPhoto(
      id: data.id.present ? data.id.value : this.id,
      assetPath: data.assetPath.present ? data.assetPath.value : this.assetPath,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerPhoto(')
          ..write('id: $id, ')
          ..write('assetPath: $assetPath, ')
          ..write('displayName: $displayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assetPath, displayName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerPhoto &&
          other.id == this.id &&
          other.assetPath == this.assetPath &&
          other.displayName == this.displayName);
}

class PlayerPhotosCompanion extends UpdateCompanion<PlayerPhoto> {
  final Value<String> id;
  final Value<String> assetPath;
  final Value<String?> displayName;
  final Value<int> rowid;
  const PlayerPhotosCompanion({
    this.id = const Value.absent(),
    this.assetPath = const Value.absent(),
    this.displayName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayerPhotosCompanion.insert({
    required String id,
    required String assetPath,
    this.displayName = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        assetPath = Value(assetPath);
  static Insertable<PlayerPhoto> custom({
    Expression<String>? id,
    Expression<String>? assetPath,
    Expression<String>? displayName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetPath != null) 'asset_path': assetPath,
      if (displayName != null) 'display_name': displayName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayerPhotosCompanion copyWith(
      {Value<String>? id,
      Value<String>? assetPath,
      Value<String?>? displayName,
      Value<int>? rowid}) {
    return PlayerPhotosCompanion(
      id: id ?? this.id,
      assetPath: assetPath ?? this.assetPath,
      displayName: displayName ?? this.displayName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetPath.present) {
      map['asset_path'] = Variable<String>(assetPath.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerPhotosCompanion(')
          ..write('id: $id, ')
          ..write('assetPath: $assetPath, ')
          ..write('displayName: $displayName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogsTable extends ActivityLogs
    with TableInfo<$ActivityLogsTable, ActivityEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<ActivityType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ActivityType>($ActivityLogsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<ActivityAction, int> action =
      GeneratedColumn<int>('action', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ActivityAction>($ActivityLogsTable.$converteraction);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
      'detail', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ownerId, type, action, title, detail, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ActivityEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(_detailMeta,
          detail.isAcceptableOrUnknown(data['detail']!, _detailMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      type: $ActivityLogsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      action: $ActivityLogsTable.$converteraction.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}action'])!),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      detail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}detail']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ActivityLogsTable createAlias(String alias) {
    return $ActivityLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActivityType, int, int> $convertertype =
      const EnumIndexConverter<ActivityType>(ActivityType.values);
  static JsonTypeConverter2<ActivityAction, int, int> $converteraction =
      const EnumIndexConverter<ActivityAction>(ActivityAction.values);
}

class ActivityEntry extends DataClass implements Insertable<ActivityEntry> {
  final String id;
  final String ownerId;
  final ActivityType type;
  final ActivityAction action;
  final String title;
  final String? detail;
  final DateTime createdAt;
  const ActivityEntry(
      {required this.id,
      required this.ownerId,
      required this.type,
      required this.action,
      required this.title,
      this.detail,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    {
      map['type'] =
          Variable<int>($ActivityLogsTable.$convertertype.toSql(type));
    }
    {
      map['action'] =
          Variable<int>($ActivityLogsTable.$converteraction.toSql(action));
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivityLogsCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      type: Value(type),
      action: Value(action),
      title: Value(title),
      detail:
          detail == null && nullToAbsent ? const Value.absent() : Value(detail),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityEntry(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      type: $ActivityLogsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      action: $ActivityLogsTable.$converteraction
          .fromJson(serializer.fromJson<int>(json['action'])),
      title: serializer.fromJson<String>(json['title']),
      detail: serializer.fromJson<String?>(json['detail']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'type': serializer
          .toJson<int>($ActivityLogsTable.$convertertype.toJson(type)),
      'action': serializer
          .toJson<int>($ActivityLogsTable.$converteraction.toJson(action)),
      'title': serializer.toJson<String>(title),
      'detail': serializer.toJson<String?>(detail),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivityEntry copyWith(
          {String? id,
          String? ownerId,
          ActivityType? type,
          ActivityAction? action,
          String? title,
          Value<String?> detail = const Value.absent(),
          DateTime? createdAt}) =>
      ActivityEntry(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        type: type ?? this.type,
        action: action ?? this.action,
        title: title ?? this.title,
        detail: detail.present ? detail.value : this.detail,
        createdAt: createdAt ?? this.createdAt,
      );
  ActivityEntry copyWithCompanion(ActivityLogsCompanion data) {
    return ActivityEntry(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      type: data.type.present ? data.type.value : this.type,
      action: data.action.present ? data.action.value : this.action,
      title: data.title.present ? data.title.value : this.title,
      detail: data.detail.present ? data.detail.value : this.detail,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEntry(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('type: $type, ')
          ..write('action: $action, ')
          ..write('title: $title, ')
          ..write('detail: $detail, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerId, type, action, title, detail, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityEntry &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.type == this.type &&
          other.action == this.action &&
          other.title == this.title &&
          other.detail == this.detail &&
          other.createdAt == this.createdAt);
}

class ActivityLogsCompanion extends UpdateCompanion<ActivityEntry> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<ActivityType> type;
  final Value<ActivityAction> action;
  final Value<String> title;
  final Value<String?> detail;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ActivityLogsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.type = const Value.absent(),
    this.action = const Value.absent(),
    this.title = const Value.absent(),
    this.detail = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLogsCompanion.insert({
    required String id,
    required String ownerId,
    required ActivityType type,
    required ActivityAction action,
    required String title,
    this.detail = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        type = Value(type),
        action = Value(action),
        title = Value(title),
        createdAt = Value(createdAt);
  static Insertable<ActivityEntry> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<int>? type,
    Expression<int>? action,
    Expression<String>? title,
    Expression<String>? detail,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (type != null) 'type': type,
      if (action != null) 'action': action,
      if (title != null) 'title': title,
      if (detail != null) 'detail': detail,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<ActivityType>? type,
      Value<ActivityAction>? action,
      Value<String>? title,
      Value<String?>? detail,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ActivityLogsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      type: type ?? this.type,
      action: action ?? this.action,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($ActivityLogsTable.$convertertype.toSql(type.value));
    }
    if (action.present) {
      map['action'] = Variable<int>(
          $ActivityLogsTable.$converteraction.toSql(action.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('type: $type, ')
          ..write('action: $action, ')
          ..write('title: $title, ')
          ..write('detail: $detail, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $GoogleAccountsTable googleAccounts = $GoogleAccountsTable(this);
  late final $GoogleGameBoxesTable googleGameBoxes =
      $GoogleGameBoxesTable(this);
  late final $GameAccountsTable gameAccounts = $GameAccountsTable(this);
  late final $PlayerPhotosTable playerPhotos = $PlayerPhotosTable(this);
  late final $ActivityLogsTable activityLogs = $ActivityLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        games,
        googleAccounts,
        googleGameBoxes,
        gameAccounts,
        playerPhotos,
        activityLogs
      ];
}

typedef $$GamesTableCreateCompanionBuilder = GamesCompanion Function({
  required String id,
  required String ownerId,
  required String name,
  Value<String?> logoAssetPath,
  Value<String?> accountImagePath,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});
typedef $$GamesTableUpdateCompanionBuilder = GamesCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> name,
  Value<String?> logoAssetPath,
  Value<String?> accountImagePath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoAssetPath => $composableBuilder(
      column: $table.logoAssetPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountImagePath => $composableBuilder(
      column: $table.accountImagePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnFilters(column));
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoAssetPath => $composableBuilder(
      column: $table.logoAssetPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountImagePath => $composableBuilder(
      column: $table.accountImagePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnOrderings(column));
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get logoAssetPath => $composableBuilder(
      column: $table.logoAssetPath, builder: (column) => column);

  GeneratedColumn<String> get accountImagePath => $composableBuilder(
      column: $table.accountImagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => column);
}

class $$GamesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GamesTable,
    Game,
    $$GamesTableFilterComposer,
    $$GamesTableOrderingComposer,
    $$GamesTableAnnotationComposer,
    $$GamesTableCreateCompanionBuilder,
    $$GamesTableUpdateCompanionBuilder,
    (Game, BaseReferences<_$AppDatabase, $GamesTable, Game>),
    Game,
    PrefetchHooks Function()> {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> logoAssetPath = const Value.absent(),
            Value<String?> accountImagePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GamesCompanion(
            id: id,
            ownerId: ownerId,
            name: name,
            logoAssetPath: logoAssetPath,
            accountImagePath: accountImagePath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            archivedAt: archivedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String name,
            Value<String?> logoAssetPath = const Value.absent(),
            Value<String?> accountImagePath = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GamesCompanion.insert(
            id: id,
            ownerId: ownerId,
            name: name,
            logoAssetPath: logoAssetPath,
            accountImagePath: accountImagePath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            archivedAt: archivedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GamesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GamesTable,
    Game,
    $$GamesTableFilterComposer,
    $$GamesTableOrderingComposer,
    $$GamesTableAnnotationComposer,
    $$GamesTableCreateCompanionBuilder,
    $$GamesTableUpdateCompanionBuilder,
    (Game, BaseReferences<_$AppDatabase, $GamesTable, Game>),
    Game,
    PrefetchHooks Function()>;
typedef $$GoogleAccountsTableCreateCompanionBuilder = GoogleAccountsCompanion
    Function({
  required String id,
  required String ownerId,
  required String email,
  required Grade grade,
  Value<bool> favorite,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$GoogleAccountsTableUpdateCompanionBuilder = GoogleAccountsCompanion
    Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> email,
  Value<Grade> grade,
  Value<bool> favorite,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$GoogleAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $GoogleAccountsTable> {
  $$GoogleAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Grade, Grade, int> get grade =>
      $composableBuilder(
          column: $table.grade,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$GoogleAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoogleAccountsTable> {
  $$GoogleAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$GoogleAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoogleAccountsTable> {
  $$GoogleAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Grade, int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$GoogleAccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoogleAccountsTable,
    GoogleAccount,
    $$GoogleAccountsTableFilterComposer,
    $$GoogleAccountsTableOrderingComposer,
    $$GoogleAccountsTableAnnotationComposer,
    $$GoogleAccountsTableCreateCompanionBuilder,
    $$GoogleAccountsTableUpdateCompanionBuilder,
    (
      GoogleAccount,
      BaseReferences<_$AppDatabase, $GoogleAccountsTable, GoogleAccount>
    ),
    GoogleAccount,
    PrefetchHooks Function()> {
  $$GoogleAccountsTableTableManager(
      _$AppDatabase db, $GoogleAccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoogleAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoogleAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoogleAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<Grade> grade = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoogleAccountsCompanion(
            id: id,
            ownerId: ownerId,
            email: email,
            grade: grade,
            favorite: favorite,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String email,
            required Grade grade,
            Value<bool> favorite = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoogleAccountsCompanion.insert(
            id: id,
            ownerId: ownerId,
            email: email,
            grade: grade,
            favorite: favorite,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoogleAccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoogleAccountsTable,
    GoogleAccount,
    $$GoogleAccountsTableFilterComposer,
    $$GoogleAccountsTableOrderingComposer,
    $$GoogleAccountsTableAnnotationComposer,
    $$GoogleAccountsTableCreateCompanionBuilder,
    $$GoogleAccountsTableUpdateCompanionBuilder,
    (
      GoogleAccount,
      BaseReferences<_$AppDatabase, $GoogleAccountsTable, GoogleAccount>
    ),
    GoogleAccount,
    PrefetchHooks Function()>;
typedef $$GoogleGameBoxesTableCreateCompanionBuilder = GoogleGameBoxesCompanion
    Function({
  required String id,
  required String googleAccountId,
  required String gameId,
  Value<BoxStatus> status,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$GoogleGameBoxesTableUpdateCompanionBuilder = GoogleGameBoxesCompanion
    Function({
  Value<String> id,
  Value<String> googleAccountId,
  Value<String> gameId,
  Value<BoxStatus> status,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$GoogleGameBoxesTableFilterComposer
    extends Composer<_$AppDatabase, $GoogleGameBoxesTable> {
  $$GoogleGameBoxesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get googleAccountId => $composableBuilder(
      column: $table.googleAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<BoxStatus, BoxStatus, int> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$GoogleGameBoxesTableOrderingComposer
    extends Composer<_$AppDatabase, $GoogleGameBoxesTable> {
  $$GoogleGameBoxesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get googleAccountId => $composableBuilder(
      column: $table.googleAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$GoogleGameBoxesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoogleGameBoxesTable> {
  $$GoogleGameBoxesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get googleAccountId => $composableBuilder(
      column: $table.googleAccountId, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BoxStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GoogleGameBoxesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoogleGameBoxesTable,
    GoogleGameBox,
    $$GoogleGameBoxesTableFilterComposer,
    $$GoogleGameBoxesTableOrderingComposer,
    $$GoogleGameBoxesTableAnnotationComposer,
    $$GoogleGameBoxesTableCreateCompanionBuilder,
    $$GoogleGameBoxesTableUpdateCompanionBuilder,
    (
      GoogleGameBox,
      BaseReferences<_$AppDatabase, $GoogleGameBoxesTable, GoogleGameBox>
    ),
    GoogleGameBox,
    PrefetchHooks Function()> {
  $$GoogleGameBoxesTableTableManager(
      _$AppDatabase db, $GoogleGameBoxesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoogleGameBoxesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoogleGameBoxesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoogleGameBoxesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> googleAccountId = const Value.absent(),
            Value<String> gameId = const Value.absent(),
            Value<BoxStatus> status = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoogleGameBoxesCompanion(
            id: id,
            googleAccountId: googleAccountId,
            gameId: gameId,
            status: status,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String googleAccountId,
            required String gameId,
            Value<BoxStatus> status = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GoogleGameBoxesCompanion.insert(
            id: id,
            googleAccountId: googleAccountId,
            gameId: gameId,
            status: status,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoogleGameBoxesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoogleGameBoxesTable,
    GoogleGameBox,
    $$GoogleGameBoxesTableFilterComposer,
    $$GoogleGameBoxesTableOrderingComposer,
    $$GoogleGameBoxesTableAnnotationComposer,
    $$GoogleGameBoxesTableCreateCompanionBuilder,
    $$GoogleGameBoxesTableUpdateCompanionBuilder,
    (
      GoogleGameBox,
      BaseReferences<_$AppDatabase, $GoogleGameBoxesTable, GoogleGameBox>
    ),
    GoogleGameBox,
    PrefetchHooks Function()>;
typedef $$GameAccountsTableCreateCompanionBuilder = GameAccountsCompanion
    Function({
  required String id,
  required String ownerId,
  required String gameId,
  required String idCompte,
  required String name,
  required double purchasePrice,
  required double salePrice,
  required GameAccountStatus status,
  Value<String?> notes,
  Value<String> playerPhotoIds,
  Value<String?> photoPath,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$GameAccountsTableUpdateCompanionBuilder = GameAccountsCompanion
    Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> gameId,
  Value<String> idCompte,
  Value<String> name,
  Value<double> purchasePrice,
  Value<double> salePrice,
  Value<GameAccountStatus> status,
  Value<String?> notes,
  Value<String> playerPhotoIds,
  Value<String?> photoPath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$GameAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $GameAccountsTable> {
  $$GameAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idCompte => $composableBuilder(
      column: $table.idCompte, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<GameAccountStatus, GameAccountStatus, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playerPhotoIds => $composableBuilder(
      column: $table.playerPhotoIds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$GameAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $GameAccountsTable> {
  $$GameAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idCompte => $composableBuilder(
      column: $table.idCompte, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playerPhotoIds => $composableBuilder(
      column: $table.playerPhotoIds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$GameAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameAccountsTable> {
  $$GameAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get idCompte =>
      $composableBuilder(column: $table.idCompte, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => column);

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GameAccountStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get playerPhotoIds => $composableBuilder(
      column: $table.playerPhotoIds, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$GameAccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GameAccountsTable,
    GameAccount,
    $$GameAccountsTableFilterComposer,
    $$GameAccountsTableOrderingComposer,
    $$GameAccountsTableAnnotationComposer,
    $$GameAccountsTableCreateCompanionBuilder,
    $$GameAccountsTableUpdateCompanionBuilder,
    (
      GameAccount,
      BaseReferences<_$AppDatabase, $GameAccountsTable, GameAccount>
    ),
    GameAccount,
    PrefetchHooks Function()> {
  $$GameAccountsTableTableManager(_$AppDatabase db, $GameAccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> gameId = const Value.absent(),
            Value<String> idCompte = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> purchasePrice = const Value.absent(),
            Value<double> salePrice = const Value.absent(),
            Value<GameAccountStatus> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> playerPhotoIds = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GameAccountsCompanion(
            id: id,
            ownerId: ownerId,
            gameId: gameId,
            idCompte: idCompte,
            name: name,
            purchasePrice: purchasePrice,
            salePrice: salePrice,
            status: status,
            notes: notes,
            playerPhotoIds: playerPhotoIds,
            photoPath: photoPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String gameId,
            required String idCompte,
            required String name,
            required double purchasePrice,
            required double salePrice,
            required GameAccountStatus status,
            Value<String?> notes = const Value.absent(),
            Value<String> playerPhotoIds = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GameAccountsCompanion.insert(
            id: id,
            ownerId: ownerId,
            gameId: gameId,
            idCompte: idCompte,
            name: name,
            purchasePrice: purchasePrice,
            salePrice: salePrice,
            status: status,
            notes: notes,
            playerPhotoIds: playerPhotoIds,
            photoPath: photoPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GameAccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GameAccountsTable,
    GameAccount,
    $$GameAccountsTableFilterComposer,
    $$GameAccountsTableOrderingComposer,
    $$GameAccountsTableAnnotationComposer,
    $$GameAccountsTableCreateCompanionBuilder,
    $$GameAccountsTableUpdateCompanionBuilder,
    (
      GameAccount,
      BaseReferences<_$AppDatabase, $GameAccountsTable, GameAccount>
    ),
    GameAccount,
    PrefetchHooks Function()>;
typedef $$PlayerPhotosTableCreateCompanionBuilder = PlayerPhotosCompanion
    Function({
  required String id,
  required String assetPath,
  Value<String?> displayName,
  Value<int> rowid,
});
typedef $$PlayerPhotosTableUpdateCompanionBuilder = PlayerPhotosCompanion
    Function({
  Value<String> id,
  Value<String> assetPath,
  Value<String?> displayName,
  Value<int> rowid,
});

class $$PlayerPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerPhotosTable> {
  $$PlayerPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetPath => $composableBuilder(
      column: $table.assetPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));
}

class $$PlayerPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerPhotosTable> {
  $$PlayerPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetPath => $composableBuilder(
      column: $table.assetPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));
}

class $$PlayerPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerPhotosTable> {
  $$PlayerPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assetPath =>
      $composableBuilder(column: $table.assetPath, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);
}

class $$PlayerPhotosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlayerPhotosTable,
    PlayerPhoto,
    $$PlayerPhotosTableFilterComposer,
    $$PlayerPhotosTableOrderingComposer,
    $$PlayerPhotosTableAnnotationComposer,
    $$PlayerPhotosTableCreateCompanionBuilder,
    $$PlayerPhotosTableUpdateCompanionBuilder,
    (
      PlayerPhoto,
      BaseReferences<_$AppDatabase, $PlayerPhotosTable, PlayerPhoto>
    ),
    PlayerPhoto,
    PrefetchHooks Function()> {
  $$PlayerPhotosTableTableManager(_$AppDatabase db, $PlayerPhotosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> assetPath = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlayerPhotosCompanion(
            id: id,
            assetPath: assetPath,
            displayName: displayName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String assetPath,
            Value<String?> displayName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlayerPhotosCompanion.insert(
            id: id,
            assetPath: assetPath,
            displayName: displayName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlayerPhotosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlayerPhotosTable,
    PlayerPhoto,
    $$PlayerPhotosTableFilterComposer,
    $$PlayerPhotosTableOrderingComposer,
    $$PlayerPhotosTableAnnotationComposer,
    $$PlayerPhotosTableCreateCompanionBuilder,
    $$PlayerPhotosTableUpdateCompanionBuilder,
    (
      PlayerPhoto,
      BaseReferences<_$AppDatabase, $PlayerPhotosTable, PlayerPhoto>
    ),
    PlayerPhoto,
    PrefetchHooks Function()>;
typedef $$ActivityLogsTableCreateCompanionBuilder = ActivityLogsCompanion
    Function({
  required String id,
  required String ownerId,
  required ActivityType type,
  required ActivityAction action,
  required String title,
  Value<String?> detail,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ActivityLogsTableUpdateCompanionBuilder = ActivityLogsCompanion
    Function({
  Value<String> id,
  Value<String> ownerId,
  Value<ActivityType> type,
  Value<ActivityAction> action,
  Value<String> title,
  Value<String?> detail,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ActivityLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ActivityType, ActivityType, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<ActivityAction, ActivityAction, int>
      get action => $composableBuilder(
          column: $table.action,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detail => $composableBuilder(
      column: $table.detail, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ActivityLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detail => $composableBuilder(
      column: $table.detail, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ActivityLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityAction, int> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ActivityLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ActivityLogsTable,
    ActivityEntry,
    $$ActivityLogsTableFilterComposer,
    $$ActivityLogsTableOrderingComposer,
    $$ActivityLogsTableAnnotationComposer,
    $$ActivityLogsTableCreateCompanionBuilder,
    $$ActivityLogsTableUpdateCompanionBuilder,
    (
      ActivityEntry,
      BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityEntry>
    ),
    ActivityEntry,
    PrefetchHooks Function()> {
  $$ActivityLogsTableTableManager(_$AppDatabase db, $ActivityLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<ActivityType> type = const Value.absent(),
            Value<ActivityAction> action = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> detail = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityLogsCompanion(
            id: id,
            ownerId: ownerId,
            type: type,
            action: action,
            title: title,
            detail: detail,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required ActivityType type,
            required ActivityAction action,
            required String title,
            Value<String?> detail = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityLogsCompanion.insert(
            id: id,
            ownerId: ownerId,
            type: type,
            action: action,
            title: title,
            detail: detail,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActivityLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ActivityLogsTable,
    ActivityEntry,
    $$ActivityLogsTableFilterComposer,
    $$ActivityLogsTableOrderingComposer,
    $$ActivityLogsTableAnnotationComposer,
    $$ActivityLogsTableCreateCompanionBuilder,
    $$ActivityLogsTableUpdateCompanionBuilder,
    (
      ActivityEntry,
      BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityEntry>
    ),
    ActivityEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$GoogleAccountsTableTableManager get googleAccounts =>
      $$GoogleAccountsTableTableManager(_db, _db.googleAccounts);
  $$GoogleGameBoxesTableTableManager get googleGameBoxes =>
      $$GoogleGameBoxesTableTableManager(_db, _db.googleGameBoxes);
  $$GameAccountsTableTableManager get gameAccounts =>
      $$GameAccountsTableTableManager(_db, _db.gameAccounts);
  $$PlayerPhotosTableTableManager get playerPhotos =>
      $$PlayerPhotosTableTableManager(_db, _db.playerPhotos);
  $$ActivityLogsTableTableManager get activityLogs =>
      $$ActivityLogsTableTableManager(_db, _db.activityLogs);
}
