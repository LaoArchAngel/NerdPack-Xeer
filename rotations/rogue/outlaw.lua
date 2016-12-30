local _, Xeer = ...

local GUI = {
	{type = 'checkbox', text = 'Adrenaline Rush in Rot', key = 'XrOutlawAr', default = true},
	{type = 'checkbox', text = 'Curse of the Dreadblades in Rot', key = 'XrOutlawCotd', default = true},
	{type = 'checkbox', text = 'Marked for Death in Rot', key = 'XrOutlawMfd', default = true},
	{type = 'checkbox', text = 'Vanish in Rot', key = 'XrOutlawVanish', default = true},
}

local exeOnLoad = function()
	 Xeer.ExeOnLoad()

	print("|cffFFFF00 ----------------------------------------------------------------------|r")
	print("|cffFFFF00 --- |rCLASS NAME:ROGUE |cffFFF569Outlaw |r")
	print("|cffFFFF00 --- |rRecommended Talents: 1/1 - 2/3 - 3/1 - 4/X - 5/1 - 6/2 - 7/2")
	print("|cffFFFF00 ----------------------------------------------------------------------|r")

	end

local Interrupts = {
	{'Kick'},
}

local build = {
--# Builders
	{'Ambush', 'target.inMelee & target.infront & player.buff(Stealth)'},
	{'Ghostly Strike', 'combo_points.deficit > 0 & target.debuff(Ghostly Strike).duration <= gcd'},
	{'Pistol Shot', 'player.buff(Opportunity) & timetomax > gcd & combo_points.deficit > PistolShotCP & {!player.buff(Curse of the Dreadblades) || player.energy < 50}'},
	{'Saber Slash', 'combo_points.deficit > 1 & {!player.buffs(Broadsides) || combo_points.deficit > 2}'},
}

local finish = {
--# Finishers
	-- Only use Between the Eyes on single target.  Blade Flurry causes this to be a DPS loss.
	{'Between the Eyes', 'player.buff(Shark Infested Waters) & !player.buff(Blade Flurry)'},
	{'Death from Above', '!player.buff(Adrenaline Rush) & !player.buff(True Bearing)'},
	{'Run Through'},
}

local bf = {
--# Blade Flurry
	{'Blade Flurry', 'player.area(5).enemies > 1 & !player.buff(Blade Flurry)'},
	{'Blade Flurry', 'player.area(5).enemies < 2 & player.buff(Blade Flurry)'},
}

local rotCds = {
	{'Adrenaline Rush', 'UI(XrOutlawAr) & timetomax > gcd & target.deathin > 15'},
	{'Curse of the Dreadblades', 'UI(XrOutlawCotd) & {!talent(1,1) || target.debuff(Ghostly Strike)} & {player.buff(Adrenaline Rush) || player.spell(Adrenaline Rush).cooldown < 6 || player.spell(Adrenaline Rush).cooldown > 120} & {player.combopoints == 0 || player.combopoints > 4}'},
	{'Marked for Death', 'UI(XrOutlawMfd) & combo_points.deficit > 4 & !player.buff(Curse of the Dreadblades)'},
	{'Vanish', 'UI(XrOutlawVanish) & !player.buff(Curse of the Dreadblades) & player.energy >= 50 & ingroup'},
}

local cds = {
--# Cooldowns
	{'Cannonball Barrage', 'player.area(7).enemies > 2', 'player.ground'},
	{'Adrenaline Rush', 'timetomax > gcd & target.deathin > 15'},
	{'Marked for Death', 'combo_points.deficit > 4 & !player.buff(Curse of the Dreadblades)'},
	{'Curse of the Dreadblades', 'CanUseDreadblades & {!talent(1,1) || target.debuff(Ghostly Strike)} & {player.buff(Adrenaline Rush) || player.spell(Adrenaline Rush).cooldown == 0 || player.spell(Adrenaline Rush).cooldown > 120} & {player.combopoints == 0 || player.combopoints > 4}'},
	{'Riposte'},
}

local xCombat = {
	{bf},
	{'Roll the Bones', 'player.combopoints > 3 && !RtB'},
	{Main_rotation, 'RtB'},
	{cds, 'toggle(cooldowns)'},
	{rotCds},
	{build, 'combo_points.deficit > 0'},
	{finish, 'player.combopoints > 4'},
	{'/startattack'}
}

local Survival ={
	{'Crimson Vial', 'player.health <= 60'},
}

local Keybinds = {
	-- Pause
	{'%pause', 'keybind(alt)'},
}

local inCombat = {
	{Keybinds},
	{Interrupts, 'target.interruptAt(46) & toggle(interrupts) & target.infront & target.inMelee & !player.buff(Stealth)'},
	{Survival, 'player.health < 100'},
	{xCombat, 'target.inMelee	& target.infront & target.alive & target.enemy'},
}

local outCombat = {
	{'Stealth', '!player.buff(Stealth)'},
	{'Ambush', 'target.inMelee & target.infront & player.buff(Vanish)'},
	{Keybinds},
}

NeP.CR:Add(260, {
	name = '[|cff'..Xeer.addonColor..'Xeer|r] ROGUE - Outlaw',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
