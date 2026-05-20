const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const { spawn } = require('node:child_process');
const { URL } = require('node:url');

const rootDir = __dirname;
const appPort = Number(process.env.APP_PORT || 4173);
const controlPort = Number(process.env.CONTROL_PORT || 4172);
const appUrl = `http://localhost:${appPort}`;
const logPath = path.join(rootDir, 'server.log');
const errorLogPath = path.join(rootDir, 'server.err.log');

let child = null;

function isRunning() {
  return Boolean(child && child.exitCode === null && !child.killed);
}

function startApp() {
  if (isRunning()) {
    return { started: false, running: true, pid: child.pid };
  }

  const out = fs.openSync(logPath, 'a');
  const err = fs.openSync(errorLogPath, 'a');
  child = spawn(process.execPath, ['server.js'], {
    cwd: rootDir,
    env: { ...process.env, PORT: String(appPort) },
    detached: false,
    stdio: ['ignore', out, err],
    windowsHide: true
  });

  child.on('exit', () => {
    child = null;
  });

  return { started: true, running: true, pid: child.pid };
}

function stopApp() {
  if (!isRunning()) {
    return { stopped: false, running: false };
  }
  const pid = child.pid;
  child.kill();
  return { stopped: true, running: false, pid };
}

function restartApp() {
  const stopped = stopApp();
  setTimeout(() => {
    startApp();
  }, 1200);
  return { restarting: true, stopped };
}

function send(res, status, value) {
  res.writeHead(status, {
    'content-type': 'application/json; charset=utf-8',
    'access-control-allow-origin': '*',
    'access-control-allow-methods': 'GET,POST,OPTIONS',
    'access-control-allow-headers': 'content-type'
  });
  res.end(JSON.stringify(value));
}

function serveControlPage(res) {
  res.writeHead(200, { 'content-type': 'text/html; charset=utf-8' });
  res.end(`<!doctype html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>FigureList Server Control</title>
  <style>
    body { margin: 0; background: #07101f; color: #edf4ff; font-family: "Segoe UI", system-ui, sans-serif; }
    main { max-width: 720px; margin: 0 auto; padding: 28px 16px; display: grid; gap: 16px; }
    .panel { border: 1px solid #2f486b; border-radius: 8px; background: #101a2b; padding: 16px; display: grid; gap: 14px; }
    .actions { display: flex; flex-wrap: wrap; gap: 10px; }
    button, a { min-height: 38px; border: 1px solid #2f486b; border-radius: 8px; background: #17385d; color: #edf4ff; padding: 8px 12px; text-decoration: none; cursor: pointer; }
    pre { white-space: pre-wrap; overflow-wrap: anywhere; background: #08101d; padding: 12px; border-radius: 8px; }
  </style>
</head>
<body>
  <main>
    <h1>FigureList Server Control</h1>
    <section class="panel">
      <p id="status">checking...</p>
      <div class="actions">
        <button id="start">Start</button>
        <button id="stop">Stop</button>
        <a href="${appUrl}" target="_blank" rel="noreferrer">Open App</a>
      </div>
      <pre id="json"></pre>
    </section>
  </main>
  <script>
    async function call(path, method = 'GET') {
      const response = await fetch(path, { method });
      return response.json();
    }
    async function refresh() {
      const data = await call('/api/server/status');
      document.querySelector('#status').textContent = data.running ? 'App server is running.' : 'App server is stopped.';
      document.querySelector('#json').textContent = JSON.stringify(data, null, 2);
    }
    document.querySelector('#start').onclick = async () => { await call('/api/server/start', 'POST'); await refresh(); };
    document.querySelector('#stop').onclick = async () => { await call('/api/server/stop', 'POST'); await refresh(); };
    refresh();
  </script>
</body>
</html>`);
}

const controlServer = http.createServer((req, res) => {
  if (req.method === 'OPTIONS') {
    return send(res, 204, {});
  }

  const url = new URL(req.url || '/', `http://${req.headers.host || 'localhost'}`);
  if (url.pathname === '/') {
    return serveControlPage(res);
  }
  if (url.pathname === '/api/server/status') {
    return send(res, 200, {
      running: isRunning(),
      appUrl,
      appPort,
      controlPort,
      pid: isRunning() ? child.pid : null
    });
  }
  if (req.method === 'POST' && url.pathname === '/api/server/start') {
    return send(res, 200, startApp());
  }
  if (req.method === 'POST' && url.pathname === '/api/server/stop') {
    return send(res, 200, stopApp());
  }
  if (req.method === 'POST' && url.pathname === '/api/server/restart') {
    return send(res, 200, restartApp());
  }
  send(res, 404, { error: 'Not found' });
});

startApp();

controlServer.listen(controlPort, () => {
  console.log(`FigureList control server running at http://localhost:${controlPort}`);
  console.log(`FigureList app server target: ${appUrl}`);
});
