local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" then
        if args[1] == "Grab" then
            args[2] = true
            args[3] = false
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

local function hook(func)
    if func and typeof(func) == "function" then
        hookfunction(func, function(cd, movetype, ...)
            if movetype == "GRAB" then
                return 0, movetype, ...
            end
            return cd, movetype, ...
        end)
    end
end

for _, inst in pairs(getgc()) do
    if typeof(inst) == "function" and islclosure(inst) then
        local info = debug.getinfo(inst)
        if info and info.name == "DoCooldown" then
            hook(inst)
        end
    end
end
