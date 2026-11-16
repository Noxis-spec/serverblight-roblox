-- ==========================================
-- SERVERBLIGHT Utility - Mobile Edition (Ultimate Fix)
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local Config = {
    MONSTER_NAMES = {"Serverblight", "Blight", "Unknown"},
    ITEM_NAMES = {"SmallHP", "LargeAmmo", "MediumAmmo", "Resupply", "Health", "Pills"},
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
-- MODULE: Infinite Ammo (Instant 999)
-- ==========================================
local processedWeapons = {}
local function processWeapon(weapon)
    if processedWeapons[weapon] then return end
    if weapon:IsA("Tool") and weapon:FindFirstChild("Values") then
        local ammo = weapon.Values:FindFirstChild("Ammo")
        local totalAmmo = weapon.Values:FindFirstChild("TotalAmmo")
        
        if ammo and totalAmmo then
            processedWeapons[weapon] = true
            local function refill()
                if Config.INF_AMMO then
                    ammo.Value = 999
                    totalAmmo.Value = 999
                end
            end
            refill()
            ammo.Changed:Connect(refill)
            totalAmmo.Changed:Connect(refill)
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        if Config.INF_AMMO then
            for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do processWeapon(item) end
            if LocalPlayer.Character then
                for _, item in pairs(LocalPlayer.Character:GetChildren()) do processWeapon(item) end
            end
        end
    end
end)

-- ==========================================
-- MODULE: Auto Intel
-- ==========================================
local function teleportTo(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function getBriefcase(name)
    local map = workspace:FindFirstChild("Map")
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
-- MODULE: ESP (Fixed + Items)
-- ==========================================
local trackedESP = {}

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

-- Универсальная функция обводки (использует Highlight для моделей и Box для предметов)
local function applyOutline(instance, color)
    if instance:IsA("Model") then
        local h = Instance.new("Highlight")
        h.Adornee = instance
        h.FillTransparency = 1 -- Только контур
        h.OutlineColor = color
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = instance
        return h
    elseif instance:IsA("BasePart") then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = instance
        box.AlwaysOnTop = true
        box.Size = instance.Size + Vector3.new(0.1, 0.1, 0.1) -- Чуть больше самого предмета
        box.Color3 = color
        box.Transparency = 0.2
        box.Parent = instance
        return box
    end
    return nil
end

local function updateESP()
    if not Config.ESP_PLAYERS and not Config.ESP_MONSTERS and not Config.ESP_ITEMS then
        for obj, data in pairs(trackedESP) do
            if data.Outline then data.Outline:Destroy() end
            if data.HP then data.HP:Destroy() end
        end
        trackedESP = {}
        return
    end

    -- Игроки
    if Config.ESP_PLAYERS then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                local char = plr.Character
                local humanoid = char.Humanoid
                if not trackedESP[char] then
                    local outline = applyOutline(char, Color3.fromRGB(255, 0, 0))
                    local hp, fill, txt = createHealthBar(char, false)
                    trackedESP[char] = {Outline = outline, HP = hp, Fill = fill, Text = txt, Hum = humanoid}
                end
                if Config.SHOW_HEALTH and trackedESP[char] then
                    local h = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
                    trackedESP[char].Fill.Size = UDim2.new(h / humanoid.MaxHealth, 0, 1, 0)
                    trackedESP[char].Text.Text = tostring(math.floor(h))
                end
            end
        end
    end
    
    -- Монстры
    if Config.ESP_MONSTERS then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                for _, name in ipairs(Config.MONSTER_NAMES) do
                    if obj.Name:lower():find(name:lower()) and not trackedESP[obj] then
                        local outline = applyOutline(obj, Color3.fromRGB(0, 170, 255))
                        local humanoid = obj:FindFirstChildOfClass("Humanoid")
                        local hp, fill, txt = createHealthBar(obj, true)
                        trackedESP[obj] = {Outline = outline, HP = hp, Fill = fill, Text = txt, Hum = humanoid}
                    end
                end
                if trackedESP[obj] and trackedESP[obj].Hum and Config.SHOW_HEALTH then
                    local h = math.clamp(trackedESP[obj].Hum.Health, 0, trackedESP[obj].Hum.MaxHealth)
                    trackedESP[obj].Fill.Size = UDim2.new(h / trackedESP[obj].Hum.MaxHealth, 0, 1, 0)
                    trackedESP[obj].Text.Text = tostring(math.floor(h))
                end
            end
        end
    end

    -- Предметы (Аптечки, патроны)
    if Config.ESP_ITEMS then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("BasePart")) and not trackedESP[obj] then
                for _, itemName in ipairs(Config.ITEM_NAMES) do
                    if obj.Name:lower():find(itemName:lower()) then
                        local outline = applyOutline(obj, Color3.fromRGB(0, 255, 0)) -- Зеленый для предметов
                        trackedESP[obj] = {Outline = outline}
                        break
                    end
                end
            end
        end
    end
end

-- ==========================================
-- UI
-- ==========================================
local function createCustomUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlightMenu"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 260, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(35, 0, 50)
    Title.Text = "SERVERBLIGHT [Ultimate]"
    Title.TextColor3 = Color3.fromRGB(200, 150, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = MainFrame
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -20, 1, -50)
    Content.Position = UDim2.new(0, 10, 0, 40)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    local function createToggle(text, yPos, defaultState, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btn.Text = text .. ": " .. (defaultState and "ON" or "OFF")
        btn.TextColor3 = defaultState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Parent = Content
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        local state = defaultState
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text .. ": " .. (state and "ON" or "OFF")
            btn.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
            callback(state)
        end)
        return btn
    end

    local function createButton(text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Parent = Content
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.MouseButton1Click:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
            task.wait(0.1)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            callback()
        end)
    end

    createToggle("ESP Players", 0, Config.ESP_PLAYERS, function(s) Config.ESP_PLAYERS = s end)
    createToggle("ESP Monsters", 35, Config.ESP_MONSTERS, function(s) Config.ESP_MONSTERS = s end)
    createToggle("ESP Items", 70, Config.ESP_ITEMS, function(s) Config.ESP_ITEMS = s end)
    createToggle("Health Bars", 105, Config.SHOW_HEALTH, function(s) Config.SHOW_HEALTH = s end)
    createToggle("Fullbright", 140, Config.FULLBRIGHT, function(s) Config.FULLBRIGHT = s; toggleFullbright(s) end)
    createToggle("Infinite Ammo", 175, Config.INF_AMMO, function(s) Config.INF_AMMO = s end)
    
    local autoBtn = createToggle("Auto Intel Farm", 210, Config.AUTO_INTEL, function(s) Config.AUTO_INTEL = s end)
    autoBtn.TextColor3 = Color3.fromRGB(255, 200, 0)

    createButton("TP to Enemy Intel", 255, function()
        local intel = getBriefcase("Blue")
        if intel then teleportTo(intel.Position + Vector3.new(0, 3, 0)) end
    end)
    createButton("TP to Red Drop Zone", 290, function()
        local dropZone = getBriefcase("Red")
        if dropZone then teleportTo(dropZone.Position + Vector3.new(0, 3, 0)) end
    end)
end

createCustomUI()
RunService.RenderStepped:Connect(updateESP)
print("[+] SERVERBLIGHT Utility loaded (Ultimate).")