"""
Comment schemas for request/response validation
"""
from pydantic import BaseModel, Field
from datetime import datetime
from ..models import UserRole


class AddCommentRequest(BaseModel):
    """Request schema for adding a comment"""
    text: str = Field(..., min_length=3, max_length=1000)


class CommentResponse(BaseModel):
    """Comment response schema"""
    id: str
    ticket_id: str
    user_id: str
    user_nama: str
    user_type: UserRole
    text: str
    is_read: bool = False
    created_at: datetime
    
    class Config:
        from_attributes = True


class CommentListResponse(BaseModel):
    """Comment list response"""
    comments: list[CommentResponse]
    total: int