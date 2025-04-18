--- 闪电效果
--- 魔兽自带型
-----@class lightning
lightning = lightning or {}

--- 闪电效果类型
lightning.kind = {
    thunder = { value = "CLPB", label = "闪电链主", model = "BoltImpact" },
    thunderLite = { value = "CLSB", label = "闪电链次", model = "BoltImpact" },
    thunderShot = { value = "CHIM", label = "闪电攻击", model = "BoltImpact" },
    thunderFork = { value = "FORK", label = "叉状闪电", model = "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl" },
    thunderRed = { value = "AFOD", label = "死亡之指", model = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl" },
    suck = { value = "DRAB", label = "汲取", model = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl" },
    suckGreen = { value = "DRAL", label = "生命汲取", model = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl" },
    suckBlue = { value = "DRAM", label = "魔法汲取", model = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl" },
    cure = { value = "HWPB", label = "医疗波主", model = "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl" },
    cureLite = { value = "HWSB", label = "医疗波次", model = "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl" },
    soul = { value = "SPLK", label = "灵魂锁链", model = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl" },
    manaBurn = { value = "MBUR", label = "法力燃烧", model = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl" },
    manaFrame = { value = "MFPB", label = "魔力之焰", model = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl" },
    manaChain = { value = "LEAS", label = "魔法镣铐", model = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl" },
}

--- 检测是否属于有效的类型
---@param value table
---@return boolean
function lightning.isValid(value)
    return nil ~= lightning.kind[value]
end

--- 创建精简闪电特效
---@see lightning#kind
---@param kind table 看上面 lightning.kind
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
    must(lightning.isValid(kind), "kind@lightning.kind")
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