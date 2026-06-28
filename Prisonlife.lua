-- [[ MEKNOYU GUI | PRISON LIFE ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Max Distance untuk Aimbot (Jarak dekat sampai setengah map)
local MAX_AIM_DISTANCE = 150 

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuPrisonUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or localPlayer:WaitForChild("PlayerGui")

-- Status States
local states = {
    aimbotGuard = false,
    aimbotCrim = false,
    aimbotAngry = false,
    espActive = false,
    autoTakeGun = false
}

-- Table penyimpanan objek ESP untuk dibersihkan/diupdate
local espObjects = {}

-- ==========================================
--        MAIN GUI STRUCTURE (MAIN FRAME)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 260)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 150, 255)

-- Header Title
local headerTitle = Instance.new("TextLabel", mainFrame)
headerTitle.Size = UDim2.new(1, -40, 0, 35)
headerTitle.Position = UDim2.new(0, 10, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "Meknoyu GUI | Prison Life"
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
gridLayout.CellSize = UDim2.new(0.48, 0, 0, 40)
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
miniCorner.CornerRadius = UDim.new(1, 0)

local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Thickness = 2
miniStroke.Color = Color3.fromRGB(0, 150, 255)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniBtn.Visible = false
end)

-- ==========================================
--        LOGIKA AIMBOT WITH DISTANCE CHECK
-- ==========================================
-- Fungsi pembantu untuk mendeteksi tanda marah (💢) pada karakter pemain
local function isAngry(player)
    if player.Character then
        -- Mencari logo 💢 di dalam nama BillboardGui atau objek teks kustom karakter
        for _, descendant in pairs(player.Character:GetDescendants()) do
            if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
                if string.find(descendant.Text, "💢") then
                    return true
                end
            end
        end
    end
    return false
end

local function getClosestPlayerByTeam(teamName, checkAngry)
    local closestPlayer = nil
    local shortestDistance = math.huge

    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end

    local myPos = localPlayer.Character.HumanoidRootPart.Position

    for _, v in pairs(Players:GetPlayers()) do
        local isValidTeam = false
        if teamName == "AngryInmates" then
            isValidTeam = (v.Team and v.Team.Name == "Inmates" and isAngry(v))
        else
            isValidTeam = (v.Team and (v.Team.Name == teamName or (teamName == "Guards" and v.Team.Name == "Police")))
        end

        if v ~= localPlayer and isValidTeam then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                
                local worldDistance = (v.Character.HumanoidRootPart.Position - myPos).Magnitude
                if worldDistance <= MAX_AIM_DISTANCE then
                    local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local mousePos = UIS:GetMouseLocation()
                        local screenDistance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if screenDistance < shortestDistance then
                            closestPlayer = v
                            shortestDistance = screenDistance
                        end
                    end
                end

            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    local target = nil
    if states.aimbotGuard then
        target = getClosestPlayerByTeam("Guards")
    elseif states.aimbotCrim then
        target = getClosestPlayerByTeam("Criminals")
    elseif states.aimbotAngry then
        target = getClosestPlayerByTeam("AngryInmates")
    end

    if target and target.Character and target.Character:FindFirstChild("Head") then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
    end
end)

-- ==========================================
--        LOGIKA ESP BOX COLOR TEAM
-- ==========================================
local function getTeamColor(player)
    if player.Team then
        local name = player.Team.Name
        if name == "Criminals" then
            return Color3.fromRGB(255, 0, 0) -- Merah
        elseif name == "Inmates" then
            return Color3.fromRGB(255, 165, 0) -- Oren
        elseif name == "Guards" or name == "Police" then
            return Color3.fromRGB(0, 0, 255) -- Biru
        end
    end
    return Color3.fromRGB(255, 255, 255)
end

local function createESP(player)
    if espObjects[player] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "EspHighlight"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character
    highlight.Parent = screenGui
    
    espObjects[player] = highlight

    player.CharacterAdded:Connect(function(char)
        highlight.Adornee = char
    end)
end

RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if states.espActive then
                createESP(player)
                if espObjects[player] then
                    espObjects[player].Enabled = true
                    espObjects[player].FillColor = getTeamColor(player)
                    espObjects[player].OutlineColor = getTeamColor(player)
                end
            else
                if espObjects[player] then
                    espObjects[player].Enabled = false
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end)

-- ==========================================
--        LOGIKA TELEPORTASI & AUTO TAKE GUN
-- ==========================================
local function teleportToTarget(targetName)
    pcall(function()
        for _, object in pairs(workspace:GetDescendants()) do
            if (object:IsA("Model") or object:IsA("BasePart")) and object.Name == targetName then
                local targetCFrame = object:IsA("Model") and (object.PrimaryPart and object.PrimaryPart.CFrame or object:GetBoundingBox()) or object.CFrame
                if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character.HumanoidRootPart.CFrame = targetCFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
        end
    end)
end

local function fireTouchGiver()
    pcall(function()
        for _, object in pairs(workspace:GetDescendants()) do
            if object:IsA("BasePart") and object.Name == "TouchGiver" then
                if firetouchinterest and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local root = localPlayer.Character.HumanoidRootPart
                    firetouchinterest(root, object, 0)
                    firetouchinterest(root, object, 1)
                end
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if states.autoTakeGun then
        fireTouchGiver()
    end
end)

-- ==========================================
--        FUNGSI UTILITAS PEMBUATAN TOMBOL
-- ==========================================
local function createToggle(name, stateKey)
    local btn = Instance.new("TextButton", container)
    btn.Text = name .. " : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        states[stateKey] = not states[stateKey]
        
        -- Reset status tombol aimbot lain jika tombol ini diaktifkan
        if states[stateKey] then
            if stateKey == "aimbotGuard" then
                states.aimbotCrim = false
                states.aimbotAngry = false
            elseif stateKey == "aimbotCrim" then
                states.aimbotGuard = false
                states.aimbotAngry = false
            elseif stateKey == "aimbotAngry" then
                states.aimbotGuard = false
                states.aimbotCrim = false
            end
            
            -- Sinkronisasi visual tombol lainnya
            for _, child in pairs(container:GetChildren()) do
                if child:IsA("TextButton") and child.Name ~= name and string.find(child.Name, "Aimbot") then
                    child.Text = child.Name .. " : OFF"
                    child.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                end
            end
        end

        if states[stateKey] then
            btn.Text = name .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
        else
            btn.Text = name .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        end
    end)
    btn.Name = name
    return btn
end

local function createButton(name, callback)
    local btn = Instance.new("TextButton", container)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
--        MENYUSUN ELEMENT TOMBOL
-- ==========================================
createToggle("Aimbot Guard", "aimbotGuard")
createToggle("Aimbot Crims", "aimbotCrim")
createToggle("Aimbot Inmates Angry 💢", "aimbotAngry")

createToggle("ESP", "espActive")

createButton("TP TO PLACE POLICE", function()
    teleportToTarget("cubicle")
end)

createButton("TP TO PLACE CRIMINALS", function()
    teleportToTarget("Criminals Spawn")
end)

createToggle("Auto Take Gun", "autoTakeGun")

createButton("Tool Key", function()
    pcall(function()
        local keyCard = game:GetService("ReplicatedStorage"):FindFirstChild("Keycard", true) or game:GetService("ReplicatedStorage"):FindFirstChild("Key card", true)
        if keyCard and localPlayer:FindFirstChild("Backpack") then
            local clone = keyCard:Clone()
            clone.Parent = localPlayer.Backpack
        end
    end)
end)
