<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { withBase } from 'vitepress';
import { getComponentEntry } from '../../catalog';
import { dartApiFor } from '../dart-api';
import { highlightDart } from '../highlight';
import { exampleSourceFor } from '../example-source';
import DemoBlock from './DemoBlock.vue';

const props = defineProps<{ componentId: string }>();
const resolved = computed(() => getComponentEntry(props.componentId));
const entry = computed(() => resolved.value.entry);
const group = computed(() => resolved.value.group);
// 组件页只接受目录显式绑定的专属预览，禁止回退到分类组合 Demo。
const demo = computed(() => entry.value.preview);

const apiCode = computed(() => dartApiFor(entry.value.name, entry.value.source));
const highlightedApi = ref('');
const apiExpanded = ref(false);

watch(apiCode, async (code) => {
  highlightedApi.value = await highlightDart(code);
}, { immediate: true });

interface ApiProp {
  name: string;
  required: boolean;
  defaultValue: string;
}

// 从构造函数签名中解析参数列表，生成属性表格
const propDescription = (name: string) => {
  return entry.value.propsDocs?.find((p) => p.name === name)?.description ?? '-';
};

const apiProps = computed<ApiProp[]>(() => {
  const code = apiCode.value;
  if (!code) return [];

  const props: ApiProp[] = [];
  // 匹配每个构造函数的参数块 { ... }
  const blocks = code.match(/\{([^}]+)\}/g) ?? [];

  for (const block of blocks) {
    const inner = block.slice(1, -1).trim();
    const lines = inner.split(',').map((l) => l.trim()).filter(Boolean);

    for (const line of lines) {
      // 跳过 super.key 这种
      if (line.startsWith('super.')) continue;

      let required = false;
      let name = '';
      let defaultValue = '-';

      let cleaned = line;
      if (cleaned.startsWith('required ')) {
        required = true;
        cleaned = cleaned.slice(9).trim();
      }

      // this.xxx = defaultValue 或 this.xxx
      const match = cleaned.match(/^this\.(\w+)(?:\s*=\s*(.+))?$/);
      if (match) {
        name = match[1];
        if (match[2]) defaultValue = match[2].trim();
      } else {
        // 命名参数直接写的形式，如 String url, double width
        const namedMatch = cleaned.match(/^(?:\w+\s+)?(\w+)(?:\s*=\s*(.+))?$/);
        if (namedMatch) {
          name = namedMatch[1];
          if (namedMatch[2]) defaultValue = namedMatch[2].trim();
          required = !cleaned.includes('=') && !cleaned.startsWith('this.');
        }
      }

      if (name) {
        if (!props.find((p) => p.name === name)) {
          props.push({ name, required, defaultValue });
        }
      }
    }
  }

  return props;
});
</script>

<template>
  <article class="component-doc">
    <header class="component-doc__header">
      <a class="component-doc__category" :href="withBase('/components/catalog')">
        组件 / {{ entry.groupTitle }}
      </a>
      <h1>{{ entry.navName }}</h1>
      <p>{{ entry.summary }}</p>
    </header>

    <section v-if="demo" class="component-doc__section" aria-labelledby="component-demo-title">
      <div class="component-doc__section-heading">
        <h2 id="component-demo-title">交互示例</h2>
        <p>直接运行真实 Flutter Widget；切换宽度、操作状态或展开源码检查用法。</p>
      </div>
      <DemoBlock
        :title="demo.title"
        :description="demo.description"
        :component="demo.id"
        :code="exampleSourceFor(demo.source, demo.symbol)"
        :height="demo.height"
      />
    </section>

    <section class="component-doc__section" aria-labelledby="component-api-title">
      <div class="component-doc__section-heading">
        <h2 id="component-api-title">公开 API</h2>
        <p>签名从组件库当前 Dart 源码提取，避免文档参数与实现脱节。</p>
      </div>
      <div class="component-doc__api">
        <div class="component-doc__api-header">
          <div class="component-doc__api-title">
            <code>{{ entry.name }}</code>
            <span>{{ entry.source }}</span>
          </div>
          <button type="button" class="component-doc__api-toggle" @click="apiExpanded = !apiExpanded">
            {{ apiExpanded ? '收起签名' : '展开签名' }}
          </button>
        </div>
        <div v-show="apiExpanded" class="component-doc__code-block" v-html="highlightedApi" />
      </div>

      <!-- 属性表格 -->
      <div v-if="apiProps.length" class="component-doc__props">
        <h3>Props</h3>
        <table class="component-doc__props-table">
          <thead>
            <tr>
              <th>属性名</th>
              <th>说明</th>
              <th>默认值</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="prop in apiProps" :key="prop.name">
              <td><span class="component-doc__prop-name">{{ prop.name }}</span><span v-if="prop.required" class="component-doc__required">必选</span></td>
              <td>{{ propDescription(prop.name) }}</td>
              <td>{{ prop.defaultValue }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <section v-if="group.conventions?.length" class="component-doc__section" aria-labelledby="component-rules-title">
      <div class="component-doc__section-heading">
        <h2 id="component-rules-title">使用约定</h2>
      </div>
      <ul class="component-doc__rules">
        <li v-for="convention in group.conventions" :key="convention">
          <span v-html="convention.replace(/`([^`]+)`/g, '<code>$1</code>')" />
        </li>
      </ul>
    </section>
  </article>
</template>
