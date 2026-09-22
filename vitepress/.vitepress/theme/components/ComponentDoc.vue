<script setup lang="ts">
import { computed } from 'vue';
import { withBase } from 'vitepress';
import { getComponentEntry } from '../../catalog';
import { dartApiFor } from '../dart-api';
import { exampleSourceFor } from '../example-source';
import DemoBlock from './DemoBlock.vue';

const props = defineProps<{ componentId: string }>();
const resolved = computed(() => getComponentEntry(props.componentId));
const entry = computed(() => resolved.value.entry);
const group = computed(() => resolved.value.group);
const demo = computed(() => (
  group.value.demos.find((item) => item.id === entry.value.demoId) ?? group.value.demos[0]
));
const relatedComponents = computed(() => (
  group.value.components.filter((item) => item.id !== entry.value.id).slice(0, 8)
));

function sourceUrl(source: string) {
  const normalized = source.startsWith('../') ? source.slice(3) : `components/${source}`;
  return `https://github.com/auroracode553/flutter-hyper-ui/blob/main/ui/lib/src/${normalized}`;
}
</script>

<template>
  <article class="component-doc">
    <header class="component-doc__header">
      <a class="component-doc__category" :href="withBase('/components/catalog')">
        组件 / {{ entry.groupTitle }}
      </a>
      <h1>{{ entry.navName }}</h1>
      <p>{{ entry.summary }}</p>
      <div class="component-doc__meta">
        <span>Flutter Widget</span>
        <a :href="sourceUrl(entry.source)" target="_blank" rel="noreferrer">查看源码 ↗</a>
      </div>
    </header>

    <section v-if="demo" class="component-doc__section" aria-labelledby="component-demo-title">
      <div class="component-doc__section-heading">
        <span class="hy-kicker">LIVE EXAMPLE</span>
        <h2 id="component-demo-title">交互示例</h2>
        <p>直接运行真实 Flutter Widget；切换宽度、操作状态或展开源码检查用法。</p>
      </div>
      <DemoBlock
        :title="demo.title"
        :description="demo.description"
        :component="demo.id"
        :code="exampleSourceFor(demo.source)"
        :height="demo.height"
      />
    </section>

    <section class="component-doc__section" aria-labelledby="component-api-title">
      <div class="component-doc__section-heading">
        <span class="hy-kicker">PUBLIC API</span>
        <h2 id="component-api-title">公开 API</h2>
        <p>签名从组件库当前 Dart 源码提取，避免文档参数与实现脱节。</p>
      </div>
      <div class="component-doc__api">
        <div class="component-doc__api-title">
          <code>{{ entry.name }}</code>
          <span>{{ entry.source }}</span>
        </div>
        <pre><code>{{ dartApiFor(entry.name, entry.source) }}</code></pre>
      </div>
    </section>

    <section v-if="group.conventions?.length" class="component-doc__section" aria-labelledby="component-rules-title">
      <div class="component-doc__section-heading">
        <span class="hy-kicker">GUIDANCE</span>
        <h2 id="component-rules-title">使用约定</h2>
      </div>
      <ul class="component-doc__rules">
        <li v-for="convention in group.conventions" :key="convention">
          <span v-html="convention.replace(/`([^`]+)`/g, '<code>$1</code>')" />
        </li>
      </ul>
    </section>

    <nav v-if="relatedComponents.length" class="component-doc__related" aria-label="同类组件">
      <div>
        <span class="hy-kicker">RELATED</span>
        <h2>同类组件</h2>
      </div>
      <a v-for="item in relatedComponents" :key="item.id" :href="withBase(item.page)">
        <span>{{ item.navName }}</span>
        <b>→</b>
      </a>
    </nav>
  </article>
</template>
