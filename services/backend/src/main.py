from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

from src.config import settings

app = FastAPI(title=settings.app_name)
Instrumentator().instrument(app).expose(app)


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "service": settings.app_name, "env": settings.environment}


@app.get("/ready")
def ready() -> dict:
    return {"status": "ready"}


@app.get("/api/products")
def products() -> list[dict]:
    return [
        {"id": 1, "name": "Cloud T-Shirt", "price": 29.99},
        {"id": 2, "name": "DevOps Mug", "price": 14.99},
    ]
