-- [[ MEKNOYU GUI | QUIET OR DIE ]] --

-- Hapus GUI lama jika dieksekusi berkali-kali agar tidak menumpuk
if game:GetService("CoreGui"):FindFirstChild("MeknoyuQuietOrDieUI") then
    game:GetService("CoreGui").MeknoyuQuietOrDieUI:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuQuietOrDieUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

-- Status States
local states = {
    espPlayers = false,
    noclip = false,
    infJump = false
}

-- ==========================================
-- MAIN GUI STRUCTURE (MAIN FRAME)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 200) -- Ukuran disesuaikan dengan isi 4 tombol grid
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

-- Rainbow Effect untuk Stroke Border (Persis seperti Chicken Farm)
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
headerTitle.Text = "Meknoyu GUI | Quiet or Die"
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
-- FUNGSI LOGIKA FITUR (QUIET OR DIE)
-- ==========================================

-- [1] ESP LOGIC (Metode Part Adornment untuk melacak Tubuh & Gerakan Player Invisible secara real-time)
local espFolder = Instance.new("Folder")
espFolder.Name = "MeknoyuESPFolder"
espFolder.Parent = game:GetService("CoreGui")

local function clearESP()
    espFolder:ClearAllChildren()
end

-- Fungsi pembantu untuk menempelkan kotak visual ke setiap part tubuh target
local function createPartAdornment(part, color)
    if not part:IsA("BasePart") or part.Name == "HumanoidRootPart" then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "MeknoPartESP"
    box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05) -- Sedikit lebih besar dari part asli agar jelas
    box.Color3 = color
    box.Transparency = 0.4 -- Semi-transparan agar pergerakannya estetik
    box.AlwaysOnTop = true -- Tembus dinding/obstacle
    box.ZIndex = 5
    box.Adornee = part
    box.Parent = espFolder
end

RunService.RenderStepped:Connect(function()
    if states.espPlayers then
        pcall(function()
            -- Bersihkan adornment lama yang kehilangan objek / adornee-nya tiap frame
            for _, adorn in pairs(espFolder:GetChildren()) do
                if not adorn.Adornee or not adorn.Adornee:IsDescendantOf(workspace) then
                    adorn:Destroy()
                end
            end

            -- Scan KillerFolder (Merah)
            local KillerFolder = workspace:FindFirstChild("KillerFolder")
            if KillerFolder then
                for _, killer in pairs(KillerFolder:GetChildren()) do
                    if killer:IsA("Model") and killer:FindFirstChild("HumanoidRootPart") then
                        for _, bodyPart in pairs(killer:GetChildren()) do
                            if bodyPart:IsA("BasePart") and not bodyPart:FindFirstChild("MeknoPartESP") then
                                createPartAdornment(bodyPart, Color3.fromRGB(255, 0, 0))
                            end
                        end
                    end
                end
            end

            -- Scan PlayersFolder (Hijau)
            local PlayersFolder = workspace:FindFirstChild("PlayersFolder")
            if PlayersFolder then
                for _, plr in pairs(PlayersFolder:GetChildren()) do
                    if plr:IsA("Model") and plr.Name ~= LocalPlayer.Name and plr:FindFirstChild("HumanoidRootPart") then
                        for _, bodyPart in pairs(plr:GetChildren()) do
                            if bodyPart:IsA("BasePart") and not bodyPart:FindFirstChild("MeknoPartESP") then
                                createPartAdornment(bodyPart, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    end
                end
            end
        end)
    else
        clearESP()
    end
end)

-- [2] NOCLIP LOGIC (Menggantikan Anti Blink)
RunService.Stepped:Connect(function()
    if states.noclip then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- [3] TELEPORT SPAWN FUNCTION
local function teleportSpawn()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local spawnPart = workspace:FindFirstChild("Spawn", true) -- true = recursive search ke seluruh model workspace
        
        if hrp and spawnPart and spawnPart:IsA("BasePart") then
            hrp.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
            notifLabel.Text = "Teleported to Spawn!"
            notifLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            notifLabel.Text = "Spawn Part Not Found!"
            notifLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end

-- [4] INF JUMP LOGIC
UserInputService.JumpRequest:Connect(function()
    if states.infJump then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
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

-- Menambahkan Semua Tombol Sesuai Fitur Terbaru
createToggle("ESP Players", "espPlayers")
createToggle("Noclip", "noclip")
createButton("Teleport Spawn", teleportSpawn)
createToggle("Inf Jump", "infJump")
