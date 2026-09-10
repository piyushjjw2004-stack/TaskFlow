import React from 'react';
import { Task } from '../types';
import { CheckCircle, Clock, AlertCircle, Edit2, Trash2, Calendar } from 'lucide-react';

interface TaskCardProps {
  task: Task;
  onEdit: (task: Task) => void;
  onDelete: (id: number) => void;
  onComplete: (id: number) => void;
}

export const TaskCard: React.FC<TaskCardProps> = ({ task, onEdit, onDelete, onComplete }) => {
  const getStatusBadge = () => {
    switch (task.status) {
      case 'completed':
        return (
          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-950 text-emerald-400 border border-emerald-800/60">
            <CheckCircle className="h-3 w-3" /> Completed
          </span>
        );
      case 'in_progress':
        return (
          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-cyan-950 text-cyan-400 border border-cyan-800/60">
            <Clock className="h-3 w-3" /> In Progress
          </span>
        );
      default:
        return (
          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-amber-950 text-amber-400 border border-amber-800/60">
            <Clock className="h-3 w-3" /> Pending
          </span>
        );
    }
  };

  const getPriorityBadge = () => {
    switch (task.priority) {
      case 'high':
        return (
          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-bold bg-rose-950 text-rose-400 border border-rose-800/50">
            <AlertCircle className="h-3 w-3" /> High
          </span>
        );
      case 'medium':
        return (
          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-medium bg-amber-950/80 text-amber-300 border border-amber-800/40">
            Medium
          </span>
        );
      default:
        return (
          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-medium bg-slate-800 text-slate-400 border border-slate-700">
            Low
          </span>
        );
    }
  };

  const formattedDate = new Date(task.created_at).toLocaleDateString(undefined, {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });

  return (
    <div className="glass-card rounded-xl p-5 border flex flex-col justify-between hover:border-slate-700 transition-all">
      <div>
        <div className="flex items-start justify-between gap-3 mb-2">
          <h4 className={`text-base font-semibold ${task.status === 'completed' ? 'line-through text-slate-400' : 'text-slate-100'}`}>
            {task.title}
          </h4>
          <div className="flex items-center gap-1.5 flex-shrink-0">
            {getPriorityBadge()}
            {getStatusBadge()}
          </div>
        </div>

        {task.description && (
          <p className="text-sm text-slate-400 line-clamp-3 mb-4 leading-relaxed">
            {task.description}
          </p>
        )}
      </div>

      <div className="flex items-center justify-between pt-4 border-t border-slate-800/80 mt-2 text-xs text-slate-500">
        <div className="flex items-center gap-1">
          <Calendar className="h-3.5 w-3.5 text-slate-400" />
          <span>{formattedDate}</span>
        </div>

        <div className="flex items-center gap-2">
          {task.status !== 'completed' && (
            <button
              onClick={() => onComplete(task.id)}
              className="px-2.5 py-1 rounded-md bg-emerald-950/80 text-emerald-400 hover:bg-emerald-900 border border-emerald-800/60 transition-colors"
            >
              Complete
            </button>
          )}
          <button
            onClick={() => onEdit(task)}
            className="p-1.5 rounded-md hover:bg-slate-800 text-slate-400 hover:text-slate-200 transition-colors"
            title="Edit Task"
          >
            <Edit2 className="h-3.5 w-3.5" />
          </button>
          <button
            onClick={() => onDelete(task.id)}
            className="p-1.5 rounded-md hover:bg-rose-950/50 text-slate-400 hover:text-rose-400 transition-colors"
            title="Delete Task"
          >
            <Trash2 className="h-3.5 w-3.5" />
          </button>
        </div>
      </div>
    </div>
  );
};
