import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/app_database.dart';

class ServerSyncException implements Exception {
  const ServerSyncException(this.message);

  final String message;

  @override
  String toString() => message;
}

class FigureSearchResult {
  const FigureSearchResult({
    required this.title,
    this.sourceUrl,
    this.snippet,
    this.imageUrl,
  });

  final String title;
  final String? sourceUrl;
  final String? snippet;
  final String? imageUrl;
}

class ServerSyncService {
  ServerSyncService(this._database) {
    if (kIsWeb) {
      final origin = Uri.base.origin;
      appBaseUrl = origin;
      controlBaseUrl = origin;
    }
  }

  final AppDatabase _database;
  final _client = http.Client();
  Process? _cloudflareProcess;

  String appBaseUrl = 'http://127.0.0.1:4173';
  String controlBaseUrl = 'http://127.0.0.1:4172';
  String? _cookie;
  String? username;

  bool get isLoggedIn => username != null && (kIsWeb || _cookie != null);

  Map<String, String> get _headers {
    return {
      'content-type': 'application/json',
      ...?_cookie == null ? null : {'cookie': _cookie!},
    };
  }

  void setBaseUrls({
    required String appBaseUrl,
    required String controlBaseUrl,
  }) {
    this.appBaseUrl = _normalizeLoopbackBaseUrl(appBaseUrl);
    this.controlBaseUrl = _normalizeLoopbackBaseUrl(controlBaseUrl);
  }

  Future<void> register({
    required String username,
    required String password,
  }) async {
    await _authenticate('register', username: username, password: password);
    await saveSession();
  }

  Future<void> registerWithUsername(String username) async {
    await _authenticate(
      'register',
      username: username,
      password: '',
      passwordless: true,
    );
    await saveSession();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    await _authenticate('login', username: username, password: password);
    await saveSession();
  }

  Future<void> loginWithUsername(String username) async {
    await _authenticate(
      'login',
      username: username,
      password: '',
      passwordless: true,
    );
    await saveSession();
  }

  Future<bool> restoreSession() async {
    if (kIsWeb) {
      try {
        final response = await _client.get(_appUri('/api/auth/session'));
        if (response.statusCode != 200) return false;
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final user = body['user'] as Map<String, dynamic>?;
        username = user?['username'] as String?;
        return username != null;
      } on Object {
        return false;
      }
    }

    final file = await _sessionFile();
    if (!await file.exists()) return false;

    try {
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      if (!kIsWeb) {
        setBaseUrls(
          appBaseUrl: json['appBaseUrl'] as String? ?? appBaseUrl,
          controlBaseUrl: json['controlBaseUrl'] as String? ?? controlBaseUrl,
        );
      }
      _cookie = json['cookie'] as String?;
      username = json['username'] as String?;
      if (_cookie == null) return false;

      final response = await _client.get(
        _appUri('/api/auth/session'),
        headers: _headers,
      );
      if (response.statusCode != 200) {
        await clearSavedSession();
        return false;
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final user = body['user'] as Map<String, dynamic>?;
      if (user == null) {
        await clearSavedSession();
        return false;
      }
      username = user['username'] as String?;
      await saveSession();
      return isLoggedIn;
    } on Object {
      await clearSavedSession();
      return false;
    }
  }

  Future<void> saveSession() async {
    if (kIsWeb) return;

    final file = await _sessionFile();
    await file.parent.create(recursive: true);
    await file.writeAsString(
      jsonEncode({
        'appBaseUrl': appBaseUrl,
        'controlBaseUrl': controlBaseUrl,
        'cookie': _cookie,
        'username': username,
      }),
    );
  }

  Future<void> _authenticate(
    String mode, {
    required String username,
    required String password,
    bool passwordless = false,
  }) async {
    final response = await _client.post(
      _appUri('/api/auth/$mode'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'username': username,
        if (!passwordless) 'password': password,
        if (passwordless) 'passwordless': true,
      }),
    );
    _throwIfFailed(response);
    _storeCookie(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    this.username =
        (body['user'] as Map<String, dynamic>)['username'] as String;
  }

  Future<void> logout() async {
    if (_cookie != null) {
      await _client.post(_appUri('/api/auth/logout'), headers: _headers);
    }
    _cookie = null;
    username = null;
    await clearSavedSession();
  }

  Future<void> clearSavedSession() async {
    if (kIsWeb) return;

    final file = await _sessionFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Map<String, dynamic>> serverStatus() async {
    final response = await _controlRequest(
      () => _client.get(_controlUri('/api/server/status')),
    );
    _throwIfFailed(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> restartServer() async {
    final response = await _controlRequest(
      () => _client.post(_controlUri('/api/server/restart')),
    );
    _throwIfFailed(response);
  }

  Future<void> startServer() async {
    final response = await _controlRequest(
      () => _client.post(_controlUri('/api/server/start')),
    );
    _throwIfFailed(response);
  }

  Future<void> stopServer() async {
    final response = await _client.post(_controlUri('/api/server/stop'));
    _throwIfFailed(response);
  }

  bool get isCloudflareTunnelRunning {
    return _cloudflareProcess != null;
  }

  Future<String> startCloudflareTunnel({bool rebuild = true}) async {
    final existing = _cloudflareProcess;
    if (existing != null) {
      throw const ServerSyncException('Cloudflare Tunnel is already running.');
    }

    final webappDirectory = await _findWebappDirectory();
    if (webappDirectory == null) {
      throw const ServerSyncException('webapp folder was not found.');
    }

    final script = File(
      p.join(webappDirectory.path, 'start_cloudflare_tunnel.ps1'),
    );
    if (!await script.exists()) {
      throw const ServerSyncException(
        'start_cloudflare_tunnel.ps1 was not found.',
      );
    }

    final args = [
      '-NoProfile',
      '-ExecutionPolicy',
      'Bypass',
      '-File',
      script.path,
      if (!rebuild) '-SkipBuild',
    ];

    final process = await Process.start(
      'powershell.exe',
      args,
      workingDirectory: webappDirectory.path,
      mode: ProcessStartMode.normal,
    );
    _cloudflareProcess = process;
    process.exitCode.then((_) {
      if (identical(_cloudflareProcess, process)) {
        _cloudflareProcess = null;
      }
    });

    final completer = Completer<String>();
    final output = StringBuffer();
    final urlPattern = RegExp(r'https://[a-z0-9-]+\.trycloudflare\.com');

    void consume(List<int> bytes) {
      final text = utf8.decode(bytes, allowMalformed: true);
      output.write(text);
      final match = urlPattern.firstMatch(output.toString());
      if (match != null && !completer.isCompleted) {
        completer.complete(match.group(0)!);
      }
    }

    process.stdout.listen(consume);
    process.stderr.listen(consume);

    process.exitCode.then((code) {
      if (!completer.isCompleted) {
        _cloudflareProcess = null;
        completer.completeError(
          ServerSyncException(
            'Cloudflare Tunnel failed with exit code $code.\n$output',
          ),
        );
      }
    });

    return completer.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () {
        stopCloudflareTunnel();
        throw ServerSyncException(
          'Cloudflare Tunnel URL was not reported within 3 minutes.\n$output',
        );
      },
    );
  }

  Future<void> stopCloudflareTunnel() async {
    final process = _cloudflareProcess;
    _cloudflareProcess = null;
    process?.kill();
  }

  Future<int> syncFromServer() async {
    _requireLogin();
    final response = await _client.get(
      _appUri('/api/prizes?includeHidden=1'),
      headers: _headers,
    );
    _throwIfFailed(response);
    final prizes = (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await _database.transaction(() async {
      for (final prize in prizes) {
        if (prize['status'] == 'hidden') {
          await (_database.delete(
            _database.prizeItems,
          )..where((t) => t.id.equals(prize['id'] as int))).go();
          continue;
        }
        await _database
            .into(_database.prizeItems)
            .insertOnConflictUpdate(_prizeCompanion(prize));
      }
    });
    return prizes.length;
  }

  Future<void> syncPrizeDetailFromServer(int prizeId) async {
    _requireLogin();
    final response = await _client.get(
      _appUri('/api/prizes/$prizeId'),
      headers: _headers,
    );
    _throwIfFailed(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final prize = body['prize'] as Map<String, dynamic>;
    final logs = (body['logs'] as List<dynamic>).cast<Map<String, dynamic>>();

    await _database.transaction(() async {
      await _database
          .into(_database.prizeItems)
          .insertOnConflictUpdate(_prizeCompanion(prize));
      await (_database.delete(
        _database.prizeAcquisitionLogs,
      )..where((t) => t.prizeId.equals(prizeId))).go();
      for (final log in logs) {
        await _database
            .into(_database.prizeAcquisitionLogs)
            .insert(_logCompanion(log));
      }
    });
  }

  Future<void> updateStatus(int prizeId, String status) async {
    if (!isLoggedIn) return;
    final response = await _client.patch(
      _appUri('/api/prizes/$prizeId/status'),
      headers: _headers,
      body: jsonEncode({'status': status}),
    );
    _throwIfFailed(response);
  }

  Future<void> updateMemo(int prizeId, String memo) async {
    if (!isLoggedIn) return;
    final response = await _client.patch(
      _appUri('/api/prizes/$prizeId/memo'),
      headers: _headers,
      body: jsonEncode({'memo': memo}),
    );
    _throwIfFailed(response);
  }

  Future<void> addAcquisitionLog(
    int prizeId, {
    String? method,
    String? place,
    int? costYen,
    String? memo,
  }) async {
    if (!isLoggedIn) return;
    final response = await _client.post(
      _appUri('/api/prizes/$prizeId/logs'),
      headers: _headers,
      body: jsonEncode({
        'method': method,
        'place': place,
        'costYen': costYen,
        'memo': memo,
      }),
    );
    _throwIfFailed(response);
  }

  Future<List<FigureSearchResult>> searchFigures(String query) async {
    _requireLogin();
    final response = await _client.get(
      _appUri('/api/figure-search?q=${Uri.encodeQueryComponent(query)}'),
      headers: _headers,
    );
    _throwIfFailed(response);
    return (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(
          (json) => FigureSearchResult(
            title: json['title'] as String,
            sourceUrl: json['sourceUrl'] as String?,
            snippet: json['snippet'] as String?,
            imageUrl: _absoluteImageUrl(json['imageUrl'] as String?),
          ),
        )
        .toList(growable: false);
  }

  Future<int> createFigure({
    required String title,
    String? workTitle,
    String? characterName,
    String? seriesName,
    String? maker,
    String? releaseText,
    String? sourceUrl,
    String? imageUrl,
  }) async {
    _requireLogin();
    final response = await _client.post(
      _appUri('/api/prizes'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'workTitle': workTitle,
        'characterName': characterName,
        'seriesName': seriesName,
        'maker': maker,
        'releaseText': releaseText,
        'sourceUrl': sourceUrl,
        'imageUrl': imageUrl,
      }),
    );
    _throwIfFailed(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['id'] as int;
  }

  Future<void> hidePrize(int prizeId) async {
    if (!isLoggedIn) return;
    final response = await _client.delete(
      _appUri('/api/prizes/$prizeId'),
      headers: _headers,
    );
    _throwIfFailed(response);
  }

  PrizeItemsCompanion _prizeCompanion(Map<String, dynamic> json) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return PrizeItemsCompanion.insert(
      id: Value(json['id'] as int),
      title: json['title'] as String,
      workTitle: json['workTitle'] as String,
      characterName: json['characterName'] as String,
      seriesName: json['seriesName'] as String,
      maker: json['maker'] as String,
      releaseText: json['releaseText'] as String,
      releaseYear: Value(json['releaseYear'] as int?),
      releaseMonth: Value(json['releaseMonth'] as int?),
      sourceUrl: Value(json['sourceUrl'] as String?),
      imageUrl: Value(_absoluteImageUrl(json['imageUrl'] as String?)),
      status: Value(json['status'] as String? ?? PrizeStatus.unowned),
      memo: Value(json['memo'] as String?),
      acquiredAtEpochMs: Value(json['acquiredAtEpochMs'] as int?),
      createdAtEpochMs: json['createdAtEpochMs'] as int? ?? now,
      updatedAtEpochMs: json['updatedAtEpochMs'] as int? ?? now,
    );
  }

  PrizeAcquisitionLogsCompanion _logCompanion(Map<String, dynamic> json) {
    return PrizeAcquisitionLogsCompanion.insert(
      prizeId: json['prizeId'] as int,
      method: Value(json['method'] as String?),
      place: Value(json['place'] as String?),
      costYen: Value(json['costYen'] as int?),
      memo: Value(json['memo'] as String?),
      createdAtEpochMs: json['createdAtEpochMs'] as int,
    );
  }

  String? _absoluteImageUrl(String? value) {
    if (value == null || value.isEmpty) return value;
    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) return value;
    return _appUri(value).toString();
  }

  Uri _appUri(String path) => Uri.parse(appBaseUrl).resolve(path);

  Uri _controlUri(String path) => Uri.parse(controlBaseUrl).resolve(path);

  String _normalizeLoopbackBaseUrl(String value) {
    final trimmed = value.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.host != 'localhost') return trimmed;
    return uri.replace(host: '127.0.0.1').toString();
  }

  Future<http.Response> _controlRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request();
    } on SocketException {
      if (!await _startLocalControlServer()) {
        throw const ServerSyncException(
          'サーバー管理機能に接続できません。Node.jsをインストールしてから、webappフォルダで `node supervisor.js` を起動してください。',
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 900));
      try {
        return await request();
      } on SocketException {
        throw const ServerSyncException(
          'サーバー管理機能を起動できませんでした。Node.jsをインストールしてから、webappフォルダで `node supervisor.js` を起動してください。',
        );
      }
    }
  }

  Future<bool> _startLocalControlServer() async {
    final webappDirectory = await _findWebappDirectory();
    if (webappDirectory == null) return false;
    final script = File(p.join(webappDirectory.path, 'supervisor.js'));
    if (!await script.exists()) return false;

    try {
      await Process.start(
        'node',
        [script.path],
        workingDirectory: script.parent.path,
        mode: ProcessStartMode.detached,
      );
      return true;
    } on Object {
      return false;
    }
  }

  Future<Directory?> _findWebappDirectory() async {
    final candidates = <Directory>[
      Directory(p.join(Directory.current.path, 'webapp')),
      Directory(p.join(p.dirname(Platform.resolvedExecutable), 'webapp')),
    ];

    var current = Directory.current;
    for (var i = 0; i < 6; i++) {
      candidates.add(Directory(p.join(current.path, 'webapp')));
      final parent = current.parent;
      if (parent.path == current.path) break;
      current = parent;
    }

    for (final candidate in candidates) {
      if (await File(p.join(candidate.path, 'supervisor.js')).exists()) {
        return candidate;
      }
    }
    return null;
  }

  Future<File> _sessionFile() async {
    final directory = await getApplicationSupportDirectory();
    return File(p.join(directory.path, 'server_session.json'));
  }

  void _storeCookie(http.Response response) {
    final cookie = response.headers['set-cookie'];
    if (cookie == null) return;
    _cookie = cookie.split(';').first;
  }

  void _requireLogin() {
    if (!isLoggedIn) {
      throw const ServerSyncException('サーバーにログインしてください');
    }
  }

  void _throwIfFailed(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    var message = 'HTTP ${response.statusCode}';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      message = body['error'] as String? ?? message;
    } on Object {
      // Keep the status message.
    }
    throw ServerSyncException(message);
  }
}
