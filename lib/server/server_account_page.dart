import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'server_sync_service.dart';

class ServerAccountPage extends StatefulWidget {
  const ServerAccountPage({super.key, required this.service});

  final ServerSyncService service;

  @override
  State<ServerAccountPage> createState() => _ServerAccountPageState();
}

class _ServerAccountPageState extends State<ServerAccountPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _busy = false;
  String? _message;
  String? _cloudflareUrl;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.service.username ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showServerControls = !kIsWeb || widget.service.isAdmin;

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _busy ? null : _auth(register: false),
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
              if (showServerControls) ...[
                OutlinedButton.icon(
                  onPressed: _busy ? null : _restartServer,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('サーバー再起動'),
                ),
                FilledButton.icon(
                  onPressed: _busy ? null : _startCloudflare,
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Cloudflare公開'),
                ),
                OutlinedButton.icon(
                  onPressed: _busy || !widget.service.isCloudflareTunnelRunning
                      ? null
                      : _stopCloudflare,
                  icon: const Icon(Icons.cloud_off_outlined),
                  label: const Text('Cloudflare停止'),
                ),
              ],
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
          if (_cloudflareUrl != null) ...[
            const SizedBox(height: 12),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Cloudflare公開URL',
                border: OutlineInputBorder(),
              ),
              child: Row(
                children: [
                  Expanded(child: SelectableText(_cloudflareUrl!)),
                  IconButton(
                    tooltip: 'URLを開く',
                    onPressed: _busy ? null : _openCloudflareUrl,
                    icon: const Icon(Icons.open_in_new),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _auth({required bool register}) async {
    await _run(() async {
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
      final count = await widget.service.syncFromServer();
      return '$count件を同期しました。';
    });
  }

  Future<void> _restartServer() async {
    await _run(() async {
      await widget.service.restartServer();
      await Future<void>.delayed(const Duration(seconds: 2));
      await widget.service.startServer();
      return 'サーバーを再起動しました。';
    });
  }

  Future<void> _startCloudflare() async {
    await _run(() async {
      final url = await widget.service.startCloudflareTunnel();
      if (mounted) setState(() => _cloudflareUrl = url);
      return 'Cloudflare Tunnelを起動しました。\n$url';
    });
  }

  Future<void> _stopCloudflare() async {
    await _run(() async {
      await widget.service.stopCloudflareTunnel();
      if (mounted) setState(() => _cloudflareUrl = null);
      return 'Cloudflare Tunnelを停止しました。';
    });
  }

  Future<void> _openCloudflareUrl() async {
    final url = _cloudflareUrl;
    if (url == null) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
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
}
