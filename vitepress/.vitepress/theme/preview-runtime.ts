import { PreviewBundleLoader } from './preview/bundle-loader';
import type { PreviewListener } from './preview/contracts';
import { PreviewView, selectedTheme } from './preview/preview-view';

export type { PreviewStatus } from './preview/contracts';

// 共享引擎；开发和发布都使用同一份静态预览资源。
const loader = new PreviewBundleLoader(`${import.meta.env.BASE_URL}preview/`);
const views = new Set<PreviewView>();
let themeObserver: MutationObserver | undefined;

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
  }, { rootMargin: '300px 0px' });
  views.add(view);
  observeTheme();
  observer.observe(target);
  return {
    activate: () => { observer.disconnect(); void view.mount(); },
    dispose: () => {
      observer.disconnect();
      views.delete(view);
      view.dispose();
      if (!views.size) { themeObserver?.disconnect(); themeObserver = undefined; }
    },
  };
}

if (import.meta.hot) {
  import.meta.hot.dispose(() => {
    for (const view of views) view.dispose();
    views.clear();
    themeObserver?.disconnect();
  });
}
