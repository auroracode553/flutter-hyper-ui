export type PreviewState = 'idle' | 'loading' | 'ready' | 'error';

interface FlutterPreviewApp {
  addView(options: {
    hostElement: HTMLElement;
    initialData: PreviewViewData;
  }): number;
  removeView(viewId: number): unknown;
}

interface PreviewViewData {
  componentId: string;
  embedded: boolean;
  theme: 'light' | 'dark';
}

interface PreviewRegistration {
  componentId: string;
  target: HTMLElement;
  setState: (state: PreviewState) => void;
  observer: IntersectionObserver;
  viewId?: number;
  disposed: boolean;
}

declare global {
  interface Window {
    loadHyUiPreview?: (assetBase: string) => Promise<FlutterPreviewApp>;
  }
}

const defaultPreviewBase = import.meta.env.DEV
  ? 'http://localhost:4201'
  : `${import.meta.env.BASE_URL}preview`;
const previewBase = (import.meta.env.VITE_PREVIEW_BASE || defaultPreviewBase).replace(/\/$/, '');
const registrations = new Set<PreviewRegistration>();

let runtimePromise: Promise<FlutterPreviewApp> | undefined;
let themeObserver: MutationObserver | undefined;
let observedTheme: PreviewViewData['theme'] | undefined;

function selectedTheme(): PreviewViewData['theme'] {
  return document.documentElement.classList.contains('dark') ? 'dark' : 'light';
}

function loadBootstrapScript() {
  return new Promise<void>((resolve, reject) => {
    const existing = document.querySelector<HTMLScriptElement>('script[data-hy-ui-flutter]');
    if (existing) {
      if (window.loadHyUiPreview) resolve();
      else existing.addEventListener('load', () => resolve(), { once: true });
      return;
    }

    const script = document.createElement('script');
    script.src = `${previewBase}/flutter_bootstrap.js`;
    script.dataset.hyUiFlutter = 'true';
    script.addEventListener('load', () => resolve(), { once: true });
    script.addEventListener('error', () => reject(new Error('Flutter bootstrap 加载失败')), { once: true });
    document.head.appendChild(script);
  });
}

function ensureRuntime() {
  runtimePromise ??= loadBootstrapScript().then(() => {
    if (!window.loadHyUiPreview) throw new Error('Flutter multi-view loader 未注册');
    return window.loadHyUiPreview(`${previewBase}/`);
  });
  return runtimePromise;
}

function addView(registration: PreviewRegistration, app: FlutterPreviewApp) {
  if (registration.disposed || registration.viewId !== undefined) return;
  registration.viewId = app.addView({
    hostElement: registration.target,
    initialData: {
      componentId: registration.componentId,
      embedded: true,
      theme: selectedTheme(),
    },
  });
  // addView 同步创建宿主视图，下一帧交给 Flutter 绘制。
  window.requestAnimationFrame(() => {
    if (!registration.disposed) registration.setState('ready');
  });
}

async function mountView(registration: PreviewRegistration) {
  if (registration.disposed || registration.viewId !== undefined) return;
  registration.setState('loading');
  try {
    const app = await ensureRuntime();
    addView(registration, app);
  } catch (error) {
    console.error(error);
    if (!registration.disposed) registration.setState('error');
  }
}

async function recreateViewsForTheme() {
  if (!runtimePromise) return;
  let app: FlutterPreviewApp;
  try {
    app = await runtimePromise;
  } catch {
    return;
  }
  for (const registration of registrations) {
    if (registration.viewId === undefined || registration.disposed) continue;
    app.removeView(registration.viewId);
    registration.viewId = undefined;
    addView(registration, app);
  }
}

function observeTheme() {
  if (themeObserver) return;
  observedTheme = selectedTheme();
  themeObserver = new MutationObserver(() => {
    const nextTheme = selectedTheme();
    if (nextTheme === observedTheme) return;
    observedTheme = nextTheme;
    void recreateViewsForTheme();
  });
  themeObserver.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['class'],
  });
}

export function registerPreview(
  target: HTMLElement,
  componentId: string,
  setState: (state: PreviewState) => void,
) {
  const registration = {} as PreviewRegistration;
  registration.componentId = componentId;
  registration.target = target;
  registration.setState = setState;
  registration.disposed = false;
  registration.observer = new IntersectionObserver(
    ([entry]) => {
      if (entry.isIntersecting) void mountView(registration);
    },
    { rootMargin: '600px 0px' },
  );

  registrations.add(registration);
  registration.observer.observe(target);
  observeTheme();

  return {
    activate: () => void mountView(registration),
    dispose: async () => {
      registration.disposed = true;
      registration.observer.disconnect();
      registrations.delete(registration);
      if (registration.viewId === undefined || !runtimePromise) return;
      const app = await runtimePromise;
      app.removeView(registration.viewId);
      registration.viewId = undefined;
    },
  };
}
