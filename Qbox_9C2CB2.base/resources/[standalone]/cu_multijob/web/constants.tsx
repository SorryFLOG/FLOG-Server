import { Job, UiStrings } from './types';

export const MOCK_JOBS: Job[] = [
  {
    id: 'police',
    name: 'police',
    label: 'Police',
    grade: 5,
    gradeLabel: 'Lieutenant',
    icon: 'Shield',
    color: '#3b82f6',
  },
  {
    id: 'ambulance',
    name: 'ambulance',
    label: 'Medic',
    grade: 2,
    gradeLabel: 'Doctor',
    icon: 'Stethoscope',
    color: '#ef4444',
  },
  {
    id: 'mechanic',
    name: 'mechanic',
    label: 'Mechanic',
    grade: 8,
    gradeLabel: 'Master',
    icon: 'Wrench',
    color: '#f59e0b',
  },
  {
    id: 'unemployed',
    name: 'unemployed',
    label: 'Unemployed',
    grade: 0,
    gradeLabel: 'Citizen',
    icon: 'User',
    color: '#9ca3af',
  },
  {
    id: 'taxi',
    name: 'taxi',
    label: 'Taxi Driver',
    grade: 3,
    gradeLabel: 'Driver',
    icon: 'Car',
    color: '#fbbf24',
  },
];

export const DEFAULT_STRINGS: UiStrings = {
  title: 'Job Selection',
  hintClose: 'Close',
  hintSelect: 'Select',
  hintResign: 'Resign',
  keyClose: 'ESC',
  keySelect: 'ENTER',
  keyResign: 'RMB',
};