"""
Detects and checks links found in email text.

Tries the abuse.ch URLhaus API first (if ENABLE_URLHAUS_API and the
request succeeds within the timeout); always falls back to local
heuristics so this never blocks or crashes a request when offline.
"""
import logging
import re
from typing import List, Tuple
from urllib.parse import urlparse

import requests

from app.config.settings import settings

logger = logging.getLogger("cybermail.urlhaus")

_URL_RE = re.compile(r"https?://[^\s<>\"']+")

SHORTENER_DOMAINS = {
    "bit.ly", "tinyurl.com", "t.co", "goo.gl", "ow.ly", "is.gd", "buff.ly",
}
SUSPICIOUS_TLDS = {".tk", ".ml", ".ga", ".cf", ".gq", ".xyz", ".top", ".zip"}

_URLHAUS_ENDPOINT = "https://urlhaus-api.abuse.ch/v1/url/"


def extract_urls(text: str) -> List[str]:
    return _URL_RE.findall(text or "")


def _is_ip_host(host: str) -> bool:
    return bool(re.fullmatch(r"(\d{1,3}\.){3}\d{1,3}", host or ""))


def _heuristic_suspicious(url: str) -> bool:
    try:
        parsed = urlparse(url)
    except ValueError:
        return True

    host = (parsed.hostname or "").lower()
    if not host:
        return True
    if _is_ip_host(host):
        return True
    if host in SHORTENER_DOMAINS:
        return True
    if any(host.endswith(tld) for tld in SUSPICIOUS_TLDS):
        return True
    if "@" in url:
        return True
    if host.count("-") >= 3:
        return True
    return False


def _check_urlhaus(url: str) -> bool:
    """Returns True if URLhaus has this URL flagged as malicious."""
    response = requests.post(
        _URLHAUS_ENDPOINT,
        data={"url": url},
        timeout=settings.REQUEST_TIMEOUT_SECONDS,
    )
    response.raise_for_status()
    data = response.json()
    return data.get("query_status") == "ok"


def scan_urls(text: str) -> Tuple[bool, List[str]]:
    """Returns (maliciousLinksFound, flagged_urls)."""
    urls = extract_urls(text)
    if not urls:
        return False, []

    flagged = []
    for url in urls:
        is_malicious = False

        if settings.ENABLE_URLHAUS_API:
            try:
                is_malicious = _check_urlhaus(url)
            except (requests.RequestException, ValueError) as exc:
                logger.info("URLhaus lookup failed for %s, using heuristics: %s", url, exc)

        if not is_malicious:
            is_malicious = _heuristic_suspicious(url)

        if is_malicious:
            flagged.append(url)

    return len(flagged) > 0, flagged
