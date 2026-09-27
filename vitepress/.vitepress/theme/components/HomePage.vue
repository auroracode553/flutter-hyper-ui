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
          Hyper UI 是一套流行的 Flutter 柔性玻璃组件库。全部组件自绘实现，不依赖
          Material 视觉体系；统一材质令牌与边缘高光，桌面端与移动端自适应，明暗双主题开箱即得。
        </p>
        <ul class="hyper-home__chips">
          <li>柔性玻璃材质</li>
          <li>桌面端 · 移动端自适应</li>
          <li>明暗双主题</li>
          <li>动效与对比度自适应</li>
        </ul>
        <div class="hyper-home__actions">
          <a class="hyper-button hyper-button--primary" :href="withBase('/guide/getting-started')">开始使用</a>
          <a class="hyper-button hyper-button--glass" :href="withBase('/components/catalog')">浏览组件</a>
        </div>
        <ul class="hyper-home__facts" aria-label="库特性">
          <li><strong>{{ componentCount }}</strong><span>组件文档</span></li>
          <li><strong>1</strong><span>第三方依赖（仅图标）</span></li>
          <li><strong>自适应</strong><span>动效与对比度适配</span></li>
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
          <span>玻璃拟态组件全部自绘，材质令牌集中定义：颜色、透明度、模糊与描边一处调整，全库同步生效。</span>
        </li>
        <li>
          <strong>桌面端 · 移动端自适应</strong>
          <span>组件随窗口尺寸自动重排，一套代码同时覆盖桌面与移动端。</span>
        </li>
        <li>
          <strong>明暗双主题</strong>
          <span>开箱即得明暗两套主题，令牌统一，可按需覆盖定制。</span>
        </li>
        <li>
          <strong>自然连贯的动效</strong>
          <span>按压反馈、开关与弹层动画由组件内置，并遵循系统减弱动效偏好。</span>
        </li>
        <li>
          <strong>依赖最小化</strong>
          <span>唯一第三方依赖是 lucide 图标库，组件逻辑与样式全部自绘，包体积可控。</span>
        </li>
        <li>
          <strong>对比度与动效自适应</strong>
          <span>自动适配系统高对比度与减弱动效偏好，保持可读与舒适。</span>
        </li>
      </ul>
    </section>
  </main>
</template>
