DuffAddon = LibStub("AceAddon-3.0"):NewAddon("DuffAddon", "AceConsole-3.0", "AceEvent-3.0")

local options = { 
	name = DuffAddon:GetName(),
	handler = DuffAddon,
	type = "group",
	args = {
        MainTitle = {
            type = "header",
            name = "Settings"
        },
        MainDescription = {
            type = "description",
            name = "Welcome to DuffAddon, this is where you can find the configuration options for my addon! \n\n"
        },
        EmptySpace = {
            type = "description",
            name = " "
        },
        RemapGroup = {
            name = "Key Remap",
            type = "group",
            args = {
                ToggleRemap = {
                    type = "toggle",
                    name = "Remap Key Names",
                    desc = "Changes the names of keys (e.g Num Pad X become NX) |cffff0000 Required Reload",
                    get = "IsEnableRemap",
                    set = "ToggleEnableRemap"
                },
                RemapDescription = {
                    type = "description",
                    name = "\nChanges the names of keys (e.g Num Pad X become NX) |cffff0000 Required Reload"
                },
                
            },
        },
        AutoRepairGroup = {
            name = "Auto Repair",
            type = "group",
            args = {
                ToggleRepair = {
                    type = "select",
                    values = {
                        [0] = "|cffff0000 Disabled",
                        [1] = "|cff00ff00 Self",
                        [2] = "|cff0000ff Guild"
                    },
                    name = "Automatically repair",
                    desc = "Changes or disables the functionality for auto repair on a subtible vendor.",
                    get = "GetRepairEnabled",
                    set = "SetRepairEnabled",
                    style = "radio"
                },
                RepairDescription = {
                    type = "description",
                    name = "Choose the option above for the functionality determing how auto repair will work \n\n |cffff0000 Disabled |cffffffff = No Auto Repair \n |cff00ff00 Self |cffffffff= Will use own funds to repair \n |cff0000ff Guild |cffffffff= Will attempt to use guild funds first, then own."
                },
            }
        },
        SpeedLootGroup = {
            name = "Speed Loot",
            type = "group",
            args = {
                ToggleRemap = {
                    type = "toggle",
                    name = "Enable Speed Loot",
                    desc = "Ensure that speed loot is enabled or disabled",
                    get = "IsEnableSpeedLoot",
                    set = "ToggleEnableSpeedLoot"
                },
                RemapDescription = {
                    type = "description",
                    name = "\nSpeeds up the looting process by hooking into the auto loot earlier"
                },
                
            },
        },
        ReadyReminderGroup = {
            name = "Ready Reminder",
            type = "group",
            args = {
                ToggleReadyReminder = {
                    type = "toggle",
                    name = "Enable Ready Reminder",
                    desc = "Ensure that ready reminder messagers are fully enabled or disabled",
                    get = "IsEnableReadyReminder",
                    set = "ToggleEnableReadyReminder"
                },
                ReadyDescription = {
                    type = "description",
                    name = "\nEnables the messages shown during ready checks to ensure things are good to go!"
                },
                
            },
        },
	},
}

local defaults = {
	profile = {
        repairEnabled = 0,
		enableRemap = true,
        enableSpeedLoot = true,
        enableReadyReminder = true
	},
}

function DuffAddon:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("DuffAddonDB", defaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("DuffAddon", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("DuffAddon", "DuffAddon")
    self:RegisterChatCommand("da", "SlashCommand")
	self:RegisterChatCommand("duffaddon", "SlashCommand")
    DuffAddon:KeyRemap()
end

function DuffAddon:OnEnable()
	-- Called when the addon is enabled
    
    -- used in DuffRepair
    self:RegisterEvent("MERCHANT_SHOW")

    -- used in DuffSpeedLoot
    self:RegisterEvent("LOOT_READY")
    self:RegisterEvent("LOOT_OPENED")

    -- used in DuffReadyReminder
    self:RegisterEvent("READY_CHECK")
end

function DuffAddon:OnDisable()
	-- Called when the addon is disabled
end

local function _printCommandHelp(selfr)
    selfr:Print("--------------|cff00ffff HELP|cffffffff --------------")
    selfr:Print("|cff00ffff al  - |cffffffffToggle auto loot on and off")
    selfr:Print("|cff00ffff ui |cffffffff - Show the addon ui.")
    selfr:Print("|cff00ffff <h/help> |cffffffff - print this help message")
    selfr:Print("----------------------------------")

end

function DuffAddon:SlashCommand(msg)

    -- auto loot toggle
	if msg == "al" then
        local currentValue = self.db.profile.enableSpeedLoot
        self.db.profile.enableSpeedLoot = not self.db.profile.enableSpeedLoot

        if not currentValue then
            self:Print("Auto loot is now |cff00ff00enabled")
        else
            self:Print("Auto loot is now |cffff0000off")
        end
    elseif msg == 'ui' then
        Settings.OpenToCategory(DuffAddon:GetName())
    elseif msg == 'killers' then
        for i = 1, 10, 1 do
            self:Print("|cFFA020F0killers in the jungle")
            UIErrorsFrame:AddMessage("killers in the jungle",1,0,0);
        end
    elseif msg == 'ft' then
        local f = CreateFrame("Frame",nil,UIParent);
        f:SetFrameStrata("BACKGROUND");
        f:SetWidth(128); -- Set these to whatever height/width is needed 
        f:SetHeight(64);-- for your Texture

        local t = f:CreateTexture(nil,"BACKGROUND");
        t:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Factions.blp");
        t:SetAllPoints(f);
        f.texture = t;

        f:SetPoint("CENTER",0,0);
        f:Show();
    elseif msg == 'load' then
        -- Load first custom slot
        EditModeManagerFrame:SelectLayout(3)
	elseif msg == 'h' or msg == 'help' then
        _printCommandHelp(self)
    else
        _printCommandHelp(self)
	end
end