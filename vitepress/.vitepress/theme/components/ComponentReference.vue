<script setup lang="ts">
import { computed } from 'vue';
import { getComponentGroup } from '../../catalog';
import DemoBlock from './DemoBlock.vue';
import { dartApiFor } from '../dart-api';
import { exampleSourceFor } from '../example-source';

const props = defineProps<{ groupId: string }>();
const group = computed(() => getComponentGroup(props.groupId));

function sourceUrl(source: string) {
  const normalized = source.startsWith('../') ? source : `../components/${source}`;
  return `https://github.com/auroracode553/flutter-hyper-ui/blob/main/ui/lib/src/${normalized.replace('../', '')}`;
}
</script>

<template>
  <article class="component-reference">
    <header class="component-reference__header">
      <span class="hy-kicker">HY UI COMPONENTS</span>
      <h1>{{ group.title }}</h1>
      <p class="component-reference__lead">{{ group.description }}</p>
      <div class="component-reference__meta">
        <span>{{ group.components.length }} 组公开 API</span>
        <span>{{ group.demos.length }} 个交互示例</span>
      </div>
    </header>

    <section class="component-reference__demos" aria-label="交互演示">
      <div class="component-reference__section-heading">
        <span class="hy-kicker">INTERACTIVE EXAMPLES</span>
        <h2>交互示例</h2>
        <p>演示直接运行 PreviewCatalog 中登记的 Flutter Widget，源码与实际预览保持同源。</p>
      </div>
      <DemoBlock
        v-for="demo in group.demos"
        :key="demo.id"
        :title="demo.title"
        :description="demo.description"
        :component="demo.id"
        :code="exampleSourceFor(demo.source)"
        :height="demo.height"
      />
    </section>

    <div class="component-reference__section-heading">
      <span class="hy-kicker">PUBLIC API</span>
      <h2>公开组件</h2>
      <p>展开签名可快速查看构造参数；源码链接指向组件的实际实现文件。</p>
    </div>
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
