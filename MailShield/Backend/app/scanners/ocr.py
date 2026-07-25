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

        # On Windows, pytesseract often can't find the tesseract engine
        # even when it's installed, because the installer doesn't
        # reliably add it to PATH. Set TESSERACT_CMD to the full path of
        # tesseract.exe (e.g. C:\Program Files\Tesseract-OCR\tesseract.exe)
        # to point pytesseract at it directly.
        if settings.TESSERACT_CMD:
            pytesseract.pytesseract.tesseract_cmd = settings.TESSERACT_CMD

        image = Image.open(io.BytesIO(image_bytes))
        text = pytesseract.image_to_string(image) or ""
        logger.info("OCR extracted %d characters from image", len(text.strip()))
        return text
    except Exception as exc:  # pragma: no cover - optional integration
        logger.warning("OCR unavailable, skipping text extraction: %s", exc)
        return ""