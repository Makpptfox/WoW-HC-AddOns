-- CPArmor --

-- Create a hidden frame to register game events
local frame = CreateFrame("FRAME", "CPArmorFrame", PaperDollFrame)

local fontSize = 10 
local fontStyle = "OUTLINE"

-- Create and configure the display text element (FontString)
frame.text = CharacterModelFrame:CreateFontString(nil, "OVERLAY")
frame.text:SetFont("Fonts\\FRIZQT__.TTF", fontSize, fontStyle)
frame.text:SetTextColor(1, 1, 1)
frame.text:SetAlpha(0.5)

frame.text:SetPoint("TOPLEFT", CharacterModelFrame, "TOPLEFT", 2, -4)
frame.text:SetJustifyH("LEFT") 

-- Function to calculate and update armor stats
local function UpdateArmorStats()
    -- Including buffs
    local _, effectiveArmor = UnitArmor("player")
    
    -- For reduction calculation
    local playerLevel = UnitLevel("player")
    
    local reduction = PaperDollFrame_GetArmorReduction(effectiveArmor, playerLevel)
    
    frame.text:SetText(string.format("Armor: %d (%.1f%%)", effectiveArmor, reduction))
    
    frame.text:ClearAllPoints()
    
    -- handle 1.15.x retail-like model rotation buttons overlap
    if (CharacterModelFrameRotateLeftButton and CharacterModelFrameRotateLeftButton:IsShown()) 
    or (CharacterModelFrameRotateRightButton and CharacterModelFrameRotateRightButton:IsShown()) then
        frame.text:SetPoint("TOP", CharacterModelFrame, "TOP", 15, -4)
        frame.text:SetJustifyH("CENTER")
    else
        frame.text:SetPoint("TOPLEFT", CharacterModelFrame, "TOPLEFT", 2, -4) 
        frame.text:SetJustifyH("LEFT")
    end
end

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("UNIT_INVENTORY_CHANGED") 
frame:RegisterEvent("UNIT_AURA")             
frame:RegisterEvent("PLAYER_LEVEL_UP")    
frame:RegisterEvent("UNIT_STATS")
frame:RegisterEvent("UNIT_RESISTANCES")

frame:SetScript("OnEvent", function(self, event, unit)
    if (unit and unit ~= "player") then return end
    
    -- Check if the character frame is visible before updating
    if PaperDollFrame:IsVisible() then
        UpdateArmorStats()
    end
end)

PaperDollFrame:HookScript("OnShow", UpdateArmorStats)