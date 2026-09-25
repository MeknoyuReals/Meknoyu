-- [[ MEKNOYU GUI | PAINT AND SEEK ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuPaintSeekUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or localPlayer:WaitForChild("PlayerGui")

-- Status States
local states = {
    espPlayer = false,
    autoFarmCoin = false,
    noclip = false,
    infJump = false
}

-- ==========================================
-- MAIN GUI STRUCTURE (MAIN FRAME)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 310)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -155)
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
            uiStroke.Color = Color3.fromHSV(i, 0.8, 1)
            task.wait(0.03)
        end
    end
end)

-- Header Title
local headerTitle = Instance.new("TextLabel", mainFrame)
headerTitle.Size = UDim2.new(1, -40, 0, 35)
headerTitle.Position = UDim2.new(0, 10, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "Meknoyu GUI | Paint And SEEK"
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

-- Container untuk Tombol Fitur
local container = Instance.new("Frame", mainFrame)
container.Size = UDim2.new(1, -20, 1, -90)
container.Position = UDim2.new(0, 10, 0, 40)
container.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout", container)
gridLayout.CellSize = UDim2.new(0.48, 0, 0, 45)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)

-- UI Text Notifikasi (Dikosongkan sesuai permintaan)
local notifLabel = Instance.new("TextLabel", mainFrame)
notifLabel.Name = "NotifLabel"
notifLabel.Size = UDim2.new(1, -20, 0, 25)
notifLabel.Position = UDim2.new(0, 10, 1, -30)
notifLabel.BackgroundTransparency = 1
notifLabel.Text = ""
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
-- FUNGSI LOGIKA FITUR (CORE LOOPS)
-- ==========================================

-- Check if player is Seeker
local function checkIsSeeker(targetPlayer)
    if not targetPlayer then return false end
    local char = targetPlayer.Character
    if not char then return false end
    
    return char:FindFirstChild("SeekerHighlight_Local") or 
           char:FindFirstChild("SeekerKnife") or 
           (targetPlayer:FindFirstChild("Backpack") and targetPlayer.Backpack:FindFirstChild("SeekerKnife"))
end

-- 1. Logika ESP Player (Hider = Hijau, Seeker = Merah)
local function applyESP(player)
    if player == localPlayer then return end
    
    local function createHighlight(character)
        if not character then return end
        
        local old = character:FindFirstChild("MeknoESP")
        if old then old:Destroy() end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "MeknoESP"
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        if checkIsSeeker(player) then
            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Merah
            highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
        else
            highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Hijau
            highlight.OutlineColor = Color3.fromRGB(50, 255, 50)
        end
    end
    
    if player.Character then createHighlight(player.Character) end
    player.CharacterAdded:Connect(createHighlight)
end

local function removeESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("MeknoESP") then
            p.Character.MeknoESP:Destroy()
        end
    end
end

RunService.RenderStepped:Connect(function()
    if states.espPlayer then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then applyESP(p) end
        end
    end
end)

-- 2. Logika Auto Farm Coin (TouchInterest)
task.spawn(function()
    while true do
        if states.autoFarmCoin then
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name:match("Coin")) then
                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            firetouchinterest(localPlayer.Character.HumanoidRootPart, obj, 0)
                            firetouchinterest(localPlayer.Character.HumanoidRootPart, obj, 1)
                        end
                    end
                end
                if notifLabel.Text ~= "Auto Farm: Collecting Coins..." then
                    notifLabel.Text = "Auto Farm: Collecting Coins..."
                    notifLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
                end
            end)
        end
        task.wait(0.3)
    end
end)

-- 3. Logika Noclip
RunService.Stepped:Connect(function()
    if states.noclip and localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 4. Logika Infinite Jump
UIS.JumpRequest:Connect(function()
    if states.infJump and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ==========================================
-- MEMBUAT FUNGSIONALITAS TOMBOL
-- ==========================================
local function createToggle(name, stateKey)
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
        else
            btn.Text = name .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            if stateKey == "espPlayer" then removeESP() end
            notifLabel.Text = name .. " Deactivated"
            notifLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end)
end

-- Menambahkan Semua Tombol Sesuai Urutan Permintaan
createToggle("ESP Player", "espPlayer")
createToggle("Auto Farm Coin", "autoFarmCoin")
createToggle("Noclip", "noclip")
createToggle("Inf Jump", "infJump")
