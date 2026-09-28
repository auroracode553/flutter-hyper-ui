<script setup lang="ts">
import { computed } from 'vue';
import { getComponentEntry } from '../../catalog';
import { exampleSourceFor } from '../example-source';
import DemoBlock from './DemoBlock.vue';

const props = defineProps<{ componentId: string }>();
const resolved = computed(() => getComponentEntry(props.componentId));
const entry = computed(() => resolved.value.entry);
// 组件页只接受目录显式绑定的专属预览，禁止回退到分类组合 Demo。
const demo = computed(() => entry.value.preview);
</script>

<template>
  <article class="component-doc">
    <header class="component-doc__header">
      <h1>{{ entry.navName }}</h1>
      <p>{{ entry.summary }}</p>
    </header>

    <section v-if="demo" class="component-doc__section" aria-labelledby="component-demo-title">
      <div class="component-doc__section-heading">
        <h2 id="component-demo-title">交互示例</h2>
      </div>
      <DemoBlock
        :title="demo.title"
        :component="demo.id"
        :code="exampleSourceFor(demo.source, demo.symbol)"
        :height="demo.height"
        :full-screen="demo.fullScreen"
      />
    </section>
  </article>
</template>
