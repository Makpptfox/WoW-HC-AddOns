local SPF1 = SigmaProfessionFilter[1]

function SPF1:LeatrixPlusCompatibility()
    if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
        for i = 1, CRAFTS_DISPLAYED do
            if _G["Craft"..i] then
                _G["Craft"..i]:SetWidth(293)
            end
        end
        
        if SPF1.Headers and #SPF1.Headers == 0 and SPF1.FIRST then
            Craft1:ClearAllPoints()
            Craft1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 22, -81)
        else
            Craft1:ClearAllPoints()
            Craft1:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 22, -96)
        end
    end
end

hooksecurefunc("CraftFrame_Update", SPF1.LeatrixPlusCompatibility)

if (LeaPlusDB and LeaPlusDB["EnhanceProfessions"] == "On") then
    if CraftExpandTabRight then CraftExpandTabRight:Hide() end
    if CraftExpandTabMiddle then CraftExpandTabMiddle:Hide() end
    if CraftExpandTabLeft then CraftExpandTabLeft:Hide() end
end