# Lua API Template

A small Lua API service template that runs in Docker and uses maintained Lua libraries for HTTP parsing, stream handling, TLS support dependencies, and JSON encoding.

## What Is Included

- Docker-based Lua 5.1 runtime on Alpine.
- `lua-http` for HTTP server behavior instead of hand-written socket parsing.
- `dkjson` for JSON encoding.
- `busted` test runner.
- A small exact-match router with method normalization and query-string tolerant lookup.

## Running The Application

```bash
docker compose up --build
```

The API is exposed at `http://localhost:18080` by default because port `8080` is commonly already occupied by local Docker/WSL services. To use a different host port:

```bash
HOST_PORT=8080 docker compose up --build
```

Available endpoints:

- `GET /`
- `GET /health`

## Running Tests

```bash
docker compose run --rm test
```

## Adding Routes

Routes are registered in `src/main.lua`:

```lua
app_router:add_route("POST", "/items", function(request)
    return '{"created":true}', 201, "application/json; charset=utf-8"
end)
```

Handlers receive a request table with `method`, `path`, and `headers`, and return:

- response body
- numeric status code
- optional content type

## Local Development

Docker is the supported path. If you run locally, install Lua 5.1, LuaRocks for Lua 5.1, and then:

```bash
luarocks-5.1 install --only-deps api-template-1.0-1.rockspec
lua5.1 src/main.lua
```
