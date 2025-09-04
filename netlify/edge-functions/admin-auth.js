export default async (request, context) => {
  const user = Deno.env.get('ADMIN_USER') || 'admin'
  const pass = Deno.env.get('ADMIN_PASS') || 'secret'

  const unauthorized = new Response('Unauthorized', {
    status: 401,
    headers: { 'WWW-Authenticate': 'Basic realm="Admin"' }
  })

  const auth = request.headers.get('authorization') || ''
  if (!auth.startsWith('Basic ')) {
    return unauthorized
  }

  try {
    const decoded = atob(auth.slice(6)) // base64("user:pass")
    const [u, p] = decoded.split(':')
    if (u === user && p === pass) {
      return context.next()
    }
  } catch (_e) {
    // fall through to unauthorized
  }

  return unauthorized
}

export const config = {
  path: ['/admin', '/admin/*']
}

