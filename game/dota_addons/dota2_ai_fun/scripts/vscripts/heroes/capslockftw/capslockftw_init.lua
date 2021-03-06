
local tNewAbilities = {
	"capslockftw_flamer",
	"capslockftw_hax",
	"capslockftw_sarcasm",
	"generic_hidden",
	"generic_hidden",
	"capslockftw_ban",
	"special_bonus_gold_income_120",
	"special_bonus_exp_boost_30",
	"special_bonus_attack_speed_40",
	"special_bonus_unique_capslockftw_2",
	"special_bonus_armor_15",
	"special_bonus_attack_range_200",
	"special_bonus_unique_capslockftw_1",
	"special_bonus_cooldown_reduction_50"
}

local tHeroBaseStats = {
	MovementSpeed = 300,
	AttackRate = 1.6,
	AttackAnimationPoint = 0.5,
	AttackDamageMin = 19,
	AttackDamageMax = 28,
	AttackRange = 550,
	AttributeBaseStrength = 20,
	AttributeBaseAgility = 25,
	AttributeBaseIntelligence = 18,
	AttributeStrengthGain = 2.2,
	AttributeAgilityGain = 2.7,
	AttributeIntelligenceGain = 1.7,
	ArmorPhysical = 0,
	PrimaryAttribute = DOTA_ATTRIBUTE_AGILITY,
}

CustomNetTables:SetTableValue("fun_hero_stats", "capslockftw_abilities", tNewAbilities)
CustomNetTables:SetTableValue("fun_hero_stats", "capslockftw", tHeroBaseStats)
GameMode:FunHeroScepterUpgradeInfo("capslockftw", tNewAbilities)




function CAPSLOCKFTWInit(hHero, context)
	hHero:AddNewModifier(hHero, nil, "modifier_attribute_indicator_capslockftw", {})	
	GameMode:InitiateHeroStats(hHero, tNewAbilities, tHeroBaseStats)	
end