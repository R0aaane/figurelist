import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'prize_repository.dart';

class PrizeNotificationService {
  PrizeNotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
      windows: WindowsInitializationSettings(
        appName: 'FigureList',
        appUserModelId: 'FigureList.PrizeCollection',
        guid: '9f2e1191-4527-4f44-b17f-7239bc06df3c',
      ),
    );
    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  Future<void> rescheduleArrivalNotifications(
    PrizeRepository repository,
  ) async {
    await initialize();
    await _cancelArrivalNotifications();
    final targets = await repository.listArrivalNotificationTargets();

    for (final target in targets) {
      final baseId = _notificationBaseId(target.appearance.id);
      await _plugin.cancel(id: baseId);
      await _plugin.cancel(id: baseId + 1);

      final arrivalEpochMs = target.appearance.appearanceDateEpochMs;
      if (arrivalEpochMs == null) {
        continue;
      }
      final arrival = DateTime.fromMillisecondsSinceEpoch(arrivalEpochMs);
      await _scheduleIfFuture(
        id: baseId,
        scheduledAt: DateTime(arrival.year, arrival.month, arrival.day - 1, 18),
        title: '\u660e\u65e5\u5165\u8377\u4e88\u5b9a',
        body:
            '${target.store.name}: ${target.prize.characterName} / ${target.prize.seriesName}',
      );
      await _scheduleIfFuture(
        id: baseId + 1,
        scheduledAt: DateTime(arrival.year, arrival.month, arrival.day, 9),
        title: '\u672c\u65e5\u5165\u8377\u4e88\u5b9a',
        body:
            '${target.store.name}: ${target.prize.characterName} / ${target.prize.seriesName}',
      );
    }
  }

  Future<void> _scheduleIfFuture({
    required int id,
    required DateTime scheduledAt,
    required String title,
    required String body,
  }) async {
    if (!scheduledAt.isAfter(DateTime.now())) {
      return;
    }
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prize_arrivals',
          '\u30d7\u30e9\u30a4\u30ba\u5165\u8377',
          channelDescription:
              '\u7372\u5f97\u4e88\u5b9a\u30d7\u30e9\u30a4\u30ba\u306e\u5165\u8377\u901a\u77e5',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
        windows: WindowsNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  int _notificationBaseId(int appearanceId) => 100000 + appearanceId * 2;

  Future<void> _cancelArrivalNotifications() async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.id >= 100000) {
        await _plugin.cancel(id: request.id);
      }
    }
  }
}
