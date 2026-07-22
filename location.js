document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('form[action="/consult"]');
  const locationField = document.getElementById('address');
  const status = document.getElementById('location_setup_status');
  if (!form || !locationField) return;

  let locationRequested = false;
  form.addEventListener('submit', event => {
    if (locationRequested || !navigator.geolocation) return;
    event.preventDefault();
    locationRequested = true;
    if (status) status.textContent = 'Requesting your current location…';

    navigator.geolocation.getCurrentPosition(
      position => {
        locationField.value = `geo:${position.coords.latitude},${position.coords.longitude}`;
        if (status) status.textContent = 'Location identified. Starting consultation…';
        form.submit();
      },
      () => {
        locationField.value = 'region-only';
        if (status) status.textContent = 'Location was unavailable. Regional facilities will still be shown.';
        form.submit();
      },
      { enableHighAccuracy: true, timeout: 10000, maximumAge: 300000 }
    );
  });
});
