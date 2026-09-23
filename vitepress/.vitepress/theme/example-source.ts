const exampleModules = import.meta.glob('../../../preview/lib/src/examples/**/*.dart', {
  eager: true,
  query: '?raw',
  import: 'default',
}) as Record<string, string>;

function importsFrom(source: string) {
  const imports: string[] = [];
  for (const line of source.split('\n')) {
    if (line.startsWith('import ')) {
      imports.push(line);
      continue;
    }
    if (line.trim() === '' && imports.length > 0) continue;
    if (imports.length > 0) break;
  }
  return imports.join('\n');
}

function regionFrom(source: string, symbol: string) {
  const startMarker = `// doc-region ${symbol}`;
  const endMarker = `// end-doc-region ${symbol}`;
  const start = source.indexOf(startMarker);
  const end = source.indexOf(endMarker, start + startMarker.length);
  if (start < 0 || end < 0) return undefined;
  const imports = importsFrom(source);
  const body = source.slice(start + startMarker.length, end).trim();
  return imports ? `${imports}\n\n${body}` : body;
}

/** Reads the exact Dart example or a marked component-only region from the PreviewCatalog source. */
export function exampleSourceFor(source: string, symbol?: string) {
  const suffix = `/preview/lib/src/examples/${source}`.replaceAll('\\', '/');
  const match = Object.entries(exampleModules).find(([path]) => (
    path.replaceAll('\\', '/').endsWith(suffix)
  ));
  if (!match) return `未找到演示源码：${source}`;
  if (!symbol) return match[1];
  return regionFrom(match[1], symbol) ?? `未找到演示片段：${symbol}`;
}
