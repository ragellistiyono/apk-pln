"""
Ticket routes
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from sqlalchemy import desc
from typing import Optional
import uuid
from datetime import datetime
from ..database import get_db
from ..models import User, Ticket, Employee, Technician, TicketStatus, TicketCategory
from ..schemas.ticket import CreateTicketRequest, CompleteTicketRequest, TicketResponse, TicketListResponse
from ..schemas.auth import TechnicianResponse
from ..middleware.auth import get_current_active_user

router = APIRouter(prefix="/api/tickets", tags=["tickets"])


@router.post("", response_model=TicketResponse, status_code=status.HTTP_201_CREATED)
async def create_ticket(
    request: CreateTicketRequest,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Create a new ticket"""
    # Verify current user is an employee
    if current_user.role != "employee":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Hanya employee yang dapat membuat tiket"
        )
    
    # Verify technician exists
    technician = db.query(Technician).filter(Technician.id == request.technician_id).first()
    if not technician:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Teknisi tidak ditemukan"
        )
    
    # Create ticket
    ticket = Ticket(
        id=str(uuid.uuid4()),
        employee_id=current_user.id,
        technician_id=request.technician_id,
        deskripsi=request.deskripsi,
        kategori=request.kategori,
        sub_kategori=request.sub_kategori,
        status=TicketStatus.PENDING
    )
    
    db.add(ticket)
    db.commit()
    db.refresh(ticket)
    
    # Add employee and technician names
    ticket.employee_nama = current_user.nama
    ticket.employee_nip = current_user.nip if isinstance(current_user, Employee) else None
    ticket.technician_nama = technician.nama
    
    return ticket


@router.get("", response_model=TicketListResponse)
async def get_tickets(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    status: Optional[TicketStatus] = None,
    category: Optional[TicketCategory] = None,
    employee_id: Optional[str] = None,
    technician_id: Optional[str] = None,
    search: Optional[str] = None,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get tickets with filtering and pagination"""
    query = db.query(Ticket)
    
    # Filter based on user role
    if current_user.role == "employee":
        query = query.filter(Ticket.employee_id == current_user.id)
    elif current_user.role == "technician":
        query = query.filter(Ticket.technician_id == current_user.id)
    
    # Apply filters
    if status:
        query = query.filter(Ticket.status == status)
    if category:
        query = query.filter(Ticket.kategori == category)
    if employee_id:
        query = query.filter(Ticket.employee_id == employee_id)
    if technician_id:
        query = query.filter(Ticket.technician_id == technician_id)
    if search:
        query = query.filter(Ticket.deskripsi.ilike(f"%{search}%"))
    
    # Get total count
    total = query.count()
    
    # Apply pagination
    offset = (page - 1) * limit
    tickets = query.order_by(desc(Ticket.created_at)).offset(offset).limit(limit).all()
    
    return TicketListResponse(
        tickets=tickets,
        total=total,
        page=page,
        limit=limit
    )


@router.get("/{ticket_id}", response_model=TicketResponse)
async def get_ticket(
    ticket_id: str,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get a single ticket by ID"""
    ticket = db.query(Ticket).filter(Ticket.id == ticket_id).first()
    
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tiket tidak ditemukan"
        )
    
    # Verify access (employee can only see their tickets, technician their assigned tickets)
    if current_user.role == "employee" and ticket.employee_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Anda tidak memiliki akses ke tiket ini"
        )
    
    if current_user.role == "technician" and ticket.technician_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Anda tidak memiliki akses ke tiket ini"
        )
    
    return ticket


@router.post("/{ticket_id}/accept", response_model=TicketResponse)
async def accept_ticket(
    ticket_id: str,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Accept a ticket (technician only)"""
    if current_user.role != "technician":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Hanya teknisi yang dapat menerima tiket"
        )
    
    ticket = db.query(Ticket).filter(Ticket.id == ticket_id).first()
    
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tiket tidak ditemukan"
        )
    
    if ticket.technician_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Tiket ini tidak ditugaskan kepada Anda"
        )
    
    if ticket.status != TicketStatus.PENDING:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Tiket sudah diterima sebelumnya"
        )
    
    ticket.status = TicketStatus.IN_PROGRESS
    ticket.accepted_at = datetime.utcnow()
    
    db.commit()
    db.refresh(ticket)
    
    return ticket


@router.post("/{ticket_id}/complete", response_model=TicketResponse)
async def complete_ticket(
    ticket_id: str,
    request: CompleteTicketRequest,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Complete a ticket (technician only)"""
    if current_user.role != "technician":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Hanya teknisi yang dapat menyelesaikan tiket"
        )
    
    ticket = db.query(Ticket).filter(Ticket.id == ticket_id).first()
    
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tiket tidak ditemukan"
        )
    
    if ticket.technician_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Tiket ini tidak ditugaskan kepada Anda"
        )
    
    if ticket.status != TicketStatus.IN_PROGRESS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Tiket harus dalam status 'In Progress' untuk diselesaikan"
        )
    
    ticket.status = TicketStatus.COMPLETED
    ticket.completed_at = datetime.utcnow()
    ticket.resolution_notes = request.resolution_notes
    
    db.commit()
    db.refresh(ticket)
    
    return ticket


@router.get("/technicians", response_model=list[TechnicianResponse])
async def get_technicians(
    category: Optional[TicketCategory] = None,
    region: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get available technicians (for matching)"""
    query = db.query(Technician).filter(Technician.is_available == True)
    
    # Filter will be done in-memory since categories/regions are JSON arrays
    technicians = query.all()
    
    # TODO: Implement proper filtering based on category and region
    # For now, return all available technicians
    
    return technicians