import React, { useEffect, useState } from 'react';
import { Navbar } from '../components/Navbar';
import { TaskFilter } from '../components/TaskFilter';
import { TaskCard } from '../components/TaskCard';
import { TaskModal } from '../components/TaskModal';
import { tasksApi } from '../api/tasksApi';
import { Task, TaskStatus, TaskPriority } from '../types';
import { Plus, ListTodo } from 'lucide-react';

export const TasksPage: React.FC = () => {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [search, setSearch] = useState('');
  const [status, setStatus] = useState<TaskStatus | undefined>(undefined);
  const [priority, setPriority] = useState<TaskPriority | undefined>(undefined);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [selectedTask, setSelectedTask] = useState<Task | null>(null);

  const loadTasks = async () => {
    try {
      setIsLoading(true);
      const data = await tasksApi.getTasks({ status, priority, search });
      setTasks(data);
    } catch (err) {
      console.error('Failed to load tasks:', err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadTasks();
  }, [status, priority, search]);

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
    loadTasks();
  };

  const handleCompleteTask = async (id: number) => {
    await tasksApi.completeTask(id);
    loadTasks();
  };

  const handleDeleteTask = async (id: number) => {
    if (window.confirm('Are you sure you want to delete this task?')) {
      await tasksApi.deleteTask(id);
      loadTasks();
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

      <main className="flex-1 max-w-7xl w-full mx-auto px-6 py-8 space-y-6">
        {/* Top Header */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div className="flex items-center space-x-3">
            <div className="p-2.5 rounded-xl bg-slate-900 border border-slate-800 text-cyan-400">
              <ListTodo className="h-6 w-6" />
            </div>
            <div>
              <h2 className="text-2xl font-bold text-slate-100">Task Management</h2>
              <p className="text-xs text-slate-400">Filter, search, and manage microservice tasks</p>
            </div>
          </div>

          <button
            onClick={handleCreateClick}
            className="px-5 py-2.5 rounded-xl bg-gradient-to-r from-cyan-500 to-blue-600 hover:from-cyan-400 hover:to-blue-500 text-white font-semibold text-sm shadow-lg shadow-cyan-500/25 flex items-center justify-center gap-2 transition-all"
          >
            <Plus className="h-4 w-4" />
            <span>Create Task</span>
          </button>
        </div>

        {/* Filters */}
        <TaskFilter
          search={search}
          onSearchChange={setSearch}
          status={status}
          onStatusChange={setStatus}
          priority={priority}
          onPriorityChange={setPriority}
        />

        {/* Task Grid */}
        {isLoading ? (
          <div className="py-16 text-center text-slate-500">Querying Task API...</div>
        ) : tasks.length === 0 ? (
          <div className="glass-card rounded-2xl p-16 text-center border border-slate-800">
            <p className="text-slate-400 text-base font-medium">No tasks found matching your filters.</p>
            <button
              onClick={handleCreateClick}
              className="mt-4 px-4 py-2 rounded-xl bg-cyan-600 hover:bg-cyan-500 text-white text-xs font-semibold"
            >
              + Create New Task
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {tasks.map((task) => (
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
