<script setup lang="ts">
import { computed } from 'vue';
import { getComponentGroup } from '../../catalog';
import DemoBlock from './DemoBlock.vue';
import { dartApiFor } from '../dart-api';

const props = defineProps<{ groupId: string }>();
const group = computed(() => getComponentGroup(props.groupId));

function sourceUrl(source: string) {
  const normalized = source.startsWith('../') ? source : `../components/${source}`;
  return `https://github.com/auroracode553/flutter-hyper-ui/blob/main/ui/lib/src/${normalized.replace('../', '')}`;
}
</script>

<template>
  <article class="component-reference">
    <h1>{{ group.title }}</h1>
    <p class="component-reference__lead">{{ group.description }}</p>

    <DemoBlock
      :title="group.previewTitle"
      :component="group.previewId"
      :code="group.example"
      :height="group.previewHeight"
    />

    <h2>公开组件</h2>
    <div class="component-reference__grid">
      <section v-for="item in group.components" :key="item.name" class="component-reference__item">
        <h3><code>{{ item.name }}</code></h3>
        <p>{{ item.summary }}</p>
        <details>
          <summary>当前公开签名</summary>
          <pre><code>{{ dartApiFor(item.name, item.source) }}</code></pre>
        </details>
        <a :href="sourceUrl(item.source)" target="_blank" rel="noreferrer">查看 Dart API 源码</a>
      </section>
    </div>

    <template v-if="group.conventions?.length">
      <h2>使用约定</h2>
      <ul>
        <li v-for="convention in group.conventions" :key="convention">
          <span v-html="convention.replace(/`([^`]+)`/g, '<code>$1</code>')" />
        </li>
      </ul>
    </template>
  </article>
</template>
