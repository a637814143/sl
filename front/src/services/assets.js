import { getApiOrigin } from './api'

const ensureOrigin = () => {
  const origin = getApiOrigin()
  if (origin) return origin
  if (typeof window !== 'undefined' && window.location) {
    return `${window.location.protocol}//${window.location.host}`
  }
  return ''
}

const isAbsoluteUrl = (value = '') => /^https?:\/\//i.test(value)

const normalizeUploadsPath = (value) => {
  if (!value) return ''
  const trimmed = value.trim()
  if (!trimmed) return ''
  if (isAbsoluteUrl(trimmed)) {
    try {
      const parsed = new URL(trimmed)
      if (parsed.pathname.startsWith('/uploads/')) {
        return parsed.pathname
      }
      return trimmed
    } catch {
      return trimmed
    }
  }
  if (trimmed.startsWith('/uploads/')) {
    return trimmed
  }
  return trimmed
}

export const sanitizeAssetPath = (value) => normalizeUploadsPath(value)

export const buildAssetUrl = (value) => {
  if (!value) return ''
  const trimmed = value.trim()
  if (!trimmed) return ''
  if (isAbsoluteUrl(trimmed)) {
    return trimmed
  }
  if (trimmed.startsWith('/')) {
    const origin = ensureOrigin()
    return origin ? `${origin}${trimmed}` : trimmed
  }
  return trimmed
}
