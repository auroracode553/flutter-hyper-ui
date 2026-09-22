<script setup lang="ts">
import { componentGroups, featuredDemo } from '../../catalog';
import { withBase } from 'vitepress';
import DemoBlock from './DemoBlock.vue';
import { exampleSourceFor } from '../example-source';

const componentCount = componentGroups.reduce(
  (total, group) => total + group.components.length,
  0,
);
</script>

<template>
  <article class="catalog-overview">
    <header class="catalog-overview__header">
      <span class="hy-kicker">COMPONENT CATALOG</span>
      <h1>组件总览</h1>
      <p>
        {{ componentGroups.length }} 个分类、{{ componentCount }} 组公开 API，共享同一套主题、材质、状态和交互规则。
        组件均不绑定业务模型或状态管理方案。
      </p>
    </header>

    <nav class="catalog-overview__grid" aria-label="组件分类">
      <a v-for="(group, index) in componentGroups" :key="group.id" :href="withBase(group.page)">
        <small>{{ String(index + 1).padStart(2, '0') }}</small>
        <strong>{{ group.title }}</strong>
        <span>{{ group.description }}</span>
        <em>{{ group.components.length }} 组 API <b>→</b></em>
      </a>
    </nav>

    <section class="catalog-overview__preview">
      <div class="catalog-overview__section-heading">
        <span class="hy-kicker">LIVE PREVIEW</span>
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
