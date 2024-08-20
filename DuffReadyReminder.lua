-- idea here is that some usefull information will be shown in the message box on ready check.


-- testing adding to global to see if i can override the existing interface
StaticPopupDialogs["EXAMPLE_CTRA_READY"] = {
    text = "%s has performed a ready check.  Are you ready?",
    -- YES, NO, ACCEPT, CANCEL, etc, are global WoW variables containing localized
    -- strings, and should be used wherever possible.
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        CT_RA_SendReady()
    end,
    OnCancel = function (_,_, reason)
        if reason == "timeout" or reason == "clicked" then
            CT_RA_SendNotReady()
        else
            -- "override" ...?
        end;
    end,
    sound = "levelup2",
    timeout = 30,
    whileDead = true,
    hideOnEscape = true,
}


local function _getDurabilityPercentage()
    local totalMin = 0
    local totalMax = 0

    for slotName, slotID in pairs(Enum.InventoryType) do
        print(slotName)
        local Minimum, Maximum = GetInventoryItemDurability(slotID)
        local location = slotName

        if Minimum and Maximum and location then 
            totalMin = totalMin + Minimum
            totalMax = totalMax + Maximum
        end
    end
    return ((totalMin / totalMax) * 100)
end

local function _getCurrentEquippedItemLevel()
    for slotName, slotID in pairs(Enum.InventoryType) do
        local link = GetInventoryItemLink("player", slotID)
        print(slotName)
        if not link then break end

        itemName, _, _, itemLevel = GetItemInfo(link);
        print(itemName .. " : " .. itemLevel)
    end
end

function DuffAddon:READY_CHECK()
    local durability = _getDurabilityPercentage()
    self:Print("Durability: " .. math.floor(durability) .. "%")
    local frame = RCC_TalentFrame or CreateFrame("Frame", "RCC_TalentFrame", UIParent)
    frame:SetSize(100 + 2, 50 + 10)
    frame:ClearAllPoints()
    frame:SetPoint("CENTER")
    frame:Show()

    local bSelect = RCC_TalentButton or CreateFrame("Button", "RCC_TalentButton", RCC_TalentFrame, "UIMenuButtonStretchTemplate")
    bSelect:SetText('Are you rrrr ready?\n YES')
    bSelect:SetSize(150*1, 75*1)
    bSelect:SetPoint("CENTER", RCC_TalentFrame, "CENTER", 0, 0)
    bSelect:SetScript("OnClick", function(self)
        RCC_TalentFrame:Hide()
    end)
    -- _getCurrentEquippedItemLevel()
end

function DuffAddon:IsEnableReadyReminder(info)
	return self.db.profile.enableReadyReminder
end

function DuffAddon:ToggleEnableReadyReminder(info, value)
	self.db.profile.enableReadyReminder = value
end