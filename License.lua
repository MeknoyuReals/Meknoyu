-- Kamu cukup jalankan baris ini di Delta, tidak perlu bikin file di ZArchiver lagi
local LicenseSystem = loadstring(game:HttpGet("PASTE_LINK_RAW_PASTEBIN_KAMU_DISINI"))()

local MyKey = "FREE-MEKNOYU" -- Key yang ingin kamu tes
local success, message = LicenseSystem.VerifyKey(MyKey)

if success then
    print(message)
    -- Jalankan script premium kamu di bawah ini
else
    game.Players.LocalPlayer:Kick("Akses Ditolak: " .. message)
end
