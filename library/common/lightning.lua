--- 闪电效果
--- 魔兽自带型
-----@class lightning
lightning = lightning or {}

--- 闪电效果类型
local m_lk = Mapping("lightningKind")
lightning.kind = {
    thunder = m_lk:set("CLPB", "闪电链主", { model = "BoltImpact" }),
    thunderLite = m_lk:set("CLSB", "闪电链次", { model = "BoltImpact" }),
    thunderShot = m_lk:set("CHIM", "闪电攻击", { model = "BoltImpact" }),
    thunderFork = m_lk:set("FORK", "叉状闪电", { model = "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl" }),
    thunderRed = m_lk:set("AFOD", "死亡之指", { model = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl" }),
    suck = m_lk:set("DRAB", "汲取", { model = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl" }),
    suckGreen = m_lk:set("DRAL", "生命汲取", { model = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl" }),
    suckBlue = m_lk:set("DRAM", "魔法汲取", { model = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl" }),
    cure = m_lk:set("HWPB", "医疗波主", { model = "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl" }),
    cureLite = m_lk:set("HWSB", "医疗波次", { model = "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl" }),
    soul = m_lk:set("SPLK", "灵魂锁链", { model = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl" }),
    manaBurn = m_lk:set("MBUR", "法力燃烧", { model = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl" }),
    manaFrame = m_lk:set("MFPB", "魔力之焰", { model = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl" }),
    manaChain = m_lk:set("LEAS", "魔法镣铐", { model = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl" }),
}

--- 检测是否属于有效的类型
---@param whichKind MappingValue lightning.kind.*
---@return boolean
function lightning.isValidKind(whichKind)
    return isMapping(whichKind, m_lk._kind)
end

--- 创建精简闪电特效
---@see lightning#kind
---@param kind MappingValue lightning.kind.*
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param duration number 持续时间，最少0.1秒
---@return number
function lightning.create(kind, x1, y1, z1, x2, y2, z2, duration)
    sync.must()
    must(lightning.isValidKind(kind), "kind@lightning.kind")
    x1 = x1 or 0
    y1 = y1 or 0
    z1 = z1 or 0
    x2 = x2 or 0
    y2 = y2 or 0
    z2 = z2 or 0
    duration = math.max(0.05, duration or 0)
    local l = J.AddLightningEx(kind.value, false, x1, y1, z1, x2, y2, z2)
    effector.point(kind.model, x2, y2, z2, 0.25)
    time.setTimeout(duration, function()
        J.DestroyLightning(l)
        l = nil
    end)
    return l
end