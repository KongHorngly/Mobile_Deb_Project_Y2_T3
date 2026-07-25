"""
Not wired to any route yet — the Flutter app reads/writes scan history
directly in Firestore (frontend/lib/services/firestore_service.dart and
providers/history_provider.dart). Kept here as the shape you'd use if
history ever moves behind this API instead.
"""
from typing import List, Optional

from pydantic import BaseModel


class HistoryEntry(BaseModel):
    id: str
    title: str
    verdictLabel: str
    isSafe: bool
    scannedAt: str
    sender: Optional[str] = None
    subject: Optional[str] = None
    fileOrImageName: Optional[str] = None
    senderDomainStatus: Optional[str] = None
    suspiciousWordsFound: Optional[bool] = None
    maliciousLinksFound: Optional[bool] = None
    recommendations: Optional[List[str]] = None
