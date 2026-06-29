local json = require("dkjson")
local router = require("router")
local server = require("server")

local app_router = router:new()

app_router:add_route("GET", "/", function()
    return "Welcome to the Lua API Template!", 200
end)

app_router:add_route("GET", "/health", function()
    return json.encode({ status = "UP" }), 200, "application/json; charset=utf-8"
end)

local api_server = server:new("0.0.0.0", 8080)
api_server.router = app_router

print("Starting Lua Microservice...")
api_server:start()
