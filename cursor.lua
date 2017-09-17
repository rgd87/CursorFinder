local addonName, addonTable = ...

local f = CreateFrame("Frame", "CursorFinder", UIParent)

f:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...)
end)

local gOffsetX = 0
local gOffsetY = 0


function f:PLAYER_LOGIN()
    self:Create()
    -- C_Timer.After(3, function() self:Create() end)
end

function f:SPELLS_CHANGED(event)
    local _, class = UnitClass("player")
    local spec = GetSpecialization()
    -- if class == "MONK" and spec == 1 then
    if true then
        f:Show()
    else
        f:Hide()
    end
end

f:RegisterEvent("SPELLS_CHANGED")
f:RegisterEvent("PLAYER_LOGIN")



-- function f:Enable()
--     -- self:RegisterEvent("PLAYER_ENTERING_WORLD")
--     -- self:RegisterUnitEvent("UNIT_AURA", "player")
--     -- self:RegisterEvent("QUEST_ACCEPTED")
--     -- self:RegisterEvent("QUEST_FINISHED") 
--     -- self:RegisterEvent("MERCHANT_CLOSED")
--     self:RegisterEvent("LOOT_CLOSED")
--     if not ticker then
--         ticker = C_Timer.NewTicker(5, unsheath)
--     end
-- end

-- function f:Disable()
--     -- self:UnregisterEvent("MERCHANT_CLOSED")
--     self:UnregisterEvent("LOOT_CLOSED")
--     if ticker then
--         ticker:Cancel()
--         ticker = nil
--     end
-- end

local Redraw = function(self)
    if not self.model_path then return end

    -- self:SetModelScale(1)
    -- self:SetPosition(0,0,0)

    -- if type(self.model_path) == "number" then
        -- self:SetDisplayInfo(self.model_path)
    -- else
    self:SetModel(self.model_path)
    if self.transformations then
        self:SetTransform(unpack(self.transformations))
    end
end



function f:Create()
    local f = self
    -- spells/7fx_nightmare_missile.m2
    -- SPELLS/Monk_ForceSpere_Orb.m2
    f:SetWidth(100)
    f:SetHeight(100)

    local f1 = CreateFrame("PlayerModel", "CursorFinderLayer1",f)
    f1.model_path = "spells/7fx_nightmare_missile.m2"
    f1:SetModel("spells/7fx_nightmare_missile.m2")
    f1:SetWidth(100)
    f1:SetHeight(100)
    f1.transformations = {0.0325,0.0295,0, rad(0), rad(0), rad(0), 0.0175}
    f1:SetTransform(unpack(f1.transformations))
    f1:SetAlpha(1)
    f1:SetPoint("CENTER",0, -18)
    f1:SetFrameStrata("BACKGROUND")
    f1:SetScript("OnShow", Redraw)

    f.layer1 = f1

    local rad = math.rad

    local f2 = CreateFrame("PlayerModel", "CursorFinderLayer2",f)
    f2.model_path = "spells/blessingoffreedom_state.m2"
    f2:SetModel("spells/blessingoffreedom_state.m2")
    f2:SetWidth(60)
    f2:SetHeight(60)
    f2.transformations = {0.02,0.0168,0, rad(90), rad(270), rad(270), 0.006}
    f2:SetTransform(unpack(f2.transformations))
    f2:SetAlpha(1)
    f2:SetPoint("CENTER",3, -15)
    f2:SetFrameStrata("BACKGROUND")
    f2:SetFrameLevel(3)
    f2:SetScript("OnShow", Redraw)

    f.layer2 = f2

    local f3 = CreateFrame("PlayerModel", "CursorFinderLayer3",f)
    f3.model_path = "spells/lightningbolt_missile.m2"
    f3:SetModel("spells/lightningbolt_missile.m2")
    f3:SetWidth(30)
    f3:SetHeight(30)
    -- f3:SetTransform(0.02,0.0168,0, rad(90), rad(270), rad(270), 0.006)
    f3:SetAlpha(1)
    f3:SetPoint("CENTER",0,0)
    f3:SetFrameStrata("TOOLTIP")
    f3:SetScript("OnShow", Redraw)

    f.layer3 = f3

    local previousX
    local previousY
    f:SetScript("OnUpdate", function(self, elapsed)
        local cursorX, cursorY = GetCursorPosition()
        if cursorX == previousX and cursorY == previousY then
            return
        end

        local uiScale = 1/UIParent:GetEffectiveScale()

        self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (cursorX+gOffsetX)*uiScale, (cursorY+gOffsetY)*uiScale)

        previousX = cursorX
        previousY = cursorY
    end)

    f:Show()
end