-- [[ MEKNOYU GUI | PISTOL ARENA EDITION ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuOneTapUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or localPlayer:WaitForChild("PlayerGui")

-- Status States
local states = {
    esp = false,
    aimbot = false,
    tracer = false,
    hitbox = false
}

-- Storage tabel untuk menghapus instansi lama saat OFF
local espStorage = {}
local tracerStorage = {}

-- ==========================================
-- MAIN GUI STRUCTURE (MAIN FRAME)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 260)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Thickness = 2.5
uiStroke.Color = Color3.fromRGB(255, 0, 0)

-- Rainbow Effect untuk Stroke Border
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            uiStroke.Color = Color3.fromHSV(i, 0.8, 1)
            task.wait(0.03)
        end
    end
end)

-- Header Title (NAMA TELAH DIGANTI)
local headerTitle = Instance.new("TextLabel", mainFrame)
headerTitle.Size = UDim2.new(1, -40, 0, 40)
headerTitle.Position = UDim2.new(0, 15, 0, 5)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "Meknoyu GUI | Pistol Arena"
headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 16
headerTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button (X)
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

-- Container untuk Tombol Fitur
local container = Instance.new("Frame", mainFrame)
container.Size = UDim2.new(1, -20, 1, -65)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout", container)
gridLayout.CellSize = UDim2.new(0.48, 0, 0, 45)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)

-- Mini Button (MEKNO)
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MiniButton"
miniBtn.Size = UDim2.new(0, 55, 0, 55)
miniBtn.Position = UDim2.new(0.9, 0, 0.1, 0)
miniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.Text = "MEKNO"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 11
miniBtn.Visible = false
miniBtn.Active = true
miniBtn.Draggable = true
miniBtn.Parent = screenGui

local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(1, 0)

local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Thickness = 2
miniStroke.Color = Color3.fromRGB(255, 255, 255)

task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            miniStroke.Color = Color3.fromHSV(i, 0.8, 1)
            task.wait(0.03)
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniBtn.Visible = false
end)

-- ==========================================
-- LOGIKA FITUR (ESP, AIMBOT, TRACER, HITBOX)
-- ==========================================

-- Fungsi pembantu mencari musuh terdekat dari crosshair (untuk Aimbot)
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = UIS:GetMouseLocation()
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- Render Loop utama (Menghindari Lag)
RunService.RenderStepped:Connect(function()
    -- 1. Logika Aimbot & Aimlock
    if states.aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
        end
    end

    -- 2. Logika ESP Chams & 3. Tracer
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")

            -- Logika ESP
            if states.esp and hrp and hum and hum.Health > 0 then
                if not espStorage[player] then
                    local box = Instance.new("Highlight")
                    box.Name = "ESPHighlight"
                    box.FillColor = Color3.fromRGB(255, 0, 0)
                    box.OutlineColor = Color3.fromRGB(255, 255, 255)
                    box.FillTransparency = 0.5
                    box.OutlineTransparency = 0
                    box.Adornee = char
                    box.Parent = char
                    espStorage[player] = box
                end
            else
                if espStorage[player] then
                    espStorage[player]:Destroy()
                    espStorage[player] = nil
                end
            end

            -- Logika Tracer
            if states.tracer and hrp and hum and hum.Health > 0 then
                local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    if not tracerStorage[player] then
                        local line = Drawing.new("Line")
                        line.Color = Color3.fromRGB(255, 0, 0)
                        line.Thickness = 1.5
                        line.Transparency = 1
                        tracerStorage[player] = line
                    end
                    local line = tracerStorage[player]
                    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y) -- Dari bawah tengah layar
                    line.To = Vector2.new(vector.X, vector.Y)
                    line.Visible = true
                else
                    if tracerStorage[player] then tracerStorage[player].Visible = false end
                end
            else
                if tracerStorage[player] then
                    tracerStorage[player]:Remove()
                    tracerStorage[player] = nil
                end
            end

            -- 4. Logika Hitbox
            if states.hitbox and hrp and hum and hum.Health > 0 then
                hrp.Size = Vector3.new(15, 15, 15)
                hrp.Transparency = 0.7
                hrp.BrickColor = BrickColor.new("Really blue")
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            else
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end
            end
        end
    end
end)

-- Bersihkan drawing instansi jika player keluar game
Players.PlayerRemoving:Connect(function(player)
    if espStorage[player] then espStorage[player]:Destroy() espStorage[player] = nil end
    if tracerStorage[player] then tracerStorage[player]:Remove() tracerStorage[player] = nil end
end)

-- ==========================================
-- MEMBUAT TOMBOL TOGGLE
-- ==========================================
local function createToggle(name, stateKey)
    local btn = Instance.new("TextButton", container)
    btn.Text = name .. " : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        states[stateKey] = not states[stateKey]
        if states[stateKey] then
            btn.Text = name .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
        else
            btn.Text = name .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        end
    end)
end

-- Menambahkan Tombol Sesuai Request
createToggle("ESP", "esp")
createToggle("Aimbot & Aimlock", "aimbot")
createToggle("Tracer", "tracer")
createToggle("Hitbox", "hitbox")
