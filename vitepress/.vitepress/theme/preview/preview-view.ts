import type { PreviewBundleLoader } from './bundle-loader';
import { failureStatus, PreviewFailure, type FlutterPreviewApp, type PreviewListener } from './contracts';

export function selectedTheme(): 'light' | 'dark' {
  return document.documentElement.classList.contains('dark') ? 'dark' : 'light';
}

/** 每个容器独立管理视图，首帧确认由 Dart 回调提供。 */
export class PreviewView {
  private app?: FlutterPreviewApp;
  private viewId?: number;
  private pending = false;
  private disposed = false;
  private generation = 0;

  constructor(
    private readonly target: HTMLElement,
    private readonly componentId: string,
    private readonly loader: PreviewBundleLoader,
    private readonly onStatus: PreviewListener,
  ) {}

  async mount() {
    if (this.disposed || this.pending || this.viewId !== undefined) return;
    this.pending = true;
    try {
      this.app = await this.loader.getApp((status) => {
        if (!this.disposed) this.onStatus(status);
      });
      if (!this.disposed) this.attach();
    } catch (error) {
      if (!this.disposed) this.onStatus(failureStatus(error));
    } finally {
      this.pending = false;
    }
  }

  refreshTheme() {
    if (this.disposed || this.viewId === undefined) return;
    try { this.detach(); this.attach(); }
    catch (error) { this.onStatus(failureStatus(error)); }
  }

  reset() {
    if (this.disposed) return;
    if (!this.app || this.viewId === undefined) {
      void this.mount();
      return;
    }
    try { this.detach(); this.attach(); }
    catch (error) { this.onStatus(failureStatus(error)); }
  }

  dispose() {
    this.disposed = true;
    this.detach();
  }

  private attach() {
    if (!this.app) return;
    const generation = ++this.generation;
    this.onStatus({ phase: 'view', message: '正在绘制交互界面…' });
    try {
      this.viewId = this.app.addView({
        hostElement: this.target,
        initialData: {
          componentId: this.componentId, embedded: true, theme: selectedTheme(),
          onFirstFrame: () => {
            if (this.disposed || generation !== this.generation) return;
            this.onStatus({ phase: 'ready', message: '' });
          },
        },
      });
    } catch (error) {
      throw new PreviewFailure(error instanceof Error ? error.message : String(error), true);
    }
  }

  private detach() {
    ++this.generation;
    const previousId = this.viewId;
    this.viewId = undefined;
    if (previousId !== undefined) {
      try { this.app?.removeView(previousId); }
      catch (error) { console.error('Flutter 视图清理失败', error); }
    }
  }
}
