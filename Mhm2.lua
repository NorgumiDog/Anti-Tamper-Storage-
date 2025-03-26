local limbs = {"HumanoidRootPart", "Head", "LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg", "LowerTorso", "RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg", "UpperTorso"}

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and self.Name == "" then
        local attackType = args[1]
        if attackType == "Attack" or attackType == "Stomp" or attackType == "Heavy" then
            local character = args[2]["Character"]

            if getgenv().selectedLimb then 
                args[2]["Limb"] = getgenv().selectedLimb
                args[2]["Hit"] = character[getgenv().selectedLimb]
            end
            return old(self, unpack(args))
        end
    end
    
    return old(self, ...)
end)

setreadonly(mt, true)
