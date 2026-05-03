import { api } from './api'

export type LoginResponse = {
    token?: string
    accessToken?: string
    access_token?: string
    username?: string
    roles?: string[]
}

function extractRolesFromJwt(token: string): string[] {
    try {
        const payload = JSON.parse(atob(token.split('.')[1] || ''))

        const rawRoles =
            payload?.roles ??
            payload?.authorities ??
            payload?.scope ??
            []

        if (Array.isArray(rawRoles)) {
            return rawRoles.map(String)
        }

        if (typeof rawRoles === 'string') {
            return rawRoles.split(' ').filter(Boolean)
        }

        return []
    } catch {
        return []
    }
}

export async function login(username: string, password: string) {
    sessionStorage.removeItem('token')
    sessionStorage.removeItem('accessToken')
    sessionStorage.removeItem('jwt')

    const { data } = await api.post<LoginResponse>('/auth/login', {
        username,
        password,
    })

    const token =
        data.token ||
        data.accessToken ||
        data.access_token ||
        ''

    const roles =
        data.roles && data.roles.length > 0
            ? data.roles
            : token
                ? extractRolesFromJwt(token)
                : []

    if (token) {
        sessionStorage.setItem('token', token)
        sessionStorage.setItem('accessToken', token)
        api.defaults.headers.common.Authorization = `Bearer ${token}`
    }

    sessionStorage.setItem('roles', JSON.stringify(roles))
    sessionStorage.setItem('username', data.username ?? username)

    return { ...data, roles, token }
}

export function getToken() {
    return sessionStorage.getItem('token') || sessionStorage.getItem('accessToken')
}

export function getRoles(): string[] {
    try {
        return JSON.parse(sessionStorage.getItem('roles') || '[]')
    } catch {
        return []
    }
}

export function hasRole(role: string): boolean {
    const roles = getRoles()
    return roles.includes(role) || roles.includes(`ROLE_${role}`)
}

export function logout() {
    sessionStorage.removeItem('token')
    sessionStorage.removeItem('accessToken')
    sessionStorage.removeItem('jwt')
    sessionStorage.removeItem('roles')
    sessionStorage.removeItem('username')
    window.location.href = '/login'
}