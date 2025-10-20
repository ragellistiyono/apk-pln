"""
User database models - Simplified without polymorphic inheritance
"""
from sqlalchemy import Column, String, DateTime, Enum, Boolean, Integer
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from ..database import Base


class UserRole(str, enum.Enum):
    """User role enumeration"""
    EMPLOYEE = "employee"
    TECHNICIAN = "technician"
    ADMIN = "admin"


class User(Base):
    """User model - all users in one table"""
    __tablename__ = "users"
    
    id = Column(String, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    nama = Column(String, nullable=False)
    role = Column(Enum(UserRole), nullable=False, index=True)
    
    # Employee-specific fields (null for non-employees)
    nip = Column(String, unique=True, nullable=True, index=True)
    region = Column(String, nullable=True)
    
    # Technician-specific fields (null for non-technicians)
    wilayah = Column(String, nullable=True)
    categories = Column(String, nullable=True)  # JSON array as string
    sub_categories = Column(String, nullable=True)  # JSON array as string
    assigned_tickets_count = Column(Integer, default=0)
    completed_tickets_count = Column(Integer, default=0)
    
    # Admin-specific fields (null for non-admins)
    nomor_wa = Column(String, nullable=True)
    permissions = Column(String, nullable=True)  # JSON array as string
    
    is_active = Column(Boolean, default=True)
    is_available = Column(Boolean, default=True)  # For technicians
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())


# Convenience classes for type hints (not actual models)
Employee = User
Technician = User
Admin = User