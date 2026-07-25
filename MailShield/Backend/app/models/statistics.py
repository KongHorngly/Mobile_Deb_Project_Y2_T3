"""
Not wired to any route yet — the Profile screen currently reads its
counters straight off UserModel via Firestore (see
frontend/lib/services/firestore_service.dart: incrementScanCounts).
"""
from pydantic import BaseModel


class UserStatistics(BaseModel):
    totalScan: int = 0
    safeCount: int = 0
    suspiciousCount: int = 0
