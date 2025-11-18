FROM node:18-slim
# or: FROM node:20-slim

ARG API_URL
ENV API_URL=${API_URL}

# Install supervisor, git, curl
RUN apt-get update \
    && apt-get install -y --no-install-recommends supervisor git curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Enable Yarn via corepack (built into modern Node)
RUN corepack enable

WORKDIR /webui
COPY ./ ./

RUN yarn install
RUN yarn run build

EXPOSE 80 443

CMD ["/usr/bin/supervisord"]
