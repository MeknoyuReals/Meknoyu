-- [[ ULTRA MEKNOYU GUI (LOCKED & PROTECTED) ]] --
local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local mps = game:GetService("MarketplaceService")
local lighting = game:GetService("Lighting")
local guiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local HapticService = game:GetService("HapticService")
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local cam = workspace.CurrentCamera
local mouse = plr:GetMouse()

-- // CONFIG DISCORD WEBHOOK //
local DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_URL_HERE"

-- // FUNGSI PEMBUAT GRADIENT (TERANG & JELAS) //
local function applyBlackGreyGradient(instance)
    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 95, 105)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 65))
    })
    uiGradient.Parent = instance
    return uiGradient
end

-- // SCREEN GUI UTAMA //
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mekno_Clean_Final"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

-- ==========================================
--        SISTEM NOTIFIKASI CUSTOM UI
-- ==========================================
local notifContainer = Instance.new("Frame", screenGui)
notifContainer.Size = UDim2.new(0, 250, 1, 0)
notifContainer.Position = UDim2.new(1, -260, 0, 10)
notifContainer.BackgroundTransparency = 1

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local function customNotify(title, text, duration)
    duration = duration or 4
    local frame = Instance.new("Frame", notifContainer)
    frame.Size = UDim2.new(0, 240, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    frame.BackgroundTransparency = 0.1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(frame)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 0, 128)

    local tLabel = Instance.new("TextLabel", frame)
    tLabel.Size = UDim2.new(1, -10, 0, 20)
    tLabel.Position = UDim2.new(0, 10, 0, 5)
    tLabel.Text = title
    tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 12
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1

    local bLabel = Instance.new("TextLabel", frame)
    bLabel.Size = UDim2.new(1, -15, 0, 30)
    bLabel.Position = UDim2.new(0, 10, 0, 25)
    bLabel.Text = text
    bLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    bLabel.Font = Enum.Font.Gotham
    bLabel.TextSize = 10
    bLabel.TextWrapped = true
    bLabel.TextXAlignment = Enum.TextXAlignment.Left
    bLabel.BackgroundTransparency = 1

    task.spawn(function()
        task.wait(duration)
        local tw = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        TweenService:Create(tLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(bLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        tw:Play()
        tw.Completed:Connect(function() frame:Destroy() end)
    end)
end

-- ==========================================
--        SEND DISCORD WEBHOOK LOGIC
-- ==========================================
local function sendWebhook()
    if DISCORD_WEBHOOK_URL == "" or DISCORD_WEBHOOK_URL:find("YOUR_WEBHOOK") then return end
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local data = {
            ["embeds"] = {{
                ["title"] = "Meknoyu GUI Executed!",
                ["color"] = 16711808,
                ["fields"] = {
                    {["name"] = "Player", ["value"] = plr.Name .. " (" .. plr.UserId .. ")", ["inline"] = true},
                    {["name"] = "Game ID", ["value"] = tostring(game.PlaceId), ["inline"] = true},
                    {["name"] = "Job ID", ["value"] = tostring(game.JobId), ["inline"] = false}
                },
                ["footer"] = {["text"] = "Meknoyu System Logs"}
            }}
        }
        req({
            Url = DISCORD_WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- ==========================================
--        MAIN MEKNOYU ENGINE LOAD
-- ==========================================
local function mainEngineLoad()
sendWebhook()

local states = {
    fling = false, noclip = false, infJump = false, antiafk = false, autoClick = false,
    sit = false, invis = false, antifling = false, antiFall = false,
    swimWater = false, useAllTools = false, esp = false
}

local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid", 10)
local hrp = char:WaitForChild("HumanoidRootPart", 10)
local lastPos = nil
local swimConnection, autoClickConnection = nil, nil
local swimPart = nil

local function setupChar(c)
    char = c; hum = c:WaitForChild("Humanoid", 10); hrp = c:WaitForChild("HumanoidRootPart", 10)
    if hrp then lastPos = hrp.CFrame end
end
if plr.Character then setupChar(plr.Character) end
plr.CharacterAdded:Connect(setupChar)

customNotify("Meknoyu GUI", "System Fully Loaded!", 5)

-- // MAIN GUI STRUCTURE (UKURAN RASIO 17 x 10 => 510 x 300) //
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 510, 0, 300)
main.Position = UDim2.new(0.5, -255, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
main.BackgroundTransparency = 0
main.Active = true; main.Draggable = true; Instance.new("UICorner", main)
applyBlackGreyGradient(main)

-- ==========================================
--        SISTEM DISPLAY FPS & MS (PING)
-- ==========================================
local statsLabel = Instance.new("TextLabel", main)
statsLabel.Size = UDim2.new(0, 120, 0, 20)
statsLabel.Position = UDim2.new(1, -210, 0, 7)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "FPS: -- | MS: --"
statsLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statsLabel.Font = Enum.Font.Code
statsLabel.TextSize = 10
statsLabel.TextXAlignment = Enum.TextXAlignment.Right

local lastFrameTime = os.clock()
local frameCount = 0
rs.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = os.clock()
    if currentTime - lastFrameTime >= 1 then
        local fps = math.floor(frameCount / (currentTime - lastFrameTime))
        local ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
        statsLabel.Text = "FPS: " .. fps .. " | MS: " .. ping
        frameCount = 0
        lastFrameTime = currentTime
    end
end)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2.5

local miniBtn = Instance.new("TextButton", screenGui)
miniBtn.Size = UDim2.new(0, 120, 0, 32)
miniBtn.Position = UDim2.new(0.5, -60, 0.12, 0)
miniBtn.Text = "Meknoyu GUI"
miniBtn.BackgroundColor3 = Color3.fromRGB(55,55,65)
miniBtn.BackgroundTransparency = 0
miniBtn.TextTransparency = 0
miniBtn.TextColor3 = Color3.fromRGB(255,255,255)
miniBtn.TextStrokeTransparency = 0
miniBtn.TextStrokeColor3 = Color3.new(0,0,0)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 12
miniBtn.Draggable = true
miniBtn.Visible = false
applyBlackGreyGradient(miniBtn)

Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 6)
local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Thickness = 1.8

rs.RenderStepped:Connect(function() 
    local hue = (tick() * 0.15) % 1
    stroke.Color = Color3.fromHSV(hue, 0.8, 1) 
    miniStroke.Color = Color3.fromHSV(hue, 0.8, 1)
end)

-- ==========================================
--        3 BULATAN KECIL DI POJOK KIRI ATAS
-- ==========================================
local topDotsContainer = Instance.new("Frame", main)
topDotsContainer.Size = UDim2.new(0, 50, 0, 15)
topDotsContainer.Position = UDim2.new(0, 8, 0, 8)
topDotsContainer.BackgroundTransparency = 1

local dotRed = Instance.new("Frame", topDotsContainer)
dotRed.Size = UDim2.new(0, 10, 0, 10)
dotRed.Position = UDim2.new(0, 0, 0.5, -5)
dotRed.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
dotRed.BorderSizePixel = 0
Instance.new("UICorner", dotRed).CornerRadius = UDim.new(1, 0)

local dotYellow = Instance.new("Frame", topDotsContainer)
dotYellow.Size = UDim2.new(0, 10, 0, 10)
dotYellow.Position = UDim2.new(0, 14, 0.5, -5)
dotYellow.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
dotYellow.BorderSizePixel = 0
Instance.new("UICorner", dotYellow).CornerRadius = UDim.new(1, 0)

local dotGreen = Instance.new("Frame", topDotsContainer)
dotGreen.Size = UDim2.new(0, 10, 0, 10)
dotGreen.Position = UDim2.new(0, 28, 0.5, -5)
dotGreen.BackgroundColor3 = Color3.fromRGB(39, 201, 63)
dotGreen.BorderSizePixel = 0
Instance.new("UICorner", dotGreen).CornerRadius = UDim.new(1, 0)

local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, -210, 0, 25); header.Position = UDim2.new(0, 65, 0, 5)
header.Text = "Meknoyu Hub | Natural Disaster Survival"; header.BackgroundTransparency = 1; header.TextColor3 = Color3.new(1,1,1); header.Font = Enum.Font.GothamBold; header.TextSize = 14; header.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", main); closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 7); closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.new(1,0,0); closeBtn.TextStrokeTransparency = 0; closeBtn.BackgroundColor3 = Color3.fromRGB(55,55,65); Instance.new("UICorner", closeBtn); applyBlackGreyGradient(closeBtn)

-- // KUSTOM KEYBIND E //
local currentToggleKey = Enum.KeyCode.E
local bindBox = Instance.new("TextBox", main)
bindBox.Size = UDim2.new(0, 35, 0, 30)
bindBox.Position = UDim2.new(1, -75, 0, 7)
bindBox.Text = "E"
bindBox.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
bindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
bindBox.Font = Enum.Font.GothamBold
bindBox.TextSize = 12
bindBox.ClearTextOnFocus = false
Instance.new("UICorner", bindBox)
applyBlackGreyGradient(bindBox)

bindBox.FocusLost:Connect(function()
    local text = string.upper(bindBox.Text)
    if #text > 0 then
        local keyEnum = Enum.KeyCode[string.sub(text, 1, 1)]
        if keyEnum then currentToggleKey = keyEnum end
    end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == currentToggleKey then
        if main.Visible then closeBtn.MouseButton1Click:Fire() else miniBtn.MouseButton1Click:Fire() end
    end
end)

local originalMainSize = UDim2.new(0, 510, 0, 300)
local originalMainPos = UDim2.new(0.5, -255, 0.5, -150)
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

closeBtn.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(main.Position.X.Scale, main.Position.Y.Offset + 150, main.Position.Y.Scale, main.Position.Y.Offset + 150)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        main.Visible = false
        miniBtn.Visible = true
        main.Size = originalMainSize
        main.Position = originalMainPos
    end)
end)

miniBtn.MouseButton1Click:Connect(function()
    miniBtn.Visible = false
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = originalMainPos
    main.Visible = true
    TweenService:Create(main, tweenInfo, {Size = originalMainSize, Position = originalMainPos}):Play()
end)

local tabContainer = Instance.new("ScrollingFrame", main)
tabContainer.Size = UDim2.new(0, 100, 1, -150)
tabContainer.Position = UDim2.new(0, 5, 0, 48)
tabContainer.BackgroundTransparency = 1
tabContainer.ScrollBarThickness = 0
tabContainer.CanvasSize = UDim2.new(0, 0, 1.8, 0)
local UIList = Instance.new("UIListLayout", tabContainer); UIList.Padding = UDim.new(0, 5)

-- // PROFIL & MAP (POSISI AMAN) //
local profileFrame = Instance.new("Frame", main)
profileFrame.Size = UDim2.new(0, 100, 0, 95)
profileFrame.Position = UDim2.new(0, 5, 1, -98)
profileFrame.BackgroundTransparency = 1

local profilePic = Instance.new("ImageLabel", profileFrame)
profilePic.Size = UDim2.new(0, 32, 0, 32)
profilePic.Position = UDim2.new(0, 2, 0, 2)
profilePic.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
profilePic.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=150&height=150&format=png"
Instance.new("UICorner", profilePic).CornerRadius = UDim.new(1, 0)
local profileStroke = Instance.new("UIStroke", profilePic)
profileStroke.Thickness = 1.5
rs.RenderStepped:Connect(function() profileStroke.Color = Color3.fromHSV((tick() * 0.3) % 1, 0.8, 1) end)

local displayNameLabel = Instance.new("TextLabel", profileFrame)
displayNameLabel.Size = UDim2.new(0, 60, 0, 12); displayNameLabel.Position = UDim2.new(0, 38, 0, 2)
displayNameLabel.BackgroundTransparency = 1; displayNameLabel.Text = "Name: " .. plr.DisplayName
displayNameLabel.TextColor3 = Color3.fromRGB(180, 80, 255); displayNameLabel.Font = Enum.Font.GothamBold; displayNameLabel.TextSize = 8; displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local useridLabel = Instance.new("TextLabel", profileFrame)
useridLabel.Size = UDim2.new(0, 60, 0, 12); useridLabel.Position = UDim2.new(0, 38, 0, 14)
useridLabel.BackgroundTransparency = 1; useridLabel.Text = "UserID: " .. plr.UserId
useridLabel.TextColor3 = Color3.fromRGB(220, 220, 220); useridLabel.Font = Enum.Font.GothamMedium; useridLabel.TextSize = 7; useridLabel.TextXAlignment = Enum.TextXAlignment.Left

local mapIcon = Instance.new("ImageLabel", profileFrame)
mapIcon.Size = UDim2.new(0, 22, 0, 22); mapIcon.Position = UDim2.new(0, 2, 0, 38); mapIcon.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
Instance.new("UICorner", mapIcon).CornerRadius = UDim.new(0, 4)

local mapNameLabel = Instance.new("TextLabel", profileFrame)
mapNameLabel.Size = UDim2.new(0, 72, 0, 25); mapNameLabel.Position = UDim2.new(0, 28, 0, 36)
mapNameLabel.BackgroundTransparency = 1; mapNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
mapNameLabel.Font = Enum.Font.GothamBold; mapNameLabel.TextSize = 8; mapNameLabel.TextWrapped = true; mapNameLabel.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    local success, info = pcall(function() return mps:GetProductInfo(game.PlaceId) end)
    if success and info then
        mapNameLabel.Text = "Name Map:\n" .. info.Name
        mapIcon.Image = (info.IconImageAssetId and info.IconImageAssetId > 0) and ("rbxassetid://" .. tostring(info.IconImageAssetId)) or "rbxassetid://6023426915"
    else
        mapNameLabel.Text = "Name Map:\n" .. game.Name
        mapIcon.Image = "rbxassetid://6023426915"
    end
end)

local pages = Instance.new("Frame", main); pages.Size = UDim2.new(1, -115, 1, -50); pages.Position = UDim2.new(0, 110, 0, 45); pages.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", pages); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0, 0, 4.5, 0)
    local grid = Instance.new("UIGridLayout", p); grid.CellSize = UDim2.new(0.48, 0, 0, 32); grid.CellPadding = UDim2.new(0, 5, 0, 5)
    return p
end

local pageMain = createPage("Main")
local pageAutomatic = createPage("Automatic")
local pageAnti = createPage("Anti")

local function addTab(name, targetPage)
    local btn = Instance.new("TextButton", tabContainer)
    btn.Size = UDim2.new(1, 0, 0, 26); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(65, 65, 75); btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextStrokeTransparency = 0.5; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 2
    Instance.new("UICorner", btn); applyBlackGreyGradient(btn)
    btn.MouseButton1Click:Connect(function() 
        for _, v in pairs(pages:GetChildren()) do v.Visible = false end; targetPage.Visible = true 
    end)
end

addTab("Main", pageMain)
addTab("Automatic", pageAutomatic)
addTab("Anti", pageAnti)
pageMain.Visible = true

-- ==========================================
--        LEADERBOARD POPUP UI
-- ==========================================
local lbGui = Instance.new("Frame", screenGui)
lbGui.Size = UDim2.new(0, 280, 0, 320)
lbGui.Position = UDim2.new(0.5, -140, 0.5, -160)
lbGui.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
lbGui.Visible = false
lbGui.Active = true
lbGui.Draggable = true
Instance.new("UICorner", lbGui)
applyBlackGreyGradient(lbGui)
local lbStroke = Instance.new("UIStroke", lbGui)
lbStroke.Thickness = 2
rs.RenderStepped:Connect(function() lbStroke.Color = Color3.fromHSV((tick() * 0.1) % 1, 0.8, 1) end)

local lbTitle = Instance.new("TextLabel", lbGui)
lbTitle.Size = UDim2.new(1, 0, 0, 35)
lbTitle.Text = "Player Leaderboard"
lbTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
lbTitle.Font = Enum.Font.GothamBold
lbTitle.TextSize = 14
lbTitle.BackgroundTransparency = 1

local lbClose = Instance.new("TextButton", lbGui)
lbClose.Size = UDim2.new(0, 26, 0, 26)
lbClose.Position = UDim2.new(1, -30, 0, 5)
lbClose.Text = "X"
lbClose.TextColor3 = Color3.fromRGB(255, 0, 0)
lbClose.Font = Enum.Font.GothamBold
lbClose.TextSize = 12
lbClose.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
Instance.new("UICorner", lbClose).CornerRadius = UDim.new(0, 4)
applyBlackGreyGradient(lbClose)
lbClose.MouseButton1Click:Connect(function() lbGui.Visible = false end)

local lbScroll = Instance.new("ScrollingFrame", lbGui)
lbScroll.Size = UDim2.new(1, -16, 1, -50)
lbScroll.Position = UDim2.new(0, 8, 0, 42)
lbScroll.BackgroundTransparency = 1
lbScroll.ScrollBarThickness = 3
lbScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local lbLayout = Instance.new("UIListLayout", lbScroll)
lbLayout.Padding = UDim.new(0, 4)

local function updateLeaderboardList()
    for _, c in pairs(lbScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    local count = 0
    for _, p in pairs(players:GetPlayers()) do
        count = count + 1
        local item = Instance.new("Frame", lbScroll)
        item.Size = UDim2.new(1, 0, 0, 30)
        item.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 4)
        
        local nameLab = Instance.new("TextLabel", item)
        nameLab.Size = UDim2.new(0.6, 0, 1, 0)
        nameLab.Position = UDim2.new(0, 8, 0, 0)
        nameLab.BackgroundTransparency = 1
        nameLab.Text = p.Name .. " (" .. p.DisplayName .. ")"
        nameLab.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLab.Font = Enum.Font.GothamSemibold
        nameLab.TextSize = 10
        nameLab.TextXAlignment = Enum.TextXAlignment.Left
        
        local teamLab = Instance.new("TextLabel", item)
        teamLab.Size = UDim2.new(0.35, 0, 1, 0)
        teamLab.Position = UDim2.new(0.6, 0, 0, 0)
        teamLab.BackgroundTransparency = 1
        teamLab.Text = p.Team and p.Team.Name or "No Team"
        teamLab.TextColor3 = Color3.fromRGB(0, 255, 180)
        teamLab.Font = Enum.Font.Gotham
        teamLab.TextSize = 10
        teamLab.TextXAlignment = Enum.TextXAlignment.Right
    end
    lbScroll.CanvasSize = UDim2.new(0, 0, 0, count * 34)
end

-- ==========================================
--        FLING TARGET SEARCH POPUP UI
-- ==========================================
local flingTargetGui = Instance.new("Frame", screenGui)
flingTargetGui.Size = UDim2.new(0, 260, 0, 150)
flingTargetGui.Position = UDim2.new(0.5, -130, 0.5, -75)
flingTargetGui.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
flingTargetGui.Visible = false
flingTargetGui.Active = true
flingTargetGui.Draggable = true
Instance.new("UICorner", flingTargetGui)
applyBlackGreyGradient(flingTargetGui)
local ftStroke = Instance.new("UIStroke", flingTargetGui)
ftStroke.Thickness = 2
rs.RenderStepped:Connect(function() ftStroke.Color = Color3.fromHSV((tick() * 0.1) % 1, 0.8, 1) end)

local ftTitle = Instance.new("TextLabel", flingTargetGui)
ftTitle.Size = UDim2.new(1, 0, 0, 30)
ftTitle.Text = "Fling Target Menu"
ftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ftTitle.Font = Enum.Font.GothamBold
ftTitle.TextSize = 12
ftTitle.BackgroundTransparency = 1

local ftClose = Instance.new("TextButton", flingTargetGui)
ftClose.Size = UDim2.new(0, 24, 0, 24)
ftClose.Position = UDim2.new(1, -28, 0, 4)
ftClose.Text = "X"
ftClose.TextColor3 = Color3.fromRGB(255, 0, 0)
ftClose.Font = Enum.Font.GothamBold
ftClose.TextSize = 12
ftClose.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
Instance.new("UICorner", ftClose).CornerRadius = UDim.new(0, 4)
applyBlackGreyGradient(ftClose)
ftClose.MouseButton1Click:Connect(function() flingTargetGui.Visible = false end)

local ftBox = Instance.new("TextBox", flingTargetGui)
ftBox.Size = UDim2.new(0.85, 0, 0, 32)
ftBox.Position = UDim2.new(0.075, 0, 0, 45)
ftBox.PlaceholderText = "Ketik nama/singkatan player..."
ftBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ftBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ftBox.Font = Enum.Font.Gotham
ftBox.TextSize = 11
Instance.new("UICorner", ftBox)

local ftExecBtn = Instance.new("TextButton", flingTargetGui)
ftExecBtn.Size = UDim2.new(0.85, 0, 0, 32)
ftExecBtn.Position = UDim2.new(0.075, 0, 0, 90)
ftExecBtn.Text = "Execute Fling Target"
ftExecBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
ftExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ftExecBtn.Font = Enum.Font.GothamBold
ftExecBtn.TextSize = 12
Instance.new("UICorner", ftExecBtn)
applyBlackGreyGradient(ftExecBtn)

local function executeFlingTarget(query)
    query = string.lower(query)
    local targetPlr = nil
    local shortestDist = math.huge
    for _, p in pairs(players:GetPlayers()) do
        if p ~= plr then
            local pName = string.lower(p.Name)
            local pDisplay = string.lower(p.DisplayName)
            if string.find(pName, query, 1, true) or string.find(pDisplay, query, 1, true) then
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and hrp then
                    local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        targetPlr = p
                    end
                end
            end
        end
    end
    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
        customNotify("Fling Target", "Mengincar: " .. targetPlr.Name, 3)
        task.spawn(function()
            local tChar = targetPlr.Character
            local tRoot = tChar:FindFirstChild("HumanoidRootPart")
            local myRoot = hrp
            if myRoot and tRoot then
                local bv = Instance.new("BodyVelocity", myRoot)
                bv.Velocity = Vector3.new(9e9, 9e9, 9e9)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                local t = tick()
                repeat
                    myRoot.CFrame = tRoot.CFrame
                    myRoot.Velocity = tRoot.Velocity * 10000 + Vector3.new(0, 10000, 0)
                    task.wait()
                until not tRoot or tRoot.Parent ~= tChar or tick() > t + 2
                bv:Destroy()
            end
        end)
    else
        customNotify("Fling Target", "Player tidak ditemukan!", 3)
    end
end

ftExecBtn.MouseButton1Click:Connect(function()
    executeFlingTarget(ftBox.Text)
    flingTargetGui.Visible = false
end)

-- ==========================================
--        MAINTAINER LOGIC & TOMBOL UTAMA
-- ==========================================
local function createFeatureBtn(name, callback, targetPage)
    targetPage = targetPage or pageMain
    local b = Instance.new("TextButton", targetPage)
    b.Text = name .. " : OFF"
    b.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextStrokeTransparency = 0.5
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 10
    Instance.new("UICorner", b)
    applyBlackGreyGradient(b)
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = name .. " : " .. (active and "ON" or "OFF")
        callback(active)
    end)
    return b
end

local function createActionBtn(name, callback, targetPage)
    targetPage = targetPage or pageMain
    local b = Instance.new("TextButton", targetPage)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextStrokeTransparency = 0.5
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 10
    Instance.new("UICorner", b)
    applyBlackGreyGradient(b)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- TAB MAIN
createFeatureBtn("FLING", function(state) states.fling = state end, pageMain)
createActionBtn("FLING TARGET", function() flingTargetGui.Visible = not flingTargetGui.Visible end, pageMain)
createFeatureBtn("Noclip", function(state) states.noclip = state end, pageMain)
createActionBtn("Teleport Labs", function()
    if hrp then
        hrp.CFrame = CFrame.new(0, 50, 0)
        customNotify("Teleport", "Berhasil teleport ke Lab!", 3)
    end
end, pageMain)
createFeatureBtn("Inf Jump", function(state) states.infJump = state end, pageMain)
createFeatureBtn("Sit", function(state)
    states.sit = state
    if hum then hum.Sit = states.sit end
end, pageMain)
createFeatureBtn("Invisible", function(state)
    states.invis = state
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = states.invis and 1 or 0
            elseif v:IsA("Decal") then
                v.Transparency = states.invis and 1 or 0
            end
        end
    end
end, pageMain)
createActionBtn("Check Leaderboard", function()
    updateLeaderboardList()
    lbGui.Visible = not lbGui.Visible
end, pageMain)
createFeatureBtn("Swim Water", function(state)
    states.swimWater = state
    if states.swimWater then
        swimPart = Instance.new("Part", workspace)
        swimPart.Name = "MeknoSwimBox"
        swimPart.Size = Vector3.new(10, 2, 10)
        swimPart.Anchored = true
        swimPart.CanCollide = false
        swimPart.Transparency = 1
        
        swimConnection = rs.RenderStepped:Connect(function()
            if not states.swimWater or not hrp then 
                if swimPart then swimPart:Destroy() end
                if swimConnection then swimConnection:Disconnect() end
                return
            end
            swimPart.CFrame = hrp.CFrame * CFrame.new(0, -2, 0)
            if hum then hum:ChangeState(Enum.HumanoidStateType.Swimming) end
        end)
    else
        if swimPart then swimPart:Destroy() end
        if swimConnection then swimConnection:Disconnect() end
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end, pageMain)
createFeatureBtn("Use All Tools", function(state)
    states.useAllTools = state
    task.spawn(function()
        while states.useAllTools do
            pcall(function()
                for _, tool in pairs(plr.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool.Parent = char
                        tool:Activate()
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end, pageMain)
createFeatureBtn("ESP", function(state)
    states.esp = state
    if not states.esp then
        for _, p in pairs(players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MeknoHighlight") then
                p.Character.MeknoHighlight:Destroy()
            end
        end
    end
end, pageMain)

-- TAB AUTOMATIC
createFeatureBtn("Auto Click Button", function(state)
    states.autoClick = state
    if states.autoClick then
        autoClickConnection = task.spawn(function()
            while states.autoClick do
                pcall(function()
                    for _, v in pairs(plr.PlayerGui:GetDescendants()) do
                        if v:IsA("TextButton") or v:IsA("ImageButton") then
                            for _, conn in pairs(getconnections(v.MouseButton1Click)) do
                                conn:Fire()
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
end, pageAutomatic)

-- TAB ANTI
createFeatureBtn("Anti Afk", function(state) states.antiafk = state end, pageAnti)
local virtualUser = game:GetService("VirtualUser")
pcall(function()
    plr.Idled:Connect(function()
        if states.antiafk then
            virtualUser:Button2Down(Vector2.new(0,0), cam.CFrame)
            task.wait(1)
            virtualUser:Button2Up(Vector2.new(0,0), cam.CFrame)
        end
    end)
end)

createFeatureBtn("Anti Fling", function(state) states.antifling = state end, pageAnti)
createFeatureBtn("Anti Fall", function(state) states.antiFall = state end, pageAnti)

-- // LOOP CORE UTAMA //
UIS.JumpRequest:Connect(function()
    if states.infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

rs.RenderStepped:Connect(function()
    if not char or not hum or not hrp then return end
    
    if states.noclip then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    
    if states.fling then
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        local cv = hrp.Velocity
        hrp.Velocity = cv * 10000 + Vector3.new(0, 10000, 0)
        rs.RenderStepped:Wait()
        if hrp then hrp.Velocity = cv; hrp.RotVelocity = Vector3.new(0,0,0) end
    end

    if states.antifling then
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        if part.Velocity.Magnitude > 150 then part.Velocity = Vector3.new(0,0,0) end
                    end
                end
            end
        end
    end

    if states.antiFall and hrp.Position.Y < -50 then
        hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
        hrp.Velocity = Vector3.new(0, 0, 0)
    end

    if states.esp then
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr and p.Character and not p.Character:FindFirstChild("MeknoHighlight") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "MeknoHighlight"
                hl.FillColor = Color3.fromRGB(0, 255, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end)

end

-- // INISIALISASI //
mainEngineLoad()
