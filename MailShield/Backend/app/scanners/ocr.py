"""
Extracts text from a screenshot/image so the same keyword + link checks
used on pasted email text can run on it. Requires the `tesseract` binary
on PATH; if it's missing, returns empty text instead of raising, so
image analysis still completes (just without OCR-derived signals).
"""
import io
import logging

from app.config.settings import settings

logger = logging.getLogger("cybermail.ocr")


def extract_text(image_bytes: bytes) -> str:
    if not settings.ENABLE_OCR:
        return ""

    try:
        import pytesseract
        from PIL import Image

        image = Image.open(io.BytesIO(image_bytes))
        return pytesseract.image_to_string(image) or ""
    except Exception as exc:  # pragma: no cover - optional integration
        logger.warning("OCR unavailable, skipping text extraction: %s", exc)
        return ""
