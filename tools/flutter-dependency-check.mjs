import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

function* dartSourceFiles(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const path = join(directory, entry.name);
    if (entry.isDirectory()) yield* dartSourceFiles(path);
    else if (entry.isFile() && entry.name.endsWith('.dart')) yield path;
  }
}

/** 只读检查包解析与源码入口；不下载依赖，不调用 Flutter。 */
export function assertFlutterDependencies({ projectDirectory, sourceDirectories }) {
  const configPath = resolve(projectDirectory, '.dart_tool', 'package_config.json');
  const preparation = `请先在 ${projectDirectory} 手动执行 flutter pub get，再重新启动文档开发服务。`;
  if (!existsSync(configPath)) {
    throw new Error(`Flutter 依赖尚未准备：缺少 package_config.json。\n${preparation}`);
  }

  let config;
  try {
    config = JSON.parse(readFileSync(configPath, 'utf8'));
  } catch {
    throw new Error(`Flutter 包解析配置无法读取。\n${preparation}`);
  }
  if (config.configVersion !== 2 || !Array.isArray(config.packages)) {
    throw new Error(`Flutter 包解析配置格式不正确。\n${preparation}`);
  }

  const packages = new Map(config.packages.map((entry) => [entry.name, entry]));
  const configUrl = pathToFileURL(configPath);
  const missingImports = new Set();
  for (const directory of sourceDirectories) {
    for (const path of dartSourceFiles(directory)) {
      const source = readFileSync(path, 'utf8');
      // 从真实导入提取包路径，避免重复维护第三方依赖名单。
      const imports = source.matchAll(/^\s*(?:import|export)\s+['"]package:([^/'"]+)\/([^'"]+)['"]/gm);
      for (const [, name, libraryPath] of imports) {
        const entry = packages.get(name);
        if (!entry) {
          missingImports.add(`package:${name}/${libraryPath}`);
          continue;
        }
        try {
          const root = new URL(entry.rootUri, configUrl);
          // package_config 的 rootUri 表示目录，即使末尾没有斜杠。
          if (!root.pathname.endsWith('/')) root.pathname += '/';
          const libraryBase = new URL(entry.packageUri ?? '', root);
          if (!existsSync(new URL(libraryPath, libraryBase))) {
            missingImports.add(`package:${name}/${libraryPath}`);
          }
        } catch {
          missingImports.add(`package:${name}/${libraryPath}`);
        }
      }
    }
  }

  if (missingImports.size) {
    throw new Error(
      `Flutter 依赖解析缺失或已失效：\n${[...missingImports].sort().join('\n')}\n${preparation}`,
    );
  }
}
