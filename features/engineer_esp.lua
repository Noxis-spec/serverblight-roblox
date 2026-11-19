-- Engineer Buildings ESP (White Outline)

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

_G.EngineerESP = _G.EngineerESP or {
    Enabled = true,
}

local trackedBuildings = {}

-- Список названий построек
local buildingNames = {
    "Sentry", "Sentry1", "Sentry2", "Sentry3",
    "Dispenser", "Dispenser1", "Dispenser2", "Dispenser3", "Depsenser1", "Depsenser2", "Depsenser3",
    "Teleporter", "TeleporterE1", "TeleporterEx1"
}

local function makeWhiteOutline(model)
    if model:IsA("Model") then
        local hl = Instance.new("Highlight")
        hl.Name = "Building_ESP"
        hl.Adornee = model
        hl.FillTransparency = 1
        hl.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белая обводка
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = model
        return hl
    end
end

local function isBuilding(name)
    for _, v in ipairs(buildingNames) do
        if name:lower() == v:lower() or name:lower():find(v:lower()) then
            return true
        end
    end
    return false
end

task.spawn(function()
    while task.wait(1) do
        if not _G.EngineerESP.Enabled then
            for obj, hl in pairs(trackedBuildings) do
                if hl then hl:Destroy() end
            end
            trackedBuildings = {}
            continue
        end

        -- Убираем удаленные постройки
        for obj, hl in pairs(trackedBuildings) do
            if not obj or not obj.Parent then
                if hl then hl:Destroy() end
                trackedBuildings[obj] = nil
            end
        end

        -- Ищем новые постройки
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and not trackedBuildings[obj] and isBuilding(obj.Name) then
                local hl = makeWhiteOutline(obj)
                trackedBuildings[obj] = hl
            end
        end
    end
end)

print("Engineer ESP loaded.")