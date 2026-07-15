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
    navigator.serviceWorker.register('/sw.js');
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
