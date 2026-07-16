-- [[ MEKNOYU GUI | SURVIVE THE KILLER ]] --

if game:GetService("CoreGui"):FindFirstChild("MeknoyuSTKUI") then
    game:GetService("CoreGui").MeknoyuSTKUI:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuSTKUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

-- Status States
local states = {
    autoCollect = false,
    espKiller = false,
    espSurvive = false,
    infJump = false
}

-- ==========================================
-- MAIN GUI STRUCTURE (MAIN FRAME)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 200)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(255, 0, 0)

-- Rainbow Effect untuk Stroke Border
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            if uiStroke then
                uiStroke.Color = Color3.fromHSV(i, 0.8, 1)
            end
            task.wait(0.03)
        end
    end
end)

-- Header Title
local headerTitle = Instance.new("TextLabel", mainFrame)
headerTitle.Size = UDim2.new(1, -40, 0, 35)
headerTitle.Position = UDim2.new(0, 10, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "Meknoyu GUI | Survive the Killer"
headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 14
headerTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button (X)
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

-- Container untuk Tombol Fitur (Grid System)
local container = Instance.new("Frame", mainFrame)
container.Size = UDim2.new(1, -20, 1, -85)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout", container)
gridLayout.CellSize = UDim2.new(0.48, 0, 0, 45)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)

-- UI Text Notifikasi
local notifLabel = Instance.new("TextLabel", mainFrame)
notifLabel.Name = "NotifLabel"
notifLabel.Size = UDim2.new(1, -20, 0, 25)
notifLabel.Position = UDim2.new(0, 10, 1, -30)
notifLabel.BackgroundTransparency = 1
notifLabel.Text = "Welcome, Survivor!"
notifLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
notifLabel.Font = Enum.Font.GothamSemibold
notifLabel.TextSize = 11
notifLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ==========================================
-- MINI BUTTON (BULAT & DRAGGABLE)
-- ==========================================
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MiniButton"
miniBtn.Size = UDim2.new(0, 50, 0, 50)
miniBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
miniBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.Text = "MEKNO"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 10
miniBtn.Visible = false
miniBtn.Active = true
miniBtn.Draggable = true
miniBtn.Parent = screenGui

local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(1, 0)

local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Thickness = 2
miniStroke.Color = Color3.fromRGB(255, 255, 255)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniBtn.Visible = false
end)


-- ==========================================
-- FUNGSI LOGIKA FITUR (SURVIVE THE KILLER)
-- ==========================================

-- [1] AUTO COLLECT LOGIC (Mencari part bernama "Border" di seluruh Workspace tanpa batasan Folder)
task.spawn(function()
    while true do
        if states.autoCollect then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, border in pairs(workspace:GetDescendants()) do
                        if border:IsA("BasePart") and border.Name == "Border" then
                            local touchInterest = border:FindFirstChildOfClass("TouchTransmitter")
                            if touchInterest then
                                firetouchinterest(root, border, 0)
                                task.wait(0.01)
                                firetouchinterest(root, border, 1)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- [2] ESP UTILITY FUNCTIONS
local function applyESP(player, color)
    local char = player.Character
    if not char then return end
    
    local oldEsp = char:FindFirstChild("MeknoyuHighlight")
    if oldEsp then oldEsp:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "MeknoyuHighlight"
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Adornee = char
    highlight.Parent = char
end

local function removeESP(player)
    local char = player.Character
    if char then
        local oldEsp = char:FindFirstChild("MeknoyuHighlight")
        if oldEsp then oldEsp:Destroy() end
    end
end

-- [3] ESP RUNTIME CHECKER (Dipisahkan Sesuai Logic Aslinya)
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local isKiller = char:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))
                
                if isKiller then
                    if states.espKiller then
                        applyESP(player, Color3.fromRGB(255, 0, 0))
                    else
                        removeESP(player)
                    end
                else
                    if states.espSurvive then
                        applyESP(player, Color3.fromRGB(0, 255, 0))
                    else
                        if not states.espKiller or not isKiller then
                            removeESP(player)
                        end
                    end
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(removeESP)

-- [4] INF JUMP LOGIC
UserInputService.JumpRequest:Connect(function()
    if states.infJump then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)

-- ==========================================
-- MEMBUAT FUNGSIONALITAS TOMBOL
-- ==========================================
local function createToggle(name, stateKey, callback)
    local btn = Instance.new("TextButton", container)
    btn.Text = name .. " : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        states[stateKey] = not states[stateKey]
        if states[stateKey] then
            btn.Text = name .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
            notifLabel.Text = name .. " Activated"
            notifLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            btn.Text = name .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            notifLabel.Text = name .. " Deactivated"
            notifLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        if callback then callback(states[stateKey]) end
    end)
end

-- Menambahkan Semua Tombol dengan Callback Pembersihan ESP seperti script awal
createToggle("Auto Collect", "autoCollect")

createToggle("ESP Killer", "espKiller", function(state)
    if not state then
        for _, player in pairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                local isKiller = char:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))
                if isKiller then removeESP(player) end
            end
        end
    end
end)

createToggle("ESP Survive", "espSurvive", function(state)
    if not state then
        for _, player in pairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                local isKiller = char:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))
                if not isKiller then removeESP(player) end
            end
        end
    end
end)

createToggle("Inf Jump", "infJump")
