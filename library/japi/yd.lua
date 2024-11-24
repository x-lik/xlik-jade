--- JAPI自yd库，包含yd引擎自带的japi方法，方法以 YD_ 开头

--- 执行脚本
---@param script string
---@return void
function japi.YD_ExecuteScript(script)
    japi.Exec("EXExecuteScript", script)
end

--- 重置特效变换
--- 清空所有的旋转和缩放，重置为初始状态
---@param whichEffect number
---@return void
function japi.YD_EffectMatReset(whichEffect)
    japi.Exec("EXEffectMatReset", whichEffect)
end

--- 特效绕X轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param whichEffect number
---@param angle number
---@return void
function japi.YD_EffectMatRotateX(whichEffect, angle)
    japi.Exec("EXEffectMatRotateX", whichEffect, angle)
end

--- 特效绕Y轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param whichEffect number
---@param angle number
---@return void
function japi.YD_EffectMatRotateY(whichEffect, angle)
    japi.Exec("EXEffectMatRotateY", whichEffect, angle)
end

--- 特效绕Z轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param whichEffect number
---@param angle number
---@return void
function japi.YD_EffectMatRotateZ(whichEffect, angle)
    japi.Exec("EXEffectMatRotateZ", whichEffect, angle)
end

--- 设置特效的X轴缩放，Y轴缩放，Z轴缩放
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态。设置为2,2,2时相当于大小变为2倍。设置为负数时，就是镜像翻转
---@param whichEffect number
---@param x number
---@param y number
---@param z number
---@return void
function japi.YD_EffectMatScale(whichEffect, x, y, z)
    japi.Exec("EXEffectMatScale", whichEffect, x, y, z)
end

--- 获取特效大小
---@param whichEffect number
---@return number
function japi.YD_GetEffectSize(whichEffect)
    return japi.Exec("EXGetEffectSize", whichEffect)
end

--- 获取特效X轴坐标
---@param whichEffect number
---@return number
function japi.YD_GetEffectX(whichEffect)
    return japi.Exec("EXGetEffectX", whichEffect)
end

--- 获取特效Y轴坐标
---@param whichEffect number
---@return number
function japi.YD_GetEffectY(whichEffect)
    return japi.Exec("EXGetEffectY", whichEffect)
end

--- 获取特效Z轴坐标
---@param whichEffect number
---@return number
function japi.YD_GetEffectZ(whichEffect)
    return japi.Exec("EXGetEffectZ", whichEffect)
end

--- 设置特效大小
---@param e number
---@param size number
---@return void
function japi.YD_SetEffectSize(e, size)
    japi.Exec("EXSetEffectSize", e, size)
end

--- 设置特效动画速度
---@param e number
---@param speed number
---@return void
function japi.YD_SetEffectSpeed(e, speed)
    japi.Exec("EXSetEffectSpeed", e, speed)
end

--- 移动特效到坐标
---@param e number
---@param x number
---@param y number
---@return void
function japi.YD_SetEffectXY(e, x, y)
    japi.Exec("EXSetEffectXY", e, x, y)
end

--- 设置特效高度
---@param e number
---@param z number
---@return void
function japi.YD_SetEffectZ(e, z)
    japi.Exec("EXSetEffectZ", e, z)
end

--- 获取技能整数数据
---@param whichAbility number ability
---@param level number integer
---@param dataType number integer
---@return number integer
function japi.YD_GetAbilityDataInteger(whichAbility, level, dataType)
    return japi.Exec("EXGetAbilityDataInteger", whichAbility, level, dataType)
end

--- 获取技能实数数据
---@param whichAbility number ability
---@param level number integer
---@param dataType number integer
---@return number
function japi.YD_GetAbilityDataReal(whichAbility, level, dataType)
    return japi.Exec("EXGetAbilityDataReal", whichAbility, level, dataType)
end

--- 获取技能字符串数据
---@param whichAbility number ability
---@param level number integer
---@param dataType number integer
---@return string
function japi.YD_GetAbilityDataString(whichAbility, level, dataType)
    return japi.Exec("EXGetAbilityDataString", whichAbility, level, dataType)
end

--- 获取技能ID
---@param whichAbility number ability
---@return number integer
function japi.YD_GetAbilityId(whichAbility)
    return japi.Exec("EXGetAbilityId", whichAbility)
end

--- 获取技能状态
---@param whichAbility number ability
---@param stateType number integer
---@return number
function japi.YD_GetAbilityState(whichAbility, stateType)
    return japi.Exec("EXGetAbilityState", whichAbility, stateType)
end

--- 设置技能状态
---@param ability number
---@param stateType number integer
---@param value number
---@return boolean
function japi.YD_SetAbilityState(ability, stateType, value)
    return japi.Exec("EXSetAbilityState", ability, stateType, value)
end

--- 设置技能变身数据A
---@param whichAbility number
---@param unitId number integer
---@return boolean
function japi.YD_SetAbilityAEmeDataA(whichAbility, unitId)
    return japi.Exec("EXSetAbilityAEmeDataA", whichAbility, unitId)
end

--- 设置技能整数数据
---@param whichAbility number
---@param level number integer
---@param data_type number integer
---@param value number integer
---@return boolean
function japi.YD_SetAbilityDataInteger(whichAbility, level, data_type, value)
    return japi.Exec("EXSetAbilityDataInteger", whichAbility, level, data_type, value)
end

--- 设置技能实数数据
---@param whichAbility number
---@param level number integer
---@param data_type number integer
---@param value number
---@return boolean
function japi.YD_SetAbilityDataReal(whichAbility, level, data_type, value)
    return japi.Exec("EXSetAbilityDataReal", whichAbility, level, data_type, value)
end

--- 设置技能字符串数据
---@param whichAbility number
---@param level number integer
---@param data_type number integer
---@param value string
---@return boolean
function japi.YD_SetAbilityDataString(whichAbility, level, data_type, value)
    return japi.Exec("EXSetAbilityDataString", whichAbility, level, data_type, value)
end

--- 获取单位技能
---@param whichUnit number
---@param abilityId number string|integer
---@return number integer
function japi.YD_GetUnitAbility(whichUnit, abilityId)
    if (type(abilityId) == "string") then
        abilityId = J.C2I(abilityId)
    end
    return japi.Exec("EXGetUnitAbility", whichUnit, abilityId)
end

--- 根据索引获取单位技能
---@param whichUnit number
---@param index number integer
---@return number integer
function japi.YD_GetUnitAbilityByIndex(whichUnit, index)
    return japi.Exec("EXGetUnitAbilityByIndex", whichUnit, index)
end

--- 设置单位类型字符串组数据
---@param uid number integer
---@param id number integer
---@param n number integer
---@param name string
---@return boolean
function japi.YD_SetUnitArrayString(uid, id, n, name)
    return japi.Exec("EXSetUnitArrayString", uid, id, n, name)
end

--- 设置单位类型整数数据
---@param uid number integer
---@param id number integer
---@param n number integer
---@return boolean
function japi.YD_SetUnitInteger(uid, id, n)
    return japi.Exec("EXSetUnitInteger", uid, id, n)
end

--- 暂停单位
---@param whichUnit number
---@param enable boolean
---@return void
function japi.YD_PauseUnit(whichUnit, enable)
    japi.Exec("EXPauseUnit", whichUnit, enable)
end

--- 设置单位的碰撞类型
--- 启用/禁用 单位u 对 t 的碰撞
---@param enable boolean
---@param u number
---@param t number integer 碰撞类型，参考blizzard:^COLLISION_TYPE
---@return void
function japi.YD_SetUnitCollisionType(enable, u, t)
    return japi.Exec("EXSetUnitCollisionType", enable, u, t)
end

--- 设置单位面向角度
--- 立即转身
---@param u number
---@param angle number
---@return void
function japi.YD_SetUnitFacing(u, angle)
    return japi.Exec("EXSetUnitFacing", u, angle)
end

--- 设置单位的移动类型
---@param u number
---@param t number integer 移动类型，参考blizzard:^MOVE_TYPE_*
---@return void
function japi.YD_SetUnitMoveType(u, t)
    return japi.Exec("EXSetUnitMoveType", u, t)
end

--- 获取单位属性
---@param whichUnit number
---@param state number 参考 blizzard:^UNIT_STATE_*
---@return number
function japi.YD_GetUnitState(whichUnit, state)
    return japi.Exec("GetUnitState", whichUnit, state)
end

--- 设置单位属性
---@param whichUnit number
---@param state number 参考 blizzard:^UNIT_STATE_*
---@param value number
---@return void
function japi.YD_SetUnitState(whichUnit, state, value)
    japi.Exec("SetUnitState", whichUnit, state, value)
end

--- 单位变身
--- 技能请填恶魔猎手的变身<AEme>或其复制品
---@param whichUnit number
---@param abilityId number 技能ID
---@param targetId number 目标单位ID
---@return void
function japi.YD_UnitTransform(whichUnit, abilityId, targetId)
    local ab = japi.YD_GetUnitAbility(whichUnit, abilityId)
    J.UnitAddAbility(whichUnit, abilityId)
    japi.YD_SetAbilityDataInteger(ab, 1, 117, J.GetUnitTypeId(whichUnit))
    japi.YD_SetAbilityAEmeDataA(ab, J.GetUnitTypeId(whichUnit))
    J.UnitRemoveAbility(whichUnit, abilityId)
    J.UnitAddAbility(whichUnit, abilityId)
    japi.YD_SetAbilityAEmeDataA(ab, targetId)
    J.UnitRemoveAbility(whichUnit, abilityId)
end

--- 获取buff字符串数据
---@param buffCode number integer
---@param dataType number integer
---@return string
function japi.YD_GetBuffDataString(buffCode, dataType)
    return japi.Exec("EXGetBuffDataString", buffCode, dataType)
end

--- 设置buff字符串数据
---@param buffCode number integer
---@param dataType number integer
---@param value string
---@return boolean
function japi.YD_SetBuffDataString(buffCode, dataType, value)
    return japi.Exec("EXSetBuffDataString", buffCode, dataType, value)
end

--- 设置物品字符串数据
---@param itemCode number integer
---@param dataType number integer
---@param value string
---@return boolean
function japi.YD_SetItemDataString(itemCode, dataType, value)
    return japi.Exec("EXSetItemDataString", itemCode, dataType, value)
end

--- 获取物品字符串数据
---@param itemCode number integer
---@param dataType number integer
---@return string
function japi.YD_GetItemDataString(itemCode, dataType)
    return japi.Exec("EXGetItemDataString", itemCode, dataType)
end

--- 设置伤害值
--- 修改伤害事件里的伤害值，不能在等待之后使用
---@param amount number
---@return void
function japi.YD_SetEventDamage(amount)
    japi.Exec("EXSetEventDamage", amount)
end

--- 伤害值
--- 单位所受伤害
--- 响应'受到伤害'单位事件，指代单位所受伤害
---@return number
function japi.YD_GetEventDamage()
    return japi.Exec("GetEventDamage")
end

--- 获取伤害事件数据
---@param eddType number integer
---@return number integer
function japi.YD_GetEventDamageData(eddType)
    return japi.Exec("EXGetEventDamageData", eddType)
end

--- 是物理伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function japi.YD_IsEventPhysicalDamage()
    return 0 ~= japi.YD_GetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL)
end

--- 是攻击伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function japi.YD_IsEventAttackDamage()
    return 0 ~= japi.YD_GetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK)
end

--- 是远程伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function japi.YD_IsEventRangedDamage()
    return 0 ~= japi.YD_GetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED)
end

--- 单位所受伤害的伤害类型是 damageType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param damageType number 参考 blizzard:^DAMAGE_TYPE_*
---@return boolean
function japi.YD_IsEventDamageType(damageType)
    return damageType == J.ConvertDamageType(japi.YD_GetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE))
end

--- 单位所受伤害的武器类型是 是 weaponType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param weaponType number 参考 blizzard:^WEAPON_TYPE_*
---@return boolean
function japi.YD_IsEventWeaponType(weaponType)
    return weaponType == J.ConvertWeaponType(japi.YD_GetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE))
end

--- 单位所受伤害的攻击类型是 是 attackType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param attackType number 参考blizzard:^ATTACK_TYPE_*
---@return boolean
function japi.YD_IsEventAttackType(attackType)
    return attackType == J.ConvertAttackType(japi.YD_GetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE))
end