# Traefik + n8n (Postgres) + MetaMCP (Postgres)

## Inicialización de DB
El contenedor de Postgres ejecuta automáticamente `postgres/init/01-init.sql` al primer arranque si `pg_data` está vacío, creando:
- DB y usuario para **n8n**
- DB y usuario para **MetaMCP**

### Comandos manuales (si no corre init)
```bash
docker compose exec postgres psql -U postgres

-- n8n
CREATE ROLE n8n_user WITH LOGIN PASSWORD 'cambia_password_n8n';
CREATE DATABASE n8n OWNER n8n_user ENCODING 'UTF8';
GRANT ALL PRIVILEGES ON DATABASE n8n TO n8n_user;

-- MetaMCP
CREATE ROLE metamcp_user WITH LOGIN PASSWORD 'cambia_password_metamcp';
CREATE DATABASE metamcp OWNER metamcp_user ENCODING 'UTF8';
GRANT ALL PRIVILEGES ON DATABASE metamcp TO metamcp_user;
\q
```
O en una sola línea:
```bash
docker compose exec -T postgres psql -U postgres -c "CREATE ROLE n8n_user WITH LOGIN PASSWORD 'cambia_password_n8n'; CREATE DATABASE n8n OWNER n8n_user;"
docker compose exec -T postgres psql -U postgres -c "CREATE ROLE metamcp_user WITH LOGIN PASSWORD 'cambia_password_metamcp'; CREATE DATABASE metamcp OWNER metamcp_user;"
```
---
Levantar:
```bash
docker compose up -d --build
```
URLs:
- Traefik dashboard: https://$TRAEFIK_HOST
- n8n: https://$N8N_HOST
- MetaMCP: https://$MCP_HOST
