import DefaultTheme from 'vitepress/theme';
import type { Theme } from 'vitepress';
import DemoBlock from './components/DemoBlock.vue';
import './style.css';

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component('DemoBlock', DemoBlock);
  },
} satisfies Theme;
