local uis = game:GetService("UserInputService")

local isMobile = uis.TouchEnabled and not uis.KeyboardEnabled

if isMobile then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Norgumi/RoScripts/refs/heads/main/TNFStorage.lua"))()
    return
end

local p = game:GetService("Players").LocalPlayer
local g = game:GetService("CoreGui")
local ts = game:GetService("TweenService")

local fnl = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Code1Tech/utils/main/notification.lua'))()

local function notify(title, text, duration)
    title = title or "Notification"
    text = text or "No text provided."
    duration = duration or 5
    
    fnl:MakeNotification({
        Title = title,
        Text = text,
        Duration = duration
    })
end

local s = Instance.new("ScreenGui")
s.Name = "KeySystem"
s.Parent = g

local m = Instance.new("Frame")
m.Size = UDim2.new(0, 450, 0, 300)
m.Position = UDim2.new(0.5, -225, 0.5, -150)
m.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
m.BorderSizePixel = 0
m.Parent = s

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 16)
mc.Parent = m

local ic = Instance.new("ImageLabel")
ic.Size = UDim2.new(0, 32, 0, 32)
ic.Position = UDim2.new(0, 20, 0, 20)
ic.BackgroundTransparency = 1
ic.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
ic.ImageColor3 = Color3.fromRGB(88, 101, 242)
ic.Parent = m

local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(0.7, 0, 0, 32)
tl.Position = UDim2.new(0, 65, 0, 20)
tl.BackgroundTransparency = 1
tl.Text = "Discord Verification Required"
tl.TextColor3 = Color3.fromRGB(255, 255, 255)
tl.TextSize = 18
tl.Font = Enum.Font.GothamBold
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.Parent = m

local d = Instance.new("TextLabel")
d.Size = UDim2.new(0.85, 0, 0, 40)
d.Position = UDim2.new(0.075, 0, 0, 80)
d.BackgroundTransparency = 1
d.Text = "Please enter your Discord User ID to verify server membership and continue."
d.TextColor3 = Color3.fromRGB(160, 160, 170)
d.TextSize = 14
d.Font = Enum.Font.Gotham
d.TextWrapped = true
d.TextXAlignment = Enum.TextXAlignment.Left
d.Parent = m

local tf = Instance.new("Frame")
tf.Size = UDim2.new(0.85, 0, 0, 45)
tf.Position = UDim2.new(0.075, 0, 0, 140)
tf.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
tf.BorderSizePixel = 0
tf.Parent = m

local tfc = Instance.new("UICorner")
tfc.CornerRadius = UDim.new(0, 8)
tfc.Parent = tf

local tfs = Instance.new("UIStroke")
tfs.Color = Color3.fromRGB(60, 63, 69)
tfs.Thickness = 1
tfs.Parent = tf

local t = Instance.new("TextBox")
t.Size = UDim2.new(0.9, 0, 0.8, 0)
t.Position = UDim2.new(0.05, 0, 0.1, 0)
t.BackgroundTransparency = 1
t.Text = ""
t.PlaceholderText = "Discord User ID"
t.PlaceholderColor3 = Color3.fromRGB(114, 118, 125)
t.TextColor3 = Color3.fromRGB(220, 221, 222)
t.TextSize = 14
t.Font = Enum.Font.Gotham
t.TextXAlignment = Enum.TextXAlignment.Left
t.ClearTextOnFocus = false
t.Parent = tf

local b = Instance.new("TextButton")
b.Size = UDim2.new(0.35, 0, 0, 40)
b.Position = UDim2.new(0.325, 0, 0, 210)
b.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
b.BorderSizePixel = 0
b.Text = "Verify Access"
b.TextColor3 = Color3.fromRGB(255, 255, 255)
b.TextSize = 14
b.Font = Enum.Font.GothamBold
b.Parent = m

local bc = Instance.new("UICorner")
bc.CornerRadius = UDim.new(0, 8)
bc.Parent = b

local st = Instance.new("TextLabel")
st.Size = UDim2.new(0.85, 0, 0, 20)
st.Position = UDim2.new(0.075, 0, 0, 270)
st.BackgroundTransparency = 1
st.Text = ""
st.TextColor3 = Color3.fromRGB(237, 66, 69)
st.TextSize = 12
st.Font = Enum.Font.Gotham
st.TextXAlignment = Enum.TextXAlignment.Center
st.Parent = m

t.Focused:Connect(function()
    tfs.Color = Color3.fromRGB(88, 101, 242)
end)

t.FocusLost:Connect(function()
    tfs.Color = Color3.fromRGB(60, 63, 69)
end)

b.MouseEnter:Connect(function()
    ts:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(108, 121, 255)}):Play()
end)

b.MouseLeave:Connect(function()
    ts:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
end)

b.MouseButton1Click:Connect(function()
    local u = t.Text:gsub("%s+", "")
    if u == "" or #u < 17 then 
        st.Text = "Please enter a valid Discord User ID"
        return 
    end
    
    b.Text = "Verifying..."
    b.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
    st.Text = ""
    
    local h = request or http_request
    local r = h({
        Url = "https://discord.com/api/v10/guilds/1356869384445886628/members/" .. u,
        Method = "GET",
        Headers = {
            ["Authorization"] = "Bot MTM3NDUwODg0Mjc5NjMyMjg2Nw.G0kphR.NwR1OzCi9O5p4qYV4SZDjRRjA_wihrxy-w5ob4"
        }
    })
    
    if r.StatusCode == 200 then
        st.TextColor3 = Color3.fromRGB(67, 181, 129)
        st.Text = "✓ Verification successful! Loading script..."
        wait(1.5)
        s:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Norgumi/RoScripts/refs/heads/main/TNFStorage.lua"))()
    else
        st.Text = "❌ Access denied - Join our Discord server first"
        toclipboard("https://discord.gg/UrSbm8dqAz")
        notify("Discord Verification", "Copied discord server link to clipboard", 4)
        b.Text = "Verify Access"
        b.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        wait(4)
        st.Text = ""
    end
end)
