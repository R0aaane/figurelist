import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
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

class ServerSyncService {
  ServerSyncService(this._database);

  final AppDatabase _database;
  final _client = http.Client();

  String appBaseUrl = 'http://localhost:4173';
  String controlBaseUrl = 'http://localhost:4172';
  String? _cookie;
  String? username;

  bool get isLoggedIn => username != null && _cookie != null;

  Map<String, String> get _headers {
    return {
      'content-type': 'application/json',
      ...?_cookie == null ? null : {'cookie': _cookie!},
    };
  }

  Future<void> register({
    required String username,
    required String password,
  }) async {
    await _authenticate('register', username: username, password: password);
    await saveSession();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    await _authenticate('login', username: username, password: password);
    await saveSession();
  }

  Future<bool> restoreSession() async {
    final file = await _sessionFile();
    if (!await file.exists()) return false;

    try {
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      appBaseUrl = json['appBaseUrl'] as String? ?? appBaseUrl;
      controlBaseUrl = json['controlBaseUrl'] as String? ?? controlBaseUrl;
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
  }) async {
    final response = await _client.post(
      _appUri('/api/auth/$mode'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    _throwIfFailed(response);
    _storeCookie(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    this.username = (body['user'] as Map<String, dynamic>)['username'] as String;
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
    final file = await _sessionFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Map<String, dynamic>> serverStatus() async {
    final response = await _client.get(_controlUri('/api/server/status'));
    _throwIfFailed(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> restartServer() async {
    final response = await _client.post(_controlUri('/api/server/restart'));
    _throwIfFailed(response);
  }

  Future<void> startServer() async {
    final response = await _client.post(_controlUri('/api/server/start'));
    _throwIfFailed(response);
  }

  Future<void> stopServer() async {
    final response = await _client.post(_controlUri('/api/server/stop'));
    _throwIfFailed(response);
  }

  Future<int> syncFromServer() async {
    _requireLogin();
    final response = await _client.get(_appUri('/api/prizes'), headers: _headers);
    _throwIfFailed(response);
    final prizes = (jsonDecode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await _database.transaction(() async {
      for (final prize in prizes) {
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
      await (_database.delete(_database.prizeAcquisitionLogs)
            ..where((t) => t.prizeId.equals(prizeId)))
          .go();
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
