FROM postgres:16-alpine
ENV POSTGRES_DB=ecommerce
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
COPY init-scripts /docker-entrypoint-initdb.d
EXPOSE 5432
HEALTHCHECK --interval=30s --timeout=5s --retries=5 CMD pg_isready -U postgres -d ecommerce || exit 1
