-- [[ MEKNOYU HUB | SUSPECT ]] --
local plr = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")
local cam = workspace.CurrentCamera

local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid", 10)
local hrp = char:WaitForChild("HumanoidRootPart", 10)

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = newChar:WaitForChild("Humanoid", 10)
    hrp = newChar:WaitForChild("HumanoidRootPart", 10)
end)

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

-- // SCREEN GUI UTAMA //
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuSuspectHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

-- // MAIN FRAME //
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 420, 0, 320)
main.Position = UDim2.new(0.5, -210, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
applyBlackGreyGradient(main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 0, 128)

-- // HEADER TITLE //
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -50, 0, 35)
title.Position = UDim2.new(0, 15, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🛡️ Meknoyu Hub | Suspect"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 8)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- // MINI BUTTON (UNTUK MEMBUKA KEMBALI GUI) //
local miniBtn = Instance.new("TextButton", screenGui)
miniBtn.Size = UDim2.new(0, 130, 0, 32)
miniBtn.Position = UDim2.new(0.5, -65, 0.12, 0)
miniBtn.Text = "Meknoyu Hub"
miniBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 12
miniBtn.Draggable = true
miniBtn.Visible = false
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 6)
applyBlackGreyGradient(miniBtn)

local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Thickness = 1.8
miniStroke.Color = Color3.fromRGB(255, 0, 128)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    miniBtn.Visible = false
    main.Visible = true
end)

-- // SCROLL CONTAINER UNTUK TOMBOL //
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 42)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.CanvasSize = UDim2.new(0, 0, 0, 340)

local grid = Instance.new("UIGridLayout", scroll)
grid.CellSize = UDim2.new(0.48, 0, 0, 42)
grid.CellPadding = UDim2.new(0, 8, 0, 8)
grid.SortOrder = Enum.SortOrder.LayoutOrder

-- // STATE FITUR //
local states = {
    espInnocent = false,
    espMurder = false,
    killAll = false,
    infJump = false,
    noclip = false,
    timerDisplay = false
}

-- // CREATOR TOMBOL TOGGLE //
local function createToggleBtn(name, key, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextWrapped = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(btn)
    
    btn.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        btn.Text = name .. ": " .. (states[key] and "ON" or "OFF")
        btn.BackgroundColor3 = states[key] and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(55, 55, 65)
        callback(states[key])
    end)
    return btn
end

-- // CREATOR TOMBOL BIASA (ACTION) //
local function createActionBtn(name, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextWrapped = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    applyBlackGreyGradient(btn)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- ==========================================
-- 1. ESP INNOCENT (Folder Players - Warna Hijau + Nama)
-- ==========================================
local innocentEspObjects = {}

local function removeInnocentEsp(p)
    if innocentEspObjects[p] then
        if innocentEspObjects[p].highlight then innocentEspObjects[p].highlight:Destroy() end
        if innocentEspObjects[p].billboard then innocentEspObjects[p].billboard:Destroy() end
        innocentEspObjects[p] = nil
    end
end

createToggleBtn("Esp Innocent", "espInnocent", function(state)
    if not state then
        for p, _ in pairs(innocentEspObjects) do
            removeInnocentEsp(p)
        end
    end
end)

rs.RenderStepped:Connect(function()
    if states.espInnocent then
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr and p.Character then
                local charModel = p.Character
                if not innocentEspObjects[p] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "InnocentHighlight"
                    hl.FillColor = Color3.fromRGB(0, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = charModel

                    local head = charModel:FindFirstChild("Head")
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "InnocentNameTag"
                    bb.Size = UDim2.new(0, 100, 0, 40)
                    bb.StudsOffset = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = head or charModel

                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = p.Name
                    lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
                    lbl.TextStrokeTransparency = 0
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 12

                    innocentEspObjects[p] = {highlight = hl, billboard = bb}
                end
            end
        end
    end
end)

players.PlayerRemoving:Connect(function(p)
    removeInnocentEsp(p)
end)

-- ==========================================
-- 2. ESP MURDER (Folder KillerFolder - Warna Merah + Nama)
-- ==========================================
local murderEspObjects = {}

local function removeMurderEsp(obj)
    if murderEspObjects[obj] then
        if murderEspObjects[obj].highlight then murderEspObjects[obj].highlight:Destroy() end
        if murderEspObjects[obj].billboard then murderEspObjects[obj].billboard:Destroy() end
        murderEspObjects[obj] = nil
    end
end

createToggleBtn("Esp Murder", "espMurder", function(state)
    if not state then
        for obj, _ in pairs(murderEspObjects) do
            removeMurderEsp(obj)
        end
    end
end)

rs.RenderStepped:Connect(function()
    if states.espMurder then
        local killerFolder = workspace:FindFirstChild("KillerFolder")
        if killerFolder then
            for _, killerChar in pairs(killerFolder:GetChildren()) do
                if killerChar:IsA("Model") and not murderEspObjects[killerChar] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "MurderHighlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = killerChar

                    local head = killerChar:FindFirstChild("Head")
                    locus = killerChar
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "MurderNameTag"
                    bb.Size = UDim2.new(0, 100, 0, 40)
                    bb.StudsOffset = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = head or killerChar

                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = killerChar.Name
                    lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
                    lbl.TextStrokeTransparency = 0
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 12

                    murderEspObjects[killerChar] = {highlight = hl, billboard = bb}
                end
            end
        end
    end
end)

-- ==========================================
-- 3. KILL ALL (MENGIKUTI BELAKANG PLAYER & MENEMPEL)
-- ==========================================
createToggleBtn("Kill All", "killAll", function(state)
    states.killAll = state
    task.spawn(function()
        while states.killAll do
            task.wait()
            pcall(function()
                if char and hum and hrp then
                    local knife = char:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")
                    if knife then
                        if knife.Parent ~= char then
                            knife.Parent = char
                        end
                        knife:Activate()
                    end

                    local playersFolder = workspace:FindFirstChild("PlayersFolder") or workspace
                    for _, targetModel in pairs(playersFolder:GetChildren()) do
                        if targetModel:IsA("Model") and targetModel ~= char then
                            local targetHrp = targetModel:FindFirstChild("HumanoidRootPart")
                            local targetHum = targetModel:FindFirstChildOfClass("Humanoid")
                            if targetHrp and targetHum and targetHum.Health > 0 then
                                hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 2.5)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- ==========================================
-- 4. INF JUMP
-- ==========================================
createToggleBtn("Inf Jump", "infJump", function(state)
    states.infJump = state
end)

UIS.JumpRequest:Connect(function()
    if states.infJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ==========================================
-- 5. NOCLIP
-- ==========================================
createToggleBtn("Noclip", "noclip", function(state)
    states.noclip = state
end)

rs.Stepped:Connect(function()
    if states.noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ==========================================
-- 6. TELEPORT MEETING (Teleport ke nama Model = Table)
-- ==========================================
createActionBtn("Teleport Meeting", function()
    pcall(function()
        local targetTable = workspace:FindFirstChild("Table", true)
        if targetTable then
            local targetPart = targetTable:FindFirstChildWhichIsA("BasePart")
            if targetPart and hrp then
                hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end)
end)

-- ==========================================
-- 7. COMPLETE QUEST (Pencet Finish, ButtonActive, dan Button)
-- ==========================================
createActionBtn("Complete Quest", function()
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                if obj.Name == "Finish" or obj.Name == "ButtonActive" or obj.Name == "Button" then
                    for _, conn in pairs(getconnections(obj.MouseButton1Click)) do
                        conn:Fire()
                    end
                end
            end
        end
        for _, gui in pairs(plr.PlayerGui:GetDescendants()) do
            if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                if gui.Name == "Finish" or gui.Name == "ButtonActive" or gui.Name == "Button" then
                    for _, conn in pairs(getconnections(gui.MouseButton1Click)) do
                        conn:Fire()
                    end
                end
            end
        end
    end)
end)

-- ==========================================
-- 8. TIMER BUTTON SUSPECT (Menampilkan nomor dari Part Timer yang ada SurfaceGui di luar layar & bisa di-drag)
-- ==========================================
local timerDisplayLabel = Instance.new("TextLabel", screenGui)
timerDisplayLabel.Size = UDim2.new(0, 200, 0, 40)
timerDisplayLabel.Position = UDim2.new(0.5, -100, 0, 15)
timerDisplayLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
timerDisplayLabel.BackgroundTransparency = 0.3
timerDisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerDisplayLabel.Font = Enum.Font.GothamBold
timerDisplayLabel.TextSize = 16
timerDisplayLabel.Text = "Timer: --"
timerDisplayLabel.Visible = false
timerDisplayLabel.Active = true
timerDisplayLabel.Draggable = true
Instance.new("UICorner", timerDisplayLabel).CornerRadius = UDim.new(0, 6)
applyBlackGreyGradient(timerDisplayLabel)

createToggleBtn("Timer Suspect", "timerDisplay", function(state)
    states.timerDisplay = state
    timerDisplayLabel.Visible = state
end)

rs.RenderStepped:Connect(function()
    if states.timerDisplay then
        local timerVal = "--"
        pcall(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("timer") then
                    for _, child in pairs(obj:GetDescendants()) do
                        if child:IsA("SurfaceGui") then
                            for _, textObj in pairs(child:GetDescendants()) do
                                if textObj:IsA("TextLabel") or textObj:IsA("TextBox") then
                                    if textObj.Text ~= "" then
                                        timerVal = textObj.Text
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        timerDisplayLabel.Text = "Timer: " .. timerVal
    end
end)