import React from 'react';
import { TaskStats } from '../types';
import { CheckCircle2, Clock, AlertTriangle, Layers } from 'lucide-react';

interface StatsOverviewProps {
  stats: TaskStats;
}

export const StatsOverview: React.FC<StatsOverviewProps> = ({ stats }) => {
  const cards = [
    {
      title: 'Total Tasks',
      value: stats.total_tasks,
      icon: Layers,
      color: 'from-blue-500/20 to-indigo-500/20 text-blue-400 border-blue-500/30',
    },
    {
      title: 'Completed',
      value: stats.completed_tasks,
      icon: CheckCircle2,
      color: 'from-emerald-500/20 to-teal-500/20 text-emerald-400 border-emerald-500/30',
    },
    {
      title: 'Pending',
      value: stats.pending_tasks + stats.in_progress_tasks,
      icon: Clock,
      color: 'from-amber-500/20 to-orange-500/20 text-amber-400 border-amber-500/30',
    },
    {
      title: 'High Priority',
      value: stats.high_priority_tasks,
      icon: AlertTriangle,
      color: 'from-rose-500/20 to-pink-500/20 text-rose-400 border-rose-500/30',
    },
  ];

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      {cards.map((card, idx) => {
        const IconComponent = card.icon;
        return (
          <div
            key={idx}
            className="glass-card rounded-2xl p-5 border transition-all duration-300 hover:scale-[1.02] hover:shadow-lg"
          >
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs uppercase tracking-wider font-semibold text-slate-400">{card.title}</p>
                <h3 className="text-3xl font-extrabold mt-1 text-slate-100">{card.value}</h3>
              </div>
              <div className={`p-3 rounded-xl bg-gradient-to-br border ${card.color}`}>
                <IconComponent className="h-6 w-6" />
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};
