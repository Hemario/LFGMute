local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local LFGMuteAddon = LibStub("AceAddon-3.0"):NewAddon("LFGMute")
LFGMuteAddon.ADDON_NAME = "LFGMute"
LFGMuteAddon.VERSION = GetAddOnMetadata("LFGMute", "Version")

local combatFrame = CreateFrame("Frame")
combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
combatFrame:SetScript("OnEvent", function(self, event) LFGMuteAddon:ApplySounds() end)

local SOUNDKIT = SOUNDKIT

local defaults = {
    global = {
        playOnce = true,
        playLoop = false,
        outOfcombatOnly = false,
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
                name = "Play Once",
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
                name = "Play Loop",
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
                name = "Out Of Combat Only",
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
    local combatCheck = not self.db.global.outOfcombatOnly or not UnitAffectingCombat("player")
    
    local playSound = function() 
		willPlay, soundHandle = PlaySound(SOUNDKIT.UI_GROUP_FINDER_RECEIVE_APPLICATION, "master")
		--print("PlaySound", GetTime(), willPlay, soundHandle)
	end
    
    QueueStatusButton.EyeHighlightAnim:SetScript("OnPlay", combatCheck and playOnce and playSound or nil)
    QueueStatusButton.EyeHighlightAnim:SetScript("OnLoop", combatCheck and playLoop and playSound or nil)
end

