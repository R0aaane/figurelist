import 'dart:async';

import 'package:http/http.dart' as http;

import '../data/app_database.dart';

abstract class PrizeStoreSource {
  Future<List<PrizeStoreSourceItem>> fetchStores();

  Future<List<PrizeStoreAppearanceSourceItem>> fetchAppearances({
    required List<PrizeItem> prizes,
    required List<PrizeStore> stores,
  });
}

class PrizeStoreSourceItem {
  const PrizeStoreSourceItem({
    required this.name,
    required this.area,
    this.address,
    this.sourceUrl,
  });

  final String name;
  final String area;
  final String? address;
  final String? sourceUrl;
}

class PrizeStoreAppearanceSourceItem {
  const PrizeStoreAppearanceSourceItem({
    required this.prizeId,
    required this.storeId,
    required this.appearanceText,
    this.appearanceDateEpochMs,
    this.sourceUrl,
    this.memo,
  });

  final int prizeId;
  final int storeId;
  final String appearanceText;
  final int? appearanceDateEpochMs;
  final String? sourceUrl;
  final String? memo;
}

class NagoyaPrizeStoreSource implements PrizeStoreSource {
  const NagoyaPrizeStoreSource({RealStoreArrivalScraper? scraper})
    : _scraper = scraper ?? const RealStoreArrivalScraper();

  final RealStoreArrivalScraper _scraper;

  @override
  Future<List<PrizeStoreSourceItem>> fetchStores() async {
    return const [
      PrizeStoreSourceItem(
        name:
            '\u30bf\u30a4\u30c8\u30fc\u30b9\u30c6\u30fc\u30b7\u30e7\u30f3 \u540d\u53e4\u5c4b\u540d\u99c5\u5e97',
        area: '\u540d\u53e4\u5c4b\u99c5',
        address: '\u611b\u77e5\u770c\u540d\u53e4\u5c4b\u5e02\u4e2d\u6751\u533a',
        sourceUrl: 'https://www.taito.co.jp/store/00002253',
      ),
      PrizeStoreSourceItem(
        name:
            '\u30bf\u30a4\u30c8\u30fc\u30b9\u30c6\u30fc\u30b7\u30e7\u30f3 \u5927\u9808\u5e97',
        area: '\u5927\u9808',
        sourceUrl: 'https://www.taito.co.jp/store/00002035',
      ),
      PrizeStoreSourceItem(
        name: 'GiGO \u91d1\u5c71',
        area: '\u91d1\u5c71',
        address:
            '\u611b\u77e5\u770c\u540d\u53e4\u5c4b\u5e02\u71b1\u7530\u533a\u91d1\u5c711-19-2',
        sourceUrl: 'https://tempo.gendagigo.jp/am/kanayama',
      ),
      PrizeStoreSourceItem(
        name: 'namco\u540d\u53e4\u5c4b\u99c5\u524d\u5e97',
        area: '\u540d\u53e4\u5c4b\u99c5',
        sourceUrl:
            'https://bandainamco-am.co.jp/game_center/loc/nagoyaekimae/index.html?p=prize_info',
      ),
      PrizeStoreSourceItem(
        name: '\u30e9\u30a6\u30f3\u30c9\u30ef\u30f3 \u5343\u7a2e\u5e97',
        area: '\u5343\u7a2e',
        address:
            '\u611b\u77e5\u770c\u540d\u53e4\u5c4b\u5e02\u5343\u7a2e\u533a\u65b0\u68043-20-17',
        sourceUrl: 'https://www.round1.co.jp/service/amuse/news/crane.html',
      ),
    ];
  }

  @override
  Future<List<PrizeStoreAppearanceSourceItem>> fetchAppearances({
    required List<PrizeItem> prizes,
    required List<PrizeStore> stores,
  }) async {
    final registeredStores = stores.where((store) => store.isRegistered);
    final appearances = <PrizeStoreAppearanceSourceItem>[];

    for (final store in registeredStores) {
      final arrivals = await _scraper.fetchArrivals(store);
      for (final prize in prizes) {
        final arrival = arrivals.matchPrize(prize);
        if (arrival != null) {
          appearances.add(
            PrizeStoreAppearanceSourceItem(
              prizeId: prize.id,
              storeId: store.id,
              appearanceText: arrival.appearanceText,
              appearanceDateEpochMs: arrival.appearanceDateEpochMs,
              sourceUrl: arrival.sourceUrl ?? store.sourceUrl,
              memo:
                  '\u5e97\u8217\u30da\u30fc\u30b8\u304b\u3089\u5b9f\u5165\u8377\u60c5\u5831\u3092\u691c\u51fa',
            ),
          );
        } else {
          appearances.add(
            PrizeStoreAppearanceSourceItem(
              prizeId: prize.id,
              storeId: store.id,
              appearanceText:
                  '${prize.releaseText} / \u30e1\u30fc\u30ab\u30fc\u767b\u5834\u6642\u671f\u30d9\u30fc\u30b9',
              sourceUrl: store.sourceUrl,
              memo:
                  '\u5e97\u8217\u306e\u5b9f\u5165\u8377\u306f\u672a\u691c\u51fa\u3002\u516c\u5f0f\u60c5\u5831\u30fb\u5e97\u8217\u544a\u77e5\u3067\u78ba\u8a8d\u3057\u3066\u304f\u3060\u3055\u3044',
            ),
          );
        }
      }
    }

    return appearances;
  }
}

class RealStoreArrivalScraper {
  const RealStoreArrivalScraper({this.timeout = const Duration(seconds: 8)});

  final Duration timeout;

  Future<StoreArrivalSnapshot> fetchArrivals(PrizeStore store) async {
    final sourceUrl = store.sourceUrl;
    if (sourceUrl == null || sourceUrl.isEmpty) {
      return StoreArrivalSnapshot.empty(storeId: store.id);
    }

    final uri = Uri.tryParse(sourceUrl);
    if (uri == null || !uri.hasScheme) {
      return StoreArrivalSnapshot.empty(storeId: store.id);
    }

    try {
      final html = await _fetchHtml(uri);
      final normalized = _normalizeHtmlText(html);
      final entries = _splitEntries(normalized)
          .map((entry) => _parseArrivalEntry(entry, sourceUrl))
          .whereType<StoreArrivalEntry>()
          .toList(growable: false);
      return StoreArrivalSnapshot(storeId: store.id, entries: entries);
    } on Object {
      return StoreArrivalSnapshot.empty(storeId: store.id);
    }
  }

  Future<String> _fetchHtml(Uri uri) async {
    final response = await http
        .get(
          uri,
          headers: const {
            'accept': 'text/html,*/*',
            'user-agent':
                'FigureList/1.0 (+https://example.local; prize arrival checker)',
          },
        )
        .timeout(timeout);
    return response.body;
  }

  String _normalizeHtmlText(String html) {
    return html
        .replaceAll(
          RegExp(r'<script[\s\S]*?</script>', caseSensitive: false),
          ' ',
        )
        .replaceAll(
          RegExp(r'<style[\s\S]*?</style>', caseSensitive: false),
          ' ',
        )
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  List<String> _splitEntries(String text) {
    if (text.isEmpty) {
      return const [];
    }
    final chunks = <String>[];
    const chunkSize = 900;
    const step = 500;
    for (var start = 0; start < text.length; start += step) {
      final end = start + chunkSize > text.length
          ? text.length
          : start + chunkSize;
      chunks.add(text.substring(start, end));
      if (end == text.length) {
        break;
      }
    }
    return chunks;
  }

  StoreArrivalEntry? _parseArrivalEntry(String text, String sourceUrl) {
    if (!_looksLikePrizeEntry(text)) {
      return null;
    }

    final dateText = _extractDateText(text);
    return StoreArrivalEntry(
      searchableText: _normalizeSearchText(text),
      appearanceText: dateText == null
          ? '\u5b9f\u5165\u8377\u60c5\u5831\u3092\u691c\u51fa'
          : '$dateText / \u5b9f\u5165\u8377',
      appearanceDateEpochMs: _parseDateEpochMs(dateText),
      sourceUrl: sourceUrl,
    );
  }

  bool _looksLikePrizeEntry(String text) {
    final normalized = _normalizeSearchText(text);
    return normalized.contains('tolove') ||
        normalized.contains('\u3068\u3089\u3076\u308b') ||
        normalized.contains('\u30c0\u30fc\u30af\u30cd\u30b9') ||
        normalized.contains('desktopcute') ||
        normalized.contains('aquafloatgirls') ||
        normalized.contains('bicutebunnies') ||
        normalized.contains('triotryit');
  }

  String? _extractDateText(String text) {
    final patterns = [
      RegExp(r'20\d{2}\s*年\s*\d{1,2}\s*月\s*\d{1,2}\s*日'),
      RegExp(r'20\d{2}\s*年\s*\d{1,2}\s*月\s*(?:上旬|中旬|下旬|第\d週)'),
      RegExp(r'\d{1,2}\s*/\s*\d{1,2}'),
      RegExp(r'\d{1,2}\s*月\s*\d{1,2}\s*日'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(0)?.replaceAll(RegExp(r'\s+'), '');
      }
    }
    return null;
  }

  int? _parseDateEpochMs(String? text) {
    if (text == null) {
      return null;
    }
    final fullDate = RegExp(r'(20\d{2})年(\d{1,2})月(\d{1,2})日').firstMatch(text);
    if (fullDate != null) {
      return DateTime(
        int.parse(fullDate.group(1)!),
        int.parse(fullDate.group(2)!),
        int.parse(fullDate.group(3)!),
      ).millisecondsSinceEpoch;
    }
    return null;
  }
}

class StoreArrivalSnapshot {
  const StoreArrivalSnapshot({required this.storeId, required this.entries});

  factory StoreArrivalSnapshot.empty({required int storeId}) {
    return StoreArrivalSnapshot(storeId: storeId, entries: const []);
  }

  final int storeId;
  final List<StoreArrivalEntry> entries;

  StoreArrivalEntry? matchPrize(PrizeItem prize) {
    final title = _normalizeSearchText(prize.title);
    final character = _normalizeSearchText(prize.characterName);
    final series = _normalizeSearchText(prize.seriesName);
    final titleTokens = _tokensFor(title);

    StoreArrivalEntry? best;
    var bestScore = 0;
    for (final entry in entries) {
      final text = entry.searchableText;
      var score = 0;
      if (series.isNotEmpty && text.contains(series)) {
        score += 4;
      }
      if (character.isNotEmpty && text.contains(character)) {
        score += 4;
      }
      for (final token in titleTokens) {
        if (text.contains(token)) {
          score += 1;
        }
      }
      if (score > bestScore) {
        bestScore = score;
        best = entry;
      }
    }

    return bestScore >= 5 ? best : null;
  }

  List<String> _tokensFor(String value) {
    return value
        .split(RegExp(r'[^a-z0-9\u3040-\u30ff\u3400-\u9fff]+'))
        .where((token) => token.length >= 2)
        .toList(growable: false);
  }
}

class StoreArrivalEntry {
  const StoreArrivalEntry({
    required this.searchableText,
    required this.appearanceText,
    this.appearanceDateEpochMs,
    this.sourceUrl,
  });

  final String searchableText;
  final String appearanceText;
  final int? appearanceDateEpochMs;
  final String? sourceUrl;
}

String _normalizeSearchText(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[\s　・\-\u2010-\u2015ー～〜~＿_]+'), '')
      .replaceAll('figure', '')
      .replaceAll('\u30d5\u30a3\u30ae\u30e5\u30a2', '')
      .trim();
}
