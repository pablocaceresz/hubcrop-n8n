-- Script de inicialización (solo corre si pg_data está vacío)

DO $$ BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'n8n_user') THEN
      CREATE ROLE n8n_user WITH LOGIN PASSWORD 'KIUB21387gsduifhvb76g23';
   END IF;
END$$;
DO $$ BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'n8n') THEN
      CREATE DATABASE n8n OWNER n8n_user ENCODING 'UTF8';
   END IF;
END$$;
GRANT ALL PRIVILEGES ON DATABASE n8n TO n8n_user;

DO $$ BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'metamcp_user') THEN
      CREATE ROLE metamcp_user WITH LOGIN PASSWORD 'IKJKBNciy82b37yv7uybkafs';
   END IF;
END$$;
DO $$ BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'metamcp') THEN
      CREATE DATABASE metamcp OWNER metamcp_user ENCODING 'UTF8';
   END IF;
END$$;
GRANT ALL PRIVILEGES ON DATABASE metamcp TO metamcp_user;
