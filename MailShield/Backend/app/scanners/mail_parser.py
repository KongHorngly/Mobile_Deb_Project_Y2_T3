"""
Pure-Python heuristics for email text — no external services required.
"""
import difflib
import re
from typing import List, Tuple

_EMAIL_DOMAIN_RE = re.compile(r"@([\w.\-]+\.[A-Za-z]{2,})")

# Common phishing/social-engineering phrasing. Not exhaustive — this is a
# fast first-pass signal, not a substitute for a trained classifier.
SUSPICIOUS_KEYWORDS = [
    "urgent action required",
    "verify your account",
    "confirm your identity",
    "your account has been suspended",
    "unusual activity detected",
    "click here immediately",
    "click the link below",
    "act now",
    "limited time offer",
    "wire transfer",
    "gift card",
    "you have won",
    "congratulations you won",
    "claim your prize",
    "update your payment",
    "password will expire",
    "reset your password immediately",
    "social security number",
    "bank account details",
    "invoice attached",
    "final notice",
    "failure to comply",
    "unauthorized login attempt",
]

# Large, legitimate providers/orgs whose domains we treat as trusted by
# default. Anything else falls back to the typosquat check below.
TRUSTED_DOMAINS = {
    "gmail.com", "outlook.com", "hotmail.com", "yahoo.com", "icloud.com",
    "protonmail.com", "live.com", "aol.com", "microsoft.com", "google.com",
    "apple.com", "amazon.com", "paypal.com", "github.com",
}

# Brands most commonly impersonated in phishing — flags lookalike domains
# like "paypa1.com" or "micros0ft-support.com".
IMPERSONATION_TARGETS = [
    "paypal", "amazon", "microsoft", "apple", "google", "netflix",
    "facebook", "instagram", "bankofamerica", "chase", "wellsfargo",
    "dhl", "fedex", "irs",
]


def extract_domain(email: str) -> str:
    match = _EMAIL_DOMAIN_RE.search(email or "")
    return match.group(1).lower() if match else ""


def find_suspicious_keywords(text: str) -> List[str]:
    lowered = (text or "").lower()
    return [kw for kw in SUSPICIOUS_KEYWORDS if kw in lowered]


SUSPICIOUS_DOMAIN_TLDS = {".tk", ".ml", ".ga", ".cf", ".gq", ".xyz", ".top", ".zip"}


def _looks_like_typosquat(domain_root: str) -> bool:
    segments = [s for s in domain_root.split("-") if s]
    candidates = [domain_root] + segments
    for candidate in candidates:
        for brand in IMPERSONATION_TARGETS:
            ratio = difflib.SequenceMatcher(None, candidate, brand).ratio()
            if brand != candidate and ratio >= 0.7:
                return True
    return False


def classify_sender_domain(email: str) -> str:
    """Returns 'Trusted' or 'Suspicious'."""
    domain = extract_domain(email)
    if not domain:
        return "Suspicious"
    if domain in TRUSTED_DOMAINS:
        return "Trusted"

    if any(domain.endswith(tld) for tld in SUSPICIOUS_DOMAIN_TLDS):
        return "Suspicious"

    root = domain.split(".")[0]
    if _looks_like_typosquat(root):
        return "Suspicious"

    # Excessive hyphens/digits or very long subdomains are common in
    # throwaway phishing infrastructure.
    if domain.count("-") >= 2 or sum(c.isdigit() for c in domain) >= 2:
        return "Suspicious"

    return "Trusted"


def analyze_email_text(sender_email: str, subject: str, body: str) -> Tuple[str, bool, List[str]]:
    """Returns (senderDomainStatus, suspiciousWordsFound, matched_keywords)."""
    domain_status = classify_sender_domain(sender_email)
    matches = find_suspicious_keywords(f"{subject} {body}")
    return domain_status, len(matches) > 0, matches
