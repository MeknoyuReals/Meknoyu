-- [[ MEKNOYU GUI | SPIN A SOCCER CARD ]] --

-- Hapus GUI lama jika dieksekusi berkali-kali agar tidak menumpuk
if game:GetService("CoreGui"):FindFirstChild("MeknoyuSpinSoccerUI") then
    game:GetService("CoreGui").MeknoyuSpinSoccerUI:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Status States
local states = {
    autoRebirth = false,
    autoClaimSoccer = false,
    autoCollectCash = false,
    autoOpenPack = false,
    autoSpinWheel = false
}

-- ==========================================
-- MAIN GUI STRUCTURE (MAIN FRAME)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuSpinSoccerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 240) -- Ukuran grid pas untuk menampung 6 item tombol
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -120)
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
headerTitle.Text = "Meknoyu GUI | Spin a Soccer Card"
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
-- LOGIKA CORE UTAMA GAME
-- ==========================================

-- Helper function untuk simulasi klik tombol secara andal
local function virtualClick(button)
    if button and button:IsA("GuiButton") then
        local connections = getconnections or get_signal_cons
        if connections then
            for _, con in pairs(connections(button.MouseButton1Click)) do
                con:Fire()
            end
        else
            button:SimulateClick()
        end
    end
end

-- [1] AUTO REBIRTH LOGIC
task.spawn(function()
    while true do
        if states.autoRebirth then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Rebirth"):FireServer()
            end)
        end
        task.wait(0.3)
    end
end)

-- [2] AUTO CLAIM SOCCER LOGIC
task.spawn(function()
    while true do
        if states.autoClaimSoccer then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                if pGui then
                    local targetBtn = pGui:FindFirstChild("ClaimAllButton", true) and pGui:FindFirstChild("ClaimAllButton", true):FindFirstChild("Button")
                    if targetBtn and targetBtn.Visible then
                        virtualClick(targetBtn)
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

-- [3] BACK TO PLOT FUNCTION
local function backToPlot()
    pcall(function()
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            local targetBtn = pGui:FindFirstChild("HUD") and pGui.HUD:FindFirstChild("Top") 
                and pGui.HUD.Top:FindFirstChild("Plot")

            if targetBtn then
                virtualClick(targetBtn)
                notifLabel.Text = "Back To Plot Triggered!"
                notifLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                notifLabel.Text = "Plot Button Not Found!"
                notifLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end)
end

-- [4] AUTO COLLECT CASH LOGIC
task.spawn(function()
    while true do
        if states.autoCollectCash then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hrp and firetouchinterest then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") and v.Name == "Top" then
                            firetouchinterest(hrp, v, 0)
                            task.wait()
                            firetouchinterest(hrp, v, 1)
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- [5] AUTO OPEN PACK LOGIC
task.spawn(function()
    while true do
        if states.autoOpenPack then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                if pGui then
                    local targetBtn = pGui:FindFirstChild("Bottom", true) 
                        and pGui:FindFirstChild("Bottom", true):FindFirstChild("PackContainer") 
                        and pGui:FindFirstChild("Bottom", true).PackContainer:FindFirstChild("CurrentPack")

                    if targetBtn and targetBtn.Visible then
                        virtualClick(targetBtn)
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- [6] AUTO SPIN WHEEL LOGIC
task.spawn(function()
    while true do
        if states.autoSpinWheel then
            pcall(function()
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                if pGui then
                    local targetBtn = pGui:FindFirstChild("SpinWheel", true)
                        and pGui:FindFirstChild("SpinWheel", true):FindFirstChild("Main")
                        and pGui:FindFirstChild("SpinWheel", true).Main:FindFirstChild("Spin")
                        
                    if targetBtn and targetBtn:IsA("GuiButton") and targetBtn.Visible then
                        virtualClick(targetBtn)
                    end
                end
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

-- Menambahkan Semua Urutan Tombol Sesuai Request
createToggle("Auto Rebirth", "autoRebirth")
createToggle("Auto Claim Soccer", "autoClaimSoccer")
createButton("Back To Plot", backToPlot)
createToggle("Auto Collect Cash", "autoCollectCash")
createToggle("Auto Open Pack", "autoOpenPack")
createToggle("Auto Spin Wheel (26mins)", "autoSpinWheel")
