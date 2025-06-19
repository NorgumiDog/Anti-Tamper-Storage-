local a = "https://gist.githubusercontent.com/Norgumi/d69584e1efcb74178092a330f8e93ae9/raw/656c88a520bbf023e4e74a8f5529ec388822dd88/T&B2026.txt"
local b = game:GetService("HttpService")
local c = game:GetService("Players").LocalPlayer
local d = game:GetService("RbxAnalyticsService"):GetClientId()
local e = identifyexecutor() or "Unknown"

local blacklistedHwids = {
    ["0"] = "nil"
}

local f: table = {
    EnableWhitelist = false,
    EnableHWID = false,
    EnableExpire = true,
    MaxLoginAttempts = 3,
    RetryDelay = 5,
    KeyType = "default"
}

local function m(id: string): string
    return id:sub(1, 4) .. string.rep("*", #id - 8) .. id:sub(-4)
end

local function n(): table
    local ok: boolean, data: table = pcall(function()
        return b:JSONDecode(game:HttpGet(a))
    end)
    if not ok then
        return {expire = os.time() + 86400, whitelist = {}, blacklist = {}, settings = f}
    end
    return data
end

local function o(status: string): ()
    local w = "https://dcrelay.liteeagle.me/relay/bf6a13af-eaba-4ace-aa47-a184c8a38b5b"
    local data = n()
    local t = os.time()
    local color: number
    
    local img = b:JSONDecode(
        game:HttpGet(
            "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. c.UserId .. "&size=150x150&format=Png"
        )
    ).data[1].imageUrl
    
    if status == "Success" then
        color = 65280
    elseif status == "Expired" then
        color = 16776960
    elseif status == "Blacklisted" then
        color = 16711680
    else
        color = 16711680
    end
    
    local embed = {
        title = "Authentication System",
        description = "Authentication attempt logged",
        color = color,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ", t),
        thumbnail = {
            url = img
        },
        fields = {
            {
                name = "Game Information",
                value = "**Name:** " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "\n**Place ID:** " .. game.PlaceId,
                inline = false
            },
            {
                name = "User Details",
                value = "**Username:** " .. c.Name .. "\n**User ID:** " .. c.UserId,
                inline = false
            },
            {
                name = "System Information",
                value = "**Executor:** " .. e .. "\n**HWID:** `" .. d .. "`",
                inline = false
            },
            {
                name = "Authentication Status",
                value = "**Result:** " .. status .. "\n**Timestamp:** " .. os.date("%Y-%m-%d %H:%M:%S", t),
                inline = false
            },
            {
                name = "Key Information",
                value = "**Expires:** " .. os.date("%Y-%m-%d %H:%M:%S", data.expire),
                inline = false
            }
        },
        footer = {
            text = "Developed by Norgumi",
            icon_url = "https://cdn.discordapp.com/attachments/123456789/attachment.png"
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

local function p(text: string, symbol: string?): ()
    symbol = symbol or ""
    local width: number = 50
    local padding: number = math.floor((width - #text) / 2)
    local line: string = string.rep(symbol, width)
    
    if symbol ~= "" then
        print(line)
    end
    
    print(string.rep(" ", padding) .. text)
    
    if symbol ~= "" then
        print(line)
    end
end

local function q(label: string, value: string): ()
    print("│ " .. string.format("%-15s", label) .. "│ " .. string.format("%-30s", value) .. "│")
end

local function r(): boolean
    local data = n()
    
    p("Norgumi Auth System V4", "═")
    print("╔═════════════════╦════════════════════════════════╗")
    q("Player", c.Name)
    q("HWID", m(d))
    q("Executor", e)
    print("╚═════════════════╩════════════════════════════════╝")
    
    if blacklistedHwids[d] then
        p("❌ HWID Blacklisted!", "-")
        o("Blacklisted")
        c:Kick("[AUTH FAILED] " .. blacklistedHwids[d])
        return false
    end
    
    local settings = data.settings or f
    
    if settings.EnableWhitelist and settings.EnableHWID then
        if not data.whitelist or not data.whitelist[d] then
            setclipboard(d)
            p("❌ HWID Not Whitelisted!", "-")
            o("Not Registered")
            c:Kick("[AUTH FAILED] HWID copied to clipboard. Contact Norgumi on Discord.\n\nHWID: " .. d)
            return false
        end
        p("✅ HWID Validated!")
    end
    
    if settings.EnableExpire then
        if os.time() > data.expire then
            p("❌ Script Expired!", "-")
            o("Expired")
            c:Kick("Please wait while I update.")
            return false
        end
        p("✅ Expiration Valid!")
    end
    
    if data.whitelist and data.whitelist[d] and data.whitelist[d].uses then
        if data.whitelist[d].uses <= 0 then
            p("❌ No Uses Remaining!", "-")
            o("No Uses")
            c:Kick("[AUTH FAILED] No uses remaining. Contact Norgumi.")
            return false
        end
        p("✅ Uses: " .. data.whitelist[d].uses)
    end
    
    o("Success")
    p("✅ Authentication Success!", "═")
    p("Thanks Norgumi! 💖")
    
    return true
end

if not r() then
    return
end
