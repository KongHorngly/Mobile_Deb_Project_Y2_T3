"""
Optional ClamAV integration for attachments/images.

Disabled by default (ENABLE_CLAMAV=false) since most dev machines don't
have a clamd daemon running. When enabled but unreachable, this logs a
warning and reports "not scanned" rather than failing the request —
an unscanned file should never silently look identical to a clean one.
"""
import logging
from typing import Optional

from app.config.settings import settings

logger = logging.getLogger("cybermail.clamav")


class ClamAvResult:
    def __init__(self, scanned: bool, infected: bool, signature: Optional[str] = None):
        self.scanned = scanned
        self.infected = infected
        self.signature = signature


def scan_bytes(data: bytes) -> ClamAvResult:
    if not settings.ENABLE_CLAMAV:
        return ClamAvResult(scanned=False, infected=False)

    try:
        import clamd  # pyclamd/clamd client, see requirements.txt

        client = clamd.ClamdNetworkSocket(host=settings.CLAMD_HOST, port=settings.CLAMD_PORT)
        result = client.instream(data)
        status, signature = result.get("stream", ("ERROR", None))
        if status == "FOUND":
            return ClamAvResult(scanned=True, infected=True, signature=signature)
        return ClamAvResult(scanned=True, infected=False)
    except Exception as exc:  # pragma: no cover - optional integration
        logger.warning("ClamAV scan unavailable, skipping: %s", exc)
        return ClamAvResult(scanned=False, infected=False)
