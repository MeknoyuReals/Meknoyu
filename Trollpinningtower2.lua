-- [[ MEKNOYU GUI | TROLL PINNING TOWER 2 ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuTrollUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or localPlayer:WaitForChild("PlayerGui")

-- Status States
local states = {
    autoGudock = false,
    autoWhite = false
}

-- ==========================================
--        MAIN GUI STRUCTURE (MAIN FRAME)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
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
headerTitle.Text = "Meknoyu GUI | Troll Pinning Tower 2"
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
container.Size = UDim2.new(1, -20, 1, -50)
container.Position = UDim2.new(0, 10, 0, 40)
container.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout", container)
gridLayout.CellSize = UDim2.new(0.48, 0, 0, 45)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)

-- ==========================================
--        MINI BUTTON (BULAT & DRAGGABLE)
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
miniCorner.CornerRadius = UDim.new(1, 0) -- Bulat sempurna

local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Thickness = 2
miniStroke.Color = Color3.fromRGB(255, 255, 255)

-- Fungsi Toggle Hiding/Showing Main GUI
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniBtn.Visible = false
end)

-- ==========================================
--        LOGIKA AUTO CLICK / SPAM PART
-- ==========================================
local function fireTouchOnPart(partName)
    pcall(function()
        for _, object in pairs(workspace:GetDescendants()) do
            if object:IsA("BasePart") and object.Name == partName then
                if firetouchinterest and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local toTouch = localPlayer.Character.HumanoidRootPart
                    firetouchinterest(toTouch, object, 0)
                    firetouchinterest(toTouch, object, 1)
                end
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if states.autoGudock then
        fireTouchOnPart("Gudock")
    end
    if states.autoWhite then
        fireTouchOnPart("사라지는 파트")
    end
end)

-- ==========================================
--        LOGIKA TELEPORTASI (TP)
-- ==========================================
local function teleportToPart(partName)
    pcall(function()
        for _, object in pairs(workspace:GetDescendants()) do
            if object:IsA("BasePart") and object.Name == partName then
                if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character.HumanoidRootPart.CFrame = object.CFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
        end
    end)
end

-- ==========================================
--        MEMBUAT FUNGSIONALITAS TOMBOL
-- ==========================================
-- Fungsi Toggle (On/Off)
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
        end
    end)
end

-- Fungsi Tombol Sekali Klik (Instant Action)
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

-- Menambahkan Semua Tombol Ke Menu
createToggle("Troll Button", "autoGudock")
createToggle("Troll Part White", "autoWhite")

createButton("TP TO WIN", function()
    teleportToPart("Seat")
end)

createButton("TP TO TROLL", function()
    teleportToPart("Gudock")
end)
