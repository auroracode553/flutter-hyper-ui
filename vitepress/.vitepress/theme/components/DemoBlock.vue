<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue';
import { registerPreview, type PreviewStatus } from '../preview-runtime';

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
const previewStatus = ref<PreviewStatus>({ phase: 'idle', message: '演示尚未加载' });
let disposePreview: (() => void) | undefined;
let activatePreview: (() => void) | undefined;

onMounted(() => {
  if (!previewTarget.value) return;
  const registration = registerPreview(
    previewTarget.value,
    props.component,
    (status) => { previewStatus.value = status; },
  );
  disposePreview = registration.dispose;
  activatePreview = registration.activate;
});

onBeforeUnmount(() => disposePreview?.());

function retryPreview() {
  if (previewStatus.value.reloadRequired) window.location.reload();
  else activatePreview?.();
}

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
    >
      <div ref="previewTarget" class="demo-block__flutter-host" />
      <div v-if="previewStatus.phase !== 'ready'" class="demo-block__placeholder" aria-live="polite">
        <span v-if="['assets', 'engine', 'view'].includes(previewStatus.phase)" class="demo-block__spinner" aria-hidden="true" />
        <span :role="previewStatus.phase === 'error' ? 'alert' : 'status'">{{ previewStatus.message }}</span>
        <button v-if="previewStatus.phase === 'idle' || previewStatus.phase === 'error'" type="button" @click="retryPreview">
          {{ previewStatus.reloadRequired ? '刷新页面' : previewStatus.phase === 'error' ? '重试加载' : '显示此演示' }}
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
