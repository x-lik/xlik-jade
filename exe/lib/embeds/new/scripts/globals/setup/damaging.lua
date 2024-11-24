local damageFlow = Flow("damage")

--- 伤害为0中止
damageFlow:abort(function(data)
    return data.damage <= 0
end)

--- 提取一些需要的参数
damageFlow:flux("prop", function(data)
    data.defend = data.targetUnit:defend()
end)

--- 判断无视装甲类型
damageFlow:flux("breakArmor", function(data)
    local ignore = { defend = false, avoid = false, invincible = false }
    if (#data.breakArmor > 0) then
        for _, b in ipairs(data.breakArmor) do
            if (nil ~= b) then
                ignore[b.value] = true
                --- 触发无视防御事件
                event.syncTrigger(data.sourceUnit, eventKind.unitBreakArmor, { targetUnit = data.targetUnit, breakArmorType = b })
                --- 触发被破防事件
                event.syncTrigger(data.targetUnit, eventKind.unitBeBreakArmor, { breakUnit = data.sourceUnit, breakArmorType = b })
            end
        end
    end
    --- 处理防御
    if (true == ignore.defend and data.defend > 0) then
        data.defend = 0
    end
end)

--- 附魔加成|抵抗|精通|附着|免疫
---@param data {targetUnit:Unit,sourceUnit:Unit}
damageFlow:flux("enchant", function(data)
    local percent = 0
    if (nil ~= data.sourceUnit) then
        local amplify = data.sourceUnit:enchantStrengthen(data.damageType.value)
        if (amplify ~= 0) then
            percent = percent + amplify
        end
    end
    local resistance = data.targetUnit:enchantResistance(data.damageType.value)
    if (resistance ~= 0) then
        percent = percent - resistance
    end
    if (nil ~= data.sourceUnit) then
        local mystery = data.sourceUnit:enchantMystery() * 0.01 + 1
        mystery = math.max(0, mystery)
        percent = percent * mystery
    end
    --- 触发附魔事件
    event.syncTrigger(data.targetUnit, eventKind.unitEnchant, { sourceUnit = data.targetUnit, enchantType = data.damageType, percent = percent })
    if (data.damageType ~= injury.damageType.common) then
        -- 一般设定攻击技能物品来源可触发附魔，禁止反应式伤害再触发
        if (data.damageSrc == injury.damageSrc.attack or data.damageSrc == injury.damageSrc.ability or data.damageSrc == injury.damageSrc.item) then
            data.targetUnit:enchantAppend(data.damageType, data.damageTypeLevel, data.sourceUnit)
        end
    end
    if (data.targetUnit:isEnchantImmune(data.damageType.value)) then
        -- 触发免疫附魔事件
        data.damage = 0
        event.syncTrigger(data.targetUnit, eventKind.unitImmuneEnchant, { sourceUnit = data.sourceUnit, enchantType = data.damageType })
    else
        data.damage = data.damage * (100 + percent) * 0.01
    end
end)