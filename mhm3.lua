local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

local currentStyle = ""

local function updateCurrentStyle()
    local invmenu = game:GetService("Players").LocalPlayer.PlayerGui.Main.Menus.Inventory.Menus.Styles.List

    for _, v in pairs(invmenu:GetDescendants()) do
        if v:IsA("ImageLabel") and v.Visible and v.Parent and v.Parent.Parent then
            local styleName = v.Parent.Parent.Name
            if currentStyle ~= styleName then
                currentStyle = styleName
            end
            return
        end
    end
end

spawn(
    function()
        while wait(0.5) do
            pcall(updateCurrentStyle)
        end
    end
)

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
            if currentStyle ~= "" then
                args[2]["Class"] = currentStyle
            end
            return old(self, unpack(args))
        end

        return old(self, ...)
    end
)

setreadonly(mt, true)
