from fastapi import APIRouter, Response
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST, Counter, Histogram, Gauge

REQUEST_COUNT = Counter(
    "taskflow_http_requests_total",
    "Total HTTP Requests",
    ["method", "endpoint", "status_code"],
)

REQUEST_LATENCY = Histogram(
    "taskflow_http_request_duration_seconds",
    "HTTP Request Latency in Seconds",
    ["method", "endpoint"],
)

ACTIVE_USERS = Gauge(
    "taskflow_active_users_total",
    "Total Registered Active Users",
)

TOTAL_TASKS_GAUGE = Gauge(
    "taskflow_tasks_total",
    "Total Tasks Created in System",
)


def refresh_business_metrics(db) -> None:
    """Refresh low-cardinality business gauges from the database.

    This is intentionally called after state-changing operations so the Grafana
    dashboard reflects real application data instead of placeholder gauges.
    """
    from app.models.user import User
    from app.models.task import Task

    ACTIVE_USERS.set(db.query(User).filter(User.is_active.is_(True)).count())
    TOTAL_TASKS_GAUGE.set(db.query(Task).count())


metrics_router = APIRouter(tags=["Metrics"])


@metrics_router.get("/metrics")
def get_metrics():
    return Response(content=generate_latest(), media_type=CONTENT_TYPE_LATEST)
