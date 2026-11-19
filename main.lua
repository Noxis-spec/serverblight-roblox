-- ==========================================
-- SERVERBLIGHT HUB - Main Interface
-- ==========================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Инициализация настроек для модулей
_G.BlightESP = {
    Enabled = false,
    ShowHealth = true,
}
_G.EngineerESP = {
    Enabled = false,
}

local Window = Rayfield:CreateWindow({
    Name = "SERVERBLIGHT HUB",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Noxis",
    ConfigurationSaving = { Enabled = true, FolderName = "BlightHub", FileName = "Main" },
    KeySystem = false
})

-- Функция загрузки модулей с GitHub
local function loadFeature(featureName)
    local url = "https://raw.githubusercontent.com/Noxis-spec/serverblight-roblox/main/features/" .. featureName .. ".lua"
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        Rayfield:Notify({ Title = "Error", Content = "Failed to load " .. featureName, Duration = 3 })
    end
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

-- 6. Configs
local ConfigsTab = Window:CreateTab("Configs", 4483362458)

-- 7. Credits
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateLabel("Developer: Noxis")
CreditsTab:CreateLabel("UI Library: Rayfield")

print("[+] SERVERBLIGHT HUB Loaded.")