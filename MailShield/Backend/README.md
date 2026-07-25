# CyberMail Backend

FastAPI service that powers the Flutter app's Email/Image Analysis screens.

## Run it

```bash
cd Backend
pip install -r app/requirements.txt
uvicorn app.main:app --reload
```

Server starts at http://localhost:8000 — this matches the Flutter app's
`ApiService` default (`frontend/lib/services/api_service.dart`), so no
extra config is needed for local dev on web/desktop.

If you're running the Android emulator instead of web/desktop, change
`ApiService.baseUrl` to `http://10.0.2.2:8000` (the emulator's alias for
your host machine).

## What's actually wired up

- `POST /v1/analyze/email` — pasted email text (sender, subject, body).
  Runs sender-domain + typosquat heuristics, phishing-keyword matching,
  and link extraction/checking (URLhaus API with local heuristic fallback).
- `POST /v1/analyze/image` — screenshot upload. Runs OCR (if `pytesseract`
  + the `tesseract-ocr` binary are installed) then the same text checks.
- `GET /health` — simple liveness check.

Both response shapes match `AnalysisResultModel` in the Flutter app
exactly, so the "Analyze" button on both screens works out of the box.

## What's scaffolded but not wired up

`routers/history_service.py`, `routers/pdf_service.py`, and
`config/firebase.py` exist (matching your original folder structure) but
aren't included in `main.py` yet — today the Flutter app talks to
Firebase Auth/Firestore directly for login, register, and history, and
the Result screen has no PDF export button. They're there as a starting
point if you want to move that logic server-side later.

## Optional integrations (off by default, safe to ignore)

Set these as environment variables before starting the server:

- `ENABLE_CLAMAV=true` — scans attachments via a running `clamd` daemon.
- `ENABLE_OCR=false` — turn off screenshot text extraction.
- `ENABLE_URLHAUS_API=false` — skip the live abuse.ch lookup, use only
  local link heuristics (useful if you're offline).

None of these need to be installed for the app to run — every scanner
degrades gracefully (skips itself and logs a warning) if its dependency
isn't available.
