# Traefik v3 + n8n (SQLite) + MetaMCP (imagen 2.4.13) — SSE listo

Usa la imagen oficial de MetaMCP `ghcr.io/metatool-ai/metamcp:2.4.13` (sin compilar).
Incluye:
- **Traefik v3** con TLS automático y **dashboard** (BasicAuth) en dominio propio.
- **n8n** (SQLite) detrás de Traefik.
- **Postgres** para MetaMCP.
- Config de **SSE** (timeouts amplios, sin buffering) y **CORS** para **clientes remotos**.

## Preparación
1) Variables:
```bash
cp .env.example .env
```
Edita dominios (`TRAEFIK_HOST`, `N8N_HOST`, `MCP_HOST`), `ACME_EMAIL` y secretos.

2) DNS: apunta los 3 dominios a esta máquina (registros A/AAAA).

3) BasicAuth dashboard:
```bash
htpasswd -nb admin 'MiClaveSegura123'
# pega el resultado en traefik/dynamic/middlewares.yml
```

## Levantar
```bash
docker compose up -d --pull always --build
```
- Dashboard: `https://$TRAEFIK_HOST`
- n8n: `https://$N8N_HOST`
- MetaMCP: `https://$MCP_HOST`

## Clientes remotos
- Usa `Authorization: Bearer <API_KEY>`
- SSE: `https://$MCP_HOST/metamcp/<ENDPOINT>/sse` (no uses query string para api_key)
- `APP_URL` debe coincidir con la URL pública real (CORS).

## Estructura
```
.
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── .gitignore
└── traefik/
    └── dynamic/
        ├── middlewares.yml
        └── servers-transport.yml
```

## Troubleshooting
- Certs LE tardan el primer arranque (revisa puertos 80/443 abiertos).
- CORS: accede por `https://$MCP_HOST` (igual a `APP_URL`).
- SSE: evita WAF/CDN con buffering; Traefik ya envía `X-Accel-Buffering: no` y extiende timeouts.
