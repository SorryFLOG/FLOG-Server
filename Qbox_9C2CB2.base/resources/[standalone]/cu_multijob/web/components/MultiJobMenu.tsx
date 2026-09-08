import React from 'react';
import { Job, UiStrings } from '../types';
import * as Icons from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

interface MultiJobMenuProps {
  isOpen: boolean;
  jobs: Job[];
  activeJobId: string;
  strings: UiStrings;
  onSelect: (job: Job) => void;
  onResign?: (job: Job) => void;
  onClose: () => void;
}

const MultiJobMenu: React.FC<MultiJobMenuProps> = ({
  isOpen,
  jobs,
  activeJobId,
  strings,
  onSelect,
  onResign,
  onClose,
}) => {
  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ x: '100%', opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          exit={{ x: '100%', opacity: 0 }}
          transition={{ type: 'spring', damping: 25, stiffness: 200 }}
          className="fixed top-0 right-0 h-full w-[88vw] z-40 flex flex-col justify-center items-end pr-6 sm:pr-12 pointer-events-none overflow-hidden"
        >
          <div className="flex w-full flex-col items-end gap-6 pointer-events-auto overflow-hidden">
            <div className="w-full max-w-[520px] rounded-2xl px-6 py-6">
              <div className="text-right">
                <h2 className="text-white text-[11px] uppercase tracking-[0.2em] font-medium job-text-shadow mb-2">
                  {strings.title}
                </h2>
                <div className="h-[1px] w-24 bg-gradient-to-l from-white/30 to-transparent ml-auto" />
              </div>

              <div className="flex flex-col gap-4 items-end w-full overflow-hidden mt-4">
                {jobs.map((job, index) => {
                  const isActive = activeJobId === job.id;
                  const IconComponent = (Icons as any)[job.icon] || Icons.Briefcase;

                  return (
                    <motion.button
                      key={job.id}
                      initial={{ x: 20, opacity: 0 }}
                      animate={{ x: 0, opacity: 1 }}
                      transition={{ delay: index * 0.05 }}
                      onClick={() => onSelect(job)}
                      onContextMenu={event => {
                        if (!onResign) return;
                        event.preventDefault();
                        onResign(job);
                      }}
                      className={`
                      group relative flex items-center gap-4 py-2 px-3 rounded-full transition-all duration-300 outline-none job-item
                      ${isActive ? 'pr-2' : ''}
                    `}
                    >
                      <div className="text-right flex flex-col items-end">
                        <span
                          className={`
                        text-xl font-medium tracking-wide job-text-shadow transition-all duration-300
                        text-white
                      `}
                        >
                          {job.label}
                        </span>
                        <span
                          className={`
                        text-[9px] uppercase tracking-[0.12em] font-medium transition-all duration-300 job-text-shadow
                        text-white
                      `}
                        >
                          {job.gradeLabel}
                        </span>
                      </div>

                      <div
                        className={`
                      relative w-12 h-12 flex items-center justify-center rounded-full border border-white/10 transition-all duration-300
                      ${isActive ? 'scale-110 border-white/30' : ''}
                    `}
                      >
                        <IconComponent
                          className="w-5 h-5 transition-all duration-300 text-white"
                          strokeWidth={1.5}
                        />

                        {isActive && (
                          <motion.div
                            layoutId="active-bg"
                            className="absolute inset-[-4px] rounded-full border border-white/20"
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            transition={{ duration: 0.3 }}
                          />
                        )}
                      </div>

                      <AnimatePresence>
                        {isActive && (
                          <motion.div
                            layoutId="active-line"
                            initial={{ opacity: 0, height: 0 }}
                            animate={{ opacity: 1, height: 24 }}
                            exit={{ opacity: 0, height: 0 }}
                            className="absolute right-1 top-0 bottom-0 my-auto h-6 w-2 bg-white/80 rounded-full shadow-[0_0_10px_rgba(255,255,255,0.5)]"
                          />
                        )}
                      </AnimatePresence>
                    </motion.button>
                  );
                })}
              </div>

              <div className="text-right mt-6">
                <div className="flex items-center gap-3 justify-end text-[10px] text-white uppercase tracking-[0.14em] job-text-shadow font-medium">
                  <span className="flex items-center gap-1">
                    <kbd className="px-1.5 py-0.5 bg-white/10 rounded text-white">{strings.keyClose}</kbd> {strings.hintClose}
                  </span>
                  <span className="flex items-center gap-1">
                    <kbd className="px-1.5 py-0.5 bg-white/10 rounded text-white">{strings.keySelect}</kbd> {strings.hintSelect}
                  </span>
                  {onResign && (
                    <span className="flex items-center gap-1">
                      <kbd className="px-1.5 py-0.5 bg-white/10 rounded text-white">{strings.keyResign}</kbd> {strings.hintResign}
                    </span>
                  )}
                </div>
              </div>
            </div>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default MultiJobMenu;
