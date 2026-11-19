-- ESP Module

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

_G.BlightESP = _G.BlightESP or {
    Enabled = true,
    ShowHealth = true,
}

local trackedESP = {}
local ignoreList = {"Sentry", "Dispenser", "Teleporter", "Sentry2", "Sentry3"}

local function makeHealthBar(model, color)
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_HP"
    bb.Adornee = model
    bb.Size = UDim2.new(0, 70, 0, 14)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = model

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    bg.BorderSizePixel = 0
    bg.Parent = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = color
    fill.BorderSizePixel = 0
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "100"
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.TextStrokeTransparency = 0.5
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 10
    txt.Parent = bg

    return bb, fill, txt
end

local function makeOutline(model, color)
    if model:IsA("Model") then
        local hl = Instance.new("Highlight")
        hl.Name = "ESP_Outline"
        hl.Adornee = model
        hl.FillTransparency = 1
        hl.OutlineColor = color
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = model
        return hl
    end
end

local function checkIgnore(name)
    for _, v in ipairs(ignoreList) do
        if name:lower():find(v:lower()) then
            return true
        end
    end
    return false
end

RunService.RenderStepped:Connect(function()
    if not _G.BlightESP.Enabled then
        for obj, data in pairs(trackedESP) do
            if data.Outline then data.Outline:Destroy() end
            if data.HP then data.HP:Destroy() end
        end
        trackedESP = {}
        return
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and not checkIgnore(obj.Name) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            
            if hum and hrp then
                local color = Color3.fromRGB(255, 0, 0)
                local plr = Players:GetPlayerFromCharacter(obj)

                if plr then
                    if plr == LocalPlayer then continue end
                    if plr.Team == LocalPlayer.Team then
                        color = Color3.fromRGB(0, 255, 0)
                    end
                else
                    local team = obj:FindFirstChild("Team")
                    if team and team.Value == "Red" then
                        color = Color3.fromRGB(0, 255, 0)
                    else
                        color = Color3.fromRGB(0, 170, 255)
                    end
                end

                if not trackedESP[obj] then
                    local hl = makeOutline(obj, color)
                    local bb, fill, txt = makeHealthBar(obj, color)
                    trackedESP[obj] = {Outline = hl, HP = bb, Fill = fill, Text = txt, Hum = hum}
                end
                
                if _G.BlightESP.ShowHealth and trackedESP[obj] then
                    local h = math.clamp(hum.Health, 0, hum.MaxHealth)
                    trackedESP[obj].Fill.Size = UDim2.new(h / hum.MaxHealth, 0, 1, 0)
                    trackedESP[obj].Text.Text = tostring(math.floor(h))
                end
            end
        end
    end
end)

print("ESP loaded.")