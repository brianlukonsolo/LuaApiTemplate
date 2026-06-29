local router = require("src.router")

describe("Router", function()
    local app_router

    before_each(function()
        app_router = router:new()
    end)

    it("should add a route correctly", function()
        app_router:add_route("GET", "/test", function() return "ok" end)
        local handler = app_router:get_handler("GET", "/test")
        assert(handler ~= nil)
        assert(handler() == "ok")
    end)

    it("should return nil for non-existent route", function()
        local handler = app_router:get_handler("GET", "/notfound")
        assert(handler == nil)
    end)

    it("should handle different methods separately", function()
        app_router:add_route("GET", "/test", function() return "get" end)
        app_router:add_route("POST", "/test", function() return "post" end)
        
        assert(app_router:get_handler("GET", "/test")() == "get")
        assert(app_router:get_handler("POST", "/test")() == "post")
    end)

    it("should normalize methods and ignore query strings", function()
        app_router:add_route("get", "/health", function() return "ok" end)

        assert(app_router:get_handler("GET", "/health?verbose=true")() == "ok")
    end)

    it("should reject invalid routes", function()
        assert.has_error(function()
            app_router:add_route("GET", "relative", function() end)
        end)

        assert.has_error(function()
            app_router:add_route("GET", "/test", "not a function")
        end)
    end)
end)
