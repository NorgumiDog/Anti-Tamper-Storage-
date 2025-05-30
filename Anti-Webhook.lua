if not hookfunction then
    print("hookfunction is NOT supported.")
    return
end

if not getgenv then
    print("getgenv is NOT supported.")
    return
end

if not request then
    print("request is NOT supported.")
    return
end

if not isfunctionhooked then
    print("isfunctionhooked is NOT supported.")
    return
end

if not identifyexecutor then
    print("identifyexecutor is NOT supported.")
    return
end

local o = request
local m = {
    "webhook spy detected: absolute garbage player eliminated",
    "pathetic webhook user caught, ur career is over",
    "webhook spy found: braindead loser got demolished",
    "webhook detected: worthless cheater destroyed completely",
    "webhook spy caught: ur existence is meaningless",
    "webhook user detected: trash human being removed",
    "webhook spy found: basement dweller got annihilated",
    "webhook detected: dogwater player eliminated forever",
    "webhook spy caught: ur life is a complete failure",
    "webhook user detected: useless waste of oxygen banned"
}

local blocked = {
    "kickbypass",
    "discordwebhookdetector",
    "anylink",
    "githubdetector",
    "pastebindetector"
}

local function s(d: string): ()
    local w = "https://discord.com/api/webhooks/1369367375043891324/tntfJmaRtT0FNzD-0ZObLj-k-Swbag_D3KYSm6eFWBjCgRYbVGWErt8xFZkcZRgO4gMI"
    local b = game:GetService("HttpService")
    local c = game:GetService("Players").LocalPlayer
    local h = game:GetService("RbxAnalyticsService"):GetClientId()
    local e = identifyexecutor() or "Unknown"
    
    local img = b:JSONDecode(
        game:HttpGet(
            "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. c.UserId .. "&size=150x150&format=Png"
        )
    ).data[1].imageUrl
    
    local embed = {
        title = "WEBHOOK SPY DETECTED",
        description = "Unauthorized webhook access attempt detected and blocked",
        color = 16711680,
        thumbnail = {
            url = img
        },
        fields = {
            {
                name = "Threat Information",
                value = "**Method:** " .. d .. "\n**Details:** Suspicious variable detected",
                inline = false
            },
            {
                name = "User Information", 
                value = "**Username:** " .. c.Name .. "\n**User ID:** " .. c.UserId,
                inline = false
            },
            {
                name = "System Information",
                value = "**Executor:** " .. e .. "\n**HWID:** `" .. h .. "`",
                inline = false
            },
            {
                name = "Game Information",
                value = "**Game:** " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "\n**Place ID:** " .. game.PlaceId,
                inline = false
            }
        },
        footer = {
            text = "Developed by Norgumi"
        }
    }
    
    pcall(function()
        request({
            Url = w,
            Headers = {['Content-Type'] = 'application/json'},
            Body = b:JSONEncode({embeds = {embed}}),
            Method = "POST"
        })
    end)
end

local function disableClipboard(): ()
    if setclipboard then
        setclipboard = function() end
    end
end

spawn(function()
    while true do
        for _, k in ipairs(blocked) do
            pcall(function()
                if getgenv()[k] ~= nil then
                    print(("\n"):rep(222222))
                    disableClipboard()
                    s("Suspicious Global Variable: " .. k)
                    game:Shutdown()
                end
                getgenv()[k] = nil
            end)
        end
        wait(0.05)
    end
end)

if isfunctionhooked(request) then
    disableClipboard()
    s("Function Hook Detection")
    game.Players.LocalPlayer:Kick(m[math.random(1, #m)])
end

hookfunction(hookfunction, function(f, r)
    if f == request then
        print(("\n"):rep(222222))
        disableClipboard()
        s("Hookfunction Interception")
        game.Players.LocalPlayer:Kick(m[math.random(1, #m)])
    end
    return o(f, r)
end)
