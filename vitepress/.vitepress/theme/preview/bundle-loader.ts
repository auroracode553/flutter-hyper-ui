import { PreviewFailure, type FlutterPreviewApp, type PreviewListener, type PreviewStatus } from './contracts';

export interface PreviewBundleLoaderOptions {
  developmentServer?: boolean;
}

/** 开发时连接 Flutter 调试服务，发布时加载同站点 release 静态包。 */
export class PreviewBundleLoader {
  private pending?: Promise<FlutterPreviewApp>;
  private engineStarted = false;
  private readonly listeners = new Set<PreviewListener>();
  private status: PreviewStatus = { phase: 'assets', message: '正在检查预览资源…' };

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

  private async load(): Promise<FlutterPreviewApp> {
    const base = new URL(this.basePath, window.location.origin);
    if (!this.options.developmentServer) await this.checkBundle(base);
    await this.loadScript(new URL('flutter_bootstrap.js', base).href);
    const bundle = window.hyUiPreviewBundle;
    if (!bundle || bundle.protocolVersion !== 1) {
      throw new PreviewFailure('预览接口版本不匹配，请替换完整构建产物并刷新页面。', true);
    }
    this.engineStarted = true;
    this.status = { phase: 'engine', message: '正在初始化预览…' };
    for (const listener of this.listeners) listener(this.status);
    return new Promise<FlutterPreviewApp>((resolve, reject) => {
      const timer = window.setTimeout(() => reject(new PreviewFailure(
        '预览初始化超过 60 秒。请检查 main.dart.js 和 canvaskit 资源是否完整，修复后刷新页面。', true,
      )), 60_000);
      Promise.resolve().then(() => bundle.start(base.href, {
        allowDebug: this.options.developmentServer,
      })).then((app) => {
        if (typeof app?.addView !== 'function' || typeof app?.removeView !== 'function') {
          throw new Error('构建产物未提供 Flutter 多视图接口');
        }
        resolve(app);
      }).catch((error: unknown) => reject(new PreviewFailure(
        error instanceof Error ? error.message : String(error), true,
      ))).finally(() => window.clearTimeout(timer));
    });
  }

  private async checkBundle(base: URL) {
    const controller = new AbortController();
    const timer = window.setTimeout(() => controller.abort(), 12_000);
    try {
      // version.json is emitted by every Flutter Web release build. Relying on
      // it avoids a second custom manifest that Flutter might not copy.
      const response = await fetch(new URL('version.json', base), {
        signal: controller.signal, cache: 'no-store',
      });
      if (!response.ok || !response.headers.get('content-type')?.includes('application/json')) {
        throw new Error('missing preview version');
      }
      const version = await response.json();
      if (version.app_name !== 'flutter_hyper_ui_preview') {
        throw new Error('incompatible preview bundle');
      }
    } catch {
      throw new PreviewFailure(
        '预览构建产物缺失、不兼容或不可访问。请使用 dev-docs watcher，或重新生成完整 release 文档包。',
      );
    } finally {
      window.clearTimeout(timer);
    }
  }

  private loadScript(url: string): Promise<void> {
    if (window.hyUiPreviewBundle) return Promise.resolve();
    return new Promise((resolve, reject) => {
      const script = document.createElement('script');
      let settled = false;
      const finish = (error?: PreviewFailure) => {
        if (settled) return;
        settled = true;
        window.clearTimeout(timer);
        script.onload = null;
        script.onerror = null;
        if (error) { script.remove(); reject(error); }
        else resolve();
      };
      // 超时脚本可能已执行一部分，需刷新页面以清理运行时状态。
      const timer = window.setTimeout(() => finish(new PreviewFailure(
        '预览启动脚本加载超时，请检查资源请求后刷新页面。', true,
      )), 15_000);
      script.src = url;
      script.onload = () => finish(window.hyUiPreviewBundle ? undefined : new PreviewFailure(
        '启动脚本不是本项目的静态预览构建，请重新构建并刷新页面。', true,
      ));
      script.onerror = () => finish(new PreviewFailure(`无法读取预览启动脚本：${url}`));
      document.head.appendChild(script);
    });
  }
}
