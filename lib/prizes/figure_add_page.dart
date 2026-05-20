import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../server/server_sync_service.dart';
import 'prize_repository.dart';

class FigureAddPage extends StatefulWidget {
  const FigureAddPage({
    super.key,
    required this.repository,
    this.serverSyncService,
  });

  final PrizeRepository repository;
  final ServerSyncService? serverSyncService;

  @override
  State<FigureAddPage> createState() => _FigureAddPageState();
}

class _FigureAddPageState extends State<FigureAddPage> {
  final _queryController = TextEditingController();
  final _titleController = TextEditingController();
  final _sourceUrlController = TextEditingController();
  bool _busy = false;
  String? _message;
  List<FigureSearchResult> _results = const [];

  @override
  void dispose() {
    _queryController.dispose();
    _titleController.dispose();
    _sourceUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = widget.serverSyncService?.isLoggedIn ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('フィギュア追加')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _queryController,
            decoration: InputDecoration(
              labelText: '検索するフィギュア名',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: '検索',
                onPressed: _busy ? null : _search,
                icon: const Icon(Icons.search),
              ),
            ),
            onSubmitted: (_) => _search(),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: _busy ? null : _search,
                icon: const Icon(Icons.search),
                label: const Text('検索'),
              ),
              OutlinedButton.icon(
                onPressed: () => _openWebSearch(_queryController.text),
                icon: const Icon(Icons.open_in_new),
                label: const Text('ブラウザで検索'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!loggedIn)
            const Text('サーバー検索と共有追加にはログインが必要です。未ログイン時はローカル追加のみ行えます。'),
          if (_busy) const LinearProgressIndicator(),
          if (_message != null) ...[
            const SizedBox(height: 8),
            Text(_message!),
          ],
          const SizedBox(height: 12),
          for (final result in _results)
            Card(
              child: ListTile(
                leading: _SearchResultImage(url: result.imageUrl),
                title: Text(result.title),
                subtitle: Text(
                  [
                    if (result.snippet != null) result.snippet!,
                    if (result.sourceUrl != null) result.sourceUrl!,
                  ].join('\n'),
                ),
                trailing: FilledButton(
                  onPressed: _busy ? null : () => _addFromResult(result),
                  child: const Text('追加'),
                ),
              ),
            ),
          const Divider(height: 32),
          Text('手動追加', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'フィギュア名',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _sourceUrlController,
            decoration: const InputDecoration(
              labelText: '参考URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _busy ? null : _addManual,
            icon: const Icon(Icons.add),
            label: Text(loggedIn ? '共有リストに追加' : 'ローカルに追加'),
          ),
        ],
      ),
    );
  }

  Future<void> _search() async {
    final service = widget.serverSyncService;
    if (service == null || !service.isLoggedIn) {
      setState(() => _message = '検索にはサーバーログインが必要です。');
      return;
    }
    await _run(() async {
      _results = await service.searchFigures(_queryController.text.trim());
      return '${_results.length}件の候補を取得しました。';
    });
  }

  Future<void> _addFromResult(FigureSearchResult result) async {
    await _create(
      title: result.title,
      sourceUrl: result.sourceUrl,
      imageUrl: result.imageUrl,
      seriesName: '検索追加',
    );
  }

  Future<void> _addManual() async {
    final title = _titleController.text.trim().isEmpty
        ? _queryController.text.trim()
        : _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _message = 'フィギュア名を入力してください。');
      return;
    }
    await _create(
      title: title,
      sourceUrl: _sourceUrlController.text.trim(),
      seriesName: '手動追加',
    );
  }

  Future<void> _create({
    required String title,
    String? sourceUrl,
    String? imageUrl,
    required String seriesName,
  }) async {
    await _run(() async {
      final service = widget.serverSyncService;
      if (service != null && service.isLoggedIn) {
        await service.createFigure(
          title: title,
          workTitle: title,
          characterName: title,
          seriesName: seriesName,
          maker: '未設定',
          releaseText: '未設定',
          sourceUrl: sourceUrl,
          imageUrl: imageUrl,
        );
        final count = await service.syncFromServer();
        return '共有リストに追加し、$count件を同期しました。';
      }
      await widget.repository.addManualPrize(
        title: title,
        workTitle: title,
        characterName: title,
        seriesName: seriesName,
        maker: '未設定',
        releaseText: '未設定',
        sourceUrl: sourceUrl,
      );
      return 'ローカルに追加しました。';
    });
  }

  Future<void> _run(Future<String> Function() action) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final message = await action();
      if (mounted) setState(() => _message = message);
    } on Object catch (error) {
      if (mounted) setState(() => _message = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openWebSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final uri = Uri.https('www.google.com', '/search', {
      'q': '$trimmed フィギュア',
    });
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SearchResultImage extends StatelessWidget {
  const _SearchResultImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final value = url;
    if (value == null || value.isEmpty) {
      return const SizedBox(
        width: 56,
        height: 56,
        child: ColoredBox(color: Color(0x11000000)),
      );
    }
    return SizedBox(
      width: 56,
      height: 56,
      child: Image.network(
        value,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported),
      ),
    );
  }
}
