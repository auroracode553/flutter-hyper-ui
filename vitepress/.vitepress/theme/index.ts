import DefaultTheme from 'vitepress/theme';
import type { Theme } from 'vitepress';
import DemoBlock from './components/DemoBlock.vue';
import ComponentReference from './components/ComponentReference.vue';
import CatalogOverview from './components/CatalogOverview.vue';
import './style.css';

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component('DemoBlock', DemoBlock);
    app.component('ComponentReference', ComponentReference);
    app.component('CatalogOverview', CatalogOverview);
  },
} satisfies Theme;
