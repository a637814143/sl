import axios from 'axios'

const client = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api',
  timeout: 8000
})

const adminDrinksPath = '/admin/drinks'

export const listDrinks = () => client.get(adminDrinksPath).then((res) => res.data)
export const createDrink = (payload) => client.post(adminDrinksPath, payload).then((res) => res.data)
export const updateDrink = (id, payload) => client.put(`${adminDrinksPath}/${id}`, payload).then((res) => res.data)
export const deleteDrink = (id) => client.delete(`${adminDrinksPath}/${id}`).then((res) => res.data)

export const register = (payload) => client.post('/auth/register', payload).then((res) => res.data)
export const login = (payload) => client.post('/auth/login', payload).then((res) => res.data)
