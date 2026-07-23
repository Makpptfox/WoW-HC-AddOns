-- DynamicUILayout --

local addonName = ...
local frame = CreateFrame("Frame", "DynamicUILayoutFrame")

local mockGroupSize = nil
local isDebugEnabled = false

local function DebugLog(...)
    if isDebugEnabled then
        print("|cFF00FFFF[DUL Debug]|r", ...)
    end
end

local function AutoSwapLayout()
    local num = mockGroupSize or GetNumGroupMembers()
    local targetLayout = nil
    
    if num > 20 then
        targetLayout = DynamicUILayoutDB.layout40
    elseif num > 10 then
        targetLayout = DynamicUILayoutDB.layout20
    elseif num > 5 then
        targetLayout = DynamicUILayoutDB.layout10
    elseif num > 0 then
        targetLayout = DynamicUILayoutDB.layout5
    end
    
    DebugLog("Group:", num, "| Target:", targetLayout, "| Type:", type(targetLayout))
    
    -- fallback just in case (DB issue or some unk err on the layout)
    if type(targetLayout) ~= "number" then 
        DebugLog("Aborted: target is not a number (re-select layouts in options)")
        return 
    end
    
    if targetLayout and targetLayout ~= 0 then
        local data = C_EditMode.GetLayouts()
        
        if data and data.activeLayout ~= targetLayout then
            -- edit mode frame blocks api calls
            if EditModeManagerFrame and EditModeManagerFrame:IsShown() then
                DebugLog("Aborted: Edit Mode window is currently open")
                return
            end

            local layoutName = "Unknown"
            for i, layout in ipairs(data.layouts) do
                if (i + 2) == targetLayout then
                    layoutName = layout.layoutName
                    break
                end
            end
            
            -- default to true if nil
            if DynamicUILayoutDB.showSuccessMessage ~= false then
                print("|T255346:0|t |cFFFFFF00Dynamic UI Layout:|r |cFF00FF00Layout changed to " .. layoutName .. ".|r")
            end
            
            DebugLog("Swapping to layout index:", targetLayout)
            C_EditMode.SetActiveLayout(targetLayout)
        else
            DebugLog("Already on target layout or no layout data")
        end
    else
        DebugLog("No valid layout configured for this size")
    end
end

-- debug stuff
SLASH_DYNAMICUILAYOUT1 = "/dul"
SlashCmdList["DYNAMICUILAYOUT"] = function(msg)
    local cmd, arg = strsplit(" ", msg)
    if cmd == "test" and tonumber(arg) then
        mockGroupSize = tonumber(arg)
        DebugLog("Testing with fake group size:", mockGroupSize)
        AutoSwapLayout()
        mockGroupSize = nil
    elseif cmd == "debug" then
        isDebugEnabled = not isDebugEnabled
        print("|T255346:0|t |cFFFFFF00Dynamic UI Layout:|r Debug mode:", isDebugEnabled and "ON" or "OFF")
    else
        print("|T255346:0|t |cFFFFFF00Dynamic UI Layout:|r Use /dul test <number> or /dul debug")
    end
end

local function GetLayouts()
    local data = C_EditMode.GetLayouts()
    local list = { { text = "None", value = 0 } }
    
    if data and data.layouts then
        for i, layout in ipairs(data.layouts) do
            -- offset the classic/modern default presets
            local id = i + 2
            table.insert(list, { text = layout.layoutName, value = id })
        end
    end
    
    return list
end

local function CreateDropdown(name, parent, labelText, dbKey, yOffset)
    local dropdown = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset)
    
    local label = dropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 16, 3)
    label:SetText(labelText)
    
    UIDropDownMenu_Initialize(dropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        local layouts = GetLayouts()
        
        for _, opt in ipairs(layouts) do
            info.text = opt.text
            info.value = opt.value
            info.checked = (DynamicUILayoutDB[dbKey] == opt.value)
            info.func = function(b)
                DynamicUILayoutDB[dbKey] = b.value
                UIDropDownMenu_SetSelectedValue(dropdown, b.value)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    UIDropDownMenu_SetSelectedValue(dropdown, DynamicUILayoutDB[dbKey] or 0)
    
    local layouts = GetLayouts()
    for _, opt in ipairs(layouts) do
        if opt.value == DynamicUILayoutDB[dbKey] then
            UIDropDownMenu_SetText(dropdown, opt.text)
            break
        end
    end
    
    return dropdown
end

local function InitSettingsPanel()
    local panel = CreateFrame("Frame", "DynamicUILayoutOptionsPanel")
    panel.name = "Dynamic UI Layout"

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Dynamic UI Layout Options")

    local toggle = CreateFrame("CheckButton", "DynamicUILayoutSuccessToggle", panel, "UICheckButtonTemplate")
    toggle:SetPoint("TOPRIGHT", -330, -80)
    
    -- fallback to true on first load
    local currentState = true
    if DynamicUILayoutDB and DynamicUILayoutDB.showSuccessMessage ~= nil then
        currentState = DynamicUILayoutDB.showSuccessMessage
    end
    toggle:SetChecked(currentState)
    
    local toggleText = toggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    toggleText:SetPoint("LEFT", toggle, "RIGHT", 5, 0)
    toggleText:SetText("Show successful dynamic layout change.")
    
    toggle:SetScript("OnClick", function(self)
        if DynamicUILayoutDB then
            DynamicUILayoutDB.showSuccessMessage = self:GetChecked()
        end
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    end)
    
    toggle:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Will print a chat message when the addon change the layout to the corresponding group size.", nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    
    toggle:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    CreateDropdown("DynamicUILayoutDrop5", panel, "<= 5 Players Layout:", "layout5", -80)
    CreateDropdown("DynamicUILayoutDrop10", panel, "10 Players Layout:", "layout10", -140)
    CreateDropdown("DynamicUILayoutDrop20", panel, "20 Players Layout:", "layout20", -200)
    CreateDropdown("DynamicUILayoutDrop40", panel, "40 Players Layout:", "layout40", -260)
    
    local data = C_EditMode.GetLayouts()
    if not data or not data.layouts or #data.layouts == 0 then
        local warning = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        warning:SetPoint("LEFT", panel, "LEFT", 250, 150)
        warning:SetPoint("RIGHT", panel, "RIGHT", -20, 150)
        warning:SetJustifyH("CENTER")
        warning:SetTextColor(1, 0, 0) 
        warning:SetText("You need to create at least one layout\nto be able to use the Dynamic UI Layout")
        
        local btn = CreateFrame("Button", "DynamicUILayoutEditModeBtn", panel, "UIPanelButtonTemplate")
        btn:SetSize(150, 30)
        btn:SetPoint("TOP", warning, "BOTTOM", 0, -20)
        btn:SetText("Open Edit Mode")
        btn:SetScript("OnClick", function()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
            if SettingsPanel then
                HideUIPanel(SettingsPanel)
            end
            if EditModeManagerFrame then
                EditModeManagerFrame:Show()
            end
        end)
    end
    
    local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(category)
end

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        DynamicUILayoutDB = DynamicUILayoutDB or {
            layout5 = 0,
            layout10 = 0,
            layout20 = 0,
            layout40 = 0
        }
        
        InitSettingsPanel()
    elseif event == "GROUP_ROSTER_UPDATE" then
        if DynamicUILayoutDB then
            AutoSwapLayout()
        end
    end
end)