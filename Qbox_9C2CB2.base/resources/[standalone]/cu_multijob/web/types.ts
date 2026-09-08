
export interface Job {
  id: string;
  name: string;
  label: string;
  grade: number;
  gradeLabel: string;
  icon: string;
  color: string;
}

export type JobCategory = 'state' | 'illegal' | 'service' | 'other';

export interface UiStrings {
  title: string;
  hintClose: string;
  hintSelect: string;
  hintResign: string;
  keyClose: string;
  keySelect: string;
  keyResign: string;
}
