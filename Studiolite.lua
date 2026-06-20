-- [[ MEKNOYU GUI | STUDIO LITE - FIXED V13 ]] --
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local rs = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- // SCREEN GUI UTAMA //
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Meknoyu_Studio_Lite"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

-- // VARIABEL CONTROL STUDIO //
local targetPart = nil
local currentMode = "Select" 
local isDraggingHandle = false
local moveSpeed = 1 

-- // MEMBUAT SELECTION BOX (OUTLINE BIRU MENTAH) //
local selectionBox = Instance.new("SelectionBox")
selectionBox.Color3 = Color3.fromRGB(0, 0, 255) 
selectionBox.LineThickness = 0.05
selectionBox.Adornee = nil
selectionBox.Parent = screenGui

-- // MEMBUAT HANDLES (PANAH TIGA WARNA) //
local studioHandles = Instance.new("Handles")
local camera = workspace.CurrentCamera
studioHandles.Style = Enum.HandlesStyle.Movement
studioHandles.Visible = false
studioHandles.Adornee = nil
studioHandles.Parent = screenGui

-- ==========================================
--    SCRIPT KHUSUS DRAGGABLE (BISA GESIS)
-- ==========================================
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
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
    
    frame.InputChanged:Connect(function(input)
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

-- // MAIN FRAME GUI //
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 230, 0, 310) -- Ukuran disesuaikan karena menghapus panel script box dan menggantinya dengan tombol ringkas
main.Position = UDim2.new(0.5, -115, 0.5, -155)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
makeDraggable(main)

-- UI Stroke dengan efek Rainbow/RGB
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
rs.RenderStepped:Connect(function() 
    stroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1) 
end)

-- Header Title
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, -40, 0, 35)
header.Position = UDim2.new(0, 10, 0, 0)
header.Text = "Meknoyu GUI | Studio Lite"
header.BackgroundTransparency = 1
header.TextColor3 = Color3.new(1, 1, 1)
header.Font = Enum.Font.GothamBold
header.TextSize = 13
header.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close (X)
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", closeBtn)

-- Tombol Mini Bulat (MEKNO)
local miniBtn = Instance.new("TextButton", screenGui)
miniBtn.Size = UDim2.new(0, 55, 0, 55)
miniBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
miniBtn.Text = "MEKNO"
miniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 10
miniBtn.Visible = false
local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(1, 0)
makeDraggable(miniBtn)

local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Thickness = 2
rs.RenderStepped:Connect(function() 
    miniStroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1) 
end)

-- Fungsi Buka Tutup GUI Utama
closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    miniBtn.Visible = false
end)

-- ========================================================
--                      SCROLLING CONTAINER
-- ========================================================
local scrollContainer = Instance.new("ScrollingFrame", main)
scrollContainer.Size = UDim2.new(1, -10, 1, -45)
scrollContainer.Position = UDim2.new(0, 5, 0, 40)
scrollContainer.BackgroundTransparency = 1
scrollContainer.ScrollBarThickness = 5
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 310)
scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

local layout = Instance.new("UIListLayout", scrollContainer)
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Fungsi Membuat Tombol Fitur
local buttons = {}
local function createStudioBtn(name)
    local btn = Instance.new("TextButton", scrollContainer)
    btn.Size = UDim2.new(0, 200, 0, 32)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    Instance.new("UICorner", btn)
    
    if name == "SELECT" then
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
    
    buttons[name] = btn
    return btn
end

local btnSelect = createStudioBtn("SELECT")
local btnMove = createStudioBtn("MOVE")
local btnScale = createStudioBtn("SCALE")
local btnRotate = createStudioBtn("ROTATION")

-- ==========================================
--        TOMBOL COPY & DELETE
-- ==========================================
local actionRow = Instance.new("Frame", scrollContainer)
actionRow.Size = UDim2.new(0, 200, 0, 32)
actionRow.BackgroundTransparency = 1

local btnCopy = Instance.new("TextButton", actionRow)
btnCopy.Size = UDim2.new(0, 97, 0, 32)
btnCopy.Text = "COPY"
btnCopy.Font = Enum.Font.GothamBold
btnCopy.TextSize = 11
btnCopy.BackgroundColor3 = Color3.fromRGB(45, 75, 95)
btnCopy.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", btnCopy)

local btnDelete = Instance.new("TextButton", actionRow)
btnDelete.Size = UDim2.new(0, 97, 0, 32)
btnDelete.Position = UDim2.new(1, -97, 0, 0)
btnDelete.Text = "DELETE"
btnDelete.Font = Enum.Font.GothamBold
btnDelete.TextSize = 11
btnDelete.BackgroundColor3 = Color3.fromRGB(110, 35, 35)
btnDelete.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", btnDelete)

btnCopy.MouseButton1Click:Connect(function()
    if targetPart and targetPart:IsA("BasePart") then
        local copyPart = targetPart:Clone()
        copyPart.Parent = targetPart.Parent
        targetPart = copyPart
        selectionBox.Adornee = targetPart
        studioHandles.Adornee = targetPart
    end
end)

btnDelete.MouseButton1Click:Connect(function()
    if targetPart then
        targetPart:Destroy()
        targetPart = nil
        selectionBox.Adornee = nil
        studioHandles.Adornee = nil
        studioHandles.Visible = false
    end
end)

-- // PANEL INPUT MOVE SPEED (WARNA HITAM PEKAT) //
local speedFrame = Instance.new("Frame", scrollContainer)
speedFrame.Size = UDim2.new(0, 200, 0, 32)
speedFrame.BackgroundTransparency = 1

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0.5, 0, 1, 0)
speedLabel.Text = "Move Speed:"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", speedFrame)
speedInput.Size = UDim2.new(0.5, 0, 1, 0)
speedInput.Position = UDim2.new(0.5, 0, 0, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Text = "1"
speedInput.Font = Enum.Font.Code
speedInput.TextSize = 11
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 5)

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then moveSpeed = val else speedInput.Text = tostring(moveSpeed) end
end)

-- ========================================================
--              NEW FITUR: TOMBOL ADD PART
-- ========================================================
local btnAddPart = Instance.new("TextButton", scrollContainer)
btnAddPart.Size = UDim2.new(0, 200, 0, 32)
btnAddPart.Text = "ADD PART"
btnAddPart.Font = Enum.Font.GothamBold
btnAddPart.TextSize = 11
btnAddPart.BackgroundColor3 = Color3.fromRGB(35, 65, 35)
btnAddPart.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", btnAddPart)

-- Logika Pembuatan Part Baru saat tombol diklik
btnAddPart.MouseButton1Click:Connect(function()
    local newPart = Instance.new("Part")
    newPart.Name = "Studio_Part"
    newPart.Size = Vector3.new(4, 4, 4)
    newPart.Material = Enum.Material.SmoothPlastic
    newPart.Color = Color3.fromRGB(163, 162, 165)
    newPart.Anchored = true
    newPart.CanCollide = true
    
    -- Memunculkan part tepat di depan posisi kamera player
    newPart.CFrame = camera.CFrame * CFrame.new(0, 0, -10)
    newPart.Parent = workspace
    
    -- Otomatis memilih part baru tersebut sebagai target edit
    targetPart = newPart
    selectionBox.Adornee = targetPart
    studioHandles.Adornee = targetPart
    
    btnAddPart.Text = "PART ADDED ✔"
    task.wait(1)
    btnAddPart.Text = "ADD PART"
end)

-- Fungsi Mengubah Mode Aktif
local function setMode(mode)
    currentMode = mode
    for name, btn in pairs(buttons) do
        if name == mode:upper() then
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
    
    if targetPart then
        if currentMode == "Select" then
            studioHandles.Visible = false
        elseif currentMode == "Move" then
            studioHandles.Style = Enum.HandlesStyle.Movement
            studioHandles.Visible = true
        elseif currentMode == "Scale" then
            studioHandles.Style = Enum.HandlesStyle.Resize
            studioHandles.Visible = true
        elseif currentMode == "Rotation" then
            studioHandles.Style = Enum.HandlesStyle.Movement
            studioHandles.Visible = true
        end
    end
end

btnSelect.MouseButton1Click:Connect(function() setMode("Select") end)
btnMove.MouseButton1Click:Connect(function() setMode("Move") end)
btnScale.MouseButton1Click:Connect(function() setMode("Scale") end)
btnRotate.MouseButton1Click:Connect(function() setMode("Rotation") end)

-- // SINKRONISASI KLIK OBJEK & KLIK GUI //
mouse.Button1Down:Connect(function()
    local guisAtPos = plr:WaitForChild("PlayerGui"):GetGuiObjectsAtPosition(mouse.X, mouse.Y)
    for _, guiObj in pairs(guisAtPos) do
        if guiObj:IsDescendantOf(screenGui) then return end
    end
    if isDraggingHandle then return end 
    
    local target = mouse.Target
    if target and target:IsA("BasePart") and not target:IsDescendantOf(plr.Character) and target ~= workspace.Terrain then
        targetPart = target
        selectionBox.Adornee = targetPart
        studioHandles.Adornee = targetPart
        setMode(currentMode)
    else
        targetPart = nil
        selectionBox.Adornee = nil
        studioHandles.Adornee = nil
        studioHandles.Visible = false
    end
end)

-- ========================================================
--                LOCK CAMERA & CHARACTER
-- ========================================================
local startCFrame
local startSize

local function setControlsLocked(lock)
    isDraggingHandle = lock
    if lock then
        camera.CameraType = Enum.CameraType.Scriptable 
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0,0,0) end 
    else
        camera.CameraType = Enum.CameraType.Custom 
    end
end

studioHandles.MouseButton1Down:Connect(function()
    if targetPart then
        startCFrame = targetPart.CFrame
        startSize = targetPart.Size
        setControlsLocked(true)
    end
end)

studioHandles.MouseButton1Up:Connect(function()
    setControlsLocked(false)
end)

-- // MANIPULASI ARAH PANAH DAN OPERASI ROTATION/MOVE/SCALE //
studioHandles.MouseDrag:Connect(function(face, distance)
    if not targetPart or not startCFrame then return end
    
    local dir = Vector3.FromNormalId(face)
    local worldDir = startCFrame.Rotation * dir
    
    if currentMode == "Move" then
        local calculatedDistance = math.round(distance / moveSpeed) * moveSpeed
        targetPart.CFrame = startCFrame + (worldDir * calculatedDistance)
    elseif currentMode == "Scale" then
        local newSize = startSize + (dir * distance)
        if newSize.X > 0.05 and newSize.Y > 0.05 and newSize.Z > 0.05 then
            targetPart.Size = newSize
            local posOffset = worldDir * (distance / 2)
            targetPart.CFrame = startCFrame + posOffset
        end
    elseif currentMode == "Rotation" then
        local degrees = math.round(distance * 5 / moveSpeed) * moveSpeed
        targetPart.CFrame = startCFrame * CFrame.fromAxisAngle(dir, math.rad(degrees))
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isDraggingHandle then setControlsLocked(false) end
    end
end)
