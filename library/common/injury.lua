--- 受伤过程
--- 绑定进攻过程虚实转化的相应方法
--- 主要用于common/player
---@class injury
injury = injury or {}

--- 伤害类型
--- 使用下方@type编写注释方便伤害类型引用，实际上伤害类型需要使用Enchant注册方可正确使用，如Enchant("fire", "火")
--- 单单加入注释在伤害判定中是无法识别的，必须使用Enchant注册
--- 当使用未附魔的类型进行伤害时会提示报错，所以不用担心类型忘记注册
--- 更多Enchant注册例子可参考/new/scripts/globals/setup/enchant.lua
--- 已编写部分常见类型，如physics,magic,fire，可以继续添加注释支持你的类型
local m_dt = Mapping("damageType")
---@type {common:MappingValue,physics:MappingValue,magic:MappingValue,fire:MappingValue,rock:MappingValue,water:MappingValue,ice:MappingValue,wind:MappingValue,light:MappingValue,dark:MappingValue,grass:MappingValue,thunder:MappingValue,poison:MappingValue,steel:MappingValue}
injury.damageType = injury.damageType or {
    common = m_dt:set("common", "常规"),
}
--- 伤害来源
local m_ds = Mapping("damageSrc")
injury.damageSrc = {
    common = m_ds:set("common", "常规"),
    attack = m_ds:set("attack", "攻击"),
    ability = m_ds:set("ability", "技能"),
    item = m_ds:set("item", "物品"),
    rebound = m_ds:set("rebound", "反伤"),
    reaction = m_ds:set("reaction", "附魔反应"),
}
--- 无视防御类型
local m_bat = Mapping("breakArmorType")
injury.breakArmorType = {
    defend = m_bat:set("defend", "防御"),
    avoid = m_bat:set("avoid", "回避"),
    invincible = m_bat:set("invincible", "无敌"),
}

--- 检测是否有效的伤害类型
---@param whichType table injury.damageType.*
---@return boolean
function injury.isValidDamageType(whichType)
    return isMapping(whichType, m_dt._kind)
end

--- 检测是否有效的伤害来源
---@param whichSrc table injury.damageSrc.*
---@return boolean
function injury.isValidDamageSrc(whichSrc)
    return isMapping(whichSrc, m_ds._kind)
end

--- 检测是否有效的无视防御类型
---@param whichType table injury.breakArmorType.*
---@return boolean
function injury.isValidBreakArmorType(whichType)
    return isMapping(whichType, m_bat._kind)
end

--- [受伤过程]抵达
---@param sourceUnit Unit
---@param targetUnit Unit
---@param extraData table 额外数据
---@return void
function injury.arrive(sourceUnit, targetUnit, extraData)
    sync.must()
    if (false == class.isObject(sourceUnit, UnitClass) or false == class.isObject(targetUnit, UnitClass)) then
        return
    end
    if (sourceUnit:isDead() or targetUnit:isDead()) then
        return
    end
    if (sourceUnit:weaponSoundMode() == 1) then
        sound.vwp(sourceUnit, targetUnit)
    end
    local dmg = sourceUnit:attack() + math.rand(0, sourceUnit:attackRipple())
    if (dmg >= 1) then
        local as = sourceUnit:assault()
        ability.damage({
            sourceUnit = sourceUnit,
            targetUnit = targetUnit,
            damage = dmg,
            damageSrc = injury.damageSrc.attack,
            damageType = as:damageType(),
            damageTypeLevel = as:damageTypeLevel(),
            extra = extraData,
        })
    end
end

--- [受伤过程]攻击
---@param sourceUnit Unit
---@param targetUnit Unit
---@param extraData table 额外数据
---@return void
function injury.attack(sourceUnit, targetUnit, extraData)
    sync.must()
    if (false == class.isObject(sourceUnit, UnitClass) or false == class.isObject(targetUnit, UnitClass)) then
        return
    end
    if (sourceUnit:isDead() or targetUnit:isDead()) then
        return
    end
    local as = sourceUnit:assault()
    local mode = as:mode()
    if (mode == "instant") then
        injury.arrive(sourceUnit, targetUnit, extraData)
    elseif (mode == "lightning") then
        local lDur = 0.3
        local lDelay = lDur * 0.6
        local focus = as:focus()
        if (focus < 1) then
            focus = 1
        end
        local x1, y1, z1 = sourceUnit:x(), sourceUnit:y(), sourceUnit:h() + sourceUnit:weaponHeight()
        local x2, y2, z2 = targetUnit:x(), targetUnit:y(), targetUnit:h() + targetUnit:stature() / 2 + math.rand(30, 70)
        x1, y1 = vector2.polar(x1, y1, sourceUnit:weaponLength(), vector2.angle(x1, y1, x2, y2))
        for _ = 1, focus do
            lightning.create(as:model(), x1, y1, z1, x2, y2, z2, lDur)
            time.setTimeout(lDelay, function()
                injury.arrive(sourceUnit, targetUnit, extraData)
            end)
        end
        if (as:scatter() > 0 and as:radius() > 0) then
            Group(UnitClass):forEach({
                limit = as:scatter(),
                circle = {
                    x = targetUnit:x(),
                    y = targetUnit:y(),
                    radius = as:radius(),
                },
                filter = function(enumUnit)
                    return enumUnit:isOther(targetUnit) and enumUnit:isAlive() and enumUnit:isEnemy(sourceUnit:owner())
                end
            }, function(enumUnit)
                x1, y1, z1 = sourceUnit:x(), sourceUnit:y(), sourceUnit:h() + sourceUnit:weaponHeight()
                x2, y2, z2 = enumUnit:x(), enumUnit:y(), enumUnit:h() + targetUnit:stature() / 2 + math.rand(30, 70)
                x1, y1 = vector2.polar(x1, y1, sourceUnit:weaponLength(), vector2.angle(x1, y1, x2, y2))
                lightning.create(as:model(), x1, y1, z1, x2, y2, z2, lDur)
                time.setTimeout(lDelay, function()
                    injury.arrive(sourceUnit, enumUnit, extraData)
                end)
            end)
        end
    elseif (mode == "missile") then
        local gatling = as:gatling()
        local options = {
            model = as:model(),
            scale = sourceUnit:modelScale(),
            sourceUnit = sourceUnit,
            targetUnit = targetUnit,
            scale = as:scale(),
            speed = as:speed(),
            height = as:height(),
            weaponHeight = sourceUnit:weaponHeight(),
            weaponLength = sourceUnit:weaponLength(),
            acceleration = as:acceleration(),
            twist = as:twist(),
            reflex = as:reflex(),
            onEnd = function(opt, vec)
                if (vector2.distance(vec[1], vec[2], opt.targetUnit:x(), opt.targetUnit:y()) <= 100) then
                    injury.arrive(opt.sourceUnit, opt.targetUnit, extraData)
                    return true
                end
                return false
            end,
        }
        if (false == as:homing()) then
            options.targetVec = { targetUnit:x(), targetUnit:y(), targetUnit:h() + targetUnit:stature() / 2 + math.rand(30, 70) }
        end
        ability.missile(options)
        if (gatling > 0) then
            time.setInterval(0.27, function(gatlingTimer)
                if (gatling <= 0
                    or false == class.isObject(sourceUnit, UnitClass) or sourceUnit:isDead()
                    or false == class.isObject(targetUnit, UnitClass) or targetUnit:isDead()) then
                    class.destroy(gatlingTimer)
                    return
                end
                gatling = gatling - 1
                local gatlingOptions = setmetatable({}, { __index = options })
                if (false == as:homing()) then
                    gatlingOptions.targetVec = { targetUnit:x(), targetUnit:y(), targetUnit:h() + targetUnit:stature() / 2 + math.rand(30, 70) }
                end
                ability.missile(gatlingOptions)
            end)
        end
        if (as:scatter() > 0 and as:radius() > 0) then
            Group(UnitClass):forEach({
                limit = as:scatter(),
                circle = {
                    x = targetUnit:x(),
                    y = targetUnit:y(),
                    radius = as:radius(),
                },
                filter = function(enumUnit)
                    return enumUnit:isOther(targetUnit) and enumUnit:isAlive() and enumUnit:isEnemy(sourceUnit:owner())
                end
            }, function(enumUnit)
                local scatterOptions = setmetatable({ targetUnit = enumUnit }, { __index = options })
                if (false == as:homing()) then
                    scatterOptions.targetVec = { enumUnit:x(), enumUnit:y(), enumUnit:h() + enumUnit:stature() / 2 + math.rand(30, 70) }
                end
                ability.missile(scatterOptions)
            end)
        end
    end
end

--- [受伤过程]死亡
---@param deadUnit Unit
---@return void
function injury.kill(deadUnit)
    sync.must()
    if (false == class.isObject(deadUnit, UnitClass)) then
        return
    end
    --- tyre切换，timer终止
    local tyre = deadUnit._moveTyre
    if (class.isObject(tyre.timer, TimerClass)) then
        class.destroy(tyre.timer)
        tyre.timer = nil
    end
    local x, y = deadUnit:x(), deadUnit:y()
    superposition.plus(deadUnit, "dead")
    --- 触发击杀事件
    local killer = deadUnit:lastHurtSource()
    if (class.isObject(killer, UnitClass)) then
        event.syncTrigger(killer, eventKind.unitKill, { targetUnit = deadUnit })
    end
    -- 复活判断
    local rebornDelay = deadUnit:reborn()
    if (rebornDelay < 0) then
        --- 触发死亡事件
        event.syncTrigger(deadUnit, eventKind.unitDead, { killerUnit = killer })
        time.setTimeout(deadUnit:corpse(), function()
            class.destroy(deadUnit)
        end)
    else
        --- 触发假死事件
        event.syncTrigger(deadUnit, eventKind.unitFeignDead, { killerUnit = killer })
        BuffClear(deadUnit)
        deadUnit:enchantSubtractAll()
        ability.reborn(deadUnit, rebornDelay, deadUnit:rebornInvulnerable(), x, y, true)
    end
end