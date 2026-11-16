-- ==========================================
-- SERVERBLIGHT Utility - Rayfield Gen2 (Juicy Edition)
-- ==========================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- CONFIGURATION
-- ==========================================
local Config = {
    MONSTER_NAMES = {"Serverblight", "Blight"},
    BASE_POSITION = Vector3.new(0, 0, 0),
    
    ESP_PLAYERS = true,
    ESP_MONSTERS = true,
    FULLBRIGHT_ENABLED = true,
}

-- ==========================================
-- MODULE: Fullbright
-- ==========================================
local function enableFullbright()
    local Lighting = game:GetService("Lighting")
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 3
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 999999
    Lighting.FogStart = 999999
    local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmos then atmos:Destroy() end
end

-- ==========================================
-- MODULE: ESP
-- ==========================================
local trackedESP = {}

local function clearESP()
    for obj, highlight in pairs(trackedESP) do
        if highlight then highlight:Destroy() end
    end
    trackedESP = {}
end

local function updateESP()
    if Config.ESP_PLAYERS then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local color = Color3.fromRGB(255, 0, 0)
                if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                    color = Color3.fromRGB(0, 255, 0)
                end
                
                if not trackedESP[plr.Character] then
                    local h = Instance.new("Highlight")
                    h.Name = "ESP_Player"
                    h.Adornee = plr.Character
                    h.FillColor = color
                    h.OutlineColor = Color3.new(1, 1, 1)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = plr.Character
                    trackedESP[plr.Character] = h
                end
            end
        end
    end
    
    if Config.ESP_MONSTERS then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                for _, name in ipairs(Config.MONSTER_NAMES) do
                    if obj.Name:lower():find(name:lower()) and not trackedESP[obj] then
                        local h = Instance.new("Highlight")
                        h.Name = "ESP_Monster"
                        h.Adornee = obj
                        h.FillColor = Color3.fromRGB(170, 0, 255)
                        h.OutlineColor = Color3.new(1, 1, 1)
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = obj
                        trackedESP[obj] = h
                    end
                end
            end
        end
    end
end

-- ==========================================
-- MODULE: Teleport
-- ==========================================
local function teleportTo(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- ==========================================
-- UI (Rayfield Gen2) - Juicy Setup
-- ==========================================

-- Кастомная тема: берём ember как базу и подкручиваем под хоррор
local JuicyTheme = {
    -- База: фиолетово-чёрная гамма с неоновым акцентом
    WindowColor = ColorSequence.new(Color3.fromRGB(15, 10, 25), Color3.fromRGB(25, 15, 40)),
    TitleColor = Color3.fromRGB(220, 180, 255),
    ContentColor = Color3.fromRGB(230, 220, 240),
    
    -- Акцент (кнопки, тогглы) — ядовито-фиолетовый
    AccentColor = Color3.fromRGB(170, 0, 255),
    AccentStroke = Color3.fromRGB(200, 100, 255),
    
    -- Элементы
    ElementGradient = ColorSequence.new(Color3.fromRGB(35, 25, 50), Color3.fromRGB(45, 30, 65)),
    ElementStroke = Color3.fromRGB(120, 60, 200),
    
    -- Вкладки
    TabBackground = ColorSequence.new(Color3.fromRGB(40, 25, 60), Color3.fromRGB(60, 35, 90)),
    TabStroke = ColorSequence.new(Color3.fromRGB(150, 80, 255), Color3.fromRGB(100, 40, 200)),
    
    -- Скругления
    CornerRoundness = UDim.new(0, 12),
    ElementCornerRadius = UDim.new(0, 8),
    
    -- Включаем анимацию переливания градиента
    LiveAnimation = true,
}

local Window = Rayfield:CreateWindow({
    name = "SERVERBLIGHT",
    subtitle = "Survive the blight",
    sidebarLayout = true,
    theme = JuicyTheme,
    configuration = {
        autoSave = true,
        autoLoad = true,
        fileName = "BlightConfig_Juicy",
    },
})

-- --- Вкладка Visuals ---
local VisualsTab = Window:CreateTab({ name = "Visuals", icon = 93364949241311 })

VisualsTab:CreateToggle({
    name = "ESP Players",
    description = "Подсветка игроков (зелёный — свои, красный — враги)",
    flag = "ESP_Players",
    currentValue = Config.ESP_PLAYERS,
    callback = function(state)
        Config.ESP_PLAYERS = state
        if not state then clearESP() end
    end,
})

VisualsTab:CreateToggle({
    name = "ESP Monsters",
    description = "Подсветка Serverblight (фиолетовый)",
    flag = "ESP_Monsters",
    currentValue = Config.ESP_MONSTERS,
    callback = function(state)
        Config.ESP_MONSTERS = state
        if not state then clearESP() end
    end,
})

VisualsTab:CreateToggle({
    name = "Fullbright",
    description = "Убирает тьму и туман",
    flag = "Fullbright",
    currentValue = Config.FULLBRIGHT_ENABLED,
    callback = function(state)
        Config.FULLBRIGHT_ENABLED = state
        if state then enableFullbright() end
    end,
})

-- --- Вкладка Player ---
local PlayerTab = Window:CreateTab({ name = "Player", icon = 93364949241311 })

PlayerTab:CreateButton({
    name = "Teleport to Base",
    description = "Мгновенный телепорт на базу Red",
    callback = function()
        teleportTo(Config.BASE_POSITION)
        Window:Notify({
            title = "Teleport",
            content = "На базе",
            duration = 3,
        })
    end,
})

-- ==========================================
-- INITIALIZATION
-- ==========================================
if Config.FULLBRIGHT_ENABLED then enableFullbright() end

RunService.RenderStepped:Connect(function()
    updateESP()
end)

print("[+] SERVERBLIGHT Utility loaded (Juicy).")