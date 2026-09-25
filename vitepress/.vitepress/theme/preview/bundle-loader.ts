import { PreviewFailure, type FlutterPreviewApp, type PreviewListener, type PreviewStatus } from './contracts';
import { PreviewLoadDiagnostics } from './load-diagnostics';

export interface PreviewBundleLoaderOptions {
  developmentServer?: boolean;
}

/** 开发时连接 Flutter 调试服务，发布时加载同站点 release 静态包。 */
export class PreviewBundleLoader {
  private pending?: Promise<FlutterPreviewApp>;
  private engineStarted = false;
  private readonly listeners = new Set<PreviewListener>();
  private status: PreviewStatus = {
    phase: 'assets',
    message: '正在准备交互预览…',
  };

  constructor(
    private readonly basePath: string,
    private readonly options: PreviewBundleLoaderOptions = {},
  ) {}

  getApp(onStatus: PreviewListener): Promise<FlutterPreviewApp> {
    this.listeners.add(onStatus);
    onStatus(this.status);
    this.pending ??= this.load().catch((error: unknown) => {
      // 引擎启动后保留失败结果，避免同页重复启动造成全局状态冲突。
      if (!this.engineStarted && !(error instanceof PreviewFailure && error.reloadRequired)) {
        this.pending = undefined;
      }
      throw error;
    });
    return this.pending.finally(() => this.listeners.delete(onStatus));
  }

  /** 预热共享引擎；具体 Flutter View 仍由视口按需创建。 */
  prewarm(): Promise<void> {
    return this.getApp(() => undefined).then(() => undefined);
  }

  private async load(): Promise<FlutterPreviewApp> {
    const base = new URL(this.basePath, window.location.origin);
    const diagnostics = this.options.developmentServer ? new PreviewLoadDiagnostics(base) : undefined;
    this.preload(new URL('main.dart.js', base).href, 'script');
    if (this.options.developmentServer) {
      this.preload(new URL('dart_sdk.js', base).href, 'script');
    }
    await this.loadScript(new URL('flutter_bootstrap.js', base).href);
    diagnostics?.bootstrapLoaded();
    if (this.options.developmentServer) {
      // Bootstrap 到达后，这些 Debug 后续脚本已由 Flutter 服务生成。
      this.preload(new URL('ddc_module_loader.js', base).href, 'script');
      this.preload(new URL('main_module.bootstrap.js', base).href, 'script');
    }
    const bundle = window.hyUiPreviewBundle;
    if (!bundle || bundle.protocolVersion !== 2) {
      throw new PreviewFailure('预览接口版本不匹配。组件预览已拆分，请重新生成完整预览包并刷新页面。', true);
    }
    this.engineStarted = true;
    this.updateStatus({
      phase: 'entrypoint',
      message: this.options.developmentServer ? '正在加载 Dart 调试模块…' : '正在加载 Dart 入口…',
    });
    const progressTimer = diagnostics ? window.setInterval(() => {
      this.updateStatus({
        phase: 'entrypoint',
        message: `加载 Dart 模块 · ${diagnostics.completedScripts} 个 · ${diagnostics.elapsedSeconds} 秒`,
      });
    }, 1000) : undefined;
    try {
      const app = await bundle.start(base.href, {
        allowDebug: this.options.developmentServer,
        onEntrypointLoaded: () => {
          diagnostics?.entrypointLoaded();
          if (progressTimer !== undefined) window.clearInterval(progressTimer);
          this.updateStatus({
            phase: 'engine',
            message: '正在初始化 Flutter 渲染引擎…',
          });
        },
      });
      diagnostics?.finish();
      if (typeof app?.addView !== 'function' || typeof app?.removeView !== 'function') {
        throw new Error('构建产物未提供 Flutter 多视图接口');
      }
      return app;
    } catch (error) {
      throw new PreviewFailure(
        error instanceof Error ? error.message : String(error), true,
      );
    } finally {
      if (progressTimer !== undefined) window.clearInterval(progressTimer);
    }
  }

  private updateStatus(status: PreviewStatus) {
    this.status = status;
    for (const listener of this.listeners) listener(status);
  }

  private preload(url: string, as: 'script') {
    if (document.head.querySelector(`link[rel="preload"][href="${url}"]`)) return;
    const link = document.createElement('link');
    link.rel = 'preload';
    link.as = as;
    link.href = url;
    document.head.appendChild(link);
  }

  private loadScript(url: string): Promise<void> {
    if (window.hyUiPreviewBundle) return Promise.resolve();
    return new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = url;
      script.onload = () => window.hyUiPreviewBundle ? resolve() : reject(new PreviewFailure(
        '预览启动脚本缺少宿主接口，请重新生成预览构建。', true,
      ));
      script.onerror = () => {
        script.remove();
        reject(new PreviewFailure(`无法读取预览启动脚本：${url}`));
      };
      document.head.appendChild(script);
    });
  }
}
