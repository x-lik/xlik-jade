--- 叠加态，控制数值的临界反应执行
--- 叠加值默认值为0，在变动为大于0或小于0后，触发仅一次的临界操作
---@class superposition
superposition = superposition or {}

--- 特有字串数据
superposition._unique = superposition._unique or {}

--- 叠加态执行设定（一般为固有设定）
--- 配置中的function在同步环境下才允许运行
local _conf = {
    [UnitClass] = {
        dead = {
            up = function(obj) superposition.plus(obj, "interrupt") end,
            down = function(obj) superposition.minus(obj, "interrupt") end,
        },
        stun = {
            up = function(obj) superposition.plus(obj, "interrupt") end,
            down = function(obj) superposition.minus(obj, "interrupt") end,
        },
        silent = {
            up = function(obj) superposition.plus(obj, "interrupt") end,
            down = function(obj) superposition.minus(obj, "interrupt") end,
        },
        interrupt = {
            up = function(obj) event.syncTrigger(obj, eventKind.unitInterruptIn) end,
            down = function(obj) event.syncTrigger(obj, eventKind.unitInterruptOut) end,
        },
        pause = {
            up = function(obj) J.PauseUnit(obj._handle, true) end,
            down = function(obj) J.PauseUnit(obj._handle, false) end,
        },
        hide = {
            up = function(obj) J.ShowUnit(obj._handle, false) end,
            down = function(obj) J.ShowUnit(obj._handle, true) end,
        },
        noPath = {
            up = function(obj)
                J.SetUnitPathing(obj._handle, false)
                japi.YD_SetUnitCollisionType(false, obj._handle, COLLISION_TYPE_UNIT)
                japi.YD_SetUnitCollisionType(false, obj._handle, COLLISION_TYPE_BUILDING)
            end,
            down = function(obj)
                J.SetUnitPathing(obj._handle, true)
                japi.YD_SetUnitCollisionType(true, obj._handle, COLLISION_TYPE_UNIT)
                japi.YD_SetUnitCollisionType(true, obj._handle, COLLISION_TYPE_BUILDING)
            end,
        },
        noAttack = {
            up = function(obj)
                japi.DZ_UnitDisableAttack(obj._handle, true)
                event.syncTrigger(obj, eventKind.classAfterChange .. "noAttack", { triggerObject = obj, old = false, new = true, name = "noAttack" })
            end,
            down = function(obj)
                japi.DZ_UnitDisableAttack(obj._handle, false)
                event.syncTrigger(obj, eventKind.classAfterChange .. "noAttack", { triggerObject = obj, old = true, new = false, name = "noAttack" })
            end,
        },
        locust = {
            up = function(obj)
                if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_LOCUST) < 1) then
                    J.UnitAddAbility(obj._handle, LK_SLK_ID_ABILITY_LOCUST)
                end
            end,
            down = function(obj)
                if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_LOCUST) >= 1) then
                    J.UnitRemoveAbility(obj._handle, LK_SLK_ID_ABILITY_LOCUST)
                end
            end,
        },
        invulnerable = {
            up = function(obj)
                if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_INVULNERABLE) < 1) then
                    J.UnitAddAbility(obj._handle, LK_SLK_ID_ABILITY_INVULNERABLE)
                    event.syncTrigger(obj, eventKind.classAfterChange .. "invulnerable", { triggerObject = obj, old = false, new = true, name = "invulnerable" })
                end
            end,
            down = function(obj)
                if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_INVULNERABLE) >= 1) then
                    J.UnitRemoveAbility(obj._handle, LK_SLK_ID_ABILITY_INVULNERABLE)
                    event.syncTrigger(obj, eventKind.classAfterChange .. "invulnerable", { triggerObject = obj, old = true, new = false, name = "invulnerable" })
                end
            end,
        },
        invisible = {
            up = function(obj)
                if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_INVISIBLE) < 1) then
                    J.UnitAddAbility(obj._handle, LK_SLK_ID_ABILITY_INVISIBLE)
                end
            end,
            down = function(obj)
                if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_INVISIBLE) >= 1) then
                    J.UnitRemoveAbility(obj._handle, LK_SLK_ID_ABILITY_INVISIBLE)
                end
            end,
        },
    }
}

--- 叠加态执行判断
---@param mod Object|string
---@param key string
---@param change number
---@return number|void
local _value = function(mod, key, change)
    if (type(mod) == "string") then
        local uni = superposition._unique
        if (type(change) == "number") then
            uni[key] = (uni[key] or 0) + change
        else
            return uni[key] or 0
        end
    elseif (type(mod) == "table") then
        if (type(change) == "number") then
            if (nil == mod._supVal) then
                mod._supVal = {}
            end
            if (nil == mod._supRes) then
                mod._supRes = {}
            end
            local cur = mod._supVal[key] or 0
            local status = cur > 0
            local val = cur + change
            mod._supVal[key] = val
            local c = _conf[mod._className]
            if (val > 0 and false == status) then
                if (c and c[key]) then
                    local up = c[key].up
                    if (type(up) == "function") then
                        sync.must()
                        up(mod)
                    end
                end
            elseif (val <= 0 and true == status) then
                mod._supRes[key] = false
                if (c and c[key]) then
                    local down = c[key].down
                    if (type(down) == "function") then
                        sync.must()
                        down(mod)
                    end
                end
            end
        else
            if (mod._supVal) then
                return mod._supVal[key] or 0
            end
            return 0
        end
    end
end

--- 某key临界值+1
---@param mod Object|string
---@param key string
function superposition.plus(mod, key)
    _value(mod, key, 1)
end

--- 某key临界值-1
---@param mod Object|string
---@param key string
function superposition.minus(mod, key)
    _value(mod, key, -1)
end

--- 某key临界状态是否处于正状态（大于0）
---@param mod Object|string
---@param key string
function superposition.is(mod, key)
    return _value(mod, key) > 0
end