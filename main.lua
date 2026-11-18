-- ==========================================
-- SERVERBLIGHT HUB - Sidebar Menu
-- ==========================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SERVERBLIGHT HUB",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Noxis",
    ConfigurationSaving = { Enabled = true, FolderName = "BlightHub", FileName = "Main" },
    KeySystem = false,
    
    -- ВОТ ЭТА СТРОЧКА ДЕЛАЕТ ВКЛАДКИ СБОКУ
    SidebarLayout = true 
})

-- Функция для загрузки модулей с GitHub
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
VisualsTab:CreateButton({
    Name = "Enable ESP",
    Callback = function() loadFeature("esp") end,
})
VisualsTab:CreateButton({
    Name = "Enable Fullbright",
    Callback = function() loadFeature("fullbright") end,
})

-- 3. Farm
local FarmTab = Window:CreateTab("Farm", 4483362458)
FarmTab:CreateLabel("Map scripts will be here")

-- 4. Teleports
local TeleportsTab = Window:CreateTab("Teleports", 4483362458)

-- 5. Utility
local UtilityTab = Window:CreateTab("Utility", 4483362458)
UtilityTab:CreateButton({
    Name = "Enable Noclip",
    Callback = function() loadFeature("noclip") end,
})
UtilityTab:CreateButton({
    Name = "Enable Infinite Ammo",
    Callback = function() loadFeature("ammo") end,
})

-- 6. Configs
local ConfigsTab = Window:CreateTab("Configs", 4483362458)

-- 7. Credits
local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateLabel("Developer: Noxis")
CreditsTab:CreateLabel("UI Library: Rayfield")

print("[+] SERVERBLIGHT HUB (Sidebar) Loaded.")