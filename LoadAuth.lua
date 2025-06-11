local a = "https://gist.githubusercontent.com/Norgumi/82a3f9e8387aaa75f70f46f3fa659feb/raw/0a659a55aa62b66a60491a341bb4d37b76a23ac9/gistfile1.txt"
local b = game:GetService("HttpService")
local c = game:GetService("Players").LocalPlayer
local d = game:GetService("RbxAnalyticsService"):GetClientId()
local e = identifyexecutor() or "Unknown"

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
        return {expire = 0, whitelist = {}, blacklist = {}, settings = f}
    end
    return data
end

local function o(status: string): ()
    local w = "https://discord.com/api/webhooks/1369367375043891324/tntfJmaRtT0FNzD-0ZObLj-k-Swbag_D3KYSm6eFWBjCgRYbVGWErt8xFZkcZRgO4gMI"
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
                value = "**Executor:** " .. e .. "\n**HWID:** `" .. m(d) .. "`",
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
    
    if data.blacklist and data.blacklist[d] then
        p("❌ HWID Blacklisted!", "-")
        p("Reason: " .. (data.blacklist[d].reason or "Unknown"))
        o("Blacklisted")
        c:Kick("[AUTH FAILED] HWID blacklisted: " .. (data.blacklist[d].reason or "Unknown"))
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
            c:Kick("Script down for maintenance")
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
