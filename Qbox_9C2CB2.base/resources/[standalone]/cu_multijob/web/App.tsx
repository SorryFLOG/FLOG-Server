import React, { useEffect, useMemo, useState } from 'react';
import MultiJobMenu from './components/MultiJobMenu';
import { DEFAULT_STRINGS, MOCK_JOBS } from './constants';
import { Job, UiStrings } from './types';
import { MousePointer2 } from 'lucide-react';

const App: React.FC = () => {
  const isNui = useMemo(
    () => typeof (window as any).GetParentResourceName === 'function',
    []
  );

  const isDevPreview = !isNui && import.meta.env.DEV;
  const [isOpen, setIsOpen] = useState<boolean>(isDevPreview);
  const [jobs, setJobs] = useState<Job[]>(!isNui ? MOCK_JOBS : []);
  const [activeJobId, setActiveJobId] = useState<string>(MOCK_JOBS[0]?.id ?? '');
  const [strings, setStrings] = useState<UiStrings>(DEFAULT_STRINGS);

  const sendNui = async (action: string, data?: unknown) => {
    if (!isNui) return;
    const resource = (window as any).GetParentResourceName();
    await fetch(`https://${resource}/${action}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data ?? {}),
    });
  };

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const payload = event.data || {};
      if (payload.action === 'setData') {
        setIsOpen(Boolean(payload.visible));
        if (Array.isArray(payload.jobs)) setJobs(payload.jobs);
        if (payload.activeJob) setActiveJobId(payload.activeJob);
        if (payload.strings && typeof payload.strings === 'object') {
          setStrings({ ...DEFAULT_STRINGS, ...payload.strings });
        }
      }
    };
    window.addEventListener('message', handleMessage);
    return () => window.removeEventListener('message', handleMessage);
  }, []);

  useEffect(() => {
    const html = document.documentElement;
    const body = document.body;
    const root = document.getElementById('root');
    const prev = {
      htmlOverflowX: html.style.overflowX,
      htmlOverflowY: html.style.overflowY,
      htmlWidth: html.style.width,
      htmlHeight: html.style.height,
      bodyOverflowX: body.style.overflowX,
      bodyOverflowY: body.style.overflowY,
      bodyWidth: body.style.width,
      bodyHeight: body.style.height,
      bodyPosition: body.style.position,
      bodyTop: body.style.top,
      bodyRight: body.style.right,
      bodyBottom: body.style.bottom,
      bodyLeft: body.style.left,
      rootOverflowX: root?.style.overflowX ?? '',
      rootOverflowY: root?.style.overflowY ?? '',
      rootWidth: root?.style.width ?? '',
      rootHeight: root?.style.height ?? '',
      boxSizing: body.style.boxSizing,
    };

    html.style.overflowX = 'hidden';
    html.style.overflowY = 'hidden';
    html.style.width = '100%';
    html.style.height = '100%';
    body.style.overflowX = 'hidden';
    body.style.overflowY = 'hidden';
    body.style.width = '100%';
    body.style.height = '100%';
    body.style.position = 'fixed';
    body.style.top = '0';
    body.style.right = '0';
    body.style.bottom = '0';
    body.style.left = '0';
    body.style.boxSizing = 'border-box';
    if (root) {
      root.style.overflowX = 'hidden';
      root.style.overflowY = 'hidden';
      root.style.width = '100%';
      root.style.height = '100%';
    }

    return () => {
      html.style.overflowX = prev.htmlOverflowX;
      html.style.overflowY = prev.htmlOverflowY;
      html.style.width = prev.htmlWidth;
      html.style.height = prev.htmlHeight;
      body.style.overflowX = prev.bodyOverflowX;
      body.style.overflowY = prev.bodyOverflowY;
      body.style.width = prev.bodyWidth;
      body.style.height = prev.bodyHeight;
      body.style.position = prev.bodyPosition;
      body.style.top = prev.bodyTop;
      body.style.right = prev.bodyRight;
      body.style.bottom = prev.bodyBottom;
      body.style.left = prev.bodyLeft;
      body.style.boxSizing = prev.boxSizing;
      if (root) {
        root.style.overflowX = prev.rootOverflowX;
        root.style.overflowY = prev.rootOverflowY;
        root.style.width = prev.rootWidth;
        root.style.height = prev.rootHeight;
      }
    };
  }, []);

  const handleClose = () => {
    setIsOpen(false);
    if (isNui) {
      void sendNui('close');
    }
  };

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && isOpen) {
        handleClose();
        return;
      }
      if (isNui) return;
      if (e.key === 'F9' || (e.altKey && e.key.toLowerCase() === 'j')) {
        setIsOpen(prev => !prev);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isNui, isOpen]);

  const handleJobSelect = (job: Job) => {
    setActiveJobId(job.id);
    if (isNui) {
      void sendNui('selectJob', { name: job.name });
    }
  };

  const handleJobResign = (job: Job) => {
    if (isNui) {
      void sendNui('resignJob', { name: job.name });
    } else {
      setJobs(prev => prev.filter(item => item.id !== job.id));
    }
  };

  return (
    <div className="relative w-full h-full overflow-hidden overflow-x-hidden">


      <MultiJobMenu
        isOpen={isOpen}
        jobs={jobs}
        activeJobId={activeJobId}
        strings={strings}
        onSelect={handleJobSelect}
        onResign={handleJobResign}
        onClose={handleClose}
      />

      {!isNui && (
        <button
          onClick={() => setIsOpen(!isOpen)}
          className="absolute top-10 right-10 z-50 p-3 bg-black/40 hover:bg-black/60 rounded-full transition-all duration-300 border border-white/10 shadow-xl group"
        >
          <MousePointer2 className={`w-6 h-6 text-white transition-transform duration-500 ${isOpen ? 'rotate-180' : ''}`} />
        </button>
      )}

      {/*
        HUD elements removed per request:
        - current job (top-left)
        - open-menu hint (bottom-left)
      */}
    </div>
  );
};

export default App;
