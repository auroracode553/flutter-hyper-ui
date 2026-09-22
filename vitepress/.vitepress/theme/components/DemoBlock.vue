<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue';
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

type PreviewWidth = 'fluid' | 'mobile';

const copied = ref(false);
const codeExpanded = ref(false);
const previewWidth = ref<PreviewWidth>('fluid');
const previewFrame = ref<HTMLElement>();
const previewTarget = ref<HTMLElement>();
const previewStatus = ref<PreviewStatus>({ phase: 'idle', message: '演示尚未加载' });
const frameStyle = computed(() => ({
  height: `${props.height}px`,
  width: previewWidth.value === 'mobile' ? '390px' : '100%',
}));
let disposePreview: (() => void) | undefined;
let activatePreview: (() => void) | undefined;
let resetPreviewView: (() => void) | undefined;

onMounted(() => {
  if (!previewTarget.value) return;
  const registration = registerPreview(
    previewTarget.value,
    props.component,
    (status) => { previewStatus.value = status; },
  );
  disposePreview = registration.dispose;
  activatePreview = registration.activate;
  resetPreviewView = registration.reset;
});

onBeforeUnmount(() => disposePreview?.());

function retryPreview() {
  if (previewStatus.value.reloadRequired) window.location.reload();
  else activatePreview?.();
}

function resetPreview() {
  previewStatus.value = { phase: 'view', message: '正在重置演示…' };
  resetPreviewView?.();
}

async function openFullscreen() {
  await previewFrame.value?.requestFullscreen();
}

async function copyCode() {
  await navigator.clipboard.writeText(props.code);
  copied.value = true;
  window.setTimeout(() => { copied.value = false; }, 1200);
}
</script>

<template>
  <section class="demo-block">
    <header class="demo-block__header">
      <div>
        <h3>{{ title }}</h3>
        <p v-if="description">{{ description }}</p>
      </div>
      <div class="demo-block__toolbar" aria-label="预览工具">
        <div class="demo-block__width-switch" aria-label="预览宽度">
          <button type="button" :class="{ 'is-active': previewWidth === 'fluid' }" :aria-pressed="previewWidth === 'fluid'" @click="previewWidth = 'fluid'">自适应</button>
          <button type="button" :class="{ 'is-active': previewWidth === 'mobile' }" :aria-pressed="previewWidth === 'mobile'" @click="previewWidth = 'mobile'">手机</button>
        </div>
        <button type="button" title="重置演示状态" :disabled="previewStatus.phase !== 'ready'" @click="resetPreview">重置</button>
        <button type="button" title="全屏预览" @click="openFullscreen">全屏</button>
      </div>
    </header>

    <div class="demo-block__stage">
      <div ref="previewFrame" class="demo-block__preview" :style="frameStyle">
        <div ref="previewTarget" class="demo-block__flutter-host" />
        <div v-if="previewStatus.phase !== 'ready'" class="demo-block__placeholder" aria-live="polite">
          <span v-if="['assets', 'engine', 'view'].includes(previewStatus.phase)" class="demo-block__spinner" aria-hidden="true" />
          <span :role="previewStatus.phase === 'error' ? 'alert' : 'status'">{{ previewStatus.message }}</span>
          <button v-if="previewStatus.phase === 'idle' || previewStatus.phase === 'error'" type="button" @click="retryPreview">
            {{ previewStatus.reloadRequired ? '刷新页面' : previewStatus.phase === 'error' ? '重试加载' : '显示此演示' }}
          </button>
        </div>
      </div>
    </div>

    <div class="demo-block__code">
      <div class="demo-block__code-header">
        <button type="button" :aria-expanded="codeExpanded" @click="codeExpanded = !codeExpanded">
          {{ codeExpanded ? '收起源码' : '查看源码' }}
        </button>
        <button type="button" @click="copyCode">{{ copied ? '已复制' : '复制代码' }}</button>
      </div>
      <pre v-if="codeExpanded"><code>{{ code }}</code></pre>
    </div>
  </section>
</template>
