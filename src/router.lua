local router = {}
router.__index = router

local function normalize_method(method)
    if type(method) ~= "string" then
        return nil
    end
    return method:upper()
end

local function normalize_path(path)
    if type(path) ~= "string" or path == "" then
        return nil
    end

    local route_path = path:match("^[^?#]+")
    if not route_path or route_path:sub(1, 1) ~= "/" then
        return nil
    end

    return route_path
end

function router:new()
    local instance = {
        routes = {}
    }
    return setmetatable(instance, self)
end

function router:add_route(method, path, handler)
    method = normalize_method(method)
    path = normalize_path(path)

    assert(method, "method must be a string")
    assert(path, "path must be an absolute path")
    assert(type(handler) == "function", "handler must be a function")

    if not self.routes[method] then
        self.routes[method] = {}
    end
    self.routes[method][path] = handler
end

function router:get_handler(method, path)
    method = normalize_method(method)
    path = normalize_path(path)

    if not method or not path then
        return nil
    end

    if self.routes[method] and self.routes[method][path] then
        return self.routes[method][path]
    end
    return nil
end

return router
