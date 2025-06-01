--- 底层技能 伤害
--[[
    对接引流 Flow `damage`
    使用 Unit:isHurting() 判断是否受伤中
    使用 Unit:isDamaging() 判断是否造成伤害中
    options = {
        sourceUnit = Unit, --[可选]源单位
        targetUnit = Unit, --[必须]目标单位
        damage = number, --[可选]伤害值，默认0
        damageSrc = table, --[可选]伤害来源，默认injury.damageSrc.common（详情查看injury.damageSrc）
        damageType = table, --[可选]伤害类型，默认injury.damageType.common （详情查看injury.damageType）
        damageTypeLevel = number, --[可选]伤害类级别（影响元素附着或自定义效果），默认0
        breakArmor = table, --[可选]破防类型，默认{}（详情查看injury.breakArmor）
        extra = table, --[可选]自定义额外数据
    }
]]
---@see injury#damageType
---@see injury#damageSrc
---@see injury#breakArmorType
---@param options {sourceUnit:Unit,targetUnit:Unit,damage:number,damageSrc:table,damageType:table,damageTypeLevel:number,breakArmor:table[],extra:table}
---@return void
function ability.damage(options)
    sync.must()
    options.damage = options.damage or 0
    if (options.damage < 1 or false == class.isObject(options.targetUnit, UnitClass)) then
        return
    end
    if (options.targetUnit:isDead()) then
        return
    end
    if (nil ~= options.sourceUnit) then
        if (false == class.isObject(options.sourceUnit, UnitClass)) then
            return
        end
        if (options.sourceUnit:isDead()) then
            return
        end
    end
    -- 禁用错误的伤害来源
    options.damageSrc = options.damageSrc or injury.damageSrc.common
    must(injury.isValidDamageSrc(options.damageSrc), "options.damageSrc@injury.damageSrc")
    if (options.damageSrc == injury.damageSrc.attack and nil ~= options.sourceUnit and options.sourceUnit:isUnArming()) then
        return
    elseif (options.damageSrc == injury.damageSrc.ability and nil ~= options.sourceUnit and options.sourceUnit:isSilencing()) then
        return
    end
    --- 触发受伤前事件
    event.syncTrigger(options.targetUnit, eventKind.unitBeforeHurt, options)
    -- 修正伤害类型
    options.damageType = options.damageType or injury.damageType.common
    must(injury.isValidDamageType(options.damageType), "options.damageType@injury.damageType")
    options.damageTypeLevel = options.damageTypeLevel or 0
    -- 修正破防类型
    options.breakArmor = options.breakArmor or {}
    if (#options.breakArmor > 0) then
        local notType = -1
        for bi, ba in ipairs(options.breakArmor) do
            if (false == injury.isValidBreakArmorType(ba)) then
                notType = bi
                break
            end
        end
        if (notType > 0) then
            must(false, "options.breakArmor[" .. notType .. "]@injury.breakArmorType")
        end
    end
    --- 对接伤害过程
    if (isFlow("damage")) then
        Flow("damage"):run(options)
    end
    --- 最终伤害
    if (options.damage >= 1) then
        if (nil ~= options.sourceUnit) then
            options.targetUnit._lastHurtSource = options.sourceUnit
            options.sourceUnit._lastDamageTarget = options.targetUnit
            superposition.plus(options.sourceUnit, "damage")
            superposition.plus(options.sourceUnit:owner(), "damage")
            time.setTimeout(3.5, function()
                if (false == class.isDestroy(options.sourceUnit)) then
                    superposition.minus(options.sourceUnit, "damage")
                    superposition.minus(options.sourceUnit:owner(), "damage")
                end
            end)
            --- 触发伤害事件
            event.syncTrigger(options.sourceUnit, eventKind.unitDamage, options)
            if (options.damageSrc == injury.damageSrc.attack) then
                event.syncTrigger(options.sourceUnit, eventKind.unitAttack, options)
            end
        end
        superposition.plus(options.targetUnit, "hurt")
        superposition.plus(options.targetUnit:owner(), "hurt")
        time.setTimeout(3.5, function()
            if (false == class.isDestroy(options.targetUnit)) then
                superposition.minus(options.targetUnit, "hurt")
                superposition.minus(options.targetUnit:owner(), "hurt")
            end
        end)
        --- 触发受伤事件
        event.syncTrigger(options.targetUnit, eventKind.unitHurt, options)
        if (options.damageSrc == injury.damageSrc.attack) then
            event.syncTrigger(options.targetUnit, eventKind.unitBeAttack, options)
        end
        options.targetUnit:hpCur("-=" .. options.damage)
    end
end
