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
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color.fromRGBO(2, 14, 38, 1);
    const darkBlueSurface = Color(0xFF061633);
    const darkBlueContainer = Color(0xFF0B2447);
    const blueAccent = Color(0xFF7DB7FF);

    return MaterialApp(
      title: 'FigureList',
      theme: ThemeData(
        scaffoldBackgroundColor: darkBlue,
        cardTheme: const CardThemeData(
          color: darkBlueSurface,
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkBlue,
          foregroundColor: Color(0xFFEAF2FF),
          surfaceTintColor: Colors.transparent,
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: darkBlueContainer,
          selectedColor: Color(0xFF1B4F8F),
          secondarySelectedColor: Color(0xFF1B4F8F),
          labelStyle: TextStyle(color: Color(0xFFEAF2FF)),
          secondaryLabelStyle: TextStyle(color: Color(0xFFEAF2FF)),
          side: BorderSide(color: Color(0xFF2D5E9E)),
        ),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: blueAccent,
              brightness: Brightness.dark,
            ).copyWith(
              surface: darkBlue,
              surfaceContainer: darkBlueSurface,
              surfaceContainerHighest: darkBlueContainer,
              primary: blueAccent,
              secondary: const Color(0xFF9CC9FF),
              outline: const Color(0xFF8DAED9),
              outlineVariant: const Color(0xFF31547F),
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
