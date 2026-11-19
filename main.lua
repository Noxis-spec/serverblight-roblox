-- 5. Utility
local UtilityTab = Window:CreateTab("Utility", 4483362458)

UtilityTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESP_Enabled",
    Callback = function(state)
        _G.BlightESP.Enabled = state
        if state and not _G.ESP_Loaded then
            loadFeature("esp")
            _G.ESP_Loaded = true
        end
    end,
})

UtilityTab:CreateToggle({
    Name = "Show Health Bars",
    CurrentValue = true,
    Flag = "ESP_Health",
    Callback = function(state)
        _G.BlightESP.ShowHealth = state
    end,
})

-- НОВЫЙ ТУМБЛЕР ДЛЯ ПОСТРОЕК
UtilityTab:CreateToggle({
    Name = "Engineer Buildings ESP",
    CurrentValue = false,
    Flag = "Engi_ESP_Enabled",
    Callback = function(state)
        _G.EngineerESP.Enabled = state
        if state and not _G.EngiESP_Loaded then
            loadFeature("engineer_esp")
            _G.EngiESP_Loaded = true
        end
    end,
})