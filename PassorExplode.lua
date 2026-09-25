local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")

-- [[ State Flags ]] --
local states = {
    AutoGetWin = false,
    InfJump = false,
    CustomSpeed = false
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Meknoyu_PoE_Gui"
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
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
header.Text = "Meknoyu GUI | Pass or Explode"
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

-- [[ IMPLEMENTASI FITUR ]] --

-- Auto Get Win (Teleport WinPart + Cooldown 300 Detik)
local runAutoGetWin = function()
    while states.AutoGetWin do
        pcall(function()
            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            local winPart = nil
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "WinPart" then
                    winPart = v
                    break
                end
            end
            
            if root and winPart then
                local savedPos = root.CFrame
                
                -- Teleport ke WinPart
                root.CFrame = winPart.CFrame * CFrame.new(0, 2, 0)
                task.wait(0.3)
                
                -- Teleport balik ke posisi semula
                root.CFrame = savedPos
                
                -- Jeda Cooldown selama 300 detik
                task.wait(300)
            end
        end)
        task.wait(0.5)
    end
end

-- Infinite Jump
local jumpConnection
local runInfJump = function()
    jumpConnection = UIS.JumpRequest:Connect(function()
        if states.InfJump then
            pcall(function()
                local char = plr.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end)
end

local stopInfJump = function()
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
end

-- Speed 100
local runSpeed = function()
    while states.CustomSpeed do
        pcall(function()
            local char = plr.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= 100 then
                humanoid.WalkSpeed = 100
            end
        end)
        task.wait(0.1)
    end
end

local stopSpeed = function()
    pcall(function()
        local char = plr.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end)
end

-- [[ Daftarkan Fungsi Ke Tombol GUI ]] --
createToggleBtn("Auto Get Win", "AutoGetWin", runAutoGetWin)
createToggleBtn("Inf Jump", "InfJump", runInfJump, stopInfJump)
createToggleBtn("Speed 100", "CustomSpeed", runSpeed, stopSpeed)

starterGui:SetCore("SendNotification", { Title = "Meknoyu GUI", Text = "Pass or Explode Loaded!", Duration = 5 })
