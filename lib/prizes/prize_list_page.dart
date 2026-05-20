import 'package:flutter/material.dart';

import '../data/app_database.dart';
import 'prize_detail_page.dart';
import 'prize_notification_service.dart';
import 'prize_repository.dart';
import 'prize_status_chip.dart';
import 'prize_store_page.dart';

class PrizeListPage extends StatefulWidget {
  const PrizeListPage({
    super.key,
    required this.repository,
    required this.notificationService,
  });

  final PrizeRepository repository;
  final PrizeNotificationService notificationService;

  @override
  State<PrizeListPage> createState() => _PrizeListPageState();
}

class _PrizeListPageState extends State<PrizeListPage> {
  final _characterController = TextEditingController();
  final _seriesController = TextEditingController();
  String? _statusFilter;
  int? _storeFilterId;
  _PrizeListDensity _density = _PrizeListDensity.large;

  @override
  void initState() {
    super.initState();
    _characterController.addListener(_refresh);
    _seriesController.addListener(_refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.repository.upsertFromSource();
      await widget.repository.upsertStoresFromSource();
      await widget.repository.syncStoreAppearances();
      await widget.notificationService.rescheduleArrivalNotifications(
        widget.repository,
      );
    });
  }

  @override
  void dispose() {
    _characterController
      ..removeListener(_refresh)
      ..dispose();
    _seriesController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('\u30d7\u30e9\u30a4\u30ba\u53ce\u96c6\u7ba1\u7406'),
        actions: [
          IconButton(
            tooltip: _density == _PrizeListDensity.compact
                ? '\u30ea\u30b9\u30c8\u3092\u5927\u304d\u304f\u8868\u793a'
                : '\u30ea\u30b9\u30c8\u3092\u901a\u5e38\u8868\u793a',
            onPressed: () {
              setState(() {
                _density = _density == _PrizeListDensity.compact
                    ? _PrizeListDensity.large
                    : _PrizeListDensity.compact;
              });
            },
            icon: Icon(
              _density == _PrizeListDensity.compact
                  ? Icons.view_agenda
                  : Icons.view_list,
            ),
          ),
          IconButton(
            tooltip: '\u5e97\u8217\u767b\u9332',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PrizeStorePage(
                    repository: widget.repository,
                    notificationService: widget.notificationService,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.storefront),
          ),
          IconButton(
            tooltip: '\u30b5\u30f3\u30d7\u30eb\u767b\u9332',
            onPressed: () async {
              await widget.repository.upsertFromSource();
              await widget.repository.syncStoreAppearances();
              await widget.notificationService.rescheduleArrivalNotifications(
                widget.repository,
              );
            },
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            repository: widget.repository,
            selectedStatus: _statusFilter,
            selectedStoreId: _storeFilterId,
            onStatusChanged: (value) => setState(() => _statusFilter = value),
            onStoreChanged: (value) => setState(() => _storeFilterId = value),
            characterController: _characterController,
            seriesController: _seriesController,
          ),
          Expanded(
            child: StreamBuilder<List<PrizeItem>>(
              stream: widget.repository.listPrizes(
                status: _statusFilter,
                characterQuery: _characterController.text,
                seriesQuery: _seriesController.text,
                registeredStoreId: _storeFilterId,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final prizes = snapshot.data ?? const [];
                if (prizes.isEmpty) {
                  return const Center(
                    child: Text(
                      '\u8a72\u5f53\u3059\u308b\u30d7\u30e9\u30a4\u30ba\u306f\u3042\u308a\u307e\u305b\u3093',
                    ),
                  );
                }
                return StreamBuilder<List<PrizeStoreAppearanceEntry>>(
                  stream: _storeFilterId == null
                      ? Stream.value(const [])
                      : widget.repository.watchAppearancesForStore(
                          _storeFilterId!,
                        ),
                  builder: (context, appearanceSnapshot) {
                    final appearancesByPrizeId = {
                      for (final entry in appearanceSnapshot.data ?? const [])
                        entry.appearance.prizeId: entry,
                    };
                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final prize = prizes[index];
                        return _PrizeTile(
                          prize: prize,
                          appearance: appearancesByPrizeId[prize.id],
                          density: _density,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => PrizeDetailPage(
                                  repository: widget.repository,
                                  notificationService:
                                      widget.notificationService,
                                  prizeId: prize.id,
                                ),
                              ),
                            );
                          },
                          onStatusSelected: (status) async {
                            await widget.repository.updateStatus(
                              prize.id,
                              status,
                            );
                            await widget.notificationService
                                .rescheduleArrivalNotifications(
                                  widget.repository,
                                );
                          },
                          onDeleteSelected: () => _confirmDelete(prize),
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemCount: prizes.length,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(PrizeItem prize) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('\u30d7\u30e9\u30a4\u30ba\u3092\u524a\u9664'),
          content: Text(
            '${prize.title}\n\n'
            '\u3053\u306e\u30d7\u30e9\u30a4\u30ba\u3068\u95a2\u9023\u3059\u308b\u7372\u5f97\u30ed\u30b0\u3092\u524a\u9664\u3057\u307e\u3059\u3002',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('\u30ad\u30e3\u30f3\u30bb\u30eb'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('\u524a\u9664'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }
    await widget.repository.deletePrize(prize.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '\u30d7\u30e9\u30a4\u30ba\u3092\u524a\u9664\u3057\u307e\u3057\u305f',
        ),
      ),
    );
  }
}

enum _PrizeListDensity { compact, large }

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.repository,
    required this.selectedStatus,
    required this.selectedStoreId,
    required this.onStatusChanged,
    required this.onStoreChanged,
    required this.characterController,
    required this.seriesController,
  });

  final PrizeRepository repository;
  final String? selectedStatus;
  final int? selectedStoreId;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<int?> onStoreChanged;
  final TextEditingController characterController;
  final TextEditingController seriesController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 260),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Column(
            children: [
              _StatusFilterRow(
                selectedStatus: selectedStatus,
                onStatusChanged: onStatusChanged,
              ),
              const SizedBox(height: 8),
              _StoreFilterRow(
                repository: repository,
                selectedStoreId: selectedStoreId,
                onStoreChanged: onStoreChanged,
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 720;
                  final characterFilter = _SuggestionTextFilter(
                    controller: characterController,
                    labelText: '\u30ad\u30e3\u30e9\u540d\u691c\u7d22',
                    icon: Icons.person_search,
                    suggestionsStream: repository.watchCharacterNames(),
                  );
                  final seriesFilter = _SuggestionTextFilter(
                    controller: seriesController,
                    labelText: '\u30b7\u30ea\u30fc\u30ba\u691c\u7d22',
                    icon: Icons.search,
                    suggestionsStream: repository.watchSeriesNames(),
                  );
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: characterFilter),
                        const SizedBox(width: 8),
                        Expanded(child: seriesFilter),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      characterFilter,
                      const SizedBox(height: 8),
                      seriesFilter,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusFilterRow extends StatelessWidget {
  const _StatusFilterRow({
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  final String? selectedStatus;
  final ValueChanged<String?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<String?>(
        segments: const [
          ButtonSegment(value: null, label: Text('\u3059\u3079\u3066')),
          ButtonSegment(
            value: PrizeStatus.unowned,
            label: Text('\u672a\u7372\u5f97'),
          ),
          ButtonSegment(
            value: PrizeStatus.owned,
            label: Text('\u7372\u5f97\u6e08\u307f'),
          ),
          ButtonSegment(
            value: PrizeStatus.reserved,
            label: Text('\u7372\u5f97\u4e88\u5b9a'),
          ),
          ButtonSegment(
            value: PrizeStatus.skipped,
            label: Text('\u898b\u9001\u308a'),
          ),
        ],
        selected: {selectedStatus},
        onSelectionChanged: (values) => onStatusChanged(values.first),
      ),
    );
  }
}

class _StoreFilterRow extends StatelessWidget {
  const _StoreFilterRow({
    required this.repository,
    required this.selectedStoreId,
    required this.onStoreChanged,
  });

  final PrizeRepository repository;
  final int? selectedStoreId;
  final ValueChanged<int?> onStoreChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PrizeStore>>(
      stream: repository.listStores(registeredOnly: true),
      builder: (context, snapshot) {
        final stores = snapshot.data ?? const [];
        if (stores.isEmpty) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Text('\u767b\u9332\u6e08\u307f\u5e97\u8217\u306a\u3057'),
          );
        }
        return Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('\u5e97\u8217\u3059\u3079\u3066'),
                  selected: selectedStoreId == null,
                  onSelected: (_) => onStoreChanged(null),
                ),
                for (final store in stores)
                  ChoiceChip(
                    label: Text(store.name),
                    selected: selectedStoreId == store.id,
                    onSelected: (_) => onStoreChanged(store.id),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionTextFilter extends StatefulWidget {
  const _SuggestionTextFilter({
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.suggestionsStream,
  });

  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final Stream<List<String>> suggestionsStream;

  @override
  State<_SuggestionTextFilter> createState() => _SuggestionTextFilterState();
}

class _SuggestionTextFilterState extends State<_SuggestionTextFilter> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: widget.suggestionsStream,
      builder: (context, snapshot) {
        final suggestions = snapshot.data ?? const [];
        return RawAutocomplete<String>(
          textEditingController: widget.controller,
          focusNode: _focusNode,
          optionsBuilder: (textEditingValue) {
            final query = textEditingValue.text.trim().toLowerCase();
            if (query.isEmpty) {
              return suggestions;
            }
            return suggestions.where(
              (suggestion) => suggestion.toLowerCase().contains(query),
            );
          },
          onSelected: (value) {
            widget.controller.text = value;
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    prefixIcon: Icon(widget.icon),
                    suffixIcon: textEditingController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: '\u30af\u30ea\u30a2',
                            onPressed: textEditingController.clear,
                            icon: const Icon(Icons.clear),
                          ),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                );
              },
          optionsViewBuilder: (context, onSelected, options) {
            final optionList = options.toList(growable: false);
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainer,
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 240,
                    minWidth: 240,
                    maxWidth: 420,
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final option = optionList[index];
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Text(option),
                        ),
                      );
                    },
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    itemCount: optionList.length,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PrizeTile extends StatelessWidget {
  const _PrizeTile({
    required this.prize,
    required this.appearance,
    required this.density,
    required this.onTap,
    required this.onStatusSelected,
    required this.onDeleteSelected,
  });

  final PrizeItem prize;
  final PrizeStoreAppearanceEntry? appearance;
  final _PrizeListDensity density;
  final VoidCallback onTap;
  final ValueChanged<String> onStatusSelected;
  final VoidCallback onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    final imageSize = density == _PrizeListDensity.large ? 128.0 : 56.0;
    final titleMaxLines = density == _PrizeListDensity.large ? 4 : 2;
    final subtitleStyle = density == _PrizeListDensity.large
        ? Theme.of(context).textTheme.bodyMedium
        : Theme.of(context).textTheme.bodySmall;

    return GestureDetector(
      onSecondaryTapDown: (details) =>
          _showContextMenu(context, details.globalPosition),
      onLongPressStart: (details) =>
          _showContextMenu(context, details.globalPosition),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(
              density == _PrizeListDensity.large ? 14 : 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PrizeImage(url: prize.imageUrl, size: imageSize),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prize.title,
                        maxLines: titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: density == _PrizeListDensity.large
                            ? Theme.of(context).textTheme.titleMedium
                            : Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${prize.characterName} / ${prize.seriesName}\n'
                        '${prize.maker} / ${prize.releaseText}',
                        style: subtitleStyle,
                      ),
                      if (density == _PrizeListDensity.large) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            PrizeStatusChip(status: prize.status),
                            if (appearance != null)
                              _ArrivalChip(entry: appearance!),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (density == _PrizeListDensity.compact) ...[
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PrizeStatusChip(status: prize.status),
                      if (appearance != null) ...[
                        const SizedBox(height: 6),
                        _ArrivalChip(entry: appearance!),
                      ],
                    ],
                  ),
                ],
                IconButton(
                  tooltip: '\u64cd\u4f5c',
                  onPressed: () => _showContextMenuForButton(context),
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showContextMenuForButton(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }
    final offset = box.localToGlobal(Offset(box.size.width, 0));
    await _showContextMenu(context, offset);
  }

  Future<void> _showContextMenu(BuildContext context, Offset position) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final selected = await showMenu<_PrizeAction>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 1, 1),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem(
          value: _PrizeAction.markOwned,
          child: ListTile(
            leading: Icon(Icons.check),
            title: Text('\u7372\u5f97\u6e08\u307f\u306b\u3059\u308b'),
          ),
        ),
        PopupMenuItem(
          value: _PrizeAction.markUnowned,
          child: ListTile(
            leading: Icon(Icons.undo),
            title: Text('\u672a\u7372\u5f97\u306b\u623b\u3059'),
          ),
        ),
        PopupMenuItem(
          value: _PrizeAction.markReserved,
          child: ListTile(
            leading: Icon(Icons.event_available),
            title: Text('\u7372\u5f97\u4e88\u5b9a\u306b\u3059\u308b'),
          ),
        ),
        PopupMenuItem(
          value: _PrizeAction.markSkipped,
          child: ListTile(
            leading: Icon(Icons.block),
            title: Text('\u898b\u9001\u308a\u306b\u3059\u308b'),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: _PrizeAction.delete,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('\u524a\u9664'),
          ),
        ),
      ],
    );

    switch (selected) {
      case _PrizeAction.markOwned:
        onStatusSelected(PrizeStatus.owned);
      case _PrizeAction.markUnowned:
        onStatusSelected(PrizeStatus.unowned);
      case _PrizeAction.markReserved:
        onStatusSelected(PrizeStatus.reserved);
      case _PrizeAction.markSkipped:
        onStatusSelected(PrizeStatus.skipped);
      case _PrizeAction.delete:
        onDeleteSelected();
      case null:
        break;
    }
  }
}

class _ArrivalChip extends StatelessWidget {
  const _ArrivalChip({required this.entry});

  final PrizeStoreAppearanceEntry entry;

  @override
  Widget build(BuildContext context) {
    final text = entry.appearance.appearanceText;
    return Chip(
      avatar: const Icon(Icons.schedule, size: 16),
      label: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
      backgroundColor: const Color(0xFF0B2447),
      side: const BorderSide(color: Color(0xFF7DB7FF)),
      visualDensity: VisualDensity.compact,
    );
  }
}

enum _PrizeAction { markOwned, markUnowned, markReserved, markSkipped, delete }

class _PrizeImage extends StatelessWidget {
  const _PrizeImage({required this.url, required this.size});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(6);
    if (url == null || url!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius,
        ),
        child: const Icon(Icons.inventory_2_outlined),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image_outlined),
          );
        },
      ),
    );
  }
}
