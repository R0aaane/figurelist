import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_database.dart';
import 'prize_notification_service.dart';
import 'prize_repository.dart';
import 'prize_status_chip.dart';

class PrizeDetailPage extends StatefulWidget {
  const PrizeDetailPage({
    super.key,
    required this.repository,
    required this.notificationService,
    required this.prizeId,
  });

  final PrizeRepository repository;
  final PrizeNotificationService notificationService;
  final int prizeId;

  @override
  State<PrizeDetailPage> createState() => _PrizeDetailPageState();
}

class _PrizeDetailPageState extends State<PrizeDetailPage> {
  final _memoController = TextEditingController();
  bool _memoInitialized = false;

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _openOfficialUrl(String? sourceUrl) async {
    if (sourceUrl == null || sourceUrl.isEmpty) {
      return;
    }
    final uri = Uri.tryParse(sourceUrl);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PrizeItem>(
      stream: widget.repository.watchPrize(widget.prizeId),
      builder: (context, snapshot) {
        final prize = snapshot.data;
        if (prize == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!_memoInitialized) {
          _memoController.text = prize.memo ?? '';
          _memoInitialized = true;
        }

        return Scaffold(
          appBar: AppBar(title: Text(prize.characterName)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _BoxImage(url: prize.imageUrl),
              const SizedBox(height: 16),
              Text(prize.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PrizeStatusChip(status: prize.status),
                  Chip(label: Text(prize.maker)),
                  Chip(label: Text(prize.releaseText)),
                  Chip(label: Text(prize.seriesName)),
                ],
              ),
              const SizedBox(height: 16),
              _InfoRow(label: '\u4f5c\u54c1', value: prize.workTitle),
              _InfoRow(
                label: '\u30ad\u30e3\u30e9\u30af\u30bf\u30fc',
                value: prize.characterName,
              ),
              _InfoRow(
                label: '\u30b7\u30ea\u30fc\u30ba',
                value: prize.seriesName,
              ),
              if (prize.releaseYear != null || prize.releaseMonth != null)
                _InfoRow(
                  label: '\u767a\u58f2\u5e74\u6708',
                  value:
                      '${prize.releaseYear ?? '-'}\u5e74${prize.releaseMonth ?? '-'}\u6708',
                ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: prize.status == PrizeStatus.owned
                        ? null
                        : () async {
                            await widget.repository.markOwned(prize.id);
                            await widget.notificationService
                                .rescheduleArrivalNotifications(
                                  widget.repository,
                                );
                          },
                    icon: const Icon(Icons.check),
                    label: const Text(
                      '\u7372\u5f97\u6e08\u307f\u306b\u3059\u308b',
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: prize.status == PrizeStatus.unowned
                        ? null
                        : () async {
                            await widget.repository.updateStatus(
                              prize.id,
                              PrizeStatus.unowned,
                            );
                            await widget.notificationService
                                .rescheduleArrivalNotifications(
                                  widget.repository,
                                );
                          },
                    icon: const Icon(Icons.undo),
                    label: const Text('\u672a\u7372\u5f97\u306b\u623b\u3059'),
                  ),
                  OutlinedButton.icon(
                    onPressed: prize.sourceUrl == null
                        ? null
                        : () => _openOfficialUrl(prize.sourceUrl),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('\u516c\u5f0fURL\u3092\u958b\u304f'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: prize.status,
                decoration: const InputDecoration(
                  labelText: '\u72b6\u614b',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: PrizeStatus.unowned,
                    child: Text('\u672a\u7372\u5f97'),
                  ),
                  DropdownMenuItem(
                    value: PrizeStatus.owned,
                    child: Text('\u7372\u5f97\u6e08\u307f'),
                  ),
                  DropdownMenuItem(
                    value: PrizeStatus.reserved,
                    child: Text('\u7372\u5f97\u4e88\u5b9a'),
                  ),
                  DropdownMenuItem(
                    value: PrizeStatus.skipped,
                    child: Text('\u898b\u9001\u308a'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    widget.repository.updateStatus(prize.id, value).then((_) {
                      widget.notificationService.rescheduleArrivalNotifications(
                        widget.repository,
                      );
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _memoController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: '\u30e1\u30e2',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () => widget.repository.updateMemo(
                    prize.id,
                    _memoController.text,
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('\u30e1\u30e2\u3092\u4fdd\u5b58'),
                ),
              ),
              const Divider(height: 32),
              Text(
                '\u767b\u9332\u5e97\u8217\u3067\u306e\u767b\u5834\u4e88\u5b9a',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _StoreAppearanceList(
                repository: widget.repository,
                notificationService: widget.notificationService,
                prizeId: prize.id,
              ),
              const Divider(height: 32),
              Text(
                '\u7372\u5f97\u30ed\u30b0',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _LogList(repository: widget.repository, prizeId: prize.id),
            ],
          ),
        );
      },
    );
  }
}

class _BoxImage extends StatelessWidget {
  const _BoxImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: Theme.of(context).colorScheme.outline,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('\u7bb1\u753b\u50cf', style: labelStyle),
        const SizedBox(height: 6),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: url == null || url!.isEmpty
                ? Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.inventory_2_outlined, size: 48),
                  )
                : Image.network(
                    url!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _StoreAppearanceList extends StatelessWidget {
  const _StoreAppearanceList({
    required this.repository,
    required this.notificationService,
    required this.prizeId,
  });

  final PrizeRepository repository;
  final PrizeNotificationService notificationService;
  final int prizeId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PrizeStoreAppearanceEntry>>(
      stream: repository.watchStoreAppearancesForPrize(prizeId),
      builder: (context, snapshot) {
        final entries = snapshot.data ?? const [];
        if (entries.isEmpty) {
          return const Text(
            '\u767b\u9332\u5e97\u8217\u304c\u306a\u3044\u304b\u3001\u767b\u5834\u4e88\u5b9a\u304c\u307e\u3060\u540c\u671f\u3055\u308c\u3066\u3044\u307e\u305b\u3093',
          );
        }
        return Column(
          children: [
            for (final entry in entries)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.storefront),
                title: Text(entry.store.name),
                subtitle: Text(
                  [
                    entry.store.area,
                    entry.appearance.appearanceText,
                    if (entry.appearance.memo != null) entry.appearance.memo!,
                  ].join('\n'),
                ),
                trailing: IconButton(
                  tooltip: '\u5b9f\u5165\u8377\u65e5\u6642\u3092\u7de8\u96c6',
                  icon: const Icon(Icons.edit_calendar),
                  onPressed: () => _editAppearance(context, entry),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _editAppearance(
    BuildContext context,
    PrizeStoreAppearanceEntry entry,
  ) async {
    final currentEpochMs = entry.appearance.appearanceDateEpochMs;
    final currentDate = currentEpochMs == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(currentEpochMs);
    final date = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (date == null || !context.mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDate),
    );
    if (time == null || !context.mounted) {
      return;
    }

    final memoController = TextEditingController(
      text: entry.appearance.memo ?? '',
    );
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('\u5b9f\u5165\u8377\u65e5\u6642\u3092\u4fdd\u5b58'),
          content: TextField(
            controller: memoController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: '\u30e1\u30e2',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('\u30ad\u30e3\u30f3\u30bb\u30eb'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('\u4fdd\u5b58'),
            ),
          ],
        );
      },
    );
    if (shouldSave != true) {
      memoController.dispose();
      return;
    }

    final updatedAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    await repository.updateStoreAppearanceManual(
      appearanceId: entry.appearance.id,
      appearanceDate: updatedAt,
      appearanceText:
          '${_formatDateTime(updatedAt)} / \u624b\u52d5\u5165\u529b',
      memo: memoController.text,
    );
    memoController.dispose();
    await notificationService.rescheduleArrivalNotifications(repository);
  }

  String _formatDateTime(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');
    return '${value.year}/${two(value.month)}/${two(value.day)} ${two(value.hour)}:${two(value.minute)}';
  }
}

class _LogList extends StatelessWidget {
  const _LogList({required this.repository, required this.prizeId});

  final PrizeRepository repository;
  final int prizeId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PrizeAcquisitionLog>>(
      stream: repository.watchAcquisitionLogs(prizeId),
      builder: (context, snapshot) {
        final logs = snapshot.data ?? const [];
        if (logs.isEmpty) {
          return const Text(
            '\u7372\u5f97\u30ed\u30b0\u306f\u307e\u3060\u3042\u308a\u307e\u305b\u3093',
          );
        }
        return Column(
          children: [
            for (final log in logs)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(log.method ?? '\u7372\u5f97'),
                subtitle: Text(
                  [
                    if (log.place != null) log.place,
                    if (log.costYen != null) '${log.costYen}\u5186',
                    if (log.memo != null) log.memo,
                  ].join(' / '),
                ),
              ),
          ],
        );
      },
    );
  }
}
