// Upload an image (base64) to the GitHub repo under assets/...
// Expects JSON body: { path: "assets/field/2025/file.jpg", content_base64: "...", message?: "..." }
// Env required: GITHUB_TOKEN; optional: GITHUB_REPO (owner/repo), GITHUB_BRANCH, COMMITTER_NAME, COMMITTER_EMAIL

const { Buffer } = require('buffer')

exports.handler = async (event) => {
  try {
    if (event.httpMethod !== 'POST') {
      return { statusCode: 405, body: 'Method Not Allowed' }
    }

    // Optional simple shared secret; if set, require header match
    const adminSecret = process.env.ADMIN_SECRET
    if (adminSecret) {
      const hdr = event.headers['x-admin-secret'] || event.headers['X-Admin-Secret']
      if (hdr !== adminSecret) {
        return { statusCode: 401, body: 'Unauthorized' }
      }
    }

    const token = process.env.GITHUB_TOKEN
    if (!token) {
      return { statusCode: 500, body: 'Server not configured: missing GITHUB_TOKEN' }
    }

    const repo = process.env.GITHUB_REPO || 'Chantal13/Spectrum-Syntax'
    const branch = process.env.GITHUB_BRANCH || 'main'
    const committer = {
      name: process.env.COMMITTER_NAME || 'Site Bot',
      email: process.env.COMMITTER_EMAIL || 'bot@users.noreply.github.com'
    }

    let body
    try { body = JSON.parse(event.body || '{}') } catch { return { statusCode: 400, body: 'Invalid JSON' } }
    const relPath = String(body.path || '').replace(/^\/+/, '')
    const contentBase64 = String(body.content_base64 || '')
    const message = String(body.message || `Upload ${relPath}`)

    if (!relPath || !contentBase64) {
      return { statusCode: 400, body: 'Missing path or content_base64' }
    }
    if (!relPath.startsWith('assets/')) {
      return { statusCode: 400, body: 'Path must start with assets/' }
    }

    // Validate base64
    try { Buffer.from(contentBase64, 'base64') } catch { return { statusCode: 400, body: 'Invalid base64' } }

    const apiBase = `https://api.github.com/repos/${repo}/contents/` + encodeURI(relPath)
    const headers = {
      'Authorization': `token ${token}`,
      'Content-Type': 'application/json',
      'Accept': 'application/vnd.github+json',
      'User-Agent': 'netlify-fn-upload-asset'
    }

    async function putWithSha(sha) {
      const payload = {
        message,
        content: contentBase64,
        branch,
        committer,
      }
      if (sha) payload.sha = sha
      const res = await fetch(apiBase, { method: 'PUT', headers, body: JSON.stringify(payload) })
      const text = await res.text()
      let data
      try { data = JSON.parse(text) } catch { data = { raw: text } }
      if (!res.ok) {
        return { ok: false, statusCode: res.status, body: typeof data === 'string' ? data : JSON.stringify(data) }
      }
      return { ok: true, data }
    }

    // Try create; if file exists, fetch sha then update
    let result = await putWithSha(undefined)
    if (!result.ok && /exists/i.test(result.body || '')) {
      const infoRes = await fetch(apiBase + `?ref=${encodeURIComponent(branch)}`, { headers })
      if (!infoRes.ok) {
        return { statusCode: infoRes.status, body: await infoRes.text() }
      }
      const info = await infoRes.json()
      result = await putWithSha(info.sha)
    }

    if (!result.ok) {
      return { statusCode: result.statusCode || 500, body: result.body || 'Upload failed' }
    }

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ ok: true, path: relPath })
    }
  } catch (e) {
    return { statusCode: 500, body: String(e && e.message || e) }
  }
}

