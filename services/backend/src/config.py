from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "ecommerce-backend"
    environment: str = "dev"
    database_url: str = "postgresql://postgres:postgres@localhost:5432/ecommerce"
    feature_recommendations: bool = False

    model_config = SettingsConfigDict(env_file=".env", env_prefix="APP_")


settings = Settings()
