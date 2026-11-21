-- [[ PREMIUM USER LIST ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PremiumUsers = {
    "Buulk00ld",
    "ExamplePremiumUser1",
    "ExamplePremiumUser2",
}

local function checkPremiumUser(targetPlayer)
    local plr = targetPlayer or LocalPlayer
    if not plr then
        return false
    end

    local username = string.lower(plr.Name)
    for _, premName in ipairs(PremiumUsers) do
        if string.lower(premName) == username then
            return true
        end
    end

    return false
end

local env = (getgenv and getgenv()) or _G
env.PremiumUsers = PremiumUsers
env.IsPremiumUser = checkPremiumUser

return checkPremiumUser(LocalPlayer)
