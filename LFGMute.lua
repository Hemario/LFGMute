local LFGMuteAddon = LibStub("AceAddon-3.0"):NewAddon("LFGMute")
LFGMuteAddon.ADDON_NAME = "LFGMute"
LFGMuteAddon.VERSION = GetAddOnMetadata("LFGMute", "Version")

local defaults = {
	global = {
		playOnce = true,
		playLoop = false,
	}
}

function LFGMuteAddon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("LFGMuteDB", defaults)
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable(LFGMuteAddon.ADDON_NAME, function() return LFGMuteAddon:GetConfigOptionsTable() end)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(LFGMuteAddon.ADDON_NAME)
	
	LFGMuteAddon:ApplySounds()
end

function LFGMuteAddon:GetConfigOptionsTable()
	return {
		name = "Options",
		type = "group",
		order = 1,
		args = {
			playOnce = {
				order = 1,
				type = "toggle",
				name = "PlayOnce",
				set = 	function(info, val)
							self.db.global.playOnce = val
							LFGMuteAddon:ApplySounds()
						end,
				get = function() return self.db.global.playOnce end
			},
			playLoop = {
				order = 2,
				type = "toggle",
				name = "PlayLoop",
				set = 	function(info, val)
							self.db.global.playLoop = val
							LFGMuteAddon:ApplySounds()
						end,
				get = function() return self.db.global.playLoop end
			}
		}
	}
end

function LFGMuteAddon:ApplySounds()
	local playOnce = self.db.global.playOnce or self.db.global.playLoop
	local playLoop = self.db.global.playLoop
	
	local playSound = function() PlaySound("UI_GroupFinderReceiveApplication") end
	
	QueueStatusMinimapButton.EyeHighlightAnim:SetScript("OnPlay", playOnce and playSound or nil)	
	QueueStatusMinimapButton.EyeHighlightAnim:SetScript("OnLoop", playLoop and playSound or nil)		
end
