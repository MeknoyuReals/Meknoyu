-- [[ MEKNOYU GUI | MM2 ]] --
-- UPDATED: RESTORED INVISIBLE & ANTI-FLING LOGIC

if game.PlaceId ~= 142823291 and game.PlaceId ~= 335132305 then 
    game.Players.LocalPlayer:Kick("Kamu tidak di game") 
    return 
end 

local Players = game:GetService("Players") 
local RunService = game:GetService("RunService") 
local TeleportService = game:GetService("TeleportService") 
local LocalPlayer = Players.LocalPlayer 
local Workspace = game:GetService("Workspace") 
local Camera = Workspace.CurrentCamera 

if game:GetService("CoreGui"):FindFirstChild("MeknoyuMM2_Gui") then 
    game:GetService("CoreGui"):FindFirstChild("MeknoyuMM2_Gui"):Destroy() 
end 

local ScreenGui = Instance.new("ScreenGui") 
ScreenGui.Name = "MeknoyuMM2_Gui" 
ScreenGui.Parent = game:GetService("CoreGui") 
ScreenGui.ResetOnSpawn = false 

-- Variables (No Edit Lainnya) 
local EspEnabled = false 
local NoclipEnabled = false 
local NormalSpeed = 16 
local CustomSpeed = 50 
local SpeedEnabled = false 
local GunEspEnabled = false 
local AutoGrabEnabled = false 
local AntiFlingEnabled = false 
local MurdererAimbotEnabled = false 
local SheriffAimbotEnabled = false 
local TpKillEnabled = false 
local TpToMurdererEnabled = false 
local InvisibleEnabled = false 
local hiddenfling = false 
local movel = 0.1
getgenv().AutoFarmCoinEnabled = false
local spawnAtPlayer = false

-- ==================================================================== -- [[ UI UTAMA (MAIN FRAME) ]] -- ==================================================================== 
local MainFrame = Instance.new("Frame") 
MainFrame.Name = "MainFrame" 
MainFrame.Size = UDim2.new(0, 520, 0, 340) 
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0) 
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35) 
MainFrame.BorderSizePixel = 0 
MainFrame.Active = true 
MainFrame.Draggable = true 
MainFrame.Visible = true 
MainFrame.Parent = ScreenGui 

local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 10); MainCorner.Parent = MainFrame 
local Header = Instance.new("Frame"); Header.Name = "Header"; Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Header.BorderSizePixel = 0; Header.Parent = MainFrame 
local HeaderCorner = Instance.new("UICorner"); HeaderCorner.CornerRadius = UDim.new(0, 10); HeaderCorner.Parent = Header 
local Title = Instance.new("TextLabel"); Title.Size = UDim2.new(0.7, 0, 1, 0); Title.Position = UDim2.new(0.03, 0, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "Meknoyu GUI | MM2"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 16; Title.Font = Enum.Font.SourceSansBold; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = Header 
local CloseBtn = Instance.new("TextButton"); CloseBtn.Name = "CloseBtn"; CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(0.93, 0, 0.125, 0); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.TextSize = 16; CloseBtn.Font = Enum.Font.SourceSansBold; CloseBtn.Parent = Header Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0) 

local ButtonContainer = Instance.new("ScrollingFrame") 
ButtonContainer.Name = "ButtonContainer"; ButtonContainer.Size = UDim2.new(1, 0, 1, -40); ButtonContainer.Position = UDim2.new(0, 0, 0, 40); ButtonContainer.BackgroundTransparency = 1; ButtonContainer.ScrollBarThickness = 6; ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 580); ButtonContainer.Parent = MainFrame 

local UIGridLayout = Instance.new("UIGridLayout"); UIGridLayout.Parent = ButtonContainer; UIGridLayout.CellSize = UDim2.new(0, 155, 0, 45); UIGridLayout.CellPadding = UDim2.new(0, 12, 0, 12); UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder; UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top 
local UIPadding = Instance.new("UIPadding"); UIPadding.Parent = ButtonContainer; UIPadding.PaddingTop = UDim.new(0, 15) 

local MiniButton = Instance.new("TextButton") 
MiniButton.Name = "KovexMiniButton"; MiniButton.Size = UDim2.new(0, 55, 0, 55); MiniButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50); MiniButton.Text = "Mekno"; MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255); MiniButton.Visible = false; MiniButton.Active = true; MiniButton.Draggable = true; MiniButton.Parent = ScreenGui Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(1, 0) 

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniButton.Position = MainFrame.Position; MiniButton.Visible = true end) 
MiniButton.MouseButton1Click:Connect(function() MiniButton.Visible = false; MainFrame.Position = MiniButton.Position; MainFrame.Visible = true end) 

-- ==================================================================== -- [[ INVISIBLE KOTAKAN SUBMENU (DRAGGABLE) ]] -- ==================================================================== 
local InvisSubFrame = Instance.new("Frame")
InvisSubFrame.Name = "InvisSubFrame"
InvisSubFrame.Size = UDim2.new(0, 200, 0, 110)
InvisSubFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
InvisSubFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
InvisSubFrame.BorderSizePixel = 0
InvisSubFrame.Active = true
InvisSubFrame.Draggable = true
InvisSubFrame.Visible = false
InvisSubFrame.Parent = ScreenGui

local InvisSubCorner = Instance.new("UICorner"); InvisSubCorner.CornerRadius = UDim.new(0, 8); InvisSubCorner.Parent = InvisSubFrame
local InvisHeader = Instance.new("Frame"); InvisHeader.Size = UDim2.new(1, 0, 0, 25); InvisHeader.BackgroundColor3 = Color3.fromRGB(50, 50, 55); InvisHeader.BorderSizePixel = 0; InvisHeader.Parent = InvisSubFrame
local InvisHeaderCorner = Instance.new("UICorner"); InvisHeaderCorner.CornerRadius = UDim.new(0, 8); InvisHeaderCorner.Parent = InvisHeader

local InvisTitle = Instance.new("TextLabel"); InvisTitle.Size = UDim2.new(0.8, 0, 1, 0); InvisTitle.Position = UDim2.new(0.05, 0, 0, 0); InvisTitle.BackgroundTransparency = 1; InvisTitle.Text = ""; InvisTitle.TextColor3 = Color3.fromRGB(200, 200, 200); InvisTitle.TextSize = 12; InvisTitle.Font = Enum.Font.SourceSansBold; InvisTitle.TextXAlignment = Enum.TextXAlignment.Left; InvisTitle.Parent = InvisSubFrame

local InvisClose = Instance.new("TextButton"); InvisClose.Size = UDim2.new(0, 20, 0, 20); InvisClose.Position = UDim2.new(0.88, 0, 0.1, 0); InvisClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50); InvisClose.Text = "X"; InvisClose.TextColor3 = Color3.fromRGB(255, 255, 255); InvisClose.TextSize = 11; InvisClose.Font = Enum.Font.SourceSansBold; InvisClose.Parent = InvisSubFrame; Instance.new("UICorner", InvisClose).CornerRadius = UDim.new(1, 0)
InvisClose.MouseButton1Click:Connect(function() InvisSubFrame.Visible = false end)

local InvisToggleBtn = Instance.new("TextButton")
InvisToggleBtn.Size = UDim2.new(0, 170, 0, 40)
InvisToggleBtn.Position = UDim2.new(0.085, 0, 0.45, 0)
InvisToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
InvisToggleBtn.Text = "Invisible: OFF"
InvisToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InvisToggleBtn.TextSize = 13
InvisToggleBtn.Font = Enum.Font.SourceSansBold
InvisToggleBtn.Parent = InvisSubFrame
Instance.new("UICorner", InvisToggleBtn).CornerRadius = UDim.new(0, 6)

local function setInvisState(state) 
    local c = game.Players.LocalPlayer.Character if not c then return end 
    for _, o in pairs(workspace:GetChildren()) do if o.Name == 'invischair' then pcall(function() o:Destroy() end) end end 
    for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end end 
    if state then 
        local r = c:FindFirstChild("HumanoidRootPart") if not r then return end 
        task.wait(0.05) local scf = r.CFrame; local under = r.Position + Vector3.new(0, -100, 0); c:MoveTo(under) 
        task.wait(0.1) local s = Instance.new("Seat", workspace); s.Anchored = true; s.CanCollide = false; s.Transparency = 1; s.Position = under; s.Name = "invischair" 
        local w = Instance.new("Weld", s); w.Part0 = s; w.Part1 = r; task.wait(); s.CFrame = scf; s.Anchored = false 
        for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 0.5 end end 
    end 
end 

InvisToggleBtn.MouseButton1Click:Connect(function()
    InvisibleEnabled = not InvisibleEnabled
    InvisToggleBtn.Text = InvisibleEnabled and "Invisible: ON" or "Invisible: OFF"
    InvisToggleBtn.BackgroundColor3 = InvisibleEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60)
    setInvisState(InvisibleEnabled)
end)

-- ==================================================================== -- [[ SHOOT MURDER SUBMENU (DRAGGABLE) ]] -- ==================================================================== 
local ShootSubFrame = Instance.new("Frame")
ShootSubFrame.Name = "ShootSubFrame"
ShootSubFrame.Size = UDim2.new(0, 200, 0, 110)
ShootSubFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
ShootSubFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ShootSubFrame.BorderSizePixel = 0
ShootSubFrame.Active = true
ShootSubFrame.Draggable = true
ShootSubFrame.Visible = false
ShootSubFrame.Parent = ScreenGui

local ShootSubCorner = Instance.new("UICorner"); ShootSubCorner.CornerRadius = UDim.new(0, 8); ShootSubCorner.Parent = ShootSubFrame
local ShootHeader = Instance.new("Frame"); ShootHeader.Size = UDim2.new(1, 0, 0, 25); ShootHeader.BackgroundColor3 = Color3.fromRGB(50, 50, 55); ShootHeader.BorderSizePixel = 0; ShootHeader.Parent = ShootSubFrame
local ShootHeaderCorner = Instance.new("UICorner"); ShootHeaderCorner.CornerRadius = UDim.new(0, 8); ShootHeaderCorner.Parent = ShootHeader

local ShootClose = Instance.new("TextButton"); ShootClose.Size = UDim2.new(0, 20, 0, 20); ShootClose.Position = UDim2.new(0.88, 0, 0.1, 0); ShootClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50); ShootClose.Text = "X"; ShootClose.TextColor3 = Color3.fromRGB(255, 255, 255); ShootClose.TextSize = 11; ShootClose.Font = Enum.Font.SourceSansBold; ShootClose.Parent = ShootSubFrame; Instance.new("UICorner", ShootClose).CornerRadius = UDim.new(1, 0)
ShootClose.MouseButton1Click:Connect(function() ShootSubFrame.Visible = false end)

local ShootActionBtn = Instance.new("TextButton")
ShootActionBtn.Size = UDim2.new(0, 170, 0, 40)
ShootActionBtn.Position = UDim2.new(0.085, 0, 0.45, 0)
ShootActionBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ShootActionBtn.Text = "Shoot Murderer"
ShootActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShootActionBtn.TextSize = 13
ShootActionBtn.Font = Enum.Font.SourceSansBold
ShootActionBtn.Parent = ShootSubFrame
Instance.new("UICorner", ShootActionBtn).CornerRadius = UDim.new(0, 6)

local function findSheriff()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and (p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")) then
            return p
        end
    end
    return nil
end

local function findMurderer()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then
            return p
        end
    end
    return nil
end

ShootActionBtn.MouseButton1Click:Connect(function()
    if findSheriff() ~= LocalPlayer then 
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Meknoyu GUI", Text = "You're not sheriff/hero.", Duration = 3})
        return 
    end

    local murderer = findMurderer()
    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
        local murdererHRP = murderer.Character.HumanoidRootPart
        local args = {
            CFrame.new(LocalPlayer.Character.RightHand.Position),
            CFrame.new(murdererHRP.Position)
        }
        LocalPlayer.Character:WaitForChild("Gun"):WaitForChild("Shoot"):FireServer(unpack(args))
    end
end)

-- ==================================================================== -- [[ FITUR FUNCTIONS ]] -- ==================================================================== 
local function createFeatureButton(text, layoutOrder, callback) 
    local Btn = Instance.new("TextButton") Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60); Btn.Text = text; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.TextSize = 13; Btn.Font = Enum.Font.SourceSansBold; Btn.LayoutOrder = layoutOrder; Btn.Parent = ButtonContainer 
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6) Btn.MouseButton1Click:Connect(function() callback(Btn) end) return Btn 
end 

createFeatureButton("Player ESP: OFF", 1, function(btn) 
    EspEnabled = not EspEnabled 
    btn.Text = EspEnabled and "Player ESP: ON" or "Player ESP: OFF"
    btn.BackgroundColor3 = EspEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
    task.spawn(function() 
        while EspEnabled do 
            if not EspEnabled then break end
            for _, player in pairs(Players:GetPlayers()) do 
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then 
                    if not player.Character.Head:FindFirstChild("EspName") then 
                        local billboard = Instance.new("BillboardGui", player.Character.Head); billboard.Name = "EspName"; billboard.AlwaysOnTop = true; billboard.Size = UDim2.new(0, 100, 0, 25); billboard.StudsOffset = Vector3.new(0, 3, 0) 
                        local textLabel = Instance.new("TextLabel", billboard); textLabel.Size = UDim2.new(1, 0, 1, 0); textLabel.BackgroundTransparency = 1; textLabel.Font = Enum.Font.SourceSansBold; textLabel.TextSize = 12 
                    end 
                    local tag = player.Character.Head.EspName.TextLabel 
                    if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then 
                        tag.Text = "[M] "..player.Name; tag.TextColor3 = Color3.fromRGB(255, 50, 50) 
                    elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then 
                        tag.Text = "[S] "..player.Name; tag.TextColor3 = Color3.fromRGB(50, 150, 255) 
                    else 
                        tag.Text = player.Name; tag.TextColor3 = Color3.fromRGB(46, 204, 113) 
                    end 
                end 
            end 
            task.wait(1) 
        end 
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("EspName") then
                player.Character.Head.EspName:Destroy()
            end
        end
    end) 
end)

createFeatureButton("Aimbot Murderer: OFF", 2, function(btn) 
    MurdererAimbotEnabled = not MurdererAimbotEnabled 
    btn.Text = MurdererAimbotEnabled and "Aimbot Murderer: ON" or "Aimbot Murderer: OFF"
    btn.BackgroundColor3 = MurdererAimbotEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
    task.spawn(function() 
        while MurdererAimbotEnabled do 
            RunService.RenderStepped:Wait() 
            if not MurdererAimbotEnabled then break end
            if LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")) then 
                for _, p in pairs(Players:GetPlayers()) do 
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then 
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.HumanoidRootPart.Position) 
                    end 
                end 
            end 
        end 
    end) 
end)

createFeatureButton("Noclip: OFF", 3, function(btn) 
    NoclipEnabled = not NoclipEnabled 
    btn.Text = NoclipEnabled and "Noclip: ON" or "Noclip: OFF"
    btn.BackgroundColor3 = NoclipEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
end)

createFeatureButton("Speed: OFF", 4, function(btn) 
    SpeedEnabled = not SpeedEnabled 
    btn.Text = SpeedEnabled and "Speed: ON (50)" or "Speed: OFF"
    btn.BackgroundColor3 = SpeedEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
    task.spawn(function() 
        while SpeedEnabled do 
            task.wait() 
            if not SpeedEnabled then break end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
                LocalPlayer.Character.Humanoid.WalkSpeed = CustomSpeed 
            end 
        end 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
            LocalPlayer.Character.Humanoid.WalkSpeed = 16 
        end 
    end) 
end)

createFeatureButton("Rejoin Server", 5, function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)

createFeatureButton("Gun ESP: OFF", 6, function(btn) 
    GunEspEnabled = not GunEspEnabled 
    btn.Text = GunEspEnabled and "Gun ESP: ON" or "Gun ESP: OFF"
    btn.BackgroundColor3 = GunEspEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
    task.spawn(function() 
        while GunEspEnabled do 
            if not GunEspEnabled then break end
            for _, obj in pairs(Workspace:GetDescendants()) do 
                if obj.Name == "GunDrop" and obj:IsA("Part") and not obj:FindFirstChild("GunEsp") then 
                    local billboard = Instance.new("BillboardGui", obj); billboard.Name = "GunEsp"; billboard.AlwaysOnTop = true; billboard.Size = UDim2.new(0, 100, 0, 25); billboard.StudsOffset = Vector3.new(0, 2, 0) 
                    local textLabel = Instance.new("TextLabel", billboard); textLabel.Size = UDim2.new(1, 0, 1, 0); textLabel.BackgroundTransparency = 1; textLabel.Text = "⚠️ GUN DROPPED!"; textLabel.TextColor3 = Color3.fromRGB(160, 32, 240); textLabel.Font = Enum.Font.SourceSansBold; textLabel.TextSize = 12 
                end 
            end 
            task.wait(1) 
        end 
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "GunDrop" and obj:FindFirstChild("GunEsp") then
                obj.GunEsp:Destroy()
            end
        end
    end) 
end)

createFeatureButton("Aimbot Sheriff: OFF", 7, function(btn) 
    SheriffAimbotEnabled = not SheriffAimbotEnabled 
    btn.Text = SheriffAimbotEnabled and "Aimbot Sheriff: ON" or "Aimbot Sheriff: OFF"
    btn.BackgroundColor3 = SheriffAimbotEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
    task.spawn(function() 
        while SheriffAimbotEnabled do 
            RunService.RenderStepped:Wait() 
            if not SheriffAimbotEnabled then break end
            if LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")) then 
                for _, p in pairs(Players:GetPlayers()) do 
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")) then 
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.HumanoidRootPart.Position) 
                    end 
                end 
            end 
        end 
    end) 
end)

createFeatureButton("Grab Gun: OFF", 8, function(btn) 
    AutoGrabEnabled = not AutoGrabEnabled 
    btn.Text = AutoGrabEnabled and "Grab Gun: ON" or "Grab Gun: OFF"
    btn.BackgroundColor3 = AutoGrabEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
    task.spawn(function() 
        while AutoGrabEnabled do 
            task.wait(0.1) 
            if not AutoGrabEnabled then break end
            local drop = Workspace:FindFirstChild("GunDrop", true) 
            if drop and drop:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame 
                LocalPlayer.Character.HumanoidRootPart.CFrame = drop.CFrame 
                task.wait(0.2) 
                LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos 
            end 
        end 
    end) 
end)

createFeatureButton("Invisible Menu", 9, function() 
    InvisSubFrame.Visible = not InvisSubFrame.Visible 
end)

createFeatureButton("Anti Fling: OFF", 10, function(btn) 
    AntiFlingEnabled = not AntiFlingEnabled 
    btn.Text = AntiFlingEnabled and "Anti Fling: ON" or "Anti Fling: OFF"
    btn.BackgroundColor3 = AntiFlingEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
end)

-- SUBTITUSI SCRIPT BARU SAKLAR SPAWN KNIFE THROW NEAR PLAYER DI SINI
createFeatureButton("Knife Throw Near: OFF", 11, function(btn) 
    spawnAtPlayer = not spawnAtPlayer
    btn.Text = spawnAtPlayer and "Knife Throw Near: ON" or "Knife Throw Near: OFF"
    btn.BackgroundColor3 = spawnAtPlayer and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60)

    -- Eksekusi Loop Lempar Otomatis Saat Fitur Ini Aktif (ON)
    task.spawn(function()
        while spawnAtPlayer do
            RunService.Heartbeat:Wait()
            if not spawnAtPlayer then break end

            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Knife") and char:FindFirstChild("HumanoidRootPart") then
                -- Cari Pemain Terdekat (Nearest Player)
                local nearestPlayer = nil
                local shortestDistance = math.huge

                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestPlayer = player
                        end
                    end
                end

                -- Jika Pemain Terdekat Ditemukan, Eksekusi KnifeThrow
                if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local nearestHRP = nearestPlayer.Character.HumanoidRootPart

                    local argsThrowRemote = {
                        [1] = CFrame.new(char.RightHand.Position),
                        [2] = CFrame.new(nearestHRP.Position + Vector3.new(0, 1, 0)),
                    }

                    if spawnAtPlayer then
                        argsThrowRemote[1] = CFrame.new(nearestHRP.Position + (nearestHRP.CFrame.LookVector * 5))
                    end

                    local knifeInstance = char:FindFirstChild("Knife")
                    if knifeInstance and knifeInstance:FindFirstChild("Events") and knifeInstance.Events:FindFirstChild("KnifeThrown") then
                        knifeInstance.Events.KnifeThrown:FireServer(unpack(argsThrowRemote))
                        task.wait(0.3) -- Cooldown aman pelemparan
                    end
                end
            end
        end
    end)
end)

createFeatureButton("TP To Murderer: OFF", 12, function(btn) 
    FreezeTp = false
    TpToMurdererEnabled = not TpToMurdererEnabled 
    btn.Text = TpToMurdererEnabled and "TP To Murderer: ON" or "TP To Murderer: OFF"
    btn.BackgroundColor3 = TpToMurdererEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
    task.spawn(function() 
        while TpToMurdererEnabled do 
            task.wait(0.1) 
            if not TpToMurdererEnabled then break end
            for _, p in pairs(Players:GetPlayers()) do 
                if p ~= LocalPlayer and p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then 
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) 
                end 
            end 
        end 
    end) 
end)

createFeatureButton("Back Lobby", 13, function() 
    local spawnObj = Workspace:FindFirstChild("Spawn", true) or Workspace:FindFirstChild("LobbySpawn", true) 
    if spawnObj and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        LocalPlayer.Character.HumanoidRootPart.CFrame = spawnObj.CFrame + Vector3.new(0, 3, 0) 
    end 
end)

createFeatureButton("Auto Farm Coin: OFF", 14, function(btn) 
    getgenv().AutoFarmCoinEnabled = not getgenv().AutoFarmCoinEnabled 
    btn.Text = getgenv().AutoFarmCoinEnabled and "Auto Farm Coin: ON" or "Auto Farm Coin: OFF" 
    btn.BackgroundColor3 = getgenv().AutoFarmCoinEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60) 
end)

createFeatureButton("Touch Fling: OFF", 15, function(btn)
    hiddenfling = not hiddenfling
    btn.Text = hiddenfling and "Touch Fling: ON" or "Touch Fling: OFF"
    btn.BackgroundColor3 = hiddenfling and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 60)
end)

createFeatureButton("Fling Murderer", 16, function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local oldPos = hrp.CFrame
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                hiddenfling = true
                local targetHrp = p.Character.HumanoidRootPart
                local startTime = tick()
                while tick() - startTime < 1.5 do 
                    RunService.Heartbeat:Wait()
                    hrp.CFrame = targetHrp.CFrame
                end
                hiddenfling = false
                hrp.CFrame = oldPos
                break
            end
        end
    end
end)

createFeatureButton("Fling Others", 17, function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local oldPos = hrp.CFrame
    hiddenfling = true
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if not (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then
                local targetHrp = p.Character.HumanoidRootPart
                local startTime = tick()
                while tick() - startTime < 0.8 do 
                    RunService.Heartbeat:Wait()
                    hrp.CFrame = targetHrp.CFrame
                end
            end
        end
    end
    hiddenfling = false
    hrp.CFrame = oldPos
end)

createFeatureButton("Shoot Murder", 18, function() 
    ShootSubFrame.Visible = not ShootSubFrame.Visible 
end)

-- ==================================================================== 
-- [[ CORE LOOPS ]] 
-- ==================================================================== 

-- Auto Farm Coin Loop (NO COOLDOWN + ANTI VOID + ANTI POSITION INVALID)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if getgenv().AutoFarmCoinEnabled then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart

                -- Anti Void Protection
                if hrp.Position.Y < -50 then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    local spawnObj = Workspace:FindFirstChild("Spawn", true) or Workspace:FindFirstChild("LobbySpawn", true)
                    if spawnObj then hrp.CFrame = spawnObj.CFrame + Vector3.new(0, 5, 0) end
                end

                for _, obj in pairs(Workspace:GetDescendants()) do
                    if not getgenv().AutoFarmCoinEnabled then 
                        hrp.Velocity = Vector3.new(0,0,0)
                        break 
                    end
                    if obj.Name == "Coin_Server" and obj:IsA("BasePart") then
                        local targetPos = obj.Position

                        while (hrp.Position - targetPos).Magnitude > 2 and getgenv().AutoFarmCoinEnabled do
                            RunService.Heartbeat:Wait()

                            local direction = (targetPos - hrp.Position).Unit
                            local distance = (targetPos - hrp.Position).Magnitude
                            local speedStep = math.min(distance, 55)

                            hrp.Velocity = direction * speedStep
                            hrp.CFrame = CFrame.new(hrp.Position + (direction * (speedStep * 0.1)), targetPos)
                        end
                    end
                end
            end
        end
    end
end)

-- Hidden Fling Logic
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if hiddenfling then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.Velocity
                hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                hrp.Velocity = vel
                RunService.Stepped:Wait()
                hrp.Velocity = vel + Vector3.new(0, movel, 0)
                movel = -movel
            end
        end
    end
end)

-- Stepped Noclip & Anti-Fling
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Noclip
                if hiddenfling or getgenv().AutoFarmCoinEnabled or NoclipEnabled then
                    part.CanCollide = false
                end
                -- Anti Fling Safe Mode (Mencegah Velocity meledak tanpa membuatnya kaku/0)
                if AntiFlingEnabled then
                    if part.RotVelocity.Magnitude > 75 then
                        part.RotVelocity = part.RotVelocity.Unit * 10
                    end
                    if part.Velocity.Magnitude > 150 then
                        part.Velocity = part.Velocity.Unit * 30
                    end
                end
            end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Meknoyu GUI", Text = "System Restored", Duration = 4})