<script setup lang="ts">
import { computed } from 'vue';
import { withBase } from 'vitepress';
import { getComponentGroup } from '../../catalog';

const props = defineProps<{ groupId: string }>();
const group = computed(() => getComponentGroup(props.groupId));
const previewCount = computed(() => (
  group.value.components.filter((item) => item.preview !== undefined).length
));

</script>

<template>
  <article class="component-reference">
    <header class="component-reference__header">
      <span class="hy-kicker">HY UI COMPONENTS</span>
      <h1>{{ group.title }}</h1>
      <p class="component-reference__lead">{{ group.description }}</p>
      <div class="component-reference__meta">
        <span>{{ group.components.length }} 组公开 API</span>
        <span>{{ previewCount }} 个专属预览</span>
      </div>
    </header>

    <div class="component-reference__section-heading">
      <span class="hy-kicker">COMPONENT DIRECTORY</span>
      <h2>选择组件</h2>
      <p>每个组件进入独立文档、独立预览与独立源码片段；分类页不再承载组合 Demo。</p>
    </div>
    <nav class="component-reference__grid" aria-label="分类组件">
      <a
        v-for="item in group.components"
        :key="item.id"
        class="component-reference__item"
        :href="withBase(item.page)"
      >
        <h3><code>{{ item.navName }}</code></h3>
        <p>{{ item.summary }}</p>
        <span>查看组件 →</span>
      </a>
    </nav>

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
