local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")

local states = {AutoHarvest = false, AutoStealNight = false, AntiAfk = false, AntiLag = false}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Meknoyu_GAG2_Gui"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 350, 0, 220)
main.Position = UDim2.new(0.5, -175, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2.5
rs.RenderStepped:Connect(function() 
    stroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1) 
end)

local function makeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(main, main)

local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, -45, 0, 40)
header.Position = UDim2.new(0, 15, 0, 5)
header.Text = "Meknoyu GUI | GAG2"
header.BackgroundTransparency = 1
header.TextColor3 = Color3.new(1, 1, 1)
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn)

local miniBtn = Instance.new("TextButton", screenGui)
miniBtn.Size = UDim2.new(0, 55, 0, 55)
miniBtn.Position = UDim2.new(0.9, 0, 0.1, 0)
miniBtn.Text = "MEKNO"
miniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 11
miniBtn.Visible = false
local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(1, 0)
local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Thickness = 2
rs.RenderStepped:Connect(function() 
    miniStroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1) 
end)
makeDraggable(miniBtn, miniBtn)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    miniBtn.Visible = false
end)

local buttonContainer = Instance.new("ScrollingFrame", main)
buttonContainer.Size = UDim2.new(1, -20, 1, -55)
buttonContainer.Position = UDim2.new(0, 10, 0, 45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ScrollBarThickness = 2
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
buttonContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local grid = Instance.new("UIGridLayout", buttonContainer)
grid.CellSize = UDim2.new(0.48, 0, 0, 40)
grid.CellPadding = UDim2.new(0, 10, 0, 10)

local function createToggleBtn(name, key, funcOn, funcOff)
    local b = Instance.new("TextButton", buttonContainer)
    b.Text = name .. " : OFF"
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        b.Text = name .. " : " .. (states[key] and "ON" or "OFF")
        b.BackgroundColor3 = states[key] and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(30, 30, 35)
        if states[key] then
            task.spawn(funcOn)
        else
            if funcOff then task.spawn(funcOff) end
        end
    end)
    return b
end

local function isInventoryFull()
    local full = false
    pcall(function()
        local backpackGui = plr.PlayerGui:FindFirstChild("BackpackGui") or plr.PlayerGui:FindFirstChild("Backpack")
        if backpackGui then
            for _, v in pairs(backpackGui:GetDescendants()) do
                if v:IsA("TextLabel") then
                    if string.find(v.Text, "Max") or string.find(v.Text, "FULL") then
                        full = true
                        break
                    end
                    local current, max = string.match(v.Text, "(%d+)%s*/%s*(%d+)")
                    if current and max and tonumber(current) >= tonumber(max) then
                        full = true
                        break
                    end
                end
            end
        end
    end)
    return full
end

local runHarvest = function()
    _G.AuraHarvest = true
    local AURA_RADIUS = 9999999
    while states.AutoHarvest and _G.AuraHarvest do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local isFull = isInventoryFull()
        if not isFull and hrp then
            for _, objek in pairs(workspace:GetDescendants()) do
                if objek:IsA("ProximityPrompt") then
                    if objek.Name == "HarvestPrompt" then
                        local parentObjek = objek.Parent
                        if parentObjek and parentObjek:IsA("BasePart") then
                            local distance = (hrp.Position - parentObjek.Position).Magnitude
                            if distance <= AURA_RADIUS then
                                fireproximityprompt(objek)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.3)
    end
end

local stopHarvest = function()
    _G.AuraHarvest = false
end

local runSteal = function()
    _G.AutoStealNight = true
    local AURA_RADIUS = 9999999
    while states.AutoStealNight and _G.AutoStealNight do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local isNight = false
            if lighting.ClockTime <= 5 or lighting.ClockTime >= 19 or workspace:FindFirstChild("Awan") or workspace:FindFirstChild("NightCloud") then
                isNight = true
            end
            if isNight then
                pcall(function()
                    for _, objek in pairs(workspace:GetDescendants()) do
                        if objek:IsA("ProximityPrompt") and objek.Name == "StealPrompt" then
                            local targetPart = objek.Parent
                            if targetPart and targetPart:IsA("BasePart") then
                                if not string.find(targetPart.Parent.Name, plr.Name) then
                                    local distance = (hrp.Position - targetPart.Position).Magnitude
                                    if distance <= AURA_RADIUS then
                                        hrp.CFrame = targetPart.CFrame * CFrame.new(0, 2, 0)
                                        task.wait(0.05)
                                        fireproximityprompt(objek)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
        task.wait(0.1)
    end
end

local stopSteal = function()
    _G.AutoStealNight = false
end

local runAntiAfk = function()
    local vu = game:GetService("VirtualUser")
    pcall(function()
        plr.Idled:Connect(function()
            if states.AntiAfk then
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end)
    end)
end

local runAntiLag = function()
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if states.AntiLag then
                if v:IsA("BasePart") and not v:IsDescendantOf(plr.Character) then
                    v.Material = Enum.Material.SmoothPlastic
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end
    end)
end

createToggleBtn("Auto Harvest", "AutoHarvest", runHarvest, stopHarvest)
createToggleBtn("Auto Steal", "AutoStealNight", runSteal, stopSteal)
createToggleBtn("Anti Afk", "AntiAfk", runAntiAfk)
createToggleBtn("Anti Lag", "AntiLag", runAntiLag)

starterGui:SetCore("SendNotification", { Title = "Meknoyu GUI", Text = "GAG2 Fully Loaded!", Duration = 5 })