<script setup lang="ts">
import { computed, ref } from 'vue';

const props = withDefaults(
  defineProps<{
    title: string;
    component: string;
    code: string;
    description?: string;
    height?: number;
  }>(),
  {
    description: '',
    height: 320,
  },
);

const copied = ref(false);
const previewBase = (import.meta.env.VITE_PREVIEW_BASE || 'http://localhost:4201').replace(/\/$/, '');
const iframeSrc = computed(() => {
  const component = encodeURIComponent(props.component);
  return `${previewBase}/?component=${component}&mode=docs`;
});

async function copyCode() {
  await navigator.clipboard.writeText(props.code);
  copied.value = true;
  window.setTimeout(() => {
    copied.value = false;
  }, 1200);
}
</script>

<template>
  <section class="demo-block">
    <header class="demo-block__header">
      <div>
        <h3>{{ title }}</h3>
        <p v-if="description">{{ description }}</p>
      </div>
    </header>

    <div class="demo-block__preview">
      <iframe
        :src="iframeSrc"
        :title="`${title} preview`"
        :style="{ height: `${height}px` }"
        loading="lazy"
      />
    </div>

    <div class="demo-block__code">
      <div class="demo-block__code-header">
        <span>使用代码</span>
        <button type="button" @click="copyCode">
          {{ copied ? '已复制' : '复制' }}
        </button>
      </div>
      <pre><code>{{ code }}</code></pre>
    </div>
  </section>
</template>
