import axios from 'axios'

const client = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api',
  timeout: 8000
})

export const fetchDrinks = () => client.get('/drinks').then((res) => res.data)
export const fetchMerchants = () => client.get('/merchants').then((res) => res.data)
export const fetchOverview = () => client.get('/orders/overview').then((res) => res.data)
export const fetchProfilesByRole = (role) =>
  client.get(`/users/roles/${role}`).then((res) => res.data)
export const createOrder = (payload) => client.post('/orders', payload).then((res) => res.data)
