-- ==========================================
-- FEATURE: ESP (Players & Monsters)
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Создаем глобальную таблицу настроек, если ее нет
_G.BlightESP = _G.BlightESP or {
    Enabled = true,
    ShowHealth = true,
    MonsterNames = {"Serverblight", "Blight", "Unknown"}
}

local trackedESP = {}

-- Функция создания полоски здоровья
local function createHealthBar(adornee, isMonster)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_HP"
    billboard.Adornee = adornee
    billboard.Size = UDim2.new(0, 70, 0, 14)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = adornee

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    bg.BorderSizePixel = 0
    bg.Parent = billboard
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = isMonster and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(255, 50, 50)
    fill.BorderSizePixel = 0
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    local text = Instance.new("TextLabel")
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

-- Универсальная обводка
local function applyOutline(instance, color)
    if instance:IsA("Model") then
        local h = Instance.new("Highlight")
        h.Adornee = instance
        h.FillTransparency = 1 
        h.OutlineColor = color
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = instance
        return h
    end
    return nil
end

-- Основной цикл обновления
RunService.RenderStepped:Connect(function()
    if not _G.BlightESP.Enabled then
        -- Если выключено, удаляем всё
        for obj, data in pairs(trackedESP) do
            if data.Outline then data.Outline:Destroy() end
            if data.HP then data.HP:Destroy() end
        end
        trackedESP = {}
        return
    end

    -- 1. Игроки
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            local char = plr.Character
            local humanoid = char.Humanoid
            
            if not trackedESP[char] then
                local outline = applyOutline(char, Color3.fromRGB(255, 0, 0))
                local hp, fill, txt = createHealthBar(char, false)
                trackedESP[char] = {Outline = outline, HP = hp, Fill = fill, Text = txt, Hum = humanoid}
            end
            
            if _G.BlightESP.ShowHealth and trackedESP[char] then
                local h = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
                trackedESP[char].Fill.Size = UDim2.new(h / humanoid.MaxHealth, 0, 1, 0)
                trackedESP[char].Text.Text = tostring(math.floor(h))
            end
        end
    end
    
    -- 2. Монстры
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            for _, name in ipairs(_G.BlightESP.MonsterNames) do
                if obj.Name:lower():find(name:lower()) then
                    if not trackedESP[obj] then
                        local outline = applyOutline(obj, Color3.fromRGB(0, 170, 255))
                        local hp, fill, txt = createHealthBar(obj, true)
                        trackedESP[obj] = {Outline = outline, HP = hp, Fill = fill, Text = txt, Hum = obj:FindFirstChildOfClass("Humanoid")}
                    end
                    
                    if _G.BlightESP.ShowHealth and trackedESP[obj].Hum then
                        local h = math.clamp(trackedESP[obj].Hum.Health, 0, trackedESP[obj].Hum.MaxHealth)
                        trackedESP[obj].Fill.Size = UDim2.new(h / trackedESP[obj].Hum.MaxHealth, 0, 1, 0)
                        trackedESP[obj].Text.Text = tostring(math.floor(h))
                    end
                end
            end
        end
    end
end)

print("[+] ESP Module Loaded.")