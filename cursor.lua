local addonName, addonTable = ...

local f = CreateFrame("Frame", "CursorFinder", UIParent)

f:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, event, ...)
end)

local gOffsetX = 0
local gOffsetY = 0


function f:ADDON_LOADED(event, addon)
    if addon == addonName then
        self:Create()
    end
    -- C_Timer.After(10, function() print("asdf"); self:Create() end)
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
f:RegisterEvent("ADDON_LOADED")

-- again, the trick is to apply transformations after the model already has been rendered,
-- otherwise it'll not show on the initial login
local modelsToReset = {}
local nextrender_frame = CreateFrame("Frame")
local nextrender_counter = 2
local nextrender_func = function()
    if nextrender_counter > 0 then
        nextrender_counter = nextrender_counter - 1
        return
    end

    while next(modelsToReset) do
        local pm = next(modelsToReset)
        modelsToReset[pm] = nil
        if pm.transformations then
            pm:SetTransform(unpack(pm.transformations))
            pm:SetAlpha(1)
        end
    end
    nextrender_frame:SetScript("OnUpdate", nil)
    nextrender_counter = 2
end

nextrender_frame.enqueue = function(self, frame)
    modelsToReset[frame] = true
    if frame.transformations then
        frame:SetAlpha(0)
    end
    nextrender_frame:SetScript("OnUpdate", nextrender_func)
    nextrender_counter = 5
end

nextrender_frame.dequeue = function(self, frame)
    modelsToReset[frame] = nil
end

local Redraw = function(self)
    if not self.model_path then return end

    -- self:SetModelScale(1)
    -- self:SetPosition(0,0,0)

    -- if type(self.model_path) == "number" then
        -- self:SetDisplayInfo(self.model_path)
    -- else
    self:SetModel(self.model_path)
    nextrender_frame:enqueue(self)
end

local Clear = function(self)
    self:SetModel("spells/lightningbolt_missile.m2")
    self:ClearTransform()
end




function f:Create()
    local f = self
    -- spells/7fx_nightmare_missile.m2
    -- SPELLS/Monk_ForceSpere_Orb.m2
    f:SetWidth(100)
    f:SetHeight(100)

    local f1 = CreateFrame("PlayerModel", "CursorFinderLayer1",f)
    f1.model_path = 1327487
    f1:SetModel(1327487)
    f1:SetWidth(100)
    f1:SetHeight(100)
    f1.transformations = {0.0325,0.0295,0, rad(0), rad(0), rad(0), 0.0175}
    nextrender_frame:enqueue(f1)
    -- f1:SetTransform(unpack(f1.transformations))
    -- f1:SetAlpha(1)
    f1:SetPoint("CENTER",0, -18)
    f1:SetFrameStrata("BACKGROUND")
    f1:SetScript("OnShow", Redraw)
    f1:SetScript("OnHide", Clear)

    f.layer1 = f1

    local rad = math.rad

    local f2 = CreateFrame("PlayerModel", "CursorFinderLayer2",f)
    f2.model_path = 165693
    f2:SetModel(165693)
    f2:SetWidth(60)
    f2:SetHeight(60)
    f2.transformations = {0.02,0.0168,0, rad(90), rad(270), rad(270), 0.006}
    nextrender_frame:enqueue(f2)
    -- f2:SetTransform(unpack(f2.transformations))
    -- f2:SetAlpha(1)
    f2:SetPoint("CENTER",3, -15)
    f2:SetFrameStrata("BACKGROUND")
    f2:SetFrameLevel(3)
    f2:SetScript("OnShow", Redraw)
    f2:SetScript("OnHide", Clear)
    f2:Show()

    f.layer2 = f2

    local f3 = CreateFrame("PlayerModel", "CursorFinderLayer3",f)
    f3.model_path = 166497
    f3:SetModel(166497)
    f3:SetWidth(30)
    f3:SetHeight(30)
    -- f3:SetTransform(0.02,0.0168,0, rad(90), rad(270), rad(270), 0.006)
    f3:SetAlpha(1)
    f3:SetPoint("CENTER",0,0)
    f3:SetFrameStrata("TOOLTIP")
    f3:SetScript("OnShow", Redraw)
    f3:SetScript("OnHide", Clear)

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