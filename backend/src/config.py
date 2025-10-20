"""
Application configuration and settings
"""
from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    """Application settings from environment variables"""
    
    # Database
    database_url: str = "postgresql://postgres:password@localhost:5432/pln_ticket_db"
    db_host: str = "localhost"
    db_port: int = 5432
    db_name: str = "pln_ticket_db"
    db_user: str = "postgres"
    db_password: str = "password"
    
    # JWT
    secret_key: str = "your-secret-key-change-in-production"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    refresh_token_expire_days: int = 7
    
    # API
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    debug: bool = True
    allowed_origins: str = "http://localhost:*,http://127.0.0.1:*"
    
    # Application
    app_name: str = "PLN Ticket System API"
    app_version: str = "1.0.0"
    
    class Config:
        env_file = ".env"
        case_sensitive = False


@lru_cache()
def get_settings() -> Settings:
    """Get cached settings instance"""
    return Settings()