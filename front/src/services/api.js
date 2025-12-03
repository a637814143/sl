import axios from 'axios'

let authToken = ''

const resolveBaseURL = () => {
  if (import.meta.env.VITE_API_BASE_URL) {
    return import.meta.env.VITE_API_BASE_URL
  }
  if (typeof window !== 'undefined') {
    return `${window.location.protocol}//${window.location.hostname}:8080/api`
  }
  return 'http://localhost:8080/api'
}

const client = axios.create({
  baseURL: resolveBaseURL(),
  timeout: 8000
})

client.interceptors.request.use((config) => {
  if (authToken) {
    config.headers = config.headers || {}
    config.headers.Authorization = `Bearer ${authToken}`
  }
  return config
})

export const setAuthToken = (token) => {
  authToken = token || ''
}

const adminDrinksPath = '/admin/drinks'

export const listDrinks = () => client.get(adminDrinksPath).then((res) => res.data)
export const createDrink = (payload) => client.post(adminDrinksPath, payload).then((res) => res.data)
export const updateDrink = (id, payload) => client.put(`${adminDrinksPath}/${id}`, payload).then((res) => res.data)
export const deleteDrink = (id) => client.delete(`${adminDrinksPath}/${id}`).then((res) => res.data)

export const fetchAdminOverview = () => client.get('/admin/dashboard').then((res) => res.data)

export const fetchMerchantOrders = (merchantId) =>
  client.get('/merchant/orders', { params: { merchantId } }).then((res) => res.data)

export const updateMerchantOrderStatus = (merchantId, orderId, status) =>
  client
    .patch(`/merchant/orders/${orderId}/status`, { status }, { params: { merchantId } })
    .then((res) => res.data)

export const fetchCatalogDrinks = (params = {}) =>
  client.get('/drinks', { params }).then((res) => res.data)
export const fetchMerchants = () => client.get('/merchants').then((res) => res.data)
export const createOrder = (payload) => client.post('/orders', payload).then((res) => res.data)
export const fetchOrderOverview = () => client.get('/orders/overview').then((res) => res.data)
export const createAlipayPayment = (payload) => client.post('/payments/alipay', payload).then((res) => res.data)

export const register = (payload) => client.post('/auth/register', payload).then((res) => res.data)
export const login = (payload) => client.post('/auth/login', payload).then((res) => res.data)

export const fetchUserProfile = (userId) => client.get(`/users/${userId}`).then((res) => res.data)
export const updateUserProfile = (userId, payload) =>
  client.put(`/users/${userId}/profile`, payload).then((res) => res.data)
export const uploadAvatar = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  return client.post('/uploads/avatar', formData).then((res) => res.data)
}

export const uploadAsset = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  return client.post('/uploads/assets', formData).then((res) => res.data)
}

export const createMerchantProduct = (payload) =>
  client.post('/merchant/products', payload).then((res) => res.data)

export const updateMerchantProduct = (id, payload) =>
  client.put(`/merchant/products/${id}`, payload).then((res) => res.data)

export const deleteMerchantProduct = (id, merchantId) =>
  client.delete(`/merchant/products/${id}`, { params: { merchantId } })
