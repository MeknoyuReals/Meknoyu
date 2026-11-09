-- [[ ULTRA MEKNOYU HUB (VIOLENCE DISTRICT) ]] --
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
screenGui.Name = "Mekno_ViolenceDistrict"
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
--        MAIN MEKNOYU ENGINE LOAD
-- ==========================================
local function mainEngineLoad()

local states = {
    espKiller = false, espMachine = false, autoCarry = false,
    predictGun = false, hitboxRole = false, infJump = false, antiLag = false
}

local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid", 10)
local hrp = char:WaitForChild("HumanoidRootPart", 10)

local function setupChar(c)
    char = c; hum = c:WaitForChild("Humanoid", 10); hrp = c:WaitForChild("HumanoidRootPart", 10)
end
if plr.Character then setupChar(plr.Character) end
plr.CharacterAdded:Connect(setupChar)

customNotify("Meknoyu Hub", "Violence District Loaded!", 5)

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
miniBtn.Text = "Meknoyu Hub"
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
header.Text = "Meknoyu Hub | Violence District"; header.BackgroundTransparency = 1; header.TextColor3 = Color3.new(1,1,1); header.Font = Enum.Font.GothamBold; header.TextSize = 13; header.TextXAlignment = Enum.TextXAlignment.Left

local keySystemLabel = Instance.new("TextLabel", main)
keySystemLabel.Size = UDim2.new(1, -210, 0, 15)
keySystemLabel.Position = UDim2.new(0, 65, 0, 26)
keySystemLabel.BackgroundTransparency = 1
keySystemLabel.Font = Enum.Font.GothamMedium
keySystemLabel.TextSize = 11
keySystemLabel.TextXAlignment = Enum.TextXAlignment.Left
keySystemLabel.Text = "KEY: FREE"
keySystemLabel.TextColor3 = Color3.fromRGB(0, 255, 128)

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
    local p = Instance.new("ScrollingFrame", pages); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0, 0, 3.5, 0)
    local grid = Instance.new("UIGridLayout", p); grid.CellSize = UDim2.new(0.48, 0, 0, 32); grid.CellPadding = UDim2.new(0, 5, 0, 5)
    return p
end

local pageMain = createPage("Main")
local pageVisuals = createPage("Visuals")

local function addTab(name, targetPage)
    local btn = Instance.new("TextButton", tabContainer)
    btn.Size = UDim2.new(1, 0, 0, 26); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(65, 65, 75); btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextStrokeTransparency = 0.5; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 2
    Instance.new("UICorner", btn); applyBlackGreyGradient(btn)
    btn.MouseButton1Click:Connect(function() 
        for _, v in pairs(pages:GetChildren()) do v.Visible = false end; targetPage.Visible = true 
    end)
end

addTab("Main", pageMain)
addTab("Visuals", pageVisuals)
pageMain.Visible = true

-- // HELPER BUTTON CREATORS //
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

-- ==========================================
--        IMPLEMENTASI FITUR VIOLENCE DISTRICT
-- ==========================================

-- 1. Esp Killer (Red Highlight)
createFeatureBtn("Esp Killer", function(state)
    states.espKiller = state
    task.spawn(function()
        while states.espKiller do
            pcall(function()
                for _, p in pairs(players:GetPlayers()) do
                    if p ~= plr and p.Character then
                        local isKiller = false
                        local pName = string.lower(p.Name)
                        if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") or pName == "killer" then
                            isKiller = true
                        end
                        
                        if isKiller then
                            if not p.Character:FindFirstChild("MeknoKillerHL") then
                                local hl = Instance.new("Highlight", p.Character)
                                hl.Name = "MeknoKillerHL"
                                hl.FillColor = Color3.fromRGB(255, 0, 0)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            end
                        end
                    end
                end
            end)
            task.wait(2)
        end
        for _, p in pairs(players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MeknoKillerHL") then
                p.Character.MeknoKillerHL:Destroy()
            end
        end
    end)
end, pageVisuals)

-- 2. Esp Machine (Yellow Highlight)
createFeatureBtn("Esp Machine", function(state)
    states.espMachine = state
    task.spawn(function()
        while states.espMachine do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (string.find(string.lower(obj.Name), "machine") or string.find(string.lower(obj.Name), "generator") or string.find(string.lower(obj.Name), "repair")) then
                        if not obj:FindFirstChild("MeknoMachineHL") then
                            local hl = Instance.new("Highlight", obj)
                            hl.Name = "MeknoMachineHL"
                            hl.FillColor = Color3.fromRGB(255, 255, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
            end)
            task.wait(2)
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("MeknoMachineHL") then
                obj.MeknoMachineHL:Destroy()
            end
        end
    end)
end, pageVisuals)

-- 3. Auto Carry Player (Otomatis memicu Prompt Carry/Lift)
createFeatureBtn("Auto Carry Player", function(state)
    states.autoCarry = state
    task.spawn(function()
        while states.autoCarry do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local text = string.lower(obj.ActionText or "")
                        local name = string.lower(obj.Name or "")
                        if text:find("carry") or text:find("pickup") or text:find("lift") or name:find("carry") or name:find("pickup") then
                            fireproximityprompt(obj)
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end, pageMain)

-- 4. Predicticon Killer Gun (Aimbot & Red Tracer Line)
createFeatureBtn("Predicticon Gun", function(state)
    states.predictGun = state
    task.spawn(function()
        while states.predictGun do
            pcall(function()
                if not hrp then return end
                local target = nil
                local shortestDist = math.huge
                
                for _, p in pairs(players:GetPlayers()) do
                    if p ~= plr and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        local head = p.Character.Head
                        local dist = (head.Position - hrp.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            target = head
                        end
                    end
                end
                
                local currentTool = char and char:FindFirstChildOfClass("Tool")
                if currentTool then
                    local handle = currentTool:FindFirstChild("Handle") or currentTool:FindFirstChildOfClass("BasePart")
                    if handle then
                        local att0 = handle:FindFirstChild("MeknoGunAtt") or Instance.new("Attachment", handle)
                        att0.Name = "MeknoGunAtt"
                        
                        if target then
                            local att1 = target:FindFirstChild("MeknoTargetAtt") or Instance.new("Attachment", target)
                            att1.Name = "MeknoTargetAtt"
                            
                            local beam = handle:FindFirstChild("MeknoGunTracer")
                            if not beam then
                                beam = Instance.new("Beam")
                                beam.Name = "MeknoGunTracer"
                                beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                                beam.Width0 = 0.1
                                beam.Width1 = 0.1
                                beam.FaceCamera = true
                                beam.Attachment0 = att0
                                beam.Attachment1 = att1
                                beam.Parent = handle
                            end
                            
                            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, target.Position + (target.Velocity * 0.1))
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
        for _, tool in pairs(plr.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                for _, h in pairs(tool:GetDescendants()) do
                    if h.Name == "MeknoGunTracer" then h:Destroy() end
                end
            end
        end
        if char then
            for _, t in pairs(char:GetChildren()) do
                if t:IsA("Tool") then
                    for _, h in pairs(t:GetDescendants()) do
                        if h.Name == "MeknoGunTracer" then h:Destroy() end
                    end
                end
            end
        end
    end)
end, pageMain)

-- 5. Hitbox Innocent (Green) & Sheriff (Blue)
createFeatureBtn("Hitbox Role", function(state)
    states.hitboxRole = state
    task.spawn(function()
        while states.hitboxRole do
            pcall(function()
                for _, p in pairs(players:GetPlayers()) do
                    if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrPart = p.Character.HumanoidRootPart
                        local pName = string.lower(p.Name)
                        
                        local isSheriff = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") or pName:find("sheriff")
                        local isInnocent = not isSheriff and not (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife"))
                        
                        hrPart.Size = Vector3.new(4, 4, 4)
                        hrPart.Transparency = 0.7
                        hrPart.CanCollide = false
                        
                        if isSheriff then
                            hrPart.Color = Color3.fromRGB(0, 0, 255)
                        elseif isInnocent then
                            hrPart.Color = Color3.fromRGB(0, 255, 0)
                        end
                    end
                end
            end)
            task.wait(1)
        end
        for _, p in pairs(players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end)
end, pageMain)

-- Fitur Pendukung Dasar
createFeatureBtn("Inf Jumps", function(state)
    states.infJump = state
end, pageMain)

UIS.JumpRequest:Connect(function()
    if states.infJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

createFeatureBtn("Anti Lag", function(state)
    states.antiLag = state
    if states.antiLag then
        settings().Rendering.QualityLevel = 1
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CastShadow = false
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        lighting.GlobalShadows = true
    end
end, pageMain)

end

-- ==========================================================
--    LOGIKA BYPASS OWNER & INITIALIZATION KEY SYSTEM
-- ==========================================================
if plr.Name == "Meknoyu" then
    mainEngineLoad()
else
    local keyVerified = false
    local currentGeneratedKey = ""
    local fileName = "Meknoyu_KeyData.json"

    local function saveKeyToDevice(key, durationInSeconds)
        local data = {
            SavedKey = key,
            ExpireTime = os.time() + durationInSeconds
        }
        pcall(function()
            if writefile then
                writefile(fileName, HttpService:JSONEncode(data))
            end
        end)
    end

    local function checkSavedKey()
        if not readfile or not isfile then return false end
        if isfile(fileName) then
            local success, content = pcall(readfile, fileName)
            if success then
                local success2, data = pcall(function() return HttpService:JSONDecode(content) end)
                if success2 and data and data.SavedKey and data.ExpireTime then
                    if os.time() < data.ExpireTime then
                        currentGeneratedKey = data.SavedKey
                        return true
                    else
                        pcall(delfile, fileName)
                    end
                end
            end
        end
        return false
    end

    if checkSavedKey() then
        mainEngineLoad()
        return 
    end

    local keyGui = Instance.new("Frame")
    keyGui.Name = "KeyGui"
    keyGui.Size = UDim2.new(0, 360, 0, 385)
    keyGui.AnchorPoint = Vector2.new(0.5, 0.5)
    keyGui.Position = UDim2.new(0.5, 0, 0.5, 0)
    keyGui.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    keyGui.BackgroundTransparency = 0
    keyGui.BorderSizePixel = 0
    keyGui.Active = true
    Instance.new("UICorner", keyGui)
    applyBlackGreyGradient(keyGui)
    local keyStroke = Instance.new("UIStroke", keyGui)
    keyStroke.Thickness = 2
    keyStroke.Color = Color3.fromRGB(255, 255, 255)
    keyGui.Parent = screenGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 10)
    titleLabel.Text = "Meknoyu Hub"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextTransparency = 0
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = keyGui

    local subTitleLabel = Instance.new("TextLabel")
    subTitleLabel.Size = UDim2.new(1, 0, 0, 25)
    subTitleLabel.Position = UDim2.new(0, 0, 0, 45)
    subTitleLabel.Text = "Get Key\n(Expired in 23h 59m)"
    subTitleLabel.Font = Enum.Font.GothamMedium
    subTitleLabel.TextSize = 12
    subTitleLabel.TextTransparency = 0
    subTitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    subTitleLabel.BackgroundTransparency = 1
    subTitleLabel.Parent = keyGui

    local keyTextBox = Instance.new("TextBox")
    keyTextBox.Size = UDim2.new(0.85, 0, 0, 35)
    keyTextBox.Position = UDim2.new(0.075, 0, 0, 90)
    keyTextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    keyTextBox.Text = ""
    keyTextBox.PlaceholderText = "Example_Key"
    keyTextBox.TextTransparency = 0
    keyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyTextBox.Font = Enum.Font.Gotham
    keyTextBox.TextSize = 14
    Instance.new("UICorner", keyTextBox)
    keyTextBox.Parent = keyGui

    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0.4, 0, 0, 35)
    getKeyBtn.Position = UDim2.new(0.075, 0, 0, 140)
    getKeyBtn.Text = "Get Key"
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    getKeyBtn.BackgroundTransparency = 0
    getKeyBtn.TextTransparency = 0
    getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyBtn.TextStrokeTransparency = 0.5
    getKeyBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    getKeyBtn.Font = Enum.Font.GothamBold
    getKeyBtn.TextSize = 14
    Instance.new("UICorner", getKeyBtn)
    applyBlackGreyGradient(getKeyBtn)
    getKeyBtn.Parent = keyGui

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Size = UDim2.new(0.4, 0, 0, 35)
    confirmBtn.Position = UDim2.new(0.525, 0, 0, 140)
    confirmBtn.Text = "Confirm"
    confirmBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    confirmBtn.BackgroundTransparency = 0
    confirmBtn.TextTransparency = 0
    confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmBtn.TextStrokeTransparency = 0.5
    confirmBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.TextSize = 14
    Instance.new("UICorner", confirmBtn)
    applyBlackGreyGradient(confirmBtn)
    confirmBtn.Parent = keyGui

    local questFrame = Instance.new("Frame")
    questFrame.Size = UDim2.new(0, 340, 0, 190)
    questFrame.Position = UDim2.new(0.025, 0, 0, 185)
    questFrame.BackgroundTransparency = 1
    questFrame.Visible = false
    questFrame.Parent = keyGui

    local quests = {
        {text = "LIKE SCRIPT THIS FOR FREE!", cd = 10},
        {text = "MEKNOYU OFFICIAL SCRIPT OP!", cd = 20},
        {text = "GET KEY FOR FREE YOUR!", cd = 30},
        {text = "SCRIPT UPDATE NEW FEATURES!", cd = 50}
    }

    local questButtons = {}
    local questStatus = {false, false, false, false}

    for i, q in ipairs(quests) do
        local qBtn = Instance.new("TextButton")
        qBtn.Size = UDim2.new(0.65, 0, 0, 35)
        qBtn.Position = UDim2.new(0, 0, 0, (i-1) * 45)
        qBtn.Text = q.text
        qBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        qBtn.BackgroundTransparency = 0
        qBtn.TextTransparency = 0
        qBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        qBtn.TextStrokeTransparency = 0.5
        qBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
        qBtn.Font = Enum.Font.GothamSemibold
        qBtn.TextSize = 10
        qBtn.TextWrapped = true
        Instance.new("UICorner", qBtn)
        applyBlackGreyGradient(qBtn)
        qBtn.Parent = questFrame
        
        local cdLabel = Instance.new("TextLabel")
        cdLabel.Size = UDim2.new(0.3, 0, 0, 35)
        cdLabel.Position = UDim2.new(0.7, 0, 0, (i-1) * 45)
        cdLabel.Text = q.cd .. " s"
        cdLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        cdLabel.TextTransparency = 0
        cdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        cdLabel.Font = Enum.Font.GothamBold
        cdLabel.TextSize = 12
        Instance.new("UICorner", cdLabel)
        cdLabel.Parent = questFrame

        qBtn.MouseButton1Click:Connect(function()
            if questStatus[i] == false then
                questStatus[i] = "processing"
                qBtn.Active = false
                task.spawn(function()
                    local currentCd = q.cd
                    while currentCd > 0 do
                        cdLabel.Text = currentCd .. "s"
                        task.wait(1)
                        currentCd = currentCd - 1
                    end
                    cdLabel.Text = "DONE"
                    questStatus[i] = true
                    
                    local allDone = true
                    for _, status in ipairs(questStatus) do
                        if status ~= true then allDone = false break end
                    end
                    
                    if allDone then
                        task.wait(0.5)
                        questFrame.Visible = false
                        showCopyKeyGui()
                    end
                end)
            end
        end)
    end

    local copyKeyGui = Instance.new("Frame")
    copyKeyGui.Name = "CopyKeyGui"
    copyKeyGui.Size = UDim2.new(1, 0, 1, 0)
    copyKeyGui.BackgroundTransparency = 1
    copyKeyGui.Visible = false
    copyKeyGui.Parent = keyGui

    local copyTitle = Instance.new("TextLabel")
    copyTitle.Size = UDim2.new(1, 0, 0, 40)
    copyTitle.Position = UDim2.new(0, 0, 0, 40)
    copyTitle.Text = "Copy Your Key"
    copyTitle.Font = Enum.Font.GothamBold
    copyTitle.TextSize = 20
    copyTitle.TextTransparency = 0
    copyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyTitle.BackgroundTransparency = 1
    copyTitle.Parent = copyKeyGui

    local keyDisplayBox = Instance.new("TextBox")
    keyDisplayBox.Size = UDim2.new(0.85, 0, 0, 35)
    keyDisplayBox.Position = UDim2.new(0.075, 0, 0, 100)
    keyDisplayBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    keyDisplayBox.TextTransparency = 0
    keyDisplayBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    keyDisplayBox.Font = Enum.Font.Code
    keyDisplayBox.TextSize = 12
    keyDisplayBox.ClearTextOnFocus = false
    keyDisplayBox.TextEditable = false
    Instance.new("UICorner", keyDisplayBox)
    keyDisplayBox.Parent = copyKeyGui

    local copyActionBtn = Instance.new("TextButton")
    copyActionBtn.Size = UDim2.new(0.5, 0, 0, 35)
    copyActionBtn.Position = UDim2.new(0.25, 0, 0, 160)
    copyActionBtn.Text = "Click to Copy Key"
    copyActionBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    copyActionBtn.BackgroundTransparency = 0
    copyActionBtn.TextTransparency = 0
    copyActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyActionBtn.TextStrokeTransparency = 0.5
    copyActionBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    copyActionBtn.Font = Enum.Font.GothamBold
    copyActionBtn.TextSize = 13
    Instance.new("UICorner", copyActionBtn)
    applyBlackGreyGradient(copyActionBtn)
    copyActionBtn.Parent = copyKeyGui

    copyActionBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(keyDisplayBox.Text)
            copyActionBtn.Text = "Copied Success!"
            task.wait(1)
            copyActionBtn.Text = "Click to Copy Key"
        end
    end)

    local closeCopyBtn = Instance.new("TextButton")
    closeCopyBtn.Size = UDim2.new(0, 30, 0, 30)
    closeCopyBtn.Position = UDim2.new(1, -35, 0, 5)
    closeCopyBtn.Text = "X"
    closeCopyBtn.TextTransparency = 0
    closeCopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeCopyBtn.TextStrokeTransparency = 0.5
    closeCopyBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    closeCopyBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    closeCopyBtn.BackgroundTransparency = 0
    closeCopyBtn.Font = Enum.Font.GothamBold
    closeCopyBtn.TextSize = 14
    Instance.new("UICorner", closeCopyBtn)
    applyBlackGreyGradient(closeCopyBtn)
    closeCopyBtn.Parent = copyKeyGui

    closeCopyBtn.MouseButton1Click:Connect(function()
        copyKeyGui.Visible = false
        titleLabel.Visible = true
        subTitleLabel.Visible = true
        keyTextBox.Visible = true
        getKeyBtn.Visible = true
        confirmBtn.Visible = true
    end)

    function showCopyKeyGui()
        titleLabel.Visible = false
        subTitleLabel.Visible = false
        keyTextBox.Visible = false
        getKeyBtn.Visible = false
        confirmBtn.Visible = false
        
        local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local randomString = ""
        for i = 1, 8 do
            local rand = math.random(1, #chars)
            randomString = randomString .. string.sub(chars, rand, rand)
        end
        currentGeneratedKey = "Mekno_" .. randomString
        keyDisplayBox.Text = currentGeneratedKey
        
        copyKeyGui.Visible = true
    end

    getKeyBtn.MouseButton1Click:Connect(function()
        questFrame.Visible = true
    end)

    confirmBtn.MouseButton1Click:Connect(function()
        if keyTextBox.Text == currentGeneratedKey and currentGeneratedKey ~= "" then
            keyVerified = true
            saveKeyToDevice(currentGeneratedKey, 86340)
            keyGui:Destroy() 
            mainEngineLoad()     
        else
            confirmBtn.Text = "INVALID KEY!"
            task.wait(1.5)
            confirmBtn.Text = "Confirm"
        end
    end)
end
