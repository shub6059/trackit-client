FROM node:6-slim

ARG API_URL
ENV API_URL=${API_URL}

# Install supervisor, git, and yarn via npm
RUN apt-get update \
    && apt-get install -y --no-install-recommends supervisor git curl \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g yarn

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /webui
COPY ./ ./
RUN yarn install
RUN yarn run build

EXPOSE 80 443
CMD ["/usr/bin/supervisord"]
