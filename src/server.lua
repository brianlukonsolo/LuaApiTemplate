local http_headers = require("http.headers")
local http_server = require("http.server")
local router = require("router")

local server = {}
server.__index = server

function server:new(host, port)
    local instance = {
        host = host or "0.0.0.0",
        port = port or 8080,
        router = router:new(),
        server = nil
    }
    return setmetatable(instance, self)
end

local function write_response(stream, status, body, content_type)
    body = body or ""

    local headers = http_headers.new()
    headers:append(":status", tostring(status or 200))
    headers:append("content-type", content_type or "text/plain; charset=utf-8")
    headers:append("content-length", tostring(#body))

    assert(stream:write_headers(headers, false))
    assert(stream:write_chunk(body, true))
end

function server:handle_stream(stream)
    local request_headers = assert(stream:get_headers())
    local method = request_headers:get(":method")
    local path = request_headers:get(":path")

    local handler = self.router:get_handler(method, path)
    if not handler then
        write_response(stream, 404, "404 Not Found")
        return
    end

    local ok, body, status, content_type = pcall(handler, {
        method = method,
        path = path,
        headers = request_headers
    })

    if not ok then
        io.stderr:write("Error in handler: " .. tostring(body) .. "\n")
        write_response(stream, 500, "500 Internal Server Error")
        return
    end

    write_response(stream, status or 200, body or "", content_type)
end

function server:start()
    self.server = assert(http_server.listen({
        host = self.host,
        port = self.port,
        onstream = function(_, stream)
            self:handle_stream(stream)
        end,
        onerror = function(_, context, operation, err)
            io.stderr:write(string.format("HTTP server error in %s %s: %s\n", context, operation, err))
        end
    }))

    assert(self.server:listen())
    print("Server started on " .. self.host .. ":" .. self.port)
    self.server:loop()
end

return server
