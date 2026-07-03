-- [[ MEKNOYU GUI | MINE PER CLICK ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuMineClickUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or localPlayer:WaitForChild("PlayerGui")

-- Status States
local states = {
    autoClickHit = false,
    autoSell = false,
    autoRebirth = false,
    autoUpgrade = false,
    antiAfk = false
}

-- ==========================================
-- MAIN GUI STRUCTURE (MAIN FRAME)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 320) -- Diperpanjang agar muat tombol baru & notif teks
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true -- Bawaan agar bisa digeser
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
headerTitle.Text = "Meknoyu GUI | Mine Per Click"
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
container.Size = UDim2.new(1, -20, 1, -90) -- Disesuaikan space-nya agar pas
container.Position = UDim2.new(0, 10, 0, 40)
container.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout", container)
gridLayout.CellSize = UDim2.new(0.48, 0, 0, 45)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)

-- UI Text Notifikasi (Agar teks penolakan/status tidak spam di output)
local notifLabel = Instance.new("TextLabel", mainFrame)
notifLabel.Name = "NotifLabel"
notifLabel.Size = UDim2.new(1, -20, 0, 25)
notifLabel.Position = UDim2.new(0, 10, 1, -30)
notifLabel.BackgroundTransparency = 1
notifLabel.Text = "System: Waiting..."
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
-- GAME LOOP LOGIC (LOOPS & REMOTES)
-- ==========================================
task.spawn(function()
    while true do
        if states.autoClickHit then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Click"):FireServer()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("HitWall"):FireServer(1, 3)
            end)
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if states.autoSell then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("SellAllLoot"):FireServer()
                notifLabel.Text = "System [Auto Sell]: Loot sold successfully!"
                notifLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            end)
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if states.autoRebirth then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Rebirth"):FireServer("Rebirth")
            end)
        end
        task.wait(1) -- Delay anti-lag untuk Rebirth
    end
end)

task.spawn(function()
    while true do
        if states.autoUpgrade then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("UpgradeSlot"):FireServer("Cash")
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("UpgradeWalkspeed"):FireServer("Cash")
                notifLabel.Text = "System [Auto Upgrade]: Equipment upgraded!"
                notifLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            end)
        end
        task.wait(0.5)
    end
end)

-- ==========================================
-- ANTI AFK LOGIC
-- ==========================================
local VirtualUser = game:GetService("VirtualUser")
localPlayer.Idled:Connect(function()
    if states.antiAfk then
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            notifLabel.Text = "System [Anti-AFK]: Prevented Disconnect!"
            notifLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        end)
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
            if stateKey == "autoSell" or stateKey == "autoUpgrade" then
                notifLabel.Text = "System ["..name.."]: Deactivated"
                notifLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
    end)
end

-- Menambahkan Semua Tombol Ke Menu (Sama persis secara tata letak)
createToggle("Auto Click & Hit", "autoClickHit")
createToggle("Auto Sell", "autoSell")
createToggle("Auto Rebirth", "autoRebirth")
createToggle("Auto Upgrade Spd/Cry", "autoUpgrade")
createToggle("Anti AFK", "antiAfk")
