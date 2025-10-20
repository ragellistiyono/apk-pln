"""
Seed database with initial data
"""
import sys
import uuid
sys.path.append('.')

from src.database import SessionLocal, Base, engine
from src.models import User, UserRole
# Import all models to ensure relationships are configured
from src.models import Ticket, Comment, Notification
from src.utils.auth import get_password_hash


# Ensure tables exist
Base.metadata.create_all(bind=engine)


def seed_data():
    """Seed database with initial users"""
    db = SessionLocal()
    
    try:
        print("Creating initial users...")
        
        # Create test employee
        employee = User(
            id=str(uuid.uuid4()),
            username="ragel",
            hashed_password=get_password_hash("password"),
            nama="Ragel Listiyono",
            role=UserRole.EMPLOYEE,
            nip="1927B3AC",
            region="Kantor Induk UIT JBM",
            is_active=True
        )
        db.add(employee)
        
        # Create 11 technicians as per specification
        technicians_data = [
            {
                "nama": "Pupus Dwi Anggono",
                "username": "pupus",
                "wilayah": "Kantor Induk UIT JBM",
                "categories": '["hardware","jaringanKoneksi","zoom","aplikasi"]',
                "sub_categories": '["SAP"]'
            },
            {
                "nama": "Parluhutan Harahap",
                "username": "parluhutan",
                "wilayah": "UPT Malang",
                "categories": '["hardware","jaringanKoneksi","zoom","aplikasi"]',
                "sub_categories": '["SAP"]'
            },
            {
                "nama": "Alif Reza",
                "username": "alif",
                "wilayah": "UPT Probolinggo",
                "categories": '["hardware","jaringanKoneksi","zoom","aplikasi"]',
                "sub_categories": '["SAP"]'
            },
            {
                "nama": "Ramadhani",
                "username": "ramadhani",
                "wilayah": "UPT Surabaya",
                "categories": '["hardware","jaringanKoneksi","zoom","aplikasi"]',
                "sub_categories": '["SAP"]'
            },
            {
                "nama": "Ardhyas",
                "username": "ardhyas",
                "wilayah": "UPT Gresik",
                "categories": '["hardware","jaringanKoneksi","zoom","aplikasi"]',
                "sub_categories": '["SAP"]'
            },
            {
                "nama": "Sayudha",
                "username": "sayudha",
                "wilayah": "UPT Madiun",
                "categories": '["hardware","jaringanKoneksi","zoom","aplikasi"]',
                "sub_categories": '["SAP"]'
            },
            {
                "nama": "Wayan Aris",
                "username": "wayan",
                "wilayah": "UPT Bali",
                "categories": '["hardware","jaringanKoneksi","zoom","aplikasi"]',
                "sub_categories": '["SAP"]'
            },
            {
                "nama": "Alfian Prasetyo",
                "username": "alfian",
                "wilayah": "ALL UIT",
                "categories": '["jaringanKoneksi","aplikasi"]',
                "sub_categories": '["Minerium","Lainnya"]'
            },
            {
                "nama": "Hartanto Budi",
                "username": "hartanto",
                "wilayah": None,
                "categories": '["aplikasi"]',
                "sub_categories": '["Smartness"]'
            },
            {
                "nama": "Kicky",
                "username": "kicky",
                "wilayah": None,
                "categories": '["akun"]',
                "sub_categories": '["Email/Korporat"]'
            },
            {
                "nama": "Risma Budi",
                "username": "risma",
                "wilayah": None,
                "categories": '["akun"]',
                "sub_categories": '["VPN"]'
            },
        ]
        
        for tech_data in technicians_data:
            technician = User(
                id=str(uuid.uuid4()),
                username=tech_data["username"],
                hashed_password=get_password_hash("password"),
                nama=tech_data["nama"],
                role=UserRole.TECHNICIAN,
                wilayah=tech_data["wilayah"],
                categories=tech_data["categories"],
                sub_categories=tech_data["sub_categories"],
                is_available=True,
                is_active=True
            )
            db.add(technician)
        
        # Create admin
        admin = User(
            id=str(uuid.uuid4()),
            username="admin",
            hashed_password=get_password_hash("admin123"),
            nama="Ralisto Reddington",
            role=UserRole.ADMIN,
            nomor_wa="085843991612",
            permissions='["all"]',
            is_active=True
        )
        db.add(admin)
        
        db.commit()
        
        print("✅ Seed data created successfully!")
        print("\nTest Accounts:")
        print("  Employee: ragel / password")
        print("  Technician: pupus / password (or any technician username)")
        print("  Admin: admin / admin123")
        
    except Exception as e:
        print(f"❌ Error seeding data: {e}")
        import traceback
        traceback.print_exc()
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    seed_data()