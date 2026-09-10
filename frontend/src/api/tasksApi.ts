import api from './client';
import { Task, TaskStats, TaskStatus, TaskPriority } from '../types';

export interface TaskFilterParams {
  status?: TaskStatus;
  priority?: TaskPriority;
  search?: string;
}

export const tasksApi = {
  getTasks: async (params?: TaskFilterParams): Promise<Task[]> => {
    const response = await api.get<Task[]>('/tasks', { params });
    return response.data;
  },

  getTaskStats: async (): Promise<TaskStats> => {
    const response = await api.get<TaskStats>('/tasks/stats');
    return response.data;
  },

  createTask: async (task: { title: string; description?: string; status?: TaskStatus; priority?: TaskPriority }): Promise<Task> => {
    const response = await api.post<Task>('/tasks', task);
    return response.data;
  },

  updateTask: async (id: number, task: Partial<Task>): Promise<Task> => {
    const response = await api.put<Task>(`/tasks/${id}`, task);
    return response.data;
  },

  completeTask: async (id: number): Promise<Task> => {
    const response = await api.patch<Task>(`/tasks/${id}/complete`);
    return response.data;
  },

  deleteTask: async (id: number): Promise<void> => {
    await api.delete(`/tasks/${id}`);
  },
};
