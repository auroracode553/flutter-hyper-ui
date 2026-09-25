/** 仅用于本地 Debug 预览，记录入口脚本与 DDC 模块的实际等待时间。 */
export class PreviewLoadDiagnostics {
  private readonly startedAt = performance.now();
  private bootstrapAt?: number;
  private entrypointAt?: number;

  constructor(private readonly base: URL) {
    // DDC 会请求大量小模块，默认的 250 条 Resource Timing 记录不够诊断。
    performance.setResourceTimingBufferSize(2000);
  }

  bootstrapLoaded() {
    this.bootstrapAt = performance.now();
  }

  entrypointLoaded() {
    this.entrypointAt = performance.now();
  }

  get elapsedSeconds() {
    return ((performance.now() - (this.bootstrapAt ?? this.startedAt)) / 1000).toFixed(0);
  }

  get completedScripts() {
    return this.scripts.length;
  }

  finish() {
    const finishedAt = performance.now();
    const scripts = this.scripts;
    const seconds = (start: number, end: number) => ((end - start) / 1000).toFixed(1);
    const bootstrapAt = this.bootstrapAt ?? finishedAt;
    const entrypointAt = this.entrypointAt ?? finishedAt;
    const lastScriptEnd = Math.max(bootstrapAt, ...scripts.map((script) => script.responseEnd));
    const summary = {
      启动脚本等待秒数: seconds(this.startedAt, bootstrapAt),
      Dart调试模块秒数: seconds(bootstrapAt, entrypointAt),
      Flutter引擎秒数: seconds(entrypointAt, finishedAt),
      最后脚本结束到入口回调秒数: seconds(lastScriptEnd, entrypointAt),
      已完成脚本请求数: scripts.length,
      最慢脚本: [...scripts]
        .sort((left, right) => right.duration - left.duration)
        .slice(0, 8)
        .map((script) => ({
          路径: new URL(script.name).pathname,
          秒数: seconds(0, script.duration),
          传输KB: Math.round(script.transferSize / 1024),
        })),
    };
    console.info(`[Hy UI 预览] 首次加载耗时 ${JSON.stringify(summary)}`);
  }

  private get scripts() {
    return performance.getEntriesByType('resource')
      .filter((entry): entry is PerformanceResourceTiming => entry instanceof PerformanceResourceTiming)
      .filter((entry) => {
        const url = new URL(entry.name);
        return url.origin === this.base.origin
          && url.pathname.startsWith(this.base.pathname)
          && url.pathname.endsWith('.js');
      });
  }
}
