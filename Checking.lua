-- [[ MEKNOYU GUI | MURNI UI LAYOUT ]] --

if game:GetService("CoreGui"):FindFirstChild("MeknoyuExplorerCheckUI") then
    game:GetService("CoreGui").MeknoyuExplorerCheckUI:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuExplorerCheckUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

local selectedPath = "" -- Variable penampung path yang diklik untuk di-copy

-- ==========================================
-- MAIN GUI STRUCTURE (MAIN FRAME)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 310)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -155)
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
headerTitle.Text = "Meknoyu GUI | ExplorerCheck"
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

-- ==========================================
-- KOTAKAN BESAR LOGS (SCROLLING FRAME)
-- ==========================================
local logsFrame = Instance.new("ScrollingFrame", mainFrame)
logsFrame.Name = "LogsFrame"
logsFrame.Size = UDim2.new(1, -20, 1, -100)
logsFrame.Position = UDim2.new(0, 10, 0, 45)
logsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
logsFrame.BorderSizePixel = 0
logsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
logsFrame.ScrollBarThickness = 6
Instance.new("UICorner", logsFrame).CornerRadius = UDim.new(0, 6)

local listLayout = Instance.new("UIListLayout", logsFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)

-- Auto scroll ke bawah jika ada log baru
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    logsFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- UI Text Notifikasi / Status Bar
local notifLabel = Instance.new("TextLabel", mainFrame)
notifLabel.Name = "NotifLabel"
notifLabel.Size = UDim2.new(1, -20, 0, 25)
notifLabel.Position = UDim2.new(0, 10, 1, -30)
notifLabel.BackgroundTransparency = 1
notifLabel.Text = "Logs Ready. Touch or click any UI/Objects to log path."
notifLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
notifLabel.Font = Enum.Font.GothamSemibold
notifLabel.TextSize = 11
notifLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ==========================================
-- BUTTON CONTAINER (COPY CODE & CLR LOGS)
-- ==========================================
local btnContainer = Instance.new("Frame", mainFrame)
btnContainer.Size = UDim2.new(1, -20, 0, 30)
btnContainer.Position = UDim2.new(0, 10, 1, -65)
btnContainer.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout", btnContainer)
gridLayout.CellSize = UDim2.new(0.49, 0, 1, 0)
gridLayout.CellPadding = UDim2.new(0, 8, 0, 0)

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
-- MEMBUAT CONTROL BUTTONS (COPY & CLEAR)
-- ==========================================
local function createControlButton(name, callback)
    local btn = Instance.new("TextButton", btnContainer)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- Tombol Copy Code
createControlButton("Copy Code", function()
    if selectedPath ~= "" then
        if setclipboard then
            setclipboard(selectedPath)
            notifLabel.Text = "Code Copied to Clipboard!"
            notifLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            notifLabel.Text = "Executor doesn't support setclipboard!"
            notifLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    else
        notifLabel.Text = "Please select a log line first!"
        notifLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
    end
end)

-- Tombol Clear Logs
createControlButton("Clr Logs", function()
    logsFrame:ClearAllChildren()
    listLayout = Instance.new("UIListLayout", logsFrame)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    selectedPath = ""
    notifLabel.Text = "Logs cleared successfully."
    notifLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
end)


-- ==========================================
-- LOGIKA CORE DETEKSI & BACKGROUND INJECTOR
-- ==========================================

local loggedPaths = {}
local totalLogsCount = 0

-- MENGUBAH FORMAT PATH MENJADI (ClassName = Name.ClassName = Name)
local function getFullPath(instance)
    local parts = {}
    local current = instance
    
    while current and current ~= game do
        table.insert(parts, 1, current.ClassName .. " = " .. current.Name)
        current = current.Parent
    end
    
    return table.concat(parts, ".")
end

local function addLog(instanceObj, eventType)
    if not instanceObj or not instanceObj.Parent then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and (instanceObj:IsDescendantOf(p.Character) or instanceObj == p.Character) then
            return
        end
    end
    
    local fullPath = getFullPath(instanceObj)
    if loggedPaths[fullPath] then return end
    loggedPaths[fullPath] = true

    totalLogsCount = totalLogsCount + 1

    local logBtn = Instance.new("TextButton", logsFrame)
    logBtn.Size = UDim2.new(1, -10, 0, 25)
    logBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    
    -- Menampilkan format modifikasi baru di dalam kotak log
    logBtn.Text = " [" .. eventType .. "] " .. fullPath
    
    logBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    logBtn.Font = Enum.Font.Code
    logBtn.TextSize = 10
    logBtn.TextXAlignment = Enum.TextXAlignment.Left
    logBtn.LayoutOrder = -totalLogsCount
    Instance.new("UICorner", logBtn).CornerRadius = UDim.new(0, 4)

    logBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(logsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
                child.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        logBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        logBtn.TextColor3 = Color3.fromRGB(255, 255, 100)
        
        selectedPath = fullPath
        notifLabel.Text = "Selected! Click 'Copy Code' to copy path."
        notifLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
end

-- Deteksi Touch
local lastTouchTime = 0
local function onCharTouched(hit)
    local now = os.clock()
    if now - lastTouchTime < 0.1 then return end 
    
    if hit and hit:IsA("BasePart") and hit.Parent then
        if hit.Parent:FindFirstChild("Humanoid") or hit.Parent.Parent:FindFirstChild("Humanoid") then return end
        if hit.Name == "Baseplate" or hit.Name == "Terrain" then return end
        
        lastTouchTime = now
        addLog(hit, "TOUCH")
    end
end

local function setupTouchDetection()
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Touched:Connect(onCharTouched)
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    setupTouchDetection()
end)
task.spawn(setupTouchDetection)

-- Deteksi UI Click
local function trackGui(gui)
    if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and not gui:IsDescendantOf(screenGui) then
        if gui:IsDescendantOf(LocalPlayer:WaitForChild("PlayerGui")) or not gui:FindFirstAncestorOfClass("PlayerGui") then
            gui.MouseButton1Click:Connect(function()
                addLog(gui, "UI_CLICK")
            end)
        end
    end
end

LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(trackGui)
for _, desc in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
    trackGui(desc)
end

-- Hook Remotes
local function hookRemote(remote, eventType)
    if remote:IsA("RemoteEvent") then
        local oldFire = remote.FireServer
        remote.FireServer = function(self, ...)
            task.spawn(addLog, self, eventType)
            return oldFire(self, ...)
        end
    elseif remote:IsA("RemoteFunction") then
        local oldInvoke = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            task.spawn(addLog, self, eventType)
            return oldInvoke(self, ...)
        end
    end
end

for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        hookRemote(obj, "REMOTE")
    end
end

game.DescendantAdded:Connect(function(obj)
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        hookRemote(obj, "REMOTE")
    end
end)

-- Deteksi Proximity Prompt
local function trackPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.Triggered:Connect(function(player)
            if player == LocalPlayer then
                addLog(prompt, "PROMPT_TRIGGER")
            end
        end)
        prompt.PromptShown:Connect(function()
            addLog(prompt, "PROMPT_SHOWN")
        end)
    end
end

for _, obj in pairs(workspace:GetDescendants()) do
    trackPrompt(obj)
end
workspace.DescendantAdded:Connect(trackPrompt)
