import { Agent } from 'node:http';
import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vitepress';
import { componentGroups, componentSidebarSections, featuredDemo } from './catalog';
import { validateCatalog } from './catalog-validation';

function withTrailingSlash(value: string) {
  return value.endsWith('/') ? value : `${value}/`;
}

const siteBase = withTrailingSlash(process.env.VITEPRESS_BASE || '/');
const repositoryRoot = fileURLToPath(new URL('../..', import.meta.url));
const previewDevelopmentServer = process.env.VITE_HYPER_UI_PREVIEW_SERVER;
// Debug 的 DDC 会请求大量小模块；复用 Vite 到 Flutter 的本地连接。
const previewProxyAgent = previewDevelopmentServer
  ? new Agent({ keepAlive: true, maxSockets: 128 })
  : undefined;
validateCatalog(repositoryRoot, componentGroups, [featuredDemo]);

export default defineConfig({
  title: 'Hyper UI',
  titleTemplate: ':title · Flutter Hyper UI',
  description: '面向 Flutter 移动端的通用柔性玻璃 UI 组件库',
  base: siteBase,
  cleanUrls: true,
  head: [
    ['meta', { name: 'theme-color', content: '#f4f6fb' }],
    ['link', { rel: 'icon', type: 'image/svg+xml', href: `${siteBase}hyper-ui-logo.svg` }],
  ],
  markdown: {
    lineNumbers: true,
    // 代码块背景随亮/暗模式切换（见 _tokens.scss 的 --vp-code-block-bg），
    // shiki 配色也跟随：浅色模式用 vitesse-light，暗色模式用 vitesse-dark。
    theme: { light: 'vitesse-light', dark: 'vitesse-dark' },
  },
  vite: {
    css: {
      preprocessorOptions: {
        scss: {
          api: 'modern',
        },
      },
    },
    server: {
      proxy: previewDevelopmentServer ? {
        '/preview': {
          target: previewDevelopmentServer,
          agent: previewProxyAgent,
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
    logo: '/hyper-ui-logo.svg',
    siteTitle: 'Hyper UI',
    search: {
      provider: 'local',
    },
    nav: [],
    // 指南与组件共用同一棵侧边栏树，类似 element-plus：指南之后直接展开组件分类。
    sidebar: [
      {
        text: '指南',
        collapsed: false,
        items: [
          { text: '快速开始', link: '/guide/getting-started' },
          { text: '主题配置', link: '/guide/theming' },
          { text: '设计系统', link: '/guide/design-system' },
        ],
      },
      {
        text: '组件总览',
        link: '/components/catalog',
      },
      ...componentSidebarSections.map((section) => ({
        text: section.title,
        collapsed: false,
        items: section.components.map((entry) => ({
          text: entry.navName.replace(/^Hyper(?=[A-Z])/, ''),
          link: entry.page,
        })),
      })),
    ],
    outline: {
      level: [2, 3],
      label: '本页目录',
    },
    docFooter: {
      prev: false,
      next: false,
    },
    lastUpdated: false,
  },
});
