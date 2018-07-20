--- Localize Vars
-- Addon
local addonName, addonTable = ...;
-- HeroLib
local HL = HeroLib;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = HL.Spell;
local Item = HL.Item;
local MouseOver = Unit.MouseOver;
-- Lua
local pairs = pairs;
local tableconcat = table.concat;
local tostring = tostring;
local tableinsert = table.insert;

if not Spell.Rogue then
    Spell.Rogue = {};
end
Spell.Rogue.Outlaw = {
    -- Racials
    ArcaneTorrent = Spell(25046),
    Berserking = Spell(26297),
    BloodFury = Spell(20572),
    Darkflight = Spell(68992),
    GiftoftheNaaru = Spell(59547),
    Shadowmeld = Spell(58984),
    -- Abilities
    AdrenalineRush = Spell(13750),
    Ambush = Spell(8676),
    BetweentheEyes = Spell(199804),
    BladeFlurry = Spell(13877),
    BladeFlurry2 = Spell(103828), -- Icon: Prot. Warrior Warbringer
    DeeperStratagem = Spell(193531),
    Opportunity = Spell(195627),
    PistolShot = Spell(185763),
    RolltheBones = Spell(193316),
    RunThrough = Spell(2098),
    SaberSlash = Spell(193315),
    Stealth = Spell(1784),
    Vanish = Spell(1856),
    VanishBuff = Spell(11327),
    SaberSlashV = Spell(224807),
    -- Talents
    Alacrity = Spell(193539),
    AlacrityBuff = Spell(193538),
    Anticipation = Spell(114015),
    CannonballBarrage = Spell(185767),
    DeathfromAbove = Spell(152150),
    DeeperStratagem = Spell(193531),
    DirtyTricks = Spell(108216),
    GhostlyStrike = Spell(196937),
    KillingSpree = Spell(51690),
    MarkedforDeath = Spell(137619),
    QuickDraw = Spell(196938),
    SliceandDice = Spell(5171),
    Vigor = Spell(14983),
    -- Artifact
    Blunderbuss = Spell(202895),
    CurseoftheDreadblades = Spell(202665),
    HiddenBlade = Spell(202754),
    LoadedDice = Spell(256171),
    -- Defensive
    CrimsonVial = Spell(185311),
    Feint = Spell(1966),
    -- Utility
    Gouge = Spell(1776),
    Kick = Spell(1766),
    Sprint = Spell(2983),
    -- Roll the Bones
    Broadside = Spell(193356),
    BuriedTreasure = Spell(199600),
    GrandMelee = Spell(193358),
    SkullandCrossbones = Spell(199603),
    RuthlessPrecision = Spell(193357),
    TrueBearing = Spell(193359),
    -- Legendaries
    GreenskinsWaterloggedWristcuffs = Spell(209423)
}
local S = Spell.Rogue.Outlaw;

local RtB_BuffsList = {
    S.Broadside,
    S.BuriedTreasure,
    S.GrandMelee,
    S.SkullandCrossbones,
    S.RuthlessPrecision,
    S.TrueBearing
};

if not Item.Rogue then Item.Rogue = {}; end
Item.Rogue.Outlaw = {
    -- Legendaries
    GreenskinsWaterloggedWristcuffs = Item(137099, { 9 }),
    MantleoftheMasterAssassin = Item(144236, { 3 }),
    ShivarranSymmetry = Item(141321, { 10 }),
    ThraxisTricksyTreads = Item(137031, { 8 })
};
local I = Item.Rogue.Outlaw;

local function RtB_Buffs()
    if not Cache.APLVar.RtB_Buffs then
        Cache.APLVar.RtB_Buffs = 0;
        for i = 1, #RtB_BuffsList do
            if Player:BuffP(RtB_BuffsList[i]) then
                Cache.APLVar.RtB_Buffs = Cache.APLVar.RtB_Buffs + 1;
            end
        end
    end
    return Cache.APLVar.RtB_Buffs;
end

local function RtB_BuffRemains()
    if not Cache.APLVar.RtB_BuffRemains then
        Cache.APLVar.RtB_BuffRemains = 0;
        for i = 1, #RtB_BuffsList do
            if Player:Buff(RtB_BuffsList[i]) then
                Cache.APLVar.RtB_BuffRemains = Player:BuffRemainsP(RtB_BuffsList[i]);
                break ;
            end
        end
    end
    return Cache.APLVar.RtB_BuffRemains;
end

local function EnergyTimeToMaxRounded()
    -- Round to the nearesth 10th to reduce prediction instability on very high regen rates
    return math.floor(Player:EnergyTimeToMaxPredicted() * 10 + 0.5) / 10;
end
	






local function APL()
    if not Player:AffectingCombat() then
        return 462338
    end
    HL.GetEnemies("Melee");
    HL.GetEnemies(8, true);
    HL.GetEnemies(10, true);
    HL.GetEnemies(11, true);
    
    
    
    
    
    
--ROT START

	if RubimRH.AoEON() and RubimRH.CDsON() and S.KillingSpree:IsReady() and Cache.EnemiesCount[8] >= 2 and Player:BuffP(S.BladeFlurry) then
    		return S.KillingSpree:Cast()
    end
    
    if RubimRH.AoEON() and S.BladeFlurry:IsReady() and Cache.EnemiesCount[8] >= 2 and not Player:BuffP(S.BladeFlurry) then
    		return S.BladeFlurry:Cast()
    end
    
    if S.Ambush:IsReady() and Target:IsInRange(S.Ambush) and Player:IsStealthed() then
    		return S.Ambush:Cast()
    end
    
    if S.AdrenalineRush:IsReady() and not Player:IsStealthed() and Target:IsInRange(S.SaberSlash) and RubimRH.CDsON() and Player:EnergyDeficitPredicted() > 0 then
            return S.AdrenalineRush:Cast()
    end
    
    if S.MarkedforDeath:IsReady() and not Player:IsStealthed() and Target:IsInRange(S.SaberSlash) and Player:ComboPointsDeficit() >= 5 then
            return S.MarkedforDeath:Cast()
    end
    
    if S.GhostlyStrike:IsReady() and not Player:IsStealthed() and Target:IsInRange(S.GhostlyStrike) and ((Player:ComboPoints() == 4 and not Player:BuffP(S.Broadside)) or (Player:ComboPoints() == 3 and Player:BuffP(S.Broadside))) then
            return S.GhostlyStrike:Cast()
    end
    
    if S.RolltheBones:IsReady() and (Player:ComboPoints() >= 4 or (Player:ComboPoints() >= 3 and Player:BuffP(S.Broadside))) and (RtB_BuffRemains() <= 5 or (Player:BuffP(S.LoadedDice) and RtB_Buffs() < 2) or (RtB_Buffs() < 2 and not (Player:BuffP(S.GrandMelee) or Player:BuffP(S.RuthlessPrecision)))) then
    		return S.RolltheBones:Cast()
    end
    
    if S.BetweentheEyes:IsReady() and Player:ComboPoints() >= 5 and Player:BuffP(S.RuthlessPrecision) and Target:IsInRange(S.BetweentheEyes) and not Player:IsStealthed() then
    		return S.BetweentheEyes:Cast()
    end
    			if S.BetweentheEyes:IsReady() and I.GreenskinsWaterloggedWristcuffs:IsEquipped() and Player:ComboPoints() >= 5 then
    					return S.BetweentheEyes:Cast()
   		 		end
    
    if S.RunThrough:IsReady() and not I.GreenskinsWaterloggedWristcuffs:IsEquipped() and not Player:BuffP(S.RuthlessPrecision) and not Player:IsStealthed() and Target:IsInRange(S.RunThrough) and (Player:ComboPoints() >= 4 or (Player:ComboPoints() >= 3 and Player:BuffP(S.Broadside))) then
            return S.RunThrough:Cast()
    end
    		    if S.RunThrough:IsReady() and not S.BetweentheEyes:CooldownUp() and not Player:IsStealthed() and Target:IsInRange(S.RunThrough) and (Player:ComboPoints() >= 4 or (Player:ComboPoints() >= 3 and Player:BuffP(S.Broadside))) then
            			return S.RunThrough:Cast()
   				end
   						if S.RunThrough:IsReady() and I.GreenskinsWaterloggedWristcuffs:IsEquipped() and not S.BetweentheEyes:CooldownUp() and not Player:IsStealthed() and Target:IsInRange(S.RunThrough) and (Player:ComboPoints() >= 4 or (Player:ComboPoints() >= 3 and Player:BuffP(S.Broadside))) then
            					return S.RunThrough:Cast()
   					    end
    
    if S.PistolShot:IsReady() and not Player:IsStealthed() and Target:IsInRange(S.PistolShot) and (((((Player:ComboPointsDeficit() >= 2 and S.QuickDraw:IsAvailable()) or (Player:ComboPointsDeficit() >= 1 and not S.QuickDraw:IsAvailable())) and not Player:BuffP(S.Broadside)) or ((Player:ComboPointsDeficit() >= 3 and S.QuickDraw:IsAvailable()) or (Player:ComboPointsDeficit() >= 2 and not S.QuickDraw:IsAvailable())) and Player:BuffP(S.Broadside))) and Player:BuffP(S.Opportunity) then
            return S.PistolShot:Cast()
    end
    	        if not Target:IsInRange(S.SaberSlash) and not Player:IsStealthed() and S.PistolShot:IsReady(20) and not Player:IsStealthed() and Player:EnergyDeficitPredicted() < 25 and (Player:ComboPointsDeficit() >= 1 or EnergyTimeToMaxRounded() <= 1.2) then
            			return S.PistolShot:Cast()
            	end
            			if S.PistolShot:IsReady() and not Player:IsStealthed() and Target:IsInRange(S.PistolShot) and Player:ComboPointsDeficit() >= 1 and Player:BuffP(S.GreenskinsWaterloggedWristcuffs) then
            					return S.PistolShot:Cast()
    					end
    
    if S.SaberSlash:IsReady() and not Player:IsStealthed() and Target:IsInRange(S.SaberSlash) and (Player:ComboPointsDeficit() >= 1 and not Player:BuffP(S.Broadside) or (Player:BuffP(S.Broadside) and (Player:ComboPointsDeficit() >= 1 and I.GreenskinsWaterloggedWristcuffs:IsEquipped()) or (Player:ComboPointsDeficit() >= 2 and not I.GreenskinsWaterloggedWristcuffs:IsEquipped()))) then
            return S.SaberSlashV:Cast()
    end
    		    if S.SaberSlash:IsReady() and not Player:IsStealthed() and Target:IsInRange(S.SaberSlash) and (Player:ComboPointsDeficit() >= 1-1 and Player:BuffP(S.RuthlessPrecision) and S.BetweentheEyes:CooldownUp()) then
            			return S.SaberSlashV:Cast()
    			end
        
        
        
        
        
        
        
        
        
        
        
    --ROT END

    return 0, 975743
end




RubimRH.Rotation.SetAPL(260, APL);

local function PASSIVE()
    return RubimRH.Shared()
end

RubimRH.Rotation.SetPASSIVE(260, PASSIVE);