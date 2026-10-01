<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { getComponentEntry } from '../../catalog';
import { dartApiFor } from '../dart-api';
import { exampleSourceFor } from '../example-source';
import { highlightDart } from '../highlight';
import { componentPropsFor } from '../component-props';
import DemoBlock from './DemoBlock.vue';

const props = defineProps<{ componentId: string }>();
const resolved = computed(() => getComponentEntry(props.componentId));
const entry = computed(() => resolved.value.entry);
// 组件页只接受目录显式绑定的专属预览，禁止回退到分类组合 Demo。
const demo = computed(() => entry.value.preview);
const apiCode = computed(() => dartApiFor(entry.value.name, entry.value.source));
const apiProps = computed(() => componentPropsFor(apiCode.value, entry.value.propsDocs ?? []));
const apiExpanded = ref(false);
const highlightedApi = ref('');

watch([apiCode, apiExpanded], async ([code, expanded]) => {
  if (expanded) highlightedApi.value = await highlightDart(code);
});
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

    <section class="component-doc__section" aria-labelledby="component-api-title">
      <div class="component-doc__section-heading">
        <h2 id="component-api-title">公开 API</h2>
      </div>
      <div class="component-doc__api">
        <div class="component-doc__api-header">
          <div class="component-doc__api-title">
            <span>{{ entry.name }}</span>
            <span>{{ entry.source }}</span>
          </div>
          <button type="button" class="component-doc__api-toggle" @click="apiExpanded = !apiExpanded">
            {{ apiExpanded ? '收起签名' : '展开签名' }}
          </button>
        </div>
        <div v-show="apiExpanded" class="component-doc__code-block" v-html="highlightedApi" />
      </div>

      <div class="component-doc__props">
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
              <td>{{ prop.description }}</td>
              <td>{{ prop.defaultValue }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </article>
</template>
