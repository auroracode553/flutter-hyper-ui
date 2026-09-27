<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue';
import { withBase } from 'vitepress';
import { componentGroups } from '../../catalog';
import DeviceFrame from './DeviceFrame.vue';
import { registerPreview } from '../preview-runtime';

/** 组件总数：只统计侧栏可见组件，与导航目录保持一致。 */
const componentCount = componentGroups.reduce(
  (total, group) => total + group.components.filter((entry) => entry.sidebar !== false).length,
  0,
);

const phoneTarget = ref<HTMLElement>();
let disposePhone: (() => void) | undefined;
onMounted(() => {
  if (!phoneTarget.value) return;
  const registration = registerPreview(phoneTarget.value, 'home-hero', () => {});
  disposePhone = registration.dispose;
});
onBeforeUnmount(() => disposePhone?.());
</script>

<template>
  <main class="hyper-home">
    <!-- 简介区 -->
    <section class="hyper-home__intro">
      <div class="hyper-home__intro-copy">
        <h1>为 Flutter 而生的<span>柔性玻璃 UI 库</span></h1>
        <p class="hyper-home__lede">
          一套流行的 Flutter 柔性玻璃组件库，用统一的材质令牌、细腻的边缘高光与自然连贯的动效，让界面自带通透质感。
        </p>
        <ul class="hyper-home__chips">
          <li>柔性玻璃材质</li>
          <li>桌面端 · 移动端自适应</li>
          <li>明暗双主题</li>
          <li>零运行时依赖</li>
        </ul>
        <div class="hyper-home__actions">
          <a class="hyper-button hyper-button--primary" :href="withBase('/guide/getting-started')">开始使用</a>
          <a class="hyper-button hyper-button--glass" :href="withBase('/components/catalog')">浏览组件</a>
        </div>
        <ul class="hyper-home__facts" aria-label="库特性">
          <li><strong>{{ componentCount }}</strong><span>组件文档</span></li>
          <li><strong>0</strong><span>运行时第三方依赖</span></li>
          <li><strong>无障碍</strong><span>动效与对比度适配</span></li>
        </ul>
      </div>

      <div class="hyper-home__intro-object">
        <DeviceFrame class="hyper-home__phone" mode="mobile">
          <div ref="phoneTarget" class="demo-block__flutter-host" />
        </DeviceFrame>
      </div>
    </section>

    <!-- 特性区：特性优点描述 -->
    <section class="hyper-home__section hyper-home__features">
      <h2>特性</h2>
      <ul class="hyper-home__features-list">
        <li>
          <strong>柔性玻璃材质</strong>
          <span>统一的材质令牌与细腻的边缘高光，让界面自带通透质感。</span>
        </li>
        <li>
          <strong>桌面端 · 移动端自适应</strong>
          <span>组件随窗口尺寸自动调整布局，一套代码覆盖手机与桌面。</span>
        </li>
        <li>
          <strong>明暗双主题</strong>
          <span>开箱即得两套主题，令牌统一，可按需定制。</span>
        </li>
        <li>
          <strong>自然连贯的动效</strong>
          <span>面向触摸反馈与页面切换的轻量动效，并遵循系统减弱动效偏好。</span>
        </li>
        <li>
          <strong>零运行时依赖</strong>
          <span>不引入任何第三方运行时库，接入即用，包体积可控。</span>
        </li>
        <li>
          <strong>无障碍适配</strong>
          <span>对比度与动效自动适配系统的无障碍偏好。</span>
        </li>
      </ul>
    </section>
  </main>
</template>
