-- [[ MEKNOYU HUB | COPY ANYTHING ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

local capturedScripts = {}
local activeIndex = 0
local isCapturing = true
local bypassKeyEnabled = false

local function copyToClipboard(text)
	if not text or text == "" then return false end
	local clipboardFn = setclipboard or toclipboard or (Clipboard and Clipboard.set)
	if clipboardFn then
		local ok = pcall(clipboardFn, text)
		return ok
	end
	return false
end

local function recordScript(sourceCode, label)
	if type(sourceCode) ~= "string" or sourceCode == "" then return end

	if #capturedScripts > 0 and capturedScripts[#capturedScripts].code == sourceCode then
		activeIndex = #capturedScripts
		return
	end

	table.insert(capturedScripts, {
		name = label or ("Captured Script #" .. tostring(#capturedScripts + 1)),
		code = sourceCode,
		time = os.date("%H:%M:%S")
	})
	activeIndex = #capturedScripts
end

local function decodeHexEscapes(str)
	return (str:gsub("\\x(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end))
end

local function decodeDecimalEscapes(str)
	return (str:gsub("\\(%d%d?%d?)", function(dec)
		local n = tonumber(dec, 10)
		if n and n >= 0 and n <= 255 then
			return string.char(n)
		end
		return "\\" .. dec
	end))
end

local function decodeBase64(data)
	local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	data = data:gsub("[^" .. b64chars .. "=]", "")
	if #data < 4 or (#data % 4) ~= 0 then return nil end
	return (data:gsub(".", function(x)
		if x == "=" then return "" end
		local r, f = "", (b64chars:find(x) - 1)
		for i = 6, 1, -1 do
			r = r .. (f % 2^i - f % 2^(i - 1) > 0 and "1" or "0")
		end
		return r
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
		if #x ~= 8 then return "" end
		local c = 0
		for i = 1, 8 do
			c = c + (x:sub(i, i) == "1" and 2^(8 - i) or 0)
		end
		return string.char(c)
	end))
end

local function deobfuscateCode(raw)
	if type(raw) ~= "string" or raw == "" then return raw end
	local out = raw

	-- 1. Decode escape \xHH dan \DDD pada string literal
	out = decodeHexEscapes(out)
	out = decodeDecimalEscapes(out)

	-- 2. Gabungkan string concatenation ("a" .. "b") yang terpecah
	for _ = 1, 5 do
		local nextOut = out:gsub('"([^"\\]*)"%s*%.%.%s*"([^"\\]*)"', '"%1%2"')
		nextOut = nextOut:gsub("'([^'\\]*)'%s*%.%.%s*'([^'\\']*)'", "'%1%2'")
		if nextOut == out then break end
		out = nextOut
	end

	-- 3. Decode string.char(n1, n2, ...)
	out = out:gsub("string%.char%(([%d%s,]+)%)", function(nums)
		local chars = {}
		local valid = true
		for numStr in nums:gmatch("%d+") do
			local code = tonumber(numStr)
			if not code or code < 0 or code > 255 then
				valid = false
				break
			end
			table.insert(chars, string.char(code))
		end
		if valid and #chars > 0 then
			return string.format("%q", table.concat(chars))
		end
		return "string.char(" .. nums .. ")"
	end)

	-- 4. Decode Base64 jika terdeteksi di dalam string
	out = out:gsub('(["\'])([A-Za-z0-9+/=]+)%1', function(quote, b64)
		if #b64 >= 12 and (#b64 % 4) == 0 then
			local decoded = decodeBase64(b64)
			if decoded and decoded:match("[%a_][%w_%s%(%)%.=:%[%]\"']+") and not decoded:find("[^\9\10\13\32-\126]") then
				return quote .. decoded .. quote
			end
		end
		return quote .. b64 .. quote
	end)

	-- 5. Rapikan whitespace berlebih pada barisan panjang
	if #out > 4000 and not out:find("\n") then
		out = out:gsub(";%s*", ";\n")
		out = out:gsub("%s+then%s+", " then\n\t")
		out = out:gsub("%s+do%s+", " do\n\t")
		out = out:gsub("%s+end%s*", "\nend\n")
	end

	return out
end

local function applyKeyBypassToSource(src)
	if type(src) ~= "string" or src == "" then return src end
	local patched = src

	-- Paksa kondisi pengecekan key menjadi true jika berupa ekspresi perbandingan key
	patched = patched:gsub("if%s+([%w_%.]+)%s*==%s*(['\"][^'\"]+['\"])%s+then", "if true then -- bypassed (%1)")
	patched = patched:gsub("if%s+(['\"][^'\"]+['\"])%s*==%s*([%w_%.]+)%s+then", "if true then -- bypassed (%2)")
	patched = patched:gsub("if%s+not%s+([%w_]*[Kk]ey[%w_]*)%s+then", "if false then -- bypassed (%1)")

	return patched
end

local function unlockKeyGuisInPlayerGui()
	for _, gui in ipairs(playerGui:GetDescendants()) do
		if gui:IsA("ScreenGui") or gui:IsA("Frame") then
			local n = string.lower(gui.Name)
			if n:find("key") or n:find("gate") or n:find("verify") or n:find("auth") then
				if gui:IsA("ScreenGui") then
					gui.Enabled = false
				else
					gui.Visible = false
				end
			end
		end
	end
end

-- // PEMBUATAN GUI MEKNOYU HUB | COPY ANYTHING //
local existingGui = (gethui and gethui():FindFirstChild("MeknoyuCopyAnythingGui")) or playerGui:FindFirstChild("MeknoyuCopyAnythingGui")
if existingGui then
	existingGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeknoyuCopyAnythingGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = (gethui and gethui()) or playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 440, 0, 325)
mainFrame.Position = UDim2.new(0.5, -220, 0.5, -162)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(0, 210, 255)

local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 58)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 26))
})
gradient.Rotation = 90

-- Header
local headerFrame = Instance.new("Frame", mainFrame)
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 38)
headerFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 48)
headerFrame.BorderSizePixel = 0
Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel", headerFrame)
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Meknoyu Hub | Copy Anything"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", headerFrame)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -56, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
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
openMiniBtn.Size = UDim2.new(0, 165, 0, 32)
openMiniBtn.Position = UDim2.new(0.5, -82, 0.1, 0)
openMiniBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
openMiniBtn.Text = "Meknoyu Hub | Copy"
openMiniBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
openMiniBtn.Font = Enum.Font.GothamBold
openMiniBtn.TextSize = 11
openMiniBtn.Visible = false
openMiniBtn.Active = true
openMiniBtn.Draggable = true
Instance.new("UICorner", openMiniBtn).CornerRadius = UDim.new(0, 8)
local miniStroke = Instance.new("UIStroke", openMiniBtn)
miniStroke.Thickness = 1.5
miniStroke.Color = Color3.fromRGB(0, 210, 255)

-- Baris Tombol Aksi Atas
local topActionBar = Instance.new("Frame", mainFrame)
topActionBar.Name = "TopActionBar"
topActionBar.Size = UDim2.new(1, -24, 0, 32)
topActionBar.Position = UDim2.new(0, 12, 0, 44)
topActionBar.BackgroundTransparency = 1

local actionLayout = Instance.new("UIListLayout", topActionBar)
actionLayout.FillDirection = Enum.FillDirection.Horizontal
actionLayout.Padding = UDim.new(0, 6)
actionLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function makeActionBtn(text, bgColor, widthScale, parent)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(widthScale, -4, 1, 0)
	btn.BackgroundColor3 = bgColor
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	return btn
end

local showScriptBtn = makeActionBtn("Show Script", Color3.fromRGB(45, 115, 195), 0.34, topActionBar)
local copyBtn = makeActionBtn("Copy", Color3.fromRGB(35, 145, 90), 0.33, topActionBar)
local clearBtn = makeActionBtn("Clear", Color3.fromRGB(120, 55, 65), 0.33, topActionBar)

-- Baris Tombol Deobfuscator & Bypass Key
local extraActionBar = Instance.new("Frame", mainFrame)
extraActionBar.Name = "ExtraActionBar"
extraActionBar.Size = UDim2.new(1, -24, 0, 32)
extraActionBar.Position = UDim2.new(0, 12, 0, 80)
extraActionBar.BackgroundTransparency = 1

local extraLayout = Instance.new("UIListLayout", extraActionBar)
extraLayout.FillDirection = Enum.FillDirection.Horizontal
extraLayout.Padding = UDim.new(0, 6)
extraLayout.SortOrder = Enum.SortOrder.LayoutOrder

local deobfBtn = makeActionBtn("Deobfuscator", Color3.fromRGB(130, 65, 195), 0.5, extraActionBar)
local bypassKeyBtn = makeActionBtn("Bypass Key : OFF", Color3.fromRGB(195, 115, 30), 0.5, extraActionBar)

-- Info Status & Navigasi Script yang Tertangkap
local statusBar = Instance.new("Frame", mainFrame)
statusBar.Name = "StatusBar"
statusBar.Size = UDim2.new(1, -24, 0, 24)
statusBar.Position = UDim2.new(0, 12, 0, 116)
statusBar.BackgroundColor3 = Color3.fromRGB(36, 36, 46)
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 6)

local prevBtn = Instance.new("TextButton", statusBar)
prevBtn.Size = UDim2.new(0, 26, 1, -4)
prevBtn.Position = UDim2.new(0, 2, 0, 2)
prevBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
prevBtn.Text = "<"
prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prevBtn.Font = Enum.Font.GothamBold
prevBtn.TextSize = 11
Instance.new("UICorner", prevBtn).CornerRadius = UDim.new(0, 5)

local statusLabel = Instance.new("TextLabel", statusBar)
statusLabel.Size = UDim2.new(1, -60, 1, 0)
statusLabel.Position = UDim2.new(0, 30, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Menunggu script lain di-execute... (0)"
statusLabel.TextColor3 = Color3.fromRGB(185, 225, 255)
statusLabel.Font = Enum.Font.Code
statusLabel.TextSize = 10
statusLabel.TextTruncate = Enum.TextTruncate.AtEnd

local nextBtn = Instance.new("TextButton", statusBar)
nextBtn.Size = UDim2.new(0, 26, 1, -4)
nextBtn.Position = UDim2.new(1, -28, 0, 2)
nextBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
nextBtn.Text = ">"
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.Font = Enum.Font.GothamBold
nextBtn.TextSize = 11
Instance.new("UICorner", nextBtn).CornerRadius = UDim.new(0, 5)

-- Area Tampilan Script Asli Lengkap
local codeScroll = Instance.new("ScrollingFrame", mainFrame)
codeScroll.Name = "CodeScroll"
codeScroll.Size = UDim2.new(1, -24, 1, -158)
codeScroll.Position = UDim2.new(0, 12, 0, 146)
codeScroll.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
codeScroll.BorderSizePixel = 0
codeScroll.ScrollBarThickness = 4
codeScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", codeScroll).CornerRadius = UDim.new(0, 8)

local codeBox = Instance.new("TextBox", codeScroll)
codeBox.Name = "CodeBox"
codeBox.Size = UDim2.new(1, -12, 1, -12)
codeBox.Position = UDim2.new(0, 6, 0, 6)
codeBox.BackgroundTransparency = 1
codeBox.Text = "-- Execute script lain, lalu tekan tombol 'Show Script' atau script akan muncul otomatis di sini."
codeBox.TextColor3 = Color3.fromRGB(235, 240, 248)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 11
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

local function displayScriptAtIndex(idx)
	if #capturedScripts == 0 then
		activeIndex = 0
		statusLabel.Text = "Menunggu script lain di-execute... (0)"
		codeBox.Text = "-- Belum ada script lain yang tertangkap."
		refreshCodeCanvas()
		return
	end

	idx = math.clamp(idx, 1, #capturedScripts)
	activeIndex = idx
	local entry = capturedScripts[activeIndex]
	statusLabel.Text = string.format("[%d/%d] %s (%s)", activeIndex, #capturedScripts, entry.name, entry.time)
	codeBox.Text = entry.code
	refreshCodeCanvas()
end

-- Hook loadstring agar setiap eksekusi script lain terekam kode aslinya
local oldLoadstring = loadstring
if type(oldLoadstring) == "function" then
	loadstring = function(src, chunkName)
		local finalSrc = src
		if isCapturing and type(src) == "string" and src ~= "" then
			recordScript(src, tostring(chunkName or "loadstring"))
			displayScriptAtIndex(activeIndex)
			if bypassKeyEnabled then
				finalSrc = applyKeyBypassToSource(src)
			end
		end
		return oldLoadstring(finalSrc, chunkName)
	end
end

-- Hook getgenv().loadstring jika executor menyimpannya di getgenv()
local env = (getgenv and getgenv()) or _G
if env and type(env.loadstring) == "function" and env.loadstring ~= loadstring then
	local oldEnvLoadstring = env.loadstring
	env.loadstring = function(src, chunkName)
		local finalSrc = src
		if isCapturing and type(src) == "string" and src ~= "" then
			recordScript(src, tostring(chunkName or "env.loadstring"))
			displayScriptAtIndex(activeIndex)
			if bypassKeyEnabled then
				finalSrc = applyKeyBypassToSource(src)
			end
		end
		return oldEnvLoadstring(finalSrc, chunkName)
	end
end

-- Hook game:HttpGet untuk merekam isi script yang diunduh saat di-execute
local oldHttpGet = game.HttpGet
local namecallHooked = false
if hookmetamethod and getnamecallmethod then
	namecallHooked = true
	local oldNamecall
	oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		local result = oldNamecall(self, ...)
		if isCapturing and self == game and (method == "HttpGet" or method == "HttpGetAsync") and type(result) == "string" and #result > 0 then
			local args = {...}
			recordScript(result, tostring(args[1] or "HttpGet"))
			task.defer(function()
				displayScriptAtIndex(activeIndex)
			end)
		end
		return result
	end)
end

if not namecallHooked and type(oldHttpGet) == "function" then
	pcall(function()
		game.HttpGet = function(self, url, ...)
			local result = oldHttpGet(self, url, ...)
			if isCapturing and type(result) == "string" and #result > 0 then
				recordScript(result, tostring(url or "HttpGet"))
				displayScriptAtIndex(activeIndex)
			end
			return result
		end
	end)
end

-- Tombol Show Script
showScriptBtn.MouseButton1Click:Connect(function()
	if #capturedScripts > 0 then
		local targetIdx = activeIndex > 0 and activeIndex or #capturedScripts
		displayScriptAtIndex(targetIdx)
	else
		if codeBox.Text ~= "" then
			refreshCodeCanvas()
		end
		statusLabel.Text = "Belum ada script lain yang di-execute."
	end

	TweenService:Create(showScriptBtn, TweenInfo.new(0.12), {
		BackgroundColor3 = Color3.fromRGB(70, 155, 240)
	}):Play()
	task.delay(0.15, function()
		TweenService:Create(showScriptBtn, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(45, 115, 195)
		}):Play()
	end)
end)

-- Tombol Copy
copyBtn.MouseButton1Click:Connect(function()
	local textToCopy = ""
	if activeIndex > 0 and capturedScripts[activeIndex] then
		textToCopy = capturedScripts[activeIndex].code
	else
		textToCopy = codeBox.Text
	end

	local copied = copyToClipboard(textToCopy)
	if copied then
		copyBtn.Text = "Copied!"
		TweenService:Create(copyBtn, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.fromRGB(45, 200, 120)
		}):Play()
	else
		copyBtn.Text = "No Clipboard"
		TweenService:Create(copyBtn, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.fromRGB(190, 120, 35)
		}):Play()
	end

	task.delay(1.1, function()
		copyBtn.Text = "Copy"
		TweenService:Create(copyBtn, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(35, 145, 90)
		}):Play()
	end)
end)

-- Tombol Deobfuscator
deobfBtn.MouseButton1Click:Connect(function()
	local sourceText = (activeIndex > 0 and capturedScripts[activeIndex] and capturedScripts[activeIndex].code) or codeBox.Text
	local cleaned = deobfuscateCode(sourceText)
	codeBox.Text = cleaned
	if activeIndex > 0 and capturedScripts[activeIndex] then
		capturedScripts[activeIndex].code = cleaned
	end
	refreshCodeCanvas()
	statusLabel.Text = "Deobfuscator applied!"

	TweenService:Create(deobfBtn, TweenInfo.new(0.12), {
		BackgroundColor3 = Color3.fromRGB(165, 95, 235)
	}):Play()
	task.delay(0.15, function()
		TweenService:Create(deobfBtn, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(130, 65, 195)
		}):Play()
	end)
end)

-- Tombol Bypass Key
bypassKeyBtn.MouseButton1Click:Connect(function()
	bypassKeyEnabled = not bypassKeyEnabled
	bypassKeyBtn.Text = "Bypass Key : " .. (bypassKeyEnabled and "ON" or "OFF")
	TweenService:Create(bypassKeyBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = bypassKeyEnabled and Color3.fromRGB(35, 145, 90) or Color3.fromRGB(195, 115, 30)
	}):Play()

	if bypassKeyEnabled then
		unlockKeyGuisInPlayerGui()
		if activeIndex > 0 and capturedScripts[activeIndex] then
			local bypassed = applyKeyBypassToSource(capturedScripts[activeIndex].code)
			capturedScripts[activeIndex].code = bypassed
			codeBox.Text = bypassed
			refreshCodeCanvas()
		end
		statusLabel.Text = "Bypass Key aktif!"
	else
		statusLabel.Text = "Bypass Key dimatikan."
	end
end)

-- Tombol Clear
clearBtn.MouseButton1Click:Connect(function()
	capturedScripts = {}
	activeIndex = 0
	displayScriptAtIndex(0)
end)

prevBtn.MouseButton1Click:Connect(function()
	if #capturedScripts > 0 then
		local nextIdx = activeIndex - 1
		if nextIdx < 1 then nextIdx = #capturedScripts end
		displayScriptAtIndex(nextIdx)
	end
end)

nextBtn.MouseButton1Click:Connect(function()
	if #capturedScripts > 0 then
		local nextIdx = activeIndex + 1
		if nextIdx > #capturedScripts then nextIdx = 1 end
		displayScriptAtIndex(nextIdx)
	end
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
	isCapturing = false
	screenGui:Destroy()
end)
