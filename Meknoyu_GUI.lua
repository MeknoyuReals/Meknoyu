-- [[ MEKNOYU GUI (LOCKED & PROTECTED) - UPDATED WITH FIX FOR TITLE & ANTI FLING ]] --
local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local mps = game:GetService("MarketplaceService")
local lighting = game:GetService("Lighting")
local guiService = game:GetService("GuiService")
local cam = workspace.CurrentCamera
local mouse = plr:GetMouse()

-- States
local states = {god=false, noclip=false, esp=false, fling=false, antifling=false, infJump=false, speed=false, fps=false, title=false, antirag=false, antijail=false, bypassac=false, tooltp=false, antitel=false, aimbot=false, aimActive=false, antirobux=false, savepos=false, disco=false, hcxxr=false, addpart=false, xray=false, tpKill=false, antiafk=false, invis=false}
local originalTransparencies = {}
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid", 10)
local hrp = char:WaitForChild("HumanoidRootPart", 10)
local godConnection, lastPos, savedPos = nil, nil, nil
local platformPart = nil

-- Block Deteksi Zona & Objek Anticheat
workspace.DescendantAdded:Connect(function(v)
    if states.bypassac and (v.Name:lower():find("anticheat") or v.Name:lower():find("detector") or v.Name:lower():find("cheat")) then
        pcall(function()
            if v:IsA("BasePart") then v.CanTouch = false; v.CanQuery = false; v.CanCollide = false
            elseif v:IsA("Script") or v:IsA("LocalScript") then v.Disabled = true end
        end)
    end
end)

starterGui:SetCore("SendNotification", { Title = "Meknoyu GUI", Text = "System Fully Loaded!", Duration = 5 })

-- // SCREEN GUI //
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mekno_Clean_Final"; screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

--// LANGIT MEKNOYU TEAMS //--
local discoSky = Instance.new("Sky")
discoSky.Name = "MeknoDiscoSky"
discoSky.SkyboxBk = "http://www.roblox.com/asset/?id=10134830810"
discoSky.SkyboxDn = "http://www.roblox.com/asset/?id=10134830810"
discoSky.SkyboxFt = "http://www.roblox.com/asset/?id=10134830810"
discoSky.SkyboxLf = "http://www.roblox.com/asset/?id=10134830810"
discoSky.SkyboxRt = "http://www.roblox.com/asset/?id=10134830810"
discoSky.SkyboxUp = "http://www.roblox.com/asset/?id=10134830810"

local skyGui = Instance.new("ScreenGui", screenGui)
skyGui.Name = "MeknoSkyTitle"
local skyText = Instance.new("TextLabel", skyGui)
skyText.Size = UDim2.new(1, 0, 0, 100)
skyText.Position = UDim2.new(0, 0, 0.05, 0)
skyText.BackgroundTransparency = 1
skyText.Text = "Meknoyu Teams >:)"
skyText.TextColor3 = Color3.fromRGB(200, 0, 0)
skyText.Font = Enum.Font.LuckiestGuy
skyText.TextSize = 65
skyText.Visible = false

local oldAmbient = lighting.Ambient
local oldOutdoor = lighting.OutdoorAmbient
local oldFog = lighting.FogColor

local virtualUser = game:GetService("VirtualUser")
pcall(function()
    plr.Idled:Connect(function()
        if states.antiafk then
            virtualUser:Button2Down(Vector2.new(0,0), cam.CFrame)
            task.wait(1)
            virtualUser:Button2Up(Vector2.new(0,0), cam.CFrame)
        end
    end)
end)

local function giveTpTool()
    local oldTool = plr.Backpack:FindFirstChild("Mekno TP Tool") or (char and char:FindFirstChild("Mekno TP Tool"))
    if oldTool then oldTool:Destroy() end
    local tpTool = Instance.new("Tool")
    tpTool.Name = "Mekno TP Tool"
    tpTool.RequiresHandle = false
    tpTool.Activated:Connect(function()
        if mouse.Hit and hrp then
            lastPos = CFrame.new(mouse.Hit.p + Vector3.new(0, 5, 0))
            hrp.CFrame = lastPos
        end
    end)
    tpTool.Parent = plr.Backpack
end

local function setupChar(c)
    char = c; hum = c:WaitForChild("Humanoid", 10); hrp = c:WaitForChild("HumanoidRootPart", 10)
    if hrp then lastPos = hrp.CFrame end
    if states.tooltp then task.defer(giveTpTool) end
end
if plr.Character then setupChar(plr.Character) end
plr.CharacterAdded:Connect(setupChar)

--// TELEPORT BACK GUI //--
local tpBackGui = Instance.new("Frame", screenGui); tpBackGui.Size = UDim2.new(0, 160, 0, 100); tpBackGui.Position = UDim2.new(0.8, 0, 0.5, 0); tpBackGui.BackgroundColor3 = Color3.fromRGB(20,20,20); tpBackGui.Visible = false; tpBackGui.Active = true; tpBackGui.Draggable = true; Instance.new("UICorner", tpBackGui)
local saveBtn = Instance.new("TextButton", tpBackGui); saveBtn.Size = UDim2.new(0, 160 * 0.9, 0, 100 * 0.4); saveBtn.Position = UDim2.new(0.05, 0, 0.05, 0); saveBtn.Text = "Save Pos : OFF"; saveBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); saveBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", saveBtn)
local clickTpBtn = Instance.new("TextButton", tpBackGui); clickTpBtn.Size = UDim2.new(0, 160 * 0.9, 0, 100 * 0.4); clickTpBtn.Position = UDim2.new(0.05, 0, 0.55, 0); clickTpBtn.Text = "Click TP Back"; clickTpBtn.BackgroundColor3 = Color3.fromRGB(60,20,20); clickTpBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", clickTpBtn)
saveBtn.MouseButton1Click:Connect(function() states.savepos = not states.savepos; saveBtn.Text = "Save Pos : " .. (states.savepos and "ON" or "OFF"); if states.savepos and hrp then savedPos = hrp.CFrame; lastPos = savedPos end end)
clickTpBtn.MouseButton1Click:Connect(function() if savedPos and hrp then lastPos = savedPos; wait(0.1); hrp.CFrame = savedPos end end)

-- // MAIN GUI STRUCTURE //
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, -225, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true; main.Draggable = true; Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2.5
rs.RenderStepped:Connect(function() stroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1) end)

local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, -110, 0, 40); header.Position = UDim2.new(0, 110, 0, 5)
header.Text = "Meknoyu Gui | Hub"; header.BackgroundTransparency = 1; header.TextColor3 = Color3.new(1,1,1); header.Font = Enum.Font.GothamBold; header.TextSize = 18; header.TextXAlignment = Enum.TextXAlignment.Left
local closeBtn = Instance.new("TextButton", main); closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 7); closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.new(1,0,0); closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); Instance.new("UICorner", closeBtn)
local miniBtn = Instance.new("TextButton", screenGui); miniBtn.Size = UDim2.new(0, 50, 0, 50); miniBtn.Position = UDim2.new(0.9, 0, 0.05, 0); miniBtn.Text = "MEKNO"; miniBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); miniBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1,0); miniBtn.Draggable = true; miniBtn.Visible = false
closeBtn.MouseButton1Click:Connect(function() main.Visible = false; miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true; miniBtn.Visible = false end)

local tabContainer = Instance.new("ScrollingFrame", main)
tabContainer.Size = UDim2.new(0, 100, 1, -10)
tabContainer.Position = UDim2.new(0, 5, 0, 5)
tabContainer.BackgroundTransparency = 1
tabContainer.ScrollBarThickness = 0
tabContainer.CanvasSize = UDim2.new(0, 0, 1.5, 0)
local UIList = Instance.new("UIListLayout", tabContainer); UIList.Padding = UDim.new(0, 5)

local pages = Instance.new("Frame", main); pages.Size = UDim2.new(1, -115, 1, -50); pages.Position = UDim2.new(0, 110, 0, 45); pages.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", pages); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0, 0, 3.5, 0)
    local grid = Instance.new("UIGridLayout", p); grid.CellSize = UDim2.new(0.48, 0, 0, 35); grid.CellPadding = UDim2.new(0, 5, 0, 5)
    return p
end

local pageMain = createPage("Main")
local pageNoToggle = createPage("NoToggle")
local pageSelectAnti = createPage("SelectAnti")
local pageInfo = createPage("Info")
local pageGames = createPage("Games")
local pageServer = createPage("Server")

local function addTab(name, targetPage)
    local btn = Instance.new("TextButton", tabContainer); btn.Size = UDim2.new(1, 0, 0, 30); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() for _, v in pairs(pages:GetChildren()) do v.Visible = false end; targetPage.Visible = true end)
end

addTab("Main", pageMain)
addTab("No Toggle", pageNoToggle)
addTab("Select Anti", pageSelectAnti)
addTab("Info", pageInfo)
addTab("Games", pageGames)
addTab("Server", pageServer)

-- // TAB INFO CONTENT //
local infoText = Instance.new("TextLabel", pageInfo)
infoText.Size = UDim2.new(0.95, 0, 0, 200); infoText.Position = UDim2.new(0.025, 0, 0, 5); infoText.BackgroundTransparency = 1; infoText.TextColor3 = Color3.fromRGB(255, 255, 255); infoText.TextSize = 13; infoText.Font = Enum.Font.GothamMedium; infoText.TextWrapped = true; infoText.TextXAlignment = Enum.TextXAlignment.Left; infoText.TextYAlignment = Enum.TextYAlignment.Top; infoText.Text = "This script is strictly guarded and secure. There is no account theft or fraud. This script is securely protected, and no malicious bots will steal your data.\n\nCreated by Progaming Meknoyu Script"

-- // TAB GAMES CONTENT //
local function createGameBtn(name, parent, func)
    local b = Instance.new("TextButton", parent); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40, 40, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func); return b
end

createGameBtn("Murder Mystery 2 Script", pageGames, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/mm2.lua"))()
end)

createGameBtn("Grow a Garden 2 Script", pageGames, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/gag2.lua"))()
end)

createGameBtn("One Tap Script", pageGames, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MeknoyuReals/Meknoyu/refs/heads/main/onetap.lua"))()
end)

-- // TAB SERVER CONTENT //
createGameBtn("Rejoin", pageServer, function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end)

createGameBtn("Small Server", pageServer, function()
    local ts = game:GetService("TeleportService")
    local http = game:GetService("HttpService")
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local req = pcall(function()
        local raw = game:HttpGet(api)
        local json = http:JSONDecode(raw)
        if json and json.data then
            for _, s in pairs(json.data) do
                if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                    ts:TeleportToPlaceInstance(game.PlaceId, s.id, plr)
                    break
                end
            end
        end
    end)
end)

createGameBtn("Server Hop", pageServer, function()
    local ts = game:GetService("TeleportService")
    local http = game:GetService("HttpService")
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local req = pcall(function()
        local raw = game:HttpGet(api)
        local json = http:JSONDecode(raw)
        if json and json.data then
            local valid = {}
            for _, s in pairs(json.data) do
                if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(valid, s.id)
                end
            end
            if #valid > 0 then
                ts:TeleportToPlaceInstance(game.PlaceId, valid[math.random(1, #valid)], plr)
            end
        end
    end)
end)

createGameBtn("Server New", pageServer, function()
    local ts = game:GetService("TeleportService")
    local http = game:GetService("HttpService")
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local req = pcall(function()
        local raw = game:HttpGet(api)
        local json = http:JSONDecode(raw)
        if json and json.data then
            for _, s in pairs(json.data) do
                if s.playing and s.playing == 1 and s.id ~= game.JobId then
                    ts:TeleportToPlaceInstance(game.PlaceId, s.id, plr)
                    return
                end
            end
            for _, s in pairs(json.data) do
                if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                    ts:TeleportToPlaceInstance(game.PlaceId, s.id, plr)
                    break
                end
            end
        end
    end)
end)

-- // TOGGLE BUTTON CREATOR //
local function createToggleBtn(name, key, parent)
    local b = Instance.new("TextButton", parent); b.Text = name .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamSemibold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        states[key] = not states[key]; b.Text = name .. " : " .. (states[key] and "ON" or "OFF"); b.BackgroundColor3 = states[key] and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(30, 30, 35)
        if key == "noclip" and not states.noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end
        elseif key == "esp" and not states.esp then for _, p in pairs(players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("MeknoHighlight") then p.Character.MeknoHighlight:Destroy() end end
        elseif key == "title" and not states.title then if char and char:FindFirstChild("Head") and char.Head:FindFirstChild("MeknoTitle") then char.Head.MeknoTitle:Destroy() end; if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("MeknoTitle") then plr.Character.Head.MeknoTitle:Destroy() end
        elseif key == "disco" then if states.disco then discoSky.Parent = lighting; skyText.Visible = true else discoSky.Parent = nil; skyText.Visible = false; lighting.Ambient = oldAmbient; lighting.OutdoorAmbient = oldOutdoor; lighting.FogColor = oldFog end
        elseif key == "hcxxr" and not states.hcxxr then lighting.Ambient = oldAmbient; lighting.OutdoorAmbient = oldOutdoor; for _, p in pairs(players:GetPlayers()) do if p.Character then for _, v in pairs(p.Character:GetDescendants()) do if v:IsA("Fire") and v.Name == "MeknoFire" then v:Destroy() end end end end
        elseif key == "addpart" and not states.addpart then if platformPart then platformPart:Destroy(); platformPart = nil end
        elseif key == "antirobux" and not states.antirobux then pcall(function() guiService.MenuOpened:Disconnect() end)
        elseif key == "xray" and not states.xray then for obj, trans in pairs(originalTransparencies) do if obj and obj.Parent then obj.Transparency = trans end end; originalTransparencies = {}
        end
    end)
    return b
end

-- // TAB MAIN //
createToggleBtn("Noclip", "noclip", pageMain)
createToggleBtn("ESP", "esp", pageMain)
createToggleBtn("Fling", "fling", pageMain)
createToggleBtn("Inf Jump", "infJump", pageMain)
createToggleBtn("Speed", "speed", pageMain)
createToggleBtn("Custom Title", "title", pageMain)
createToggleBtn("Xray", "xray", pageMain)
createToggleBtn("TP Kill Enemy", "tpKill", pageMain)
createToggleBtn("Aimbot", "aimActive", pageMain)
createToggleBtn("Disco Mode", "disco", pageMain)
createToggleBtn("HCXXR Mode", "hcxxr", pageMain)
createToggleBtn("Add Part", "addpart", pageMain)

-- // TAB SELECT ANTI //
createToggleBtn("Bypass AntiCheat", "bypassac", pageSelectAnti)
createToggleBtn("Anti Fling", "antifling", pageSelectAnti)
createToggleBtn("Anti Teleport", "antitel", pageSelectAnti)
createToggleBtn("Anti Ragdoll", "antirag", pageSelectAnti)
createToggleBtn("Anti Afk", "antiafk", pageSelectAnti)
createToggleBtn("Anti Robux", "antirobux", pageSelectAnti)

-- // TAB NO TOGGLE //
local function createPlainBtn(name, parent, func)
    local b = Instance.new("TextButton", parent); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40, 40, 45); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamSemibold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func); return b
end

local godSubFrame = Instance.new("Frame", screenGui); godSubFrame.Size = UDim2.new(0, 150, 0, 100); godSubFrame.Position = UDim2.new(0.5, -75, 0.5, -50); godSubFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); godSubFrame.Visible = false; godSubFrame.Active = true; godSubFrame.Draggable = true; Instance.new("UICorner", godSubFrame)
local godToggleBtn = Instance.new("TextButton", godSubFrame); godToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0); godToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0); godToggleBtn.Text = "God Mode : OFF"; godToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); godToggleBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", godToggleBtn)
local function GodModeSeatNoInvis(state) local c = game.Players.LocalPlayer.Character; if not c then return end for _, o in pairs(workspace:GetChildren()) do if o.Name == 'invischair' then pcall(function() o:Destroy() end) end end if state then local r = c:FindFirstChild("HumanoidRootPart"); if not r then return end task.wait(0.05); local scf = r.CFrame; local under = r.Position + Vector3.new(0, -100, 0); c:MoveTo(under); task.wait(0.1); local s = Instance.new("Seat", workspace); s.Anchored = true; s.CanCollide = false; s.Transparency = 1; s.Position = under; s.Name = "invischair"; local w = Instance.new("Weld", s); w.Part0 = s; w.Part1 = r; task.wait(); s.CFrame = scf; s.Anchored = false end end
godToggleBtn.MouseButton1Click:Connect(function() states.god = not states.god; godToggleBtn.Text = "God Mode : " .. (states.god and "ON" or "OFF"); godToggleBtn.BackgroundColor3 = states.god and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(35, 35, 35); if states.god then GodModeSeatNoInvis(true); godConnection = rs.Heartbeat:Connect(function() if char and hum and hrp then hum.MaxHealth = math.huge; hum.Health = math.huge; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end end) else if godConnection then godConnection:Disconnect() end; GodModeSeatNoInvis(false); if hum then hum.MaxHealth = 100; hum.Health = 100; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end end end)

local invisSubFrame = Instance.new("Frame", screenGui); invisSubFrame.Size = UDim2.new(0, 150, 0, 100); invisSubFrame.Position = UDim2.new(0.5, -75, 0.5, -50); invisSubFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); invisSubFrame.Visible = false; invisSubFrame.Active = true; invisSubFrame.Draggable = true; Instance.new("UICorner", invisSubFrame)
local invisToggleBtn = Instance.new("TextButton", invisSubFrame); invisToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0); invisToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0); invisToggleBtn.Text = "Invisible : OFF"; invisToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); invisToggleBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", invisToggleBtn)
local function setInvisState(state) local c = game.Players.LocalPlayer.Character; if not c then return end for _, o in pairs(workspace:GetChildren()) do if o.Name == 'invischair' then pcall(function() o:Destroy() end) end end for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 0 end end if state then local r = c:FindFirstChild("HumanoidRootPart"); if not r then return end task.wait(0.05); local scf = r.CFrame; local under = r.Position + Vector3.new(0, -100, 0); c:MoveTo(under); task.wait(0.1); local s = Instance.new("Seat", workspace); s.Anchored = true; s.CanCollide = false; s.Transparency = 1; s.Position = under; s.Name = "invischair"; local w = Instance.new("Weld", s); w.Part0 = s; w.Part1 = r; task.wait(); s.CFrame = scf; s.Anchored = false; for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = 0.5 end end end end
invisToggleBtn.MouseButton1Click:Connect(function() states.invis = not states.invis; invisToggleBtn.Text = "Invisible : " .. (states.invis and "ON" or "OFF"); invisToggleBtn.BackgroundColor3 = states.invis and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(35, 35, 35); setInvisState(states.invis) end)

local execMainFrame = Instance.new("Frame", screenGui); execMainFrame.Size = UDim2.new(0, 300, 0, 220); execMainFrame.Position = UDim2.new(0.5, -150, 0.5, -110); execMainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); execMainFrame.Visible = false; execMainFrame.Active = true; execMainFrame.Draggable = true; Instance.new("UICorner", execMainFrame)
local execTextBox = Instance.new("TextBox", execMainFrame); execTextBox.Size = UDim2.new(1, -20, 0, 130); execTextBox.Position = UDim2.new(0, 10, 0, 40); execTextBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10); execTextBox.TextColor3 = Color3.fromRGB(255, 255, 255); execTextBox.ClearTextOnFocus = false; execTextBox.MultiLine = true; execTextBox.Font = Enum.Font.Code; execTextBox.TextSize = 10; Instance.new("UICorner", execTextBox)
local executeSubBtn = Instance.new("TextButton", execMainFrame); executeSubBtn.Size = UDim2.new(0, 85, 0, 35); executeSubBtn.Position = UDim2.new(0, 10, 0, 175); executeSubBtn.Text = "Execute"; executeSubBtn.BackgroundColor3 = Color3.fromRGB(35, 100, 35); executeSubBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", executeSubBtn)
executeSubBtn.MouseButton1Click:Connect(function() if execTextBox.Text ~= "" then pcall(function() local func = loadstring(execTextBox.Text); if func then func() end end) end end)

local function miniFling(playerToFling)
    local localplayer = game:GetService("Players").LocalPlayer
    local character = localplayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = humanoid and humanoid.RootPart

    local targetCharacter = playerToFling.Character
    local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
    local targetRootPart = targetHumanoid and targetHumanoid.RootPart
    local targetHead = targetCharacter and targetCharacter:FindFirstChild("Head")

    if character and humanoid and rootPart and targetCharacter and targetHumanoid and targetRootPart then
        if rootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = rootPart.CFrame
        end

        workspace.CurrentCamera.CameraSubject = targetHead or targetRootPart or targetHumanoid
        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Name = "VelocityFling"
        BV.Parent = rootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        -- Loop teleportasi melekat ke target sampai target terdeteksi kena fling (pental) jauh
        local Time = tick()
        repeat
            if rootPart and targetRootPart then
                -- Melekatkan posisi kita tepat di rootpart lawan untuk mentransfer gaya physics touch fling
                rootPart.CFrame = targetRootPart.CFrame * CFrame.new(0, 0, 0)
                rootPart.Velocity = targetRootPart.Velocity * 10000 + Vector3.new(0, 10000, 0)
                rootPart.RotVelocity = Vector3.new(0, 10000, 0)
            end
            task.wait()
        -- Berhenti klu target ter-fling jauh (Velocity tinggi), mati, atau waktu habis (2 detik per player)
        until not targetRootPart or targetRootPart.Parent ~= targetCharacter or targetRootPart.Velocity.Magnitude > 150 or targetHumanoid.Health <= 0 or targetHumanoid.Sit or tick() > Time + 2

        BV:Destroy()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = humanoid

        -- Mengembalikan posisi ke awal setelah fling selesai
        repeat
            rootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            if character.PrimaryPart then character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0)) end
            humanoid:ChangeState("GettingUp")
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
                end
            end
            task.wait()
        until (rootPart.Position - getgenv().OldPos.p).Magnitude < 25
    end
end

createPlainBtn("God Mode Menu", pageNoToggle, function() godSubFrame.Visible = not godSubFrame.Visible end)
createPlainBtn("Invisible Menu", pageNoToggle, function() invisSubFrame.Visible = not invisSubFrame.Visible end)
createPlainBtn("Execute Project", pageNoToggle, function() execMainFrame.Visible = not execMainFrame.Visible end)
createPlainBtn("Teleport Back UI", pageNoToggle, function() tpBackGui.Visible = not tpBackGui.Visible end)
createPlainBtn("Tool TP Logic", pageNoToggle, function() states.tooltp = not states.tooltp; if states.tooltp then giveTpTool() else local t = plr.Backpack:FindFirstChild("Mekno TP Tool") or (char and char:FindFirstChild("Mekno TP Tool")); if t then t:Destroy() end end end)
createPlainBtn("KILL ALL", pageNoToggle, function() for i = 1, 10 do for _, p in pairs(players:GetPlayers()) do if p ~= plr and p.Character and p.Character:FindFirstChild("Humanoid") then p.Character.Humanoid.Health = 0; p.Character.Humanoid:TakeDamage(999999) end end; task.wait(0.02) end end)
createPlainBtn("Fling All", pageNoToggle, function() task.spawn(function() for _, p in pairs(players:GetPlayers()) do if p ~= plr and p.Character then miniFling(p) end end end) end)
createPlainBtn("Dark Dex", pageNoToggle, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
createPlainBtn("Message Horror", pageNoToggle, function() task.spawn(function() local oldFrame = Instance.new("Frame", screenGui); oldFrame.Size = UDim2.new(1, 0, 0.25, 0); oldFrame.Position = UDim2.new(0, 0, 0.35, 0); oldFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); oldFrame.BackgroundTransparency = 0.4; local oldLabel = Instance.new("TextLabel", oldFrame); oldLabel.Size = UDim2.new(1, 0, 1, 0); oldLabel.BackgroundTransparency = 1; oldLabel.TextColor3 = Color3.fromRGB(255, 255, 255); oldLabel.TextSize = 32; oldLabel.Font = Enum.Font.Legacy; oldLabel.Text = "Are you stuck here forever?"; task.wait(3.5); oldLabel.Text = "You're scared here hahahaha\240\159\152\136"; task.wait(3.5); oldLabel.Text = "I'm going to crash this server now hahahaha"; task.wait(3.5); oldFrame:Destroy() end) end)
createPlainBtn("MAN??? (Server Cook)", pageNoToggle, function() task.spawn(function() while true do starterGui:SetCore("SendNotification", { Title = "Meknoyu Team", Text = "SERVER ARE COOKED NGAW\240\159\152\136", Duration = 9999 }); task.wait(0.5) end end); local topGui = screenGui:FindFirstChild("MeknoTopPermanent") or Instance.new("ScreenGui", screenGui); topGui.Name = "MeknoTopPermanent"; topGui.DisplayOrder = 1000000; local topFrame = Instance.new("Frame", topGui); topFrame.Size = UDim2.new(0, 500, 0, 35); topFrame.Position = UDim2.new(0.5, -250, 0.02, 0); topFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); local topLabel = Instance.new("TextLabel", topFrame); topLabel.Size = UDim2.new(1, 0, 1, 0); topLabel.BackgroundTransparency = 1; topLabel.Text = "KEBIXEVEBJDDGEBEJDOXI3ERKF9U3V33R8V3B33INXC"; topLabel.TextColor3 = Color3.new(1,1,1); topLabel.TextScaled = true; task.wait(0.1); local loadGui = Instance.new("ScreenGui", screenGui); loadGui.DisplayOrder = 999999; local loadFrame = Instance.new("Frame", loadGui); loadFrame.Size = UDim2.new(1,0,1,0); local cookLabel = Instance.new("TextLabel", loadFrame); cookLabel.Size = UDim2.new(1, 0, 0.3, 0); cookLabel.Position = UDim2.new(0, 0, 0.35, 0); cookLabel.BackgroundTransparency = 1; cookLabel.Text = "YOUXXXXXXXAREXXXXXCOOKKED\240\159\152\136XXXX"; cookLabel.TextColor3 = Color3.new(0,0,0); cookLabel.TextSize = 42; local cn = rs.RenderStepped:Connect(function() loadFrame.BackgroundColor3 = Color3.fromHSV((tick() * 0.5) % 1, 0.8, 1) end); task.wait(5); cn:Disconnect(); loadGui:Destroy(); for _, obj in pairs(workspace:GetChildren()) do if not obj:IsA("Camera") and not obj:IsA("Terrain") and not players:GetPlayerFromCharacter(obj) then if obj:IsA("BasePart") then obj.Transparency = 1; obj.CanCollide = false elseif obj:IsA("Model") or obj:IsA("Folder") then for _, child in pairs(obj:GetDescendants()) do if child:IsA("BasePart") then child.Transparency = 1; child.CanCollide = false end end end end end; local bp = workspace:FindFirstChild("MeknoLocalBaseplate") or Instance.new("Part", workspace); bp.Name = "MeknoLocalBaseplate"; bp.Size = Vector3.new(2000, 4, 2000); bp.Position = Vector3.new(0, -2, 0); bp.Anchored = true; bp.CanCollide = true; if hrp then lastPos = CFrame.new(0, 5, 0); hrp.CFrame = lastPos end; local horrorTracks = {1837874627, 1836740615, 1843358057, 1839019688, 1841348122}; for _, audioId in pairs(horrorTracks) do task.spawn(function() local sound = Instance.new("Sound", workspace); sound.SoundId = "rbxassetid://" .. audioId; sound.Volume = 6; sound.Looped = true; sound:Play() end) end; local rainPart = Instance.new("Part", workspace); rainPart.Size = Vector3.new(2000, 1, 2000); rainPart.Position = Vector3.new(0, 150, 0); rainPart.Anchored = true; rainPart.Transparency = 1; rainPart.CanCollide = false; local attachment = Instance.new("Attachment", rainPart); local bloodRain = Instance.new("ParticleEmitter", attachment); bloodRain.Texture = "rbxassetid://242336336"; bloodRain.Rate = 50000; bloodRain.Speed = NumberRange.new(120, 180); bloodRain.Lifetime = NumberRange.new(3, 4) end)

pageMain.Visible = true

--// MAIN ENGINE RENDER LOOP //--
UIS.JumpRequest:Connect(function() if states.infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

rs.Heartbeat:Connect(function()
    if states.fling then
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if hrp and hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            
            -- Implementasi Metode Baru Touch Fling Sesuai Request (No Spin)
            local currentVel = hrp.Velocity
            hrp.Velocity = currentVel * 10000 + Vector3.new(0, 10000, 0)
            
            rs.RenderStepped:Wait()
            
            if hrp then
                hrp.Velocity = currentVel
                hrp.RotVelocity = Vector3.new(0, 10000, 0)
            end
        end
    end
end)

rs.Stepped:Connect(function()
    if states.fling and plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

rs.RenderStepped:Connect(function()
    if not char or not hum or not hrp then return end
    if states.god then if hum.Health < 100000000 or hum.MaxHealth < 100000000 then hum.MaxHealth = 100000000; hum.Health = 100000000 end end
    if states.antirobux then mps.PromptPurchaseFinished:Connect(function() return nil end); mps.PromptProductPurchaseFinished:Connect(function() return nil end) end
    if states.antiafk then pcall(function() guiService:SetMenuIsOpen(false) end) end
    if states.antirag or states.antifling then 
        -- Anti Fling Fixed: Hanya mematikan state ragdoll agar tidak pingsan saat terkena hantaman physics player lain
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    if states.antitel and lastPos then local distance = (hrp.Position - lastPos.Position).Magnitude; if distance > 40 and not (states.speed or states.tooltp or states.savepos or states.tpKill or states.antifling) then hrp.Velocity = Vector3.new(0,0,0); hrp.CFrame = lastPos else lastPos = hrp.CFrame end else lastPos = hrp.CFrame end
    if states.addpart then if not platformPart or not platformPart.Parent then platformPart = Instance.new("Part"); platformPart.Name = "MeknoPlatform"; platformPart.Size = Vector3.new(7, 1, 7); platformPart.Anchored = true; platformPart.Material = Enum.Material.Neon; platformPart.Color = Color3.fromRGB(150, 0, 0); platformPart.Parent = workspace end; platformPart.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z) end
    if states.xray then for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("BasePart") and not obj:IsDescendantOf(char) and not players:GetPlayerFromCharacter(obj.Parent) then if not originalTransparencies[obj] then originalTransparencies[obj] = obj.Transparency end; obj.Transparency = 0.65 end end end
    if states.tpKill then local targetEnemy = nil; local shortestDist = math.huge; for _, p in pairs(players:GetPlayers()) do if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then local tChar = p.Character; local inLobby = tChar.Parent.Name:lower():find("lobby") or tChar:FindFirstChild("InLobby") or (tChar.HumanoidRootPart.Position.Y > 200 and workspace:FindFirstChild("Lobby")); if not inLobby and (not plr.Team or p.Team ~= plr.Team) then local targetHrp = p.Character.HumanoidRootPart; local currentDist = (targetHrp.Position - hrp.Position).Magnitude; if currentDist < shortestDist then targetEnemy = targetHrp; shortestDist = currentDist end end end end; if targetEnemy then hrp.CFrame = targetEnemy.CFrame * CFrame.new(0, 0, 3); hrp.Velocity = Vector3.new(0, 0, 0); cam.CFrame = CFrame.new(cam.CFrame.Position, targetEnemy.Position) end end
    if states.disco then local hue = (tick() * 0.3) % 1; local rainbowColor = Color3.fromHSV(hue, 0.8, 1); lighting.Ambient = rainbowColor; lighting.OutdoorAmbient = rainbowColor; lighting.FogColor = rainbowColor; skyText.TextColor3 = Color3.fromHSV((tick() * 1.5) % 1, 1, 1) end
    if states.hcxxr then lighting.Ambient = Color3.fromRGB(255, 0, 0); lighting.OutdoorAmbient = Color3.fromRGB(150, 0, 0); for _, p in pairs(players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local root = p.Character.HumanoidRootPart; if not root:FindFirstChild("MeknoFire") then local f = Instance.new("Fire", root); f.Name = "MeknoFire"; f.Heat = 25; f.Size = 15; f.Color = Color3.fromRGB(255, 0, 0); f.SecondaryColor = Color3.fromRGB(100, 0, 0) end; for _, part in pairs(p.Character:GetDescendants()) do if part:IsA("BasePart") or part:IsA("Decal") then if part.Name == "HumanoidRootPart" then continue end; part.Transparency = 0 end end end end end
    if states.aimActive and not states.tpKill then local target = nil; local shortDistance = math.huge; for _, p in pairs(players:GetPlayers()) do if p ~= plr and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then if not plr.Team or p.Team ~= plr.Team or plr.Team == nil then local head = p.Character.Head; local currentDist = (head.Position - hrp.Position).Magnitude; if currentDist < shortDistance then target = head; shortDistance = currentDist end end end end; if target then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, target.Position); local currentTool = char:FindFirstChildOfClass("Tool"); if currentTool then currentTool:Activate() end end end
    if states.esp then for _, p in pairs(players:GetPlayers()) do if p ~= plr and p.Character and not p.Character:FindFirstChild("MeknoHighlight") then Instance.new("Highlight", p.Character).Name = "MeknoHighlight" end end end
    if states.title then local head = plr.Character and plr.Character:FindFirstChild("Head"); if head then local t = head:FindFirstChild("MeknoTitle"); if not t then t = Instance.new("BillboardGui"); t.Name = "MeknoTitle"; t.Size = UDim2.new(0, 200, 0, 50); t.AlwaysOnTop = true; t.Adornee = head; t.StudsOffset = Vector3.new(0, 3, 0); local txt = Instance.new("TextLabel", t); txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.fromRGB(255, 0, 0); txt.Font = Enum.Font.GothamBold; txt.TextSize = 18; txt.Text = "Meknoyu Here"; t.Parent = head; txt.Parent = t end end elseif not states.title then if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("MeknoTitle") then plr.Character.Head.MeknoTitle:Destroy() end end
    if states.noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if states.speed and hum.MoveDirection.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 1.5) end
end)
