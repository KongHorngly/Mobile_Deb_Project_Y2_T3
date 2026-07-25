from typing import List, Optional

from app.models.analysis import AnalysisResult
from app.scanners import mail_parser, urlhaus
from app.scanners.clamav import ClamAvResult


def _build_recommendations(
    domain_status: str,
    suspicious_words_found: bool,
    matched_keywords: List[str],
    malicious_links_found: bool,
    flagged_urls: List[str],
    clam: Optional[ClamAvResult],
) -> List[str]:
    if (
        domain_status == "Trusted"
        and not suspicious_words_found
        and not malicious_links_found
        and (clam is None or not clam.infected)
    ):
        return [
            "This email appears to be safe.",
            "Still verify unexpected requests directly with the sender.",
        ]

    recs: List[str] = []
    if domain_status == "Suspicious":
        recs.append("The sender's domain looks unfamiliar or spoofed — verify it independently.")
    if suspicious_words_found:
        top = ", ".join(f'"{kw}"' for kw in matched_keywords[:3])
        recs.append(f"Contains common phishing language ({top}).")
    if malicious_links_found:
        recs.append(f"Do NOT click the link(s) found: {', '.join(flagged_urls[:3])}")
    if clam is not None and clam.infected:
        recs.append(f"Attachment flagged by ClamAV ({clam.signature or 'malware detected'}).")

    recs.append("Do not reply, click links, or open attachments.")
    recs.append("Report the sender and delete the email.")
    return recs


def evaluate_email(
    sender_email: str,
    subject: str,
    body: str,
    has_attachment: bool,
    clam: Optional[ClamAvResult] = None,
) -> AnalysisResult:
    domain_status, suspicious_words_found, matched_keywords = mail_parser.analyze_email_text(
        sender_email, subject, body
    )
    malicious_links_found, flagged_urls = urlhaus.scan_urls(body)

    attachment_infected = bool(has_attachment and clam is not None and clam.infected)

    is_safe = not (
        domain_status == "Suspicious"
        or suspicious_words_found
        or malicious_links_found
        or attachment_infected
    )

    return AnalysisResult(
        isSafe=is_safe,
        sender=sender_email,
        subject=subject,
        fileOrImageName="(pasted content)",
        senderDomainStatus=domain_status,
        suspiciousWordsFound=suspicious_words_found,
        maliciousLinksFound=malicious_links_found,
        recommendations=_build_recommendations(
            domain_status,
            suspicious_words_found,
            matched_keywords,
            malicious_links_found,
            flagged_urls,
            clam,
        ),
    )


def evaluate_image(
    ocr_text: str,
    filename: str,
    clam: Optional[ClamAvResult] = None,
) -> AnalysisResult:
    domain_status, suspicious_words_found, matched_keywords = mail_parser.analyze_email_text(
        "", "", ocr_text
    )
    malicious_links_found, flagged_urls = urlhaus.scan_urls(ocr_text)

    # No sender address to judge for an image, so don't let an empty
    # domain drag the verdict down — only count it if OCR clearly found
    # an email address to check.
    domain_looks_relevant = "@" in ocr_text
    if not domain_looks_relevant:
        domain_status = "Trusted"

    image_infected = bool(clam is not None and clam.infected)

    is_safe = not (
        (domain_looks_relevant and domain_status == "Suspicious")
        or suspicious_words_found
        or malicious_links_found
        or image_infected
    )

    return AnalysisResult(
        isSafe=is_safe,
        sender=mail_parser.extract_domain(ocr_text) or "unknown",
        subject="(from screenshot)",
        fileOrImageName=filename,
        senderDomainStatus=domain_status,
        suspiciousWordsFound=suspicious_words_found,
        maliciousLinksFound=malicious_links_found,
        recommendations=_build_recommendations(
            domain_status if domain_looks_relevant else "Trusted",
            suspicious_words_found,
            matched_keywords,
            malicious_links_found,
            flagged_urls,
            clam,
        ),
    )
