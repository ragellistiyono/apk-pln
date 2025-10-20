# PLN Ticket System - Backend API

FastAPI backend for PLN Internal Ticket Management System.

## Technology Stack

- **Framework**: FastAPI 0.109.0
- **Database**: PostgreSQL
- **ORM**: SQLAlchemy 2.0
- **Authentication**: JWT (python-jose)
- **Password Hashing**: bcrypt (passlib)

## Project Structure

```
pln-ticket-api/
├── src/
│   ├── models/          # SQLAlchemy database models
│   ├── schemas/         # Pydantic request/response schemas
│   ├── routes/          # API endpoints
│   ├── services/        # Business logic
│   ├── middleware/      # Auth and error handling
│   ├── utils/           # Helper functions
│   ├── config.py        # Configuration
│   ├── database.py      # Database setup
│   └── main.py          # FastAPI application
├── migrations/          # Database migrations
├── tests/               # Test files
├── requirements.txt     # Python dependencies
└── .env                 # Environment variables (create from .env.example)
```

## Setup Instructions

### 1. Prerequisites

- Python 3.11+
- PostgreSQL 15+
- pip or poetry

### 2. Database Setup

```bash
# Install PostgreSQL (if not installed)
sudo apt-get install postgresql postgresql-contrib

# Start PostgreSQL service
sudo service postgresql start

# Create database and user
sudo -u postgres psql
```

In PostgreSQL shell:
```sql
CREATE DATABASE pln_ticket_db;
CREATE USER pln_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE pln_ticket_db TO pln_user;
\q
```

### 3. Environment Configuration

```bash
# Copy example environment file
cp .env.example .env

# Edit .env with your database credentials
nano .env
```

Update these values in `.env`:
```
DATABASE_URL=postgresql://pln_user:your_password@localhost:5432/pln_ticket_db
SECRET_KEY=generate-a-secure-random-key-here
```

### 4. Install Dependencies

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
source venv/bin/activate  # On Linux/Mac
# or
venv\Scripts\activate  # On Windows

# Install dependencies
pip install -r requirements.txt
```

### 5. Initialize Database

```bash
# Run migrations (create tables)
python -c "from src.database import init_db; init_db()"

# Or run with alembic (recommended for production)
alembic revision --autogenerate -m "Initial schema"
alembic upgrade head
```

### 6. Create Initial Users (Seed Data)

```bash
# Run seed script to create test users
python scripts/seed_data.py
```

This will create:
- 1 test employee (NIP: TEST001, password: password)
- 11 technicians (as per specification)
- 1 admin (username: admin, password: admin123)

### 7. Run the Server

```bash
# Development mode with auto-reload
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

# Production mode
uvicorn src.main:app --host 0.0.0.0 --port 8000 --workers 4
```

The API will be available at:
- API: http://localhost:8000
- Interactive Docs: http://localhost:8000/docs
- Alternative Docs: http://localhost:8000/redoc

## API Endpoints

### Authentication
- `POST /api/auth/login` - Login with username/password
- `POST /api/auth/refresh` - Refresh access token
- `POST /api/auth/logout` - Logout (client-side)

### Tickets
- `GET /api/tickets` - List tickets (with filtering)
- `POST /api/tickets` - Create new ticket
- `GET /api/tickets/{id}` - Get ticket details
- `POST /api/tickets/{id}/accept` - Accept ticket (technician)
- `POST /api/tickets/{id}/complete` - Complete ticket (technician)
- `GET /api/technicians` - Get available technicians

### Comments
- `GET /api/tickets/{id}/comments` - Get ticket comments
- `POST /api/tickets/{id}/comments` - Add comment

### Health
- `GET /api/health` - Health check
- `GET /` - API info

## Testing

```bash
# Run tests
pytest

# Run with coverage
pytest --cov=src tests/

# Run specific test file
pytest tests/test_auth.py -v
```

## Development

### Running in Development

```bash
# Activate virtual environment
source venv/bin/activate

# Run with auto-reload
uvicorn src.main:app --reload
```

### Database Migrations

```bash
# Create new migration
alembic revision --autogenerate -m "Description of changes"

# Apply migrations
alembic upgrade head

# Rollback migration
alembic downgrade -1
```

## Connecting with Flutter App

The Flutter app is configured to connect to `http://localhost:8000` by default.

To change the API URL in Flutter app:
1. Update `lib/core/constants/api_constants.dart`
2. Change `baseUrl` constant
3. Rebuild Flutter app

## Production Deployment

### Using Docker (Recommended)

```bash
# Build Docker image
docker build -t pln-ticket-api .

# Run with Docker Compose
docker-compose up -d
```

### Manual Deployment

1. Setup PostgreSQL on server
2. Configure environment variables
3. Run database migrations
4. Start with gunicorn or uvicorn
5. Setup reverse proxy (nginx)
6. Enable HTTPS (Let's Encrypt)

## Troubleshooting

### Database Connection Issues
```bash
# Check PostgreSQL is running
sudo service postgresql status

# Check connection
psql -U pln_user -d pln_ticket_db -h localhost
```

### Import Errors
```bash
# Ensure you're in virtual environment
source venv/bin/activate

# Reinstall dependencies
pip install -r requirements.txt
```

### CORS Issues
- Check `ALLOWED_ORIGINS` in `.env`
- Ensure Flutter app origin is included

## License

Internal PLN Project - All Rights Reserved