--- 受伤过程
--- 绑定进攻过程虚实转化的相应方法
--- 主要用于common/player
---@class injury
injury = injury or {}

--- 伤害类型keys
injury.damageTypeKeys = injury.damageTypeKeys or { "common" }
--- 伤害类型
injury.damageType = injury.damageType or {
    common = { value = "common", label = "常规" },
}
--- 伤害来源
injury.damageSrc = {
    common = { value = "common", label = "常规" },
    attack = { value = "attack", label = "攻击" },
    ability = { value = "ability", label = "技能" },
    item = { value = "item", label = "物品" },
}
--- 无视防御种类
injury.breakArmorType = {
    defend = { value = "defend", label = "防御" },
    avoid = { value = "avoid", label = "回避" },
    invincible = { value = "invincible", label = "无敌" },
}

--- [受伤过程]抵达
---@param sourceUnit Unit
---@param targetUnit Unit
---@return void
function injury.arrive(sourceUnit, targetUnit)
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
        })
    end
end

--- [受伤过程]攻击
---@param sourceUnit Unit
---@param targetUnit Unit
---@return void
function injury.attack(sourceUnit, targetUnit)
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
        injury.arrive(sourceUnit, targetUnit)
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
                injury.arrive(sourceUnit, targetUnit)
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
                    injury.arrive(sourceUnit, enumUnit)
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
                    injury.arrive(opt.sourceUnit, opt.targetUnit)
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