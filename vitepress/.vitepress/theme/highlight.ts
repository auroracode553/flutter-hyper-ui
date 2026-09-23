import { createHighlighter, type Highlighter } from 'shiki';

/**
 * 惰性创建共享的 Shiki 高亮器，只加载 dart 语言与两套主题（浅色/深色），
 * 避免在每个 DemoBlock 实例上重复初始化。明暗切换由 CSS 根据 .dark 类完成。
 */
let highlighterPromise: Promise<Highlighter> | null = null;

function getHighlighter(): Promise<Highlighter> {
  if (!highlighterPromise) {
    highlighterPromise = createHighlighter({
      themes: ['vitesse-light', 'vitesse-dark'],
      langs: ['dart'],
    });
  }
  return highlighterPromise;
}

function escapeHtml(source: string): string {
  return source
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

/** 将 Dart 示例源码高亮为带行内颜色的 HTML（含 <pre class="shiki">）。 */
export async function highlightDart(source: string): Promise<string> {
  if (!source) return '';
  try {
    const highlighter = await getHighlighter();
    return highlighter.codeToHtml(source, {
      lang: 'dart',
      themes: { light: 'vitesse-light', dark: 'vitesse-dark' },
    });
  } catch {
    return `<pre class="shiki"><code>${escapeHtml(source)}</code></pre>`;
  }
}
