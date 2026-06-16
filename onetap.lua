-- [[ MEKNOYU PREMIUM HUB | [FPS] ONE TAP ASSISTANT ]] --
-- CONFIGURATION: PERSISTENT CONFIGS | AIM ENGINE | VISUAL ESP CONTROLLER

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

if game:GetService("CoreGui"):FindFirstChild("MeknoyuGuiOneTap_Premium") then 
    game:GetService("CoreGui"):FindFirstChild("MeknoyuGuiOneTap_Premium"):Destroy() 
end 

local ScreenGui = Instance.new("ScreenGui") 
ScreenGui.Name = "MeknoyuGuiOneTap_Premium" 
ScreenGui.Parent = game:GetService("CoreGui") 
ScreenGui.ResetOnSpawn = false 

-- Persistent Configurations (FPS Universal Core)
getgenv().MeknoOneTapAim = getgenv().MeknoOneTapAim or false
getgenv().MeknoOneTapEsp = getgenv().MeknoOneTapEsp or false
getgenv().MeknoNoRecoil = getgenv().MeknoNoRecoil or false
getgenv().MeknoTriggerBot = getgenv().MeknoTriggerBot or false

local CustomWalkSpeed = 24
local CustomJumpPower = 50

-- ==================================================================== -- [[ UI UTAMA (MAIN FRAME - PREMIUM FPS HUB) ]] -- ==================================================================== 
local MainFrame = Instance.new("Frame") 
MainFrame.Name = "MainFrame" 
MainFrame.Size = UDim2.new(0, 520, 0, 360) 
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0) 
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) 
MainFrame.BorderSizePixel = 0 
MainFrame.Active = true 
MainFrame.Draggable = true 
MainFrame.Visible = true 
MainFrame.Parent = ScreenGui 

local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 12); MainCorner.Parent = MainFrame 

-- Efek Stroke Premium (Glow Minimalis Orange Accent)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(230, 126, 34) 
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local Header = Instance.new("Frame"); Header.Name = "Header"; Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Header.BorderSizePixel = 0; Header.Parent = MainFrame 
local HeaderCorner = Instance.new("UICorner"); HeaderCorner.CornerRadius = UDim.new(0, 12); HeaderCorner.Parent = Header 

local Title = Instance.new("TextLabel"); Title.Size = UDim2.new(0.7, 0, 1, 0); Title.Position = UDim2.new(0.04, 0, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "Meknoyu Gui | One Tap"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 15; Title.Font = Enum.Font.SourceSansBold; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = Header 
local CloseBtn = Instance.new("TextButton"); CloseBtn.Name = "CloseBtn"; CloseBtn.Size = UDim2.new(0, 28, 0, 28); CloseBtn.Position = UDim2.new(0.93, 0, 0.18, 0); CloseBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.TextSize = 14; CloseBtn.Font = Enum.Font.SourceSansBold; CloseBtn.Parent = Header Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0) 

local ButtonContainer = Instance.new("ScrollingFrame") 
ButtonContainer.Name = "ButtonContainer"; ButtonContainer.Size = UDim2.new(1, 0, 1, -45); ButtonContainer.Position = UDim2.new(0, 0, 0, 45); ButtonContainer.BackgroundTransparency = 1; ButtonContainer.ScrollBarThickness = 6; ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 400); ButtonContainer.Parent = MainFrame 

local UIGridLayout = Instance.new("UIGridLayout"); UIGridLayout.Parent = ButtonContainer; UIGridLayout.CellSize = UDim2.new(0, 155, 0, 45); UIGridLayout.CellPadding = UDim2.new(0, 12, 0, 12); UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder; UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top 
local UIPadding = Instance.new("UIPadding"); UIPadding.Parent = ButtonContainer; UIPadding.PaddingTop = UDim.new(0, 15) 

local MiniButton = Instance.new("TextButton") 
MiniButton.Name = "MeknoyuMiniButton" 
MiniButton.Size = UDim2.new(0, 60, 0, 60) 
MiniButton.Position = UDim2.new(0.05, 0, 0.1, 0) 
MiniButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35) 
MiniButton.Text = "Mekno FPS" 
MiniButton.TextColor3 = Color3.fromRGB(230, 126, 34) 
MiniButton.TextSize = 11
MiniButton.Font = Enum.Font.SourceSansBold
MiniButton.Visible = false 
MiniButton.Active = true 
MiniButton.Draggable = true 
MiniButton.Parent = ScreenGui 
Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(1, 0) 
local MiniStroke = Instance.new("UIStroke"); MiniStroke.Thickness = 1.5; MiniStroke.Color = Color3.fromRGB(230, 126, 34); MiniStroke.Parent = MiniButton

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniButton.Visible = true end) 
MiniButton.MouseButton1Click:Connect(function() MiniButton.Visible = false; MainFrame.Visible = true end) 

-- ==================================================================== -- [[ FITUR FUNCTIONS GENERATOR (SLEEK TOGGLE SYSTEM) ]] -- ==================================================================== 
local function createFeatureButton(text, layoutOrder, isToggle, globalVarName, callback) 
    local Btn = Instance.new("TextButton") 
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45) 
    Btn.Text = isToggle and "  " .. text or text
    Btn.TextColor3 = Color3.fromRGB(245, 245, 245) 
    Btn.TextSize = 11 
    Btn.Font = Enum.Font.SourceSansBold 
    Btn.LayoutOrder = layoutOrder 
    Btn.TextXAlignment = isToggle and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
    Btn.Parent = ButtonContainer 
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6) 

    if isToggle then
        local Switch = Instance.new("Frame")
        Switch.Size = UDim2.new(0, 36, 0, 20)
        Switch.Position = UDim2.new(0.72, 0, 0.28, 0)
        Switch.BackgroundColor3 = getgenv()[globalVarName] and Color3.fromRGB(230, 126, 34) or Color3.fromRGB(70, 70, 75)
        Switch.Parent = Btn
        Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.Position = getgenv()[globalVarName] and UDim2.new(0, 18, 0, 2) or UDim2.new(0, 2, 0, 2)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = Switch
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        Btn.MouseButton1Click:Connect(function() 
            getgenv()[globalVarName] = not getgenv()[globalVarName]
            local state = getgenv()[globalVarName]
            local targetPos = state and UDim2.new(0, 18, 0, 2) or UDim2.new(0, 2, 0, 2)
            local targetColor = state and Color3.fromRGB(230, 126, 34) or Color3.fromRGB(70, 70, 75)
            TweenService:Create(Circle, TweenInfo.new(0.12), {Position = targetPos}):Play()
            TweenService:Create(Switch, TweenInfo.new(0.12), {BackgroundColor3 = targetColor}):Play()
            if callback then callback(state) end
        end)
    else
        Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    end
    return Btn 
end 

-- ==================================================================== -- [[ GENERATE 8 ESSENTIAL FPS ONE TAP FEATURES ]] -- ==================================================================== 
createFeatureButton("Silent Aim (Head)", 1, true, "MeknoOneTapAim")
createFeatureButton("Trigger Bot", 2, true, "MeknoTriggerBot")
createFeatureButton("ESP Box Neutrals", 3, true, "MeknoOneTapEsp")
createFeatureButton("No Recoil Stabilizer", 4, true, "MeknoNoRecoil")
createFeatureButton("FPS Boost Buff", 5, false, nil, function()
    local t = Workspace:FindFirstChildOfClass("Terrain")
    if t then t.Decoration = false end
    game:GetService("Lighting").GlobalShadows = false
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end)
createFeatureButton("Server Hop Bypass", 6, false, nil, function()
    local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(x.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
            break
        end
    end
end)

-- ==================================================================== -- [[ ADVANCED FPS MATHEMATICS ENGINE ]] -- ==================================================================== 

local function GetClosestPlayerToCamera()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            if player.Team ~= LocalPlayer.Team or player.Team == nil then
                local distance = (player.Character.Head.Position - Camera.CFrame.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Loop Utama
RunService.RenderStepped:Connect(function()
    pcall(function()
        if getgenv().MeknoOneTapAim then
            local targetEnemy = GetClosestPlayerToCamera()
            if targetEnemy and targetEnemy.Character and targetEnemy.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetEnemy.Character.Head.Position)
            end
        end

        if getgenv().MeknoTriggerBot and Mouse.Target then
            local targetParent = Mouse.Target.Parent
            local hum = targetParent:FindFirstChildOfClass("Humanoid") or targetParent.Parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local targetedPlayer = Players:GetPlayerFromCharacter(targetParent) or Players:GetPlayerFromCharacter(targetParent.Parent)
                if targetedPlayer and (targetedPlayer.Team ~= LocalPlayer.Team or targetedPlayer.Team == nil) then
                    mouse1click() 
                end
            end
        end

        if getgenv().MeknoNoRecoil then
            local currentTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if currentTool then
                for _, prop in pairs(currentTool:GetDescendants()) do
                    if prop:IsA("NumberValue") or prop:IsA("IntValue") then
                        if prop.Name:lower():find("recoil") or prop.Name:lower():find("kick") then
                            prop.Value = 0
                        end
                    end
                end
            end
        end
    end)
end)

-- Loop Utama: ESP Box Visualizer
task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().MeknoOneTapEsp then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if not player.Character.HumanoidRootPart:FindFirstChild("MeknoEsp") then
                            local BoxHighlight = Instance.new("Highlight")
                            BoxHighlight.Name = "MeknoEsp"
                            BoxHighlight.FillColor = Color3.fromRGB(230, 126, 34)
                            BoxHighlight.FillTransparency = 0.65
                            BoxHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            BoxHighlight.OutlineTransparency = 0.1
                            BoxHighlight.Adornee = player.Character
                            BoxHighlight.Parent = player.Character.HumanoidRootPart
                        end
                    end
                end
            end)
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local esp = player.Character.HumanoidRootPart:FindFirstChild("MeknoEsp")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Meknoyu Gui | One Tap", Text = "Engine Ready!", Duration = 5})