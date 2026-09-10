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
  private frameTimer?: number;

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

  dispose() {
    this.disposed = true;
    this.detach();
  }

  private attach() {
    if (!this.app) return;
    const generation = ++this.generation;
    this.onStatus({ phase: 'view', message: '正在绘制演示…' });
    this.frameTimer = window.setTimeout(() => {
      if (this.disposed || generation !== this.generation) return;
      this.detach();
      this.onStatus(failureStatus(new PreviewFailure(
        '演示未在 20 秒内提交首帧。请检查 Flutter 错误，并确认预览构建与文档版本一致。', true,
      )));
    }, 20_000);
    try {
      this.viewId = this.app.addView({
        hostElement: this.target,
        initialData: {
          componentId: this.componentId, embedded: true, theme: selectedTheme(),
          onFirstFrame: () => {
            if (this.disposed || generation !== this.generation) return;
            window.clearTimeout(this.frameTimer);
            this.onStatus({ phase: 'ready', message: '' });
          },
        },
      });
    } catch (error) {
      window.clearTimeout(this.frameTimer);
      throw new PreviewFailure(error instanceof Error ? error.message : String(error), true);
    }
  }

  private detach() {
    ++this.generation;
    window.clearTimeout(this.frameTimer);
    const previousId = this.viewId;
    this.viewId = undefined;
    if (previousId !== undefined) {
      try { this.app?.removeView(previousId); }
      catch (error) { console.error('Flutter 视图清理失败', error); }
    }
  }
}
