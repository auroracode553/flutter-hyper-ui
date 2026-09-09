import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vitepress';
import { componentGroups } from './catalog';
import { validateCatalog } from './catalog-validation';

function withTrailingSlash(value: string) {
  return value.endsWith('/') ? value : `${value}/`;
}

const siteBase = withTrailingSlash(process.env.VITEPRESS_BASE || '/');
const repositoryRoot = fileURLToPath(new URL('../..', import.meta.url));
validateCatalog(repositoryRoot, componentGroups);

export default defineConfig({
  title: 'Flutter Hyper UI',
  description: 'Hy 柔光玻璃 Flutter UI 组件库',
  base: siteBase,
  cleanUrls: true,
  markdown: {
    lineNumbers: true,
  },
  vite: {
    server: {
      fs: {
        // 分类页以只读方式导入相邻 ui 包源码，修改参数后由 Vite HMR 实时更新 API 签名。
        allow: [repositoryRoot],
      },
    },
  },
  themeConfig: {
    logo: undefined,
    search: {
      provider: 'local',
    },
    nav: [
      { text: '指南', link: '/guide/getting-started' },
      { text: '组件', link: '/components/catalog' },
    ],
    sidebar: [
      {
        text: '指南',
        items: [
          { text: '快速开始', link: '/guide/getting-started' },
          { text: '文档与预览架构', link: '/guide/architecture' },
        ],
      },
      {
        text: '组件',
        items: [
          { text: '组件总览', link: '/components/catalog' },
          ...componentGroups.map((group) => ({ text: group.navTitle, link: group.page })),
        ],
      },
    ],
    outline: {
      level: [2, 3],
    },
  },
});
