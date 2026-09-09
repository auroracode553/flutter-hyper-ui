<script setup lang="ts">
import { componentGroups } from '../../catalog';
import { withBase } from 'vitepress';
import DemoBlock from './DemoBlock.vue';
</script>

<template>
  <article class="catalog-overview">
    <h1>组件总览</h1>
    <p class="component-reference__lead">
      文档侧栏、分类页与实时演示共用同一份组件目录。每项都链接到实际 Dart 源码，避免文档和实现各自演进。
    </p>

    <nav class="catalog-overview__grid" aria-label="组件分类">
      <a v-for="group in componentGroups" :key="group.id" :href="withBase(group.page)">
        <strong>{{ group.title }}</strong>
        <span>{{ group.description }}</span>
        <small>{{ group.components.length }} 组公开 API</small>
      </a>
    </nav>

    <h2>实时演示</h2>
    <p>
      页面只启动一个 Flutter Web 引擎。进入视口的演示会创建独立 FlutterView，并直接挂载到对应 DOM 容器。
    </p>
    <DemoBlock
      v-for="group in componentGroups"
      :key="group.id"
      :title="group.previewTitle"
      :description="group.description"
      :component="group.previewId"
      :code="group.example"
      :height="group.previewHeight"
    />
  </article>
</template>
