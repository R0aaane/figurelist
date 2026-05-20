import 'package:drift/drift.dart';

import 'database_connection.dart';

part 'app_database.g.dart';

class PrizeStatus {
  static const unowned = 'unowned';
  static const owned = 'owned';
  static const reserved = 'reserved';
  static const skipped = 'skipped';

  static const values = [unowned, owned, reserved, skipped];

  static String label(String status) {
    return switch (status) {
      owned => '\u7372\u5f97\u6e08\u307f',
      reserved => '\u7372\u5f97\u4e88\u5b9a',
      skipped => '\u898b\u9001\u308a',
      _ => '\u672a\u7372\u5f97',
    };
  }
}

class PrizeItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get workTitle => text()();
  TextColumn get characterName => text()();
  TextColumn get seriesName => text()();
  TextColumn get maker => text()();
  TextColumn get releaseText => text()();
  IntColumn get releaseYear => integer().nullable()();
  IntColumn get releaseMonth => integer().nullable()();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant(PrizeStatus.unowned))();
  TextColumn get memo => text().nullable()();
  IntColumn get acquiredAtEpochMs => integer().nullable()();
  IntColumn get createdAtEpochMs => integer()();
  IntColumn get updatedAtEpochMs => integer()();
}

class PrizeAcquisitionLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get prizeId =>
      integer().references(PrizeItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get method => text().nullable()();
  TextColumn get place => text().nullable()();
  IntColumn get costYen => integer().nullable()();
  TextColumn get memo => text().nullable()();
  IntColumn get createdAtEpochMs => integer()();
}

class PrizeStores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get area => text()();
  TextColumn get address => text().nullable()();
  TextColumn get sourceUrl => text().nullable()();
  BoolColumn get isRegistered => boolean().withDefault(const Constant(false))();
  IntColumn get createdAtEpochMs => integer()();
  IntColumn get updatedAtEpochMs => integer()();
}

class PrizeStoreAppearances extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get prizeId =>
      integer().references(PrizeItems, #id, onDelete: KeyAction.cascade)();
  IntColumn get storeId =>
      integer().references(PrizeStores, #id, onDelete: KeyAction.cascade)();
  TextColumn get appearanceText => text()();
  IntColumn get appearanceDateEpochMs => integer().nullable()();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get memo => text().nullable()();
  IntColumn get createdAtEpochMs => integer()();
  IntColumn get updatedAtEpochMs => integer()();
}

@DriftDatabase(
  tables: [
    PrizeItems,
    PrizeAcquisitionLogs,
    PrizeStores,
    PrizeStoreAppearances,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? openDatabaseConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async => m.createAll(),
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(prizeStores);
          await m.createTable(prizeStoreAppearances);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
