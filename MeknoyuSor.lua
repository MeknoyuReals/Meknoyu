-- [[ MEKNOYU HUB | EXPLORE SOURCE ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")
local cam = workspace.CurrentCamera
local mouse = plr:GetMouse()

local selectedInstance = workspace
local currentMode = "Explorer" -- "Explorer" | "Property" | "Script Shows" | "Click Object"
local clickObjectActive = false
local searchQuery = ""

local function safeGetChildren(inst)
	local ok, res = pcall(function()
		return inst:GetChildren()
	end)
	return ok and res or {}
end

local function safeGetFullName(inst)
	if not inst then return "nil" end
	local ok, res = pcall(function()
		return inst:GetFullName()
	end)
	return ok and res or tostring(inst.Name)
end

local function getKnownProperties(inst)
	local props = {}
	local function tryProp(propName)
		local ok, val = pcall(function()
			return inst[propName]
		end)
		if ok then
			table.insert(props, { name = propName, value = val })
		end
	end

	local commonProps = {
		"Name", "ClassName", "Parent", "Archivable",
		"Position", "CFrame", "Size", "Orientation", "Anchored", "CanCollide", "CanTouch", "CanQuery",
		"Transparency", "Reflectance", "Material", "Color", "CastShadow",
		"PrimaryPart", "WorldPivot",
		"WalkSpeed", "JumpPower", "JumpHeight", "Health", "MaxHealth", "HipHeight", "RigType",
		"Enabled", "ResetOnSpawn", "DisplayOrder", "ZIndexBehavior", "Visible", "Active", "Text", "Image", "BackgroundColor3",
		"Source", "Disabled", "RunContext",
		"ActionText", "ObjectText", "KeyboardKeyCode", "MaxActivationDistance", "HoldDuration", "RequiresLineOfSight",
		"MaxDistance", "ActivationDistance",
		"Value", "Adornee", "Target", "Part0", "Part1"
	}

	for _, pName in ipairs(commonProps) do
		tryProp(pName)
	end

	-- Tambahan atribut jika ada
	local okAttrs, attrs = pcall(function()
		return inst:GetAttributes()
	end)
	if okAttrs and type(attrs) == "table" then
		for attrName, attrVal in pairs(attrs) do
			table.insert(props, { name = "[Attr] " .. tostring(attrName), value = attrVal })
		end
	end

	return props
end

local function formatPropertyValue(val)
	local t = typeof and typeof(val) or type(val)
	if t == "Instance" then
		return string.format("%s (%s)", val.Name, val.ClassName)
	elseif t == "Vector3" then
		return string.format("%.2f, %.2f, %.2f", val.X, val.Y, val.Z)
	elseif t == "CFrame" then
		local p = val.Position
		return string.format("Pos(%.2f, %.2f, %.2f)", p.X, p.Y, p.Z)
	elseif t == "Color3" then
		return string.format("RGB(%d, %d, %d)", math.floor(val.R * 255), math.floor(val.G * 255), math.floor(val.B * 255))
	elseif t == "UDim2" then
		return string.format("{%d, %d}, {%d, %d}", val.X.Scale, val.X.Offset, val.Y.Scale, val.Y.Offset)
	else
		return tostring(val)
	end
end

local function getScriptSourceInfo(inst)
	local lines = {}
	table.insert(lines, "Name      : " .. tostring(inst.Name))
	table.insert(lines, "ClassName : " .. tostring(inst.ClassName))
	table.insert(lines, "FullName  : " .. safeGetFullName(inst))

	local disabledOk, isDisabled = pcall(function() return inst.Disabled end)
	if disabledOk then
		table.insert(lines, "Disabled  : " .. tostring(isDisabled))
	end

	local srcOk, srcVal = pcall(function() return inst.Source end)
	if srcOk and type(srcVal) == "string" and #srcVal > 0 then
		table.insert(lines, "----------------------------------------")
		table.insert(lines, srcVal)
	else
		table.insert(lines, "----------------------------------------")
		table.insert(lines, "-- Source tidak terekspos secara langsung pada client untuk instance ini.")
		if decompile then
			local dOk, dRes = pcall(decompile, inst)
			if dOk and type(dRes) == "string" and #dRes > 0 then
				table.insert(lines, "-- [Decompiled Output]")
				table.insert(lines, dRes)
			end
		end
	end
	return table.concat(lines, "\n")
end

-- // PEMBUATAN GUI MEKNOYU HUB | EXPLORE SOURCE //
local existingGui = (gethui and gethui():FindFirstChild("MeknoyuExploreSourceGui")) or playerGui:FindFirstChild("MeknoyuExploreSourceGui")
if existingGui then
	existingGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuExploreSourceGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = (gethui and gethui()) or playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 460, 0, 340)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(255, 145, 35)

local bgGrad = Instance.new("UIGradient", mainFrame)
bgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 42, 54)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(19, 19, 25))
})
bgGrad.Rotation = 90

-- Header dengan Tombol Menu di Atas
local headerFrame = Instance.new("Frame", mainFrame)
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 38)
headerFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
headerFrame.BorderSizePixel = 0
Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel", headerFrame)
titleLabel.Size = UDim2.new(1, -165, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Meknoyu Hub | Explore Source"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTruncate = Enum.TextTruncate.AtEnd

local menuTopBtn = Instance.new("TextButton", headerFrame)
menuTopBtn.Name = "MenuTopBtn"
menuTopBtn.Size = UDim2.new(0, 62, 0, 24)
menuTopBtn.Position = UDim2.new(1, -146, 0.5, -12)
menuTopBtn.BackgroundColor3 = Color3.fromRGB(255, 145, 35)
menuTopBtn.Text = "Menu"
menuTopBtn.TextColor3 = Color3.fromRGB(20, 20, 24)
menuTopBtn.Font = Enum.Font.GothamBold
menuTopBtn.TextSize = 11
Instance.new("UICorner", menuTopBtn).CornerRadius = UDim.new(0, 6)

local minBtn = Instance.new("TextButton", headerFrame)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -78, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(54, 54, 68)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton", headerFrame)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -48, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(175, 45, 55)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Minimize Floating
local openMiniBtn = Instance.new("TextButton", screenGui)
openMiniBtn.Name = "OpenMiniBtn"
openMiniBtn.Size = UDim2.new(0, 175, 0, 32)
openMiniBtn.Position = UDim2.new(0.5, -87, 0.1, 0)
openMiniBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
openMiniBtn.Text = "Meknoyu Hub | Explore"
openMiniBtn.TextColor3 = Color3.fromRGB(255, 165, 55)
openMiniBtn.Font = Enum.Font.GothamBold
openMiniBtn.TextSize = 11
openMiniBtn.Visible = false
openMiniBtn.Active = true
openMiniBtn.Draggable = true
Instance.new("UICorner", openMiniBtn).CornerRadius = UDim.new(0, 8)
local miniStroke = Instance.new("UIStroke", openMiniBtn)
miniStroke.Thickness = 1.5
miniStroke.Color = Color3.fromRGB(255, 145, 35)

-- Popup Menu (Click Object, Script Shows, Explorer, Property)
local menuPopup = Instance.new("Frame", mainFrame)
menuPopup.Name = "MenuPopup"
menuPopup.Size = UDim2.new(0, 155, 0, 156)
menuPopup.Position = UDim2.new(1, -167, 0, 42)
menuPopup.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
menuPopup.BorderSizePixel = 0
menuPopup.Visible = false
menuPopup.ZIndex = 20
Instance.new("UICorner", menuPopup).CornerRadius = UDim.new(0, 8)
local popupStroke = Instance.new("UIStroke", menuPopup)
popupStroke.Thickness = 1.5
popupStroke.Color = Color3.fromRGB(255, 145, 35)

local popupLayout = Instance.new("UIListLayout", menuPopup)
popupLayout.Padding = UDim.new(0, 5)
popupLayout.SortOrder = Enum.SortOrder.LayoutOrder

local popupPadding = Instance.new("UIPadding", menuPopup)
popupPadding.PaddingTop = UDim.new(0, 6)
popupPadding.PaddingBottom = UDim.new(0, 6)
popupPadding.PaddingLeft = UDim.new(0, 6)
popupPadding.PaddingRight = UDim.new(0, 6)

-- Search & Path Bar
local searchBar = Instance.new("Frame", mainFrame)
searchBar.Name = "SearchBar"
searchBar.Size = UDim2.new(1, -24, 0, 28)
searchBar.Position = UDim2.new(0, 12, 0, 44)
searchBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 6)

local searchBox = Instance.new("TextBox", searchBar)
searchBox.Size = UDim2.new(1, -92, 1, 0)
searchBox.Position = UDim2.new(0, 8, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.PlaceholderText = "Cari source / nama / class di Explorer..."
searchBox.PlaceholderColor3 = Color3.fromRGB(145, 145, 165)
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.Font = Enum.Font.Code
searchBox.TextSize = 11
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false

local upParentBtn = Instance.new("TextButton", searchBar)
upParentBtn.Size = UDim2.new(0, 38, 1, -4)
upParentBtn.Position = UDim2.new(1, -82, 0, 2)
upParentBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
upParentBtn.Text = ".. Up"
upParentBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
upParentBtn.Font = Enum.Font.GothamBold
upParentBtn.TextSize = 10
Instance.new("UICorner", upParentBtn).CornerRadius = UDim.new(0, 5)

local refreshBtn = Instance.new("TextButton", searchBar)
refreshBtn.Size = UDim2.new(0, 38, 1, -4)
refreshBtn.Position = UDim2.new(1, -41, 0, 2)
refreshBtn.BackgroundColor3 = Color3.fromRGB(55, 110, 175)
refreshBtn.Text = "Scan"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 10
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 5)

-- Path Label
local pathLabel = Instance.new("TextLabel", mainFrame)
pathLabel.Size = UDim2.new(1, -24, 0, 18)
pathLabel.Position = UDim2.new(0, 12, 0, 74)
pathLabel.BackgroundTransparency = 1
pathLabel.Text = "Path: workspace"
pathLabel.TextColor3 = Color3.fromRGB(255, 185, 85)
pathLabel.Font = Enum.Font.Code
pathLabel.TextSize = 10
pathLabel.TextXAlignment = Enum.TextXAlignment.Left
pathLabel.TextTruncate = Enum.TextTruncate.AtEnd

-- Area Utama (Kiri: Explorer Tree / Search Results | Kanan: Properties & Source)
local bodyFrame = Instance.new("Frame", mainFrame)
bodyFrame.Size = UDim2.new(1, -24, 1, -100)
bodyFrame.Position = UDim2.new(0, 12, 0, 94)
bodyFrame.BackgroundTransparency = 1

local explorerScroll = Instance.new("ScrollingFrame", bodyFrame)
explorerScroll.Name = "ExplorerScroll"
explorerScroll.Size = UDim2.new(0.47, -4, 1, 0)
explorerScroll.Position = UDim2.new(0, 0, 0, 0)
explorerScroll.BackgroundColor3 = Color3.fromRGB(19, 19, 25)
explorerScroll.BorderSizePixel = 0
explorerScroll.ScrollBarThickness = 3
explorerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", explorerScroll).CornerRadius = UDim.new(0, 7)

local explorerLayout = Instance.new("UIListLayout", explorerScroll)
explorerLayout.Padding = UDim.new(0, 3)
explorerLayout.SortOrder = Enum.SortOrder.LayoutOrder

local rightPanel = Instance.new("ScrollingFrame", bodyFrame)
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(0.53, -4, 1, 0)
rightPanel.Position = UDim2.new(0.47, 8, 0, 0)
rightPanel.BackgroundColor3 = Color3.fromRGB(19, 19, 25)
rightPanel.BorderSizePixel = 0
rightPanel.ScrollBarThickness = 3
rightPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0, 7)

local rightTextBox = Instance.new("TextBox", rightPanel)
rightTextBox.Size = UDim2.new(1, -12, 1, -12)
rightTextBox.Position = UDim2.new(0, 6, 0, 6)
rightTextBox.BackgroundTransparency = 1
rightTextBox.Text = ""
rightTextBox.TextColor3 = Color3.fromRGB(230, 235, 245)
rightTextBox.Font = Enum.Font.Code
rightTextBox.TextSize = 10
rightTextBox.TextXAlignment = Enum.TextXAlignment.Left
rightTextBox.TextYAlignment = Enum.TextYAlignment.Top
rightTextBox.MultiLine = true
rightTextBox.ClearTextOnFocus = false
rightTextBox.TextWrapped = true
rightTextBox.AutomaticSize = Enum.AutomaticSize.Y

local function refreshRightCanvas()
	task.defer(function()
		local bounds = rightTextBox.TextBounds
		rightPanel.CanvasSize = UDim2.new(0, 0, 0, math.max(rightPanel.AbsoluteSize.Y, bounds.Y + 24))
	end)
end

local function renderRightDetails()
	pathLabel.Text = string.format("[%s] %s", currentMode, safeGetFullName(selectedInstance))

	if currentMode == "Script Shows" then
		rightTextBox.Text = getScriptSourceInfo(selectedInstance)
	elseif currentMode == "Click Object" then
		local statusStr = clickObjectActive and "AKTIF (Klik objek di 3D game untuk inspect)" or "NONAKTIF (Tekan 'Click Object' di Menu)"
		local infoLines = {
			"Mode Click Object : " .. statusStr,
			"Selected Object   : " .. tostring(selectedInstance.Name),
			"ClassName         : " .. tostring(selectedInstance.ClassName),
			"FullName          : " .. safeGetFullName(selectedInstance),
			"----------------------------------------"
		}
		for _, p in ipairs(getKnownProperties(selectedInstance)) do
			table.insert(infoLines, string.format("%s = %s", p.name, formatPropertyValue(p.value)))
		end
		rightTextBox.Text = table.concat(infoLines, "\n")
	else
		-- Property / Explorer detail
		local lines = {
			"Name      : " .. tostring(selectedInstance.Name),
			"ClassName : " .. tostring(selectedInstance.ClassName),
			"FullName  : " .. safeGetFullName(selectedInstance),
			"Children  : " .. tostring(#safeGetChildren(selectedInstance)),
			"----------------------------------------"
		}
		for _, p in ipairs(getKnownProperties(selectedInstance)) do
			table.insert(lines, string.format("%s : %s", p.name, formatPropertyValue(p.value)))
		end
		rightTextBox.Text = table.concat(lines, "\n")
	end

	refreshRightCanvas()
end

local function rebuildExplorerList()
	for _, ch in ipairs(explorerScroll:GetChildren()) do
		if ch:IsA("TextButton") then
			ch:Destroy()
		end
	end

	local items = {}
	local q = string.lower(searchQuery)

	if q ~= "" then
		local roots = { workspace, plr, playerGui, game:GetService("ReplicatedStorage") }
		local count = 0
		for _, r in ipairs(roots) do
			if r then
				for _, desc in ipairs(r:GetDescendants()) do
					count += 1
					if count > 1200 then break end
					local nameMatch = string.find(string.lower(desc.Name), q, 1, true)
					local classMatch = string.find(string.lower(desc.ClassName), q, 1, true)
					local pathMatch = string.find(string.lower(safeGetFullName(desc)), q, 1, true)
					if nameMatch or classMatch or pathMatch then
						table.insert(items, desc)
						if #items >= 80 then break end
					end
				end
			end
			if #items >= 80 then break end
		end
	else
		local baseParent = selectedInstance or workspace
		items = safeGetChildren(baseParent)
	end

	for idx, obj in ipairs(items) do
		local btn = Instance.new("TextButton", explorerScroll)
		btn.Size = UDim2.new(1, -6, 0, 26)
		btn.BackgroundColor3 = (obj == selectedInstance) and Color3.fromRGB(75, 55, 25) or Color3.fromRGB(34, 34, 44)
		btn.Text = string.format("[%s] %s", obj.ClassName, obj.Name)
		btn.TextColor3 = Color3.fromRGB(240, 240, 248)
		btn.Font = Enum.Font.Code
		btn.TextSize = 10
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.TextTruncate = Enum.TextTruncate.AtEnd
		btn.LayoutOrder = idx
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

		btn.MouseButton1Click:Connect(function()
			selectedInstance = obj
			if q == "" and #safeGetChildren(obj) > 0 then
				selectedInstance = obj
				rebuildExplorerList()
			else
				rebuildExplorerList()
			end
			renderRightDetails()
		end)
	end

	explorerScroll.CanvasSize = UDim2.new(0, 0, 0, #items * 29 + 8)
end

-- Helper Tombol di dalam Popup Menu
local function addMenuItem(labelText, callback)
	local b = Instance.new("TextButton", menuPopup)
	b.Size = UDim2.new(1, 0, 0, 31)
	b.BackgroundColor3 = Color3.fromRGB(48, 48, 62)
	b.Text = labelText
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

	b.MouseButton1Click:Connect(function()
		menuPopup.Visible = false
		callback(b)
	end)
	return b
end

local clickObjMenuBtn = addMenuItem("Click Object : OFF", function(btn)
	clickObjectActive = not clickObjectActive
	currentMode = "Click Object"
	btn.Text = "Click Object : " .. (clickObjectActive and "ON" or "OFF")
	TweenService:Create(btn, TweenInfo.new(0.15), {
		BackgroundColor3 = clickObjectActive and Color3.fromRGB(40, 145, 90) or Color3.fromRGB(48, 48, 62)
	}):Play()
	renderRightDetails()
end)

addMenuItem("Script Shows", function()
	currentMode = "Script Shows"
	renderRightDetails()
end)

addMenuItem("Explorer", function()
	currentMode = "Explorer"
	rebuildExplorerList()
	renderRightDetails()
end)

addMenuItem("Property", function()
	currentMode = "Property"
	renderRightDetails()
end)

-- Klik Objek di World saat mode Click Object aktif
mouse.Button1Down:Connect(function()
	if not clickObjectActive then return end
	local target = mouse.Target
	if target and target:IsA("Instance") then
		selectedInstance = target
		currentMode = "Click Object"
		rebuildExplorerList()
		renderRightDetails()
	end
end)

menuTopBtn.MouseButton1Click:Connect(function()
	menuPopup.Visible = not menuPopup.Visible
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	searchQuery = searchBox.Text
	rebuildExplorerList()
end)

upParentBtn.MouseButton1Click:Connect(function()
	if selectedInstance and selectedInstance.Parent and selectedInstance ~= game then
		selectedInstance = selectedInstance.Parent
		rebuildExplorerList()
		renderRightDetails()
	end
end)

refreshBtn.MouseButton1Click:Connect(function()
	rebuildExplorerList()
	renderRightDetails()
end)

minBtn.MouseButton1Click:Connect(function()
	menuPopup.Visible = false
	mainFrame.Visible = false
	openMiniBtn.Visible = true
end)

openMiniBtn.MouseButton1Click:Connect(function()
	openMiniBtn.Visible = false
	mainFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
	clickObjectActive = false
	screenGui:Destroy()
end)

-- Inisialisasi awal
rebuildExplorerList()
renderRightDetails()
