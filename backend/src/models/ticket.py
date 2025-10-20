"""
Ticket database model
"""
from sqlalchemy import Column, String, DateTime, Enum, ForeignKey, Integer, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from ..database import Base


class TicketStatus(str, enum.Enum):
    """Ticket status enumeration"""
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"


class TicketCategory(str, enum.Enum):
    """Ticket category enumeration"""
    HARDWARE = "hardware"
    JARINGAN_KONEKSI = "jaringanKoneksi"
    ZOOM = "zoom"
    AKUN = "akun"
    APLIKASI = "aplikasi"


class Ticket(Base):
    """Ticket model"""
    __tablename__ = "tickets"
    
    id = Column(String, primary_key=True, index=True)
    employee_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    technician_id = Column(String, ForeignKey("users.id"), nullable=True, index=True)
    
    deskripsi = Column(Text, nullable=False)
    kategori = Column(Enum(TicketCategory), nullable=False, index=True)
    sub_kategori = Column(String, nullable=True)
    status = Column(Enum(TicketStatus), nullable=False, default=TicketStatus.PENDING, index=True)
    
    resolution_notes = Column(Text, nullable=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now(), index=True)
    accepted_at = Column(DateTime(timezone=True), nullable=True)
    completed_at = Column(DateTime(timezone=True), nullable=True)
    
    # Relationships (without back_populates since User model is simplified)
    employee = relationship("User", foreign_keys=[employee_id])
    technician = relationship("User", foreign_keys=[technician_id])
    comments = relationship("Comment", back_populates="ticket", cascade="all, delete-orphan")
    notifications = relationship("Notification", back_populates="ticket", cascade="all, delete-orphan")