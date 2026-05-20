import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_database.dart';
import 'prize_notification_service.dart';
import 'prize_repository.dart';

class PrizeStorePage extends StatefulWidget {
  const PrizeStorePage({
    super.key,
    required this.repository,
    required this.notificationService,
  });

  final PrizeRepository repository;
  final PrizeNotificationService notificationService;

  @override
  State<PrizeStorePage> createState() => _PrizeStorePageState();
}

class _PrizeStorePageState extends State<PrizeStorePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.repository.upsertStoresFromSource();
      await widget.repository.syncStoreAppearances();
      await widget.notificationService.rescheduleArrivalNotifications(
        widget.repository,
      );
    });
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) {
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('\u540d\u53e4\u5c4b\u5468\u8fba\u306e\u5e97\u8217'),
        actions: [
          IconButton(
            tooltip: '\u5e97\u8217\u5019\u88dc\u3092\u66f4\u65b0',
            onPressed: () async {
              await widget.repository.upsertStoresFromSource();
              await widget.repository.syncStoreAppearances();
              await widget.notificationService.rescheduleArrivalNotifications(
                widget.repository,
              );
            },
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      body: StreamBuilder<List<PrizeStore>>(
        stream: widget.repository.listStores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final stores = snapshot.data ?? const [];
          if (stores.isEmpty) {
            return const Center(
              child: Text(
                '\u5e97\u8217\u5019\u88dc\u304c\u307e\u3060\u3042\u308a\u307e\u305b\u3093',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final store = stores[index];
              return Card(
                margin: EdgeInsets.zero,
                child: SwitchListTile(
                  value: store.isRegistered,
                  onChanged: (value) async {
                    await widget.repository.updateStoreRegistration(
                      store.id,
                      value,
                    );
                    await widget.notificationService
                        .rescheduleArrivalNotifications(widget.repository);
                  },
                  title: Text(store.name),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      [
                        store.area,
                        if (store.address != null) store.address!,
                        if (store.isRegistered)
                          '\u767b\u9332\u6e08\u307f'
                        else
                          '\u672a\u767b\u9332',
                      ].join(' / '),
                    ),
                  ),
                  secondary: IconButton(
                    tooltip: '\u5e97\u8217\u30da\u30fc\u30b8\u3092\u958b\u304f',
                    onPressed: store.sourceUrl == null
                        ? null
                        : () => _openUrl(store.sourceUrl),
                    icon: const Icon(Icons.open_in_new),
                  ),
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemCount: stores.length,
          );
        },
      ),
    );
  }
}
