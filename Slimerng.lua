-- [[ MEKNOYU GUI | SLIME RNG ]] --

if game:GetService("CoreGui"):FindFirstChild("MeknoyuSlimeRNGUI") then
    game:GetService("CoreGui").MeknoyuSlimeRNGUI:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuSlimeRNGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

-- Status States
local states = {
    autoRebirth = false,
    autoBuyZone = false,
    claimReward = false,
    autoSpins = false
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
headerTitle.Text = "Meknoyu GUI | Slime RNG"
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
notifLabel.Text = "Welcome to Meknoyu GUI!"
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
-- FUNGSI LOGIKA FITUR (SLIME RNG)
-- ==========================================

-- Fungsi Eksekusi Auto-Click Handlers
local function executeClick(btnName)
    pcall(function()
        for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if gui.Name == btnName and (gui:IsA("ImageButton") or gui:IsA("TextButton")) then
                if gui.Visible then
                    -- Trigger event firesignal
                    if firesignal then
                        firesignal(gui.MouseButton1Click)
                        firesignal(gui.Activated)
                    end
                    -- Trigger event VirtualUser simulasi click fisik
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(gui.AbsolutePosition.X + (gui.AbsoluteSize.X / 2), gui.AbsolutePosition.Y + (gui.AbsoluteSize.Y / 2)))
                end
            end
        end
    end)
end

-- Loop Eksekusi Utama (Auto Clicker Instan Tanpa Lag)
task.spawn(function()
    while true do
        if states.autoRebirth then
            executeClick("RebirthButton")
        end
        if states.autoBuyZone then
            executeClick("BuyButton")
        end
        if states.claimReward then
            executeClick("RewardIcon2")
        end
        if states.autoSpins then
            executeClick("ClaimButton")
        end
        task.wait(0.1)
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
            notifLabel.Text = name .. " Activated"
            notifLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            btn.Text = name .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            notifLabel.Text = name .. " Deactivated"
            notifLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end)
end

-- Menambahkan Semua Tombol Fitur Sesuai Menu Grid Slime RNG
createToggle("Auto Rebirth", "autoRebirth")
createToggle("Auto Buy Zone", "autoBuyZone")
createToggle("Claim Reward", "claimReward")
createToggle("Auto Spins", "autoSpins")
