-- [[ MEKNOYU HUB | SPY ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")
local mouse = plr:GetMouse()

local spyLogs = {}
local selectedIndex = 0
local spyActive = true
local clickInspectActive = false

local function copyToClipboard(text)
	if not text or text == "" then return false end
	local clipboardFn = setclipboard or toclipboard or (Clipboard and Clipboard.set)
	if clipboardFn then
		local ok = pcall(clipboardFn, text)
		return ok
	end
	return false
end

local function safeGetFullName(inst)
	if not inst then return "nil" end
	local ok, res = pcall(function()
		return inst:GetFullName()
	end)
	return ok and res or tostring(inst.Name)
end

local function buildPathExpression(inst)
	if not inst or not inst.Parent then
		return "game"
	end
	if inst == game then
		return "game"
	end
	if inst == workspace then
		return "workspace"
	end

	local parts = {}
	local cur = inst
	while cur and cur ~= game do
		local nameStr = tostring(cur.Name)
		if nameStr:match("^[%a_][%w_]*$") then
			table.insert(parts, 1, "." .. nameStr)
		else
			table.insert(parts, 1, string.format("[%q]", nameStr))
		end
		cur = cur.Parent
	end
	return "game" .. table.concat(parts)
end

local function serializeArg(val, depth)
	depth = depth or 0
	if depth > 3 then
		return string.format("%q", tostring(val))
	end

	local t = typeof and typeof(val) or type(val)
	if t == "string" then
		return string.format("%q", val)
	elseif t == "number" or t == "boolean" then
		return tostring(val)
	elseif t == "nil" then
		return "nil"
	elseif t == "Instance" then
		return buildPathExpression(val)
	elseif t == "Vector3" then
		return string.format("Vector3.new(%s, %s, %s)", tostring(val.X), tostring(val.Y), tostring(val.Z))
	elseif t == "Vector2" then
		return string.format("Vector2.new(%s, %s)", tostring(val.X), tostring(val.Y))
	elseif t == "CFrame" then
		local c = { val:GetComponents() }
		return "CFrame.new(" .. table.concat(c, ", ") .. ")"
	elseif t == "Color3" then
		return string.format("Color3.new(%s, %s, %s)", tostring(val.R), tostring(val.G), tostring(val.B))
	elseif t == "UDim2" then
		return string.format("UDim2.new(%s, %s, %s, %s)", tostring(val.X.Scale), tostring(val.X.Offset), tostring(val.Y.Scale), tostring(val.Y.Offset))
	elseif t == "table" then
		local items = {}
		local count = 0
		for k, v in pairs(val) do
			count += 1
			if count > 15 then
				table.insert(items, "--[[ ... ]]")
				break
			end
			local keyFormatted = (type(k) == "string" and k:match("^[%a_][%w_]*$")) and (k .. " = ") or ("[" .. serializeArg(k, depth + 1) .. "] = ")
			table.insert(items, keyFormatted .. serializeArg(v, depth + 1))
		end
		return "{ " .. table.concat(items, ", ") .. " }"
	else
		return string.format("--[[ %s: %s ]]", t, tostring(val))
	end
end

local function formatArgsList(args)
	if not args or #args == 0 then
		return ""
	end
	local formatted = {}
	for i = 1, #args do
		table.insert(formatted, serializeArg(args[i], 0))
	end
	return table.concat(formatted, ", ")
end

-- // PEMBUATAN GUI MEKNOYU HUB | SPY //
local existingGui = (gethui and gethui():FindFirstChild("MeknoyuSpyGui")) or playerGui:FindFirstChild("MeknoyuSpyGui")
if existingGui then
	existingGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuSpyGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = (gethui and gethui()) or playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 460, 0, 320)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(27, 27, 34)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(0, 225, 165)

local bgGrad = Instance.new("UIGradient", mainFrame)
bgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(43, 43, 56)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(19, 19, 25))
})
bgGrad.Rotation = 90

-- Header
local headerFrame = Instance.new("Frame", mainFrame)
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 38)
headerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 46)
headerFrame.BorderSizePixel = 0
Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel", headerFrame)
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Meknoyu Hub | Spy"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", headerFrame)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -56, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(54, 54, 68)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton", headerFrame)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(175, 45, 55)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Minimize Floating
local openMiniBtn = Instance.new("TextButton", screenGui)
openMiniBtn.Name = "OpenMiniBtn"
openMiniBtn.Size = UDim2.new(0, 155, 0, 32)
openMiniBtn.Position = UDim2.new(0.5, -77, 0.1, 0)
openMiniBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
openMiniBtn.Text = "Meknoyu Hub | Spy"
openMiniBtn.TextColor3 = Color3.fromRGB(0, 225, 165)
openMiniBtn.Font = Enum.Font.GothamBold
openMiniBtn.TextSize = 11
openMiniBtn.Visible = false
openMiniBtn.Active = true
openMiniBtn.Draggable = true
Instance.new("UICorner", openMiniBtn).CornerRadius = UDim.new(0, 8)
local miniStroke = Instance.new("UIStroke", openMiniBtn)
miniStroke.Thickness = 1.5
miniStroke.Color = Color3.fromRGB(0, 225, 165)

-- Baris Kontrol Atas
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, -24, 0, 30)
topBar.Position = UDim2.new(0, 12, 0, 44)
topBar.BackgroundTransparency = 1

local topLayout = Instance.new("UIListLayout", topBar)
topLayout.FillDirection = Enum.FillDirection.Horizontal
topLayout.Padding = UDim.new(0, 6)
topLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function makeTopBtn(text, color, widthScale)
	local b = Instance.new("TextButton", topBar)
	b.Size = UDim2.new(widthScale, -4, 1, 0)
	b.BackgroundColor3 = color
	b.Text = text
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 10
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

local spyToggleBtn = makeTopBtn("Spy : ON", Color3.fromRGB(35, 145, 95), 0.25)
local clickSpyBtn = makeTopBtn("Click Spy : OFF", Color3.fromRGB(55, 85, 145), 0.27)
local copyFuncBtn = makeTopBtn("Copy", Color3.fromRGB(45, 115, 195), 0.24)
local execFuncBtn = makeTopBtn("Execute", Color3.fromRGB(195, 115, 30), 0.24)

-- Baris Bawah Aksi (Clear & Info)
local subBar = Instance.new("Frame", mainFrame)
subBar.Size = UDim2.new(1, -24, 0, 22)
subBar.Position = UDim2.new(0, 12, 0, 78)
subBar.BackgroundTransparency = 1

local clearBtn = Instance.new("TextButton", subBar)
clearBtn.Size = UDim2.new(0, 64, 1, 0)
clearBtn.Position = UDim2.new(1, -64, 0, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 60)
clearBtn.Text = "Clear"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 10
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 5)

local infoLabel = Instance.new("TextLabel", subBar)
infoLabel.Size = UDim2.new(1, -72, 1, 0)
infoLabel.Position = UDim2.new(0, 0, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Klik / picu sesuatu di game untuk memunculkan fungsi..."
infoLabel.TextColor3 = Color3.fromRGB(175, 235, 215)
infoLabel.Font = Enum.Font.Code
infoLabel.TextSize = 10
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextTruncate = Enum.TextTruncate.AtEnd

-- Body: Kiri Daftar Hasil Klik/Spy | Kanan Kode Fungsi Lengkap
local bodyFrame = Instance.new("Frame", mainFrame)
bodyFrame.Size = UDim2.new(1, -24, 1, -112)
bodyFrame.Position = UDim2.new(0, 12, 0, 104)
bodyFrame.BackgroundTransparency = 1

local listScroll = Instance.new("ScrollingFrame", bodyFrame)
listScroll.Name = "SpyList"
listScroll.Size = UDim2.new(0.42, -4, 1, 0)
listScroll.Position = UDim2.new(0, 0, 0, 0)
listScroll.BackgroundColor3 = Color3.fromRGB(19, 19, 25)
listScroll.BorderSizePixel = 0
listScroll.ScrollBarThickness = 3
listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", listScroll).CornerRadius = UDim.new(0, 7)

local listLayout = Instance.new("UIListLayout", listScroll)
listLayout.Padding = UDim.new(0, 3)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local codeScroll = Instance.new("ScrollingFrame", bodyFrame)
codeScroll.Name = "CodeView"
codeScroll.Size = UDim2.new(0.58, -4, 1, 0)
codeScroll.Position = UDim2.new(0.42, 8, 0, 0)
codeScroll.BackgroundColor3 = Color3.fromRGB(19, 19, 25)
codeScroll.BorderSizePixel = 0
codeScroll.ScrollBarThickness = 3
codeScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", codeScroll).CornerRadius = UDim.new(0, 7)

local codeBox = Instance.new("TextBox", codeScroll)
codeBox.Size = UDim2.new(1, -12, 1, -12)
codeBox.Position = UDim2.new(0, 6, 0, 6)
codeBox.BackgroundTransparency = 1
codeBox.Text = "-- Fungsi akan muncul di sini saat kamu mengklik / memicu sesuatu.\n-- Lalu tekan tombol 'Copy' atau 'Execute'."
codeBox.TextColor3 = Color3.fromRGB(235, 240, 248)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 10
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.MultiLine = true
codeBox.ClearTextOnFocus = false
codeBox.TextWrapped = false
codeBox.AutomaticSize = Enum.AutomaticSize.XY

local function refreshCodeCanvas()
	task.defer(function()
		local bounds = codeBox.TextBounds
		codeScroll.CanvasSize = UDim2.new(0, math.max(codeScroll.AbsoluteSize.X, bounds.X + 24), 0, math.max(codeScroll.AbsoluteSize.Y, bounds.Y + 24))
	end)
end

local function rebuildList()
	for _, ch in ipairs(listScroll:GetChildren()) do
		if ch:IsA("TextButton") then
			ch:Destroy()
		end
	end

	for i, item in ipairs(spyLogs) do
		local btn = Instance.new("TextButton", listScroll)
		btn.Size = UDim2.new(1, -6, 0, 28)
		btn.BackgroundColor3 = (i == selectedIndex) and Color3.fromRGB(28, 82, 68) or Color3.fromRGB(34, 34, 44)
		btn.Text = string.format("#%d %s", i, item.title)
		btn.TextColor3 = Color3.fromRGB(240, 245, 250)
		btn.Font = Enum.Font.Code
		btn.TextSize = 10
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.TextTruncate = Enum.TextTruncate.AtEnd
		btn.LayoutOrder = i
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

		btn.MouseButton1Click:Connect(function()
			selectedIndex = i
			codeBox.Text = item.code
			infoLabel.Text = string.format("[%d/%d] %s (%s)", i, #spyLogs, item.title, item.time)
			refreshCodeCanvas()
			rebuildList()
		end)
	end

	listScroll.CanvasSize = UDim2.new(0, 0, 0, #spyLogs * 31 + 8)
end

local function pushSpyEntry(title, generatedCode, runnerFn)
	if not spyActive then return end

	table.insert(spyLogs, {
		title = title,
		code = generatedCode,
		time = os.date("%H:%M:%S"),
		runner = runnerFn
	})
	selectedIndex = #spyLogs
	codeBox.Text = generatedCode
	infoLabel.Text = string.format("[%d/%d] %s (%s)", selectedIndex, #spyLogs, title, spyLogs[selectedIndex].time)
	refreshCodeCanvas()
	rebuildList()
end

local function generateFunctionForInstance(inst, extraArgs)
	local pathExpr = buildPathExpression(inst)
	local argStr = formatArgsList(extraArgs)

	if inst:IsA("RemoteEvent") then
		local code = string.format(
			"local args = { %s }\n%s:FireServer(unpack(args))",
			argStr,
			pathExpr
		)
		return code, function()
			if extraArgs and #extraArgs > 0 then
				inst:FireServer(unpack(extraArgs))
			else
				inst:FireServer()
			end
		end
	elseif inst:IsA("UnreliableRemoteEvent") then
		local code = string.format(
			"local args = { %s }\n%s:FireServer(unpack(args))",
			argStr,
			pathExpr
		)
		return code, function()
			if extraArgs and #extraArgs > 0 then
				inst:FireServer(unpack(extraArgs))
			else
				inst:FireServer()
			end
		end
	elseif inst:IsA("RemoteFunction") then
		local code = string.format(
			"local args = { %s }\nreturn %s:InvokeServer(unpack(args))",
			argStr,
			pathExpr
		)
		return code, function()
			if extraArgs and #extraArgs > 0 then
				return inst:InvokeServer(unpack(extraArgs))
			else
				return inst:InvokeServer()
			end
		end
	elseif inst:IsA("BindableEvent") then
		local code = string.format(
			"local args = { %s }\n%s:Fire(unpack(args))",
			argStr,
			pathExpr
		)
		return code, function()
			if extraArgs and #extraArgs > 0 then
				inst:Fire(unpack(extraArgs))
			else
				inst:Fire()
			end
		end
	elseif inst:IsA("BindableFunction") then
		local code = string.format(
			"local args = { %s }\nreturn %s:Invoke(unpack(args))",
			argStr,
			pathExpr
		)
		return code, function()
			if extraArgs and #extraArgs > 0 then
				return inst:Invoke(unpack(extraArgs))
			else
				return inst:Invoke()
			end
		end
	elseif inst:IsA("ProximityPrompt") then
		local code = string.format(
			"fireproximityprompt(%s)",
			pathExpr
		)
		return code, function()
			if fireproximityprompt then
				fireproximityprompt(inst)
			else
				inst:InputHoldBegin()
				task.wait(inst.HoldDuration or 0.1)
				inst:InputHoldEnd()
			end
		end
	elseif inst:IsA("ClickDetector") then
		local code = string.format(
			"fireclickdetector(%s)",
			pathExpr
		)
		return code, function()
			if fireclickdetector then
				fireclickdetector(inst)
			end
		end
	elseif inst:IsA("TextButton") or inst:IsA("ImageButton") then
		local code = string.format(
			"local btn = %s\nfiresignal(btn.MouseButton1Click)",
			pathExpr
		)
		return code, function()
			if firesignal then
				firesignal(inst.MouseButton1Click)
			end
		end
	elseif inst:IsA("BasePart") then
		local code = string.format(
			"local part = %s\nlocal hrp = game:GetService('Players').LocalPlayer.Character and game:GetService('Players').LocalPlayer.Character:FindFirstChild('HumanoidRootPart')\nif hrp then hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0) end",
			pathExpr
		)
		return code, function()
			local char = plr.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.CFrame = inst.CFrame + Vector3.new(0, 3, 0)
			end
		end
	else
		local code = string.format(
			"-- Target: %s (%s)\nlocal target = %s",
			tostring(inst.Name),
			tostring(inst.ClassName),
			pathExpr
		)
		return code, function()
			return inst
		end
	end
end

-- Hook remote & bindable calls saat terpicu di game
if hookmetamethod and getnamecallmethod then
	local oldNamecall
	oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		local args = { ... }

		if spyActive and not checkcaller() and typeof(self) == "Instance" then
			if (method == "FireServer" and (self:IsA("RemoteEvent") or self:IsA("UnreliableRemoteEvent")))
				or (method == "InvokeServer" and self:IsA("RemoteFunction"))
				or (method == "Fire" and self:IsA("BindableEvent"))
				or (method == "Invoke" and self:IsA("BindableFunction")) then

				task.defer(function()
					local codeStr, runner = generateFunctionForInstance(self, args)
					pushSpyEntry(string.format("[%s] %s", method, self.Name), codeStr, runner)
				end)
			end
		end

		return oldNamecall(self, ...)
	end)
end

-- Saat mengklik objek di world ketika Click Spy aktif
mouse.Button1Down:Connect(function()
	if not (spyActive and clickInspectActive) then return end
	local target = mouse.Target
	if target and target:IsA("Instance") and not target:IsDescendantOf(screenGui) then
		local codeStr, runner = generateFunctionForInstance(target, nil)
		pushSpyEntry("[Click] " .. target.Name, codeStr, runner)
	end
end)

-- Saat mengklik tombol UI di PlayerGui
local hookedButtons = {}
local function hookGuiButton(guiObj)
	if hookedButtons[guiObj] then return end
	if guiObj:IsDescendantOf(screenGui) then return end
	if guiObj:IsA("TextButton") or guiObj:IsA("ImageButton") then
		hookedButtons[guiObj] = true
		guiObj.MouseButton1Click:Connect(function()
			if not spyActive then return end
			local codeStr, runner = generateFunctionForInstance(guiObj, nil)
			pushSpyEntry("[UI Click] " .. guiObj.Name, codeStr, runner)
		end)
	end
end

for _, d in ipairs(playerGui:GetDescendants()) do
	hookGuiButton(d)
end

playerGui.DescendantAdded:Connect(function(d)
	hookGuiButton(d)
end)

-- Tombol Copy dari fungsi yang tampil
copyFuncBtn.MouseButton1Click:Connect(function()
	local textToCopy = (selectedIndex > 0 and spyLogs[selectedIndex] and spyLogs[selectedIndex].code) or codeBox.Text
	local ok = copyToClipboard(textToCopy)
	copyFuncBtn.Text = ok and "Copied!" or "No Clipboard"
	task.delay(1.1, function()
		copyFuncBtn.Text = "Copy"
	end)
end)

-- Tombol Execute dari fungsi yang tampil
execFuncBtn.MouseButton1Click:Connect(function()
	local entry = (selectedIndex > 0 and spyLogs[selectedIndex]) or nil
	local currentCode = codeBox.Text

	if entry and entry.code == currentCode and type(entry.runner) == "function" then
		local ok, err = pcall(entry.runner)
		execFuncBtn.Text = ok and "Executed!" or "Err"
		if not ok then
			infoLabel.Text = "Execute error: " .. tostring(err)
		end
	elseif currentCode ~= "" then
		local fn, loadErr = loadstring(currentCode)
		if fn then
			local ok, runErr = pcall(fn)
			execFuncBtn.Text = ok and "Executed!" or "Err"
			if not ok then
				infoLabel.Text = "Execute error: " .. tostring(runErr)
			end
		else
			execFuncBtn.Text = "Err"
			infoLabel.Text = "Syntax error: " .. tostring(loadErr)
		end
	end

	task.delay(1.1, function()
		execFuncBtn.Text = "Execute"
	end)
end)

spyToggleBtn.MouseButton1Click:Connect(function()
	spyActive = not spyActive
	spyToggleBtn.Text = "Spy : " .. (spyActive and "ON" or "OFF")
	TweenService:Create(spyToggleBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = spyActive and Color3.fromRGB(35, 145, 95) or Color3.fromRGB(120, 55, 65)
	}):Play()
end)

clickSpyBtn.MouseButton1Click:Connect(function()
	clickInspectActive = not clickInspectActive
	clickSpyBtn.Text = "Click Spy : " .. (clickInspectActive and "ON" or "OFF")
	TweenService:Create(clickSpyBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = clickInspectActive and Color3.fromRGB(45, 130, 200) or Color3.fromRGB(55, 85, 145)
	}):Play()
end)

clearBtn.MouseButton1Click:Connect(function()
	spyLogs = {}
	selectedIndex = 0
	codeBox.Text = "-- Log dibersihkan. Klik / picu sesuatu di game untuk memunculkan fungsi."
	infoLabel.Text = "Klik / picu sesuatu di game untuk memunculkan fungsi..."
	refreshCodeCanvas()
	rebuildList()
end)

minBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	openMiniBtn.Visible = true
end)

openMiniBtn.MouseButton1Click:Connect(function()
	openMiniBtn.Visible = false
	mainFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
	spyActive = false
	clickInspectActive = false
	screenGui:Destroy()
end)
