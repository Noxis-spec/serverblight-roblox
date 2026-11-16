-- ==========================================
-- SERVERBLIGHT Utility - Rayfield Gen2
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
    BASE_POSITION = Vector3.new(0, 0, 0), -- Set your Red Base coordinates here
    
    ESP_PLAYERS = true,
    ESP_MONSTERS = true,
    SHOW_HEALTH = true,
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
-- MODULE: ESP & Health Bars
-- ==========================================
local trackedESP = {}

local function createHealthBar(adornee, isMonster)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_HealthBar"
    billboard.Adornee = adornee
    billboard.Size = UDim2.new(0, 50, 0, 6) -- Small, compact size
    billboard.StudsOffset = Vector3.new(0, 2.5, 0) -- Position above the head
    billboard.AlwaysOnTop = true
    billboard.Parent = adornee

    -- Health bar background (dark)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bg.BorderSizePixel = 0
    bg.Parent = billboard
    
    local bgCorner = Instance.new("UICorner", bg)
    bgCorner.CornerRadius = UDim.new(0, 2)

    -- Actual health fill
    local fill = Instance.new("Frame")
    fill.Name = "HealthFill"
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = isMonster and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    fill.BorderSizePixel = 0
    fill.Parent = bg

    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(0, 2)

    return billboard, fill
end

local function updateESP()
    -- Clear memory if everything is disabled
    if not Config.ESP_PLAYERS and not Config.ESP_MONSTERS then
        for obj, data in pairs(trackedESP) do
            if data.Highlight then data.Highlight:Destroy() end
            if data.HealthBar then data.HealthBar:Destroy() end
        end
        trackedESP = {}
        return
    end

    -- 1. ESP for Players (Allies / Red Team)
    if Config.ESP_PLAYERS then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                local char = plr.Character
                local humanoid = char.Humanoid
                
                -- Highlight all players as GREEN (Allies)
                local color = Color3.fromRGB(0, 255, 0)
                
                if not trackedESP[char] then
                    local h = Instance.new("Highlight")
                    h.Name = "ESP_Player"
                    h.Adornee = char
                    h.FillColor = color
                    h.OutlineColor = Color3.new(1, 1, 1)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = char
                    
                    local hb, fill = createHealthBar(char, false)
                    trackedESP[char] = {Highlight = h, HealthBar = hb, Fill = fill, Humanoid = humanoid}
                end
                
                -- Update health bar
                if Config.SHOW_HEALTH and trackedESP[char] and trackedESP[char].Fill then
                    local healthPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    trackedESP[char].Fill.Size = UDim2.new(healthPct, 0, 1, 0)
                    if healthPct < 0.3 then
                        trackedESP[char].Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red when low HP
                    else
                        trackedESP[char].Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green when normal
                    end
                end
            end
        end
    end
    
    -- 2. ESP for Monsters (Serverblight)
    if Config.ESP_MONSTERS then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                for _, name in ipairs(Config.MONSTER_NAMES) do
                    if obj.Name:lower():find(name:lower()) then
                        local humanoid = obj:FindFirstChildOfClass("Humanoid")
                        
                        if not trackedESP[obj] then
                            local h = Instance.new("Highlight")
                            h.Name = "ESP_Monster"
                            h.Adornee = obj
                            h.FillColor = Color3.fromRGB(255, 0, 0) -- Bright red for threats
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Parent = obj
                            
                            local hb, fill = createHealthBar(obj, true)
                            trackedESP[obj] = {Highlight = h, HealthBar = hb, Fill = fill, Humanoid = humanoid}
                        end
                        
                        -- Update monster health bar (if Humanoid exists)
                        if Config.SHOW_HEALTH and humanoid and trackedESP[obj] and trackedESP[obj].Fill then
                            local healthPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            trackedESP[obj].Fill.Size = UDim2.new(healthPct, 0, 1, 0)
                            trackedESP[obj].Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Always red
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
    ElementStroke = Color3.fromRGB(120, 60, 200),
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
    description = "Green - Allies (Red Team)",
    flag = "ESP_Players",
    currentValue = Config.ESP_PLAYERS,
    callback = function(state) Config.ESP_PLAYERS = state end,
})

VisualsTab:CreateToggle({
    name = "ESP Monsters",
    description = "Red - Serverblight",
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

local PlayerTab = Window:CreateTab({ name = "Player", icon = 93364949241311 })

PlayerTab:CreateButton({
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
if Config.FULLBRIGHT_ENABLED then enableFullbright() end

RunService.RenderStepped:Connect(function()
    updateESP()
end)

print("[+] SERVERBLIGHT Utility loaded.")