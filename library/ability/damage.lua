--- 底层技能 伤害
--[[
    对接引流 Flow `damage`
    使用 Unit:isHurting() 判断是否受伤中
    使用 Unit:isDamaging() 判断是否造成伤害中
    params = {
        sourceUnit 源单位
        targetUnit 目标单位
        damage 伤害值
        damageSrc 伤害来源
        damageType 伤害类型（影响元素反应或自定义效果）
        damageTypeLevel 伤害类级别（影响元素附着或自定义效果）
        breakArmor 破甲类型
        extra table 自定义额外数据map
    }
]]
---@see injury#damageType
---@see injury#damageSrc
---@see injury#breakArmorType
---@param params {sourceUnit:Unit,targetUnit:Unit,damage:number,damageSrc:table,damageType:table,damageTypeLevel:number,breakArmor:table[],extra:table}
---@return void
function ability.damage(params)
    sync.must()
    params.damage = params.damage or 0
    if (params.damage < 1 or false == class.isObject(params.targetUnit, UnitClass)) then
        return
    end
    if (params.targetUnit:isDead()) then
        return
    end
    if (nil ~= params.sourceUnit) then
        if (false == class.isObject(params.sourceUnit, UnitClass)) then
            return
        end
        if (params.sourceUnit:isDead()) then
            return
        end
    end
    -- 禁用错误的伤害来源
    params.damageSrc = params.damageSrc or injury.damageSrc.common
    if (params.damageSrc == injury.damageSrc.attack and nil ~= params.sourceUnit and params.sourceUnit:isUnArming()) then
        return
    elseif (params.damageSrc == injury.damageSrc.ability and nil ~= params.sourceUnit and params.sourceUnit:isSilencing()) then
        return
    end
    --- 触发受伤前事件
    event.syncTrigger(params.targetUnit, eventKind.unitBeforeHurt, params)
    -- 修正伤害类型
    params.damageType = params.damageType or injury.damageType.common
    params.damageTypeLevel = params.damageTypeLevel or 0
    -- 修正破防类型
    params.breakArmor = params.breakArmor or {}
    --- 对接伤害过程
    if (isFlow("damage")) then
        Flow("damage"):run(params)
    end
    --- 最终伤害
    if (params.damage >= 1) then
        if (nil ~= params.sourceUnit) then
            params.targetUnit._lastHurtSource = params.sourceUnit
            params.sourceUnit._lastDamageTarget = params.targetUnit
            superposition.plus(params.sourceUnit, "damage")
            superposition.plus(params.sourceUnit:owner(), "damage")
            time.setTimeout(3.5, function()
                if (false == class.isDestroy(params.sourceUnit)) then
                    superposition.minus(params.sourceUnit, "damage")
                    superposition.minus(params.sourceUnit:owner(), "damage")
                end
            end)
            --- 触发伤害事件
            event.syncTrigger(params.sourceUnit, eventKind.unitDamage, params)
            if (params.damageSrc == injury.damageSrc.attack) then
                event.syncTrigger(params.sourceUnit, eventKind.unitAttack, params)
            end
        end
        superposition.plus(params.targetUnit, "hurt")
        superposition.plus(params.targetUnit:owner(), "hurt")
        time.setTimeout(3.5, function()
            if (false == class.isDestroy(params.targetUnit)) then
                superposition.minus(params.targetUnit, "hurt")
                superposition.minus(params.targetUnit:owner(), "hurt")
            end
        end)
        --- 触发受伤事件
        event.syncTrigger(params.targetUnit, eventKind.unitHurt, params)
        if (params.damageSrc == injury.damageSrc.attack) then
            event.syncTrigger(params.targetUnit, eventKind.unitBeAttack, params)
        end
        params.targetUnit:hpCur("-=" .. params.damage)
    end
end
