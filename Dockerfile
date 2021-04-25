FROM postgres:11

ENV POSTGRES_USER "docker"
ENV POSTGRES_PASSWORD "docker"

EXPOSE 5432

COPY sql/init.sql /docker-entrypoint-initdb.d/init.sql
