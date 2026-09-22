import { PreviewBundleLoader } from './preview/bundle-loader';
import type { PreviewListener } from './preview/contracts';
import { PreviewView, selectedTheme } from './preview/preview-view';

export type { PreviewStatus } from './preview/contracts';

const developmentServer = import.meta.env.VITE_HY_UI_PREVIEW_MODE === 'dev-server';
// 开发模式走 Vite 同源代理，发布模式读取同站点静态包。
const loader = new PreviewBundleLoader(
  `${import.meta.env.BASE_URL}preview/`,
  { developmentServer },
);
const views = new Set<PreviewView>();
let themeObserver: MutationObserver | undefined;
let prewarmScheduled = false;
let idleHandle: number | undefined;
let fallbackHandle: number | undefined;

type ConnectionAwareNavigator = Navigator & {
  connection?: { saveData?: boolean; effectiveType?: string };
};

function shouldPrewarm() {
  const connection = (navigator as ConnectionAwareNavigator).connection;
  return !connection?.saveData && !['slow-2g', '2g'].includes(connection?.effectiveType ?? '');
}

function cancelScheduledPrewarm() {
  if (idleHandle !== undefined && typeof window.cancelIdleCallback === 'function') {
    window.cancelIdleCallback(idleHandle);
  }
  if (fallbackHandle !== undefined) window.clearTimeout(fallbackHandle);
  idleHandle = undefined;
  fallbackHandle = undefined;
  prewarmScheduled = false;
}

function runPrewarm() {
  idleHandle = undefined;
  fallbackHandle = undefined;
  prewarmScheduled = false;
  if (!views.size || document.visibilityState !== 'visible') return;
  // 预热失败会在 View 真正挂载时显示可操作的错误，不在后台打扰读者。
  void loader.prewarm().catch(() => undefined);
}

function schedulePrewarm() {
  if (prewarmScheduled || !shouldPrewarm()) return;
  prewarmScheduled = true;
  if (typeof window.requestIdleCallback === 'function') {
    idleHandle = window.requestIdleCallback(runPrewarm, { timeout: 1_500 });
  } else {
    fallbackHandle = window.setTimeout(runPrewarm, 700);
  }
}

function observeTheme() {
  if (themeObserver) return;
  let theme = selectedTheme();
  themeObserver = new MutationObserver(() => {
    const next = selectedTheme();
    if (next === theme) return;
    theme = next;
    for (const view of views) view.refreshTheme();
  });
  themeObserver.observe(document.documentElement, {
    attributes: true, attributeFilter: ['class'],
  });
}

export function registerPreview(target: HTMLElement, componentId: string, onStatus: PreviewListener) {
  const view = new PreviewView(target, componentId, loader, onStatus);
  const observer = new IntersectionObserver(([entry]) => {
    if (!entry.isIntersecting) return;
    observer.disconnect();
    void view.mount();
  }, { rootMargin: '520px 0px' });
  views.add(view);
  observeTheme();
  schedulePrewarm();
  observer.observe(target);
  return {
    activate: () => { observer.disconnect(); void view.mount(); },
    reset: () => { observer.disconnect(); view.reset(); },
    dispose: () => {
      observer.disconnect();
      views.delete(view);
      view.dispose();
      if (!views.size) {
        cancelScheduledPrewarm();
        themeObserver?.disconnect();
        themeObserver = undefined;
      }
    },
  };
}

if (import.meta.hot) {
  import.meta.hot.dispose(() => {
    for (const view of views) view.dispose();
    views.clear();
    cancelScheduledPrewarm();
    themeObserver?.disconnect();
  });
}
