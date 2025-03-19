local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

local style = ""

local function update()
    local inv = game:GetService("Players").LocalPlayer.PlayerGui.Main.Menus.Inventory.Menus.Styles.List
    for _, v in pairs(inv:GetDescendants()) do
        if v:IsA("ImageLabel") and v.Visible and v.Parent and v.Parent.Parent then
            style = v.Parent.Parent.Name
            return
        end
    end
end

pcall(update)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" and self.Name == "" and
       (args[1] == "Attack" or args[1] == "Heavy" or args[1] == "Stomp") and
       typeof(args[2]) == "table" then
        if style ~= "" then
            args[2]["Class"] = style
        end
        return old(self, unpack(args))
    end
    
    return old(self, ...)
end)

setreadonly(mt, true)

getgenv().setStyle = function(newStyle)
    style = newStyle
end
