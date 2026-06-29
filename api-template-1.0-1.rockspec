package = "api-template"
version = "1.0-1"
source = {
  url = "git://github.com/your-username/LuaApiTemplate"
}
description = {
  summary = "Lua API microservice template",
  detailed = "A small Lua API service template using lua-http for HTTP parsing and I/O.",
  homepage = "https://github.com/your-username/LuaApiTemplate",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1, < 5.2",
  "http == 0.4-0",
  "dkjson >= 2.8"
}
build = {
  type = "builtin",
  modules = {
    server = "src/server.lua",
    router = "src/router.lua"
  }
}
