import { spawnSync } from 'node:child_process';
import { cpSync, existsSync, rmSync } from 'node:fs';
import { dirname, resolve, sep } from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDirectory = dirname(fileURLToPath(import.meta.url));
const repositoryRoot = resolve(scriptDirectory, '..');
const previewDirectory = resolve(repositoryRoot, 'preview');
const flutterOutput = resolve(previewDirectory, 'build', 'web');
const vitepressDirectory = resolve(repositoryRoot, 'vitepress');
const publicDirectory = resolve(vitepressDirectory, 'public');
const previewPublicDirectory = resolve(publicDirectory, 'preview');
const previewBaseHref = process.env.PREVIEW_BASE_HREF || '/preview/';

function run(command, args, cwd, env = process.env) {
  const result = spawnSync([command, ...args].join(' '), {
    cwd,
    env,
    shell: true,
    stdio: 'inherit',
    windowsHide: true,
  });
  if (result.error) throw result.error;
  if (result.status !== 0) process.exit(result.status ?? 1);
}

function assertSafePreviewTarget() {
  const expectedParent = `${publicDirectory}${sep}`.toLowerCase();
  if (!`${previewPublicDirectory}${sep}`.toLowerCase().startsWith(expectedParent)) {
    throw new Error(`拒绝清理非文档目录：${previewPublicDirectory}`);
  }
}

console.log('构建 Flutter Web release…');
run(
  'flutter',
  ['build', 'web', '--release', '--no-web-resources-cdn', '--base-href', previewBaseHref],
  previewDirectory,
);

if (!existsSync(resolve(flutterOutput, 'main.dart.js'))) {
  throw new Error(`Flutter 构建产物不完整：${flutterOutput}`);
}

assertSafePreviewTarget();
console.log('同步 Flutter 产物到 VitePress public/preview…');
rmSync(previewPublicDirectory, { recursive: true, force: true });
cpSync(flutterOutput, previewPublicDirectory, { recursive: true });

console.log('构建 VitePress 文档…');
run('npm', ['run', 'build'], vitepressDirectory);
console.log('本地文档构建完成；脚本未执行任何部署操作。');
