-- [[ MEKNOYU HUB | REMOTE CHECK ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

local selectedRemote = nil
local selectedRemoteCode = ""

local function copyToClipboard(text)
	if not text or text == "" then return false end
	local clipboardFn = setclipboard or toclipboard or (Clipboard and Clipboard.set)
	if clipboardFn then
		local ok = pcall(clipboardFn, text)
		return ok
	end
	return false
end

local function buildRemoteCallCode(rem)
	local ok, full = pcall(function()
		return rem:GetFullName()
	end)
	local pathStr = ok and full or tostring(rem.Name)
	if rem:IsA("RemoteFunction") then
		return string.format("game.%s:InvokeServer()", pathStr)
	end
	return string.format("game.%s:FireServer()", pathStr)
end

local existingGui = (gethui and gethui():FindFirstChild("MeknoyuRemoteCheckGui")) or playerGui:FindFirstChild("MeknoyuRemoteCheckGui")
if existingGui then
	existingGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuRemoteCheckGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = (gethui and gethui()) or playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 270)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -135)
mainFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(140, 110, 255)

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 46)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Meknoyu Hub | Remote Check"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -56, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 66)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(175, 45, 55)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local openMiniBtn = Instance.new("TextButton", screenGui)
openMiniBtn.Size = UDim2.new(0, 165, 0, 32)
openMiniBtn.Position = UDim2.new(0.5, -82, 0.1, 0)
openMiniBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
openMiniBtn.Text = "Meknoyu Hub | Remote Check"
openMiniBtn.TextColor3 = Color3.fromRGB(140, 110, 255)
openMiniBtn.Font = Enum.Font.GothamBold
openMiniBtn.TextSize = 11
openMiniBtn.Visible = false
openMiniBtn.Active = true
openMiniBtn.Draggable = true
Instance.new("UICorner", openMiniBtn).CornerRadius = UDim.new(0, 8)

local scanBtn = Instance.new("TextButton", mainFrame)
scanBtn.Size = UDim2.new(0.58, -14, 0, 30)
scanBtn.Position = UDim2.new(0, 12, 0, 46)
scanBtn.BackgroundColor3 = Color3.fromRGB(65, 55, 130)
scanBtn.Text = "Scan Remotes"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 11
Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 6)

local copyBtn = Instance.new("TextButton", mainFrame)
copyBtn.Size = UDim2.new(0.42, -14, 0, 30)
copyBtn.Position = UDim2.new(0.58, 2, 0, 46)
copyBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
copyBtn.Text = "Copy (Locked)"
copyBtn.TextColor3 = Color3.fromRGB(145, 145, 160)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 11
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

local function updateCopyButtonState()
	if selectedRemote and selectedRemoteCode ~= "" then
		copyBtn.BackgroundColor3 = Color3.fromRGB(35, 145, 90)
		copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		copyBtn.Text = "Copy"
	else
		copyBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
		copyBtn.TextColor3 = Color3.fromRGB(145, 145, 160)
		copyBtn.Text = "Copy (Locked)"
	end
end

local statusLbl = Instance.new("TextLabel", mainFrame)
statusLbl.Size = UDim2.new(1, -24, 0, 20)
statusLbl.Position = UDim2.new(0, 12, 0, 80)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Klik Scan Remotes untuk memuat daftar."
statusLbl.TextColor3 = Color3.fromRGB(190, 195, 215)
statusLbl.Font = Enum.Font.Code
statusLbl.TextSize = 10
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

local listScroll = Instance.new("ScrollingFrame", mainFrame)
listScroll.Size = UDim2.new(1, -24, 1, -112)
listScroll.Position = UDim2.new(0, 12, 0, 102)
listScroll.BackgroundColor3 = Color3.fromRGB(19, 19, 25)
listScroll.BorderSizePixel = 0
listScroll.ScrollBarThickness = 3
listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", listScroll).CornerRadius = UDim.new(0, 7)

local listLayout = Instance.new("UIListLayout", listScroll)
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function refreshRemotes()
	for _, ch in ipairs(listScroll:GetChildren()) do
		if ch:IsA("TextButton") then
			ch:Destroy()
		end
	end

	selectedRemote = nil
	selectedRemoteCode = ""
	updateCopyButtonState()

	local found = {}
	for _, desc in ipairs(ReplicatedStorage:GetDescendants()) do
		if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
			table.insert(found, desc)
		end
	end

	statusLbl.Text = "Ditemukan " .. tostring(#found) .. " remote di ReplicatedStorage."

	for i, rem in ipairs(found) do
		local b = Instance.new("TextButton", listScroll)
		b.Size = UDim2.new(1, -8, 0, 28)
		b.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
		b.Text = string.format("[%s] %s", rem.ClassName, rem.Name)
		b.TextColor3 = Color3.fromRGB(240, 240, 250)
		b.Font = Enum.Font.Code
		b.TextSize = 10
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.TextTruncate = Enum.TextTruncate.AtEnd
		b.LayoutOrder = i
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

		b.MouseButton1Click:Connect(function()
			selectedRemote = rem
			selectedRemoteCode = buildRemoteCallCode(rem)
			updateCopyButtonState()

			pcall(function()
				if rem:IsA("RemoteEvent") then
					rem:FireServer()
					statusLbl.Text = "FireServer dipanggil & dipilih: " .. rem.Name
				elseif rem:IsA("RemoteFunction") then
					rem:InvokeServer()
					statusLbl.Text = "InvokeServer dipanggil & dipilih: " .. rem.Name
				end
			end)
		end)
	end

	listScroll.CanvasSize = UDim2.new(0, 0, 0, #found * 32 + 8)
end

copyBtn.MouseButton1Click:Connect(function()
	if not selectedRemote or selectedRemoteCode == "" then
		statusLbl.Text = "Pilih tombol remote dulu sebelum Copy!"
		return
	end

	local ok = copyToClipboard(selectedRemoteCode)
	if ok then
		copyBtn.Text = "Copied!"
		statusLbl.Text = "Tersalin: " .. selectedRemoteCode
	else
		copyBtn.Text = "No Clipboard"
		statusLbl.Text = "Clipboard tidak tersedia di executor."
	end

	task.delay(1.1, function()
		updateCopyButtonState()
	end)
end)

scanBtn.MouseButton1Click:Connect(refreshRemotes)

minBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	openMiniBtn.Visible = true
end)

openMiniBtn.MouseButton1Click:Connect(function()
	openMiniBtn.Visible = false
	mainFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

refreshRemotes()
