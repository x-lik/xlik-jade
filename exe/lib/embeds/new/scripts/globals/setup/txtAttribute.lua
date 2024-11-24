--- attribute&buff 属性配置

--- 游戏规定的抗性key
local resistance = { "stun", "silent", "unArm" }

--- 附魔元素对应图标路径
local elementIconPath = {
    dark = "icon/ability/Nightswallow",
    fire = "icon/ability/IncendiaryBonds",
    grass = "icon/ability/SpellLfieblood",
    ice = "icon/ability/Glacier",
    light = "icon/ability/HolyBolt",
    poison = "icon/ability/SummonDemonicGateway",
    rock = "icon/item/MiscQirajiCrystal01",
    steel = "icon/ability/FlameCrystal",
    thunder = "icon/ability/SplitLightning",
    water = "icon/ability/DeathknightFrozencenter",
    wind = "icon/ability/Greenengulfingtornado",
}

local T = true
local F = false
attribute.conf(F, "str", "力量", nil, "icon/ability/Strength3")
attribute.conf(F, "agi", "敏捷", nil, "icon/ability/RogueQuickRecovery")
attribute.conf(F, "int", "智力", nil, "icon/ability/DeclarationofGod")
attribute.conf(F, "aim", "命中", '%', "icon/ability/DeadlyDoubleLine")
attribute.conf(F, "animateScale", "动作", '%', "icon/ability/LightWork")
attribute.conf(F, "attack", "攻击", nil, "icon/ability/CrystalSlash")
attribute.conf(F, "attackRange", "攻击范围", nil, "icon/ability/HunterLockAndLoad")
attribute.conf(F, "attackRangeAcquire", "主动攻击范围", nil, "icon/ability/HunterLockAndLoad")
attribute.conf(F, "attackRipple", "攻击浮动")
attribute.conf(T, "attackSpace", "攻击间隔", "击每秒", "icon/ability/WarriorWeaponMastery")
attribute.conf(T, "attackSpaceBase", "原始攻击间隔", "击每秒", "icon/ability/WarriorWeaponMastery")
attribute.conf(F, "attackSpeed", "攻击速度", '%', "icon/ability/DemonhunterBladeDance")
attribute.conf(F, "breakArmor", "破甲", nil, "icon/ability/ShadowCurseOfSargeras")
attribute.conf(T, "castChant", "吟唱时间", "秒", "icon/ability/ShadowLastingAfflictions")
attribute.conf(T, "castChantPercent", "吟唱时间", '%', "icon/ability/ShadowLastingAfflictions")
attribute.conf(F, "castDistance", "施法距离", nil, "icon/ability/ShadowLastingAfflictions")
attribute.conf(F, "castDistancePercent", "施法距离", '%', "icon/ability/ShadowLastingAfflictions")
attribute.conf(T, "castKeep", "施法持续时间", "秒", "icon/ability/ShadowLastingAfflictions")
attribute.conf(T, "castKeepPercent", "施法持续时间", '%', "icon/ability/ShadowLastingAfflictions")
attribute.conf(F, "castRange", "施法范围", nil, "icon/ability/ShadowLastingAfflictions")
attribute.conf(F, "castRangePercent", "施法范围", '%', "icon/ability/ShadowLastingAfflictions")
attribute.conf(T, "coolDown", "冷却时间", "秒", "icon/ability/ShadowLastingAfflictions")
attribute.conf(T, "coolDownPercent", "冷却时间", '%', "icon/ability/ShadowLastingAfflictions")
attribute.conf(T, "cost", "施法消耗", nil, "icon/ability/ShadowLastingAfflictions")
attribute.conf(T, "costPercent", "施法消耗", '%', "icon/ability/ShadowLastingAfflictions")
attribute.conf(F, "defend", "防御", nil, "icon/ability/ThickFur")
attribute.conf(F, "hp", "HP", nil, "icon/ability/HPRecharge")
attribute.conf(F, "hpCur", "当前HP", nil, "icon/ability/HPRecharge")
attribute.conf(F, "hpRegen", "HP恢复", "每秒", "icon/ability/ReplenishHealth")
attribute.conf(F, "move", "移动", nil, "icon/ability/RogueFleetFooted")
attribute.conf(F, "mp", "MP", nil, "icon/ability/ManaRecharge2")
attribute.conf(F, "mpCur", "当前MP", nil, "icon/ability/ManaRecharge2")
attribute.conf(F, "nsight", "夜晚视野", nil, "icon/ability/SigntNight")
attribute.conf(F, "reborn", "复活时间", "秒", "icon/ability/HolyHolyGuidance")
attribute.conf(F, "rgba", "偏色", nil, "icon/ability/HunterBeastWithin")
attribute.conf(F, "sight", "白昼视野", nil, "icon/ability/SigntDay")
attribute.conf(F, "stun", "眩晕", '%', "icon/ability/Stun")
attribute.conf(F, "visible", "反隐范围", nil, "icon/ability/MagicalSentry")
attribute.conf(F, "unArm", "缴械", nil, "icon/ability/ShadowCurseOfMannoroth")
attribute.conf(F, "silent", "沉默", nil, "icon/ability/Silence")
attribute.conf(F, "invisible", "隐身", nil, "icon/ability/Vanish")
attribute.conf(F, "invulnerable", "无敌", '%', "icon/ability/Invulnerable")
--
EnchantForeach(function(k)
    local n = Enchant(k):name()
    local eip = elementIconPath[k]
    attribute.conf(F, k, n, nil, eip)
    attribute.conf(F, SYMBOL_E .. k, n .. "强化", '%', eip)
    attribute.conf(F, SYMBOL_E .. k .. "Weapon", n .. "武装", eip)
    attribute.conf(F, SYMBOL_E .. k .. "Append", n .. "附着", eip)
    attribute.conf(F, SYMBOL_EI .. k, n .. "免疫", eip)
    attribute.conf(F, SYMBOL_ODD .. SYMBOL_E .. k, n .. "几率", '%', eip)
    attribute.conf(F, SYMBOL_RES .. SYMBOL_E .. k, n .. "抗性", '%', eip)
end)
for _, v in ipairs(resistance) do
    attribute.conf(F, SYMBOL_RES .. v, attribute.label(v) .. "抗性", '%', attribute.icon(v))
end

-- 定义智能属性描述体
-- [基础信息]
---@param this Ability|Item
---@param options {level:number}
description.define("attributes", function(this, options)
    local attributes = this:modify("attributes")
    if (type(attributes) ~= "table" or #attributes == 0) then
        return nil
    end
    local desc = {}
    local lv = math.floor(options.level or this:level())
    for _, a in ipairs(attributes) do
        local param = a[1]
        local m2 = a[2] or 0
        local d1
        local d2
        if (type(m2) == "number") then
            d1 = m2
            d2 = a[3] or d1
        elseif (type(m2) == "string") then
            param = attribute.enParam(m2)
            d1 = a[3] or 0
            d2 = a[4] or d1
        end
        local label = attribute.label(param)
        if (nil ~= label) then
            local v = d1
            if (lv > 1) then
                v = v + (lv - 1) * d2
            end
            table.insert(desc, attribute.format(param, v))
        end
    end
    return desc
end)