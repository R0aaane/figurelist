import 'package:drift/native.dart';
import 'package:figurelist/data/app_database.dart';
import 'package:figurelist/prizes/prize_repository.dart';
import 'package:figurelist/prizes/prize_source.dart';
import 'package:figurelist/prizes/prize_store_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late PrizeRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = PrizeRepository(
      database,
      source: const _MutablePrizeSource(),
      storeSource: const _FakePrizeStoreSource(),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('upsertFromSource inserts sample prizes', () async {
    final prizes = await repository.upsertFromSource();

    expect(prizes, hasLength(1));
    expect(prizes.single.status, PrizeStatus.unowned);
    expect(prizes.single.title, 'Sample prize');
  });

  test(
    'default source includes current and past prizes with image urls',
    () async {
      final prizes = await const SamplePrizeSource().fetchItems();

      expect(prizes.length, greaterThan(10));
      expect(prizes.any((prize) => prize.releaseYear == 2025), isTrue);
      expect(prizes.any((prize) => prize.releaseYear == 2026), isTrue);
      expect(
        prizes.every((prize) => prize.imageUrl?.isNotEmpty ?? false),
        isTrue,
      );
    },
  );

  test(
    'upsertFromSource preserves user status, memo, and acquisition logs',
    () async {
      await repository.upsertFromSource();
      final prize = (await repository.listPrizes().first).single;

      await repository.markOwned(
        prize.id,
        method: 'Shop',
        place: 'Akihabara',
        costYen: 1200,
        memo: 'first win',
      );
      await repository.updateMemo(prize.id, 'keep this memo');

      await repository.upsertFromSource(
        source: const _MutablePrizeSource(title: 'Renamed sample prize'),
      );

      final updated = await repository.getPrize(prize.id);
      final logs = await repository.watchAcquisitionLogs(prize.id).first;

      expect(updated.title, 'Renamed sample prize');
      expect(updated.status, PrizeStatus.owned);
      expect(updated.memo, 'keep this memo');
      expect(updated.acquiredAtEpochMs, isNotNull);
      expect(logs.single.costYen, 1200);
    },
  );

  test('deletePrize removes prize and acquisition logs', () async {
    await repository.upsertFromSource();
    final prize = (await repository.listPrizes().first).single;
    await repository.addAcquisitionLog(prize.id, costYen: 500);

    final deletedCount = await repository.deletePrize(prize.id);
    final prizes = await repository.listPrizes().first;
    final logs = await repository.watchAcquisitionLogs(prize.id).first;

    expect(deletedCount, 1);
    expect(prizes, isEmpty);
    expect(logs, isEmpty);
  });

  test(
    'store registration creates appearance estimates for registered stores',
    () async {
      await repository.upsertFromSource();
      final stores = await repository.upsertStoresFromSource();

      expect(stores, isNotEmpty);

      await repository.updateStoreRegistration(stores.first.id, true);
      final prize = (await repository.listPrizes().first).single;
      final appearances = await repository
          .watchStoreAppearancesForPrize(prize.id)
          .first;

      expect(appearances, hasLength(1));
      expect(appearances.single.store.isRegistered, isTrue);
      expect(
        appearances.single.appearance.appearanceText,
        contains('2026-05-20'),
      );
    },
  );

  test(
    'manual store appearance date is editable and becomes notification target',
    () async {
      await repository.upsertFromSource();
      final stores = await repository.upsertStoresFromSource();
      await repository.updateStoreRegistration(stores.first.id, true);
      final prize = (await repository.listPrizes().first).single;
      await repository.updateStatus(prize.id, PrizeStatus.reserved);
      final entry =
          (await repository.watchStoreAppearancesForPrize(prize.id).first)
              .single;
      final arrival = DateTime(2026, 5, 20, 10, 30);

      await repository.updateStoreAppearanceManual(
        appearanceId: entry.appearance.id,
        appearanceDate: arrival,
        appearanceText: '2026/05/20 10:30 / 手動入力',
        memo: 'confirmed by phone',
      );

      final targets = await repository.listArrivalNotificationTargets();

      expect(targets, hasLength(1));
      expect(
        targets.single.appearance.appearanceDateEpochMs,
        arrival.millisecondsSinceEpoch,
      );
      expect(targets.single.appearance.memo, 'confirmed by phone');
    },
  );

  test('arrival snapshot matches a prize by series and character', () {
    const snapshot = StoreArrivalSnapshot(
      storeId: 1,
      entries: [
        StoreArrivalEntry(
          searchableText: 'toloveるdesktopcuteモモ2026年5月20日実入荷',
          appearanceText: '2026年5月20日 / 実入荷',
        ),
      ],
    );
    final prize = PrizeItem(
      id: 1,
      title: 'To LOVEる Desktop Cute フィギュア モモ',
      workTitle: 'To LOVEる',
      characterName: 'モモ',
      seriesName: 'Desktop Cute',
      maker: 'Sample maker',
      releaseText: '2026-05',
      releaseYear: 2026,
      releaseMonth: 5,
      sourceUrl: null,
      imageUrl: null,
      status: PrizeStatus.unowned,
      memo: null,
      acquiredAtEpochMs: null,
      createdAtEpochMs: 1,
      updatedAtEpochMs: 1,
    );

    expect(snapshot.matchPrize(prize)?.appearanceText, contains('実入荷'));
  });
}

class _MutablePrizeSource implements PrizeSource {
  const _MutablePrizeSource({this.title = 'Sample prize'});

  final String title;

  @override
  Future<List<PrizeSourceItem>> fetchItems() async {
    return [
      PrizeSourceItem(
        title: title,
        workTitle: 'Sample work',
        characterName: 'Momo',
        seriesName: 'Sample series',
        maker: 'Sample maker',
        releaseText: '2026-05',
        releaseYear: 2026,
        releaseMonth: 5,
        sourceUrl: 'https://example.com/prize',
      ),
    ];
  }
}

class _FakePrizeStoreSource implements PrizeStoreSource {
  const _FakePrizeStoreSource();

  @override
  Future<List<PrizeStoreSourceItem>> fetchStores() async {
    return const [
      PrizeStoreSourceItem(
        name: 'Sample store',
        area: 'Nagoya',
        sourceUrl: 'https://example.com/store',
      ),
    ];
  }

  @override
  Future<List<PrizeStoreAppearanceSourceItem>> fetchAppearances({
    required List<PrizeItem> prizes,
    required List<PrizeStore> stores,
  }) async {
    return [
      for (final store in stores.where((store) => store.isRegistered))
        for (final prize in prizes)
          PrizeStoreAppearanceSourceItem(
            prizeId: prize.id,
            storeId: store.id,
            appearanceText: '2026-05-20 / 実入荷',
            sourceUrl: store.sourceUrl,
            memo: 'fake actual arrival',
          ),
    ];
  }
}
