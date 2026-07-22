const CACHE = 'careguide-v16';
const CORE = [
  '/',
  '/setup',
  '/offline.html',
  '/style.css',
  '/theme.css',
  '/background-carousel.js',
  '/pwa.js?v=16',
  '/location.js',
  '/voice.js?v=16',
  '/voice.css',
  '/mobile.css?v=16',
  '/ollama.js?v=16',
  '/manifest.webmanifest',
  '/app-icon.svg',
  '/app-icon-192.png',
  '/app-icon-512.png',
  '/hospital-background.png',
  '/hospital-background-2.png',
  '/hospital-background-3.png',
  '/hospital-background-4.jpg'
];

self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(CORE)));
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(key => key !== CACHE).map(key => caches.delete(key))
    ))
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') return;
  event.respondWith(
    fetch(event.request)
      .then(response => {
        const copy = response.clone();
        caches.open(CACHE).then(cache => cache.put(event.request, copy));
        return response;
      })
      .catch(() => caches.match(event.request).then(response => {
        if (response) return response;
        if (event.request.mode === 'navigate') return caches.match('/offline.html');
        return new Response('Offline', {status: 503, headers: {'Content-Type': 'text/plain'}});
      }))
  );
});
