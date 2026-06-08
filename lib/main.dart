import 'dart:async';

import 'package:flutter/material.dart';

import 'data/app_database.dart';
import 'prizes/prize_list_page.dart';
import 'prizes/prize_notification_service.dart';
import 'prizes/prize_repository.dart';
import 'server/server_sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = PrizeNotificationService();
  await notificationService.initialize();
  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.notificationService});

  final PrizeNotificationService notificationService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppDatabase _database;
  late final PrizeRepository _repository;
  late final ServerSyncService _serverSyncService;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _repository = PrizeRepository(_database);
    _serverSyncService = ServerSyncService(_database);
    unawaited(_restoreServerSession());
  }

  Future<void> _restoreServerSession() async {
    final restored = await _serverSyncService.restoreSession();
    if (restored) {
      await _serverSyncService.syncFromServer();
    }
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF151518);
    const paper = Color(0xFFFAFAFB);
    const panel = Color(0xFFFFFFFF);
    const subtle = Color(0xFFF4F4F5);
    const accent = Color(0xFFFFC83D);

    return MaterialApp(
      title: 'FigureList',
      theme: ThemeData(
        scaffoldBackgroundColor: paper,
        cardTheme: const CardThemeData(
          color: panel,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: Color(0xFFE3E3E6)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: panel,
          foregroundColor: ink,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: subtle,
          selectedColor: Color(0xFFE8E8EA),
          secondarySelectedColor: Color(0xFFE8E8EA),
          labelStyle: TextStyle(color: ink),
          secondaryLabelStyle: TextStyle(color: ink),
          side: BorderSide(color: Color(0xFFE0E0E3)),
        ),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: accent,
              brightness: Brightness.light,
            ).copyWith(
              surface: paper,
              surfaceContainer: panel,
              surfaceContainerHighest: subtle,
              primary: ink,
              secondary: const Color(0xFF936411),
              outline: const Color(0xFFCFCFD3),
              outlineVariant: const Color(0xFFE7E7EA),
            ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE7E7EA),
          thickness: 1,
          space: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFE1E1E4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFE1E1E4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF151518)),
          ),
        ),
        useMaterial3: true,
      ),
      home: PrizeListPage(
        repository: _repository,
        notificationService: widget.notificationService,
        serverSyncService: _serverSyncService,
      ),
    );
  }
}
