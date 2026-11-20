-- Speed & Jump Power

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.BlightSpeed = _G.BlightSpeed or { Speed = 16, Jump = 50 }

task.spawn(function()
    while task.wait(0.5) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = _G.BlightSpeed.Speed
            char.Humanoid.JumpPower = _G.BlightSpeed.Jump
        end
    end
end)

print("Movement loaded.")