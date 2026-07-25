"""
Not wired to any route yet — the Flutter app authenticates directly
against Firebase Auth (frontend/lib/services/auth_service.dart).
Kept here as the shape you'd use if login/register ever move server-side.
"""
from pydantic import BaseModel


class RegisterRequest(BaseModel):
    username: str
    email: str
    password: str


class LoginRequest(BaseModel):
    username: str
    password: str


class UserResponse(BaseModel):
    id: str
    username: str
    email: str
    totalScan: int = 0
    safeCount: int = 0
    suspiciousCount: int = 0
