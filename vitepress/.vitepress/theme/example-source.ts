const exampleModules = import.meta.glob('../../../preview/lib/src/examples/**/*.dart', {
  eager: true,
  query: '?raw',
  import: 'default',
}) as Record<string, string>;

/** Reads the exact Dart file used by PreviewCatalog instead of duplicating code in docs metadata. */
export function exampleSourceFor(source: string) {
  const suffix = `/preview/lib/src/examples/${source}`.replaceAll('\\', '/');
  const match = Object.entries(exampleModules).find(([path]) => (
    path.replaceAll('\\', '/').endsWith(suffix)
  ));
  return match?.[1] ?? `未找到演示源码：${source}`;
}
