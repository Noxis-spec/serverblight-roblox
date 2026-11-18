-- ==========================================
-- SERVERBLIGHT HUB - Template (Optimized Tabs)
-- ==========================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SERVERBLIGHT HUB",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Noxis",
    ConfigurationSaving = { Enabled = true, FolderName = "BlightHub", FileName = "Main" },
    KeySystem = false
})

-- 1. Main
local MainTab = Window:CreateTab("Main", 4483362458)

-- 2. Visuals
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- 3. Farm
local FarmTab = Window:CreateTab("Farm", 4483362458)

-- 4. Teleports
local TeleportsTab = Window:CreateTab("Teleports", 4483362458)

-- 5. Utility
local UtilityTab = Window:CreateTab("Utility", 4483362458)

-- 6. Configs
local ConfigsTab = Window:CreateTab("Configs", 4483362458)

-- 7. Credits
local CreditsTab = Window:CreateTab("Credits", 4483362458)

print("[+] SERVERBLIGHT HUB (Optimized Template) Loaded.")