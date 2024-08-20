local map = {
	["Middle Mouse"] = "M3",
	["Mouse Wheel Down"] = "DWN",
	["Mouse Wheel Up"] = "UP",
	["Home"] = "Hm",
	["Insert"] = "Ins",
	["Page Down"] = "PD",
	["Page Up"] = "PU",
	["Spacebar"] = "SpB",
}

local patterns = {
	["Mouse Button "] = "M", -- M4, M5
	["Num Pad "] = "N",
	["a%-"] = "A", -- alt
	["c%-"] = "C", -- ctrl
	["s%-"] = "S", -- shift
}

local bars = {
	"ActionButton",
	"MultiBarBottomLeftButton",
	"MultiBarBottomRightButton",
	"MultiBarLeftButton",
	"MultiBarRightButton",
	"MultiBar7Button",
}

local function UpdateHotkey(self, actionButtonType)
	local hotkey = self.HotKey
	local text = hotkey:GetText()
	for k, v in pairs(patterns) do
		text = text:gsub(k, v)
	end
	hotkey:SetText(map[text] or text)
end

function DuffAddon:KeyRemap()
	if not self.db.profile.enableRemap then
		return
	end

	for _, bar in pairs(bars) do
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			hooksecurefunc(_G[bar..i], "UpdateHotkeys", UpdateHotkey)
		end
	end
end

function DuffAddon:IsEnableRemap(info)
	return self.db.profile.enableRemap
end

function DuffAddon:ToggleEnableRemap(info, value)
	self.db.profile.enableRemap = value
end