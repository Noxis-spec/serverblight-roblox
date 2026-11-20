-- Noclip Module

local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

_G.BlightNoclip = _G.BlightNoclip or { Enabled = true }

RunService.Stepped:Connect(function()
    if _G.BlightNoclip.Enabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

print("Noclip loaded.")