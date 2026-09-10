export type PreviewPhase = 'idle' | 'assets' | 'engine' | 'view' | 'ready' | 'error';

export interface PreviewStatus {
  phase: PreviewPhase;
  message: string;
  reloadRequired?: boolean;
}

export type PreviewListener = (status: PreviewStatus) => void;

export interface FlutterPreviewApp {
  addView(options: {
    hostElement: HTMLElement;
    initialData: {
      componentId: string;
      embedded: boolean;
      theme: 'light' | 'dark';
      onFirstFrame: () => void;
    };
  }): number;
  removeView(viewId: number): unknown;
}

export interface PreviewBundle {
  protocolVersion: number;
  start(assetBase: string): Promise<FlutterPreviewApp>;
}

declare global {
  interface Window {
    hyUiPreviewBundle?: PreviewBundle;
  }
}

export class PreviewFailure extends Error {
  constructor(message: string, readonly reloadRequired = false) {
    super(message);
    this.name = 'PreviewFailure';
  }
}

export function failureStatus(error: unknown): PreviewStatus {
  return {
    phase: 'error',
    message: error instanceof Error ? error.message : String(error),
    reloadRequired: error instanceof PreviewFailure && error.reloadRequired,
  };
}
