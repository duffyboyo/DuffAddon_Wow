local function _speedLoot(enabled)
    for i = GetNumLootItems(), 1, -1 do
        if enabled then
            LootSlot(i)
        else
            -- only grab currencyID
            local type = GetLootSlotType(i)

            -- todo toggle message for showing loot in window as well as loot chat
            local icon, lootName, quantity, _, _, _, isQuestItem, _, _ = GetLootSlotInfo(i)

            if type >= 2 or isQuestItem then
                LootSlot(i)
            end
        end
    end
end

local function _checkEnabled()
    local enabled = false

    local checkAction = IsModifiedClick("AUTOLOOTTOGGLE")
    local autoLootEnabled = GetCVarBool("autoLootDefault")
    
    if autoLootEnabled ~= checkAction then
        enabled = true
    end

    return enabled
end

local function _runSpeedLoot()
    local enabled = _checkEnabled()
    _speedLoot(enabled)
end

function DuffAddon:LOOT_READY(event, ...)
    if not self.db.profile.enableSpeedLoot then
        return
    end
    _runSpeedLoot()
end

function DuffAddon:LOOT_OPENED(event, ...)
    if not self.db.profile.enableSpeedLoot then
        return
    end
    _runSpeedLoot()
end

function DuffAddon:IsEnableSpeedLoot(info)
	return self.db.profile.enableSpeedLoot
end

function DuffAddon:ToggleEnableSpeedLoot(info, value)
	self.db.profile.enableSpeedLoot = value
end