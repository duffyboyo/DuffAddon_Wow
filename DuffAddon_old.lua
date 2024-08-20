
-- GLOBALS
-- So we know when the config has been loadedd
DuffAddon_VariablesLoaded = false
-- CONFIG
DuffAddonRealm = GetCVar("realmName");
DuffAddonChar = UnitName("player")
DuffAddonDetails = {
	name = "DuffAddon",
	frame = "frmDuffAddon",
	optionsframe = "frmDuffAddonConfigurationFrame"
}

local DuffAddon_defaultOn = true -- is addon enabled?
local DuffAddon_AutoRepairEnabled = true
local DuffAddon_KeyRemapEnabled = true


function DuffAddon_OnLoad()
	frmDuffAddon:SetScript("Onevent", DuffAddon_OnEvent);
	frmDuffAddon:RegisterEvent("MERCHANT_SHOW");
	frmDuffAddon:RegisterEvent("VARIABLES_LOADED");

	SLASH_DUFFADDON1, SLASH_DUFFADDON2 = '/da', '/duffaddon'

	DEFAULT_CHAT_FRAME:AddMessage("DUFF Addon loaded use /da or /duffaddon", 255, 255, 0);
end

function SlashCmdList.DUFFADDON(msg, editbox)
	local command, rest = msg:match("^(%S*)%s*(.-)$")

	if command=="repair" then
		if autoRepair==nil then
			autoRepair=0
		end
		if rest=="disable" then autoRepair=0;
		elseif rest=="self" then autoRepair=1;
		elseif rest=="guild" then autoRepair=2;
		else DEFAULT_CHAT_FRAME:AddMessage("/da repair [disable/self/guild]", 255, 255, 0); end

		repairStatus()

	end
end

function repairStatus()
	local repairText =
	{
		[0] = "auto repair is currently disabled",
		[1] = "auto repair will use own funds only",
		[2] = "auto repair will use guild funds then self"
	};

	if autoRepair==nil then
		autoRepair = 0;
	end

	DEFAULT_CHAT_FRAME:AddMessage("DUFFADDON: "..repairText[autoRepair], 255, 255, 0);
	
end

local function DuffAddon_MERCHANT_SHOW()
	if autoRepair >= 1 then
		doRepair(autoRepair)
	else
		DEFAULT_CHAT_FRAME:AddMessage("DUFFADDON: Not automatically repairing", 255, 255, 0);
	end
end

function DuffAddon_OnEvent(self, event)

	-- sort out vars here maybe
	if autoRepair==nil then
		autoRepair=0;
	end
	
	if ( event == "VARIABLES_LOADED" ) then

	end


	if(event == "MERCHANT_SHOW") then
		DuffAddon_MERCHANT_SHOW();
	end

end



function doRepair(autoRepair)
	local outputText = 
	{
		[0] = "You currently do not have enough funds to auto repair!",
		[1] = "Used own funds to repair!",
		[2] = "Used guild funds to repair!",
		[3] = "Unable to use guild bank, falling back to own gold"
	}

	local repairAllCost, canRepair = GetRepairAllCost();

	if(canRepair == false) then
		return;
	end

	local currentGold = GetMoney()

	if currentGold >= repairAllCost then
		if( IsInGuild() and CanGuildBankRepair() and autoRepair == 2) then
			RepairAllItems(true);
			DEFAULT_CHAT_FRAME:AddMessage("DUFFADDON: " .. outputText[autoRepair])
			return
		else
			DEFAULT_CHAT_FRAME:AddMessage("DUFFADDON: " .. outputText[3])
		end

		RepairAllItems(false);	
		DEFAULT_CHAT_FRAME:AddMessage("DUFFADDON: ".. outputText[1])
	else
		DEFAULT_CHAT_FRAME:AddMessage("DUFFADDON: ".. outputText[0])
		DEFAULT_CHAT_FRAME:AddMessage("You have: ".. GetCoinText(currentGold) .."/"..GetCoinText(repairAllCost))
		return
	end

	DEFAULT_CHAT_FRAME:AddMessage("DUFFADDON: Total Cost was - " .. GetCoinText(repairAllCost, ','))


end

