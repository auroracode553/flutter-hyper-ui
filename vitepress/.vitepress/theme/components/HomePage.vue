<script setup lang="ts">
import { withBase } from 'vitepress';
import { componentSidebarSections, featuredDemo } from '../../catalog';
import DemoBlock from './DemoBlock.vue';
import { exampleSourceFor } from '../example-source';

const principles = [
  {
    number: '01',
    title: '一种材质语言',
    description: '表面厚度、边缘高光、阴影和遮罩全部由主题令牌控制，明暗模式自然一致。',
  },
  {
    number: '02',
    title: '真实触控反馈',
    description: '按下即响应，拖拽连续跟手，释放继承速度；减少动画时自动退化为稳定反馈。',
  },
  {
    number: '03',
    title: '完全通用',
    description: '组件只接受值、Widget 与回调，不绑定路由、业务模型或状态管理框架。',
  },
];

const componentCount = componentSidebarSections.reduce(
  (total, section) => total + section.components.length,
  0,
);

function sectionPreview(section: (typeof componentSidebarSections)[number]) {
  return section.components.slice(0, 4).map((item) => item.navName).join(' · ');
}

const quickCode = `import 'package:flutter/material.dart';
import 'package:flutter_hyper_ui/hy_ui.dart';

MaterialApp(
  theme: HyUiTheme.light(),
  darkTheme: HyUiTheme.dark(),
  home: const HySoftBackground(
    child: YourApp(),
  ),
);`;
</script>

<template>
  <main class="hy-home">
    <section class="hy-home__hero">
      <div class="hy-home__ambient hy-home__ambient--blue" />
      <div class="hy-home__ambient hy-home__ambient--violet" />
      <div class="hy-home__hero-copy">
        <div class="hy-home__eyebrow">
          <img :src="withBase('/hy-ui-logo.svg')" alt="" />
          <span>HY UI · FLUTTER</span>
        </div>
        <h1>让界面像玻璃一样<br /><span>轻盈，也清晰。</span></h1>
        <p>
          一套面向 Flutter 移动端的通用柔性玻璃 UI 库。统一材质、状态、动效和无障碍行为，
          让业务只关注内容与流程。
        </p>
        <div class="hy-home__actions">
          <a class="hy-button hy-button--primary" :href="withBase('/guide/getting-started')">开始使用</a>
          <a class="hy-button hy-button--glass" :href="withBase('/components/catalog')">浏览组件</a>
        </div>
        <ul class="hy-home__facts" aria-label="库特性">
          <li><strong>{{ componentCount }}</strong><span>组件文档</span></li>
          <li><strong>0</strong><span>运行时第三方依赖</span></li>
          <li><strong>A11y</strong><span>动效与对比度适配</span></li>
        </ul>
      </div>

      <div class="hy-home__hero-object" aria-hidden="true">
        <div class="hy-home__phone">
          <div class="hy-home__phone-top"><span /><span /></div>
          <div class="hy-home__welcome">下午好</div>
          <div class="hy-home__phone-title">保持从容，<br />专注重要的事。</div>
          <div class="hy-home__metric">
            <span>今日进度</span><strong>72%</strong>
            <div><i /></div>
          </div>
          <div class="hy-home__menu-row"><b>◈</b><span>外观与显示</span><i>›</i></div>
          <div class="hy-home__menu-row"><b>◇</b><span>通知</span><em /></div>
          <div class="hy-home__tabbar">
            <span class="is-active">⌂<small>首页</small></span>
            <span>⌁<small>发现</small></span>
            <span>○<small>我的</small></span>
          </div>
        </div>
      </div>
    </section>

    <section class="hy-home__section hy-home__principles">
      <div class="hy-home__section-heading">
        <span>DESIGN FOUNDATION</span>
        <h2>不是套一层模糊，<br />而是一套完整的界面行为。</h2>
      </div>
      <div class="hy-home__principle-grid">
        <article v-for="principle in principles" :key="principle.number">
          <small>{{ principle.number }}</small>
          <h3>{{ principle.title }}</h3>
          <p>{{ principle.description }}</p>
        </article>
      </div>
    </section>

    <section class="hy-home__section hy-home__live">
      <div class="hy-home__section-heading">
        <span>LIVE FLUTTER PREVIEW</span>
        <h2>文档里的每一个控件，<br />都是真实运行的 Widget。</h2>
        <p>拖动 TabBar、侧滑菜单、打开抽屉，直接体验组件的真实状态和交互。</p>
      </div>
      <DemoBlock
        :title="featuredDemo.title"
        :description="featuredDemo.description"
        :component="featuredDemo.id"
        :code="exampleSourceFor(featuredDemo.source)"
        :height="featuredDemo.height"
      />
    </section>

    <section class="hy-home__section hy-home__catalog">
      <div class="hy-home__section-heading">
        <span>COMPONENT SYSTEM</span>
        <h2>从原子控件到完整移动端界面。</h2>
      </div>
      <nav class="hy-home__catalog-grid" aria-label="组件分类">
        <a
          v-for="(section, index) in componentSidebarSections"
          :key="section.id"
          :href="withBase(`/components/catalog#${section.id}`)"
        >
          <small>{{ String(index + 1).padStart(2, '0') }}</small>
          <h3>{{ section.title }}</h3>
          <p>{{ sectionPreview(section) }}</p>
          <span>{{ section.components.length }} 个组件 <b>→</b></span>
        </a>
      </nav>
    </section>

    <section class="hy-home__section hy-home__start">
      <div>
        <span class="hy-home__kicker">START SMALL</span>
        <h2>两套主题，<br />一行接入。</h2>
        <p>Hy UI 不接管你的应用架构。使用主题作为入口，再按需组合组件。</p>
        <a :href="withBase('/guide/theming')">了解主题定制 →</a>
      </div>
      <pre><code>{{ quickCode }}</code></pre>
    </section>
  </main>
</template>
