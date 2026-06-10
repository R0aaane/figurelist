import 'dart:math' as math;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image_lib;
import 'package:url_launcher/url_launcher.dart';

import '../data/app_database.dart';
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
  List<_SimilarFigureCandidate> _similarResults = const [];
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

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
          Text('画像からDB内を類似検索', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _ImagePickerPanel(
            imageBytes: _selectedImageBytes,
            imageName: _selectedImageName,
            busy: _busy,
            onPickImage: _pickImage,
            onIdentify: _findSimilarLocalImages,
          ),
          const SizedBox(height: 12),
          const Text('登録済みフィギュアの画像と照合します。近い候補がない場合は下の手動追加に名前を入力してください。'),
          const SizedBox(height: 12),
          for (final candidate in _similarResults)
            Card(
              child: ListTile(
                leading: _SearchResultImage(url: candidate.prize.imageUrl),
                title: Text(candidate.prize.title),
                subtitle: Text(
                  [
                    '類似度 ${candidate.similarityPercent}%',
                    candidate.prize.characterName,
                    candidate.prize.seriesName,
                    if (candidate.prize.sourceUrl != null)
                      candidate.prize.sourceUrl!,
                  ].join('\n'),
                ),
                trailing: FilledButton(
                  onPressed: _busy
                      ? null
                      : () => _useSimilarCandidate(candidate),
                  child: const Text('この名前を使う'),
                ),
              ),
            ),
          const Divider(height: 32),
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
            const Text('サーバ検索、共有リストへの追加にはログインが必要です。未ログイン時はローカルへの手動追加のみできます。'),
          if (_busy) const LinearProgressIndicator(),
          if (_message != null) ...[const SizedBox(height: 8), Text(_message!)],
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
              labelText: '参照URL',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _importFromUrl(),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _busy ? null : _importFromUrl,
            icon: const Icon(Icons.link),
            label: const Text('URLから自動登録'),
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

  Future<void> _pickImage() async {
    const imageGroup = XTypeGroup(
      label: '画像',
      extensions: ['jpg', 'jpeg', 'png', 'webp'],
      mimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
    );
    final file = await openFile(acceptedTypeGroups: [imageGroup]);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() {
      _selectedImageBytes = bytes;
      _selectedImageName = file.name;
      _similarResults = const [];
      _message = null;
    });
  }

  Future<void> _findSimilarLocalImages() async {
    final bytes = _selectedImageBytes;
    if (bytes == null) {
      setState(() => _message = '類似検索する画像を選択してください。');
      return;
    }

    await _run(() async {
      final targetHash = _averageHash(bytes);
      if (targetHash == null) {
        _similarResults = const [];
        return '選択した画像を読み取れませんでした。別の画像を選択してください。';
      }

      final prizes = await widget.repository.listAllPrizesSnapshot();
      final candidates = <_SimilarFigureCandidate>[];
      final imagePrizes = prizes
          .where(
            (prize) => prize.imageUrl != null && prize.imageUrl!.isNotEmpty,
          )
          .take(120);

      for (final prize in imagePrizes) {
        final imageBytes = await _downloadImage(prize.imageUrl!);
        if (imageBytes == null) continue;
        final hash = _averageHash(imageBytes);
        if (hash == null) continue;
        final distance = _hammingDistance(targetHash, hash);
        if (distance <= 24) {
          candidates.add(
            _SimilarFigureCandidate(prize: prize, distance: distance),
          );
        }
      }

      candidates.sort((a, b) => a.distance.compareTo(b.distance));
      _similarResults = candidates.take(5).toList(growable: false);
      _results = const [];

      if (_similarResults.isEmpty) {
        return 'DB内に近い画像は見つかりませんでした。フィギュア名が分かる場合は手動追加してください。';
      }
      return '${_similarResults.length}件の類似候補を見つけました。候補を選ぶか、違う場合は手動で入力してください。';
    });
  }

  Future<void> _search() async {
    final service = widget.serverSyncService;
    if (service == null || !service.isLoggedIn) {
      setState(() => _message = '検索にはサーバへのログインが必要です。');
      return;
    }
    await _run(() async {
      _results = await service.searchFigures(_queryController.text.trim());
      _similarResults = const [];
      return '${_results.length}件の候補を取得しました。';
    });
  }

  Future<void> _addFromResult(FigureSearchResult result) async {
    await _create(
      title: result.title,
      workTitle: result.workTitle ?? result.title,
      characterName: result.characterName ?? result.title,
      seriesName: result.seriesName ?? '検索追加',
      maker: result.maker,
      releaseText: result.releaseText,
      releaseYear: result.releaseYear,
      releaseMonth: result.releaseMonth,
      sourceUrl: result.sourceUrl,
      imageUrl: result.imageUrl,
    );
  }

  void _useSimilarCandidate(_SimilarFigureCandidate candidate) {
    final prize = candidate.prize;
    setState(() {
      _queryController.text = prize.title;
      _titleController.text = prize.title;
      _sourceUrlController.text = prize.sourceUrl ?? '';
      _message = '候補の情報を手動追加欄に入れました。内容を確認して追加してください。';
    });
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

  Future<void> _importFromUrl() async {
    final url = _sourceUrlController.text.trim().isEmpty
        ? _queryController.text.trim()
        : _sourceUrlController.text.trim();
    final service = widget.serverSyncService;
    if (service == null || !service.isLoggedIn) {
      setState(() => _message = 'URLからの自動登録にはサーバーログインが必要です。');
      return;
    }
    if (Uri.tryParse(url)?.hasScheme != true) {
      setState(() => _message = '参照URLを入力してください。');
      return;
    }

    await _run(() async {
      final figures = await service.fetchFiguresFromUrl(url);
      if (figures.isEmpty) {
        return 'URLから登録できるフィギュアが見つかりませんでした。';
      }
      for (final figure in figures) {
        await service.createFigure(
          title: figure.title,
          workTitle: figure.workTitle ?? figure.title,
          characterName: figure.characterName ?? figure.title,
          seriesName: figure.seriesName ?? 'URL追加',
          maker: figure.maker ?? '未設定',
          releaseText: figure.releaseText ?? '未設定',
          releaseYear: figure.releaseYear,
          releaseMonth: figure.releaseMonth,
          sourceUrl: figure.sourceUrl ?? url,
          imageUrl: figure.imageUrl,
        );
      }
      final count = await service.syncFromServer();
      _results = figures;
      _similarResults = const [];
      return '${figures.length}件をURLから登録し、$count件を同期しました。';
    });
  }

  Future<void> _create({
    required String title,
    String? workTitle,
    String? characterName,
    String? maker,
    String? releaseText,
    int? releaseYear,
    int? releaseMonth,
    String? sourceUrl,
    String? imageUrl,
    required String seriesName,
  }) async {
    await _run(() async {
      final service = widget.serverSyncService;
      if (service != null && service.isLoggedIn) {
        await service.createFigure(
          title: title,
          workTitle: workTitle ?? title,
          characterName: characterName ?? title,
          seriesName: seriesName,
          maker: maker ?? '未設定',
          releaseText: releaseText ?? '未設定',
          releaseYear: releaseYear,
          releaseMonth: releaseMonth,
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
    final uri = Uri.https('www.google.com', '/search', {'q': '$trimmed フィギュア'});
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  BigInt? _averageHash(Uint8List bytes) {
    final decoded = image_lib.decodeImage(bytes);
    if (decoded == null) return null;
    final resized = image_lib.copyResize(decoded, width: 8, height: 8);
    final gray = image_lib.grayscale(resized);
    final values = <int>[];
    for (var y = 0; y < 8; y += 1) {
      for (var x = 0; x < 8; x += 1) {
        values.add(gray.getPixel(x, y).r.toInt());
      }
    }
    final average = values.reduce((a, b) => a + b) / values.length;
    var hash = BigInt.zero;
    for (final value in values) {
      hash = (hash << 1) | (value >= average ? BigInt.one : BigInt.zero);
    }
    return hash;
  }

  int _hammingDistance(BigInt a, BigInt b) {
    var value = a ^ b;
    var count = 0;
    while (value > BigInt.zero) {
      count += (value & BigInt.one).toInt();
      value = value >> 1;
    }
    return count;
  }

  Future<Uint8List?> _downloadImage(String imageUrl) async {
    final uri = Uri.tryParse(imageUrl);
    if (uri == null || !uri.hasScheme) return null;
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode < 200 || response.statusCode >= 300) return null;
      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.startsWith('image/')) return null;
      return response.bodyBytes;
    } on Object {
      return null;
    }
  }
}

class _SimilarFigureCandidate {
  const _SimilarFigureCandidate({required this.prize, required this.distance});

  final PrizeItem prize;
  final int distance;

  int get similarityPercent =>
      math.max(0, ((64 - distance) / 64 * 100).round());
}

class _ImagePickerPanel extends StatelessWidget {
  const _ImagePickerPanel({
    required this.imageBytes,
    required this.imageName,
    required this.busy,
    required this.onPickImage,
    required this.onIdentify,
  });

  final Uint8List? imageBytes;
  final String? imageName;
  final bool busy;
  final VoidCallback onPickImage;
  final VoidCallback onIdentify;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: imageBytes == null
                    ? const ColoredBox(
                        color: Color(0x11000000),
                        child: Center(child: Icon(Icons.image_search)),
                      )
                    : Image.memory(imageBytes!, fit: BoxFit.contain),
              ),
            ),
            if (imageName != null) ...[
              const SizedBox(height: 8),
              Text(
                imageName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: busy ? null : onPickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('画像を選択'),
                ),
                FilledButton.icon(
                  onPressed: busy || imageBytes == null ? null : onIdentify,
                  icon: const Icon(Icons.manage_search),
                  label: const Text('DB内で類似検索'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
        _displayImageUrl(value),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported),
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
