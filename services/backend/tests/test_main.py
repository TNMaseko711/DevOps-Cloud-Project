from fastapi.testclient import TestClient

from src.main import app


client = TestClient(app)


def test_health_endpoint() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_products_endpoint() -> None:
    response = client.get("/api/products")
    assert response.status_code == 200
    assert len(response.json()) >= 2
