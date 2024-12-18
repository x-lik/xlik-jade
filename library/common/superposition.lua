--- 叠加态，控制数值的临界反应执行
--- 叠加值默认值为0，在变动为大于0或小于0后，触发仅一次的临界操作
---@class superposition
superposition = superposition or {}

--- 特有字串数据
superposition._unique = superposition._unique or {}

--- 叠加态执行为对象时设定数据（一般为固有设定）
--- 配置中的function在同步环境下才允许运行
superposition._configs = superposition._configs or {}

--- 配置叠加态执行为对象时的设定数据
---@param className string
---@param key string
---@param up fun(obj:Object):void
---@param down fun(obj:Object):void
---@return void
function superposition.config(className, key, up, down)
    if (nil == superposition._configs[className]) then
        superposition._configs[className] = {}
    end
    superposition._configs[className][key] = { up = up, down = down }
end

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
    elseif (class.is(mod)) then
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
            local c = superposition._configs[mod._className]
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
---@return void
function superposition.plus(mod, key)
    _value(mod, key, 1)
end

--- 某key临界值-1
---@param mod Object|string
---@param key string
---@return void
function superposition.minus(mod, key)
    _value(mod, key, -1)
end

--- 某key临界状态是否处于正状态（大于0）
---@param mod Object|string
---@param key string
---@return boolean
function superposition.is(mod, key)
    return _value(mod, key) > 0
end

-- 默认配置
superposition.config(UnitClass, "dead",
    function(obj) superposition.plus(obj, "interrupt") end,
    function(obj) superposition.minus(obj, "interrupt") end)
superposition.config(UnitClass, "stun",
    function(obj) superposition.plus(obj, "interrupt") end,
    function(obj) superposition.minus(obj, "interrupt") end)
superposition.config(UnitClass, "silent",
    function(obj) superposition.plus(obj, "interrupt") end,
    function(obj) superposition.minus(obj, "interrupt") end)
superposition.config(UnitClass, "interrupt",
    function(obj) event.syncTrigger(obj, eventKind.unitInterruptIn) end,
    function(obj) event.syncTrigger(obj, eventKind.unitInterruptOut) end)
superposition.config(UnitClass, "pause",
    function(obj) J.PauseUnit(obj._handle, true) end,
    function(obj) J.PauseUnit(obj._handle, false) end)
superposition.config(UnitClass, "hide",
    function(obj) J.ShowUnit(obj._handle, false) end,
    function(obj) J.ShowUnit(obj._handle, true) end)
superposition.config(UnitClass, "noPath",
    function(obj)
        J.SetUnitPathing(obj._handle, false)
        japi.YD_SetUnitCollisionType(false, obj._handle, COLLISION_TYPE_UNIT)
        japi.YD_SetUnitCollisionType(false, obj._handle, COLLISION_TYPE_BUILDING)
    end,
    function(obj)
        J.SetUnitPathing(obj._handle, true)
        japi.YD_SetUnitCollisionType(true, obj._handle, COLLISION_TYPE_UNIT)
        japi.YD_SetUnitCollisionType(true, obj._handle, COLLISION_TYPE_BUILDING)
    end)
superposition.config(UnitClass, "noAttack",
    function(obj)
        japi.DZ_UnitDisableAttack(obj._handle, true)
        event.syncTrigger(obj, eventKind.classAfterChange .. "noAttack", { triggerObject = obj, old = false, new = true, name = "noAttack" })
    end,
    function(obj)
        japi.DZ_UnitDisableAttack(obj._handle, false)
        event.syncTrigger(obj, eventKind.classAfterChange .. "noAttack", { triggerObject = obj, old = true, new = false, name = "noAttack" })
    end)
superposition.config(UnitClass, "locust",
    function(obj)
        if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_LOCUST) < 1) then
            J.UnitAddAbility(obj._handle, LK_SLK_ID_ABILITY_LOCUST)
        end
    end,
    function(obj)
        if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_LOCUST) >= 1) then
            J.UnitRemoveAbility(obj._handle, LK_SLK_ID_ABILITY_LOCUST)
        end
    end)
superposition.config(UnitClass, "invulnerable",
    function(obj)
        if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_INVULNERABLE) < 1) then
            J.UnitAddAbility(obj._handle, LK_SLK_ID_ABILITY_INVULNERABLE)
            event.syncTrigger(obj, eventKind.classAfterChange .. "invulnerable", { triggerObject = obj, old = false, new = true, name = "invulnerable" })
        end
    end,
    function(obj)
        if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_INVULNERABLE) >= 1) then
            J.UnitRemoveAbility(obj._handle, LK_SLK_ID_ABILITY_INVULNERABLE)
            event.syncTrigger(obj, eventKind.classAfterChange .. "invulnerable", { triggerObject = obj, old = true, new = false, name = "invulnerable" })
        end
    end)
superposition.config(UnitClass, "invisible",
    function(obj)
        if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_INVISIBLE) < 1) then
            J.UnitAddAbility(obj._handle, LK_SLK_ID_ABILITY_INVISIBLE)
        end
    end,
    function(obj)
        if (J.GetUnitAbilityLevel(obj._handle, LK_SLK_ID_ABILITY_INVISIBLE) >= 1) then
            J.UnitRemoveAbility(obj._handle, LK_SLK_ID_ABILITY_INVISIBLE)
        end
    end)