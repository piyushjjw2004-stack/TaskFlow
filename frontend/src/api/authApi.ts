import api from './client';
import { AuthResponse, User } from '../types';

export const authApi = {
  register: async (email: string, full_name: string, password: string): Promise<User> => {
    const response = await api.post<User>('/auth/register', { email, full_name, password });
    return response.data;
  },

  login: async (email: string, password: string): Promise<AuthResponse> => {
    const response = await api.post<AuthResponse>('/auth/login', { email, password });
    return response.data;
  },

  getMe: async (): Promise<User> => {
    const response = await api.get<User>('/auth/me');
    return response.data;
  },
};
