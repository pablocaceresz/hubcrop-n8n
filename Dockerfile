FROM n8nio/n8n:1.107.3

USER root
# Paquetes globales para funciones personalizadas (ajusta los que necesites)
RUN npm install -g google-auth-library aws-sigv4-sign && npm cache clean --force

# Permitir requires externos en Function/Code nodes
ENV NODE_FUNCTION_ALLOW_EXTERNAL=*

USER node
