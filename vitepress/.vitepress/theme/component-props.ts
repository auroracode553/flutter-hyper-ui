import type { ComponentPropDoc } from '../catalog';

export interface ApiProp {
  name: string;
  description: string;
  required: boolean;
  defaultValue: string;
}

function closingParenthesis(source: string, opening: number): number {
  let depth = 0;
  for (let index = opening; index < source.length; index += 1) {
    if (source[index] === '(') depth += 1;
    if (source[index] === ')') depth -= 1;
    if (depth === 0) return index;
  }
  return -1;
}

function splitParameters(source: string): string[] {
  const parameters: string[] = [];
  const depths: Record<string, number> = { '(': 0, '[': 0, '{': 0, '<': 0 };
  const matching: Record<string, string> = { ')': '(', ']': '[', '}': '{', '>': '<' };
  let start = 0;
  let quote = '';
  let escaped = false;

  for (let index = 0; index < source.length; index += 1) {
    const character = source[index];
    if (quote) {
      if (character === quote && !escaped) quote = '';
      escaped = character === '\\' && !escaped;
      continue;
    }
    if (character === '"' || character === "'") {
      quote = character;
    } else if (character in depths) {
      depths[character] += 1;
    } else if (character in matching && depths[matching[character]] > 0) {
      depths[matching[character]] -= 1;
    } else if (character === ',' && Object.values(depths).every((depth) => depth === 0)) {
      parameters.push(source.slice(start, index).trim());
      start = index + 1;
    }
  }
  parameters.push(source.slice(start).trim());
  return parameters.filter(Boolean);
}

function parseParameter(source: string, named: boolean): Omit<ApiProp, 'description'> | null {
  const required = source.startsWith('required ');
  const declaration = required ? source.slice('required '.length).trim() : source;
  if (declaration.startsWith('super.')) return null;

  const field = /^this\.(\w+)(?:\s*=\s*(.+))?$/s.exec(declaration);
  const typed = /^.+?\s+(\w+)(?:\s*=\s*(.+))?$/s.exec(declaration);
  const match = field ?? typed;
  if (!match) return null;
  const defaultValue = match[2]?.trim() || '—';
  return {
    name: match[1],
    required: required || (!named && defaultValue === '—'),
    defaultValue,
  };
}

function parseConstructor(code: string): Omit<ApiProp, 'description'>[] {
  const props: Omit<ApiProp, 'description'>[] = [];
  const constructor = /^\s*(?:const\s+|factory\s+)?Hyper\w*(?:\.\w+)?\s*\(/gm;
  for (const match of code.matchAll(constructor)) {
    const opening = code.indexOf('(', match.index);
    const closing = closingParenthesis(code, opening);
    if (closing < 0) continue;
    const argumentsText = code.slice(opening + 1, closing).trim();
    for (const group of splitParameters(argumentsText)) {
      const named = group.startsWith('{') && group.endsWith('}');
      const optionalPositional = group.startsWith('[') && group.endsWith(']');
      const parameters = named || optionalPositional
        ? splitParameters(group.slice(1, -1))
        : [group];
      for (const parameter of parameters) {
        const prop = parseParameter(parameter, named || optionalPositional);
        if (prop && !props.some((existing) => existing.name === prop.name)) props.push(prop);
      }
    }
  }
  return props;
}

/** Combine source-derived constructor defaults with the curated catalog descriptions. */
export function componentPropsFor(code: string, documented: ComponentPropDoc[]): ApiProp[] {
  const descriptionByName = new Map(documented.map(({ name, description }) => [name, description]));
  const props = parseConstructor(code).map((prop) => ({
    ...prop,
    description: descriptionByName.get(prop.name) ?? '参见公开签名。',
  }));
  for (const { name, description } of documented) {
    if (!props.some((prop) => prop.name === name)) {
      props.push({ name, description, required: false, defaultValue: '—' });
    }
  }
  return props;
}
