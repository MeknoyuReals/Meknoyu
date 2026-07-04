-- [[ MEKNOYU GUI | CHICKEN FARM ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuChickenFarmUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or localPlayer:WaitForChild("PlayerGui")

-- Status States
local states = {
    autoCollectEgg = false,
    autoCollectCash = false,
    depositEgg = false,
    buyChicken = false,
    upgradeSellEgg = false
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
headerTitle.Text = "Meknoyu GUI | Chicken Farm"
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

-- UI Text Notifikasi
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
-- FUNGSI LOGIKA FITUR
-- ==========================================

-- 1. Merge Chicken
local function mergeChicken()
    pcall(function()
        local args = { "Merge Chickens" }
        game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remotefunction"):InvokeServer(unpack(args))
        notifLabel.Text = "Chickens Merged!"
        notifLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
end

-- 2. Logika Auto Collect Egg (Folder Eggs -> TouchInterest + Discard Lucky Block)
task.spawn(function()
    while true do
        if states.autoCollectEgg then
            pcall(function()
                -- Script Ke-1: Ambil telur dari Folder Eggs
                local eggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("Eggs", true)
                if eggsFolder then
                    for _, obj in pairs(eggsFolder:GetDescendants()) do
                        if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then
                            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                firetouchinterest(localPlayer.Character.HumanoidRootPart, obj, 0)
                                firetouchinterest(localPlayer.Character.HumanoidRootPart, obj, 1)
                            end
                        end
                    end
                end
                
                -- Script Ke-2: Discard Lucky Block
                local discardArgs = { "Discard Lucky Block" }
                game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remoteevent"):FireServer(unpack(discardArgs))
            end)
        end
        task.wait(0.3)
    end
end)

-- 3. Logika Auto Collect Cash (Remote Invoke)
task.spawn(function()
    while true do
        if states.autoCollectCash then
            pcall(function()
                local args = { "Collect Cash" }
                game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remotefunction"):InvokeServer(unpack(args))
            end)
        end
        task.wait(0.3)
    end
end)

-- 4. Logika Auto Deposit Egg
task.spawn(function()
    while true do
        if states.depositEgg then
            pcall(function()
                local args = { "Deposit Eggs" }
                game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remotefunction"):InvokeServer(unpack(args))
            end)
        end
        task.wait(0.5)
    end
end)

-- 5. Logika Auto Buy Chicken
task.spawn(function()
    while true do
        if states.buyChicken then
            pcall(function()
                local args = { "Buy Chickens", 5 }
                game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remotefunction"):InvokeServer(unpack(args))
            end)
        end
        task.wait(0.5)
    end
end)

-- 6. Logika Upgrade Sell Egg
task.spawn(function()
    while true do
        if states.upgradeSellEgg then
            pcall(function()
                local args = { "Upgrade Process Level" }
                game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remotefunction"):InvokeServer(unpack(args))
            end)
        end
        task.wait(0.5)
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

local function createButton(name, callback)
    local btn = Instance.new("TextButton", container)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- Menambahkan Semua Tombol
createButton("Merge Chicken", mergeChicken)
createToggle("Auto Collect Egg", "autoCollectEgg")
createToggle("Auto Collect Cash", "autoCollectCash")
createToggle("Deposit Egg", "depositEgg")
createToggle("Buy Chicken", "buyChicken")
createToggle("Upgrade Sell Egg", "upgradeSellEgg")
