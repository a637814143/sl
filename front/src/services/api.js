import axios from 'axios'

const client = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api',
  timeout: 8000
})

export const listDrinks = () => client.get('/drinks').then((res) => res.data)
export const createDrink = (payload) => client.post('/drinks', payload).then((res) => res.data)
export const updateDrink = (id, payload) => client.put(`/drinks/${id}`, payload).then((res) => res.data)
export const deleteDrink = (id) => client.delete(`/drinks/${id}`).then((res) => res.data)

export const register = (payload) => client.post('/auth/register', payload).then((res) => res.data)
export const login = (payload) => client.post('/auth/login', payload).then((res) => res.data)
