-- [[ ROBLOX SELL LEMON / LEMONADE TYCOON - PREMIUM HUB ]] --
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local rs = game:GetService("RunService")
local vu = game:GetService("VirtualUser")

-- Konfigurasi Fitur
local flags = {
    autoBuyBuild = false,
    superSpeed = false,
    teleportTree = false
}

-- Anti-AFK (Biar bisa ditinggal tidur/sekolah tanpa terkena Kick)
plr.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Pembuatan GUI Utama
local sg = Instance.new("ScreenGui", (gethui and gethui()) or plr:WaitForChild("PlayerGui"))
sg.Name = "LemonGodHub"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 340, 0, 360)
main.Position = UDim2.new(0.5, -170, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 15) -- Tema Lemon (Kuning Gelap)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- UI Stroke Neon Effect
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2.5
rs.RenderStepped:Connect(function()
    stroke.Color = Color3.fromHSV((tick() * 0.12) % 1, 0.8, 1) -- Pelangi Smooth
end)

-- Title Sesuai Request
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -45, 0, 45)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Meknoyu GUI | Sell Lemons"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- Tombol X Close Di Atas Kanan
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 7)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 10)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Mini Button Bulat Nama Mekno Sesuai Request
local miniBtn = Instance.new("TextButton", sg)
miniBtn.Size = UDim2.new(0, 60, 0, 60)
miniBtn.Position = UDim2.new(0.85, 0, 0.2, 0)
miniBtn.Text = "Mekno"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 14
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 15)
miniBtn.Visible = false
miniBtn.Active = true
miniBtn.Draggable = true
local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(1, 0) -- Membuatnya bulat sempurna
local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Thickness = 2
miniStroke.Color = Color3.fromRGB(255, 255, 0)

-- Logika Buka Tutup Gui
closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    miniBtn.Visible = false
end)

-- Container Tombol
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1
local grid = Instance.new("UIGridLayout", container)
grid.CellSize = UDim2.new(1, 0, 0, 45)
grid.CellPadding = UDim2.new(0, 0, 0, 8)

-- Fungsi Pembuat Tombol Dengan Standard Text On/Off Toggle (Fixed)
local function makeToggle(text, flagKey, callback)
    local btn = Instance.new("TextButton", container)
    btn.Text = text .. " : OFF"
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 20)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        flags[flagKey] = not flags[flagKey]
        
        if flags[flagKey] then
            btn.Text = text .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(35, 90, 35) -- Warna Hijau saat aktif
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 20) -- Kembali ke warna awal
            btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        end
        
        callback(flags[flagKey])
    end)
end

-- =========================================================
--                     LOGIKA SCRIPT UTAMA
-- =========================================================

-- 1. AUTO BUY BUILD (RADIUS AURA 9999999 - TANPA COOLDOWN LAMA)
makeToggle("Auto Buy Build", "autoBuyBuild", function(state)
    if state then
        task.spawn(function()
            while flags.autoBuyBuild do
                for _, btn in pairs(workspace:GetDescendants()) do
                    if flags.autoBuyBuild == false then break end
                    if btn:IsA("BasePart") and btn.Name == "Button" then
                        -- Jangkauan luas sesuai request radius aura 9999999
                        local distance = (hrp.Position - btn.Position).Magnitude
                        if distance <= 9999999 then
                            local rf = btn:FindFirstChild("Upgrade") or btn.Parent:FindFirstChild("Upgrade") or btn:FindFirstChildWhichIsA("RemoteFunction")
                            
                            -- Spam touch interest instan tanpa jeda lama
                            firetouchinterest(hrp, btn, 0)
                            firetouchinterest(hrp, btn, 1)
                            
                            if rf and rf:IsA("RemoteFunction") and rf.Name == "Upgrade" then
                                task.spawn(function()
                                    pcall(function()
                                        rf:InvokeServer()
                                    end)
                                end)
                            end
                        end
                    end
                end
                
                -- Klik instant UI kancing bawaan player gui
                for _, g in pairs(plr.PlayerGui:GetDescendants()) do
                    if flags.autoBuyBuild == false then break end
                    if g:IsA("TextButton") or g:IsA("ImageButton") then
                        local name = g.Name:lower()
                        if name:find("upgrade") or name:find("buy") or name:find("speed") or name:find("capacity") then
                            pcall(function()
                                g:Activate()
                            end)
                        end
                    end
                end
                -- Cooldown nunggu dihilangkan/dibuat seminimal mungkin agar langsung tereksekusi konstan
                task.wait(0.01) 
            end
        end)
    end
end)

-- 2. TELEPORT TO TREE & AUTO CLICK ON CLICKPART
makeToggle("Teleport to Tree & Auto Click", "teleportTree", function(state)
    if state then
        task.spawn(function()
            while flags.teleportTree do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if flags.teleportTree == false then break end
                    if obj:IsA("BasePart") and obj.Name == "ClickFruitPart" and obj:FindFirstChildOfClass("ClickDetector") then
                        local cd = obj:FindFirstChildOfClass("ClickDetector")
                        
                        hrp.CFrame = obj.CFrame * CFrame.new(0, 0, 3)
                        task.wait(0.1)
                        
                        if cd then
                            fireclickdetector(cd)
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end)

-- 3. SPEED HACK BYPASS
makeToggle("Bypass Walkspeed x2", "superSpeed", function(state)
    if state then
        _G.SpeedHook = rs.RenderStepped:Connect(function()
            if hum and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 1.5)
            end
        end)
    else
        if _G.SpeedHook then _G.SpeedHook:Disconnect() end
    end
end)

-- Auto Update Karakter saat Respawn
plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
end)
