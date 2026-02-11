import os
import requests


def main() -> None:
    base_url = os.getenv("API_BASE_URL", "http://localhost:8080")
    response = requests.get(f"{base_url}/health", timeout=5)
    response.raise_for_status()
    print("integration health check passed")


if __name__ == "__main__":
    main()
