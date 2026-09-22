import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vitepress';
import { componentGroups, featuredDemo } from './catalog';
import { validateCatalog } from './catalog-validation';

function withTrailingSlash(value: string) {
  return value.endsWith('/') ? value : `${value}/`;
}

const siteBase = withTrailingSlash(process.env.VITEPRESS_BASE || '/');
const repositoryRoot = fileURLToPath(new URL('../..', import.meta.url));
const previewDevelopmentServer = process.env.VITE_HY_UI_PREVIEW_SERVER;
validateCatalog(repositoryRoot, componentGroups, [featuredDemo]);

export default defineConfig({
  title: 'Hy UI',
  titleTemplate: ':title · Flutter Hyper UI',
  description: '面向 Flutter 移动端的通用柔性玻璃 UI 组件库',
  base: siteBase,
  cleanUrls: true,
  head: [
    ['meta', { name: 'theme-color', content: '#f4f6fb' }],
    ['link', { rel: 'icon', type: 'image/svg+xml', href: `${siteBase}hy-ui-logo.svg` }],
  ],
  markdown: {
    lineNumbers: true,
  },
  vite: {
    server: {
      proxy: previewDevelopmentServer ? {
        '/preview': {
          target: previewDevelopmentServer,
          changeOrigin: true,
          ws: true,
          rewrite: (path) => path.replace(/^\/preview/, ''),
        },
      } : undefined,
      fs: {
        // 分类页以只读方式导入相邻 ui 包源码，修改参数后由 Vite HMR 实时更新 API 签名。
        allow: [repositoryRoot],
      },
    },
  },
  themeConfig: {
    logo: '/hy-ui-logo.svg',
    siteTitle: 'Hy UI',
    search: {
      provider: 'local',
    },
    nav: [
      { text: '开始', link: '/guide/getting-started' },
      { text: '设计系统', link: '/guide/design-system' },
      { text: '组件', link: '/components/catalog' },
    ],
    sidebar: [
      {
        text: '指南',
        items: [
          { text: '快速开始', link: '/guide/getting-started' },
          { text: '设计系统', link: '/guide/design-system' },
          { text: '主题与令牌', link: '/guide/theming' },
          { text: '无障碍与自适应', link: '/guide/accessibility' },
          { text: '架构与依赖边界', link: '/guide/architecture' },
          { text: '文档开发', link: '/guide/documentation' },
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
    docFooter: {
      prev: '上一篇',
      next: '下一篇',
    },
    lastUpdated: {
      text: '最后更新',
    },
  },
});
