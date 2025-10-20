"""
Comment routes
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import desc
import uuid
from ..database import get_db
from ..models import User, Ticket, Comment
from ..schemas.comment import AddCommentRequest, CommentResponse, CommentListResponse
from ..middleware.auth import get_current_active_user

router = APIRouter(prefix="/api/tickets", tags=["comments"])


@router.post("/{ticket_id}/comments", response_model=CommentResponse, status_code=status.HTTP_201_CREATED)
async def add_comment(
    ticket_id: str,
    request: AddCommentRequest,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Add a comment to a ticket"""
    # Verify ticket exists
    ticket = db.query(Ticket).filter(Ticket.id == ticket_id).first()
    
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tiket tidak ditemukan"
        )
    
    # Verify user has access to this ticket
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
    
    # Create comment
    comment = Comment(
        id=str(uuid.uuid4()),
        ticket_id=ticket_id,
        user_id=current_user.id,
        text=request.text
    )
    
    db.add(comment)
    db.commit()
    db.refresh(comment)
    
    # Prepare response with user info
    comment_response = CommentResponse(
        id=comment.id,
        ticket_id=comment.ticket_id,
        user_id=comment.user_id,
        user_nama=current_user.nama,
        user_type=current_user.role,
        text=comment.text,
        is_read=comment.is_read,
        created_at=comment.created_at
    )
    
    return comment_response


@router.get("/{ticket_id}/comments", response_model=CommentListResponse)
async def get_comments(
    ticket_id: str,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """Get all comments for a ticket"""
    # Verify ticket exists
    ticket = db.query(Ticket).filter(Ticket.id == ticket_id).first()
    
    if not ticket:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tiket tidak ditemukan"
        )
    
    # Verify access
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
    
    # Get comments
    comments = db.query(Comment).filter(
        Comment.ticket_id == ticket_id
    ).order_by(Comment.created_at).all()
    
    # Build response with user names
    comment_responses = []
    for comment in comments:
        user = db.query(User).filter(User.id == comment.user_id).first()
        comment_responses.append(
            CommentResponse(
                id=comment.id,
                ticket_id=comment.ticket_id,
                user_id=comment.user_id,
                user_nama=user.nama if user else "Unknown",
                user_type=user.role if user else "employee",
                text=comment.text,
                is_read=comment.is_read,
                created_at=comment.created_at
            )
        )
    
    return CommentListResponse(
        comments=comment_responses,
        total=len(comment_responses)
    )