<script setup lang="ts">
import { componentSidebarSections, featuredDemo } from '../../catalog';
import { withBase } from 'vitepress';
import DemoBlock from './DemoBlock.vue';
import { exampleSourceFor } from '../example-source';

const componentCount = componentSidebarSections.reduce(
  (total, section) => total + section.components.length,
  0,
);
</script>

<template>
  <article class="catalog-overview">
    <header class="catalog-overview__header">
      <h1>组件总览</h1>
      <p>
        {{ componentSidebarSections.length }} 个分类、{{ componentCount }} 组公开 API，共享同一套主题、材质、状态和交互规则。
        组件均不绑定业务模型或状态管理方案。
      </p>
    </header>

    <nav class="catalog-overview__sections" aria-label="全部组件">
      <section
        v-for="section in componentSidebarSections"
        :id="section.id"
        :key="section.id"
        class="catalog-overview__section"
      >
        <header>
          <h2>{{ section.title }}</h2>
          <span>{{ section.components.length }}</span>
        </header>
        <div class="catalog-overview__component-grid">
          <a v-for="item in section.components" :key="item.id" :href="withBase(item.page)">
            <strong>{{ item.navName }}</strong>
            <span>{{ item.summary }}</span>
            <b>→</b>
          </a>
        </div>
      </section>
    </nav>

    <section class="catalog-overview__preview">
      <div class="catalog-overview__section-heading">
        <h2>先体验，再选择。</h2>
        <p>下面运行的是真实 Flutter Widget。可以切换手机宽度、操作控件并查看完整示例源码。</p>
      </div>
      <DemoBlock
        :title="featuredDemo.title"
        :description="featuredDemo.description"
        :component="featuredDemo.id"
        :code="exampleSourceFor(featuredDemo.source)"
        :height="featuredDemo.height"
      />
    </section>

    <section class="catalog-overview__rules">
      <div>
        <strong>受控状态</strong>
        <span>值由应用持有，组件只负责展示与交互。</span>
      </div>
      <div>
        <strong>组合优先</strong>
        <span>通过 Widget 与回调组合，不引入业务继承体系。</span>
      </div>
      <div>
        <strong>系统适配</strong>
        <span>统一处理明暗、RTL、文本缩放与减少动画。</span>
      </div>
    </section>
  </article>
</template>
