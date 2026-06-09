import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/app_database.dart';
import '../server/server_account_page.dart';
import '../server/server_sync_service.dart';
import 'figure_add_page.dart';
import 'prize_detail_page.dart';
import 'prize_notification_service.dart';
import 'prize_repository.dart';
import 'prize_store_page.dart';

class PrizeListPage extends StatefulWidget {
  const PrizeListPage({
    super.key,
    required this.repository,
    required this.notificationService,
    this.serverSyncService,
  });

  final PrizeRepository repository;
  final PrizeNotificationService notificationService;
  final ServerSyncService? serverSyncService;

  @override
  State<PrizeListPage> createState() => _PrizeListPageState();
}

class _PrizeListPageState extends State<PrizeListPage> {
  final _characterController = TextEditingController();
  final _seriesController = TextEditingController();
  String? _statusFilter;
  int? _storeFilterId;
  _PrizeListDensity _density = _PrizeListDensity.large;
  bool _gridView = true;

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
      body: Row(
        children: [
          _RailNavigation(
            onAdd: _openAddPage,
            onSync: _syncSamples,
            onStores: _openStorePage,
            onAccount: _openAccountPage,
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final showSidebar = constraints.maxWidth >= 860;
                return Row(
                  children: [
                    if (showSidebar)
                      SizedBox(
                        width: 304,
                        child: _FolderSidebar(
                          repository: widget.repository,
                          selectedStatus: _statusFilter,
                          selectedStoreId: _storeFilterId,
                          onStatusChanged: (value) =>
                              setState(() => _statusFilter = value),
                          onStoreChanged: (value) =>
                              setState(() => _storeFilterId = value),
                        ),
                      ),
                    if (showSidebar) const VerticalDivider(width: 1),
                    Expanded(
                      child: _MainProjectsPane(
                        repository: widget.repository,
                        selectedStatus: _statusFilter,
                        selectedStoreId: _storeFilterId,
                        characterController: _characterController,
                        seriesController: _seriesController,
                        density: _density,
                        gridView: _gridView,
                        showInlineFilters: !showSidebar,
                        onStatusChanged: (value) =>
                            setState(() => _statusFilter = value),
                        onStoreChanged: (value) =>
                            setState(() => _storeFilterId = value),
                        onAdd: _openAddPage,
                        onSync: _syncSamples,
                        onStores: _openStorePage,
                        onAccount: _openAccountPage,
                        onToggleGridView: () =>
                            setState(() => _gridView = !_gridView),
                        onToggleDensity: () {
                          setState(() {
                            _density = _density == _PrizeListDensity.compact
                                ? _PrizeListDensity.large
                                : _PrizeListDensity.compact;
                          });
                        },
                        onOpenPrize: _openPrize,
                        onStatusSelected: _updatePrizeStatus,
                        onDeleteSelected: _confirmDelete,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openAddPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FigureAddPage(
          repository: widget.repository,
          serverSyncService: widget.serverSyncService,
        ),
      ),
    );
  }

  void _openAccountPage() {
    final service = widget.serverSyncService;
    if (service == null) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ServerAccountPage(service: service),
      ),
    );
  }

  void _openStorePage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PrizeStorePage(
          repository: widget.repository,
          notificationService: widget.notificationService,
        ),
      ),
    );
  }

  Future<void> _syncSamples() async {
    await widget.repository.upsertFromSource();
    await widget.repository.syncStoreAppearances();
    await widget.notificationService.rescheduleArrivalNotifications(
      widget.repository,
    );
  }

  void _openPrize(PrizeItem prize) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PrizeDetailPage(
          repository: widget.repository,
          notificationService: widget.notificationService,
          serverSyncService: widget.serverSyncService,
          prizeId: prize.id,
        ),
      ),
    );
  }

  Future<void> _updatePrizeStatus(PrizeItem prize, String status) async {
    if (prize.status == status) {
      return;
    }
    await widget.repository.updateStatus(prize.id, status);
    await widget.serverSyncService?.updateStatus(prize.id, status);
    await widget.notificationService.rescheduleArrivalNotifications(
      widget.repository,
    );
  }

  Future<void> _confirmDelete(PrizeItem prize) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('プライズを削除'),
          content: Text(
            '${prize.title}\n\n'
            'ログイン中の場合はこのアカウントの一覧からのみ削除します。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('削除'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }
    final syncService = widget.serverSyncService;
    if (syncService != null && syncService.isLoggedIn) {
      await syncService.hidePrize(prize.id);
    }
    await widget.repository.deletePrize(prize.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('プライズを削除しました')));
  }
}

enum _PrizeListDensity { compact, large }

class _RailNavigation extends StatelessWidget {
  const _RailNavigation({
    required this.onAdd,
    required this.onSync,
    required this.onStores,
    required this.onAccount,
  });

  final VoidCallback onAdd;
  final VoidCallback onSync;
  final VoidCallback onStores;
  final VoidCallback onAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const _AppMark(),
            const SizedBox(height: 28),
            _RailButton(
              icon: Icons.home_outlined,
              tooltip: 'ホーム',
              selected: true,
            ),
            _RailButton(icon: Icons.search, tooltip: '検索', onPressed: () {}),
            _RailButton(icon: Icons.inventory_2_outlined, tooltip: '一覧'),
            _RailButton(
              icon: Icons.storefront_outlined,
              tooltip: '店舗',
              onPressed: onStores,
            ),
            _RailButton(icon: Icons.add, tooltip: '追加', onPressed: onAdd),
            _RailButton(
              icon: Icons.cloud_sync_outlined,
              tooltip: 'アカウント',
              onPressed: onAccount,
            ),
            _RailButton(icon: Icons.sync, tooltip: '同期', onPressed: onSync),
            const Spacer(),
            _RailButton(icon: Icons.notifications_none, tooltip: '通知'),
            _RailButton(icon: Icons.help_outline, tooltip: 'ヘルプ'),
            const SizedBox(height: 12),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFF3F3F4),
              child: Text('F', style: TextStyle(color: Color(0xFF151518))),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.icon,
    required this.tooltip,
    this.selected = false,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            fixedSize: const Size(40, 40),
            backgroundColor: selected
                ? const Color(0xFFECECEF)
                : Colors.transparent,
            foregroundColor: const Color(0xFF151518),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(icon, size: 21),
        ),
      ),
    );
  }
}

class _AppMark extends StatelessWidget {
  const _AppMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFF151518),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.view_in_ar_outlined,
        color: Colors.white,
        size: 21,
      ),
    );
  }
}

class _FolderSidebar extends StatelessWidget {
  const _FolderSidebar({
    required this.repository,
    required this.selectedStatus,
    required this.selectedStoreId,
    required this.onStatusChanged,
    required this.onStoreChanged,
  });

  final PrizeRepository repository;
  final String? selectedStatus;
  final int? selectedStoreId;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<int?> onStoreChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SidebarHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 20),
              label: const Text('New Folder'),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                foregroundColor: const Color(0xFF151518),
                side: const BorderSide(color: Color(0xFFE0E0E3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                const Expanded(
                  child: _SidebarSearchField(hintText: 'Search folders'),
                ),
                const SizedBox(width: 8),
                _SmallSquareButton(
                  icon: Icons.filter_alt_outlined,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          _FolderItem(
            icon: Icons.all_inbox_outlined,
            label: 'My Figures',
            selected: selectedStatus == null && selectedStoreId == null,
            onTap: () {
              onStatusChanged(null);
              onStoreChanged(null);
            },
          ),
          _FolderItem(
            icon: Icons.bookmark_border,
            label: '獲得予定',
            selected: selectedStatus == PrizeStatus.reserved,
            onTap: () => onStatusChanged(PrizeStatus.reserved),
          ),
          _FolderItem(
            icon: Icons.check_circle_outline,
            label: '獲得済み',
            selected: selectedStatus == PrizeStatus.owned,
            onTap: () => onStatusChanged(PrizeStatus.owned),
          ),
          _FolderItem(
            icon: Icons.radio_button_unchecked,
            label: '未獲得',
            selected: selectedStatus == PrizeStatus.unowned,
            onTap: () => onStatusChanged(PrizeStatus.unowned),
          ),
          _FolderItem(
            icon: Icons.block_outlined,
            label: '見送り',
            selected: selectedStatus == PrizeStatus.skipped,
            onTap: () => onStatusChanged(PrizeStatus.skipped),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'Stores',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF737376),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<PrizeStore>>(
              stream: repository.listStores(registeredOnly: true),
              builder: (context, snapshot) {
                final stores = snapshot.data ?? const [];
                if (stores.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('登録済み店舗なし'),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return _FolderItem(
                      icon: Icons.store_mall_directory_outlined,
                      label: store.name,
                      selected: selectedStoreId == store.id,
                      onTap: () => onStoreChanged(store.id),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          _FolderItem(
            icon: Icons.archive_outlined,
            label: 'Archives',
            onTap: () {},
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Folders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _FolderItem extends StatelessWidget {
  const _FolderItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: onTap,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE9E9EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Row(
            children: [
              Icon(icon, size: 19, color: const Color(0xFF151518)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainProjectsPane extends StatelessWidget {
  const _MainProjectsPane({
    required this.repository,
    required this.selectedStatus,
    required this.selectedStoreId,
    required this.characterController,
    required this.seriesController,
    required this.density,
    required this.gridView,
    required this.showInlineFilters,
    required this.onStatusChanged,
    required this.onStoreChanged,
    required this.onAdd,
    required this.onSync,
    required this.onStores,
    required this.onAccount,
    required this.onToggleGridView,
    required this.onToggleDensity,
    required this.onOpenPrize,
    required this.onStatusSelected,
    required this.onDeleteSelected,
  });

  final PrizeRepository repository;
  final String? selectedStatus;
  final int? selectedStoreId;
  final TextEditingController characterController;
  final TextEditingController seriesController;
  final _PrizeListDensity density;
  final bool gridView;
  final bool showInlineFilters;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<int?> onStoreChanged;
  final VoidCallback onAdd;
  final Future<void> Function() onSync;
  final VoidCallback onStores;
  final VoidCallback onAccount;
  final VoidCallback onToggleGridView;
  final VoidCallback onToggleDensity;
  final ValueChanged<PrizeItem> onOpenPrize;
  final void Function(PrizeItem prize, String status) onStatusSelected;
  final ValueChanged<PrizeItem> onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBar(onAdd: onAdd, onStores: onStores, onAccount: onAccount),
        Expanded(
          child: StreamBuilder<List<PrizeItem>>(
            stream: repository.listPrizes(
              status: selectedStatus,
              characterQuery: characterController.text,
              seriesQuery: seriesController.text,
              registeredStoreId: selectedStoreId,
            ),
            builder: (context, snapshot) {
              final prizes = snapshot.data ?? const [];
              return StreamBuilder<List<PrizeStoreAppearanceEntry>>(
                stream: selectedStoreId == null
                    ? Stream.value(const [])
                    : repository.watchAppearancesForStore(selectedStoreId!),
                builder: (context, appearanceSnapshot) {
                  final appearancesByPrizeId = <int, PrizeStoreAppearanceEntry>{
                    for (final entry in appearanceSnapshot.data ?? const [])
                      entry.appearance.prizeId: entry,
                  };
                  return Column(
                    children: [
                      _LimitBanner(count: prizes.length),
                      _ProjectToolbar(
                        repository: repository,
                        characterController: characterController,
                        seriesController: seriesController,
                        selectedStatus: selectedStatus,
                        selectedStoreId: selectedStoreId,
                        showInlineFilters: showInlineFilters,
                        gridView: gridView,
                        onStatusChanged: onStatusChanged,
                        onStoreChanged: onStoreChanged,
                        onToggleGridView: onToggleGridView,
                        onToggleDensity: onToggleDensity,
                        onSync: onSync,
                      ),
                      Expanded(
                        child: _PrizeCollectionView(
                          prizes: prizes,
                          isLoading:
                              snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              !snapshot.hasData,
                          appearancesByPrizeId: appearancesByPrizeId,
                          gridView: gridView,
                          density: density,
                          onOpenPrize: onOpenPrize,
                          onStatusSelected: onStatusSelected,
                          onDeleteSelected: onDeleteSelected,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onAdd,
    required this.onStores,
    required this.onAccount,
  });

  final VoidCallback onAdd;
  final VoidCallback onStores;
  final VoidCallback onAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'My Figures',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          IconButton(
            tooltip: '店舗登録',
            onPressed: onStores,
            icon: const Icon(Icons.storefront_outlined),
          ),
          IconButton(
            tooltip: 'アカウント',
            onPressed: onAccount,
            icon: const Icon(Icons.cloud_sync_outlined),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Figure'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF151518),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitBanner extends StatelessWidget {
  const _LimitBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EA),
          border: Border.all(color: const Color(0xFFF0DDC0)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 18, color: Color(0xFF8B5A13)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Figures tracked ($count). Use filters to organize your collection.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF80510F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFD23F),
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Color(0xFF151518)),
                  SizedBox(width: 6),
                  Text(
                    'Organize',
                    style: TextStyle(
                      color: Color(0xFF151518),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectToolbar extends StatelessWidget {
  const _ProjectToolbar({
    required this.repository,
    required this.characterController,
    required this.seriesController,
    required this.selectedStatus,
    required this.selectedStoreId,
    required this.showInlineFilters,
    required this.gridView,
    required this.onStatusChanged,
    required this.onStoreChanged,
    required this.onToggleGridView,
    required this.onToggleDensity,
    required this.onSync,
  });

  final PrizeRepository repository;
  final TextEditingController characterController;
  final TextEditingController seriesController;
  final String? selectedStatus;
  final int? selectedStoreId;
  final bool showInlineFilters;
  final bool gridView;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<int?> onStoreChanged;
  final VoidCallback onToggleGridView;
  final VoidCallback onToggleDensity;
  final Future<void> Function() onSync;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _SuggestionTextFilter(
                  controller: characterController,
                  hintText: 'Search figures',
                  icon: Icons.search,
                  suggestionsStream: repository.watchCharacterNames(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SuggestionTextFilter(
                  controller: seriesController,
                  hintText: 'Search series',
                  icon: Icons.collections_bookmark_outlined,
                  suggestionsStream: repository.watchSeriesNames(),
                ),
              ),
              const SizedBox(width: 10),
              _SmallSquareButton(
                icon: gridView ? Icons.view_list : Icons.grid_view_outlined,
                tooltip: gridView ? 'リスト表示' : 'グリッド表示',
                onPressed: onToggleGridView,
              ),
              const SizedBox(width: 8),
              _SmallSquareButton(
                icon: Icons.density_medium_outlined,
                tooltip: '表示密度',
                onPressed: onToggleDensity,
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onSync,
                icon: const Icon(Icons.sync, size: 18),
                label: const Text('Sync'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF151518),
                  side: const BorderSide(color: Color(0xFFE0E0E3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
          if (showInlineFilters) ...[
            const SizedBox(height: 10),
            _InlineFilters(
              repository: repository,
              selectedStatus: selectedStatus,
              selectedStoreId: selectedStoreId,
              onStatusChanged: onStatusChanged,
              onStoreChanged: onStoreChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _InlineFilters extends StatelessWidget {
  const _InlineFilters({
    required this.repository,
    required this.selectedStatus,
    required this.selectedStoreId,
    required this.onStatusChanged,
    required this.onStoreChanged,
  });

  final PrizeRepository repository;
  final String? selectedStatus;
  final int? selectedStoreId;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<int?> onStoreChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChipButton(
            label: 'すべて',
            selected: selectedStatus == null && selectedStoreId == null,
            onTap: () {
              onStatusChanged(null);
              onStoreChanged(null);
            },
          ),
          _FilterChipButton(
            label: '未獲得',
            selected: selectedStatus == PrizeStatus.unowned,
            onTap: () => onStatusChanged(PrizeStatus.unowned),
          ),
          _FilterChipButton(
            label: '獲得済み',
            selected: selectedStatus == PrizeStatus.owned,
            onTap: () => onStatusChanged(PrizeStatus.owned),
          ),
          _FilterChipButton(
            label: '獲得予定',
            selected: selectedStatus == PrizeStatus.reserved,
            onTap: () => onStatusChanged(PrizeStatus.reserved),
          ),
          _FilterChipButton(
            label: '見送り',
            selected: selectedStatus == PrizeStatus.skipped,
            onTap: () => onStatusChanged(PrizeStatus.skipped),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }
}

class _PrizeCollectionView extends StatelessWidget {
  const _PrizeCollectionView({
    required this.prizes,
    required this.isLoading,
    required this.appearancesByPrizeId,
    required this.gridView,
    required this.density,
    required this.onOpenPrize,
    required this.onStatusSelected,
    required this.onDeleteSelected,
  });

  final List<PrizeItem> prizes;
  final bool isLoading;
  final Map<int, PrizeStoreAppearanceEntry> appearancesByPrizeId;
  final bool gridView;
  final _PrizeListDensity density;
  final ValueChanged<PrizeItem> onOpenPrize;
  final void Function(PrizeItem prize, String status) onStatusSelected;
  final ValueChanged<PrizeItem> onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (prizes.isEmpty) {
      return const Center(child: Text('該当するプライズはありません'));
    }
    if (!gridView) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        itemBuilder: (context, index) {
          final prize = prizes[index];
          return _PrizeTile(
            prize: prize,
            appearance: appearancesByPrizeId[prize.id],
            density: density,
            asGridCard: false,
            onTap: () => onOpenPrize(prize),
            onStatusSelected: (status) => onStatusSelected(prize, status),
            onDeleteSelected: () => onDeleteSelected(prize),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemCount: prizes.length,
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1320
            ? 3
            : width >= 760
            ? 2
            : 1;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 28,
            mainAxisSpacing: 18,
            childAspectRatio: density == _PrizeListDensity.large ? 2.45 : 3.8,
          ),
          itemCount: prizes.length,
          itemBuilder: (context, index) {
            final prize = prizes[index];
            return _PrizeTile(
              prize: prize,
              appearance: appearancesByPrizeId[prize.id],
              density: density,
              asGridCard: true,
              onTap: () => onOpenPrize(prize),
              onStatusSelected: (status) => onStatusSelected(prize, status),
              onDeleteSelected: () => onDeleteSelected(prize),
            );
          },
        );
      },
    );
  }
}

class _SuggestionTextFilter extends StatefulWidget {
  const _SuggestionTextFilter({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.suggestionsStream,
  });

  final TextEditingController controller;
  final String hintText;
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
                    hintText: widget.hintText,
                    prefixIcon: Icon(widget.icon, size: 21),
                    suffixIcon: textEditingController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'クリア',
                            onPressed: textEditingController.clear,
                            icon: const Icon(Icons.close, size: 18),
                          ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                );
              },
          optionsViewBuilder: (context, onSelected, options) {
            final optionList = options.toList(growable: false);
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.white,
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
                    separatorBuilder: (_, _) => const Divider(height: 1),
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

class _SidebarSearchField extends StatelessWidget {
  const _SidebarSearchField({required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search, size: 21),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}

class _SmallSquareButton extends StatelessWidget {
  const _SmallSquareButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          fixedSize: const Size(43, 43),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF151518),
          side: const BorderSide(color: Color(0xFFE0E0E3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        icon: Icon(icon, size: 21),
      ),
    );
  }
}

class _PrizeTile extends StatelessWidget {
  const _PrizeTile({
    required this.prize,
    required this.appearance,
    required this.density,
    required this.asGridCard,
    required this.onTap,
    required this.onStatusSelected,
    required this.onDeleteSelected,
  });

  final PrizeItem prize;
  final PrizeStoreAppearanceEntry? appearance;
  final _PrizeListDensity density;
  final bool asGridCard;
  final VoidCallback onTap;
  final ValueChanged<String> onStatusSelected;
  final VoidCallback onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    final imageSize = density == _PrizeListDensity.large ? 76.0 : 50.0;
    return GestureDetector(
      onSecondaryTapDown: (details) =>
          _showContextMenu(context, details.globalPosition),
      onLongPressStart: (details) =>
          _showContextMenu(context, details.globalPosition),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(
              density == _PrizeListDensity.large ? 18 : 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PrizeImage(url: prize.imageUrl, size: imageSize),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prize.title,
                            maxLines: asGridCard ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF151518),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${prize.characterName} / ${prize.seriesName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFF78787D)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${prize.maker} / ${prize.releaseText}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFF78787D)),
                          ),
                        ],
                      ),
                      if (density == _PrizeListDensity.large) ...[
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _PrizeStatusPill(
                              status: prize.status,
                              onTap: () => onStatusSelected(
                                _nextPrizeStatus(prize.status),
                              ),
                            ),
                            if (appearance != null)
                              _ArrivalPill(entry: appearance!),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const _CloudBadge(),
                    const SizedBox(height: 16),
                    IconButton(
                      tooltip: '操作',
                      onPressed: () => _showContextMenuForButton(context),
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
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
      items: [
        ..._statusMenuItems(prize.status),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: _PrizeAction.delete,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('削除'),
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

class _CloudBadge extends StatelessWidget {
  const _CloudBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFD9FFE9),
        border: Border.all(color: const Color(0xFF98EABB)),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.cloud_outlined,
        color: Color(0xFF16A05D),
        size: 19,
      ),
    );
  }
}

class _PrizeStatusPill extends StatelessWidget {
  const _PrizeStatusPill({required this.status, required this.onTap});

  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(status);
    return Tooltip(
      message: '次の状態に変更',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: style.border),
            ),
            child: Text(
              style.label,
              style: TextStyle(
                color: style.foreground,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrivalPill extends StatelessWidget {
  const _ArrivalPill({required this.entry});

  final PrizeStoreAppearanceEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE0E0E3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule, size: 14, color: Color(0xFF6B6B70)),
          const SizedBox(width: 5),
          Text(
            entry.appearance.appearanceText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6B6B70),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

enum _PrizeAction { markOwned, markUnowned, markReserved, markSkipped, delete }

const _statusCycle = [
  PrizeStatus.unowned,
  PrizeStatus.owned,
  PrizeStatus.reserved,
  PrizeStatus.skipped,
];

String _nextPrizeStatus(String status) {
  final index = _statusCycle.indexOf(status);
  if (index == -1) {
    return PrizeStatus.unowned;
  }
  return _statusCycle[(index + 1) % _statusCycle.length];
}

List<PopupMenuEntry<_PrizeAction>> _statusMenuItems(String currentStatus) {
  return [
    if (currentStatus != PrizeStatus.owned)
      PopupMenuItem(
        value: _PrizeAction.markOwned,
        child: ListTile(
          leading: const Icon(Icons.check),
          title: Text('${PrizeStatus.label(PrizeStatus.owned)}にする'),
        ),
      ),
    if (currentStatus != PrizeStatus.unowned)
      PopupMenuItem(
        value: _PrizeAction.markUnowned,
        child: ListTile(
          leading: const Icon(Icons.undo),
          title: Text('${PrizeStatus.label(PrizeStatus.unowned)}にする'),
        ),
      ),
    if (currentStatus != PrizeStatus.reserved)
      PopupMenuItem(
        value: _PrizeAction.markReserved,
        child: ListTile(
          leading: const Icon(Icons.event_available),
          title: Text('${PrizeStatus.label(PrizeStatus.reserved)}にする'),
        ),
      ),
    if (currentStatus != PrizeStatus.skipped)
      PopupMenuItem(
        value: _PrizeAction.markSkipped,
        child: ListTile(
          leading: const Icon(Icons.block),
          title: Text('${PrizeStatus.label(PrizeStatus.skipped)}にする'),
        ),
      ),
  ];
}

class _PrizeImage extends StatelessWidget {
  const _PrizeImage({required this.url, required this.size});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(7);
    if (url == null || url!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F2),
          borderRadius: borderRadius,
          border: Border.all(color: const Color(0xFFE0E0E3)),
        ),
        child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF77777C)),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        _displayImageUrl(url!),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: const Color(0xFFF0F0F2),
            child: const Icon(
              Icons.broken_image_outlined,
              color: Color(0xFF77777C),
            ),
          );
        },
      ),
    );
  }
}

String _displayImageUrl(String value) {
  if (!kIsWeb) return value;
  final uri = Uri.tryParse(value);
  if (uri == null || !uri.hasScheme) return value;
  if (uri.scheme != 'http' && uri.scheme != 'https') return value;
  if (uri.origin == Uri.base.origin) return value;
  return Uri.base
      .resolve('/api/image-proxy?url=${Uri.encodeComponent(value)}')
      .toString();
}

_StatusStyle _statusStyle(String status) {
  switch (status) {
    case PrizeStatus.owned:
      return const _StatusStyle(
        label: '獲得済み',
        background: Color(0xFFE9F8EF),
        border: Color(0xFFC4EBD0),
        foreground: Color(0xFF1A7A42),
      );
    case PrizeStatus.reserved:
      return const _StatusStyle(
        label: '獲得予定',
        background: Color(0xFFFFF4D8),
        border: Color(0xFFF0D393),
        foreground: Color(0xFF8A5B11),
      );
    case PrizeStatus.skipped:
      return const _StatusStyle(
        label: '見送り',
        background: Color(0xFFF2F2F3),
        border: Color(0xFFD8D8DC),
        foreground: Color(0xFF696970),
      );
    case PrizeStatus.unowned:
    default:
      return const _StatusStyle(
        label: '未獲得',
        background: Color(0xFFF0F5FF),
        border: Color(0xFFD3DFF5),
        foreground: Color(0xFF38598C),
      );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.label,
    required this.background,
    required this.border,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color border;
  final Color foreground;
}
