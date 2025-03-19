local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and self.Name == "" and
       (args[1] == "Attack" or args[1] == "Heavy" or args[1] == "Stomp") and
       typeof(args[2]) == "table"
    then
        local selectedStyle = getgenv().selectedStyle
        if selectedStyle and selectedStyle ~= "" then
            args[2]["Class"] = selectedStyle
        end
    end

    return old(self, ...)
end)

setreadonly(mt, true)
