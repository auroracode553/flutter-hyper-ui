import { spawn, spawnSync } from 'node:child_process';
import { existsSync, watch } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDirectory = dirname(fileURLToPath(import.meta.url));
const repositoryRoot = resolve(scriptDirectory, '..');
const previewDirectory = resolve(repositoryRoot, 'preview');
const vitepressDirectory = resolve(repositoryRoot, 'vitepress');
const flutterPort = '4201';
const flutterOrigin = `http://127.0.0.1:${flutterPort}`;

function start(command, args, options) {
  return spawn([command, ...args].join(' '), {
    shell: true,
    windowsHide: true,
    ...options,
  });
}

function stopProcessTree(child) {
  if (!child?.pid || child.exitCode !== null) return;
  if (process.platform === 'win32') {
    spawnSync('taskkill', ['/pid', String(child.pid), '/t', '/f'], {
      stdio: 'ignore',
      windowsHide: true,
    });
  } else {
    child.kill('SIGTERM');
  }
}

for (const directory of [previewDirectory, vitepressDirectory]) {
  if (!existsSync(directory)) throw new Error(`缺少目录：${directory}`);
}

console.log('启动 Flutter Web 调试服务（原生热重载）…');
const flutter = start(
  'flutter',
  [
    'run',
    '-d', 'web-server',
    '--web-hostname', '127.0.0.1',
    '--web-port', flutterPort,
  ],
  {
    cwd: previewDirectory,
    stdio: ['pipe', 'inherit', 'inherit'],
  },
);

console.log('启动 VitePress，并将 /preview 代理到 Flutter 调试服务…');
const vitepress = start('npm', ['run', 'dev'], {
  cwd: vitepressDirectory,
  stdio: 'inherit',
  env: {
    ...process.env,
    VITE_HY_UI_PREVIEW_MODE: 'dev-server',
    VITE_HY_UI_PREVIEW_SERVER: flutterOrigin,
  },
});

let reloadTimer;
let shuttingDown = false;
const watchers = [
  resolve(repositoryRoot, 'ui', 'lib'),
  resolve(repositoryRoot, 'preview', 'lib'),
].map((directory) => watch(directory, { recursive: true }, (_event, filename) => {
  if (!filename?.toLowerCase().endsWith('.dart')) return;
  clearTimeout(reloadTimer);
  reloadTimer = setTimeout(() => {
    if (flutter.exitCode !== null || !flutter.stdin.writable) return;
    console.log(`Dart 已变化：${filename}，请求 Flutter 热重载…`);
    flutter.stdin.write('r\n');
  }, 250);
}));

function shutdown(exitCode = 0) {
  if (shuttingDown) return;
  shuttingDown = true;
  clearTimeout(reloadTimer);
  for (const watcher of watchers) watcher.close();
  stopProcessTree(vitepress);
  stopProcessTree(flutter);
  process.exit(exitCode);
}

flutter.on('error', (error) => {
  console.error(`Flutter 启动失败：${error.message}`);
  shutdown(1);
});
vitepress.on('error', (error) => {
  console.error(`VitePress 启动失败：${error.message}`);
  shutdown(1);
});
flutter.on('exit', (code) => {
  if (!shuttingDown) shutdown(code ?? 1);
});
vitepress.on('exit', (code) => {
  if (!shuttingDown) shutdown(code ?? 1);
});
process.on('SIGINT', () => shutdown(0));
process.on('SIGTERM', () => shutdown(0));

console.log('开发文档：http://localhost:9000/components/catalog');
console.log('保存 Dart 文件后会自动发送热重载；按 Ctrl+C 同时停止两个服务。');
