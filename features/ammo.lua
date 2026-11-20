-- Auto Reload Module

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

_G.BlightAmmo = _G.BlightAmmo or { Enabled = true }
local processedWeapons = {}

local function pressReloadKey()
    -- Нажимаем клавишу R для перезарядки
    VirtualInputManager:SendKeyEvent(true, "R", false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, "R", false, game)
end

local function checkWeapon(tool)
    if processedWeapons[tool] then return end
    if tool:IsA("Tool") and tool:FindFirstChild("Values") then
        local ammo = tool.Values:FindFirstChild("Ammo")
        
        if ammo then
            processedWeapons[tool] = true
            
            -- Слушаем изменения патронов в магазине
            ammo.Changed:Connect(function()
                -- Если авто-перезарядка включена и патроны кончились
                if _G.BlightAmmo.Enabled and ammo.Value <= 0 then
                    pressReloadKey()
                end
            end)
        end
    end
end

-- Проверяем новые пушки, которые попадают в инвентарь
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if _G.BlightAmmo.Enabled then checkWeapon(child) end
end)

-- Проверяем пушки, которые уже в руках
task.spawn(function()
    while task.wait(1) do
        if _G.BlightAmmo.Enabled then
            for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do checkWeapon(item) end
            if LocalPlayer.Character then
                for _, item in pairs(LocalPlayer.Character:GetChildren()) do checkWeapon(item) end
            end
        end
    end
end)

print("Auto Reload loaded.")