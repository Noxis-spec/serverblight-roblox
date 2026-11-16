-- ==========================================
-- SERVERBLIGHT Utility - Rayfield (Optimized)
-- ==========================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local Config = {
    MONSTER_NAMES = {"Serverblight", "Blight", "Unknown"},
    ITEM_NAMES = {"SmallHP", "LargeAmmo", "MediumAmmo", "Resupply", "Health"},
    BASE_POSITION = Vector3.new(0, 0, 0),
    
    ESP_PLAYERS = true,
    ESP_MONSTERS = true,
    ESP_ITEMS = true,
    SHOW_HEALTH = true,
    FULLBRIGHT = false,
    INF_AMMO = false,
    AUTO_INTEL = false,
}

-- ==========================================
-- MODULE: Fullbright
-- ==========================================
local function toggleFullbright(state)
    local Lighting = game:GetService("Lighting")
    if state then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmos then atmos:Destroy() end
    else
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = true
    end
end

-- ==========================================
-- MODULE: Infinite Ammo (999 в магазине)
-- ==========================================
local processedWeapons = {}
local function processWeapon(weapon)
    if processedWeapons[weapon] then return end
    if weapon:IsA("Tool") and weapon:FindFirstChild("Values") then
        local ammo = weapon.Values:FindFirstChild("Ammo")
        
        if ammo then
            processedWeapons[weapon] = true
            -- Ставим 999 сразу при взятии
            ammo.Value = 999
            
            ammo.Changed:Connect(function()
                -- Если магазин пустеет (выстрел или перезарядка), снова ставим 999
                -- При этом TotalAmmo не трогаем, он будет тратиться как положено
                if Config.INF_AMMO and ammo.Value < 999 then
                    ammo.Value = 999
                end
            end)
        end
    end
end

-- Отслеживаем добавление оружия в инвентарь (вместо бесконечного цикла)
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if Config.INF_AMMO then processWeapon(child) end
end)

-- ==========================================
-- MODULE: Auto Intel (Оптимизированный)
-- ==========================================
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
    local VirtualInputManager = game:GetService("VirtualInputManager")
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

task.spawn(function()
    while task.wait(0.1) do
        if Config.AUTO_INTEL and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
            local enemyIntel = getBriefcase("Blue")
            if enemyIntel and enemyIntel.Parent.Name == "Briefcases" then
                teleportTo(enemyIntel.Position + Vector3.new(0, 2, 0))
                task.wait(0.2)
                pressE()
                task.wait(0.5)
                local dropZone = getBriefcase("Red")
                if dropZone then
                    teleportTo(dropZone.Position + Vector3.new(0, 2, 0))
                    task.wait(1)
                end
            end
        end
    end
end)

-- ==========================================
-- MODULE: ESP (Оптимизированный)
-- ==========================================
local trackedESP = {}

-- Функция создания Health Bar (Pulse Hub style)
local function createHealthBar(adornee, isMonster)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_HP"
    billboard.Adornee = adornee
    billboard.Size = UDim2.new(0, 90, 0, 16)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = adornee

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    bg.BorderSizePixel = 0
    bg.Parent = billboard
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -2, 1, -2)
    barBg.Position = UDim2.new(0, 1, 0, 1)
    barBg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    barBg.BorderSizePixel = 0
    barBg.Parent = bg
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = isMonster and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(255, 50, 50)
    fill.BorderSizePixel = 0
    fill.Parent = barBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "100"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeTransparency = 0.7
    text.Font = Enum.Font.GothamBold
    text.TextSize = 11
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
    elseif instance:IsA("BasePart") then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = instance
        box.AlwaysOnTop = true
        box.Size = instance.Size + Vector3.new(0.1, 0.1, 0.1)
        box.Color3 = color
        box.Transparency = 0.2
        box.Parent = instance
        return box
    end
    return nil
end

-- Функция добавления объекта в ESP
local function addObjectToESP(obj, isMonster, isItem)
    if trackedESP[obj] then return end
    
    local color = Color3.fromRGB(255, 0, 0) -- Red for players
    if isMonster then color = Color3.fromRGB(0, 170, 255) end -- Blue for monsters
    if isItem then color = Color3.fromRGB(0, 255, 0) end -- Green for items

    local outline = applyOutline(obj, color)
    local hp, fill, txt = nil, nil, nil
    
    -- Полоску ХП даем только игрокам и монстрам
    if not isItem then
        hp, fill, txt = createHealthBar(obj, isMonster)
    end
    
    trackedESP[obj] = {Outline = outline, HP = hp, Fill = fill, Text = txt, IsMonster = isMonster, IsItem = isItem}
end

-- Функция обновления позиций и ХП (только для уже добавленных)
local function updateESP()
    for obj, data in pairs(trackedESP) do
        if not obj or not obj.Parent then
            if data.Outline then data.Outline:Destroy() end
            if data.HP then data.HP:Destroy() end
            trackedESP[obj] = nil
        else
            if not data.IsItem and Config.SHOW_HEALTH then
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                if humanoid and data.Fill then
                    local h = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
                    data.Fill.Size = UDim2.new(h / humanoid.MaxHealth, 0, 1, 0)
                    data.Text.Text = tostring(math.floor(h))
                end
            end
        end
    end
end

-- Сканируем карту ТОЛЬКО при добавлении новых объектов (оптимизация)
local function scanObject(obj)
    if not obj then return end
    local name = obj.Name:lower()

    -- Монстры
    if Config.ESP_MONSTERS and obj:IsA("Model") then
        for _, mName in ipairs(Config.MONSTER_NAMES) do
            if name:find(mName:lower()) then
                addObjectToESP(obj, true, false)
                return
            end
        end
    end

    -- Предметы
    if Config.ESP_ITEMS and (obj:IsA("Model") or obj:IsA("BasePart")) then
        for _, iName in ipairs(Config.ITEM_NAMES) do
            if name:find(iName:lower()) then
                addObjectToESP(obj, false, true)
                return
            end
        end
    end
end

-- Отслеживаем появление новых объектов на карте
Workspace.DescendantAdded:Connect(function(obj)
    if Config.ESP_MONSTERS or Config.ESP_ITEMS then
        task.wait(0.1) -- Небольшая задержка чтобы объект успел инициализироваться
        scanObject(obj)
    end
end)

-- Сканируем игроков
local function scanPlayer(plr)
    if plr ~= LocalPlayer and Config.ESP_PLAYERS then
        plr.CharacterAdded:Connect(function(char)
            task.wait(1) -- Ждем спавна
            addObjectToESP(char, false, false)
        end)
        if plr.Character then
            addObjectToESP(plr.Character, false, false)
        end
    end
end
Players.PlayerAdded:Connect(scanPlayer)
for _, p in ipairs(Players:GetPlayers()) do scanPlayer(p) end

-- ==========================================
-- UI (Rayfield Original)
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "SERVERBLIGHT [Optimized]",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Noxis",
    ConfigurationSaving = { Enabled = true, FolderName = "BlightConfig", FileName = "Main" },
    KeySystem = false
})

local VisualsTab = Window:CreateTab("Visuals", 4483362458)

VisualsTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = Config.ESP_PLAYERS,
    Flag = "ESP_Players",
    Callback = function(state) Config.ESP_PLAYERS = state end,
})

VisualsTab:CreateToggle({
    Name = "ESP Monsters",
    CurrentValue = Config.ESP_MONSTERS,
    Flag = "ESP_Monsters",
    Callback = function(state) Config.ESP_MONSTERS = state end,
})

VisualsTab:CreateToggle({
    Name = "ESP Items (Heals/Ammo)",
    CurrentValue = Config.ESP_ITEMS,
    Flag = "ESP_Items",
    Callback = function(state) Config.ESP_ITEMS = state end,
})

VisualsTab:CreateToggle({
    Name = "Health Bars",
    CurrentValue = Config.SHOW_HEALTH,
    Flag = "Show_Health",
    Callback = function(state) Config.SHOW_HEALTH = state end,
})

VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = Config.FULLBRIGHT,
    Flag = "Fullbright",
    Callback = function(state) Config.FULLBRIGHT = state; toggleFullbright(state) end,
})

local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateToggle({
    Name = "Infinite Ammo (999 Mag)",
    CurrentValue = Config.INF_AMMO,
    Flag = "Inf_Ammo",
    Callback = function(state) 
        Config.INF_AMMO = state 
        if state then
            -- Принудительно обрабатываем текущее оружие
            for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do processWeapon(item) end
        end
    end,
})

PlayerTab:CreateToggle({
    Name = "Auto Intel Farm",
    CurrentValue = Config.AUTO_INTEL,
    Flag = "Auto_Intel",
    Callback = function(state) Config.AUTO_INTEL = state end,
})

PlayerTab:CreateButton({
    Name = "Teleport to Enemy Intel",
    Callback = function()
        local intel = getBriefcase("Blue")
        if intel then teleportTo(intel.Position + Vector3.new(0, 3, 0)) end
    end,
})

PlayerTab:CreateButton({
    Name = "Teleport to Red Drop Zone",
    Callback = function()
        local dropZone = getBriefcase("Red")
        if dropZone then teleportTo(dropZone.Position + Vector3.new(0, 3, 0)) end
    end,
})

-- ==========================================
-- INITIALIZATION
-- ==========================================
Rayfield:LoadConfiguration()
RunService.RenderStepped:Connect(updateESP)
print("[+] SERVERBLIGHT Utility loaded (Optimized + Rayfield).")