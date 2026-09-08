import { defineConfig } from 'vitepress';

function withTrailingSlash(value: string) {
  return value.endsWith('/') ? value : `${value}/`;
}

const siteBase = withTrailingSlash(process.env.VITEPRESS_BASE || '/');

export default defineConfig({
  title: 'Flutter Hyper UI',
  description: 'Hy 柔光玻璃 Flutter UI 组件库',
  base: siteBase,
  cleanUrls: true,
  markdown: {
    lineNumbers: true,
  },
  themeConfig: {
    logo: undefined,
    search: {
      provider: 'local',
    },
    nav: [
      { text: '指南', link: '/guide/getting-started' },
      { text: '组件', link: '/components/button' },
    ],
    sidebar: [
      {
        text: '指南',
        items: [
          { text: '快速开始', link: '/guide/getting-started' },
        ],
      },
      {
        text: '组件',
        items: [
          { text: '完整组件与交互', link: '/components/catalog' },
          { text: 'Button 按钮', link: '/components/button' },
          { text: 'Card 卡片', link: '/components/card' },
          { text: 'Input 输入', link: '/components/input' },
          { text: 'Data 数据展示', link: '/components/data' },
          { text: 'Feedback 反馈', link: '/components/feedback' },
          { text: 'Navigation 导航', link: '/components/navigation' },
        ],
      },
    ],
    outline: {
      level: [2, 3],
    },
  },
});
