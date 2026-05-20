// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PrizeItemsTable extends PrizeItems
    with TableInfo<$PrizeItemsTable, PrizeItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrizeItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workTitleMeta = const VerificationMeta(
    'workTitle',
  );
  @override
  late final GeneratedColumn<String> workTitle = GeneratedColumn<String>(
    'work_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _characterNameMeta = const VerificationMeta(
    'characterName',
  );
  @override
  late final GeneratedColumn<String> characterName = GeneratedColumn<String>(
    'character_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seriesNameMeta = const VerificationMeta(
    'seriesName',
  );
  @override
  late final GeneratedColumn<String> seriesName = GeneratedColumn<String>(
    'series_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _makerMeta = const VerificationMeta('maker');
  @override
  late final GeneratedColumn<String> maker = GeneratedColumn<String>(
    'maker',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releaseTextMeta = const VerificationMeta(
    'releaseText',
  );
  @override
  late final GeneratedColumn<String> releaseText = GeneratedColumn<String>(
    'release_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releaseYearMeta = const VerificationMeta(
    'releaseYear',
  );
  @override
  late final GeneratedColumn<int> releaseYear = GeneratedColumn<int>(
    'release_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseMonthMeta = const VerificationMeta(
    'releaseMonth',
  );
  @override
  late final GeneratedColumn<int> releaseMonth = GeneratedColumn<int>(
    'release_month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(PrizeStatus.unowned),
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _acquiredAtEpochMsMeta = const VerificationMeta(
    'acquiredAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> acquiredAtEpochMs = GeneratedColumn<int>(
    'acquired_at_epoch_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtEpochMsMeta = const VerificationMeta(
    'createdAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> createdAtEpochMs = GeneratedColumn<int>(
    'created_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtEpochMsMeta = const VerificationMeta(
    'updatedAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtEpochMs = GeneratedColumn<int>(
    'updated_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    workTitle,
    characterName,
    seriesName,
    maker,
    releaseText,
    releaseYear,
    releaseMonth,
    sourceUrl,
    imageUrl,
    status,
    memo,
    acquiredAtEpochMs,
    createdAtEpochMs,
    updatedAtEpochMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prize_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrizeItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('work_title')) {
      context.handle(
        _workTitleMeta,
        workTitle.isAcceptableOrUnknown(data['work_title']!, _workTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_workTitleMeta);
    }
    if (data.containsKey('character_name')) {
      context.handle(
        _characterNameMeta,
        characterName.isAcceptableOrUnknown(
          data['character_name']!,
          _characterNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterNameMeta);
    }
    if (data.containsKey('series_name')) {
      context.handle(
        _seriesNameMeta,
        seriesName.isAcceptableOrUnknown(data['series_name']!, _seriesNameMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesNameMeta);
    }
    if (data.containsKey('maker')) {
      context.handle(
        _makerMeta,
        maker.isAcceptableOrUnknown(data['maker']!, _makerMeta),
      );
    } else if (isInserting) {
      context.missing(_makerMeta);
    }
    if (data.containsKey('release_text')) {
      context.handle(
        _releaseTextMeta,
        releaseText.isAcceptableOrUnknown(
          data['release_text']!,
          _releaseTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_releaseTextMeta);
    }
    if (data.containsKey('release_year')) {
      context.handle(
        _releaseYearMeta,
        releaseYear.isAcceptableOrUnknown(
          data['release_year']!,
          _releaseYearMeta,
        ),
      );
    }
    if (data.containsKey('release_month')) {
      context.handle(
        _releaseMonthMeta,
        releaseMonth.isAcceptableOrUnknown(
          data['release_month']!,
          _releaseMonthMeta,
        ),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('acquired_at_epoch_ms')) {
      context.handle(
        _acquiredAtEpochMsMeta,
        acquiredAtEpochMs.isAcceptableOrUnknown(
          data['acquired_at_epoch_ms']!,
          _acquiredAtEpochMsMeta,
        ),
      );
    }
    if (data.containsKey('created_at_epoch_ms')) {
      context.handle(
        _createdAtEpochMsMeta,
        createdAtEpochMs.isAcceptableOrUnknown(
          data['created_at_epoch_ms']!,
          _createdAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtEpochMsMeta);
    }
    if (data.containsKey('updated_at_epoch_ms')) {
      context.handle(
        _updatedAtEpochMsMeta,
        updatedAtEpochMs.isAcceptableOrUnknown(
          data['updated_at_epoch_ms']!,
          _updatedAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtEpochMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrizeItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrizeItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      workTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_title'],
      )!,
      characterName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_name'],
      )!,
      seriesName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_name'],
      )!,
      maker: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}maker'],
      )!,
      releaseText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}release_text'],
      )!,
      releaseYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}release_year'],
      ),
      releaseMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}release_month'],
      ),
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      acquiredAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}acquired_at_epoch_ms'],
      ),
      createdAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_epoch_ms'],
      )!,
      updatedAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_epoch_ms'],
      )!,
    );
  }

  @override
  $PrizeItemsTable createAlias(String alias) {
    return $PrizeItemsTable(attachedDatabase, alias);
  }
}

class PrizeItem extends DataClass implements Insertable<PrizeItem> {
  final int id;
  final String title;
  final String workTitle;
  final String characterName;
  final String seriesName;
  final String maker;
  final String releaseText;
  final int? releaseYear;
  final int? releaseMonth;
  final String? sourceUrl;
  final String? imageUrl;
  final String status;
  final String? memo;
  final int? acquiredAtEpochMs;
  final int createdAtEpochMs;
  final int updatedAtEpochMs;
  const PrizeItem({
    required this.id,
    required this.title,
    required this.workTitle,
    required this.characterName,
    required this.seriesName,
    required this.maker,
    required this.releaseText,
    this.releaseYear,
    this.releaseMonth,
    this.sourceUrl,
    this.imageUrl,
    required this.status,
    this.memo,
    this.acquiredAtEpochMs,
    required this.createdAtEpochMs,
    required this.updatedAtEpochMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['work_title'] = Variable<String>(workTitle);
    map['character_name'] = Variable<String>(characterName);
    map['series_name'] = Variable<String>(seriesName);
    map['maker'] = Variable<String>(maker);
    map['release_text'] = Variable<String>(releaseText);
    if (!nullToAbsent || releaseYear != null) {
      map['release_year'] = Variable<int>(releaseYear);
    }
    if (!nullToAbsent || releaseMonth != null) {
      map['release_month'] = Variable<int>(releaseMonth);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || acquiredAtEpochMs != null) {
      map['acquired_at_epoch_ms'] = Variable<int>(acquiredAtEpochMs);
    }
    map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs);
    map['updated_at_epoch_ms'] = Variable<int>(updatedAtEpochMs);
    return map;
  }

  PrizeItemsCompanion toCompanion(bool nullToAbsent) {
    return PrizeItemsCompanion(
      id: Value(id),
      title: Value(title),
      workTitle: Value(workTitle),
      characterName: Value(characterName),
      seriesName: Value(seriesName),
      maker: Value(maker),
      releaseText: Value(releaseText),
      releaseYear: releaseYear == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseYear),
      releaseMonth: releaseMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseMonth),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      status: Value(status),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      acquiredAtEpochMs: acquiredAtEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(acquiredAtEpochMs),
      createdAtEpochMs: Value(createdAtEpochMs),
      updatedAtEpochMs: Value(updatedAtEpochMs),
    );
  }

  factory PrizeItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrizeItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      workTitle: serializer.fromJson<String>(json['workTitle']),
      characterName: serializer.fromJson<String>(json['characterName']),
      seriesName: serializer.fromJson<String>(json['seriesName']),
      maker: serializer.fromJson<String>(json['maker']),
      releaseText: serializer.fromJson<String>(json['releaseText']),
      releaseYear: serializer.fromJson<int?>(json['releaseYear']),
      releaseMonth: serializer.fromJson<int?>(json['releaseMonth']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      status: serializer.fromJson<String>(json['status']),
      memo: serializer.fromJson<String?>(json['memo']),
      acquiredAtEpochMs: serializer.fromJson<int?>(json['acquiredAtEpochMs']),
      createdAtEpochMs: serializer.fromJson<int>(json['createdAtEpochMs']),
      updatedAtEpochMs: serializer.fromJson<int>(json['updatedAtEpochMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'workTitle': serializer.toJson<String>(workTitle),
      'characterName': serializer.toJson<String>(characterName),
      'seriesName': serializer.toJson<String>(seriesName),
      'maker': serializer.toJson<String>(maker),
      'releaseText': serializer.toJson<String>(releaseText),
      'releaseYear': serializer.toJson<int?>(releaseYear),
      'releaseMonth': serializer.toJson<int?>(releaseMonth),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'status': serializer.toJson<String>(status),
      'memo': serializer.toJson<String?>(memo),
      'acquiredAtEpochMs': serializer.toJson<int?>(acquiredAtEpochMs),
      'createdAtEpochMs': serializer.toJson<int>(createdAtEpochMs),
      'updatedAtEpochMs': serializer.toJson<int>(updatedAtEpochMs),
    };
  }

  PrizeItem copyWith({
    int? id,
    String? title,
    String? workTitle,
    String? characterName,
    String? seriesName,
    String? maker,
    String? releaseText,
    Value<int?> releaseYear = const Value.absent(),
    Value<int?> releaseMonth = const Value.absent(),
    Value<String?> sourceUrl = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    String? status,
    Value<String?> memo = const Value.absent(),
    Value<int?> acquiredAtEpochMs = const Value.absent(),
    int? createdAtEpochMs,
    int? updatedAtEpochMs,
  }) => PrizeItem(
    id: id ?? this.id,
    title: title ?? this.title,
    workTitle: workTitle ?? this.workTitle,
    characterName: characterName ?? this.characterName,
    seriesName: seriesName ?? this.seriesName,
    maker: maker ?? this.maker,
    releaseText: releaseText ?? this.releaseText,
    releaseYear: releaseYear.present ? releaseYear.value : this.releaseYear,
    releaseMonth: releaseMonth.present ? releaseMonth.value : this.releaseMonth,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    status: status ?? this.status,
    memo: memo.present ? memo.value : this.memo,
    acquiredAtEpochMs: acquiredAtEpochMs.present
        ? acquiredAtEpochMs.value
        : this.acquiredAtEpochMs,
    createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
    updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
  );
  PrizeItem copyWithCompanion(PrizeItemsCompanion data) {
    return PrizeItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      workTitle: data.workTitle.present ? data.workTitle.value : this.workTitle,
      characterName: data.characterName.present
          ? data.characterName.value
          : this.characterName,
      seriesName: data.seriesName.present
          ? data.seriesName.value
          : this.seriesName,
      maker: data.maker.present ? data.maker.value : this.maker,
      releaseText: data.releaseText.present
          ? data.releaseText.value
          : this.releaseText,
      releaseYear: data.releaseYear.present
          ? data.releaseYear.value
          : this.releaseYear,
      releaseMonth: data.releaseMonth.present
          ? data.releaseMonth.value
          : this.releaseMonth,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      status: data.status.present ? data.status.value : this.status,
      memo: data.memo.present ? data.memo.value : this.memo,
      acquiredAtEpochMs: data.acquiredAtEpochMs.present
          ? data.acquiredAtEpochMs.value
          : this.acquiredAtEpochMs,
      createdAtEpochMs: data.createdAtEpochMs.present
          ? data.createdAtEpochMs.value
          : this.createdAtEpochMs,
      updatedAtEpochMs: data.updatedAtEpochMs.present
          ? data.updatedAtEpochMs.value
          : this.updatedAtEpochMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrizeItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('workTitle: $workTitle, ')
          ..write('characterName: $characterName, ')
          ..write('seriesName: $seriesName, ')
          ..write('maker: $maker, ')
          ..write('releaseText: $releaseText, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('releaseMonth: $releaseMonth, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('status: $status, ')
          ..write('memo: $memo, ')
          ..write('acquiredAtEpochMs: $acquiredAtEpochMs, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('updatedAtEpochMs: $updatedAtEpochMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    workTitle,
    characterName,
    seriesName,
    maker,
    releaseText,
    releaseYear,
    releaseMonth,
    sourceUrl,
    imageUrl,
    status,
    memo,
    acquiredAtEpochMs,
    createdAtEpochMs,
    updatedAtEpochMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrizeItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.workTitle == this.workTitle &&
          other.characterName == this.characterName &&
          other.seriesName == this.seriesName &&
          other.maker == this.maker &&
          other.releaseText == this.releaseText &&
          other.releaseYear == this.releaseYear &&
          other.releaseMonth == this.releaseMonth &&
          other.sourceUrl == this.sourceUrl &&
          other.imageUrl == this.imageUrl &&
          other.status == this.status &&
          other.memo == this.memo &&
          other.acquiredAtEpochMs == this.acquiredAtEpochMs &&
          other.createdAtEpochMs == this.createdAtEpochMs &&
          other.updatedAtEpochMs == this.updatedAtEpochMs);
}

class PrizeItemsCompanion extends UpdateCompanion<PrizeItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> workTitle;
  final Value<String> characterName;
  final Value<String> seriesName;
  final Value<String> maker;
  final Value<String> releaseText;
  final Value<int?> releaseYear;
  final Value<int?> releaseMonth;
  final Value<String?> sourceUrl;
  final Value<String?> imageUrl;
  final Value<String> status;
  final Value<String?> memo;
  final Value<int?> acquiredAtEpochMs;
  final Value<int> createdAtEpochMs;
  final Value<int> updatedAtEpochMs;
  const PrizeItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.workTitle = const Value.absent(),
    this.characterName = const Value.absent(),
    this.seriesName = const Value.absent(),
    this.maker = const Value.absent(),
    this.releaseText = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.releaseMonth = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.memo = const Value.absent(),
    this.acquiredAtEpochMs = const Value.absent(),
    this.createdAtEpochMs = const Value.absent(),
    this.updatedAtEpochMs = const Value.absent(),
  });
  PrizeItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String workTitle,
    required String characterName,
    required String seriesName,
    required String maker,
    required String releaseText,
    this.releaseYear = const Value.absent(),
    this.releaseMonth = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.memo = const Value.absent(),
    this.acquiredAtEpochMs = const Value.absent(),
    required int createdAtEpochMs,
    required int updatedAtEpochMs,
  }) : title = Value(title),
       workTitle = Value(workTitle),
       characterName = Value(characterName),
       seriesName = Value(seriesName),
       maker = Value(maker),
       releaseText = Value(releaseText),
       createdAtEpochMs = Value(createdAtEpochMs),
       updatedAtEpochMs = Value(updatedAtEpochMs);
  static Insertable<PrizeItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? workTitle,
    Expression<String>? characterName,
    Expression<String>? seriesName,
    Expression<String>? maker,
    Expression<String>? releaseText,
    Expression<int>? releaseYear,
    Expression<int>? releaseMonth,
    Expression<String>? sourceUrl,
    Expression<String>? imageUrl,
    Expression<String>? status,
    Expression<String>? memo,
    Expression<int>? acquiredAtEpochMs,
    Expression<int>? createdAtEpochMs,
    Expression<int>? updatedAtEpochMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (workTitle != null) 'work_title': workTitle,
      if (characterName != null) 'character_name': characterName,
      if (seriesName != null) 'series_name': seriesName,
      if (maker != null) 'maker': maker,
      if (releaseText != null) 'release_text': releaseText,
      if (releaseYear != null) 'release_year': releaseYear,
      if (releaseMonth != null) 'release_month': releaseMonth,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (imageUrl != null) 'image_url': imageUrl,
      if (status != null) 'status': status,
      if (memo != null) 'memo': memo,
      if (acquiredAtEpochMs != null) 'acquired_at_epoch_ms': acquiredAtEpochMs,
      if (createdAtEpochMs != null) 'created_at_epoch_ms': createdAtEpochMs,
      if (updatedAtEpochMs != null) 'updated_at_epoch_ms': updatedAtEpochMs,
    });
  }

  PrizeItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? workTitle,
    Value<String>? characterName,
    Value<String>? seriesName,
    Value<String>? maker,
    Value<String>? releaseText,
    Value<int?>? releaseYear,
    Value<int?>? releaseMonth,
    Value<String?>? sourceUrl,
    Value<String?>? imageUrl,
    Value<String>? status,
    Value<String?>? memo,
    Value<int?>? acquiredAtEpochMs,
    Value<int>? createdAtEpochMs,
    Value<int>? updatedAtEpochMs,
  }) {
    return PrizeItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      workTitle: workTitle ?? this.workTitle,
      characterName: characterName ?? this.characterName,
      seriesName: seriesName ?? this.seriesName,
      maker: maker ?? this.maker,
      releaseText: releaseText ?? this.releaseText,
      releaseYear: releaseYear ?? this.releaseYear,
      releaseMonth: releaseMonth ?? this.releaseMonth,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      memo: memo ?? this.memo,
      acquiredAtEpochMs: acquiredAtEpochMs ?? this.acquiredAtEpochMs,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
      updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (workTitle.present) {
      map['work_title'] = Variable<String>(workTitle.value);
    }
    if (characterName.present) {
      map['character_name'] = Variable<String>(characterName.value);
    }
    if (seriesName.present) {
      map['series_name'] = Variable<String>(seriesName.value);
    }
    if (maker.present) {
      map['maker'] = Variable<String>(maker.value);
    }
    if (releaseText.present) {
      map['release_text'] = Variable<String>(releaseText.value);
    }
    if (releaseYear.present) {
      map['release_year'] = Variable<int>(releaseYear.value);
    }
    if (releaseMonth.present) {
      map['release_month'] = Variable<int>(releaseMonth.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (acquiredAtEpochMs.present) {
      map['acquired_at_epoch_ms'] = Variable<int>(acquiredAtEpochMs.value);
    }
    if (createdAtEpochMs.present) {
      map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs.value);
    }
    if (updatedAtEpochMs.present) {
      map['updated_at_epoch_ms'] = Variable<int>(updatedAtEpochMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrizeItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('workTitle: $workTitle, ')
          ..write('characterName: $characterName, ')
          ..write('seriesName: $seriesName, ')
          ..write('maker: $maker, ')
          ..write('releaseText: $releaseText, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('releaseMonth: $releaseMonth, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('status: $status, ')
          ..write('memo: $memo, ')
          ..write('acquiredAtEpochMs: $acquiredAtEpochMs, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('updatedAtEpochMs: $updatedAtEpochMs')
          ..write(')'))
        .toString();
  }
}

class $PrizeAcquisitionLogsTable extends PrizeAcquisitionLogs
    with TableInfo<$PrizeAcquisitionLogsTable, PrizeAcquisitionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrizeAcquisitionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _prizeIdMeta = const VerificationMeta(
    'prizeId',
  );
  @override
  late final GeneratedColumn<int> prizeId = GeneratedColumn<int>(
    'prize_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prize_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costYenMeta = const VerificationMeta(
    'costYen',
  );
  @override
  late final GeneratedColumn<int> costYen = GeneratedColumn<int>(
    'cost_yen',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtEpochMsMeta = const VerificationMeta(
    'createdAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> createdAtEpochMs = GeneratedColumn<int>(
    'created_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    prizeId,
    method,
    place,
    costYen,
    memo,
    createdAtEpochMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prize_acquisition_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrizeAcquisitionLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prize_id')) {
      context.handle(
        _prizeIdMeta,
        prizeId.isAcceptableOrUnknown(data['prize_id']!, _prizeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_prizeIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    }
    if (data.containsKey('cost_yen')) {
      context.handle(
        _costYenMeta,
        costYen.isAcceptableOrUnknown(data['cost_yen']!, _costYenMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('created_at_epoch_ms')) {
      context.handle(
        _createdAtEpochMsMeta,
        createdAtEpochMs.isAcceptableOrUnknown(
          data['created_at_epoch_ms']!,
          _createdAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtEpochMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrizeAcquisitionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrizeAcquisitionLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      prizeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prize_id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      ),
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      ),
      costYen: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_yen'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      createdAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_epoch_ms'],
      )!,
    );
  }

  @override
  $PrizeAcquisitionLogsTable createAlias(String alias) {
    return $PrizeAcquisitionLogsTable(attachedDatabase, alias);
  }
}

class PrizeAcquisitionLog extends DataClass
    implements Insertable<PrizeAcquisitionLog> {
  final int id;
  final int prizeId;
  final String? method;
  final String? place;
  final int? costYen;
  final String? memo;
  final int createdAtEpochMs;
  const PrizeAcquisitionLog({
    required this.id,
    required this.prizeId,
    this.method,
    this.place,
    this.costYen,
    this.memo,
    required this.createdAtEpochMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prize_id'] = Variable<int>(prizeId);
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<String>(place);
    }
    if (!nullToAbsent || costYen != null) {
      map['cost_yen'] = Variable<int>(costYen);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs);
    return map;
  }

  PrizeAcquisitionLogsCompanion toCompanion(bool nullToAbsent) {
    return PrizeAcquisitionLogsCompanion(
      id: Value(id),
      prizeId: Value(prizeId),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      place: place == null && nullToAbsent
          ? const Value.absent()
          : Value(place),
      costYen: costYen == null && nullToAbsent
          ? const Value.absent()
          : Value(costYen),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      createdAtEpochMs: Value(createdAtEpochMs),
    );
  }

  factory PrizeAcquisitionLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrizeAcquisitionLog(
      id: serializer.fromJson<int>(json['id']),
      prizeId: serializer.fromJson<int>(json['prizeId']),
      method: serializer.fromJson<String?>(json['method']),
      place: serializer.fromJson<String?>(json['place']),
      costYen: serializer.fromJson<int?>(json['costYen']),
      memo: serializer.fromJson<String?>(json['memo']),
      createdAtEpochMs: serializer.fromJson<int>(json['createdAtEpochMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'prizeId': serializer.toJson<int>(prizeId),
      'method': serializer.toJson<String?>(method),
      'place': serializer.toJson<String?>(place),
      'costYen': serializer.toJson<int?>(costYen),
      'memo': serializer.toJson<String?>(memo),
      'createdAtEpochMs': serializer.toJson<int>(createdAtEpochMs),
    };
  }

  PrizeAcquisitionLog copyWith({
    int? id,
    int? prizeId,
    Value<String?> method = const Value.absent(),
    Value<String?> place = const Value.absent(),
    Value<int?> costYen = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    int? createdAtEpochMs,
  }) => PrizeAcquisitionLog(
    id: id ?? this.id,
    prizeId: prizeId ?? this.prizeId,
    method: method.present ? method.value : this.method,
    place: place.present ? place.value : this.place,
    costYen: costYen.present ? costYen.value : this.costYen,
    memo: memo.present ? memo.value : this.memo,
    createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
  );
  PrizeAcquisitionLog copyWithCompanion(PrizeAcquisitionLogsCompanion data) {
    return PrizeAcquisitionLog(
      id: data.id.present ? data.id.value : this.id,
      prizeId: data.prizeId.present ? data.prizeId.value : this.prizeId,
      method: data.method.present ? data.method.value : this.method,
      place: data.place.present ? data.place.value : this.place,
      costYen: data.costYen.present ? data.costYen.value : this.costYen,
      memo: data.memo.present ? data.memo.value : this.memo,
      createdAtEpochMs: data.createdAtEpochMs.present
          ? data.createdAtEpochMs.value
          : this.createdAtEpochMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrizeAcquisitionLog(')
          ..write('id: $id, ')
          ..write('prizeId: $prizeId, ')
          ..write('method: $method, ')
          ..write('place: $place, ')
          ..write('costYen: $costYen, ')
          ..write('memo: $memo, ')
          ..write('createdAtEpochMs: $createdAtEpochMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, prizeId, method, place, costYen, memo, createdAtEpochMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrizeAcquisitionLog &&
          other.id == this.id &&
          other.prizeId == this.prizeId &&
          other.method == this.method &&
          other.place == this.place &&
          other.costYen == this.costYen &&
          other.memo == this.memo &&
          other.createdAtEpochMs == this.createdAtEpochMs);
}

class PrizeAcquisitionLogsCompanion
    extends UpdateCompanion<PrizeAcquisitionLog> {
  final Value<int> id;
  final Value<int> prizeId;
  final Value<String?> method;
  final Value<String?> place;
  final Value<int?> costYen;
  final Value<String?> memo;
  final Value<int> createdAtEpochMs;
  const PrizeAcquisitionLogsCompanion({
    this.id = const Value.absent(),
    this.prizeId = const Value.absent(),
    this.method = const Value.absent(),
    this.place = const Value.absent(),
    this.costYen = const Value.absent(),
    this.memo = const Value.absent(),
    this.createdAtEpochMs = const Value.absent(),
  });
  PrizeAcquisitionLogsCompanion.insert({
    this.id = const Value.absent(),
    required int prizeId,
    this.method = const Value.absent(),
    this.place = const Value.absent(),
    this.costYen = const Value.absent(),
    this.memo = const Value.absent(),
    required int createdAtEpochMs,
  }) : prizeId = Value(prizeId),
       createdAtEpochMs = Value(createdAtEpochMs);
  static Insertable<PrizeAcquisitionLog> custom({
    Expression<int>? id,
    Expression<int>? prizeId,
    Expression<String>? method,
    Expression<String>? place,
    Expression<int>? costYen,
    Expression<String>? memo,
    Expression<int>? createdAtEpochMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prizeId != null) 'prize_id': prizeId,
      if (method != null) 'method': method,
      if (place != null) 'place': place,
      if (costYen != null) 'cost_yen': costYen,
      if (memo != null) 'memo': memo,
      if (createdAtEpochMs != null) 'created_at_epoch_ms': createdAtEpochMs,
    });
  }

  PrizeAcquisitionLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? prizeId,
    Value<String?>? method,
    Value<String?>? place,
    Value<int?>? costYen,
    Value<String?>? memo,
    Value<int>? createdAtEpochMs,
  }) {
    return PrizeAcquisitionLogsCompanion(
      id: id ?? this.id,
      prizeId: prizeId ?? this.prizeId,
      method: method ?? this.method,
      place: place ?? this.place,
      costYen: costYen ?? this.costYen,
      memo: memo ?? this.memo,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (prizeId.present) {
      map['prize_id'] = Variable<int>(prizeId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (costYen.present) {
      map['cost_yen'] = Variable<int>(costYen.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (createdAtEpochMs.present) {
      map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrizeAcquisitionLogsCompanion(')
          ..write('id: $id, ')
          ..write('prizeId: $prizeId, ')
          ..write('method: $method, ')
          ..write('place: $place, ')
          ..write('costYen: $costYen, ')
          ..write('memo: $memo, ')
          ..write('createdAtEpochMs: $createdAtEpochMs')
          ..write(')'))
        .toString();
  }
}

class $PrizeStoresTable extends PrizeStores
    with TableInfo<$PrizeStoresTable, PrizeStore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrizeStoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRegisteredMeta = const VerificationMeta(
    'isRegistered',
  );
  @override
  late final GeneratedColumn<bool> isRegistered = GeneratedColumn<bool>(
    'is_registered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_registered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtEpochMsMeta = const VerificationMeta(
    'createdAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> createdAtEpochMs = GeneratedColumn<int>(
    'created_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtEpochMsMeta = const VerificationMeta(
    'updatedAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtEpochMs = GeneratedColumn<int>(
    'updated_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    area,
    address,
    sourceUrl,
    isRegistered,
    createdAtEpochMs,
    updatedAtEpochMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prize_stores';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrizeStore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('is_registered')) {
      context.handle(
        _isRegisteredMeta,
        isRegistered.isAcceptableOrUnknown(
          data['is_registered']!,
          _isRegisteredMeta,
        ),
      );
    }
    if (data.containsKey('created_at_epoch_ms')) {
      context.handle(
        _createdAtEpochMsMeta,
        createdAtEpochMs.isAcceptableOrUnknown(
          data['created_at_epoch_ms']!,
          _createdAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtEpochMsMeta);
    }
    if (data.containsKey('updated_at_epoch_ms')) {
      context.handle(
        _updatedAtEpochMsMeta,
        updatedAtEpochMs.isAcceptableOrUnknown(
          data['updated_at_epoch_ms']!,
          _updatedAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtEpochMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrizeStore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrizeStore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      isRegistered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_registered'],
      )!,
      createdAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_epoch_ms'],
      )!,
      updatedAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_epoch_ms'],
      )!,
    );
  }

  @override
  $PrizeStoresTable createAlias(String alias) {
    return $PrizeStoresTable(attachedDatabase, alias);
  }
}

class PrizeStore extends DataClass implements Insertable<PrizeStore> {
  final int id;
  final String name;
  final String area;
  final String? address;
  final String? sourceUrl;
  final bool isRegistered;
  final int createdAtEpochMs;
  final int updatedAtEpochMs;
  const PrizeStore({
    required this.id,
    required this.name,
    required this.area,
    this.address,
    this.sourceUrl,
    required this.isRegistered,
    required this.createdAtEpochMs,
    required this.updatedAtEpochMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['area'] = Variable<String>(area);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    map['is_registered'] = Variable<bool>(isRegistered);
    map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs);
    map['updated_at_epoch_ms'] = Variable<int>(updatedAtEpochMs);
    return map;
  }

  PrizeStoresCompanion toCompanion(bool nullToAbsent) {
    return PrizeStoresCompanion(
      id: Value(id),
      name: Value(name),
      area: Value(area),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      isRegistered: Value(isRegistered),
      createdAtEpochMs: Value(createdAtEpochMs),
      updatedAtEpochMs: Value(updatedAtEpochMs),
    );
  }

  factory PrizeStore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrizeStore(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      area: serializer.fromJson<String>(json['area']),
      address: serializer.fromJson<String?>(json['address']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      isRegistered: serializer.fromJson<bool>(json['isRegistered']),
      createdAtEpochMs: serializer.fromJson<int>(json['createdAtEpochMs']),
      updatedAtEpochMs: serializer.fromJson<int>(json['updatedAtEpochMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'area': serializer.toJson<String>(area),
      'address': serializer.toJson<String?>(address),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'isRegistered': serializer.toJson<bool>(isRegistered),
      'createdAtEpochMs': serializer.toJson<int>(createdAtEpochMs),
      'updatedAtEpochMs': serializer.toJson<int>(updatedAtEpochMs),
    };
  }

  PrizeStore copyWith({
    int? id,
    String? name,
    String? area,
    Value<String?> address = const Value.absent(),
    Value<String?> sourceUrl = const Value.absent(),
    bool? isRegistered,
    int? createdAtEpochMs,
    int? updatedAtEpochMs,
  }) => PrizeStore(
    id: id ?? this.id,
    name: name ?? this.name,
    area: area ?? this.area,
    address: address.present ? address.value : this.address,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    isRegistered: isRegistered ?? this.isRegistered,
    createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
    updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
  );
  PrizeStore copyWithCompanion(PrizeStoresCompanion data) {
    return PrizeStore(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      area: data.area.present ? data.area.value : this.area,
      address: data.address.present ? data.address.value : this.address,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      isRegistered: data.isRegistered.present
          ? data.isRegistered.value
          : this.isRegistered,
      createdAtEpochMs: data.createdAtEpochMs.present
          ? data.createdAtEpochMs.value
          : this.createdAtEpochMs,
      updatedAtEpochMs: data.updatedAtEpochMs.present
          ? data.updatedAtEpochMs.value
          : this.updatedAtEpochMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrizeStore(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('area: $area, ')
          ..write('address: $address, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('isRegistered: $isRegistered, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('updatedAtEpochMs: $updatedAtEpochMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    area,
    address,
    sourceUrl,
    isRegistered,
    createdAtEpochMs,
    updatedAtEpochMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrizeStore &&
          other.id == this.id &&
          other.name == this.name &&
          other.area == this.area &&
          other.address == this.address &&
          other.sourceUrl == this.sourceUrl &&
          other.isRegistered == this.isRegistered &&
          other.createdAtEpochMs == this.createdAtEpochMs &&
          other.updatedAtEpochMs == this.updatedAtEpochMs);
}

class PrizeStoresCompanion extends UpdateCompanion<PrizeStore> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> area;
  final Value<String?> address;
  final Value<String?> sourceUrl;
  final Value<bool> isRegistered;
  final Value<int> createdAtEpochMs;
  final Value<int> updatedAtEpochMs;
  const PrizeStoresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.area = const Value.absent(),
    this.address = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.isRegistered = const Value.absent(),
    this.createdAtEpochMs = const Value.absent(),
    this.updatedAtEpochMs = const Value.absent(),
  });
  PrizeStoresCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String area,
    this.address = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.isRegistered = const Value.absent(),
    required int createdAtEpochMs,
    required int updatedAtEpochMs,
  }) : name = Value(name),
       area = Value(area),
       createdAtEpochMs = Value(createdAtEpochMs),
       updatedAtEpochMs = Value(updatedAtEpochMs);
  static Insertable<PrizeStore> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? area,
    Expression<String>? address,
    Expression<String>? sourceUrl,
    Expression<bool>? isRegistered,
    Expression<int>? createdAtEpochMs,
    Expression<int>? updatedAtEpochMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (area != null) 'area': area,
      if (address != null) 'address': address,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (isRegistered != null) 'is_registered': isRegistered,
      if (createdAtEpochMs != null) 'created_at_epoch_ms': createdAtEpochMs,
      if (updatedAtEpochMs != null) 'updated_at_epoch_ms': updatedAtEpochMs,
    });
  }

  PrizeStoresCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? area,
    Value<String?>? address,
    Value<String?>? sourceUrl,
    Value<bool>? isRegistered,
    Value<int>? createdAtEpochMs,
    Value<int>? updatedAtEpochMs,
  }) {
    return PrizeStoresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      area: area ?? this.area,
      address: address ?? this.address,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      isRegistered: isRegistered ?? this.isRegistered,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
      updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (isRegistered.present) {
      map['is_registered'] = Variable<bool>(isRegistered.value);
    }
    if (createdAtEpochMs.present) {
      map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs.value);
    }
    if (updatedAtEpochMs.present) {
      map['updated_at_epoch_ms'] = Variable<int>(updatedAtEpochMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrizeStoresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('area: $area, ')
          ..write('address: $address, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('isRegistered: $isRegistered, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('updatedAtEpochMs: $updatedAtEpochMs')
          ..write(')'))
        .toString();
  }
}

class $PrizeStoreAppearancesTable extends PrizeStoreAppearances
    with TableInfo<$PrizeStoreAppearancesTable, PrizeStoreAppearance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrizeStoreAppearancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _prizeIdMeta = const VerificationMeta(
    'prizeId',
  );
  @override
  late final GeneratedColumn<int> prizeId = GeneratedColumn<int>(
    'prize_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prize_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<int> storeId = GeneratedColumn<int>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prize_stores (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _appearanceTextMeta = const VerificationMeta(
    'appearanceText',
  );
  @override
  late final GeneratedColumn<String> appearanceText = GeneratedColumn<String>(
    'appearance_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appearanceDateEpochMsMeta =
      const VerificationMeta('appearanceDateEpochMs');
  @override
  late final GeneratedColumn<int> appearanceDateEpochMs = GeneratedColumn<int>(
    'appearance_date_epoch_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtEpochMsMeta = const VerificationMeta(
    'createdAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> createdAtEpochMs = GeneratedColumn<int>(
    'created_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtEpochMsMeta = const VerificationMeta(
    'updatedAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtEpochMs = GeneratedColumn<int>(
    'updated_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    prizeId,
    storeId,
    appearanceText,
    appearanceDateEpochMs,
    sourceUrl,
    memo,
    createdAtEpochMs,
    updatedAtEpochMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prize_store_appearances';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrizeStoreAppearance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prize_id')) {
      context.handle(
        _prizeIdMeta,
        prizeId.isAcceptableOrUnknown(data['prize_id']!, _prizeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_prizeIdMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('appearance_text')) {
      context.handle(
        _appearanceTextMeta,
        appearanceText.isAcceptableOrUnknown(
          data['appearance_text']!,
          _appearanceTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appearanceTextMeta);
    }
    if (data.containsKey('appearance_date_epoch_ms')) {
      context.handle(
        _appearanceDateEpochMsMeta,
        appearanceDateEpochMs.isAcceptableOrUnknown(
          data['appearance_date_epoch_ms']!,
          _appearanceDateEpochMsMeta,
        ),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('created_at_epoch_ms')) {
      context.handle(
        _createdAtEpochMsMeta,
        createdAtEpochMs.isAcceptableOrUnknown(
          data['created_at_epoch_ms']!,
          _createdAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtEpochMsMeta);
    }
    if (data.containsKey('updated_at_epoch_ms')) {
      context.handle(
        _updatedAtEpochMsMeta,
        updatedAtEpochMs.isAcceptableOrUnknown(
          data['updated_at_epoch_ms']!,
          _updatedAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtEpochMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrizeStoreAppearance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrizeStoreAppearance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      prizeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prize_id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}store_id'],
      )!,
      appearanceText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appearance_text'],
      )!,
      appearanceDateEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}appearance_date_epoch_ms'],
      ),
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      createdAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_epoch_ms'],
      )!,
      updatedAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_epoch_ms'],
      )!,
    );
  }

  @override
  $PrizeStoreAppearancesTable createAlias(String alias) {
    return $PrizeStoreAppearancesTable(attachedDatabase, alias);
  }
}

class PrizeStoreAppearance extends DataClass
    implements Insertable<PrizeStoreAppearance> {
  final int id;
  final int prizeId;
  final int storeId;
  final String appearanceText;
  final int? appearanceDateEpochMs;
  final String? sourceUrl;
  final String? memo;
  final int createdAtEpochMs;
  final int updatedAtEpochMs;
  const PrizeStoreAppearance({
    required this.id,
    required this.prizeId,
    required this.storeId,
    required this.appearanceText,
    this.appearanceDateEpochMs,
    this.sourceUrl,
    this.memo,
    required this.createdAtEpochMs,
    required this.updatedAtEpochMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prize_id'] = Variable<int>(prizeId);
    map['store_id'] = Variable<int>(storeId);
    map['appearance_text'] = Variable<String>(appearanceText);
    if (!nullToAbsent || appearanceDateEpochMs != null) {
      map['appearance_date_epoch_ms'] = Variable<int>(appearanceDateEpochMs);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs);
    map['updated_at_epoch_ms'] = Variable<int>(updatedAtEpochMs);
    return map;
  }

  PrizeStoreAppearancesCompanion toCompanion(bool nullToAbsent) {
    return PrizeStoreAppearancesCompanion(
      id: Value(id),
      prizeId: Value(prizeId),
      storeId: Value(storeId),
      appearanceText: Value(appearanceText),
      appearanceDateEpochMs: appearanceDateEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(appearanceDateEpochMs),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      createdAtEpochMs: Value(createdAtEpochMs),
      updatedAtEpochMs: Value(updatedAtEpochMs),
    );
  }

  factory PrizeStoreAppearance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrizeStoreAppearance(
      id: serializer.fromJson<int>(json['id']),
      prizeId: serializer.fromJson<int>(json['prizeId']),
      storeId: serializer.fromJson<int>(json['storeId']),
      appearanceText: serializer.fromJson<String>(json['appearanceText']),
      appearanceDateEpochMs: serializer.fromJson<int?>(
        json['appearanceDateEpochMs'],
      ),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      memo: serializer.fromJson<String?>(json['memo']),
      createdAtEpochMs: serializer.fromJson<int>(json['createdAtEpochMs']),
      updatedAtEpochMs: serializer.fromJson<int>(json['updatedAtEpochMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'prizeId': serializer.toJson<int>(prizeId),
      'storeId': serializer.toJson<int>(storeId),
      'appearanceText': serializer.toJson<String>(appearanceText),
      'appearanceDateEpochMs': serializer.toJson<int?>(appearanceDateEpochMs),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'memo': serializer.toJson<String?>(memo),
      'createdAtEpochMs': serializer.toJson<int>(createdAtEpochMs),
      'updatedAtEpochMs': serializer.toJson<int>(updatedAtEpochMs),
    };
  }

  PrizeStoreAppearance copyWith({
    int? id,
    int? prizeId,
    int? storeId,
    String? appearanceText,
    Value<int?> appearanceDateEpochMs = const Value.absent(),
    Value<String?> sourceUrl = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    int? createdAtEpochMs,
    int? updatedAtEpochMs,
  }) => PrizeStoreAppearance(
    id: id ?? this.id,
    prizeId: prizeId ?? this.prizeId,
    storeId: storeId ?? this.storeId,
    appearanceText: appearanceText ?? this.appearanceText,
    appearanceDateEpochMs: appearanceDateEpochMs.present
        ? appearanceDateEpochMs.value
        : this.appearanceDateEpochMs,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    memo: memo.present ? memo.value : this.memo,
    createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
    updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
  );
  PrizeStoreAppearance copyWithCompanion(PrizeStoreAppearancesCompanion data) {
    return PrizeStoreAppearance(
      id: data.id.present ? data.id.value : this.id,
      prizeId: data.prizeId.present ? data.prizeId.value : this.prizeId,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      appearanceText: data.appearanceText.present
          ? data.appearanceText.value
          : this.appearanceText,
      appearanceDateEpochMs: data.appearanceDateEpochMs.present
          ? data.appearanceDateEpochMs.value
          : this.appearanceDateEpochMs,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      memo: data.memo.present ? data.memo.value : this.memo,
      createdAtEpochMs: data.createdAtEpochMs.present
          ? data.createdAtEpochMs.value
          : this.createdAtEpochMs,
      updatedAtEpochMs: data.updatedAtEpochMs.present
          ? data.updatedAtEpochMs.value
          : this.updatedAtEpochMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrizeStoreAppearance(')
          ..write('id: $id, ')
          ..write('prizeId: $prizeId, ')
          ..write('storeId: $storeId, ')
          ..write('appearanceText: $appearanceText, ')
          ..write('appearanceDateEpochMs: $appearanceDateEpochMs, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('memo: $memo, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('updatedAtEpochMs: $updatedAtEpochMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    prizeId,
    storeId,
    appearanceText,
    appearanceDateEpochMs,
    sourceUrl,
    memo,
    createdAtEpochMs,
    updatedAtEpochMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrizeStoreAppearance &&
          other.id == this.id &&
          other.prizeId == this.prizeId &&
          other.storeId == this.storeId &&
          other.appearanceText == this.appearanceText &&
          other.appearanceDateEpochMs == this.appearanceDateEpochMs &&
          other.sourceUrl == this.sourceUrl &&
          other.memo == this.memo &&
          other.createdAtEpochMs == this.createdAtEpochMs &&
          other.updatedAtEpochMs == this.updatedAtEpochMs);
}

class PrizeStoreAppearancesCompanion
    extends UpdateCompanion<PrizeStoreAppearance> {
  final Value<int> id;
  final Value<int> prizeId;
  final Value<int> storeId;
  final Value<String> appearanceText;
  final Value<int?> appearanceDateEpochMs;
  final Value<String?> sourceUrl;
  final Value<String?> memo;
  final Value<int> createdAtEpochMs;
  final Value<int> updatedAtEpochMs;
  const PrizeStoreAppearancesCompanion({
    this.id = const Value.absent(),
    this.prizeId = const Value.absent(),
    this.storeId = const Value.absent(),
    this.appearanceText = const Value.absent(),
    this.appearanceDateEpochMs = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.memo = const Value.absent(),
    this.createdAtEpochMs = const Value.absent(),
    this.updatedAtEpochMs = const Value.absent(),
  });
  PrizeStoreAppearancesCompanion.insert({
    this.id = const Value.absent(),
    required int prizeId,
    required int storeId,
    required String appearanceText,
    this.appearanceDateEpochMs = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.memo = const Value.absent(),
    required int createdAtEpochMs,
    required int updatedAtEpochMs,
  }) : prizeId = Value(prizeId),
       storeId = Value(storeId),
       appearanceText = Value(appearanceText),
       createdAtEpochMs = Value(createdAtEpochMs),
       updatedAtEpochMs = Value(updatedAtEpochMs);
  static Insertable<PrizeStoreAppearance> custom({
    Expression<int>? id,
    Expression<int>? prizeId,
    Expression<int>? storeId,
    Expression<String>? appearanceText,
    Expression<int>? appearanceDateEpochMs,
    Expression<String>? sourceUrl,
    Expression<String>? memo,
    Expression<int>? createdAtEpochMs,
    Expression<int>? updatedAtEpochMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prizeId != null) 'prize_id': prizeId,
      if (storeId != null) 'store_id': storeId,
      if (appearanceText != null) 'appearance_text': appearanceText,
      if (appearanceDateEpochMs != null)
        'appearance_date_epoch_ms': appearanceDateEpochMs,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (memo != null) 'memo': memo,
      if (createdAtEpochMs != null) 'created_at_epoch_ms': createdAtEpochMs,
      if (updatedAtEpochMs != null) 'updated_at_epoch_ms': updatedAtEpochMs,
    });
  }

  PrizeStoreAppearancesCompanion copyWith({
    Value<int>? id,
    Value<int>? prizeId,
    Value<int>? storeId,
    Value<String>? appearanceText,
    Value<int?>? appearanceDateEpochMs,
    Value<String?>? sourceUrl,
    Value<String?>? memo,
    Value<int>? createdAtEpochMs,
    Value<int>? updatedAtEpochMs,
  }) {
    return PrizeStoreAppearancesCompanion(
      id: id ?? this.id,
      prizeId: prizeId ?? this.prizeId,
      storeId: storeId ?? this.storeId,
      appearanceText: appearanceText ?? this.appearanceText,
      appearanceDateEpochMs:
          appearanceDateEpochMs ?? this.appearanceDateEpochMs,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      memo: memo ?? this.memo,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
      updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (prizeId.present) {
      map['prize_id'] = Variable<int>(prizeId.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<int>(storeId.value);
    }
    if (appearanceText.present) {
      map['appearance_text'] = Variable<String>(appearanceText.value);
    }
    if (appearanceDateEpochMs.present) {
      map['appearance_date_epoch_ms'] = Variable<int>(
        appearanceDateEpochMs.value,
      );
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (createdAtEpochMs.present) {
      map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs.value);
    }
    if (updatedAtEpochMs.present) {
      map['updated_at_epoch_ms'] = Variable<int>(updatedAtEpochMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrizeStoreAppearancesCompanion(')
          ..write('id: $id, ')
          ..write('prizeId: $prizeId, ')
          ..write('storeId: $storeId, ')
          ..write('appearanceText: $appearanceText, ')
          ..write('appearanceDateEpochMs: $appearanceDateEpochMs, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('memo: $memo, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('updatedAtEpochMs: $updatedAtEpochMs')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PrizeItemsTable prizeItems = $PrizeItemsTable(this);
  late final $PrizeAcquisitionLogsTable prizeAcquisitionLogs =
      $PrizeAcquisitionLogsTable(this);
  late final $PrizeStoresTable prizeStores = $PrizeStoresTable(this);
  late final $PrizeStoreAppearancesTable prizeStoreAppearances =
      $PrizeStoreAppearancesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    prizeItems,
    prizeAcquisitionLogs,
    prizeStores,
    prizeStoreAppearances,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'prize_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('prize_acquisition_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'prize_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('prize_store_appearances', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'prize_stores',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('prize_store_appearances', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PrizeItemsTableCreateCompanionBuilder =
    PrizeItemsCompanion Function({
      Value<int> id,
      required String title,
      required String workTitle,
      required String characterName,
      required String seriesName,
      required String maker,
      required String releaseText,
      Value<int?> releaseYear,
      Value<int?> releaseMonth,
      Value<String?> sourceUrl,
      Value<String?> imageUrl,
      Value<String> status,
      Value<String?> memo,
      Value<int?> acquiredAtEpochMs,
      required int createdAtEpochMs,
      required int updatedAtEpochMs,
    });
typedef $$PrizeItemsTableUpdateCompanionBuilder =
    PrizeItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> workTitle,
      Value<String> characterName,
      Value<String> seriesName,
      Value<String> maker,
      Value<String> releaseText,
      Value<int?> releaseYear,
      Value<int?> releaseMonth,
      Value<String?> sourceUrl,
      Value<String?> imageUrl,
      Value<String> status,
      Value<String?> memo,
      Value<int?> acquiredAtEpochMs,
      Value<int> createdAtEpochMs,
      Value<int> updatedAtEpochMs,
    });

final class $$PrizeItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PrizeItemsTable, PrizeItem> {
  $$PrizeItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $PrizeAcquisitionLogsTable,
    List<PrizeAcquisitionLog>
  >
  _prizeAcquisitionLogsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.prizeAcquisitionLogs,
        aliasName: $_aliasNameGenerator(
          db.prizeItems.id,
          db.prizeAcquisitionLogs.prizeId,
        ),
      );

  $$PrizeAcquisitionLogsTableProcessedTableManager
  get prizeAcquisitionLogsRefs {
    final manager = $$PrizeAcquisitionLogsTableTableManager(
      $_db,
      $_db.prizeAcquisitionLogs,
    ).filter((f) => f.prizeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _prizeAcquisitionLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PrizeStoreAppearancesTable,
    List<PrizeStoreAppearance>
  >
  _prizeStoreAppearancesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.prizeStoreAppearances,
        aliasName: $_aliasNameGenerator(
          db.prizeItems.id,
          db.prizeStoreAppearances.prizeId,
        ),
      );

  $$PrizeStoreAppearancesTableProcessedTableManager
  get prizeStoreAppearancesRefs {
    final manager = $$PrizeStoreAppearancesTableTableManager(
      $_db,
      $_db.prizeStoreAppearances,
    ).filter((f) => f.prizeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _prizeStoreAppearancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PrizeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PrizeItemsTable> {
  $$PrizeItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workTitle => $composableBuilder(
    column: $table.workTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get characterName => $composableBuilder(
    column: $table.characterName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seriesName => $composableBuilder(
    column: $table.seriesName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maker => $composableBuilder(
    column: $table.maker,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get releaseText => $composableBuilder(
    column: $table.releaseText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get releaseMonth => $composableBuilder(
    column: $table.releaseMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get acquiredAtEpochMs => $composableBuilder(
    column: $table.acquiredAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> prizeAcquisitionLogsRefs(
    Expression<bool> Function($$PrizeAcquisitionLogsTableFilterComposer f) f,
  ) {
    final $$PrizeAcquisitionLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.prizeAcquisitionLogs,
      getReferencedColumn: (t) => t.prizeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeAcquisitionLogsTableFilterComposer(
            $db: $db,
            $table: $db.prizeAcquisitionLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> prizeStoreAppearancesRefs(
    Expression<bool> Function($$PrizeStoreAppearancesTableFilterComposer f) f,
  ) {
    final $$PrizeStoreAppearancesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.prizeStoreAppearances,
          getReferencedColumn: (t) => t.prizeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PrizeStoreAppearancesTableFilterComposer(
                $db: $db,
                $table: $db.prizeStoreAppearances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PrizeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrizeItemsTable> {
  $$PrizeItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workTitle => $composableBuilder(
    column: $table.workTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get characterName => $composableBuilder(
    column: $table.characterName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seriesName => $composableBuilder(
    column: $table.seriesName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maker => $composableBuilder(
    column: $table.maker,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get releaseText => $composableBuilder(
    column: $table.releaseText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get releaseMonth => $composableBuilder(
    column: $table.releaseMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get acquiredAtEpochMs => $composableBuilder(
    column: $table.acquiredAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrizeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrizeItemsTable> {
  $$PrizeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get workTitle =>
      $composableBuilder(column: $table.workTitle, builder: (column) => column);

  GeneratedColumn<String> get characterName => $composableBuilder(
    column: $table.characterName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seriesName => $composableBuilder(
    column: $table.seriesName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get maker =>
      $composableBuilder(column: $table.maker, builder: (column) => column);

  GeneratedColumn<String> get releaseText => $composableBuilder(
    column: $table.releaseText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => column,
  );

  GeneratedColumn<int> get releaseMonth => $composableBuilder(
    column: $table.releaseMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<int> get acquiredAtEpochMs => $composableBuilder(
    column: $table.acquiredAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => column,
  );

  Expression<T> prizeAcquisitionLogsRefs<T extends Object>(
    Expression<T> Function($$PrizeAcquisitionLogsTableAnnotationComposer a) f,
  ) {
    final $$PrizeAcquisitionLogsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.prizeAcquisitionLogs,
          getReferencedColumn: (t) => t.prizeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PrizeAcquisitionLogsTableAnnotationComposer(
                $db: $db,
                $table: $db.prizeAcquisitionLogs,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> prizeStoreAppearancesRefs<T extends Object>(
    Expression<T> Function($$PrizeStoreAppearancesTableAnnotationComposer a) f,
  ) {
    final $$PrizeStoreAppearancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.prizeStoreAppearances,
          getReferencedColumn: (t) => t.prizeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PrizeStoreAppearancesTableAnnotationComposer(
                $db: $db,
                $table: $db.prizeStoreAppearances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PrizeItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrizeItemsTable,
          PrizeItem,
          $$PrizeItemsTableFilterComposer,
          $$PrizeItemsTableOrderingComposer,
          $$PrizeItemsTableAnnotationComposer,
          $$PrizeItemsTableCreateCompanionBuilder,
          $$PrizeItemsTableUpdateCompanionBuilder,
          (PrizeItem, $$PrizeItemsTableReferences),
          PrizeItem,
          PrefetchHooks Function({
            bool prizeAcquisitionLogsRefs,
            bool prizeStoreAppearancesRefs,
          })
        > {
  $$PrizeItemsTableTableManager(_$AppDatabase db, $PrizeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrizeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrizeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrizeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> workTitle = const Value.absent(),
                Value<String> characterName = const Value.absent(),
                Value<String> seriesName = const Value.absent(),
                Value<String> maker = const Value.absent(),
                Value<String> releaseText = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<int?> releaseMonth = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int?> acquiredAtEpochMs = const Value.absent(),
                Value<int> createdAtEpochMs = const Value.absent(),
                Value<int> updatedAtEpochMs = const Value.absent(),
              }) => PrizeItemsCompanion(
                id: id,
                title: title,
                workTitle: workTitle,
                characterName: characterName,
                seriesName: seriesName,
                maker: maker,
                releaseText: releaseText,
                releaseYear: releaseYear,
                releaseMonth: releaseMonth,
                sourceUrl: sourceUrl,
                imageUrl: imageUrl,
                status: status,
                memo: memo,
                acquiredAtEpochMs: acquiredAtEpochMs,
                createdAtEpochMs: createdAtEpochMs,
                updatedAtEpochMs: updatedAtEpochMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String workTitle,
                required String characterName,
                required String seriesName,
                required String maker,
                required String releaseText,
                Value<int?> releaseYear = const Value.absent(),
                Value<int?> releaseMonth = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int?> acquiredAtEpochMs = const Value.absent(),
                required int createdAtEpochMs,
                required int updatedAtEpochMs,
              }) => PrizeItemsCompanion.insert(
                id: id,
                title: title,
                workTitle: workTitle,
                characterName: characterName,
                seriesName: seriesName,
                maker: maker,
                releaseText: releaseText,
                releaseYear: releaseYear,
                releaseMonth: releaseMonth,
                sourceUrl: sourceUrl,
                imageUrl: imageUrl,
                status: status,
                memo: memo,
                acquiredAtEpochMs: acquiredAtEpochMs,
                createdAtEpochMs: createdAtEpochMs,
                updatedAtEpochMs: updatedAtEpochMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrizeItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                prizeAcquisitionLogsRefs = false,
                prizeStoreAppearancesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (prizeAcquisitionLogsRefs) db.prizeAcquisitionLogs,
                    if (prizeStoreAppearancesRefs) db.prizeStoreAppearances,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (prizeAcquisitionLogsRefs)
                        await $_getPrefetchedData<
                          PrizeItem,
                          $PrizeItemsTable,
                          PrizeAcquisitionLog
                        >(
                          currentTable: table,
                          referencedTable: $$PrizeItemsTableReferences
                              ._prizeAcquisitionLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PrizeItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).prizeAcquisitionLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.prizeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (prizeStoreAppearancesRefs)
                        await $_getPrefetchedData<
                          PrizeItem,
                          $PrizeItemsTable,
                          PrizeStoreAppearance
                        >(
                          currentTable: table,
                          referencedTable: $$PrizeItemsTableReferences
                              ._prizeStoreAppearancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PrizeItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).prizeStoreAppearancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.prizeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PrizeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrizeItemsTable,
      PrizeItem,
      $$PrizeItemsTableFilterComposer,
      $$PrizeItemsTableOrderingComposer,
      $$PrizeItemsTableAnnotationComposer,
      $$PrizeItemsTableCreateCompanionBuilder,
      $$PrizeItemsTableUpdateCompanionBuilder,
      (PrizeItem, $$PrizeItemsTableReferences),
      PrizeItem,
      PrefetchHooks Function({
        bool prizeAcquisitionLogsRefs,
        bool prizeStoreAppearancesRefs,
      })
    >;
typedef $$PrizeAcquisitionLogsTableCreateCompanionBuilder =
    PrizeAcquisitionLogsCompanion Function({
      Value<int> id,
      required int prizeId,
      Value<String?> method,
      Value<String?> place,
      Value<int?> costYen,
      Value<String?> memo,
      required int createdAtEpochMs,
    });
typedef $$PrizeAcquisitionLogsTableUpdateCompanionBuilder =
    PrizeAcquisitionLogsCompanion Function({
      Value<int> id,
      Value<int> prizeId,
      Value<String?> method,
      Value<String?> place,
      Value<int?> costYen,
      Value<String?> memo,
      Value<int> createdAtEpochMs,
    });

final class $$PrizeAcquisitionLogsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PrizeAcquisitionLogsTable,
          PrizeAcquisitionLog
        > {
  $$PrizeAcquisitionLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PrizeItemsTable _prizeIdTable(_$AppDatabase db) =>
      db.prizeItems.createAlias(
        $_aliasNameGenerator(db.prizeAcquisitionLogs.prizeId, db.prizeItems.id),
      );

  $$PrizeItemsTableProcessedTableManager get prizeId {
    final $_column = $_itemColumn<int>('prize_id')!;

    final manager = $$PrizeItemsTableTableManager(
      $_db,
      $_db.prizeItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_prizeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PrizeAcquisitionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $PrizeAcquisitionLogsTable> {
  $$PrizeAcquisitionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costYen => $composableBuilder(
    column: $table.costYen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  $$PrizeItemsTableFilterComposer get prizeId {
    final $$PrizeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prizeId,
      referencedTable: $db.prizeItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeItemsTableFilterComposer(
            $db: $db,
            $table: $db.prizeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrizeAcquisitionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrizeAcquisitionLogsTable> {
  $$PrizeAcquisitionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costYen => $composableBuilder(
    column: $table.costYen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$PrizeItemsTableOrderingComposer get prizeId {
    final $$PrizeItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prizeId,
      referencedTable: $db.prizeItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeItemsTableOrderingComposer(
            $db: $db,
            $table: $db.prizeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrizeAcquisitionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrizeAcquisitionLogsTable> {
  $$PrizeAcquisitionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<int> get costYen =>
      $composableBuilder(column: $table.costYen, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => column,
  );

  $$PrizeItemsTableAnnotationComposer get prizeId {
    final $$PrizeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prizeId,
      referencedTable: $db.prizeItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.prizeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrizeAcquisitionLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrizeAcquisitionLogsTable,
          PrizeAcquisitionLog,
          $$PrizeAcquisitionLogsTableFilterComposer,
          $$PrizeAcquisitionLogsTableOrderingComposer,
          $$PrizeAcquisitionLogsTableAnnotationComposer,
          $$PrizeAcquisitionLogsTableCreateCompanionBuilder,
          $$PrizeAcquisitionLogsTableUpdateCompanionBuilder,
          (PrizeAcquisitionLog, $$PrizeAcquisitionLogsTableReferences),
          PrizeAcquisitionLog,
          PrefetchHooks Function({bool prizeId})
        > {
  $$PrizeAcquisitionLogsTableTableManager(
    _$AppDatabase db,
    $PrizeAcquisitionLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrizeAcquisitionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrizeAcquisitionLogsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PrizeAcquisitionLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> prizeId = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<int?> costYen = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int> createdAtEpochMs = const Value.absent(),
              }) => PrizeAcquisitionLogsCompanion(
                id: id,
                prizeId: prizeId,
                method: method,
                place: place,
                costYen: costYen,
                memo: memo,
                createdAtEpochMs: createdAtEpochMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int prizeId,
                Value<String?> method = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<int?> costYen = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                required int createdAtEpochMs,
              }) => PrizeAcquisitionLogsCompanion.insert(
                id: id,
                prizeId: prizeId,
                method: method,
                place: place,
                costYen: costYen,
                memo: memo,
                createdAtEpochMs: createdAtEpochMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrizeAcquisitionLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({prizeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (prizeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.prizeId,
                                referencedTable:
                                    $$PrizeAcquisitionLogsTableReferences
                                        ._prizeIdTable(db),
                                referencedColumn:
                                    $$PrizeAcquisitionLogsTableReferences
                                        ._prizeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PrizeAcquisitionLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrizeAcquisitionLogsTable,
      PrizeAcquisitionLog,
      $$PrizeAcquisitionLogsTableFilterComposer,
      $$PrizeAcquisitionLogsTableOrderingComposer,
      $$PrizeAcquisitionLogsTableAnnotationComposer,
      $$PrizeAcquisitionLogsTableCreateCompanionBuilder,
      $$PrizeAcquisitionLogsTableUpdateCompanionBuilder,
      (PrizeAcquisitionLog, $$PrizeAcquisitionLogsTableReferences),
      PrizeAcquisitionLog,
      PrefetchHooks Function({bool prizeId})
    >;
typedef $$PrizeStoresTableCreateCompanionBuilder =
    PrizeStoresCompanion Function({
      Value<int> id,
      required String name,
      required String area,
      Value<String?> address,
      Value<String?> sourceUrl,
      Value<bool> isRegistered,
      required int createdAtEpochMs,
      required int updatedAtEpochMs,
    });
typedef $$PrizeStoresTableUpdateCompanionBuilder =
    PrizeStoresCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> area,
      Value<String?> address,
      Value<String?> sourceUrl,
      Value<bool> isRegistered,
      Value<int> createdAtEpochMs,
      Value<int> updatedAtEpochMs,
    });

final class $$PrizeStoresTableReferences
    extends BaseReferences<_$AppDatabase, $PrizeStoresTable, PrizeStore> {
  $$PrizeStoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $PrizeStoreAppearancesTable,
    List<PrizeStoreAppearance>
  >
  _prizeStoreAppearancesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.prizeStoreAppearances,
        aliasName: $_aliasNameGenerator(
          db.prizeStores.id,
          db.prizeStoreAppearances.storeId,
        ),
      );

  $$PrizeStoreAppearancesTableProcessedTableManager
  get prizeStoreAppearancesRefs {
    final manager = $$PrizeStoreAppearancesTableTableManager(
      $_db,
      $_db.prizeStoreAppearances,
    ).filter((f) => f.storeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _prizeStoreAppearancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PrizeStoresTableFilterComposer
    extends Composer<_$AppDatabase, $PrizeStoresTable> {
  $$PrizeStoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRegistered => $composableBuilder(
    column: $table.isRegistered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> prizeStoreAppearancesRefs(
    Expression<bool> Function($$PrizeStoreAppearancesTableFilterComposer f) f,
  ) {
    final $$PrizeStoreAppearancesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.prizeStoreAppearances,
          getReferencedColumn: (t) => t.storeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PrizeStoreAppearancesTableFilterComposer(
                $db: $db,
                $table: $db.prizeStoreAppearances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PrizeStoresTableOrderingComposer
    extends Composer<_$AppDatabase, $PrizeStoresTable> {
  $$PrizeStoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRegistered => $composableBuilder(
    column: $table.isRegistered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrizeStoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrizeStoresTable> {
  $$PrizeStoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<bool> get isRegistered => $composableBuilder(
    column: $table.isRegistered,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => column,
  );

  Expression<T> prizeStoreAppearancesRefs<T extends Object>(
    Expression<T> Function($$PrizeStoreAppearancesTableAnnotationComposer a) f,
  ) {
    final $$PrizeStoreAppearancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.prizeStoreAppearances,
          getReferencedColumn: (t) => t.storeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PrizeStoreAppearancesTableAnnotationComposer(
                $db: $db,
                $table: $db.prizeStoreAppearances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PrizeStoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrizeStoresTable,
          PrizeStore,
          $$PrizeStoresTableFilterComposer,
          $$PrizeStoresTableOrderingComposer,
          $$PrizeStoresTableAnnotationComposer,
          $$PrizeStoresTableCreateCompanionBuilder,
          $$PrizeStoresTableUpdateCompanionBuilder,
          (PrizeStore, $$PrizeStoresTableReferences),
          PrizeStore,
          PrefetchHooks Function({bool prizeStoreAppearancesRefs})
        > {
  $$PrizeStoresTableTableManager(_$AppDatabase db, $PrizeStoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrizeStoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrizeStoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrizeStoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> area = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<bool> isRegistered = const Value.absent(),
                Value<int> createdAtEpochMs = const Value.absent(),
                Value<int> updatedAtEpochMs = const Value.absent(),
              }) => PrizeStoresCompanion(
                id: id,
                name: name,
                area: area,
                address: address,
                sourceUrl: sourceUrl,
                isRegistered: isRegistered,
                createdAtEpochMs: createdAtEpochMs,
                updatedAtEpochMs: updatedAtEpochMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String area,
                Value<String?> address = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<bool> isRegistered = const Value.absent(),
                required int createdAtEpochMs,
                required int updatedAtEpochMs,
              }) => PrizeStoresCompanion.insert(
                id: id,
                name: name,
                area: area,
                address: address,
                sourceUrl: sourceUrl,
                isRegistered: isRegistered,
                createdAtEpochMs: createdAtEpochMs,
                updatedAtEpochMs: updatedAtEpochMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrizeStoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({prizeStoreAppearancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (prizeStoreAppearancesRefs) db.prizeStoreAppearances,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (prizeStoreAppearancesRefs)
                    await $_getPrefetchedData<
                      PrizeStore,
                      $PrizeStoresTable,
                      PrizeStoreAppearance
                    >(
                      currentTable: table,
                      referencedTable: $$PrizeStoresTableReferences
                          ._prizeStoreAppearancesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PrizeStoresTableReferences(
                            db,
                            table,
                            p0,
                          ).prizeStoreAppearancesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.storeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PrizeStoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrizeStoresTable,
      PrizeStore,
      $$PrizeStoresTableFilterComposer,
      $$PrizeStoresTableOrderingComposer,
      $$PrizeStoresTableAnnotationComposer,
      $$PrizeStoresTableCreateCompanionBuilder,
      $$PrizeStoresTableUpdateCompanionBuilder,
      (PrizeStore, $$PrizeStoresTableReferences),
      PrizeStore,
      PrefetchHooks Function({bool prizeStoreAppearancesRefs})
    >;
typedef $$PrizeStoreAppearancesTableCreateCompanionBuilder =
    PrizeStoreAppearancesCompanion Function({
      Value<int> id,
      required int prizeId,
      required int storeId,
      required String appearanceText,
      Value<int?> appearanceDateEpochMs,
      Value<String?> sourceUrl,
      Value<String?> memo,
      required int createdAtEpochMs,
      required int updatedAtEpochMs,
    });
typedef $$PrizeStoreAppearancesTableUpdateCompanionBuilder =
    PrizeStoreAppearancesCompanion Function({
      Value<int> id,
      Value<int> prizeId,
      Value<int> storeId,
      Value<String> appearanceText,
      Value<int?> appearanceDateEpochMs,
      Value<String?> sourceUrl,
      Value<String?> memo,
      Value<int> createdAtEpochMs,
      Value<int> updatedAtEpochMs,
    });

final class $$PrizeStoreAppearancesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PrizeStoreAppearancesTable,
          PrizeStoreAppearance
        > {
  $$PrizeStoreAppearancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PrizeItemsTable _prizeIdTable(_$AppDatabase db) =>
      db.prizeItems.createAlias(
        $_aliasNameGenerator(
          db.prizeStoreAppearances.prizeId,
          db.prizeItems.id,
        ),
      );

  $$PrizeItemsTableProcessedTableManager get prizeId {
    final $_column = $_itemColumn<int>('prize_id')!;

    final manager = $$PrizeItemsTableTableManager(
      $_db,
      $_db.prizeItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_prizeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PrizeStoresTable _storeIdTable(_$AppDatabase db) =>
      db.prizeStores.createAlias(
        $_aliasNameGenerator(
          db.prizeStoreAppearances.storeId,
          db.prizeStores.id,
        ),
      );

  $$PrizeStoresTableProcessedTableManager get storeId {
    final $_column = $_itemColumn<int>('store_id')!;

    final manager = $$PrizeStoresTableTableManager(
      $_db,
      $_db.prizeStores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PrizeStoreAppearancesTableFilterComposer
    extends Composer<_$AppDatabase, $PrizeStoreAppearancesTable> {
  $$PrizeStoreAppearancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appearanceText => $composableBuilder(
    column: $table.appearanceText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get appearanceDateEpochMs => $composableBuilder(
    column: $table.appearanceDateEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  $$PrizeItemsTableFilterComposer get prizeId {
    final $$PrizeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prizeId,
      referencedTable: $db.prizeItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeItemsTableFilterComposer(
            $db: $db,
            $table: $db.prizeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrizeStoresTableFilterComposer get storeId {
    final $$PrizeStoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storeId,
      referencedTable: $db.prizeStores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeStoresTableFilterComposer(
            $db: $db,
            $table: $db.prizeStores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrizeStoreAppearancesTableOrderingComposer
    extends Composer<_$AppDatabase, $PrizeStoreAppearancesTable> {
  $$PrizeStoreAppearancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appearanceText => $composableBuilder(
    column: $table.appearanceText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get appearanceDateEpochMs => $composableBuilder(
    column: $table.appearanceDateEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$PrizeItemsTableOrderingComposer get prizeId {
    final $$PrizeItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prizeId,
      referencedTable: $db.prizeItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeItemsTableOrderingComposer(
            $db: $db,
            $table: $db.prizeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrizeStoresTableOrderingComposer get storeId {
    final $$PrizeStoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storeId,
      referencedTable: $db.prizeStores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeStoresTableOrderingComposer(
            $db: $db,
            $table: $db.prizeStores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrizeStoreAppearancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrizeStoreAppearancesTable> {
  $$PrizeStoreAppearancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get appearanceText => $composableBuilder(
    column: $table.appearanceText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get appearanceDateEpochMs => $composableBuilder(
    column: $table.appearanceDateEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtEpochMs => $composableBuilder(
    column: $table.updatedAtEpochMs,
    builder: (column) => column,
  );

  $$PrizeItemsTableAnnotationComposer get prizeId {
    final $$PrizeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prizeId,
      referencedTable: $db.prizeItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.prizeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrizeStoresTableAnnotationComposer get storeId {
    final $$PrizeStoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storeId,
      referencedTable: $db.prizeStores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrizeStoresTableAnnotationComposer(
            $db: $db,
            $table: $db.prizeStores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PrizeStoreAppearancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrizeStoreAppearancesTable,
          PrizeStoreAppearance,
          $$PrizeStoreAppearancesTableFilterComposer,
          $$PrizeStoreAppearancesTableOrderingComposer,
          $$PrizeStoreAppearancesTableAnnotationComposer,
          $$PrizeStoreAppearancesTableCreateCompanionBuilder,
          $$PrizeStoreAppearancesTableUpdateCompanionBuilder,
          (PrizeStoreAppearance, $$PrizeStoreAppearancesTableReferences),
          PrizeStoreAppearance,
          PrefetchHooks Function({bool prizeId, bool storeId})
        > {
  $$PrizeStoreAppearancesTableTableManager(
    _$AppDatabase db,
    $PrizeStoreAppearancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrizeStoreAppearancesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PrizeStoreAppearancesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PrizeStoreAppearancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> prizeId = const Value.absent(),
                Value<int> storeId = const Value.absent(),
                Value<String> appearanceText = const Value.absent(),
                Value<int?> appearanceDateEpochMs = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int> createdAtEpochMs = const Value.absent(),
                Value<int> updatedAtEpochMs = const Value.absent(),
              }) => PrizeStoreAppearancesCompanion(
                id: id,
                prizeId: prizeId,
                storeId: storeId,
                appearanceText: appearanceText,
                appearanceDateEpochMs: appearanceDateEpochMs,
                sourceUrl: sourceUrl,
                memo: memo,
                createdAtEpochMs: createdAtEpochMs,
                updatedAtEpochMs: updatedAtEpochMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int prizeId,
                required int storeId,
                required String appearanceText,
                Value<int?> appearanceDateEpochMs = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                required int createdAtEpochMs,
                required int updatedAtEpochMs,
              }) => PrizeStoreAppearancesCompanion.insert(
                id: id,
                prizeId: prizeId,
                storeId: storeId,
                appearanceText: appearanceText,
                appearanceDateEpochMs: appearanceDateEpochMs,
                sourceUrl: sourceUrl,
                memo: memo,
                createdAtEpochMs: createdAtEpochMs,
                updatedAtEpochMs: updatedAtEpochMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrizeStoreAppearancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({prizeId = false, storeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (prizeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.prizeId,
                                referencedTable:
                                    $$PrizeStoreAppearancesTableReferences
                                        ._prizeIdTable(db),
                                referencedColumn:
                                    $$PrizeStoreAppearancesTableReferences
                                        ._prizeIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (storeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.storeId,
                                referencedTable:
                                    $$PrizeStoreAppearancesTableReferences
                                        ._storeIdTable(db),
                                referencedColumn:
                                    $$PrizeStoreAppearancesTableReferences
                                        ._storeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PrizeStoreAppearancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrizeStoreAppearancesTable,
      PrizeStoreAppearance,
      $$PrizeStoreAppearancesTableFilterComposer,
      $$PrizeStoreAppearancesTableOrderingComposer,
      $$PrizeStoreAppearancesTableAnnotationComposer,
      $$PrizeStoreAppearancesTableCreateCompanionBuilder,
      $$PrizeStoreAppearancesTableUpdateCompanionBuilder,
      (PrizeStoreAppearance, $$PrizeStoreAppearancesTableReferences),
      PrizeStoreAppearance,
      PrefetchHooks Function({bool prizeId, bool storeId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PrizeItemsTableTableManager get prizeItems =>
      $$PrizeItemsTableTableManager(_db, _db.prizeItems);
  $$PrizeAcquisitionLogsTableTableManager get prizeAcquisitionLogs =>
      $$PrizeAcquisitionLogsTableTableManager(_db, _db.prizeAcquisitionLogs);
  $$PrizeStoresTableTableManager get prizeStores =>
      $$PrizeStoresTableTableManager(_db, _db.prizeStores);
  $$PrizeStoreAppearancesTableTableManager get prizeStoreAppearances =>
      $$PrizeStoreAppearancesTableTableManager(_db, _db.prizeStoreAppearances);
}
