import React from 'react';
import { TaskStatus, TaskPriority } from '../types';
import { Search, Filter } from 'lucide-react';

interface TaskFilterProps {
  search: string;
  onSearchChange: (value: string) => void;
  status?: TaskStatus;
  onStatusChange: (status?: TaskStatus) => void;
  priority?: TaskPriority;
  onPriorityChange: (priority?: TaskPriority) => void;
}

export const TaskFilter: React.FC<TaskFilterProps> = ({
  search,
  onSearchChange,
  status,
  onStatusChange,
  priority,
  onPriorityChange,
}) => {
  const statusOptions: { label: string; value?: TaskStatus }[] = [
    { label: 'All Statuses', value: undefined },
    { label: 'Pending', value: 'pending' },
    { label: 'In Progress', value: 'in_progress' },
    { label: 'Completed', value: 'completed' },
  ];

  const priorityOptions: { label: string; value?: TaskPriority }[] = [
    { label: 'All Priorities', value: undefined },
    { label: 'Low', value: 'low' },
    { label: 'Medium', value: 'medium' },
    { label: 'High', value: 'high' },
  ];

  return (
    <div className="glass-card rounded-xl p-4 flex flex-col md:flex-row items-center gap-4">
      {/* Search Input */}
      <div className="relative flex-1 w-full">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
        <input
          type="text"
          value={search}
          onChange={(e) => onSearchChange(e.target.value)}
          placeholder="Search tasks by title or description..."
          className="w-full bg-slate-900 border border-slate-700/80 rounded-lg pl-9 pr-4 py-2 text-sm text-slate-200 focus:outline-none focus:border-cyan-500 transition-colors"
        />
      </div>

      {/* Status Pills */}
      <div className="flex items-center gap-1.5 w-full md:w-auto overflow-x-auto pb-1 md:pb-0">
        <Filter className="h-4 w-4 text-slate-400 mr-1 hidden lg:block" />
        {statusOptions.map((opt, idx) => (
          <button
            key={idx}
            onClick={() => onStatusChange(opt.value)}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-all whitespace-nowrap ${
              status === opt.value
                ? 'bg-cyan-600 text-white shadow-md shadow-cyan-600/30'
                : 'bg-slate-800/80 text-slate-400 hover:bg-slate-700 hover:text-slate-200'
            }`}
          >
            {opt.label}
          </button>
        ))}
      </div>

      {/* Priority Selector */}
      <select
        value={priority || ''}
        onChange={(e) => onPriorityChange(e.target.value ? (e.target.value as TaskPriority) : undefined)}
        className="w-full md:w-auto bg-slate-900 border border-slate-700/80 rounded-lg px-3 py-2 text-sm text-slate-300 focus:outline-none focus:border-cyan-500"
      >
        {priorityOptions.map((opt, idx) => (
          <option key={idx} value={opt.value || ''}>
            {opt.label}
          </option>
        ))}
      </select>
    </div>
  );
};
