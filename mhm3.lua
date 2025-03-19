local mt = getrawmetatable(game)
setreadonly(mt, false)

local old_index = mt.__index
local old_namecall = mt.__namecall

getgenv().currentStyle = ""

getgenv().updateCurrentStyle = function()
    local player = game:GetService("Players").LocalPlayer
    if player and player.PlayerGui then
        local inv = player.PlayerGui.Main.Menus.Inventory.Menus.Styles.List
        for _, v in pairs(inv:GetDescendants()) do
            if v:IsA("ImageLabel") and v.Visible and v.Parent and v.Parent.Parent then
                getgenv().currentStyle = v.Parent.Parent.Name
                return
            end
        end
    end
end

pcall(getgenv().updateCurrentStyle)

getgenv().setStyle = function(styleName)
    getgenv().currentStyle = styleName
end

mt.__index = newcclosure(function(a, b)
    if tostring(a) == "Class" then
        if tostring(b) == "Value" then
            return getgenv().currentStyle
        end
    end
    return old_index(a, b)
end)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" and self.Name == "" and
       (args[1] == "Attack" or args[1] == "Heavy" or args[1] == "Stomp") and
       typeof(args[2]) == "table" then
        if getgenv().currentStyle ~= "" then
            args[2]["Class"] = getgenv().currentStyle
        end
        return old_namecall(self, unpack(args))
    end
    
    return old_namecall(self, ...)
end)

getgenv().styles = {
    "Jeet Kune Do",
    "SAVAGE",
    "Karate",
    "Ninja",
    "Kicker",
    "Heavy Hitter",
    "Aggressive",
    "Hitman",
    "Hawk",
    "Muay Thai",
    "CRASH OUT",
    "Jaw Breaker",
    "Philly",
    "Stud",
    "Squabble",
    "Bones",
    "Peak A Boo",
    "Striker",
    "Boxer",
    "Slap Boxer",
    "Amateur",
    "Baddie",
    "Compound V"
}

getgenv().get_styles = function() 
    return getgenv().styles 
end

setreadonly(mt, true)
