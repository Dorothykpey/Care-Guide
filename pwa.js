let deferredInstallPrompt;

window.addEventListener('beforeinstallprompt', event => {
  event.preventDefault();
  deferredInstallPrompt = event;
  const button = document.getElementById('install_app');
  if (button) button.hidden = false;
});

window.addEventListener('appinstalled', () => {
  deferredInstallPrompt = undefined;
  const button = document.getElementById('install_app');
  if (button) button.hidden = true;
});

document.addEventListener('DOMContentLoaded', () => {
  if ('serviceWorker' in navigator) {
    let refreshing = false;
    navigator.serviceWorker.addEventListener('controllerchange', () => {
      if (refreshing) return;
      refreshing = true;
      window.location.reload();
    });

    navigator.serviceWorker.register('/sw.js?v=16', {updateViaCache: 'none'})
      .then(registration => registration.update())
      .catch(() => {
        // The web app still works online if service-worker registration fails.
      });
  }

  const button = document.getElementById('install_app');
  if (!button) return;
  button.addEventListener('click', async () => {
    if (!deferredInstallPrompt) return;
    deferredInstallPrompt.prompt();
    await deferredInstallPrompt.userChoice;
    deferredInstallPrompt = undefined;
    button.hidden = true;
  });
});
