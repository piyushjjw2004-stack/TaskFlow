import React, { useEffect, useState } from 'react';
import { Navbar } from '../components/Navbar';
import { StatsOverview } from '../components/StatsOverview';
import { TaskCard } from '../components/TaskCard';
import { TaskModal } from '../components/TaskModal';
import { tasksApi } from '../api/tasksApi';
import { Task, TaskStats, TaskStatus, TaskPriority } from '../types';
import { Plus, Activity, Server, ShieldCheck, Cpu } from 'lucide-react';
import { useAuth } from '../context/AuthContext';

export const Dashboard: React.FC = () => {
  const { user } = useAuth();
  const [stats, setStats] = useState<TaskStats>({
    total_tasks: 0,
    completed_tasks: 0,
    pending_tasks: 0,
    in_progress_tasks: 0,
    high_priority_tasks: 0,
  });
  const [recentTasks, setRecentTasks] = useState<Task[]>([]);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [selectedTask, setSelectedTask] = useState<Task | null>(null);

  const loadDashboardData = async () => {
    try {
      setIsLoading(true);
      const [statsData, tasksData] = await Promise.all([
        tasksApi.getTaskStats(),
        tasksApi.getTasks(),
      ]);
      setStats(statsData);
      setRecentTasks(tasksData.slice(0, 6)); // Top 6 recent tasks
    } catch (err) {
      console.error('Failed to load dashboard data:', err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadDashboardData();
  }, []);

  const handleCreateOrUpdateTask = async (data: {
    title: string;
    description?: string;
    status: TaskStatus;
    priority: TaskPriority;
  }) => {
    if (selectedTask) {
      await tasksApi.updateTask(selectedTask.id, data);
    } else {
      await tasksApi.createTask(data);
    }
    loadDashboardData();
  };

  const handleCompleteTask = async (id: number) => {
    await tasksApi.completeTask(id);
    loadDashboardData();
  };

  const handleDeleteTask = async (id: number) => {
    if (window.confirm('Are you sure you want to delete this task?')) {
      await tasksApi.deleteTask(id);
      loadDashboardData();
    }
  };

  const handleEditClick = (task: Task) => {
    setSelectedTask(task);
    setIsModalOpen(true);
  };

  const handleCreateClick = () => {
    setSelectedTask(null);
    setIsModalOpen(true);
  };

  return (
    <div className="min-h-screen bg-slate-950 flex flex-col">
      <Navbar />

      <main className="flex-1 max-w-7xl w-full mx-auto px-6 py-8 space-y-8">
        {/* Welcome Banner */}
        <div className="glass-card rounded-3xl p-8 border border-slate-800 relative overflow-hidden bg-gradient-to-r from-slate-900 via-slate-900 to-cyan-950/40">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 relative z-10">
            <div>
              <span className="text-xs uppercase tracking-widest font-mono text-cyan-400 font-semibold">
                DevOps Control Panel
              </span>
              <h2 className="text-3xl font-extrabold text-slate-100 mt-1">
                Welcome back, {user?.full_name || user?.email || 'Engineer'}!
              </h2>
              <p className="text-slate-400 text-sm mt-1 max-w-2xl">
                TaskFlow microservice backend is active and streaming metrics to Prometheus. Monitor cluster workload and manage operational tasks.
              </p>
            </div>

            <button
              onClick={handleCreateClick}
              className="px-6 py-3 rounded-2xl bg-gradient-to-r from-cyan-500 to-blue-600 hover:from-cyan-400 hover:to-blue-500 text-white font-semibold text-sm shadow-xl shadow-cyan-500/25 flex items-center justify-center gap-2 transition-all flex-shrink-0"
            >
              <Plus className="h-5 w-5" />
              <span>Create New Task</span>
            </button>
          </div>
        </div>

        {/* System Health Indicators */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3 text-xs">
          <div className="glass-panel rounded-xl p-3.5 flex items-center gap-3 border border-slate-800/80">
            <div className="p-2 rounded-lg bg-emerald-950/80 text-emerald-400 border border-emerald-800/50">
              <Server className="h-4 w-4" />
            </div>
            <div>
              <p className="text-slate-400 font-mono">Backend API</p>
              <p className="font-semibold text-emerald-400">FastAPI / Online</p>
            </div>
          </div>

          <div className="glass-panel rounded-xl p-3.5 flex items-center gap-3 border border-slate-800/80">
            <div className="p-2 rounded-lg bg-cyan-950/80 text-cyan-400 border border-cyan-800/50">
              <Activity className="h-4 w-4" />
            </div>
            <div>
              <p className="text-slate-400 font-mono">Database</p>
              <p className="font-semibold text-cyan-400">PostgreSQL / Connected</p>
            </div>
          </div>

          <div className="glass-panel rounded-xl p-3.5 flex items-center gap-3 border border-slate-800/80">
            <div className="p-2 rounded-lg bg-indigo-950/80 text-indigo-400 border border-indigo-800/50">
              <Cpu className="h-4 w-4" />
            </div>
            <div>
              <p className="text-slate-400 font-mono">K8s Scaling</p>
              <p className="font-semibold text-indigo-400">HPA Active (2-5 pods)</p>
            </div>
          </div>

          <div className="glass-panel rounded-xl p-3.5 flex items-center gap-3 border border-slate-800/80">
            <div className="p-2 rounded-lg bg-emerald-950/80 text-emerald-400 border border-emerald-800/50">
              <ShieldCheck className="h-4 w-4" />
            </div>
            <div>
              <p className="text-slate-400 font-mono">Security</p>
              <p className="font-semibold text-emerald-400">JWT / Trivy Scanned</p>
            </div>
          </div>
        </div>

        {/* Task Statistics */}
        <StatsOverview stats={stats} />

        {/* Recent Tasks */}
        <div className="space-y-4 pt-4">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-bold text-slate-100">Recent Tasks</h3>
            <span className="text-xs text-slate-400">Showing top recent tasks</span>
          </div>

          {isLoading ? (
            <div className="py-12 text-center text-slate-500">Loading task matrix...</div>
          ) : recentTasks.length === 0 ? (
            <div className="glass-card rounded-2xl p-12 text-center border border-slate-800">
              <p className="text-slate-400 text-sm">No tasks created yet.</p>
              <button
                onClick={handleCreateClick}
                className="mt-4 px-4 py-2 rounded-xl bg-cyan-600 hover:bg-cyan-500 text-white text-xs font-semibold"
              >
                + Create Your First Task
              </button>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {recentTasks.map((task) => (
                <TaskCard
                  key={task.id}
                  task={task}
                  onEdit={handleEditClick}
                  onDelete={handleDeleteTask}
                  onComplete={handleCompleteTask}
                />
              ))}
            </div>
          )}
        </div>
      </main>

      {/* Task Modal */}
      <TaskModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleCreateOrUpdateTask}
        task={selectedTask}
      />
    </div>
  );
};
