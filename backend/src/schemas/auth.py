"""
Authentication schemas for request/response validation
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from ..models import UserRole


class LoginRequest(BaseModel):
    """Login request schema"""
    username: str = Field(..., min_length=3)
    password: str = Field(..., min_length=6)


class TokenResponse(BaseModel):
    """Token response schema"""
    token: str
    refresh_token: str
    token_type: str = "bearer"


class UserResponse(BaseModel):
    """User response schema"""
    id: str
    nama: str
    role: UserRole
    created_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True


class EmployeeResponse(UserResponse):
    """Employee response schema"""
    nip: str
    region: str
    created_tickets_count: Optional[int] = 0


class TechnicianResponse(UserResponse):
    """Technician response schema"""
    wilayah: Optional[str] = None
    categories: list[str]
    sub_categories: list[str]
    is_available: bool = True
    assigned_tickets_count: Optional[int] = 0
    completed_tickets_count: Optional[int] = 0


class AdminResponse(UserResponse):
    """Admin response schema"""
    nomor_wa: str
    permissions: Optional[list[str]] = None


class LoginResponse(BaseModel):
    """Complete login response"""
    token: str
    refresh_token: str
    user: UserResponse


class RefreshTokenRequest(BaseModel):
    """Refresh token request"""
    refresh_token: str