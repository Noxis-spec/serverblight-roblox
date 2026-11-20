-- ==========================================
-- SERVERBLIGHT HUB - Main Interface
-- ==========================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Настройки для модулей
_G.BlightESP = { Enabled = false, ShowHealth = true }
_G.EngineerESP = { Enabled = false }
_G.BlightNoclip = { Enabled = false }
_G.BlightAmmo = { Enabled = false }
_G.BlightSpeed = { Speed = 16, Jump = 50 }

local Window = Rayfield:CreateWindow({
    Name = "SERVERBLIGHT HUB",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Noxis",
    ConfigurationSaving = { Enabled = true, FolderName = "BlightHub", FileName = "Main" },
    KeySystem = false
})
-- Doublecross Auto Farm Logic
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Координаты для Даблкросса
local SAFE_ZONE_POS = Vector3.new(-145.08, 910.79, 20.61)
local platform = nil

local function createFloor()
    if platform and platform.Parent then return end
    platform = Instance.new("Part")
    platform.Name = "SafeZoneFloor"
    platform.Size = Vector3.new(20, 1, 20) 
    platform.Position = SAFE_ZONE_POS - Vector3.new(0, 3, 0) 
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1 
    platform.Parent = Workspace
end

local function teleportTo(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function getBriefcase(name)
    local map = Workspace:FindFirstChild("Map")
    local briefcases = map and map:FindFirstChild("Briefcases")
    return briefcases and briefcases:FindFirstChild(name)
end

local function pressE()
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

local function doOneCycle()
    local blueIntel = getBriefcase("Blue")
    local redIntel = getBriefcase("Red")
    if not blueIntel or not redIntel then return false end

    teleportTo(blueIntel.Position + Vector3.new(0, 5, 0))
    task.wait(0.8)
    pressE()
    task.wait(0.8)
    
    teleportTo(redIntel.Position + Vector3.new(0, 2, 0))
    task.wait(1.5)
    
    teleportTo(SAFE_ZONE_POS)
    task.wait(1)
    return true
end

-- Запускаем в фоне
task.spawn(function()
    createFloor()
    local count = 0
    while count < 3 do
        if getBriefcase("Blue") then
            doOneCycle()
            count = count + 1
        end
        task.wait(1)
    end
end)

-- Функция загрузки модулей с GitHub
local function loadFeature(featureName)
    local url = "https://raw.githubusercontent.com/Noxis-spec/serverblight-roblox/main/features/" .. featureName .. ".lua"
    pcall(function() 
        loadstring(game:HttpGet(url))() 
    end)
end

-- 1. Main
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateLabel("Welcome to SERVERBLIGHT HUB")

-- 2. Visuals
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- 3. Farm
local FarmTab = Window:CreateTab("Farm", 4483362458)

-- 4. Teleports
local TeleportsTab = Window:CreateTab("Teleports", 4483362458)

-- 5. Utility
local UtilityTab = Window:CreateTab("Utility", 4483362458)

-- [ESP Toggles]
UtilityTab:CreateToggle({
    Name = "Enable Player ESP",
    CurrentValue = false,
    Flag = "ESP_Enabled",
    Callback = function(state)
        _G.BlightESP.Enabled = state
        if state and not _G.ESP_Loaded then 
            loadFeature("esp") 
            _G.ESP_Loaded = true 
        end
    end,
})

UtilityTab:CreateToggle({
    Name = "Show Health Bars",
    CurrentValue = true,
    Flag = "ESP_Health",
    Callback = function(state) 
        _G.BlightESP.ShowHealth = state 
    end,
})

UtilityTab:CreateToggle({
    Name = "Engineer Buildings ESP",
    CurrentValue = false,
    Flag = "Engi_ESP_Enabled",
    Callback = function(state)
        _G.EngineerESP.Enabled = state
        if state and not _G.EngiESP_Loaded then 
            loadFeature("engineer_esp") 
            _G.EngiESP_Loaded = true 
        end
    end,
})

-- [Utility Toggles]
UtilityTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip_Enabled",
    Callback = function(state)
        _G.BlightNoclip.Enabled = state
        if state and not _G.Noclip_Loaded then 
            loadFeature("noclip") 
            _G.Noclip_Loaded = true 
        end
    end,
})

UtilityTab:CreateToggle({
    Name = "Auto Reload",
    CurrentValue = false,
    Flag = "Ammo_Enabled",
    Callback = function(state)
        _G.BlightAmmo.Enabled = state
        if state and not _G.Ammo_Loaded then 
            loadFeature("ammo") 
            _G.Ammo_Loaded = true 
        end
    end,
})

UtilityTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        _G.BlightSpeed.Speed = Value
        if not _G.Move_Loaded then 
            loadFeature("movement") 
            _G.Move_Loaded = true 
        end
    end,
})

UtilityTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 200},
    Increment = 10,
    Suffix = " Power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        _G.BlightSpeed.Jump = Value
        if not _G.Move_Loaded then 
            loadFeature("movement") 
            _G.Move_Loaded = true 
        end
    end,
})

-- 6. Configs
local ConfigsTab = Window:CreateTab("Configs", 4483362458)

-- 7. Credits
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateLabel("Developer: Noxis")
CreditsTab:CreateLabel("UI Library: Rayfield")

print("[+] SERVERBLIGHT HUB Loaded.")