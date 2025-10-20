"""
Ticket schemas for request/response validation
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from ..models import TicketStatus, TicketCategory


class CreateTicketRequest(BaseModel):
    """Request schema for creating a ticket"""
    deskripsi: str = Field(..., min_length=10, max_length=500)
    kategori: TicketCategory
    sub_kategori: Optional[str] = None
    technician_id: str


class CompleteTicketRequest(BaseModel):
    """Request schema for completing a ticket"""
    resolution_notes: str = Field(..., min_length=10, max_length=1000)


class TicketResponse(BaseModel):
    """Ticket response schema"""
    id: str
    employee_id: str
    employee_nama: Optional[str] = None
    employee_nip: Optional[str] = None
    technician_id: Optional[str] = None
    technician_nama: Optional[str] = None
    deskripsi: str
    kategori: TicketCategory
    sub_kategori: Optional[str] = None
    status: TicketStatus
    resolution_notes: Optional[str] = None
    comment_count: Optional[int] = 0
    unread_comments: Optional[int] = 0
    created_at: datetime
    accepted_at: Optional[datetime] = None
    completed_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True


class TicketListResponse(BaseModel):
    """Paginated ticket list response"""
    tickets: list[TicketResponse]
    total: int
    page: int
    limit: int
    
    @property
    def has_more(self) -> bool:
        """Check if there are more pages"""
        return (self.page * self.limit) < self.total