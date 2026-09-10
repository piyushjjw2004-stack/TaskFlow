from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import text
from app.api.deps import get_db
from app.core.config import settings

health_router = APIRouter(tags=["Health & Diagnostics"])


@health_router.get("/health", status_code=status.HTTP_200_OK)
def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "service": settings.PROJECT_NAME,
        "version": settings.VERSION,
        "environment": settings.ENVIRONMENT
    }


@health_router.get("/ready", status_code=status.HTTP_200_OK)
def readiness_check(db: Session = Depends(get_db)):
    """Readiness checks the runtime dependency needed to accept traffic.

    Schema migrations are handled separately by the deployment migration Job, so
    readiness must not deadlock the Helm release before that Job can execute.
    """
    try:
        db.execute(text("SELECT 1"))
        return {
            "status": "ready",
            "database": "connected",
            "timestamp": datetime.now(timezone.utc).isoformat()
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={
                "status": "not_ready",
                "database": "disconnected",
                "error": str(e)
            }
        )


@health_router.get("/ready/schema", status_code=status.HTTP_200_OK)
def schema_readiness_check(db: Session = Depends(get_db)):
    """Verify that the Alembic schema has been applied after deployment."""
    try:
        result = db.execute(text("SELECT version_num FROM alembic_version LIMIT 1"))
        version = result.scalar_one_or_none()
        if not version:
            raise RuntimeError("Alembic schema is not initialized")
        return {
            "status": "ready",
            "database": "connected",
            "schema": "migrated",
            "alembic_revision": version,
            "timestamp": datetime.now(timezone.utc).isoformat()
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={
                "status": "not_ready",
                "database": "schema_not_ready",
                "error": str(e)
            }
        )
