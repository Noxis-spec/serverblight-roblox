-- ==========================================
-- SERVERBLIGHT HUB - Empty Template (with Main)
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
-- Сюда будем добавлять главные функции (быстрый старт, важные кнопки)

-- 2. Visual
local VisualTab = Window:CreateTab("Visual", 4483362458)
-- Сюда будем добавлять ESP, Fullbright и т.д.

-- 3. Farm
local FarmTab = Window:CreateTab("Farm", 4483362458)
-- Сюда будем добавлять кнопки авто-фарма

-- 4. Teleports
local TpTab = Window:CreateTab("Teleports", 4483362458)
-- Сюда будем добавлять кнопки телепортации

-- 5. Misc
local MiscTab = Window:CreateTab("Misc", 4483362458)
-- Сюда будем добавлять Noclip, Infinite Ammo и т.д.

-- 6. Info
local InfoTab = Window:CreateTab("Info", 4483362458)
-- Сюда будем добавлять информацию об авторе и ссылки

-- 7. Settings
local SettingsTab = Window:CreateTab("Settings", 4483362458)
-- Сюда будем добавлять настройки

print("[+] SERVERBLIGHT HUB (Template) Loaded.")