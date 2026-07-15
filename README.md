# Disease Diagnosis Web App

This project wraps the existing Prolog knowledge base in a small SWI-Prolog web app.

## Requirements

- [SWI-Prolog](https://www.swi-prolog.org/download/stable) (64-bit recommended)

After installing, reopen PowerShell so the `swipl` command is available.
If Windows has not added it to `PATH`, use the full executable path shown below.

## Run

From this folder:

```powershell
swipl -s web_app.pl
```

Windows fallback:

```powershell
& 'C:\Program Files\swipl\bin\swipl.exe' -s web_app.pl
```

Then open <http://localhost:8080/>. Stop the server with `Ctrl+C`.

To use another port:

```powershell
swipl -s web_app.pl -- 3000
```

The original terminal version remains available:

```powershell
swipl -s diseases_diagnosis.pl -g main
```

## Important

This is an educational expert system with a small fixed knowledge base. It must not be presented as a substitute for professional medical diagnosis or emergency care.

## Install on a phone

The project is configured as a Progressive Web App (PWA). Phone installation requires an HTTPS deployment; a phone cannot install the app from the computer's `localhost` address.

After deploying to HTTPS:

- Android/Chrome: open the site and tap **Install app**, or use **Add to Home screen** from the browser menu.
- iPhone/Safari: open the site, tap **Share**, then **Add to Home Screen**.

The service worker caches the application shell and images. Diagnosis requests still require the Prolog server because they are generated dynamically.
