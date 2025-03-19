local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

local function updateSelectedStyle(args)
    if getgenv().SelectedStyle ~= "" then
        args[2]["Class"] = getgenv().SelectedStyle
    end
end

mt.__namecall =
    newcclosure(
    function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if
            method == "FireServer" and self.Name == "" and
                (args[1] == "Attack" or args[1] == "Heavy" or args[1] == "Stomp") and
                typeof(args[2]) == "table"
         then
            updateSelectedStyle(args)
            return old(self, unpack(args))
        end

        return old(self, ...)
    end
)

setreadonly(mt, true)
