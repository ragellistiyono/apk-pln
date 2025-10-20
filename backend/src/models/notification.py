"""
Notification database model
"""
from sqlalchemy import Column, String, DateTime, ForeignKey, Boolean, Enum, JSON
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from ..database import Base


class NotificationType(str, enum.Enum):
    """Notification type enumeration"""
    TICKET_ASSIGNED = "ticket_assigned"
    TICKET_ACCEPTED = "ticket_accepted"
    TICKET_COMPLETED = "ticket_completed"
    NEW_COMMENT = "new_comment"


class Notification(Base):
    """Notification model"""
    __tablename__ = "notifications"
    
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    ticket_id = Column(String, ForeignKey("tickets.id"), nullable=False, index=True)
    
    type = Column(Enum(NotificationType), nullable=False)
    message = Column(String, nullable=False)
    read_status = Column(Boolean, default=False, index=True)
    extra_data = Column(JSON, nullable=True)  # Renamed from 'metadata' (reserved word)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now(), index=True)
    
    # Relationships
    user = relationship("User")
    ticket = relationship("Ticket", back_populates="notifications")