import { existsSync, readFileSync } from 'node:fs';
import { resolve } from 'node:path';

import type { ComponentGroup } from './catalog';

function assertUnique(values: string[], label: string) {
  const duplicates = values.filter((value, index) => values.indexOf(value) !== index);
  if (duplicates.length > 0) {
    throw new Error(`${label} 存在重复值: ${[...new Set(duplicates)].join(', ')}`);
  }
}

/** VitePress 启动和构建时执行的只读契约检查。 */
export function validateCatalog(repositoryRoot: string, groups: ComponentGroup[]) {
  assertUnique(groups.map((group) => group.id), '组件分类 id');
  assertUnique(groups.map((group) => group.page), '组件分类 page');

  const previewCatalogPath = resolve(repositoryRoot, 'preview/lib/src/preview_catalog.dart');
  const previewCatalog = readFileSync(previewCatalogPath, 'utf8');
  const registeredPreviewIds = new Set(
    [...previewCatalog.matchAll(/\bid:\s*'([^']+)'/g)].map((match) => match[1]),
  );
  const missingPreviewIds = groups
    .map((group) => group.previewId)
    .filter((previewId) => !registeredPreviewIds.has(previewId));
  if (missingPreviewIds.length > 0) {
    throw new Error(`文档演示未在 PreviewCatalog 注册: ${missingPreviewIds.join(', ')}`);
  }

  const publicEntryPath = resolve(repositoryRoot, 'ui/lib/hy_ui.dart');
  const publicEntry = readFileSync(publicEntryPath, 'utf8');
  const sourceErrors: string[] = [];
  const documentedSymbols = new Set<string>();
  for (const group of groups) {
    for (const entry of group.components) {
      const relativeSource = entry.source.startsWith('../')
        ? entry.source.slice(3)
        : `components/${entry.source}`;
      const diskPath = resolve(repositoryRoot, 'ui/lib/src', relativeSource);
      const exportStatement = `export 'src/${relativeSource.replaceAll('\\', '/')}';`;
      if (!existsSync(diskPath)) sourceErrors.push(`${entry.name}: 源文件不存在 (${relativeSource})`);
      else if (!publicEntry.includes(exportStatement)) sourceErrors.push(`${entry.name}: 未从 hy_ui.dart 导出`);
      else {
        const source = readFileSync(diskPath, 'utf8');
        for (const rawSymbol of entry.name.split('/')) {
          const symbol = rawSymbol.trim().replace(/<.*>/, '');
          documentedSymbols.add(symbol);
          const declaration = new RegExp(`(?:class|enum|extension|typedef)\\s+${symbol}\\b`);
          if (!declaration.test(source)) sourceErrors.push(`${entry.name}: ${symbol} 不在 ${relativeSource} 中`);
        }
      }
    }
  }

  const exportedSources = [...publicEntry.matchAll(/export 'src\/([^']+\.dart)';/g)]
    .map((match) => resolve(repositoryRoot, 'ui/lib/src', match[1]));
  const undocumentedSymbols: string[] = [];
  for (const sourcePath of exportedSources) {
    const source = readFileSync(sourcePath, 'utf8');
    const declarations = source.matchAll(
      /^(?:abstract\s+final\s+)?(?:class|enum|extension)\s+(Hy\w+)|^typedef\s+(Hy\w+)/gm,
    );
    for (const declaration of declarations) {
      const symbol = declaration[1] || declaration[2];
      if (!documentedSymbols.has(symbol)) undocumentedSymbols.push(symbol);
    }
  }
  if (undocumentedSymbols.length > 0) {
    sourceErrors.push(`公开 API 未进入组件目录: ${undocumentedSymbols.join(', ')}`);
  }
  if (sourceErrors.length > 0) throw new Error(`组件目录契约失败:\n${sourceErrors.join('\n')}`);
}
