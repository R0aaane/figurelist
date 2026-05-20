import 'package:drift/drift.dart';

import '../data/app_database.dart';
import 'prize_source.dart';
import 'prize_store_source.dart';

class PrizeRepository {
  PrizeRepository(
    this._database, {
    PrizeSource? source,
    PrizeStoreSource? storeSource,
  }) : _source = source ?? const SamplePrizeSource(),
       _storeSource = storeSource ?? const NagoyaPrizeStoreSource();

  final AppDatabase _database;
  final PrizeSource _source;
  final PrizeStoreSource _storeSource;

  Stream<List<PrizeItem>> listPrizes({
    String? status,
    String? characterQuery,
    String? seriesQuery,
    int? registeredStoreId,
  }) {
    final query = _database.select(_database.prizeItems);

    if (status != null) {
      query.where((t) => t.status.equals(status));
    }
    final trimmedCharacter = characterQuery?.trim();
    if (trimmedCharacter != null && trimmedCharacter.isNotEmpty) {
      query.where((t) => t.characterName.like('%$trimmedCharacter%'));
    }
    final trimmedSeries = seriesQuery?.trim();
    if (trimmedSeries != null && trimmedSeries.isNotEmpty) {
      query.where((t) => t.seriesName.like('%$trimmedSeries%'));
    }
    if (registeredStoreId != null) {
      final appearanceSubquery = _database.selectOnly(
        _database.prizeStoreAppearances,
      )..addColumns([_database.prizeStoreAppearances.prizeId]);
      appearanceSubquery.where(
        _database.prizeStoreAppearances.storeId.equals(registeredStoreId),
      );
      query.where((t) => t.id.isInQuery(appearanceSubquery));
    }
    query.orderBy([
      (t) => OrderingTerm(
        expression: t.releaseYear,
        mode: OrderingMode.desc,
        nulls: NullsOrder.last,
      ),
      (t) => OrderingTerm(
        expression: t.releaseMonth,
        mode: OrderingMode.desc,
        nulls: NullsOrder.last,
      ),
      (t) =>
          OrderingTerm(expression: t.updatedAtEpochMs, mode: OrderingMode.desc),
    ]);

    return query.watch();
  }

  Stream<List<String>> watchCharacterNames() {
    final query = _database.selectOnly(_database.prizeItems, distinct: true)
      ..addColumns([_database.prizeItems.characterName])
      ..orderBy([OrderingTerm(expression: _database.prizeItems.characterName)]);
    return query.watch().map((rows) {
      return [
        for (final row in rows) ?row.read(_database.prizeItems.characterName),
      ];
    });
  }

  Stream<List<String>> watchSeriesNames() {
    final query = _database.selectOnly(_database.prizeItems, distinct: true)
      ..addColumns([_database.prizeItems.seriesName])
      ..orderBy([OrderingTerm(expression: _database.prizeItems.seriesName)]);
    return query.watch().map((rows) {
      return [
        for (final row in rows) ?row.read(_database.prizeItems.seriesName),
      ];
    });
  }

  Stream<List<PrizeStoreAppearanceEntry>> watchAppearancesForStore(
    int storeId,
  ) {
    final query = _database.select(_database.prizeStoreAppearances).join([
      innerJoin(
        _database.prizeStores,
        _database.prizeStores.id.equalsExp(
          _database.prizeStoreAppearances.storeId,
        ),
      ),
    ])..where(_database.prizeStoreAppearances.storeId.equals(storeId));

    return query.watch().map((rows) {
      return [
        for (final row in rows)
          PrizeStoreAppearanceEntry(
            appearance: row.readTable(_database.prizeStoreAppearances),
            store: row.readTable(_database.prizeStores),
          ),
      ];
    });
  }

  Stream<List<PrizeItem>> listWantedPrizes() {
    return listPrizes(status: PrizeStatus.unowned);
  }

  Stream<List<PrizeItem>> listOwnedPrizes() {
    return listPrizes(status: PrizeStatus.owned);
  }

  Future<List<PrizeItem>> upsertFromSource({PrizeSource? source}) async {
    final items = await (source ?? _source).fetchItems();
    final savedItems = <PrizeItem>[];
    final now = DateTime.now().millisecondsSinceEpoch;

    await _database.transaction(() async {
      for (final item in items) {
        final existing = await _findExistingSourceItem(item);
        if (existing == null) {
          final id = await _database
              .into(_database.prizeItems)
              .insert(_companionForInsert(item, now));
          savedItems.add(await getPrize(id));
        } else {
          await (_database.update(_database.prizeItems)
                ..where((t) => t.id.equals(existing.id)))
              .write(_companionForSourceUpdate(item, now));
          savedItems.add(await getPrize(existing.id));
        }
      }
    });

    return savedItems;
  }

  Future<PrizeItem> addManualPrize({
    required String title,
    String? workTitle,
    String? characterName,
    String? seriesName,
    String? maker,
    String? releaseText,
    String? sourceUrl,
    String? imageUrl,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = await _database
        .into(_database.prizeItems)
        .insert(
          PrizeItemsCompanion.insert(
            title: title.trim(),
            workTitle: _blankToNull(workTitle) ?? title.trim(),
            characterName: _blankToNull(characterName) ?? title.trim(),
            seriesName: _blankToNull(seriesName) ?? '手動追加',
            maker: _blankToNull(maker) ?? '未設定',
            releaseText: _blankToNull(releaseText) ?? '未設定',
            sourceUrl: Value(_blankToNull(sourceUrl)),
            imageUrl: Value(_blankToNull(imageUrl)),
            createdAtEpochMs: now,
            updatedAtEpochMs: now,
          ),
        );
    return getPrize(id);
  }

  Future<PrizeItem> getPrize(int id) async {
    return (_database.select(
      _database.prizeItems,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Stream<PrizeItem> watchPrize(int id) {
    return (_database.select(
      _database.prizeItems,
    )..where((t) => t.id.equals(id))).watchSingle();
  }

  Stream<List<PrizeAcquisitionLog>> watchAcquisitionLogs(int prizeId) {
    final query = _database.select(_database.prizeAcquisitionLogs)
      ..where((t) => t.prizeId.equals(prizeId))
      ..orderBy([
        (t) => OrderingTerm(
          expression: t.createdAtEpochMs,
          mode: OrderingMode.desc,
        ),
      ]);
    return query.watch();
  }

  Future<void> updateStatus(int id, String status) async {
    if (!PrizeStatus.values.contains(status)) {
      throw ArgumentError.value(status, 'status', 'Unknown prize status');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_database.update(
      _database.prizeItems,
    )..where((t) => t.id.equals(id))).write(
      PrizeItemsCompanion(
        status: Value(status),
        acquiredAtEpochMs: Value(status == PrizeStatus.owned ? now : null),
        updatedAtEpochMs: Value(now),
      ),
    );
  }

  Future<void> updateStoreAppearanceManual({
    required int appearanceId,
    required DateTime? appearanceDate,
    required String appearanceText,
    String? memo,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_database.update(
      _database.prizeStoreAppearances,
    )..where((t) => t.id.equals(appearanceId))).write(
      PrizeStoreAppearancesCompanion(
        appearanceText: Value(appearanceText.trim()),
        appearanceDateEpochMs: Value(appearanceDate?.millisecondsSinceEpoch),
        memo: Value(_blankToNull(memo)),
        updatedAtEpochMs: Value(now),
      ),
    );
  }

  Future<void> markOwned(
    int id, {
    String? method,
    String? place,
    int? costYen,
    String? memo,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _database.transaction(() async {
      await (_database.update(
        _database.prizeItems,
      )..where((t) => t.id.equals(id))).write(
        PrizeItemsCompanion(
          status: const Value(PrizeStatus.owned),
          acquiredAtEpochMs: Value(now),
          updatedAtEpochMs: Value(now),
        ),
      );
      if (_hasLogContent(
        method: method,
        place: place,
        costYen: costYen,
        memo: memo,
      )) {
        await addAcquisitionLog(
          id,
          method: method,
          place: place,
          costYen: costYen,
          memo: memo,
          createdAtEpochMs: now,
        );
      }
    });
  }

  Future<void> updateMemo(int id, String? memo) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_database.update(
      _database.prizeItems,
    )..where((t) => t.id.equals(id))).write(
      PrizeItemsCompanion(
        memo: Value(memo?.trim().isEmpty ?? true ? null : memo?.trim()),
        updatedAtEpochMs: Value(now),
      ),
    );
  }

  Future<int> addAcquisitionLog(
    int prizeId, {
    String? method,
    String? place,
    int? costYen,
    String? memo,
    int? createdAtEpochMs,
  }) {
    final createdAt = createdAtEpochMs ?? DateTime.now().millisecondsSinceEpoch;
    return _database
        .into(_database.prizeAcquisitionLogs)
        .insert(
          PrizeAcquisitionLogsCompanion.insert(
            prizeId: prizeId,
            method: Value(_blankToNull(method)),
            place: Value(_blankToNull(place)),
            costYen: Value(costYen),
            memo: Value(_blankToNull(memo)),
            createdAtEpochMs: createdAt,
          ),
        );
  }

  Future<int> deletePrize(int id) {
    return (_database.delete(
      _database.prizeItems,
    )..where((t) => t.id.equals(id))).go();
  }

  Stream<List<PrizeStore>> listStores({bool registeredOnly = false}) {
    final query = _database.select(_database.prizeStores)
      ..orderBy([
        (t) =>
            OrderingTerm(expression: t.isRegistered, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.area),
        (t) => OrderingTerm(expression: t.name),
      ]);
    if (registeredOnly) {
      query.where((t) => t.isRegistered.equals(true));
    }
    return query.watch();
  }

  Future<List<PrizeStore>> upsertStoresFromSource({
    PrizeStoreSource? source,
  }) async {
    final stores = await (source ?? _storeSource).fetchStores();
    final savedStores = <PrizeStore>[];
    final now = DateTime.now().millisecondsSinceEpoch;

    await _database.transaction(() async {
      for (final store in stores) {
        final existing = await _findExistingStore(store);
        if (existing == null) {
          final id = await _database
              .into(_database.prizeStores)
              .insert(_storeCompanionForInsert(store, now));
          savedStores.add(await _getStore(id));
        } else {
          await (_database.update(_database.prizeStores)
                ..where((t) => t.id.equals(existing.id)))
              .write(_storeCompanionForSourceUpdate(store, now));
          savedStores.add(await _getStore(existing.id));
        }
      }
    });

    return savedStores;
  }

  Future<void> updateStoreRegistration(int storeId, bool isRegistered) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_database.update(
      _database.prizeStores,
    )..where((t) => t.id.equals(storeId))).write(
      PrizeStoresCompanion(
        isRegistered: Value(isRegistered),
        updatedAtEpochMs: Value(now),
      ),
    );
    if (isRegistered) {
      await syncStoreAppearances();
    }
  }

  Future<List<PrizeStoreAppearance>> syncStoreAppearances({
    PrizeStoreSource? source,
  }) async {
    final prizes = await _database.select(_database.prizeItems).get();
    final stores = await _database.select(_database.prizeStores).get();
    final appearances = await (source ?? _storeSource).fetchAppearances(
      prizes: prizes,
      stores: stores,
    );
    final savedAppearances = <PrizeStoreAppearance>[];
    final now = DateTime.now().millisecondsSinceEpoch;

    await _database.transaction(() async {
      for (final appearance in appearances) {
        final existing = await _findExistingAppearance(appearance);
        if (existing == null) {
          final id = await _database
              .into(_database.prizeStoreAppearances)
              .insert(_appearanceCompanionForInsert(appearance, now));
          savedAppearances.add(await _getAppearance(id));
        } else {
          await (_database.update(_database.prizeStoreAppearances)
                ..where((t) => t.id.equals(existing.id)))
              .write(_appearanceCompanionForUpdate(appearance, now));
          savedAppearances.add(await _getAppearance(existing.id));
        }
      }
    });

    return savedAppearances;
  }

  Stream<List<PrizeStoreAppearanceEntry>> watchStoreAppearancesForPrize(
    int prizeId,
  ) {
    final query =
        _database.select(_database.prizeStoreAppearances).join([
            innerJoin(
              _database.prizeStores,
              _database.prizeStores.id.equalsExp(
                _database.prizeStoreAppearances.storeId,
              ),
            ),
          ])
          ..where(_database.prizeStoreAppearances.prizeId.equals(prizeId))
          ..where(_database.prizeStores.isRegistered.equals(true))
          ..orderBy([
            OrderingTerm(expression: _database.prizeStores.area),
            OrderingTerm(expression: _database.prizeStores.name),
          ]);

    return query.watch().map((rows) {
      return [
        for (final row in rows)
          PrizeStoreAppearanceEntry(
            appearance: row.readTable(_database.prizeStoreAppearances),
            store: row.readTable(_database.prizeStores),
          ),
      ];
    });
  }

  Future<List<PrizeArrivalNotificationTarget>>
  listArrivalNotificationTargets() async {
    final query =
        _database.select(_database.prizeStoreAppearances).join([
            innerJoin(
              _database.prizeItems,
              _database.prizeItems.id.equalsExp(
                _database.prizeStoreAppearances.prizeId,
              ),
            ),
            innerJoin(
              _database.prizeStores,
              _database.prizeStores.id.equalsExp(
                _database.prizeStoreAppearances.storeId,
              ),
            ),
          ])
          ..where(_database.prizeItems.status.equals(PrizeStatus.reserved))
          ..where(_database.prizeStores.isRegistered.equals(true))
          ..where(
            _database.prizeStoreAppearances.appearanceDateEpochMs.isNotNull(),
          );

    final rows = await query.get();
    return [
      for (final row in rows)
        PrizeArrivalNotificationTarget(
          prize: row.readTable(_database.prizeItems),
          store: row.readTable(_database.prizeStores),
          appearance: row.readTable(_database.prizeStoreAppearances),
        ),
    ];
  }

  Future<PrizeItem?> _findExistingSourceItem(PrizeSourceItem item) async {
    if (item.sourceUrl != null && item.sourceUrl!.trim().isNotEmpty) {
      final byUrl =
          await (_database.select(_database.prizeItems)
                ..where((t) => t.sourceUrl.equals(item.sourceUrl!.trim()))
                ..limit(1))
              .getSingleOrNull();
      if (byUrl != null) {
        return byUrl;
      }
    }

    return (_database.select(_database.prizeItems)
          ..where(
            (t) => t.title.equals(item.title) & t.maker.equals(item.maker),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  PrizeItemsCompanion _companionForInsert(PrizeSourceItem item, int now) {
    return PrizeItemsCompanion.insert(
      title: item.title,
      workTitle: item.workTitle,
      characterName: item.characterName,
      seriesName: item.seriesName,
      maker: item.maker,
      releaseText: item.releaseText,
      releaseYear: Value(item.releaseYear),
      releaseMonth: Value(item.releaseMonth),
      sourceUrl: Value(_blankToNull(item.sourceUrl)),
      imageUrl: Value(_blankToNull(item.imageUrl)),
      createdAtEpochMs: now,
      updatedAtEpochMs: now,
    );
  }

  PrizeItemsCompanion _companionForSourceUpdate(PrizeSourceItem item, int now) {
    return PrizeItemsCompanion(
      title: Value(item.title),
      workTitle: Value(item.workTitle),
      characterName: Value(item.characterName),
      seriesName: Value(item.seriesName),
      maker: Value(item.maker),
      releaseText: Value(item.releaseText),
      releaseYear: Value(item.releaseYear),
      releaseMonth: Value(item.releaseMonth),
      sourceUrl: Value(_blankToNull(item.sourceUrl)),
      imageUrl: Value(_blankToNull(item.imageUrl)),
      updatedAtEpochMs: Value(now),
    );
  }

  bool _hasLogContent({
    String? method,
    String? place,
    int? costYen,
    String? memo,
  }) {
    return _blankToNull(method) != null ||
        _blankToNull(place) != null ||
        costYen != null ||
        _blankToNull(memo) != null;
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  Future<PrizeStore> _getStore(int id) {
    return (_database.select(
      _database.prizeStores,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<PrizeStoreAppearance> _getAppearance(int id) {
    return (_database.select(
      _database.prizeStoreAppearances,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<PrizeStore?> _findExistingStore(PrizeStoreSourceItem store) async {
    if (store.sourceUrl != null && store.sourceUrl!.trim().isNotEmpty) {
      final byUrl =
          await (_database.select(_database.prizeStores)
                ..where((t) => t.sourceUrl.equals(store.sourceUrl!.trim()))
                ..limit(1))
              .getSingleOrNull();
      if (byUrl != null) {
        return byUrl;
      }
    }

    return (_database.select(_database.prizeStores)
          ..where((t) => t.name.equals(store.name) & t.area.equals(store.area))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<PrizeStoreAppearance?> _findExistingAppearance(
    PrizeStoreAppearanceSourceItem appearance,
  ) {
    return (_database.select(_database.prizeStoreAppearances)..where(
          (t) =>
              t.prizeId.equals(appearance.prizeId) &
              t.storeId.equals(appearance.storeId),
        )..limit(1))
        .getSingleOrNull();
  }

  PrizeStoresCompanion _storeCompanionForInsert(
    PrizeStoreSourceItem store,
    int now,
  ) {
    return PrizeStoresCompanion.insert(
      name: store.name,
      area: store.area,
      address: Value(_blankToNull(store.address)),
      sourceUrl: Value(_blankToNull(store.sourceUrl)),
      createdAtEpochMs: now,
      updatedAtEpochMs: now,
    );
  }

  PrizeStoresCompanion _storeCompanionForSourceUpdate(
    PrizeStoreSourceItem store,
    int now,
  ) {
    return PrizeStoresCompanion(
      name: Value(store.name),
      area: Value(store.area),
      address: Value(_blankToNull(store.address)),
      sourceUrl: Value(_blankToNull(store.sourceUrl)),
      updatedAtEpochMs: Value(now),
    );
  }

  PrizeStoreAppearancesCompanion _appearanceCompanionForInsert(
    PrizeStoreAppearanceSourceItem appearance,
    int now,
  ) {
    return PrizeStoreAppearancesCompanion.insert(
      prizeId: appearance.prizeId,
      storeId: appearance.storeId,
      appearanceText: appearance.appearanceText,
      appearanceDateEpochMs: Value(appearance.appearanceDateEpochMs),
      sourceUrl: Value(_blankToNull(appearance.sourceUrl)),
      memo: Value(_blankToNull(appearance.memo)),
      createdAtEpochMs: now,
      updatedAtEpochMs: now,
    );
  }

  PrizeStoreAppearancesCompanion _appearanceCompanionForUpdate(
    PrizeStoreAppearanceSourceItem appearance,
    int now,
  ) {
    return PrizeStoreAppearancesCompanion(
      appearanceText: Value(appearance.appearanceText),
      appearanceDateEpochMs: Value(appearance.appearanceDateEpochMs),
      sourceUrl: Value(_blankToNull(appearance.sourceUrl)),
      memo: Value(_blankToNull(appearance.memo)),
      updatedAtEpochMs: Value(now),
    );
  }
}

class PrizeStoreAppearanceEntry {
  const PrizeStoreAppearanceEntry({
    required this.appearance,
    required this.store,
  });

  final PrizeStoreAppearance appearance;
  final PrizeStore store;
}

class PrizeArrivalNotificationTarget {
  const PrizeArrivalNotificationTarget({
    required this.prize,
    required this.store,
    required this.appearance,
  });

  final PrizeItem prize;
  final PrizeStore store;
  final PrizeStoreAppearance appearance;
}
