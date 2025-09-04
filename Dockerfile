FROM n8nio/n8n:1.107.3

USER root
RUN npm install -g google-auth-library aws-sigv4-sign && npm cache clean --force
ENV NODE_FUNCTION_ALLOW_EXTERNAL=*
USER node
