-- ==========================================
-- SERVERBLIGHT Utility - Rayfield Gen2 (Stylish UI)
-- ==========================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- CONFIGURATION
-- ==========================================
local Config = {
    MONSTER_NAMES = {"Serverblight", "Blight", "Unknown"},
    BASE_POSITION = Vector3.new(0, 0, 0), 
    
    ESP_PLAYERS = true,
    ESP_MONSTERS = true,
    SHOW_HEALTH = true,
    FULLBRIGHT_ENABLED = false, 
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
-- MODULE: ESP (Stylish Outline & Health Bars)
-- ==========================================
local trackedESP = {}

local function createBoxOutline(model, color)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Box"
    box.Adornee = model
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = model:GetExtentsSize() 
    box.Color3 = color
    box.Transparency = 0.5
    box.Parent = model
    return box
end

local function createHealthBar(adornee, isMonster)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_HealthBar"
    billboard.Adornee = adornee
    -- Размер полоски (чуть шире, чтобы влез текст)
    billboard.Size = UDim2.new(0, 80, 0, 14) 
    billboard.StudsOffset = Vector3.new(0, 3.2, 0) 
    billboard.AlwaysOnTop = true
    billboard.Parent = adornee

    -- Тень/Фон (черная обводка)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    bg.BorderSizePixel = 0
    bg.Parent = billboard
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)

    -- Внутренний контейнер (полоса здоровья)
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -2, 1, -2)
    barBg.Position = UDim2.new(0, 1, 0, 1)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    barBg.BorderSizePixel = 0
    barBg.Parent = bg
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 4)

    -- Заполнение здоровья
    local fill = Instance.new("Frame")
    fill.Name = "HealthFill"
    fill.Size = UDim2.new(1, 0, 1, 0)
    -- Градиент для красоты: от темного к светлому
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, isMonster and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(200, 0, 0)),
        ColorSequenceKeypoint.new(1, isMonster and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 50, 50))
    }
    gradient.Parent = fill
    
    fill.BackgroundColor3 = Color3.new(1, 1, 1) -- Белый, чтобы градиент работал
    fill.BorderSizePixel = 0
    fill.Parent = barBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    -- Текст с цифрами HP
    local text = Instance.new("TextLabel")
    text.Name = "HealthText"
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "100"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeTransparency = 0.5
    text.Font = Enum.Font.GothamBold
    text.TextSize = 10
    text.Parent = bg

    return billboard, fill, text
end

local function updateESP()
    if not Config.ESP_PLAYERS and not Config.ESP_MONSTERS then
        for obj, data in pairs(trackedESP) do
            if data.Box then data.Box:Destroy() end
            if data.HealthBar then data.HealthBar:Destroy() end
        end
        trackedESP = {}
        return
    end

    -- 1. ESP for Players
    if Config.ESP_PLAYERS then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                local char = plr.Character
                local humanoid = char.Humanoid
                
                if not trackedESP[char] then
                    local box = createBoxOutline(char, Color3.fromRGB(255, 0, 0))
                    local hb, fill, text = createHealthBar(char, false)
                    trackedESP[char] = {Box = box, HealthBar = hb, Fill = fill, Text = text, Humanoid = humanoid}
                end
                
                if Config.SHOW_HEALTH and trackedESP[char] and trackedESP[char].Fill then
                    local hp = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
                    local healthPct = math.clamp(hp / humanoid.MaxHealth, 0, 1)
                    trackedESP[char].Fill.Size = UDim2.new(healthPct, 0, 1, 0)
                    trackedESP[char].Text.Text = tostring(math.floor(hp))
                end
            end
        end
    end
    
    -- 2. ESP for Monsters
    if Config.ESP_MONSTERS then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                for _, name in ipairs(Config.MONSTER_NAMES) do
                    if obj.Name:lower():find(name:lower()) then
                        local humanoid = obj:FindFirstChildOfClass("Humanoid")
                        
                        if not trackedESP[obj] then
                            local box = createBoxOutline(obj, Color3.fromRGB(0, 170, 255))
                            local hb, fill, text = createHealthBar(obj, true)
                            trackedESP[obj] = {Box = box, HealthBar = hb, Fill = fill, Text = text, Humanoid = humanoid}
                        end
                        
                        if Config.SHOW_HEALTH and humanoid and trackedESP[obj] and trackedESP[obj].Fill then
                            local hp = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
                            local healthPct = math.clamp(hp / humanoid.MaxHealth, 0, 1)
                            trackedESP[obj].Fill.Size = UDim2.new(healthPct, 0, 1, 0)
                            trackedESP[obj].Text.Text = tostring(math.floor(hp))
                        end
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
-- UI (Rayfield Gen2)
-- ==========================================
local JuicyTheme = {
    WindowColor = ColorSequence.new(Color3.fromRGB(15, 10, 25), Color3.fromRGB(25, 15, 40)),
    TitleColor = Color3.fromRGB(220, 180, 255),
    ContentColor = Color3.fromRGB(230, 220, 240),
    AccentColor = Color3.fromRGB(170, 0, 255),
    AccentStroke = Color3.fromRGB(200, 100, 255),
    ElementGradient = ColorSequence.new(Color3.fromRGB(35, 25, 50), Color3.fromRGB(45, 30, 65)),
    ElementStroke = ColorSequence.new(Color3.fromRGB(120, 60, 200)),
    TabBackground = ColorSequence.new(Color3.fromRGB(40, 25, 60), Color3.fromRGB(60, 35, 90)),
    TabStroke = ColorSequence.new(Color3.fromRGB(150, 80, 255), Color3.fromRGB(100, 40, 200)),
    CornerRoundness = UDim.new(0, 12),
    ElementCornerRadius = UDim.new(0, 8),
    LiveAnimation = true,
}

local Window = Rayfield:CreateWindow({
    name = "SERVERBLIGHT",
    subtitle = "Survive the blight",
    sidebarLayout = true,
    theme = JuicyTheme,
    configuration = { autoSave = true, autoLoad = true, fileName = "BlightConfig_Juicy" },
})

local VisualsTab = Window:CreateTab({ name = "Visuals", icon = 93364949241311 })

VisualsTab:CreateToggle({
    name = "ESP Players",
    description = "Red box - Allies",
    flag = "ESP_Players",
    currentValue = Config.ESP_PLAYERS,
    callback = function(state) Config.ESP_PLAYERS = state end,
})

VisualsTab:CreateToggle({
    name = "ESP Monsters",
    description = "Blue box - Serverblight",
    flag = "ESP_Monsters",
    currentValue = Config.ESP_MONSTERS,
    callback = function(state) Config.ESP_MONSTERS = state end,
})

VisualsTab:CreateToggle({
    name = "Show Health Bars",
    description = "Displays HP above heads",
    flag = "Show_Health",
    currentValue = Config.SHOW_HEALTH,
    callback = function(state) Config.SHOW_HEALTH = state end,
})

VisualsTab:CreateToggle({
    name = "Fullbright",
    description = "Removes darkness and fog",
    flag = "Fullbright",
    currentValue = Config.FULLBRIGHT_ENABLED,
    callback = function(state)
        Config.FULLBRIGHT_ENABLED = state
        if state then enableFullbright() end
    end,
})

local IntelTab = Window:CreateTab({ name = "Intel", icon = 93364949241311 })

IntelTab:CreateButton({
    name = "Teleport to Intel",
    description = "Teleports to Workspace.Map.Briefcases.RedTrigger",
    callback = function()
        local briefcases = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Briefcases")
        local intel = briefcases and briefcases:FindFirstChild("RedTrigger")
        
        if intel then
            teleportTo(intel.Position + Vector3.new(0, 3, 0))
            Window:Notify({ title = "Intel", content = "Teleported to Intel", duration = 3 })
        else
            Window:Notify({ title = "Intel", content = "Intel not found on map", duration = 3 })
        end
    end,
})

IntelTab:CreateButton({
    name = "Teleport to Base",
    description = "Instantly teleport to the Red Base",
    callback = function()
        teleportTo(Config.BASE_POSITION)
        Window:Notify({ title = "Teleport", content = "Arrived at base", duration = 3 })
    end,
})

-- ==========================================
-- INITIALIZATION
-- ==========================================
RunService.RenderStepped:Connect(function()
    updateESP()
end)

print("[+] SERVERBLIGHT Utility loaded.")