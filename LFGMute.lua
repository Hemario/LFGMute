local LFGMuteAddon = LibStub("AceAddon-3.0"):NewAddon("LFGMute")
LFGMuteAddon.ADDON_NAME = "LFGMute"
LFGMuteAddon.VERSION = GetAddOnMetadata("LFGMute", "Version")

local SOUNDKIT = SOUNDKIT

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
                desc = "Play the ping sound only once.",
                order = 1,
                type = "toggle",
                name = "PlayOnce",
                set = function(info, val)
                    self.db.global.playOnce = val
                    LFGMuteAddon:ApplySounds()
                end,
                get = function() return self.db.global.playOnce end
            },
            playLoop = {
                desc = "Play the ping sound repeatedly.",
                order = 2,
                type = "toggle",
                name = "PlayLoop",
                set = function(info, val)
                        self.db.global.playLoop = val
                        LFGMuteAddon:ApplySounds()
                end,
                get = function() return self.db.global.playLoop end
            },
			outOfcombatOnly = {
				desc = "Play the ping sound only while out of Combat",
                order = 3,
                type = "toggle",
                name = "OutOfCombatOnly",
                set = function(info, val)
                    self.db.global.outOfcombatOnly = val
                    LFGMuteAddon:ApplySounds()
                end,
                get = function() return self.db.global.outOfcombatOnly end
			}
        }
    }
end

function LFGMuteAddon:ApplySounds()
	local playOnce = self.db.global.playOnce or self.db.global.playLoop
	local playLoop = self.db.global.playLoop
	local outOfcombatOnly = self.db.global.outOfcombatOnly
	
	local playSound = function() PlaySound(SOUNDKIT.UI_GROUP_FINDER_RECEIVE_APPLICATION, "master") end
	
	QueueStatusMinimapButton.EyeHighlightAnim:SetScript("OnPlay", ((outOfCombatOnly and not InCombatLockdown()) or not outOfCombatOnly) and playOnce and playSound or nil)	
	QueueStatusMinimapButton.EyeHighlightAnim:SetScript("OnLoop", ((outOfCombatOnly and not InCombatLockdown()) or not outOfCombatOnly) and playLoop and playSound or nil)		
end
