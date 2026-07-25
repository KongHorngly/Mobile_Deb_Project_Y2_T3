"""
These field names are intentionally camelCase (not snake_case) — they
must match frontend/lib/models/email_model.dart's toJson() and
frontend/lib/models/analysis_result_model.dart's fromJson() exactly,
since ApiService decodes the raw JSON with no key translation.
"""
from typing import List, Optional

from pydantic import BaseModel, Field


class EmailAnalysisRequest(BaseModel):
    senderEmail: str
    subject: str
    body: str
    fileName: Optional[str] = None
    hasAttachment: bool = False
    containsLink: bool = False


class AnalysisResult(BaseModel):
    isSafe: bool
    sender: str
    subject: str
    fileOrImageName: str
    senderDomainStatus: str  # "Trusted" | "Suspicious"
    suspiciousWordsFound: bool
    maliciousLinksFound: bool
    recommendations: List[str] = Field(default_factory=list)
