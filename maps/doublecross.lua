-- Doublecross Auto Farm Logic

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Координаты сейф-зоны для Даблкросса
local SAFE_ZONE_POS = Vector3.new(-145.08, 910.79, 20.61)
local platform = nil

local function createFloor()
    if platform and platform.Parent then return end
    platform = Instance.new("Part")
    platform.Name = "SafeZoneFloor"
    platform.Size = Vector3.new(20, 1, 20) 
    platform.Position = SAFE_ZONE_POS - Vector3.new(0, 3, 0) 
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1 
    platform.Parent = Workspace
end

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
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

local function doOneCycle()
    local blueIntel = getBriefcase("Blue")
    local redIntel = getBriefcase("Red")
    if not blueIntel or not redIntel then return false end

    -- 1. ТП к синему
    teleportTo(blueIntel.Position + Vector3.new(0, 5, 0))
    task.wait(0.8)
    pressE()
    task.wait(0.8)
    
    -- 2. ТП к красному (сдача)
    teleportTo(redIntel.Position + Vector3.new(0, 2, 0))
    task.wait(1.5)
    
    -- 3. ТП в сейф-зону
    teleportTo(SAFE_ZONE_POS)
    task.wait(1)
    return true
end

-- Запускаем цикл в фоне
task.spawn(function()
    createFloor()
    local count = 0
    while count < 3 do
        -- Ждем появления синего интела
        while not getBriefcase("Blue") do
            task.wait(0.5)
        end
        
        doOneCycle()
        count = count + 1
        task.wait(1)
    end
    print("[+] Doublecross Farm finished 3 cycles.")
end)