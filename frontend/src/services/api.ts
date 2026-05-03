import axios from 'axios'

const API_BASE_URL =
    import.meta.env.PROD
        ? import.meta.env.VITE_API_BASE_URL || '/api'
        : '/api'

export const api = axios.create({
    baseURL: API_BASE_URL,
    headers: { 'Content-Type': 'application/json' },
})

api.interceptors.request.use((config) => {
    const url = config.url || ''

    // Không gắn token cho login
    if (url.includes('/auth/login')) {
        return config
    }

    const token =
        sessionStorage.getItem('token') ||
        sessionStorage.getItem('accessToken') ||
        sessionStorage.getItem('jwt')

    if (token) {
        config.headers = config.headers || {}
        config.headers.Authorization = `Bearer ${token}`
    }

    return config
})