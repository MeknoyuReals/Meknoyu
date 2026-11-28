-- [[ ULTRA MEKNOYU HUB (LOCKED & PROTECTED - SAFER HOOKS) ]] --
local plr = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local mps = game:GetService("MarketplaceService")
local lighting = game:GetService("Lighting")
local guiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local HapticService = game:GetService("HapticService")
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local cam = workspace.CurrentCamera
local mouse = plr:GetMouse()

-- // CONFIG DISCORD WEBHOOK //
local DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/1574359151512125473/F1ix--xZW9PGmqfSwRKvyX8DdD_xoaxzShbBCiVE3eUARvYkU-2IZCLRbUq9rXIY97bj"

-- // OWNER LIST & PREMIUM USER URL CHECK //
local OWNER_USERS = {
    ["Meknoyu"] = true,
}

local function normalizePremiumList(raw)
    local map = {}
    if type(raw) == "table" then
        for k, v in pairs(raw) do
            if type(k) == "string" and v == true then
                map[string.lower(k)] = true
            elseif type(v) == "string" then
                map[string.lower(v)] = true
            end
        end
    elseif type(raw) == "string" then
        for name in raw:gmatch("[^\r\n,]+") do
            local cleaned = name:gsub("^%s+", ""):gsub("%s+$", "")
            if cleaned ~= "" then
                map[string.lower(cleaned)] = true
            end
        end
    end
    return map
end

local PREMIUM_USERS = {}
pcall(function()
    local premText = game:HttpGet("https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/userprem.lua")
    local premResult = nil
    local okLoad, loadedFn = pcall(loadstring, premText)
    if okLoad and type(loadedFn) == "function" then
        local okCall, callRes = pcall(loadedFn)
        if okCall then
            premResult = callRes
        end
    end
    if premResult ~= nil then
        PREMIUM_USERS = normalizePremiumList(premResult)
    elseif type(premText) == "string" then
        PREMIUM_USERS = normalizePremiumList(premText)
    end
end)

local env = (getgenv and getgenv()) or _G
if next(PREMIUM_USERS) == nil and type(env.PremiumUsers) == "table" then
    PREMIUM_USERS = normalizePremiumList(env.PremiumUsers)
end

local function isOwnerUser(player)
    return OWNER_USERS[player.Name] == true
end

local function isPremiumUser(player)
    if isOwnerUser(player) then
        return true
    end
    return PREMIUM_USERS[string.lower(player.Name)] == true
end

local function getUserKeyTier(player)
    if isOwnerUser(player) then
        return "OWNER"
    elseif isPremiumUser(player) then
        return "PREMIUM"
    else
        return "FREE"
    end
end

local function getTierRichText(tier)
    if tier == "OWNER" then
        return '<font color="rgb(255,255,255)">Key: </font><font color="rgb(255,60,60)">OWNER</font>'
    elseif tier == "PREMIUM" then
        return '<font color="rgb(255,220,50)">PREMIUM</font>'
    else
        return '<font color="rgb(60,255,120)">FREE</font>'
    end
end

local function canAccessFeatureTab(player)
    local tier = getUserKeyTier(player)
    return tier == "OWNER" or tier == "PREMIUM"
end

-- // GRADIENT HELPER //
local function applyBlackGreyGradient(instance)
    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 95, 105)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 65))
    })
    uiGradient.Parent = instance
    return uiGradient
end

-- // MAIN SCREEN GUI //
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mekno_Clean_Final"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

-- ==========================================
--        CUSTOM NOTIFICATION UI SYSTEM
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
        pcall(function()
            local data = {
                ["embeds"] = {{
                    ["title"] = "Meknoyu Hub Executed!",
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
        end)
    end
end

-- ==========================================
--        MAIN MEKNOYU ENGINE LOAD
-- ==========================================
local function mainEngineLoad()
    sendWebhook()

    local states = {
        god=false, noclip=false, esp=false, espskeleton=false, tracer=false, fling=false, antifling=false,
        infJump=false, speed=false, fps=false, antirag=false, antijail=false, bypassac=false,
        tooltp=false, antitel=false, aimbot=false, aimActive=false, antirobux=false, savepos=false,
        hitbox=false, fullbright=false, addpart=false, xray=false, tpKill=false, antiafk=false,
        invis=false, antivoid=false, antilag=false, float=false, spin=false,
        antikick=false, antikickrejoin=false, fly=false, swim=false, spectate=false, hitall=false
    }
    local originalTransparencies = {}
    local originalHitboxes = {}
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 10)
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    local godConnection, lastPos, savedPos = nil, nil, nil
    local platformPart, voidPart, floatPart = nil, nil, nil
    local savedOldPos = nil

    local function resetHitboxes()
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr and p.Character then
                local tRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if tRoot and originalHitboxes[tRoot] then
                    pcall(function()
                        tRoot.Size = originalHitboxes[tRoot].size
                        tRoot.Transparency = originalHitboxes[tRoot].transparency
                        tRoot.CanCollide = originalHitboxes[tRoot].canCollide
                    end)
                end
            end
        end
        originalHitboxes = {}
    end

    -- ========================
    -- KONFIGURASI ESP SKELETON
    -- ========================
    local skeletonDrawings = {}

    local function removeSkeleton(p)
        if skeletonDrawings[p] then
            for _, line in pairs(skeletonDrawings[p]) do
                pcall(function() line:Remove() end)
            end
            skeletonDrawings[p] = nil
        end
    end

    local function updateSkeleton()
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr then
                if states.espskeleton and p.Character and p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health > 0 then
                    local char = p.Character
                    local head = char:FindFirstChild("Head")
                    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                    local la = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand") or char:FindFirstChild("LeftLowerArm")
                    local ra = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand") or char:FindFirstChild("RightLowerArm")
                    local ll = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftFoot") or char:FindFirstChild("LeftLowerLeg")
                    local rl = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightFoot") or char:FindFirstChild("RightLowerLeg")

                    if head and torso then
                        if not skeletonDrawings[p] then
                            skeletonDrawings[p] = {
                                HeadToTorso = Drawing.new("Line"),
                                TorsoToLA = Drawing.new("Line"),
                                TorsoToRA = Drawing.new("Line"),
                                TorsoToLL = Drawing.new("Line"),
                                TorsoToRL = Drawing.new("Line")
                            }
                            for _, line in pairs(skeletonDrawings[p]) do
                                line.Visible = false
                                line.Color = Color3.fromRGB(255, 0, 128)
                                line.Thickness = 1.5
                            end
                        end

                        local lines = skeletonDrawings[p]
                        local function renderLine(lineObj, partA, partB)
                            if partA and partB then
                                local posA, onScreenA = cam:WorldToViewportPoint(partA.Position)
                                local posB, onScreenB = cam:WorldToViewportPoint(partB.Position)
                                if onScreenA or onScreenB then
                                    lineObj.From = Vector2.new(posA.X, posA.Y)
                                    lineObj.To = Vector2.new(posB.X, posB.Y)
                                    lineObj.Visible = true
                                else
                                    lineObj.Visible = false
                                end
                            else
                                lineObj.Visible = false
                            end
                        end

                        renderLine(lines.HeadToTorso, head, torso)
                        renderLine(lines.TorsoToLA, torso, la)
                        renderLine(lines.TorsoToRA, torso, ra)
                        renderLine(lines.TorsoToLL, torso, ll)
                        renderLine(lines.TorsoToRL, torso, rl)
                    else
                        removeSkeleton(p)
                    end
                else
                    removeSkeleton(p)
                end
            end
        end
    end

    players.PlayerRemoving:Connect(function(p)
        removeSkeleton(p)
    end)

    -- ========================
    -- KONFIGURASI SPECTATE
    -- ========================
    local spectateIndex = 1
    local spectateTarget = nil

    local spectateBar = Instance.new("Frame", screenGui)
    spectateBar.Name = "MeknoSpectateBar"
    spectateBar.Size = UDim2.new(0, 270, 0, 38)
    spectateBar.AnchorPoint = Vector2.new(0.5, 1)
    spectateBar.Position = UDim2.new(0.5, 0, 1, -26)
    spectateBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    spectateBar.BackgroundTransparency = 0.05
    spectateBar.Visible = false
    Instance.new("UICorner", spectateBar).CornerRadius = UDim.new(0, 8)
    applyBlackGreyGradient(spectateBar)

    local spectateStroke = Instance.new("UIStroke", spectateBar)
    spectateStroke.Thickness = 1.8
    rs.RenderStepped:Connect(function()
        spectateStroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1)
    end)

    local spectateBackBtn = Instance.new("TextButton", spectateBar)
    spectateBackBtn.Size = UDim2.new(0, 56, 0, 26)
    spectateBackBtn.Position = UDim2.new(0, 6, 0.5, -13)
    spectateBackBtn.Text = "Back"
    spectateBackBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    spectateBackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spectateBackBtn.TextStrokeTransparency = 0.5
    spectateBackBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    spectateBackBtn.Font = Enum.Font.GothamBold
    spectateBackBtn.TextSize = 11
    Instance.new("UICorner", spectateBackBtn).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(spectateBackBtn)

    local spectateNameLabel = Instance.new("TextLabel", spectateBar)
    spectateNameLabel.Size = UDim2.new(1, -136, 1, 0)
    spectateNameLabel.Position = UDim2.new(0, 68, 0, 0)
    spectateNameLabel.BackgroundTransparency = 1
    spectateNameLabel.Text = "No Player"
    spectateNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    spectateNameLabel.TextStrokeTransparency = 0.5
    spectateNameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    spectateNameLabel.Font = Enum.Font.GothamBold
    spectateNameLabel.TextSize = 11
    spectateNameLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local spectateNextBtn = Instance.new("TextButton", spectateBar)
    spectateNextBtn.Size = UDim2.new(0, 56, 0, 26)
    spectateNextBtn.Position = UDim2.new(1, -62, 0.5, -13)
    spectateNextBtn.Text = "Next"
    spectateNextBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    spectateNextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spectateNextBtn.TextStrokeTransparency = 0.5
    spectateNextBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    spectateNextBtn.Font = Enum.Font.GothamBold
    spectateNextBtn.TextSize = 11
    Instance.new("UICorner", spectateNextBtn).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(spectateNextBtn)

    local function getSpectateList()
        local list = {}
        for _, p in ipairs(players:GetPlayers()) do
            if p ~= plr then
                table.insert(list, p)
            end
        end
        return list
    end

    local function applySpectateCamera(targetPlr)
        local currentCam = workspace.CurrentCamera
        if targetPlr and targetPlr.Character then
            local targetHum = targetPlr.Character:FindFirstChildOfClass("Humanoid")
            local targetRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart") or targetPlr.Character:FindFirstChild("Head")
            if targetHum then
                currentCam.CameraType = Enum.CameraType.Custom
                currentCam.CameraSubject = targetHum
                return
            elseif targetRoot then
                currentCam.CameraType = Enum.CameraType.Custom
                currentCam.CameraSubject = targetRoot
                return
            end
        end
    end

    local function refreshSpectateTarget(step)
        local list = getSpectateList()
        if #list == 0 then
            spectateTarget = nil
            spectateNameLabel.Text = "No Other Player"
            local myChar = plr.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if myHum then
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                workspace.CurrentCamera.CameraSubject = myHum
            end
            return
        end

        if step and step ~= 0 then
            spectateIndex = ((spectateIndex - 1 + step) % #list) + 1
        else
            if spectateTarget then
                local foundIdx = table.find(list, spectateTarget)
                if foundIdx then
                    spectateIndex = foundIdx
                else
                    spectateIndex = ((spectateIndex - 1) % #list) + 1
                end
            else
                spectateIndex = ((spectateIndex - 1) % #list) + 1
            end
        end

        spectateTarget = list[spectateIndex]
        spectateNameLabel.Text = spectateTarget.Name
        applySpectateCamera(spectateTarget)
    end

    local spectateBtnRef = nil

    local function setSpectateEnabled(enabled)
        states.spectate = enabled
        if spectateBtnRef then
            spectateBtnRef.Text = "Spectate Player : " .. (enabled and "ON" or "OFF")
        end

        if enabled then
            spectateBar.Visible = true
            refreshSpectateTarget(0)
        else
            spectateBar.Visible = false
            spectateTarget = nil
            local myChar = plr.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            if myHum then
                workspace.CurrentCamera.CameraSubject = myHum
            elseif myRoot then
                workspace.CurrentCamera.CameraSubject = myRoot
            end
        end
    end

    spectateBackBtn.MouseButton1Click:Connect(function()
        if states.spectate then
            refreshSpectateTarget(-1)
        end
    end)

    spectateNextBtn.MouseButton1Click:Connect(function()
        if states.spectate then
            refreshSpectateTarget(1)
        end
    end)

    players.PlayerRemoving:Connect(function(leftPlr)
        if states.spectate and spectateTarget == leftPlr then
            refreshSpectateTarget(0)
        end
    end)

    -- ========================
    -- KONFIGURASI FLY
    -- ========================
    local FLYING = false
    local QEfly = true
    local iyflyspeed = 1
    local flyKeyDown, flyKeyUp
    local mfly1, mfly2

    local velocityHandlerName = "FlyVelocity"
    local gyroHandlerName = "FlyGyro"

    local IsOnMobile = false
    pcall(function()
        IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UIS:GetPlatform()) ~= nil
    end)
    if not IsOnMobile then
        IsOnMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
    end

    local function getRoot(c)
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and h.RootPart then
                return h.RootPart
            end
            return c:FindFirstChild("HumanoidRootPart")
        end
        return nil
    end

    local function isNumber(str)
        return tonumber(str) ~= nil or str == "inf"
    end

    local function sFLY()
        local c = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = c:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            repeat task.wait() until c:FindFirstChildOfClass("Humanoid")
            humanoid = c:FindFirstChildOfClass("Humanoid")
        end

        if flyKeyDown then flyKeyDown:Disconnect() end
        if flyKeyUp then flyKeyUp:Disconnect() end

        local root = getRoot(c)
        if not root then return end

        local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        local SPEED = 0

        local function FLY()
            FLYING = true
            local BG = Instance.new("BodyGyro")
            local BV = Instance.new("BodyVelocity")
            BG.P = 9e4
            BG.Parent = root
            BV.Parent = root
            BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            BG.CFrame = root.CFrame
            BV.Velocity = Vector3.new(0, 0, 0)
            BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

            task.spawn(function()
                repeat task.wait()
                    local camera = workspace.CurrentCamera
                    if humanoid then
                        humanoid.PlatformStand = true
                    end

                    if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                        SPEED = 50
                    elseif SPEED ~= 0 then
                        SPEED = 0
                    end

                    if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                        BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                        lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                    elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                        BV.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + lCONTROL.Q + lCONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                    else
                        BV.Velocity = Vector3.new(0, 0, 0)
                    end

                    BG.CFrame = camera.CFrame
                until not FLYING

                BG:Destroy()
                BV:Destroy()
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end)
        end

        flyKeyDown = UIS.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == Enum.KeyCode.W then
                CONTROL.F = iyflyspeed
            elseif input.KeyCode == Enum.KeyCode.S then
                CONTROL.B = -iyflyspeed
            elseif input.KeyCode == Enum.KeyCode.A then
                CONTROL.L = -iyflyspeed
            elseif input.KeyCode == Enum.KeyCode.D then
                CONTROL.R = iyflyspeed
            elseif input.KeyCode == Enum.KeyCode.E and QEfly then
                CONTROL.Q = iyflyspeed * 2
            elseif input.KeyCode == Enum.KeyCode.Q and QEfly then
                CONTROL.E = -iyflyspeed * 2
            end
        end)

        flyKeyUp = UIS.InputEnded:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == Enum.KeyCode.W then
                CONTROL.F = 0
            elseif input.KeyCode == Enum.KeyCode.S then
                CONTROL.B = 0
            elseif input.KeyCode == Enum.KeyCode.A then
                CONTROL.L = 0
            elseif input.KeyCode == Enum.KeyCode.D then
                CONTROL.R = 0
            elseif input.KeyCode == Enum.KeyCode.E then
                CONTROL.Q = 0
            elseif input.KeyCode == Enum.KeyCode.Q then
                CONTROL.E = 0
            end
        end)

        FLY()
    end

    local function NOFLY()
        FLYING = false
        if flyKeyDown then flyKeyDown:Disconnect() end
        if flyKeyUp then flyKeyUp:Disconnect() end
        local c = plr.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then
            h.PlatformStand = false
        end
    end

    local function unmobilefly(speaker)
        pcall(function()
            FLYING = false
            local root = getRoot(speaker.Character)
            if root then
                local bv = root:FindFirstChild(velocityHandlerName)
                local bg = root:FindFirstChild(gyroHandlerName)
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
            local h = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
            if h then h.PlatformStand = false end
            if mfly1 then mfly1:Disconnect() end
            if mfly2 then mfly2:Disconnect() end
        end)
    end

    local function mobilefly(speaker)
        unmobilefly(speaker)
        FLYING = true

        local root = getRoot(speaker.Character)
        if not root then return end
        local camera = workspace.CurrentCamera
        local v3none = Vector3.new()
        local v3zero = Vector3.new(0, 0, 0)
        local v3inf = Vector3.new(9e9, 9e9, 9e9)

        local controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

        local bv = Instance.new("BodyVelocity")
        bv.Name = velocityHandlerName
        bv.Parent = root
        bv.MaxForce = v3zero
        bv.Velocity = v3zero

        local bg = Instance.new("BodyGyro")
        bg.Name = gyroHandlerName
        bg.Parent = root
        bg.MaxTorque = v3inf
        bg.P = 1000
        bg.D = 50

        mfly1 = speaker.CharacterAdded:Connect(function(newChar)
            task.wait(0.2)
            local newRoot = getRoot(newChar)
            if not newRoot then return end
            local bv2 = Instance.new("BodyVelocity")
            bv2.Name = velocityHandlerName
            bv2.Parent = newRoot
            bv2.MaxForce = v3zero
            bv2.Velocity = v3zero

            local bg2 = Instance.new("BodyGyro")
            bg2.Name = gyroHandlerName
            bg2.Parent = newRoot
            bg2.MaxTorque = v3inf
            bg2.P = 1000
            bg2.D = 50
        end)

        mfly2 = rs.RenderStepped:Connect(function()
            root = getRoot(speaker.Character)
            camera = workspace.CurrentCamera
            local humanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
            if humanoid and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
                local VelocityHandler = root:FindFirstChild(velocityHandlerName)
                local GyroHandler = root:FindFirstChild(gyroHandlerName)

                VelocityHandler.MaxForce = v3inf
                GyroHandler.MaxTorque = v3inf
                humanoid.PlatformStand = true
                GyroHandler.CFrame = camera.CoordinateFrame
                VelocityHandler.Velocity = v3none

                local direction = controlModule:GetMoveVector()
                local spd = iyflyspeed * 50
                if direction.X ~= 0 then
                    VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * spd)
                end
                if direction.Z ~= 0 then
                    VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * spd)
                end
            end
        end)
    end

    local function setFly(enabled, speed)
        if speed and isNumber(speed) then
            iyflyspeed = tonumber(speed)
        end
        if enabled then
            if not IsOnMobile then
                NOFLY()
                task.wait()
                sFLY()
            else
                mobilefly(plr)
            end
        else
            if not IsOnMobile then
                NOFLY()
            else
                unmobilefly(plr)
            end
        end
    end

    -- ========================
    -- KONFIGURASI SWIM
    -- ========================
    local swimming = false
    local swimConnection = nil
    local swimBodyVel = nil
    local swimBodyGyro = nil
    local savedStates = {}

    local function stopSwim()
        swimming = false
        states.swim = false

        if swimConnection then
            swimConnection:Disconnect()
            swimConnection = nil
        end

        if swimBodyVel then
            swimBodyVel:Destroy()
            swimBodyVel = nil
        end

        if swimBodyGyro then
            swimBodyGyro:Destroy()
            swimBodyGyro = nil
        end

        local targetPlr = players.LocalPlayer
        local targetChar = targetPlr and targetPlr.Character
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

        if targetHum then
            for state, enabled in pairs(savedStates) do
                pcall(function()
                    targetHum:SetStateEnabled(state, enabled)
                end)
            end
            targetHum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        savedStates = {}
    end

    local function startSwim(speed)
        local targetPlr = players.LocalPlayer
        local targetChar = targetPlr and targetPlr.Character
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        local root = targetChar and getRoot(targetChar)

        if not targetChar or not targetHum or not root then
            return
        end

        if swimming then
            stopSwim()
        end

        swimming = true
        states.swim = true
        local swimSpeed = tonumber(speed) or 25

        local statesToToggle = {
            Enum.HumanoidStateType.Climbing,
            Enum.HumanoidStateType.FallingDown,
            Enum.HumanoidStateType.Flying,
            Enum.HumanoidStateType.Freefall,
            Enum.HumanoidStateType.GettingUp,
            Enum.HumanoidStateType.Jumping,
            Enum.HumanoidStateType.Landed,
            Enum.HumanoidStateType.Physics,
            Enum.HumanoidStateType.Ragdoll,
            Enum.HumanoidStateType.Running,
            Enum.HumanoidStateType.RunningNoPhysics,
            Enum.HumanoidStateType.Seated,
            Enum.HumanoidStateType.StrafingNoPhysics,
            Enum.HumanoidStateType.Swimming,
        }

        savedStates = {}
        for _, state in ipairs(statesToToggle) do
            savedStates[state] = targetHum:GetStateEnabled(state)
            pcall(function()
                targetHum:SetStateEnabled(state, false)
            end)
        end
        targetHum:ChangeState(Enum.HumanoidStateType.Swimming)

        swimBodyVel = Instance.new("BodyVelocity")
        swimBodyVel.Name = "IYSwimVelocity"
        swimBodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        swimBodyVel.Velocity = Vector3.zero
        swimBodyVel.Parent = root

        swimBodyGyro = Instance.new("BodyGyro")
        swimBodyGyro.Name = "IYSwimGyro"
        swimBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        swimBodyGyro.P = 3000
        swimBodyGyro.CFrame = workspace.CurrentCamera.CFrame
        swimBodyGyro.Parent = root

        swimConnection = rs.RenderStepped:Connect(function()
            local currentChar = targetPlr.Character
            local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
            local currentRoot = currentChar and getRoot(currentChar)
            local currentCam = workspace.CurrentCamera

            if not swimming or not currentChar or not currentHum or not currentRoot or currentHum.Health <= 0 then
                stopSwim()
                return
            end

            local moveDir = currentHum.MoveDirection
            if moveDir.Magnitude > 0 then
                local lookVec = currentCam.CFrame.LookVector
                local rightVec = currentCam.CFrame.RightVector
                local forwardInput = moveDir:Dot(Vector3.new(lookVec.X, 0, lookVec.Z).Unit)
                local rightInput = moveDir:Dot(Vector3.new(rightVec.X, 0, rightVec.Z).Unit)

                local desiredVel = (currentCam.CFrame.LookVector * forwardInput + rightVec * rightInput)
                if desiredVel.Magnitude > 0 then
                    desiredVel = desiredVel.Unit * swimSpeed
                end
                swimBodyVel.Velocity = desiredVel
            else
                swimBodyVel.Velocity = Vector3.zero
            end

            if currentCam then
                swimBodyGyro.CFrame = currentCam.CFrame
            end
        end)
    end

    -- ==========================================
    --  SAFE ANTI-DETECT
    -- ==========================================
    local connection1, connection2

    local function scanAndDisableClientChecks(root)
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("LocalScript") then
                local name = obj.Name:lower()
                if name:find("anticheat") or name:find("detector") or name:find("adonis") then
                    pcall(function()
                        obj.Disabled = true
                    end)
                end
            end
        end
    end

    local function applyAntiDetect(state)
        if state then
            pcall(function()
                scanAndDisableClientChecks(plr.PlayerGui)
                scanAndDisableClientChecks(plr.StarterGear)
            end)

            if not connection1 then
                connection1 = workspace.DescendantAdded:Connect(function(v)
                    local n = v.Name:lower()
                    if n:find("anticheat") or n:find("detector") then
                        pcall(function()
                            if v:IsA("BasePart") then
                                v.CanTouch = false
                                v.CanQuery = false
                                v.CanCollide = false
                            elseif v:IsA("LocalScript") then
                                v.Disabled = true
                            end
                        end)
                    end
                end)
            end

            if not connection2 then
                connection2 = plr.PlayerGui.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("LocalScript") then
                        local name = descendant.Name:lower()
                        if name:find("anticheat") or name:find("detector") then
                            pcall(function()
                                descendant.Disabled = true
                            end)
                        end
                    end
                end)
            end
        else
            if connection1 then connection1:Disconnect(); connection1 = nil end
            if connection2 then connection2:Disconnect(); connection2 = nil end
        end
    end

    customNotify("Meknoyu Hub", "System Fully Loaded!", 5)

    local oldAmbient = lighting.Ambient
    local oldOutdoor = lighting.OutdoorAmbient

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

    local function giveTpTool()
        local oldTool = plr.Backpack:FindFirstChild("Mekno TP Tool") or (char and char:FindFirstChild("Mekno TP Tool"))
        if oldTool then oldTool:Destroy() end
        local tpTool = Instance.new("Tool")
        tpTool.Name = "Mekno TP Tool"
        tpTool.RequiresHandle = false
        tpTool.Activated:Connect(function()
            if mouse.Hit and hrp then
                lastPos = CFrame.new(mouse.Hit.p + Vector3.new(0, 5, 0))
                hrp.CFrame = lastPos
            end
        end)
        tpTool.Parent = plr.Backpack
    end

    local function setupChar(c)
        char = c; hum = c:WaitForChild("Humanoid", 10); hrp = c:WaitForChild("HumanoidRootPart", 10)
        if hrp then lastPos = hrp.CFrame end
        if states.tooltp then task.defer(giveTpTool) end
        if states.spectate then task.defer(function() applySpectateCamera(spectateTarget) end) end
    end
    if plr.Character then setupChar(plr.Character) end
    plr.CharacterAdded:Connect(setupChar)

    --// TELEPORT BACK HUB //--
    local tpBackGui = Instance.new("Frame", screenGui); tpBackGui.Size = UDim2.new(0, 160, 0, 100); tpBackGui.Position = UDim2.new(0.8, 0, 0.5, 0); tpBackGui.BackgroundColor3 = Color3.fromRGB(55,55,65); tpBackGui.BackgroundTransparency = 0; tpBackGui.Visible = false; tpBackGui.Active = true; tpBackGui.Draggable = true; Instance.new("UICorner", tpBackGui); applyBlackGreyGradient(tpBackGui)
    local saveBtn = Instance.new("TextButton", tpBackGui); saveBtn.Size = UDim2.new(0, 160 * 0.9, 0, 100 * 0.4); saveBtn.Position = UDim2.new(0.05, 0, 0.05, 0); saveBtn.Text = "Save Pos : OFF"; saveBtn.BackgroundColor3 = Color3.fromRGB(55,55,65); saveBtn.BackgroundTransparency = 0; saveBtn.TextTransparency = 0; saveBtn.TextColor3 = Color3.fromRGB(255,255,255); saveBtn.TextStrokeTransparency = 0; saveBtn.TextStrokeColor3 = Color3.new(0,0,0); Instance.new("UICorner", saveBtn); applyBlackGreyGradient(saveBtn)
    local clickTpBtn = Instance.new("TextButton", tpBackGui); clickTpBtn.Size = UDim2.new(0, 160 * 0.9, 0, 100 * 0.4); clickTpBtn.Position = UDim2.new(0.05, 0, 0.55, 0); clickTpBtn.Text = "Click TP Back"; clickTpBtn.BackgroundColor3 = Color3.fromRGB(55,55,65); clickTpBtn.BackgroundTransparency = 0; clickTpBtn.TextTransparency = 0; clickTpBtn.TextColor3 = Color3.fromRGB(255,255,255); clickTpBtn.TextStrokeTransparency = 0; clickTpBtn.TextStrokeColor3 = Color3.new(0,0,0); Instance.new("UICorner", clickTpBtn); applyBlackGreyGradient(clickTpBtn)
    saveBtn.MouseButton1Click:Connect(function() states.savepos = not states.savepos; saveBtn.Text = "Save Pos : " .. (states.savepos and "ON" or "OFF"); if states.savepos and hrp then savedPos = hrp.CFrame; lastPos = savedPos end end)
    clickTpBtn.MouseButton1Click:Connect(function() if savedPos and hrp then task.wait(0.1); hrp.CFrame = savedPos end end)

    -- // MAIN HUB STRUCTURE //
    local main = Instance.new("Frame", screenGui)
    main.Size = UDim2.new(0, 510, 0, 300)
    main.Position = UDim2.new(0.5, -255, 0.5, -150)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    main.BackgroundTransparency = 0
    main.Active = true; main.Draggable = true; Instance.new("UICorner", main)
    applyBlackGreyGradient(main)

    -- ==========================================
    --        FPS & MS (PING) DISPLAY SYSTEM
    -- ==========================================
    local statsLabel = Instance.new("TextLabel", main)
    statsLabel.Size = UDim2.new(0, 120, 0, 20)
    statsLabel.Position = UDim2.new(1, -245, 0, 7)
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
            local ping = 0
            pcall(function()
                ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
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

    local miniCorner = Instance.new("UICorner", miniBtn)
    miniCorner.CornerRadius = UDim.new(0, 6)

    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Thickness = 1.8

    local isRainbow = true
    rs.RenderStepped:Connect(function()
        if isRainbow then
            local hue = (tick() * 0.15) % 1
            stroke.Color = Color3.fromHSV(hue, 0.8, 1)
            miniStroke.Color = Color3.fromHSV(hue, 0.8, 1)
        end
    end)

    -- ==========================================
    --        3 SMALL DOTS AT TOP LEFT
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
    header.Size = UDim2.new(0, 120, 0, 25); header.Position = UDim2.new(0, 65, 0, 5)
    header.Text = "Meknoyu Hub"; header.BackgroundTransparency = 1; header.TextTransparency = 0; header.TextColor3 = Color3.new(1,1,1); header.Font = Enum.Font.GothamBold; header.TextSize = 18; header.TextXAlignment = Enum.TextXAlignment.Left

    local currentTier = getUserKeyTier(plr)
    local keySystemLabel = Instance.new("TextLabel", main)
    keySystemLabel.Size = UDim2.new(1, -245, 0, 15)
    keySystemLabel.Position = UDim2.new(0, 65, 0, 28)
    keySystemLabel.BackgroundTransparency = 1
    keySystemLabel.TextTransparency = 0
    keySystemLabel.Font = Enum.Font.GothamMedium
    keySystemLabel.TextSize = 11
    keySystemLabel.TextXAlignment = Enum.TextXAlignment.Left
    keySystemLabel.RichText = true
    keySystemLabel.Text = getTierRichText(currentTier)
    keySystemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    local closeBtn = Instance.new("TextButton", main); closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 7); closeBtn.Text = "X"; closeBtn.TextTransparency = 0; closeBtn.TextColor3 = Color3.new(1,0,0); closeBtn.TextStrokeTransparency = 0; closeBtn.TextStrokeColor3 = Color3.new(0,0,0); closeBtn.BackgroundColor3 = Color3.fromRGB(55,55,65); closeBtn.BackgroundTransparency = 0; Instance.new("UICorner", closeBtn); applyBlackGreyGradient(closeBtn)

    -- ==========================================
    --        RESIZE BUTTON (- / +)
    -- ==========================================
    local isEnlarged = false
    local normalSize = UDim2.new(0, 510, 0, 300)
    local normalPos = UDim2.new(0.5, -255, 0.5, -150)
    local enlargedSize = UDim2.new(0, 640, 0, 390)
    local enlargedPos = UDim2.new(0.5, -320, 0.5, -195)

    local resizeBtn = Instance.new("TextButton", main)
    resizeBtn.Size = UDim2.new(0, 30, 0, 30)
    resizeBtn.Position = UDim2.new(1, -70, 0, 7)
    resizeBtn.Text = "-"
    resizeBtn.TextTransparency = 0
    resizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resizeBtn.TextStrokeTransparency = 0
    resizeBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    resizeBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    resizeBtn.BackgroundTransparency = 0
    resizeBtn.Font = Enum.Font.GothamBold
    resizeBtn.TextSize = 14
    Instance.new("UICorner", resizeBtn)
    applyBlackGreyGradient(resizeBtn)

    -- ==========================================
    --        CUSTOM KEYBIND E
    -- ==========================================
    local currentToggleKey = Enum.KeyCode.E
    local bindBox = Instance.new("TextBox", main)
    bindBox.Size = UDim2.new(0, 35, 0, 30)
    bindBox.Position = UDim2.new(1, -110, 0, 7)
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
            if keyEnum then
                currentToggleKey = keyEnum
                bindBox.Text = string.sub(text, 1, 1)
            else
                bindBox.Text = string.sub(tostring(currentToggleKey.Name), 1, 1)
            end
        end
    end)

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == currentToggleKey then
            if main.Visible then
                closeBtn.MouseButton1Click:Fire()
            else
                miniBtn.MouseButton1Click:Fire()
            end
        end
    end)

    -- ==========================================
    --        COMMUNITY UI (?)
    -- ==========================================
    local communityGui = Instance.new("Frame", screenGui)
    communityGui.Name = "MeknoyuCommunityGui"
    communityGui.Size = UDim2.new(0, 300, 0, 150)
    communityGui.Position = UDim2.new(0.5, -150, 0.5, -75)
    communityGui.BackgroundColor3 = Color3.fromRGB(35, 35, 44)
    communityGui.BackgroundTransparency = 0
    communityGui.Visible = false
    communityGui.Active = true
    communityGui.Draggable = true
    Instance.new("UICorner", communityGui).CornerRadius = UDim.new(0, 8)
    applyBlackGreyGradient(communityGui)

    local commStroke = Instance.new("UIStroke", communityGui)
    commStroke.Thickness = 2
    rs.RenderStepped:Connect(function()
        commStroke.Color = Color3.fromHSV((tick() * 0.15) % 1, 0.8, 1)
    end)

    local commTitle = Instance.new("TextLabel", communityGui)
    commTitle.Size = UDim2.new(1, -45, 0, 22)
    commTitle.Position = UDim2.new(0, 12, 0, 8)
    commTitle.BackgroundTransparency = 1
    commTitle.Text = "Meknoyu"
    commTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    commTitle.Font = Enum.Font.GothamBold
    commTitle.TextSize = 16
    commTitle.TextXAlignment = Enum.TextXAlignment.Left

    local commSubTitle = Instance.new("TextLabel", communityGui)
    commSubTitle.Size = UDim2.new(1, -45, 0, 16)
    commSubTitle.Position = UDim2.new(0, 12, 0, 28)
    commSubTitle.BackgroundTransparency = 1
    commSubTitle.Text = "Community"
    commSubTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
    commSubTitle.Font = Enum.Font.GothamBold
    commSubTitle.TextSize = 12
    commSubTitle.TextXAlignment = Enum.TextXAlignment.Left

    local commDesc = Instance.new("TextLabel", communityGui)
    commDesc.Size = UDim2.new(1, -24, 0, 34)
    commDesc.Position = UDim2.new(0, 12, 0, 48)
    commDesc.BackgroundTransparency = 1
    commDesc.Text = "Meknoyu provides information for script users who like this script"
    commDesc.TextColor3 = Color3.fromRGB(220, 220, 220)
    commDesc.Font = Enum.Font.Gotham
    commDesc.TextSize = 10
    commDesc.TextWrapped = true
    commDesc.TextXAlignment = Enum.TextXAlignment.Left
    commDesc.TextYAlignment = Enum.TextYAlignment.Top

    local commPill = Instance.new("Frame", communityGui)
    commPill.Size = UDim2.new(1, -24, 0, 32)
    commPill.Position = UDim2.new(0, 12, 1, -42)
    commPill.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    commPill.BackgroundTransparency = 0
    Instance.new("UICorner", commPill).CornerRadius = UDim.new(1, 0)
    applyBlackGreyGradient(commPill)

    local commPillLabel = Instance.new("TextLabel", commPill)
    commPillLabel.Size = UDim2.new(1, -16, 1, 0)
    commPillLabel.Position = UDim2.new(0, 8, 0, 0)
    commPillLabel.BackgroundTransparency = 1
    commPillLabel.Text = "Suggestions, Bug reports, Updates"
    commPillLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    commPillLabel.Font = Enum.Font.GothamSemibold
    commPillLabel.TextSize = 10

    local commCloseBtn = Instance.new("TextButton", communityGui)
    commCloseBtn.Size = UDim2.new(0, 26, 0, 26)
    commCloseBtn.Position = UDim2.new(1, -34, 0, 8)
    commCloseBtn.Text = "X"
    commCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    commCloseBtn.Font = Enum.Font.GothamBold
    commCloseBtn.TextSize = 12
    commCloseBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    Instance.new("UICorner", commCloseBtn).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(commCloseBtn)
    commCloseBtn.MouseButton1Click:Connect(function()
        communityGui.Visible = false
    end)

    local helpBtn = Instance.new("TextButton", main)
    helpBtn.Name = "MeknoyuHelpBtn"
    helpBtn.Size = UDim2.new(0, 24, 0, 24)
    helpBtn.Position = UDim2.new(0, 188, 0, 5)
    helpBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    helpBtn.BackgroundTransparency = 0
    helpBtn.TextTransparency = 0
    helpBtn.Text = "?"
    helpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    helpBtn.TextStrokeTransparency = 0
    helpBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    helpBtn.Font = Enum.Font.GothamBold
    helpBtn.TextSize = 13
    Instance.new("UICorner", helpBtn).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(helpBtn)

    local helpStroke = Instance.new("UIStroke", helpBtn)
    helpStroke.Thickness = 1.8
    rs.RenderStepped:Connect(function()
        helpStroke.Color = Color3.fromHSV((tick() * 0.15) % 1, 0.8, 1)
    end)

    helpBtn.MouseButton1Click:Connect(function()
        communityGui.Visible = not communityGui.Visible
    end)

    -- ==========================================
    --        TWEEN ANIMATION SYSTEM
    -- ==========================================
    local originalMainSize = normalSize
    local originalMainPos = normalPos
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    resizeBtn.MouseButton1Click:Connect(function()
        isEnlarged = not isEnlarged
        local targetSize = isEnlarged and enlargedSize or normalSize
        local targetPos = isEnlarged and enlargedPos or normalPos
        resizeBtn.Text = isEnlarged and "+" or "-"
        originalMainSize = targetSize
        originalMainPos = targetPos
        local resizeTween = TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = targetSize,
            Position = targetPos
        })
        resizeTween:Play()
    end)

    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(main.Position.X.Scale, main.Position.Y.Offset + (main.Size.Y.Offset/2), main.Position.Y.Scale, main.Position.Y.Offset + (main.Size.Y.Offset/2))
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

        local openTween = TweenService:Create(main, tweenInfo, {
            Size = originalMainSize,
            Position = originalMainPos
        })
        openTween:Play()
    end)

    local tabContainer = Instance.new("ScrollingFrame", main)
    tabContainer.Size = UDim2.new(0, 100, 1, -150)
    tabContainer.Position = UDim2.new(0, 5, 0, 48)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 0
    tabContainer.CanvasSize = UDim2.new(0, 0, 2.5, 0)
    local UIList = Instance.new("UIListLayout", tabContainer); UIList.Padding = UDim.new(0, 5)

    -- ==========================================
    --        PROFILE & MAP INFO SYSTEM
    -- ==========================================
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

    rs.RenderStepped:Connect(function()
        profileStroke.Color = Color3.fromHSV((tick() * 0.3) % 1, 0.8, 1)
    end)

    local displayNameLabel = Instance.new("TextLabel", profileFrame)
    displayNameLabel.Size = UDim2.new(0, 60, 0, 12)
    displayNameLabel.Position = UDim2.new(0, 38, 0, 2)
    displayNameLabel.BackgroundTransparency = 1
    displayNameLabel.TextTransparency = 0
    displayNameLabel.Text = "Name: " .. plr.DisplayName
    displayNameLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
    displayNameLabel.Font = Enum.Font.GothamBold
    displayNameLabel.TextSize = 8
    displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local useridLabel = Instance.new("TextLabel", profileFrame)
    useridLabel.Size = UDim2.new(0, 60, 0, 12)
    useridLabel.Position = UDim2.new(0, 38, 0, 14)
    useridLabel.BackgroundTransparency = 1
    useridLabel.TextTransparency = 0
    useridLabel.Text = "UserID: " .. plr.UserId
    useridLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    useridLabel.Font = Enum.Font.GothamMedium
    useridLabel.TextSize = 7
    useridLabel.TextXAlignment = Enum.TextXAlignment.Left

    local mapIcon = Instance.new("ImageLabel", profileFrame)
    mapIcon.Size = UDim2.new(0, 22, 0, 22)
    mapIcon.Position = UDim2.new(0, 2, 0, 38)
    mapIcon.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    Instance.new("UICorner", mapIcon).CornerRadius = UDim.new(0, 4)

    local mapNameLabel = Instance.new("TextLabel", profileFrame)
    mapNameLabel.Size = UDim2.new(0, 72, 0, 25)
    mapNameLabel.Position = UDim2.new(0, 28, 0, 36)
    mapNameLabel.BackgroundTransparency = 1
    mapNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    mapNameLabel.Font = Enum.Font.GothamBold
    mapNameLabel.TextSize = 8
    mapNameLabel.TextWrapped = true
    mapNameLabel.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        local success, info = pcall(function()
            return mps:GetProductInfo(game.PlaceId)
        end)
        if success and info then
            mapNameLabel.Text = "Map Name:\n" .. info.Name
            if info.IconImageAssetId and info.IconImageAssetId > 0 then
                mapIcon.Image = "rbxassetid://" .. tostring(info.IconImageAssetId)
            else
                mapIcon.Image = "rbxassetid://6023426915"
            end
        else
            mapNameLabel.Text = "Map Name:\n" .. game.Name
            mapIcon.Image = "rbxassetid://6023426915"
        end
    end)

    local function generateHwid()
        local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        local function part(n)
            local s = ""
            for i = 1, n do
                local rand = math.random(1, #chars)
                s = s .. string.sub(chars, rand, rand)
            end
            return s
        end
        return part(4) .. "-" .. part(4) .. "-" .. part(4)
    end

    local generatedHwidString = generateHwid()

    local hwidLabel = Instance.new("TextLabel", profileFrame)
    hwidLabel.Size = UDim2.new(0, 96, 0, 15)
    hwidLabel.Position = UDim2.new(0, 2, 0, 68)
    hwidLabel.BackgroundTransparency = 1
    hwidLabel.TextTransparency = 0
    hwidLabel.Text = "HWID: " .. generatedHwidString
    hwidLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
    hwidLabel.Font = Enum.Font.Code
    hwidLabel.TextSize = 8
    hwidLabel.TextXAlignment = Enum.TextXAlignment.Left

    local pages = Instance.new("Frame", main); pages.Size = UDim2.new(1, -115, 1, -50); pages.Position = UDim2.new(0, 110, 0, 45); pages.BackgroundTransparency = 1

    local function createPage(name)
        local p = Instance.new("ScrollingFrame", pages); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0, 0, 3.5, 0)
        local grid = Instance.new("UIGridLayout", p); grid.CellSize = UDim2.new(0.48, 0, 0, 32); grid.CellPadding = UDim2.new(0, 5, 0, 5)
        return p
    end

    local pageMain = createPage("Main")
    local pageNoToggle = createPage("NoToggle")
    local pageSelectAnti = createPage("SelectAnti")
    local pageFeature = createPage("Feature")
    local pageGames = createPage("Games")
    local pageServer = createPage("Server")

    -- OVERVIEW TAB
    local pageOverview = Instance.new("ScrollingFrame", pages)
    pageOverview.Name = "Overview"
    pageOverview.Size = UDim2.new(1, 0, 1, 0)
    pageOverview.Visible = false
    pageOverview.BackgroundTransparency = 1
    pageOverview.ScrollBarThickness = 2
    pageOverview.CanvasSize = UDim2.new(0, 0, 4.8, 0)
    local overviewLayout = Instance.new("UIListLayout", pageOverview)
    overviewLayout.Padding = UDim.new(0, 8)
    overviewLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local overviewBox = Instance.new("Frame", pageOverview)
    overviewBox.Size = UDim2.new(0.95, 0, 0, 190)
    overviewBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    overviewBox.BackgroundTransparency = 0
    Instance.new("UICorner", overviewBox).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(overviewBox)
    local overviewStroke = Instance.new("UIStroke", overviewBox)
    overviewStroke.Thickness = 1.5
    rs.RenderStepped:Connect(function()
        overviewStroke.Color = Color3.fromHSV((tick() * 0.1) % 1, 0.8, 1)
    end)

    local overviewTitle = Instance.new("TextLabel", overviewBox)
    overviewTitle.Size = UDim2.new(1, -10, 0, 30)
    overviewTitle.Position = UDim2.new(0, 10, 0, 5)
    overviewTitle.BackgroundTransparency = 1
    overviewTitle.Text = "Session & Server"
    overviewTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    overviewTitle.Font = Enum.Font.GothamBold
    overviewTitle.TextSize = 12
    overviewTitle.TextXAlignment = Enum.TextXAlignment.Left

    local overviewTextInfo = Instance.new("TextLabel", overviewBox)
    overviewTextInfo.Size = UDim2.new(1, -20, 1, -40)
    overviewTextInfo.Position = UDim2.new(0, 10, 0, 35)
    overviewTextInfo.BackgroundTransparency = 1
    overviewTextInfo.Text = "Loading Session & Server Info..."
    overviewTextInfo.TextColor3 = Color3.fromRGB(220, 220, 220)
    overviewTextInfo.Font = Enum.Font.Code
    overviewTextInfo.TextSize = 10
    overviewTextInfo.TextWrapped = true
    overviewTextInfo.TextXAlignment = Enum.TextXAlignment.Left
    overviewTextInfo.TextYAlignment = Enum.TextYAlignment.Top

    task.spawn(function()
        while true do
            local playerCount = #players:GetPlayers()
            local maxPlayers = players.MaxPlayers
            local placeId = game.PlaceId
            local jobId = game.JobId
            local dt = rs.RenderStepped:Wait()
            local fpsVal = math.floor(1 / math.max(dt, 0.001))
            local pingVal = 0
            pcall(function()
                pingVal = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            overviewTextInfo.Text = string.format(
                "• Game Place ID: %s\n• Server Job ID: %s\n• Total Players: %d / %d\n• Current FPS: ~%d\n• Server Ping (MS): %d ms\n• Account Age: %d Days\n• Execution Engine: %s",
                tostring(placeId),
                tostring(jobId),
                playerCount,
                maxPlayers,
                fpsVal,
                pingVal,
                plr.AccountAge,
                (identifyexecutor and identifyexecutor()) or "Unknown"
            )
            task.wait(1)
        end
    end)

    local profileBox = Instance.new("Frame", pageOverview)
    profileBox.Size = UDim2.new(0.95, 0, 0, 180)
    profileBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    profileBox.BackgroundTransparency = 0
    Instance.new("UICorner", profileBox).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(profileBox)
    local profileBoxStroke = Instance.new("UIStroke", profileBox)
    profileBoxStroke.Thickness = 1.5
    rs.RenderStepped:Connect(function()
        profileBoxStroke.Color = Color3.fromHSV((tick() * 0.15) % 1, 0.8, 1)
    end)

    local profileBoxTitle = Instance.new("TextLabel", profileBox)
    profileBoxTitle.Size = UDim2.new(1, -10, 0, 30)
    profileBoxTitle.Position = UDim2.new(0, 10, 0, 5)
    profileBoxTitle.BackgroundTransparency = 1
    profileBoxTitle.Text = "Player Profile"
    profileBoxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    profileBoxTitle.Font = Enum.Font.GothamBold
    profileBoxTitle.TextSize = 12
    profileBoxTitle.TextXAlignment = Enum.TextXAlignment.Left

    local profileTextInfo = Instance.new("TextLabel", profileBox)
    profileTextInfo.Size = UDim2.new(1, -20, 1, -40)
    profileTextInfo.Position = UDim2.new(0, 10, 0, 35)
    profileTextInfo.BackgroundTransparency = 1
    profileTextInfo.Text = string.format(
        "• Username: %s\n• Display Name: %s\n• User ID: %d\n• Account Age: %d Days\n• Membership Type: %s\n• Team: %s\n• HWID String: %s",
        plr.Name,
        plr.DisplayName,
        plr.UserId,
        plr.AccountAge,
        tostring(plr.MembershipType),
        tostring(plr.Team and plr.Team.Name or "None"),
        generatedHwidString
    )
    profileTextInfo.TextColor3 = Color3.fromRGB(220, 220, 220)
    profileTextInfo.Font = Enum.Font.Code
    profileTextInfo.TextSize = 10
    profileTextInfo.TextWrapped = true
    profileTextInfo.TextXAlignment = Enum.TextXAlignment.Left
    profileTextInfo.TextYAlignment = Enum.TextYAlignment.Top

    local charBox = Instance.new("Frame", pageOverview)
    charBox.Size = UDim2.new(0.95, 0, 0, 150)
    charBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    charBox.BackgroundTransparency = 0
    Instance.new("UICorner", charBox).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(charBox)
    local charBoxStroke = Instance.new("UIStroke", charBox)
    charBoxStroke.Thickness = 1.5
    rs.RenderStepped:Connect(function()
        charBoxStroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1)
    end)

    local charBoxTitle = Instance.new("TextLabel", charBox)
    charBoxTitle.Size = UDim2.new(1, -10, 0, 28)
    charBoxTitle.Position = UDim2.new(0, 10, 0, 4)
    charBoxTitle.BackgroundTransparency = 1
    charBoxTitle.Text = "Character"
    charBoxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    charBoxTitle.Font = Enum.Font.GothamBold
    charBoxTitle.TextSize = 12
    charBoxTitle.TextXAlignment = Enum.TextXAlignment.Left

    local avatarPreview = Instance.new("ImageLabel", charBox)
    avatarPreview.Size = UDim2.new(0, 95, 0, 95)
    avatarPreview.Position = UDim2.new(0, 12, 0, 36)
    avatarPreview.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    avatarPreview.Image = "https://www.roblox.com/Thumbs/Avatar.ashx?x=352&y=352&Format=Png&userId=" .. plr.UserId
    Instance.new("UICorner", avatarPreview).CornerRadius = UDim.new(0, 6)

    local charInfoLabel = Instance.new("TextLabel", charBox)
    charInfoLabel.Size = UDim2.new(1, -120, 0, 95)
    charInfoLabel.Position = UDim2.new(0, 115, 0, 36)
    charInfoLabel.BackgroundTransparency = 1
    charInfoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    charInfoLabel.Font = Enum.Font.Code
    charInfoLabel.TextSize = 10
    charInfoLabel.TextWrapped = true
    charInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    charInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
    charInfoLabel.Text = string.format(
        "• Avatar: %s\n• User ID: %d\n• Rig Type: %s\n• Status: Active",
        plr.Name,
        plr.UserId,
        (hum and tostring(hum.RigType)) or "Unknown"
    )

    local pageCustomize = Instance.new("ScrollingFrame", pages)
    pageCustomize.Name = "Customize"
    pageCustomize.Size = UDim2.new(1, 0, 1, 0)
    pageCustomize.Visible = false
    pageCustomize.BackgroundTransparency = 1
    pageCustomize.ScrollBarThickness = 2
    pageCustomize.CanvasSize = UDim2.new(0, 0, 3.5, 0)
    local custLayout = Instance.new("UIListLayout", pageCustomize)
    custLayout.Padding = UDim.new(0, 8)
    custLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function addTab(name, targetPage, lockedCheckFn)
        local btn = Instance.new("TextButton", tabContainer)
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        btn.BackgroundTransparency = 0
        btn.TextTransparency = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextStrokeTransparency = 0.5
        btn.TextStrokeColor3 = Color3.new(0, 0, 0)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.TextWrapped = true
        btn.ZIndex = 2
        Instance.new("UICorner", btn)
        applyBlackGreyGradient(btn)

        local tInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, tInfo, {TextTransparency = 0.2}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, tInfo, {TextTransparency = 0}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            if lockedCheckFn and not lockedCheckFn() then
                customNotify("Feature Locked", "Feature (Only Premium) is only for PREMIUM and OWNER keys.", 4)
                return
            end
            btn.Size = UDim2.new(0.9, 0, 0, 24)
            local clickTween = TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 26)})
            clickTween:Play()

            for _, v in pairs(pages:GetChildren()) do v.Visible = false end
            targetPage.Visible = true
        end)
        return btn
    end

    addTab("Main", pageMain)
    addTab("Visuals", pageNoToggle)
    addTab("Select Anti", pageSelectAnti)
    addTab(canAccessFeatureTab(plr) and "Feature" or "Feature (Only Premium)", pageFeature, function()
        return canAccessFeatureTab(plr)
    end)
    addTab("Overview", pageOverview)
    addTab("Customize", pageCustomize)
    addTab("Games", pageGames)
    addTab("Server", pageServer)

    -- // FEATURE TAB CONTENT //
    local function createFeatureBtn(name, url, parent)
        local b = Instance.new("TextButton", parent)
        b.Text = name
        b.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        b.BackgroundTransparency = 0
        b.TextTransparency = 0
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextStrokeTransparency = 0.5
        b.TextStrokeColor3 = Color3.new(0, 0, 0)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.TextWrapped = true
        Instance.new("UICorner", b)
        applyBlackGreyGradient(b)

        b.MouseButton1Click:Connect(function()
            if not canAccessFeatureTab(plr) then
                customNotify("Access Denied", "Only for PREMIUM and OWNER keys.", 3)
                return
            end
            local ok, err = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if ok then
                customNotify("Feature Loaded", name .. " executed.", 3)
            else
                customNotify("Feature Error", tostring(err), 4)
            end
        end)
        return b
    end

    createFeatureBtn("Explorer Property", "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/MeknoyuSor.lua", pageFeature)
    createFeatureBtn("Function Spy", "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/MeknoyuSpy.lua", pageFeature)
    createFeatureBtn("Remote Check", "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/MeknoyuRemote.lua", pageFeature)
    createFeatureBtn("Copy Anything Script", "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/MeknoyuAny.lua", pageFeature)

    local selectedPlayerName = ""
    local selectedFriendName = ""

    -- // CUSTOMIZE TAB CONTENT //
    local dropUIFrame = Instance.new("Frame", pageCustomize)
    dropUIFrame.Size = UDim2.new(0.95, 0, 0, 35)
    dropUIFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    dropUIFrame.BackgroundTransparency = 0
    Instance.new("UICorner", dropUIFrame).CornerRadius = UDim.new(0, 5)
    applyBlackGreyGradient(dropUIFrame)
    local dropUIStroke = Instance.new("UIStroke", dropUIFrame)
    dropUIStroke.Thickness = 2

    rs.RenderStepped:Connect(function()
        dropUIStroke.Color = Color3.fromHSV((tick() * 0.1) % 1, 0.8, 1)
    end)

    local dropUIText = Instance.new("TextButton", dropUIFrame)
    dropUIText.Size = UDim2.new(1, 0, 1, 0)
    dropUIText.BackgroundTransparency = 1
    dropUIText.TextTransparency = 0
    dropUIText.Text = "  Custom UI"
    dropUIText.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropUIText.TextStrokeTransparency = 0.5
    dropUIText.TextStrokeColor3 = Color3.new(0, 0, 0)
    dropUIText.Font = Enum.Font.GothamBold
    dropUIText.TextSize = 12
    dropUIText.TextXAlignment = Enum.TextXAlignment.Left

    local dropUIArrow = Instance.new("TextLabel", dropUIFrame)
    dropUIArrow.Size = UDim2.new(0, 30, 1, 0)
    dropUIArrow.Position = UDim2.new(1, -30, 0, 0)
    dropUIArrow.BackgroundTransparency = 1
    dropUIArrow.TextTransparency = 0
    dropUIArrow.Text = "V"
    dropUIArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropUIArrow.TextStrokeTransparency = 0.5
    dropUIArrow.TextStrokeColor3 = Color3.new(0, 0, 0)
    dropUIArrow.Font = Enum.Font.GothamBold
    dropUIArrow.TextSize = 11

    local contentUIFrame = Instance.new("Frame", pageCustomize)
    contentUIFrame.Size = UDim2.new(0.95, 0, 0, 75)
    contentUIFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    contentUIFrame.BackgroundTransparency = 0
    contentUIFrame.Visible = false
    Instance.new("UICorner", contentUIFrame).CornerRadius = UDim.new(0, 5)

    local sliderTitle = Instance.new("TextLabel", contentUIFrame)
    sliderTitle.Size = UDim2.new(1, 0, 0, 20)
    sliderTitle.Position = UDim2.new(0, 10, 0, 5)
    sliderTitle.BackgroundTransparency = 1
    sliderTitle.TextTransparency = 0
    sliderTitle.Text = "Transparency UI"
    sliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderTitle.TextStrokeTransparency = 0.5
    sliderTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
    sliderTitle.Font = Enum.Font.GothamSemibold
    sliderTitle.TextSize = 11
    sliderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local sliderTrack = Instance.new("Frame", contentUIFrame)
    sliderTrack.Size = UDim2.new(0.85, 0, 0, 5)
    sliderTrack.Position = UDim2.new(0.075, 0, 0, 32)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
    sliderTrack.BorderSizePixel = 0

    local sliderThumb = Instance.new("TextButton", sliderTrack)
    sliderThumb.Size = UDim2.new(0, 12, 0, 12)
    sliderThumb.Position = UDim2.new(0, -6, 0.5, -6)
    sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderThumb.Text = ""
    sliderThumb.TextTransparency = 0
    sliderThumb.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", sliderThumb).CornerRadius = UDim.new(1, 0)

    local sliderValueLabel = Instance.new("TextLabel", contentUIFrame)
    sliderValueLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderValueLabel.Position = UDim2.new(0, 0, 0, 43)
    sliderValueLabel.BackgroundTransparency = 1
    sliderValueLabel.TextTransparency = 0
    sliderValueLabel.Text = "Transparency: 0"
    sliderValueLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
    sliderValueLabel.TextStrokeTransparency = 0.5
    sliderValueLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    sliderValueLabel.Font = Enum.Font.GothamMedium
    sliderValueLabel.TextSize = 11

    local uiOpen = false
    dropUIText.MouseButton1Click:Connect(function()
        uiOpen = not uiOpen
        contentUIFrame.Visible = uiOpen
        dropUIArrow.Text = uiOpen and "^" or "V"
    end)

    local sliding = false
    local function updateSlider()
        if not sliding then return end
        local mX = UIS:GetMouseLocation().X
        local tX = sliderTrack.AbsolutePosition.X
        local tW = sliderTrack.AbsoluteSize.X
        local pct = math.clamp((mX - tX) / math.max(tW, 1), 0, 1)

        sliderThumb.Position = UDim2.new(pct, -6, 0.5, -6)
        local rawVal = math.round(pct * 10) / 10
        sliderValueLabel.Text = "Transparency: " .. rawVal

        main.BackgroundTransparency = rawVal
    end
    sliderThumb.MouseButton1Down:Connect(function() sliding = true end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    rs.RenderStepped:Connect(updateSlider)

    local dropColFrame = Instance.new("Frame", pageCustomize)
    dropColFrame.Size = UDim2.new(0.95, 0, 0, 35)
    dropColFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    dropColFrame.BackgroundTransparency = 0
    Instance.new("UICorner", dropColFrame).CornerRadius = UDim.new(0, 5)
    applyBlackGreyGradient(dropColFrame)
    local dropColStroke = Instance.new("UIStroke", dropColFrame)
    dropColStroke.Thickness = 2

    rs.RenderStepped:Connect(function()
        dropColStroke.Color = Color3.fromHSV((tick() * 0.1) % 1, 0.8, 1)
    end)

    local dropColText = Instance.new("TextButton", dropColFrame)
    dropColText.Size = UDim2.new(1, 0, 1, 0)
    dropColText.BackgroundTransparency = 1
    dropColText.TextTransparency = 0
    dropColText.Text = "  Colors UI"
    dropColText.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropColText.TextStrokeTransparency = 0.5
    dropColText.TextStrokeColor3 = Color3.new(0, 0, 0)
    dropColText.Font = Enum.Font.GothamBold
    dropColText.TextSize = 12
    dropColText.TextXAlignment = Enum.TextXAlignment.Left

    local dropColArrow = Instance.new("TextLabel", dropColFrame)
    dropColArrow.Size = UDim2.new(0, 30, 1, 0)
    dropColArrow.Position = UDim2.new(1, -30, 0, 0)
    dropColArrow.BackgroundTransparency = 1
    dropColArrow.TextTransparency = 0
    dropColArrow.Text = "V"
    dropColArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropColArrow.TextStrokeTransparency = 0.5
    dropColArrow.TextStrokeColor3 = Color3.new(0, 0, 0)
    dropColArrow.Font = Enum.Font.GothamBold
    dropColArrow.TextSize = 11

    local contentColFrame = Instance.new("Frame", pageCustomize)
    contentColFrame.Size = UDim2.new(0.95, 0, 0, 75)
    contentColFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    contentColFrame.BackgroundTransparency = 0
    contentColFrame.Visible = false
    Instance.new("UICorner", contentColFrame).CornerRadius = UDim.new(0, 5)

    local contentColStroke = Instance.new("UIStroke", contentColFrame)
    contentColStroke.Thickness = 1.5
    rs.RenderStepped:Connect(function()
        contentColStroke.Color = Color3.fromHSV((tick() * 0.1) % 1, 0.8, 1)
    end)

    local colGrid = Instance.new("UIGridLayout", contentColFrame)
    colGrid.CellSize = UDim2.new(0, 22, 0, 22)
    colGrid.CellPadding = UDim2.new(0, 8, 0, 6)
    colGrid.SortOrder = Enum.SortOrder.LayoutOrder

    local padingGrid = Instance.new("UIPadding", contentColFrame)
    padingGrid.PaddingTop = UDim.new(0, 6)
    padingGrid.PaddingLeft = UDim.new(0, 10)

    local colorPalette = {
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 128, 0), Color3.fromRGB(128, 0, 255),
        Color3.fromRGB(255, 0, 128), Color3.fromRGB(0, 255, 128), Color3.fromRGB(15, 15, 15)
    }

    for _, color in ipairs(colorPalette) do
        local colorBox = Instance.new("TextButton", contentColFrame)
        colorBox.Text = ""
        colorBox.TextTransparency = 0
        colorBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorBox.BackgroundColor3 = color
        colorBox.BorderSizePixel = 0
        Instance.new("UICorner", colorBox).CornerRadius = UDim.new(0, 4)

        colorBox.MouseButton1Click:Connect(function()
            main.BackgroundColor3 = color
        end)
    end

    local colOpen = false
    dropColText.MouseButton1Click:Connect(function()
        colOpen = not colOpen
        contentColFrame.Visible = colOpen
        dropColArrow.Text = colOpen and "^" or "V"
    end)

    local dropPlayerFrame = Instance.new("Frame", pageCustomize)
    dropPlayerFrame.Size = UDim2.new(0.95, 0, 0, 35)
    dropPlayerFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    dropPlayerFrame.BackgroundTransparency = 0
    Instance.new("UICorner", dropPlayerFrame).CornerRadius = UDim.new(0, 5)
    applyBlackGreyGradient(dropPlayerFrame)
    local dropPlayerStroke = Instance.new("UIStroke", dropPlayerFrame)
    dropPlayerStroke.Thickness = 2
    rs.RenderStepped:Connect(function()
        dropPlayerStroke.Color = Color3.fromHSV((tick() * 0.15) % 1, 0.8, 1)
    end)

    local dropPlayerText = Instance.new("TextButton", dropPlayerFrame)
    dropPlayerText.Size = UDim2.new(1, 0, 1, 0)
    dropPlayerText.BackgroundTransparency = 1
    dropPlayerText.TextTransparency = 0
    dropPlayerText.Text = "  Teleport To Players"
    dropPlayerText.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropPlayerText.TextStrokeTransparency = 0.5
    dropPlayerText.TextStrokeColor3 = Color3.new(0, 0, 0)
    dropPlayerText.Font = Enum.Font.GothamBold
    dropPlayerText.TextSize = 12
    dropPlayerText.TextXAlignment = Enum.TextXAlignment.Left

    local dropPlayerArrow = Instance.new("TextLabel", dropPlayerFrame)
    dropPlayerArrow.Size = UDim2.new(0, 30, 1, 0)
    dropPlayerArrow.Position = UDim2.new(1, -30, 0, 0)
    dropPlayerArrow.BackgroundTransparency = 1
    dropPlayerArrow.TextTransparency = 0
    dropPlayerArrow.Text = "V"
    dropPlayerArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropPlayerArrow.TextStrokeTransparency = 0.5
    dropPlayerArrow.TextStrokeColor3 = Color3.new(0, 0, 0)
    dropPlayerArrow.Font = Enum.Font.GothamBold
    dropPlayerArrow.TextSize = 11

    local listPlayerScroll = Instance.new("ScrollingFrame", pageCustomize)
    listPlayerScroll.Size = UDim2.new(0.95, 0, 0, 100)
    listPlayerScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    listPlayerScroll.BackgroundTransparency = 0
    listPlayerScroll.Visible = false
    listPlayerScroll.ScrollBarThickness = 3
    listPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Instance.new("UICorner", listPlayerScroll).CornerRadius = UDim.new(0, 5)
    local listPlayerLayout = Instance.new("UIListLayout", listPlayerScroll)
    listPlayerLayout.Padding = UDim.new(0, 2)

    local tpPlayerBtn = Instance.new("TextButton", pageCustomize)
    tpPlayerBtn.Size = UDim2.new(0.95, 0, 0, 30)
    tpPlayerBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    tpPlayerBtn.BackgroundTransparency = 0
    tpPlayerBtn.TextTransparency = 0
    tpPlayerBtn.Text = "Teleport"
    tpPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpPlayerBtn.TextStrokeTransparency = 0.5
    tpPlayerBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    tpPlayerBtn.Font = Enum.Font.GothamBold
    tpPlayerBtn.TextSize = 12
    Instance.new("UICorner", tpPlayerBtn).CornerRadius = UDim.new(0, 5)
    applyBlackGreyGradient(tpPlayerBtn)

    local function updatePlayerDropdown()
        for _, child in pairs(listPlayerScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local count = 0
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr then
                count = count + 1
                local pBtn = Instance.new("TextButton", listPlayerScroll)
                pBtn.Size = UDim2.new(1, 0, 0, 25)
                pBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 85)
                pBtn.BackgroundTransparency = 0
                pBtn.TextTransparency = 0
                pBtn.Text = p.Name
                pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                pBtn.TextStrokeTransparency = 0.5
                pBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
                pBtn.Font = Enum.Font.GothamSemibold
                pBtn.TextSize = 11
                Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
                pBtn.MouseButton1Click:Connect(function()
                    selectedPlayerName = p.Name
                    dropPlayerText.Text = "  Teleport To Players: " .. p.Name
                    listPlayerScroll.Visible = false
                    dropPlayerArrow.Text = "V"
                end)
            end
        end
        listPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, count * 27)
    end

    dropPlayerText.MouseButton1Click:Connect(function()
        local isVisible = not listPlayerScroll.Visible
        listPlayerScroll.Visible = isVisible
        dropPlayerArrow.Text = isVisible and "^" or "V"
        if isVisible then updatePlayerDropdown() end
    end)

    tpPlayerBtn.MouseButton1Click:Connect(function()
        if selectedPlayerName ~= "" then
            local target = players:FindFirstChild(selectedPlayerName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
                hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end)

    local dropFriendFrame = Instance.new("Frame", pageCustomize)
    dropFriendFrame.Size = UDim2.new(0.95, 0, 0, 35)
    dropFriendFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    dropFriendFrame.BackgroundTransparency = 0
    Instance.new("UICorner", dropFriendFrame).CornerRadius = UDim.new(0, 5)
    applyBlackGreyGradient(dropFriendFrame)
    local dropFriendStroke = Instance.new("UIStroke", dropFriendFrame)
    dropFriendStroke.Thickness = 2
    rs.RenderStepped:Connect(function()
        dropFriendStroke.Color = Color3.fromHSV((tick() * 0.15) % 1, 0.8, 1)
    end)

    local dropFriendText = Instance.new("TextButton", dropFriendFrame)
    dropFriendText.Size = UDim2.new(1, 0, 1, 0)
    dropFriendText.BackgroundTransparency = 1
    dropFriendText.TextTransparency = 0
    dropFriendText.Text = "  Teleport to Friends"
    dropFriendText.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropFriendText.TextStrokeTransparency = 0.5
    dropFriendText.TextStrokeColor3 = Color3.new(0, 0, 0)
    dropFriendText.Font = Enum.Font.GothamBold
    dropFriendText.TextSize = 12
    dropFriendText.TextXAlignment = Enum.TextXAlignment.Left

    local dropFriendArrow = Instance.new("TextLabel", dropFriendFrame)
    dropFriendArrow.Size = UDim2.new(0, 30, 1, 0)
    dropFriendArrow.Position = UDim2.new(1, -30, 0, 0)
    dropFriendArrow.BackgroundTransparency = 1
    dropFriendArrow.TextTransparency = 0
    dropFriendArrow.Text = "V"
    dropFriendArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropFriendArrow.TextStrokeTransparency = 0.5
    dropFriendArrow.TextStrokeColor3 = Color3.new(0, 0, 0)
    dropFriendArrow.Font = Enum.Font.GothamBold
    dropFriendArrow.TextSize = 11

    local listFriendScroll = Instance.new("ScrollingFrame", pageCustomize)
    listFriendScroll.Size = UDim2.new(0.95, 0, 0, 100)
    listFriendScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    listFriendScroll.BackgroundTransparency = 0
    listFriendScroll.Visible = false
    listFriendScroll.ScrollBarThickness = 3
    listFriendScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Instance.new("UICorner", listFriendScroll).CornerRadius = UDim.new(0, 5)
    local listFriendLayout = Instance.new("UIListLayout", listFriendScroll)
    listFriendLayout.Padding = UDim.new(0, 2)

    local tpFriendBtn = Instance.new("TextButton", pageCustomize)
    tpFriendBtn.Size = UDim2.new(0.95, 0, 0, 30)
    tpFriendBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    tpFriendBtn.BackgroundTransparency = 0
    tpFriendBtn.TextTransparency = 0
    tpFriendBtn.Text = "Teleport"
    tpFriendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpFriendBtn.TextStrokeTransparency = 0.5
    tpFriendBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    tpFriendBtn.Font = Enum.Font.GothamBold
    tpFriendBtn.TextSize = 12
    Instance.new("UICorner", tpFriendBtn).CornerRadius = UDim.new(0, 5)
    applyBlackGreyGradient(tpFriendBtn)

    local function updateFriendDropdown()
        for _, child in pairs(listFriendScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local count = 0
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr then
                local isFriend = false
                pcall(function()
                    isFriend = plr:IsFriendsWith(p.UserId)
                end)
                if isFriend then
                    count = count + 1
                    local fBtn = Instance.new("TextButton", listFriendScroll)
                    fBtn.Size = UDim2.new(1, 0, 0, 25)
                    fBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 85)
                    fBtn.BackgroundTransparency = 0
                    fBtn.TextTransparency = 0
                    fBtn.Text = p.Name
                    fBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    fBtn.TextStrokeTransparency = 0.5
                    fBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
                    fBtn.Font = Enum.Font.GothamSemibold
                    fBtn.TextSize = 11
                    Instance.new("UICorner", fBtn).CornerRadius = UDim.new(0, 4)
                    fBtn.MouseButton1Click:Connect(function()
                        selectedFriendName = p.Name
                        dropFriendText.Text = "  Teleport to Friends: " .. p.Name
                        listFriendScroll.Visible = false
                        dropFriendArrow.Text = "V"
                    end)
                end
            end
        end
        listFriendScroll.CanvasSize = UDim2.new(0, 0, 0, count * 27)
    end

    dropFriendText.MouseButton1Click:Connect(function()
        local isVisible = not listFriendScroll.Visible
        listFriendScroll.Visible = isVisible
        dropFriendArrow.Text = isVisible and "^" or "V"
        if isVisible then updateFriendDropdown() end
    end)

    tpFriendBtn.MouseButton1Click:Connect(function()
        if selectedFriendName ~= "" then
            local target = players:FindFirstChild(selectedFriendName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
                hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end)

    -- // GAMES TAB CONTENT //
    local function createGameBtn(name, targetPlaceId, url, parent)
        local b = Instance.new("TextButton", parent)
        b.Text = name
        b.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        b.BackgroundTransparency = 0
        b.TextTransparency = 0
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextStrokeTransparency = 0.5
        b.TextStrokeColor3 = Color3.new(0,0,0)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        Instance.new("UICorner", b)
        applyBlackGreyGradient(b)

        b.MouseButton1Click:Connect(function()
            b.Text = "Loading..."
            task.wait(1.5)
            if game.PlaceId == targetPlaceId then
                customNotify("Success", "Game verified successfully!", 3)
                b.Text = name
                pcall(function()
                    loadstring(game:HttpGet(url))()
                end)
            else
                customNotify("Error", "You are not in the same game", 4)
                b.Text = name
            end
        end)
        return b
    end

    createGameBtn("Murder Mystery 2 Script", 142823291, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/mm2.lua", pageGames)
    createGameBtn("The Floor Is Lava Script", 815405518, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/thefloorislava.lua", pageGames)
    createGameBtn("Survive the Killer Script", 4580204640, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/SurvivetheKiller.lua", pageGames)
    createGameBtn("Suspect Script", 121268060261990, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/Suspect.lua", pageGames)
    createGameBtn("Quiet or Die Script", 126922689754590, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/QuietorDie.lua", pageGames)
    createGameBtn("Violence District Script", 93978595733734, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/ViolenceDistrict.lua", pageGames)
    createGameBtn("Mine Per Click Script", 11210864111, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/Mineperclick.lua", pageGames)
    createGameBtn("Steal An Egg Script", 80978566387592, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/StealAnEgg.lua", pageGames)
    createGameBtn("Prison Life Script", 155615604, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/Prisonlife.lua", pageGames)
    createGameBtn("Natural Disaster Survival Script", 189707, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/Naturaldisastersurvival.lua", pageGames)
    createGameBtn("Sell Lemons Script", 79268393072444, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/Sell_lemons.lua", pageGames)
    createGameBtn("Paint and Seek Script", 78724049937437, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/Paintandseek.lua", pageGames)
    createGameBtn("Grow a Garden 2 Script", 97598239454123, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/gag2.lua", pageGames)
    createGameBtn("Pistol Arena Script", 87018676608089, "https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/PistolArena.lua", pageGames)

    -- // SERVER TAB CONTENT //
    local function createServerBtn(name, parent, func)
        local b = Instance.new("TextButton", parent)
        b.Text = name
        b.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        b.BackgroundTransparency = 0
        b.TextTransparency = 0
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextStrokeTransparency = 0.5
        b.TextStrokeColor3 = Color3.new(0,0,0)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        Instance.new("UICorner", b)
        applyBlackGreyGradient(b)
        b.MouseButton1Click:Connect(func)
        return b
    end

    createServerBtn("Rejoin", pageServer, function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
    end)

    createServerBtn("Small Server", pageServer, function()
        local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        pcall(function()
            local raw = game:HttpGet(api)
            local json = HttpService:JSONDecode(raw)
            if json and json.data then
                for _, s in pairs(json.data) do
                    if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, plr)
                        break
                    end
                end
            end
        end)
    end)

    createServerBtn("Server Hop", pageServer, function()
        local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        pcall(function()
            local raw = game:HttpGet(api)
            local json = HttpService:JSONDecode(raw)
            if json and json.data then
                local valid = {}
                for _, s in pairs(json.data) do
                    if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        table.insert(valid, s.id)
                    end
                end
                if #valid > 0 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, valid[math.random(1, #valid)], plr)
                end
            end
        end)
    end)

    createServerBtn("Server New", pageServer, function()
        local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        pcall(function()
            local raw = game:HttpGet(api)
            local json = HttpService:JSONDecode(raw)
            if json and json.data then
                for _, s in pairs(json.data) do
                    if s.playing and s.playing == 1 and s.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, plr)
                        return
                    end
                end
                for _, s in pairs(json.data) do
                    if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, plr)
                        break
                    end
                end
            end
        end)
    end)

    -- // SLEEK TOGGLE BUTTON CREATOR //
    local function createToggleBtn(name, key, parent)
        local holder = Instance.new("Frame", parent)
        holder.Name = "SleekToggle_" .. key
        holder.BackgroundColor3 = Color3.fromRGB(52, 52, 62)
        holder.BackgroundTransparency = 0
        holder.BorderSizePixel = 0
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 7)
        applyBlackGreyGradient(holder)

        local holderStroke = Instance.new("UIStroke", holder)
        holderStroke.Thickness = 1
        holderStroke.Color = Color3.fromRGB(85, 85, 100)
        holderStroke.Transparency = 0.35

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1, -46, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(235, 235, 242)
        label.TextStrokeTransparency = 0.65
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 9.5
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 2

        local track = Instance.new("Frame", holder)
        track.Name = "Track"
        track.Size = UDim2.new(0, 32, 0, 16)
        track.Position = UDim2.new(1, -38, 0.5, -8)
        track.BackgroundColor3 = Color3.fromRGB(75, 75, 88)
        track.BorderSizePixel = 0
        track.ZIndex = 2
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local trackStroke = Instance.new("UIStroke", track)
        trackStroke.Thickness = 1
        trackStroke.Color = Color3.fromRGB(105, 105, 120)
        trackStroke.Transparency = 0.4

        local knob = Instance.new("Frame", track)
        knob.Name = "Knob"
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.Position = UDim2.new(0, 2, 0.5, -6)
        knob.BackgroundColor3 = Color3.fromRGB(215, 215, 225)
        knob.BorderSizePixel = 0
        knob.ZIndex = 3
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local hitBtn = Instance.new("TextButton", holder)
        hitBtn.Size = UDim2.new(1, 0, 1, 0)
        hitBtn.BackgroundTransparency = 1
        hitBtn.Text = ""
        hitBtn.ZIndex = 4

        local tweenSleek = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        local function syncVisual(active)
            if active then
                TweenService:Create(knob, tweenSleek, {
                    Position = UDim2.new(1, -14, 0.5, -6),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
                TweenService:Create(track, tweenSleek, {
                    BackgroundColor3 = Color3.fromRGB(0, 195, 120)
                }):Play()
                TweenService:Create(trackStroke, tweenSleek, {
                    Color = Color3.fromRGB(60, 235, 155),
                    Transparency = 0.15
                }):Play()
                TweenService:Create(holderStroke, tweenSleek, {
                    Color = Color3.fromRGB(0, 195, 120),
                    Transparency = 0.25
                }):Play()
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                TweenService:Create(knob, tweenSleek, {
                    Position = UDim2.new(0, 2, 0.5, -6),
                    BackgroundColor3 = Color3.fromRGB(205, 205, 215)
                }):Play()
                TweenService:Create(track, tweenSleek, {
                    BackgroundColor3 = Color3.fromRGB(75, 75, 88)
                }):Play()
                TweenService:Create(trackStroke, tweenSleek, {
                    Color = Color3.fromRGB(105, 105, 120),
                    Transparency = 0.45
                }):Play()
                TweenService:Create(holderStroke, tweenSleek, {
                    Color = Color3.fromRGB(85, 85, 100),
                    Transparency = 0.4
                }):Play()
                label.TextColor3 = Color3.fromRGB(225, 225, 232)
            end
        end

        syncVisual(states[key] == true)

        hitBtn.MouseButton1Click:Connect(function()
            states[key] = not states[key]
            syncVisual(states[key])
            if key == "fly" then setFly(states.fly)
            elseif key == "swim" then
                if states.swim then startSwim() else stopSwim() end
            elseif key == "bypassac" then applyAntiDetect(states.bypassac)
            elseif key == "antikick" or key == "antikickrejoin" then
                -- tanpa customNotify
            elseif key == "noclip" and not states.noclip and char then
                for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end
            elseif key == "esp" and not states.esp then
                for _, p in pairs(players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("MeknoHighlight") then p.Character.MeknoHighlight:Destroy() end end
            elseif key == "espskeleton" and not states.espskeleton then
                for _, p in pairs(players:GetPlayers()) do removeSkeleton(p) end
            elseif key == "tracer" and not states.tracer then
                for _, p in pairs(players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("MeknoTracer") then p.Character.MeknoTracer:Destroy() end end
            elseif key == "hitbox" and not states.hitbox then
                resetHitboxes()
            elseif key == "fullbright" then
                if states.fullbright then
                    pcall(function()
                        lighting.Ambient = Color3.fromRGB(255, 255, 255)
                        lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                        lighting.Brightness = 2
                        lighting.ClockTime = 14
                    end)
                else
                    pcall(function()
                        lighting.Ambient = oldAmbient
                        lighting.OutdoorAmbient = oldOutdoor
                        lighting.Brightness = 1
                    end)
                end
            elseif key == "addpart" and not states.addpart then if platformPart then platformPart:Destroy(); platformPart = nil end
            elseif key == "antivoid" and not states.antivoid then if voidPart then voidPart:Destroy(); voidPart = nil end
            elseif key == "float" and not states.float then if floatPart then floatPart:Destroy(); floatPart = nil end
            elseif key == "antilag" then
                if states.antilag then
                    pcall(function()
                        settings().Rendering.QualityLevel = 1
                        lighting.GlobalShadows = false
                        lighting.FogEnd = 9e9
                    end)
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CastShadow = false
                            v.Material = Enum.Material.SmoothPlastic
                        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                            v.Enabled = false
                        end
                    end
                else
                    pcall(function()
                        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
                        lighting.GlobalShadows = true
                    end)
                end
            elseif key == "xray" and not states.xray then
                for obj, trans in pairs(originalTransparencies) do if obj and obj.Parent then obj.Transparency = trans end end
                originalTransparencies = {}
            elseif key == "antitel" and states.antitel then if hrp then lastPos = hrp.CFrame end
            elseif key == "antifling" and not states.antifling then
                if plr.Character then
                    for _, part in pairs(plr.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
                end
                for _, p in pairs(players:GetPlayers()) do
                    if p ~= plr and p.Character then
                        for _, part in pairs(p.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
                    end
                end
            end
        end)
        return holder
    end

    -- // MAIN TAB //
    createToggleBtn("Noclip", "noclip", pageMain)
    createToggleBtn("ESP", "esp", pageMain)
    createToggleBtn("ESP Skeleton", "espskeleton", pageMain)
    createToggleBtn("Tracer", "tracer", pageMain)
    createToggleBtn("Fling", "fling", pageMain)
    createToggleBtn("Inf Jump", "infJump", pageMain)
    createToggleBtn("Speed", "speed", pageMain)
    createToggleBtn("Float", "float", pageMain)
    createToggleBtn("SpinBot 360", "spin", pageMain)
    createToggleBtn("Xray", "xray", pageMain)
    createToggleBtn("TP Kill Enemy", "tpKill", pageMain)
    createToggleBtn("Aimbot", "aimActive", pageMain)
    createToggleBtn("Hitbox", "hitbox", pageMain)
    createToggleBtn("Fullbright", "fullbright", pageMain)
    createToggleBtn("Add Part", "addpart", pageMain)
    createToggleBtn("Fly", "fly", pageMain)
    createToggleBtn("Swim", "swim", pageMain)
    createToggleBtn("Hit all (use tools)", "hitall", pageMain)

    -- // SELECT ANTI TAB //
    createToggleBtn("Anti Fling", "antifling", pageSelectAnti)
    createToggleBtn("Anti Teleport", "antitel", pageSelectAnti)
    createToggleBtn("Anti Ragdoll", "antirag", pageSelectAnti)
    createToggleBtn("Anti Afk", "antiafk", pageSelectAnti)
    createToggleBtn("Anti Void", "antivoid", pageSelectAnti)
    createToggleBtn("Anti Lag", "antilag", pageSelectAnti)
    createToggleBtn("Anti Kick Clients", "antikick", pageSelectAnti)
    createToggleBtn("Anti Kick On Rejoin", "antikickrejoin", pageSelectAnti)

    -- // VISUALS TAB //
    local function createPlainBtn(name, parent, func)
        local b = Instance.new("TextButton", parent)
        b.Text = name
        b.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        b.BackgroundTransparency = 0
        b.TextTransparency = 0
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextStrokeTransparency = 0.5
        b.TextStrokeColor3 = Color3.new(0, 0, 0)
        b.Font = Enum.Font.GothamSemibold
        b.TextSize = 10
        Instance.new("UICorner", b)
        applyBlackGreyGradient(b)

        b.MouseButton1Click:Connect(func)
        return b
    end

    local godSubFrame = Instance.new("Frame", screenGui); godSubFrame.Size = UDim2.new(0, 150, 0, 100); godSubFrame.Position = UDim2.new(0.5, -75, 0.5, -50); godSubFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65); godSubFrame.BackgroundTransparency = 0; godSubFrame.Visible = false; godSubFrame.Active = true; godSubFrame.Draggable = true; Instance.new("UICorner", godSubFrame); applyBlackGreyGradient(godSubFrame)
    local godToggleBtn = Instance.new("TextButton", godSubFrame); godToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0); godToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0); godToggleBtn.Text = "God Mode : OFF"; godToggleBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75); godToggleBtn.BackgroundTransparency = 0; godToggleBtn.TextTransparency = 0; godToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255); godToggleBtn.TextStrokeTransparency = 0; godToggleBtn.TextStrokeColor3 = Color3.new(0, 0, 0); Instance.new("UICorner", godToggleBtn); applyBlackGreyGradient(godToggleBtn)

    local godCloseBtn = Instance.new("TextButton", godSubFrame)
    godCloseBtn.Size = UDim2.new(0, 24, 0, 24)
    godCloseBtn.Position = UDim2.new(1, -28, 0, 4)
    godCloseBtn.Text = "X"
    godCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    godCloseBtn.Font = Enum.Font.GothamBold
    godCloseBtn.TextSize = 12
    godCloseBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    Instance.new("UICorner", godCloseBtn).CornerRadius = UDim.new(0, 4)
    applyBlackGreyGradient(godCloseBtn)
    godCloseBtn.MouseButton1Click:Connect(function() godSubFrame.Visible = false end)

    godToggleBtn.MouseButton1Click:Connect(function()
        states.god = not states.god
        godToggleBtn.Text = "God Mode : " .. (states.god and "ON" or "OFF")
        if states.god then
            godConnection = rs.Heartbeat:Connect(function()
                pcall(function()
                    if char and hum and hrp then
                        hum.MaxHealth = 1e6
                        hum.Health = 1e6
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                        if hrp.Position.Y < -50 then
                            hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                end)
            end)
        else
            if godConnection then godConnection:Disconnect(); godConnection = nil end
            if hum then
                pcall(function()
                    hum.MaxHealth = 100
                    hum.Health = 100
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                end)
            end
        end
    end)

    -- // INVISIBLE SUB MENU (MIRIP GOD MODE) //
    local invisSubFrame = Instance.new("Frame", screenGui)
    invisSubFrame.Size = UDim2.new(0, 150, 0, 100)
    invisSubFrame.Position = UDim2.new(0.5, -75, 0.5, -50)
    invisSubFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    invisSubFrame.BackgroundTransparency = 0
    invisSubFrame.Visible = false
    invisSubFrame.Active = true
    invisSubFrame.Draggable = true
    Instance.new("UICorner", invisSubFrame)
    applyBlackGreyGradient(invisSubFrame)

    local invisToggleBtn = Instance.new("TextButton", invisSubFrame)
    invisToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
    invisToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
    invisToggleBtn.Text = "Invisible : OFF"
    invisToggleBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    invisToggleBtn.BackgroundTransparency = 0
    invisToggleBtn.TextTransparency = 0
    invisToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    invisToggleBtn.TextStrokeTransparency = 0
    invisToggleBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
    Instance.new("UICorner", invisToggleBtn)
    applyBlackGreyGradient(invisToggleBtn)

    local invisCloseBtn = Instance.new("TextButton", invisSubFrame)
    invisCloseBtn.Size = UDim2.new(0, 24, 0, 24)
    invisCloseBtn.Position = UDim2.new(1, -28, 0, 4)
    invisCloseBtn.Text = "X"
    invisCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    invisCloseBtn.Font = Enum.Font.GothamBold
    invisCloseBtn.TextSize = 12
    invisCloseBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    Instance.new("UICorner", invisCloseBtn).CornerRadius = UDim.new(0, 4)
    applyBlackGreyGradient(invisCloseBtn)
    invisCloseBtn.MouseButton1Click:Connect(function() invisSubFrame.Visible = false end)

    local function setInvisState(state) 
        local c = plr.Character if not c then return end 
        for _, o in pairs(workspace:GetChildren()) do if o.Name == 'invischair' then pcall(function() o:Destroy() end) end end 
        for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end end 
        if state then 
            local r = c:FindFirstChild("HumanoidRootPart") if not r then return end 
            task.wait(0.05) local scf = r.CFrame; local under = r.Position + Vector3.new(0, -100, 0); c:MoveTo(under) 
            task.wait(0.1) local s = Instance.new("Seat", workspace); s.Anchored = true; s.CanCollide = false; s.Transparency = 1; s.Position = under; s.Name = "invischair" 
            local w = Instance.new("Weld", s); w.Part0 = s; w.Part1 = r; task.wait(); s.CFrame = scf; s.Anchored = false 
            for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 0.5 end end 
        end 
    end

    invisToggleBtn.MouseButton1Click:Connect(function()
        states.invis = not states.invis
        invisToggleBtn.Text = "Invisible : " .. (states.invis and "ON" or "OFF")
        setInvisState(states.invis)
    end)

    local execMainFrame = Instance.new("Frame", screenGui); execMainFrame.Size = UDim2.new(0, 300, 0, 220); execMainFrame.Position = UDim2.new(0.5, -150, 0.5, -110); execMainFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65); execMainFrame.BackgroundTransparency = 0; execMainFrame.Visible = false; execMainFrame.Active = true; execMainFrame.Draggable = true; Instance.new("UICorner", execMainFrame); applyBlackGreyGradient(execMainFrame)
    local execTextBox = Instance.new("TextBox", execMainFrame); execTextBox.Size = UDim2.new(1, -20, 0, 130); execTextBox.Position = UDim2.new(0, 10, 0, 40); execTextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25); execTextBox.TextColor3 = Color3.fromRGB(255, 255, 255); execTextBox.ClearTextOnFocus = false; execTextBox.MultiLine = true; execTextBox.Font = Enum.Font.Code; execTextBox.TextSize = 10; Instance.new("UICorner", execTextBox)
    local executeSubBtn = Instance.new("TextButton", execMainFrame); executeSubBtn.Size = UDim2.new(0, 85, 0, 35); executeSubBtn.Position = UDim2.new(0, 10, 0, 175); executeSubBtn.Text = "Execute"; executeSubBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75); executeSubBtn.BackgroundTransparency = 0; executeSubBtn.TextTransparency = 0; executeSubBtn.TextColor3 = Color3.fromRGB(255, 255, 255); executeSubBtn.TextStrokeTransparency = 0; executeSubBtn.TextStrokeColor3 = Color3.new(0, 0, 0); Instance.new("UICorner", executeSubBtn); applyBlackGreyGradient(executeSubBtn)

    local execCloseBtn = Instance.new("TextButton", execMainFrame)
    execCloseBtn.Size = UDim2.new(0, 24, 0, 24)
    execCloseBtn.Position = UDim2.new(1, -28, 0, 6)
    execCloseBtn.Text = "X"
    execCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    execCloseBtn.Font = Enum.Font.GothamBold
    execCloseBtn.TextSize = 12
    execCloseBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    Instance.new("UICorner", execCloseBtn).CornerRadius = UDim.new(0, 4)
    applyBlackGreyGradient(execCloseBtn)
    execCloseBtn.MouseButton1Click:Connect(function() execMainFrame.Visible = false end)

    executeSubBtn.MouseButton1Click:Connect(function()
        if execTextBox.Text ~= "" then
            pcall(function()
                local func = loadstring(execTextBox.Text)
                if func then func() end
            end)
        end
    end)

    local function miniFling(playerToFling)
        local character = plr.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = humanoid and humanoid.RootPart

        local targetCharacter = playerToFling.Character
        local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
        local targetRootPart = targetHumanoid and targetHumanoid.RootPart
        local targetHead = targetCharacter and targetCharacter:FindFirstChild("Head")

        if character and humanoid and rootPart and targetCharacter and targetHumanoid and targetRootPart then
            if rootPart.AssemblyLinearVelocity.Magnitude < 50 then
                savedOldPos = rootPart.CFrame
            end

            workspace.CurrentCamera.CameraSubject = targetHead or targetRootPart or targetHumanoid

            local BV = Instance.new("BodyVelocity")
            BV.Name = "VelocityFling"
            BV.Parent = rootPart
            BV.Velocity = Vector3.new(1500, 1500, 1500)
            BV.MaxForce = Vector3.new(1e7, 1e7, 1e7)

            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

            local Time = tick()
            repeat
                if rootPart and targetRootPart then
                    rootPart.CFrame = targetRootPart.CFrame
                    rootPart.AssemblyLinearVelocity = Vector3.new(1500, 1500, 1500)
                    rootPart.AssemblyAngularVelocity = Vector3.zero
                end
                task.wait()
            until not targetRootPart or targetRootPart.Parent ~= targetCharacter or targetHumanoid.Health <= 0 or targetHumanoid.Sit or tick() > Time + 1.5

            BV:Destroy()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = humanoid

            if savedOldPos then
                rootPart.CFrame = savedOldPos * CFrame.new(0, 0.5, 0)
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end

    -- ==========================================
    --        FEEDBACK UI
    -- ==========================================
    local globalFeedbackGui = Instance.new("Frame", screenGui)
    globalFeedbackGui.Name = "GlobalFeedbackGui"
    globalFeedbackGui.Size = UDim2.new(0, 320, 0, 180)
    globalFeedbackGui.AnchorPoint = Vector2.new(0.5, 0.5)
    globalFeedbackGui.Position = UDim2.new(0.5, 0, 0.5, 0)
    globalFeedbackGui.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    globalFeedbackGui.BackgroundTransparency = 0
    globalFeedbackGui.Visible = false
    globalFeedbackGui.Active = true
    globalFeedbackGui.Draggable = true
    Instance.new("UICorner", globalFeedbackGui).CornerRadius = UDim.new(0, 8)
    applyBlackGreyGradient(globalFeedbackGui)

    local gfbStroke = Instance.new("UIStroke", globalFeedbackGui)
    gfbStroke.Thickness = 1.8
    gfbStroke.Color = Color3.fromRGB(255, 0, 128)

    local gfbTitle = Instance.new("TextLabel", globalFeedbackGui)
    gfbTitle.Size = UDim2.new(1, -20, 0, 30)
    gfbTitle.Position = UDim2.new(0, 10, 0, 10)
    gfbTitle.BackgroundTransparency = 1
    gfbTitle.Text = "Feedback"
    gfbTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    gfbTitle.Font = Enum.Font.GothamBold
    gfbTitle.TextSize = 16
    gfbTitle.TextXAlignment = Enum.TextXAlignment.Left

    local gfbCloseBtn = Instance.new("TextButton", globalFeedbackGui)
    gfbCloseBtn.Size = UDim2.new(0, 24, 0, 24)
    gfbCloseBtn.Position = UDim2.new(1, -28, 0, 8)
    gfbCloseBtn.Text = "X"
    gfbCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    gfbCloseBtn.Font = Enum.Font.GothamBold
    gfbCloseBtn.TextSize = 12
    gfbCloseBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    Instance.new("UICorner", gfbCloseBtn).CornerRadius = UDim.new(0, 4)
    applyBlackGreyGradient(gfbCloseBtn)
    gfbCloseBtn.MouseButton1Click:Connect(function()
        globalFeedbackGui.Visible = false
    end)

    local gfbBox = Instance.new("TextBox", globalFeedbackGui)
    gfbBox.Size = UDim2.new(1, -20, 0, 70)
    gfbBox.Position = UDim2.new(0, 10, 0, 45)
    gfbBox.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    gfbBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    gfbBox.PlaceholderText = "Write your feedback here..."
    gfbBox.Font = Enum.Font.Gotham
    gfbBox.TextSize = 12
    gfbBox.ClearTextOnFocus = false
    gfbBox.MultiLine = true
    Instance.new("UICorner", gfbBox).CornerRadius = UDim.new(0, 6)

    local gfbSendBtn = Instance.new("TextButton", globalFeedbackGui)
    gfbSendBtn.Size = UDim2.new(1, -20, 0, 35)
    gfbSendBtn.Position = UDim2.new(0, 10, 1, -45)
    gfbSendBtn.Text = "Send"
    gfbSendBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    gfbSendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    gfbSendBtn.Font = Enum.Font.GothamBold
    gfbSendBtn.TextSize = 13
    Instance.new("UICorner", gfbSendBtn).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(gfbSendBtn)

    gfbSendBtn.MouseButton1Click:Connect(function()
        local feedbackText = gfbBox.Text
        if feedbackText ~= "" then
            local req = (syn and syn.request) or (http and http.request) or http_request or request
            if req then
                pcall(function()
                    local data = {
                        ["embeds"] = {{
                            ["title"] = "New Script Feedback Received!",
                            ["color"] = 65280,
                            ["fields"] = {
                                {["name"] = "Player", ["value"] = plr.Name .. " (" .. plr.UserId .. ")", ["inline"] = true},
                                {["name"] = "Feedback", ["value"] = feedbackText, ["inline"] = false}
                            },
                            ["footer"] = {["text"] = "Meknoyu Feedback System"}
                        }}
                    }
                    req({
                        Url = "https://discord.com/api/webhooks/1574788508307038358/BEhHmUMAyEFiS_y-mVbOtRCrDwVCpRWEI3ch-sDh_dj8d280r36Cvxx1Jh2TjfFfsU8S",
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = HttpService:JSONEncode(data)
                    })
                end)
            end
            gfbSendBtn.Text = "Sent Successfully!"
            task.wait(1.5)
            globalFeedbackGui.Visible = false
            gfbSendBtn.Text = "Send"
            gfbBox.Text = ""
        else
            gfbSendBtn.Text = "Please write something!"
            task.wait(1.5)
            gfbSendBtn.Text = "Send"
        end
    end)

    createPlainBtn("God Mode Menu", pageNoToggle, function() godSubFrame.Visible = not godSubFrame.Visible end)
    createPlainBtn("Invisible Menu", pageNoToggle, function() invisSubFrame.Visible = not invisSubFrame.Visible end)
    createPlainBtn("Execute Project", pageNoToggle, function() execMainFrame.Visible = not execMainFrame.Visible end)
    createPlainBtn("Teleport Back Hub", pageNoToggle, function() tpBackGui.Visible = not tpBackGui.Visible end)
    createPlainBtn("Feedback", pageNoToggle, function() globalFeedbackGui.Visible = not globalFeedbackGui.Visible end)
    spectateBtnRef = createPlainBtn("Spectate Player : OFF", pageNoToggle, function()
        setSpectateEnabled(not states.spectate)
    end)
    createPlainBtn("Tool TP Logic", pageNoToggle, function()
        states.tooltp = not states.tooltp
        if states.tooltp then
            giveTpTool()
        else
            local t = plr.Backpack:FindFirstChild("Mekno TP Tool") or (char and char:FindFirstChild("Mekno TP Tool"))
            if t then t:Destroy() end
        end
    end)
    createPlainBtn("Fling All", pageNoToggle, function()
        task.spawn(function()
            for _, p in pairs(players:GetPlayers()) do
                if p ~= plr and p.Character then
                    miniFling(p)
                end
            end
        end)
    end)
    createPlainBtn("Dark Dex", pageNoToggle, function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        end)
    end)

    pageMain.Visible = true

    --// MAIN ENGINE RENDER LOOP //--
    UIS.JumpRequest:Connect(function()
        if states.infJump and hum then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end)

    rs.Stepped:Connect(function()
        if (states.fling or states.noclip) and plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    rs.RenderStepped:Connect(function()
        -- Logika Hit All mengecek backpack/character tool dengan range 10000000
        if states.hitall then
            pcall(function()
                if char and hrp then
                    local tool = char:FindFirstChildOfClass("Tool") or (plr.Backpack and plr.Backpack:FindFirstChildOfClass("Tool"))
                    if tool then
                        if tool.Parent ~= char then
                            tool.Parent = char
                        end
                        for _, p in pairs(players:GetPlayers()) do
                            if p ~= plr and p.Character then
                                local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
                                local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                                if tHrp and tHum and tHum.Health > 0 then
                                    if (tHrp.Position - hrp.Position).Magnitude <= 10000000 then
                                        tool:Activate()
                                        for _, v in pairs(tool:GetDescendants()) do
                                            if v:IsA("BasePart") then
                                                pcall(function()
                                                    firetouchinterest(v, tHrp, 0)
                                                    firetouchinterest(v, tHrp, 1)
                                                end)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end

        if states.espskeleton then
            updateSkeleton()
        else
            for _, p in pairs(players:GetPlayers()) do
                removeSkeleton(p)
            end
        end

        if states.spectate then
            if not spectateTarget or not spectateTarget.Parent then
                refreshSpectateTarget(0)
            elseif spectateTarget.Character then
                local tHum = spectateTarget.Character:FindFirstChildOfClass("Humanoid")
                local tRoot = spectateTarget.Character:FindFirstChild("HumanoidRootPart") or spectateTarget.Character:FindFirstChild("Head")
                if tHum and workspace.CurrentCamera.CameraSubject ~= tHum then
                    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                    workspace.CurrentCamera.CameraSubject = tHum
                elseif not tHum and tRoot and workspace.CurrentCamera.CameraSubject ~= tRoot then
                    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                    workspace.CurrentCamera.CameraSubject = tRoot
                end
            end
        end

        if not char or not hum or not hrp then return end

        if states.antivoid then
            if not voidPart or not voidPart.Parent then
                voidPart = Instance.new("Part")
                voidPart.Name = "MeknoAntiVoidPart"
                voidPart.Size = Vector3.new(5000, 1, 5000)
                voidPart.Position = Vector3.new(0, -350, 0)
                voidPart.Anchored = true
                voidPart.CanCollide = true
                voidPart.Transparency = 1
                voidPart.Parent = workspace

                voidPart.Touched:Connect(function(hit)
                    if hit and hit.Parent and hit.Parent == plr.Character and hrp then
                        if savedPos then hrp.CFrame = savedPos
                        elseif lastPos then hrp.CFrame = lastPos + Vector3.new(0, 10, 0)
                        else hrp.CFrame = CFrame.new(0, 50, 0) end
                        hrp.AssemblyLinearVelocity = Vector3.zero
                    end
                end)
            else
                voidPart.Position = Vector3.new(hrp.Position.X, -350, hrp.Position.Z)
            end
        end

        if states.float then
            if not floatPart or not floatPart.Parent then
                floatPart = Instance.new("Part")
                floatPart.Name = "MeknoFloatPart"
                floatPart.Size = Vector3.new(5, 1, 5)
                floatPart.Transparency = 1
                floatPart.Anchored = true
                floatPart.CanCollide = true
                floatPart.Parent = workspace
            end
            floatPart.CFrame = hrp.CFrame - Vector3.new(0, 3.5, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
        elseif floatPart then
            floatPart:Destroy()
            floatPart = nil
        end

        if states.spin then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(25), 0)
        end

        if states.antifling or states.antirag then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end)
            if states.antifling then
                for _, p in pairs(players:GetPlayers()) do
                    if p ~= plr and p.Character then
                        for _, part in pairs(p.Character:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                end
            end
        end

        if states.antitel and lastPos then
            local distance = (hrp.Position - lastPos.Position).Magnitude
            if distance > 40 and not (states.speed or states.tooltp or states.savepos or states.tpKill or states.antifling or states.fling or states.fly) then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = lastPos
            else
                lastPos = hrp.CFrame
            end
        else
            lastPos = hrp.CFrame
        end

        if states.addpart then
            if not platformPart or not platformPart.Parent then
                platformPart = Instance.new("Part")
                platformPart.Name = "MeknoPlatform"
                platformPart.Size = Vector3.new(7, 1, 7)
                platformPart.Anchored = true
                platformPart.Material = Enum.Material.Neon
                platformPart.Color = Color3.fromRGB(150, 0, 0)
                platformPart.Parent = workspace
            end
            platformPart.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
        end

        if states.xray then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(char) and not players:GetPlayerFromCharacter(obj.Parent) then
                    if not originalTransparencies[obj] then originalTransparencies[obj] = obj.Transparency end
                    obj.Transparency = 0.65
                end
            end
        end

        if states.tpKill then
            local targetEnemy = nil
            local shortestDist = math.huge
            for _, p in pairs(players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    if not plr.Team or p.Team ~= plr.Team then
                        local targetHrp = p.Character.HumanoidRootPart
                        local currentDist = (targetHrp.Position - hrp.Position).Magnitude
                        if currentDist < shortestDist then
                            targetEnemy = targetHrp
                            shortestDist = currentDist
                        end
                    end
                end
            end
            if targetEnemy then
                hrp.CFrame = targetEnemy.CFrame * CFrame.new(0, 0, 3)
                hrp.AssemblyLinearVelocity = Vector3.zero
                cam.CFrame = CFrame.new(cam.CFrame.Position, targetEnemy.Position)
            end
        end

        if states.hitbox then
            for _, p in pairs(players:GetPlayers()) do
                if p ~= plr and p.Character and (not plr.Team or p.Team ~= plr.Team) then
                    local tRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                    if tRoot and tHum and tHum.Health > 0 then
                        if not originalHitboxes[tRoot] then
                            originalHitboxes[tRoot] = {
                                size = tRoot.Size,
                                transparency = tRoot.Transparency,
                                canCollide = tRoot.CanCollide
                            }
                        end
                        pcall(function()
                            tRoot.Size = Vector3.new(15, 15, 15)
                            tRoot.Transparency = 0.7
                            tRoot.BrickColor = BrickColor.new("Really blue")
                            tRoot.Material = Enum.Material.Neon
                            tRoot.CanCollide = false
                        end)
                    end
                end
            end
        else
            for _, p in pairs(players:GetPlayers()) do
                if p ~= plr and p.Character then
                    local tRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    if tRoot and originalHitboxes[tRoot] then
                        pcall(function()
                            tRoot.Size = originalHitboxes[tRoot].size
                            tRoot.Transparency = originalHitboxes[tRoot].transparency
                            tRoot.CanCollide = originalHitboxes[tRoot].canCollide
                        end)
                    end
                end
            end
        end

        local function isVisible(targetPart)
            if not targetPart or not hrp then return false end
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = {char, targetPart.Parent}
            raycastParams.IgnoreWater = true
            local origin = cam.CFrame.Position
            local direction = targetPart.Position - origin
            local result = workspace:Raycast(origin, direction, raycastParams)
            return result == nil
        end

        if states.aimActive and not states.tpKill then
            local target = nil
            local shortDistance = math.huge
            for _, p in pairs(players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    if not plr.Team or p.Team ~= plr.Team then
                        local head = p.Character.Head
                        if isVisible(head) then
                            local currentDist = (head.Position - hrp.Position).Magnitude
                            if currentDist < shortDistance then
                                target = head
                                shortDistance = currentDist
                            end
                        end
                    end
                end
            end
            if target then
                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, target.Position)
            end
        end

        if states.esp then
            for _, p in pairs(players:GetPlayers()) do
                if p ~= plr and p.Character and not p.Character:FindFirstChild("MeknoHighlight") then
                    Instance.new("Highlight", p.Character).Name = "MeknoHighlight"
                end
            end
        end

        if states.tracer then
            for _, p in pairs(players:GetPlayers()) do
                if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHrp = p.Character.HumanoidRootPart
                    local a1 = targetHrp:FindFirstChild("MeknoTracerAttach") or Instance.new("Attachment", targetHrp)
                    a1.Name = "MeknoTracerAttach"
                    local a0 = hrp:FindFirstChild("MeknoTracerAttachMy") or Instance.new("Attachment", hrp)
                    a0.Name = "MeknoTracerAttachMy"
                    if not targetHrp:FindFirstChild("MeknoTracer") then
                        local beam = Instance.new("Beam")
                        beam.Name = "MeknoTracer"
                        beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                        beam.Width0 = 0.15
                        beam.Width1 = 0.15
                        beam.FaceCamera = true
                        beam.Attachment0 = a0
                        beam.Attachment1 = a1
                        beam.Parent = targetHrp
                    end
                end
            end
        else
            for _, p in pairs(players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart:FindFirstChild("MeknoTracer") then
                    p.Character.HumanoidRootPart.MeknoTracer:Destroy()
                end
            end
        end

        if states.speed and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 1.2)
        end
    end)

    task.defer(function()
        customNotify("Device Mobile", "Mobile UI Optimized", 5)
    end)
end

-- ==========================================================
--    OWNER BYPASS & KEY SYSTEM INITIALIZATION
-- ==========================================================
if isPremiumUser(plr) then
    mainEngineLoad()
else
    local keyVerified = false
    local currentGeneratedKey = ""
    local fileName = "Meknoyu_KeyData.json"

    local function saveKeyToDevice(key, durationInSeconds)
        local data = { SavedKey = key, ExpireTime = os.time() + durationInSeconds }
        pcall(function()
            if writefile then writefile(fileName, HttpService:JSONEncode(data)) end
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

    local questStatus = {false, false, false, false}

    local copyKeyGui = Instance.new("Frame")
    copyKeyGui.Name = "CopyKeyGui"
    copyKeyGui.Size = UDim2.new(1, 0, 1, 0)
    copyKeyGui.BackgroundTransparency = 1
    copyKeyGui.Visible = false
    copyKeyGui.Parent = keyGui

    local keyDisplayBox

    local function showCopyKeyGui()
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
        if keyDisplayBox then
            keyDisplayBox.Text = currentGeneratedKey
        end
        copyKeyGui.Visible = true
    end

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

    keyDisplayBox = Instance.new("TextBox")
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