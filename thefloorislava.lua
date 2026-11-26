-- [[ THE FLOOR IS LAVA - ULTIMATE GUI ]] --
local plr = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")

local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid", 10)
local hrp = char:WaitForChild("HumanoidRootPart", 10)

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = newChar:WaitForChild("Humanoid", 10)
    hrp = newChar:WaitForChild("HumanoidRootPart", 10)
end)

-- // SCREEN GUI UTAMA //
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloorIsLavaGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

-- // NOTIFIKASI SISTEM //
local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "The Floor Is Lava",
            Text = text,
            Duration = 3
        })
    end)
end

-- // MAIN FRAME //
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 480, 0, 320)
main.Position = UDim2.new(0.5, -240, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 100, 0)

-- // HEADER TITLE //
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -50, 0, 35)
title.Position = UDim2.new(0, 15, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🔥 The Floor Is Lava Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- // SCROLL CONTAINER UNTUK TOMBOL //
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -55)
scroll.Position = UDim2.new(0, 10, 0, 45)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 480)

local grid = Instance.new("UIGridLayout", scroll)
grid.CellSize = UDim2.new(0.48, 0, 0, 40)
grid.CellPadding = UDim2.new(0, 8, 0, 8)
grid.SortOrder = Enum.SortOrder.LayoutOrder

-- // STATE FITUR //
local states = {
    autoFarm = false,
    autoBuyGear = false,
    autoParkour = false,
    infJump = false,
    speed = false,
    esp = false,
    antiTeleport = false
}

local lastPos = nil

-- // TOMBOL UTILITY CREATOR //
local function createButton(name, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextWrapped = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. ": " .. (active and "ON" or "OFF")
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(55, 55, 65)
        callback(active, btn)
    end)
    return btn
end

-- // 1. AUTO FARM (TouchInterest bernama "coin" dengan range 1000000) //
createButton("Auto Farm Coin", function(state)
    states.autoFarm = state
    task.spawn(function()
        while states.autoFarm do
            task.wait(0.2)
            pcall(function()
                if hrp then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("coin") and obj:IsA("BasePart") then
                            if (obj.Position - hrp.Position).Magnitude < 1000000 then
                                firetouchinterest(hrp, obj, 0)
                                firetouchinterest(hrp, obj, 1)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- // 2. AUTO BUY GEAR (ScreenGui.MainFrame.Gears.Preview.Equip) //
createButton("Auto Buy Gear", function(state)
    states.autoBuyGear = state
    task.spawn(function()
        while states.autoBuyGear do
            task.wait(1)
            pcall(function()
                local equipBtn = plr.PlayerGui:FindFirstChild("MainFrame", true)
                if equipBtn then
                    equipBtn = equipBtn:FindFirstChild("Gears", true)
                    if equipBtn then
                        equipBtn = equipBtn:FindFirstChild("Preview", true)
                        if equipBtn then
                            equipBtn = equipBtn:FindFirstChild("Equip", true)
                            if equipBtn and (equipBtn:IsA("TextButton") or equipBtn:IsA("ImageButton")) then
                                for _, connection in pairs(getconnections(equipBtn.MouseButton1Click)) do
                                    connection:Fire()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- // 3. AUTO COMPLETE PARKOUR (Workspace.Obby1.Head pake touchinterest) //
createButton("Auto Parkour", function(state)
    states.autoParkour = state
    task.spawn(function()
        while states.autoParkour do
            task.wait(0.5)
            pcall(function()
                if hrp then
                    local obbyHead = workspace:FindFirstChild("Obby1") and workspace.Obby1:FindFirstChild("Head")
                    if obbyHead and obbyHead:IsA("BasePart") then
                        firetouchinterest(hrp, obbyHead, 0)
                        firetouchinterest(hrp, obbyHead, 1)
                    end
                end
            end)
        end
    end)
end)

-- // 4. INF JUMP //
createButton("Inf Jump", function(state)
    states.infJump = state
end)

UIS.JumpRequest:Connect(function()
    if states.infJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- // 5. SPEED BOOST //
createButton("Speed Boost", function(state)
    states.speed = state
    task.spawn(function()
        while states.speed do
            task.wait(0.1)
            pcall(function()
                if hum then hum.WalkSpeed = 30 end
            end)
        end
        if hum then hum.WalkSpeed = 16 end
    end)
end)

-- // 6. ESP (Highlight Player / Item) //
createButton("ESP Player", function(state)
    states.esp = state
    task.spawn(function()
        while states.esp do
            task.wait(1)
            pcall(function()
                for _, p in pairs(players:GetPlayers()) do
                    if p ~= plr and p.Character and not p.Character:FindFirstChild("MeknoHighlight") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "MeknoHighlight"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.Parent = p.Character
                    end
                end
            end)
        end
        if not states.esp then
            for _, p in pairs(players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("MeknoHighlight") then
                    p.Character.MeknoHighlight:Destroy()
                end
            end
        end
    end)
end)

-- // 7. ANTI TELEPORT + DETEKSI VOID //
createButton("Anti Teleport", function(state)
    states.antiTeleport = state
end)

rs.RenderStepped:Connect(function()
    if hrp then
        if hrp.Position.Y < -5 then
            lastPos = nil
        end
        if states.antiTeleport then
            local dist = lastPos and (hrp.Position - lastPos.Position).Magnitude or 0
            if dist > 50 and lastPos.Y >= -5 then
                hrp.CFrame = lastPos
                hrp.AssemblyLinearVelocity = Vector3.zero
            else
                if hrp.Position.Y >= -5 then
                    lastPos = hrp.CFrame
                end
            end
        else
            if hrp.Position.Y >= -5 then
                lastPos = hrp.CFrame
            end
        end
    end
end)

-- // 8. TELEPORT LOBBY (Workspace.MainLobby.Floor.Part) //
local tpLobbyBtn = Instance.new("TextButton", scroll)
tpLobbyBtn.Text = "Teleport Lobby"
tpLobbyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
tpLobbyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpLobbyBtn.Font = Enum.Font.GothamBold
tpLobbyBtn.TextSize = 11
Instance.new("UICorner", tpLobbyBtn).CornerRadius = UDim.new(0, 6)

tpLobbyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local lobbyObj = workspace.MainLobby.Floor.Part
        if lobbyObj and lobbyObj:IsA("BasePart") then
            hrp.CFrame = lobbyObj.CFrame + Vector3.new(0, 5, 0)
            notify("Berpindah ke Workspace.MainLobby.Floor.Part!")
            return
        end
        notify("Workspace.MainLobby.Floor.Part tidak ditemukan.")
    end)
end)

-- // 9. TELEPORT MAP (MainBase) //
local tpMapBtn = Instance.new("TextButton", scroll)
tpMapBtn.Text = "Teleport ke Map"
tpMapBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
tpMapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpMapBtn.Font = Enum.Font.GothamBold
tpMapBtn.TextSize = 11
Instance.new("UICorner", tpMapBtn).CornerRadius = UDim.new(0, 6)

tpMapBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local baseObj = workspace:FindFirstChild("MainBase", true)
        if baseObj and baseObj:IsA("BasePart") then
            hrp.CFrame = baseObj.CFrame + Vector3.new(0, 5, 0)
            notify("Berpindah ke MainBase!")
            return
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("mainbase") and obj:IsA("BasePart") then
                hrp.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                notify("Berpindah ke MainBase!")
                return
            end
        end
        notify("MainBase aktif tidak ditemukan.")
    end)
end)

-- // TOMBOL TUTUP / BUKA GUI DENGAN KEYBOARD (Tombol 'E') //
closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    notify("GUI disembunyikan. Tekan tombol E untuk membuka kembali.")
end)

UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.E then
        main.Visible = not main.Visible
    end
end)

notify("GUI The Floor Is Lava berhasil dimuat!")
