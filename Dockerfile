FROM alpine:3.20

WORKDIR /app

RUN apk add --no-cache \
    bsd-compat-headers \
    build-base \
    ca-certificates \
    linux-headers \
    lua5.4 \
    lua5.4-dev \
    luarocks5.4 \
    m4 \
    openssl-dev \
    zlib-dev

ENV LUA_PATH="/app/src/?.lua;/app/?.lua;;"
ENV LUA_CPATH="/usr/local/lib/lua/5.4/?.so;;"

COPY api-template-1.0-1.rockspec .

RUN luarocks-5.4 install --only-deps api-template-1.0-1.rockspec
RUN luarocks-5.4 install busted

COPY . .

EXPOSE 8080

CMD ["lua5.4", "src/main.lua"]
