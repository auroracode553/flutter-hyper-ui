<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue';
import { registerPreview, type PreviewState } from '../preview-runtime';

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
const previewTarget = ref<HTMLElement>();
const previewState = ref<PreviewState>('idle');
let disposePreview: (() => void) | undefined;
let activatePreview: (() => void) | undefined;

onMounted(() => {
  if (!previewTarget.value) return;
  const registration = registerPreview(
    previewTarget.value,
    props.component,
    (state) => (previewState.value = state),
  );
  disposePreview = registration.dispose;
  activatePreview = registration.activate;
});

onBeforeUnmount(() => disposePreview?.());

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

    <div
      class="demo-block__preview"
      :style="{ height: `${height}px` }"
      @click="activatePreview?.()"
    >
      <div ref="previewTarget" class="demo-block__flutter-host" />
      <div v-if="previewState !== 'ready'" class="demo-block__placeholder">
        <span v-if="previewState === 'loading'" class="demo-block__spinner" aria-hidden="true" />
        <span v-if="previewState === 'error'">预览服务未响应，请确认 Flutter Web 已在 4201 端口启动。</span>
        <span v-else-if="previewState === 'idle'">点击或滚动到这里，复用已启动的 Flutter 预览。</span>
        <span v-else>Flutter 引擎首次加载中，后续演示将直接复用…</span>
        <button v-if="previewState === 'idle'" type="button" @click.stop="activatePreview?.()">
          显示此演示
        </button>
      </div>
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
