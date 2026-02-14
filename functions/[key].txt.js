// IndexNow key verification file
// Serves the key at /{INDEXNOW_KEY}.txt for search engine verification
// Key is stored as environment variable in Cloudflare Pages settings

export async function onRequest(context) {
  const key = context.env.INDEXNOW_KEY;
  const requestedKey = context.params.key;

  // Only serve if the requested filename matches our key
  if (key && requestedKey === key) {
    return new Response(key, {
      headers: {
        'Content-Type': 'text/plain',
        'Cache-Control': 'public, max-age=86400'
      }
    });
  }

  // Return 404 for any other .txt request
  return new Response('Not found', { status: 404 });
}
