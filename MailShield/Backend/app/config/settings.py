"""
Central config for the CyberMail API.

Nothing here requires external services to be installed — ClamAV, OCR and
the URLhaus lookup are all optional and controlled by the ENABLE_* flags
below. If the underlying tool isn't installed/reachable, the corresponding
scanner degrades gracefully instead of crashing the request.
"""
import os


class Settings:
    APP_NAME = "CyberMail API"
    API_PREFIX = "/v1"

    # Flutter web (flutter run -d chrome) uses a random localhost port,
    # and the emulator/device may hit this from a different origin —
    # keep this permissive for local dev. Lock down before shipping.
    CORS_ORIGINS = ["*"]

    HOST = os.getenv("HOST", "0.0.0.0")
    PORT = int(os.getenv("PORT", "8000"))

    # Optional integrations — safe to leave off, everything still works
    # with the built-in heuristics.
    ENABLE_URLHAUS_API = os.getenv("ENABLE_URLHAUS_API", "true").lower() == "true"
    ENABLE_CLAMAV = os.getenv("ENABLE_CLAMAV", "false").lower() == "true"
    ENABLE_OCR = os.getenv("ENABLE_OCR", "true").lower() == "true"

    # Full path to tesseract.exe on Windows if it's not on PATH, e.g.
    # C:\Program Files\Tesseract-OCR\tesseract.exe. Leave unset on
    # macOS/Linux where `tesseract` is normally already on PATH.
    TESSERACT_CMD = os.getenv("TESSERACT_CMD", "")

    CLAMD_HOST = os.getenv("CLAMD_HOST", "localhost")
    CLAMD_PORT = int(os.getenv("CLAMD_PORT", "3310"))

    UPLOAD_DIR = os.getenv("UPLOAD_DIR", "app/uploads")
    MAX_UPLOAD_SIZE_MB = int(os.getenv("MAX_UPLOAD_SIZE_MB", "15"))

    REQUEST_TIMEOUT_SECONDS = 6


settings = Settings()