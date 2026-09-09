const dartModules = import.meta.glob('../../../ui/lib/src/**/*.dart', {
  eager: true,
  query: '?raw',
  import: 'default',
}) as Record<string, string>;

function publicSymbols(label: string) {
  return label
    .split('/')
    .map((part) => part.trim().replace(/<.*>/, ''))
    .filter(Boolean);
}

function sourceFile(source: string) {
  const relativePath = source.startsWith('../')
    ? source.slice(3)
    : `components/${source}`;
  const suffix = `/ui/lib/src/${relativePath}`.replaceAll('\\', '/');
  const match = Object.entries(dartModules).find(([path]) => path.replaceAll('\\', '/').endsWith(suffix));
  return match?.[1];
}

function matchingBrace(source: string, openingIndex: number) {
  let depth = 0;
  for (let index = openingIndex; index < source.length; index += 1) {
    if (source[index] === '{') depth += 1;
    if (source[index] === '}') depth -= 1;
    if (depth === 0) return index;
  }
  return source.length - 1;
}

function callableSignature(source: string, start: number) {
  const opening = source.indexOf('(', start);
  if (opening < 0) return '';
  let depth = 0;
  for (let index = opening; index < source.length; index += 1) {
    if (source[index] === '(') depth += 1;
    if (source[index] === ')') depth -= 1;
    if (depth === 0) {
      return `${source.slice(start, index + 1).trim()};`
        .replace(/\s+/g, ' ')
        .replace(/\{ /g, '{\n  ')
        .replace(/, /g, ',\n  ')
        .replace(/ \}/g, '\n}');
    }
  }
  return '';
}

function extractSymbol(source: string, symbol: string) {
  const declaration = new RegExp(`(?:abstract\\s+final\\s+)?(?:class|enum|extension)\\s+${symbol}\\b`);
  const declarationMatch = declaration.exec(source);
  if (!declarationMatch) {
    const typedefMatch = new RegExp(`typedef\\s+${symbol}\\b[^;]+;`, 's').exec(source);
    return typedefMatch?.[0].replace(/\s+/g, ' ') ?? '';
  }

  const opening = source.indexOf('{', declarationMatch.index);
  if (opening < 0) return declarationMatch[0];
  const closing = matchingBrace(source, opening);
  const block = source.slice(declarationMatch.index, closing + 1);

  if (block.startsWith('enum ')) return block.replace(/\s+/g, ' ');

  const signatures: string[] = [];
  const constructors = new RegExp(`^(?:\\s*)(?:const\\s+|factory\\s+)?${symbol}(?:\\.\\w+)?\\s*\\(`, 'gm');
  for (const match of block.matchAll(constructors)) {
    const lineStart = match.index ?? 0;
    const signature = callableSignature(block, lineStart);
    if (signature) signatures.push(signature);
  }

  const staticMethods = /^\s*static\s+[^;\n=]+\(/gm;
  for (const match of block.matchAll(staticMethods)) {
    const signature = callableSignature(block, match.index ?? 0);
    if (signature) signatures.push(signature);
  }

  const staticValues = /^\s*static\s+const\s+[^;]+;/gm;
  for (const match of block.matchAll(staticValues)) {
    signatures.push(match[0].trim().replace(/\s+/g, ' '));
  }

  if (signatures.length === 0) return `${declarationMatch[0]} { … }`;
  return signatures.join('\n\n');
}

/** Extracts display-only public signatures from the same Dart files exported by the package. */
export function dartApiFor(label: string, source: string) {
  const file = sourceFile(source);
  if (!file) return '未找到对应源码文件。';
  const signatures = publicSymbols(label)
    .map((symbol) => extractSymbol(file, symbol))
    .filter(Boolean);
  return signatures.length > 0 ? signatures.join('\n\n') : '请查看源码中的公开声明。';
}
