import DefaultTheme from 'vitepress/theme';
import type { Theme } from 'vitepress';
import DemoBlock from './components/DemoBlock.vue';
import ComponentReference from './components/ComponentReference.vue';
import ComponentDoc from './components/ComponentDoc.vue';
import CatalogOverview from './components/CatalogOverview.vue';
import HomePage from './components/HomePage.vue';
import './style.css';

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component('DemoBlock', DemoBlock);
    app.component('ComponentReference', ComponentReference);
    app.component('ComponentDoc', ComponentDoc);
    app.component('CatalogOverview', CatalogOverview);
    app.component('HomePage', HomePage);
  },
} satisfies Theme;
