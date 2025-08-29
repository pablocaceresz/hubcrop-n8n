# n8n + SQLite (Docker Compose)

Stack mínimo para ejecutar **n8n** con **SQLite** usando Docker Compose. Incluye una imagen base personalizada donde se instalan paquetes NPM globales para usar desde Function/Code nodes.

> **Importante:** Este proyecto expone n8n en `http://localhost:5678` por defecto. Para producción, publícalo detrás de un reverse proxy con TLS y usa `N8N_PROTOCOL=https` y `WEBHOOK_URL` con tu dominio público.

---

## 🚀 Requisitos

- Docker Engine 20.10+
- Docker Compose v2+ (plugin `docker compose`)

---

## 📦 Estructura

```
.
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── .gitignore
└── README.md
```

---

## ⚙️ Preparación

1) **Clona** este repo (o descomprime el zip).
2) **Copia** el archivo de variables y edítalo:
```bash
cp .env.example .env
# Genera una clave de cifrado fuerte y pégala en N8N_ENCRYPTION_KEY
openssl rand -base64 32
```
3) (Opcional) Ajusta paquetes NPM en el `Dockerfile` si necesitas otros módulos globales.

---

## ▶️ Puesta en marcha

```bash
docker compose up -d --build
docker compose logs -f n8n
```

Accede a: **http://localhost:5678**

> Si vas a usar webhooks desde internet, configura:
> - `N8N_HOST` con tu dominio (p.ej. `n8n.midominio.cl`)
> - `N8N_PROTOCOL=https`
> - `WEBHOOK_URL=https://n8n.midominio.cl/`

---

## 💾 Persistencia de datos

- El volumen `n8n_data` guarda **workflows, credenciales y la base SQLite** (`database.sqlite`) bajo `/home/node/.n8n`.
- Respáldalo de forma periódica.

**Backup rápido del volumen (ejemplo):**
```bash
# Crea una carpeta local de backups
mkdir -p backup

# Empaqueta el volumen n8n_data (requiere tar dentro del contenedor temporal)
docker run --rm -v n8n-sqlite-docker_n8n_data:/source -v "$(pwd)/backup:/backup" alpine   sh -c "apk add --no-cache tar >/dev/null && tar czf /backup/n8n_data_$(date +%F_%H-%M-%S).tgz -C /source ."
```

**Restore (ejemplo):**
```bash
docker run --rm -v n8n-sqlite-docker_n8n_data:/dest -v "$(pwd)/backup:/backup" alpine   sh -c "apk add --no-cache tar >/dev/null && rm -rf /dest/* && tar xzf /backup/n8n_data_YYYY-MM-DD_HH-MM-SS.tgz -C /dest"
```

> Cambia `n8n-sqlite-docker_n8n_data` si tu namespace de Docker Compose difiere (normalmente: `<carpeta>_n8n_data`).

---

## 🔐 Seguridad recomendada

- Usa un **proxy** (Nginx/Traefik/Caddy) con TLS si publicas en internet.
- Cambia `N8N_ENCRYPTION_KEY` por una clave fuerte y **no** la compartas.
- Define `N8N_SECURE_COOKIE=true` (ya viene activado).
- Limita el acceso por IP/Autenticación del proxy a la UI si es necesario.

---

## ♻️ Actualizaciones

Para subir de versión de n8n, edita la etiqueta de la imagen base en `Dockerfile` (p.ej. `n8nio/n8n:1.108.0`) y reconstruye:

```bash
docker compose down
docker compose build --no-cache
docker compose up -d
```

**Antes de actualizar**, realiza un backup del volumen `n8n_data`.

---

## 🧪 Variables de entorno clave

| Variable | Descripción |
|---|---|
| `TZ` | Zona horaria del contenedor. |
| `GENERIC_TIMEZONE` | Zona horaria usada por n8n. |
| `N8N_HOST` | Host/Dominio público (útil para webhooks). |
| `N8N_PROTOCOL` | `http` o `https`. |
| `WEBHOOK_URL` | URL pública base de webhooks. |
| `N8N_ENCRYPTION_KEY` | Clave para cifrar credenciales en n8n. |
| `DB_TYPE` | Fijado a `sqlite` en este stack. |
| `NODE_FUNCTION_ALLOW_EXTERNAL` | Permite `require` de módulos externos en Function/Code nodes. |

---

## 🛠️ Troubleshooting

- **La UI no responde**: revisa `docker compose logs -f n8n` y el `healthcheck`.
- **Webhooks no llegan**: confirma `N8N_HOST`, `N8N_PROTOCOL`, `WEBHOOK_URL` y reglas del proxy/Firewall.
- **Permisos en volumen**: los contenedores corren como usuario `node`. Evita cambiar permisos manualmente dentro de `/home/node/.n8n`.

---

## 📜 Licencia

Este proyecto se entrega **sin licencia explícita**. Puedes añadir la que prefieras en tu repositorio.
