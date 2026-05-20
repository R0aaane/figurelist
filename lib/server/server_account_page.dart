import 'package:flutter/material.dart';

import 'server_sync_service.dart';

class ServerAccountPage extends StatefulWidget {
  const ServerAccountPage({super.key, required this.service});

  final ServerSyncService service;

  @override
  State<ServerAccountPage> createState() => _ServerAccountPageState();
}

class _ServerAccountPageState extends State<ServerAccountPage> {
  late final TextEditingController _appUrlController;
  late final TextEditingController _controlUrlController;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _busy = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _appUrlController = TextEditingController(text: widget.service.appBaseUrl);
    _controlUrlController = TextEditingController(
      text: widget.service.controlBaseUrl,
    );
  }

  @override
  void dispose() {
    _appUrlController.dispose();
    _controlUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('サーバー同期')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _appUrlController,
            decoration: const InputDecoration(
              labelText: 'アプリURL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controlUrlController,
            decoration: const InputDecoration(
              labelText: '管理URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: _busy ? null : () => _auth(register: false),
                icon: const Icon(Icons.login),
                label: const Text('ログイン'),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : () => _auth(register: true),
                icon: const Icon(Icons.person_add),
                label: const Text('登録'),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _sync,
                icon: const Icon(Icons.sync),
                label: const Text('同期'),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _restartServer,
                icon: const Icon(Icons.restart_alt),
                label: const Text('サーバー再起動'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.service.isLoggedIn)
            Text('ログイン中: ${widget.service.username}'),
          if (_busy) const LinearProgressIndicator(),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(_message!),
          ],
        ],
      ),
    );
  }

  Future<void> _auth({required bool register}) async {
    await _run(() async {
      _saveUrls();
      if (register) {
        await widget.service.register(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await widget.service.login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
      }
      final count = await widget.service.syncFromServer();
      return '${register ? '登録' : 'ログイン'}しました。$count件を同期しました。';
    });
  }

  Future<void> _sync() async {
    await _run(() async {
      _saveUrls();
      final count = await widget.service.syncFromServer();
      return '$count件を同期しました。';
    });
  }

  Future<void> _restartServer() async {
    await _run(() async {
      _saveUrls();
      await widget.service.restartServer();
      await Future<void>.delayed(const Duration(seconds: 2));
      await widget.service.startServer();
      return 'サーバーを再起動しました。';
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

  void _saveUrls() {
    widget.service.appBaseUrl = _appUrlController.text.trim();
    widget.service.controlBaseUrl = _controlUrlController.text.trim();
  }
}
