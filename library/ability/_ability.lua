--- 技能模组，通用的技能处理方法规则函数，包含技能通用的执行过程，用于Ability或单独调用
---@alias abilityBuffAddon {name:string,icon:string,description:string[]}
---@class ability
ability = ability or {}

-- 技能目标类型数据
---@class abilityTargetType
ability.targetType = {
    pas = { value = "p", label = "被动" },
    none = { value = "n", label = "无目标" },
    unit = { value = "u", label = "单位目标" },
    loc = { value = "l", label = "点目标" },
    circle = { value = "c", label = "圆形范围目标" },
    square = { value = "s", label = "方形范围目标" },
}

--- [实际]计算整合数值型
--- 根据base、vary计算出技能该等级时对应的数据
--- 公式：base + (level-1) * vary
---@param obj Ability
---@param whichLevel number|nil
---@param abKey string 技能取值key
---@param uPercent string|nil 单位百分比变化取值key
---@param uFixed string|nil 单位固定变化取值key
---@return number
function ability.caleValueNumber(obj, whichLevel, abKey, uPercent, uFixed)
    whichLevel = whichLevel or obj:level()
    local base = abKey .. "Base"
    local vary = abKey .. "Vary"
    local val = (obj:get(base) or 0) + (whichLevel - 1) * (obj:get(vary) or 0)
    ---@type Unit
    local u = obj:get("bindUnit")
    if (class.isObject(u, UnitClass)) then
        if (uPercent) then
            local p = u:get(uPercent)
            if (type(p) == "number") then
                val = val * (1 + 0.01 * p)
            end
        end
        if (uFixed) then
            local f = u:get(uFixed)
            if (type(f) == "number") then
                val = val + f
            end
        end
    end
    return val
end

--- [成长推导]随耗
--- 根据配置的数据设定记录技能成长推导数据的通用进展配置方法
---@param whichAbility AbilityTpl|Ability
---@param key string
---@param base number|table
---@param vary number|table
---@param cond function 条件执行回调
---@param deplete function 实消执行回调
---@param value function 实际数值回调
---@param reason string|nil 原因声明
---@return AbilityTpl|Ability
function ability.anyCostAdv(whichAbility, key, base, vary, cond, deplete, value, reason)
    if (nil ~= base) then
        whichAbility:set(key .. "CostBase", base)
    end
    if (nil ~= vary) then
        whichAbility:set(key .. "CostVary", vary)
    end
    ---@type Array
    local costAdv = whichAbility:get("costAdv")
    if (nil == costAdv) then
        costAdv = Array()
        whichAbility:set("costAdv", costAdv)
    end
    costAdv:set(key, { cond = cond, deplete = deplete, value = value, reason = reason })
    return whichAbility
end

--- [实际]随耗
--- 根据adv进展配置值获得技能该等级的消耗数据
---@param whichAbility AbilityTpl|Ability
---@param key string
---@param whichLevel number|nil
---@param default any
---@return number|table
function ability.anyCost(whichAbility, key, whichLevel, default)
    local costAdv = whichAbility:get("costAdv")
    if (isArray(costAdv)) then
        local any = costAdv:get(key)
        if (type(any) == "table") then
            local f = any.value
            if (type(f) == "function") then
                return f(whichAbility, whichLevel)
            end
        end
    end
    return default
end

--- [实际]计算整合资源型
--- 根据base、vary计算出技能该等级的财物消耗数据
--- 公式：base + (level-1) * vary
---@param obj Ability
---@param whichLevel number|nil
---@return number
function ability.caleValueWorth(obj, whichLevel)
    local base = obj:get("worthCostBase")
    if (nil == base) then
        return
    end
    whichLevel = whichLevel or obj:level()
    local worthKeys = worth.get():keys()
    local val = {}
    local vary = nil
    if (whichLevel > 1) then
        vary = obj:get("worthCostVary")
    end
    for _, k in ipairs(worthKeys) do
        if (type(base[k]) == "number" and base[k] ~= 0) then
            val[k] = base[k]
        end
        if (type(vary) == "table" and type(vary[k]) == "number" and vary[k] ~= 0) then
            val[k] = (val[k] or 0) + (whichLevel - 1) * vary[k]
        end
    end
    ---@type Unit
    local u = obj:get("bindUnit")
    if (class.isObject(u, UnitClass)) then
        local p = u:costPercent()
        if (type(p) == "number") then
            val = worth.cale(val, "*", 1 + 0.01 * p)
        end
        local fixed = u:costWorth()
        if (nil ~= fixed) then
            val = worth.cale(val, "+", fixed)
        end
    end
    return val
end

--- [实际]HP
--- 用于获取HP实际消耗的计算方法
---@param obj Ability
---@return void
function ability.hpCostValue(obj, whichLevel)
    local val = ability.caleValueNumber(obj, whichLevel, "hpCost", "costPercent", "cost")
    return math.ceil(math.max(0, val))
end

--- [条件]HP
--- HP消耗条件的判定方法
---@param obj Ability
---@return boolean
function ability.hpCostCond(obj)
    local val = ability.hpCostValue(obj)
    return not (val > 0 and val >= obj:bindUnit():hpCur())
end

--- [实消]HP
--- HP变动消耗后削减的执行方法
---@param obj Ability
---@return void
function ability.hpCostDeplete(obj)
    sync.must()
    local val = ability.hpCostValue(obj)
    obj:bindUnit():hpCur("-=" .. val)
end

--- [实际]MP
--- 用于获取MP实际消耗的计算方法
---@param obj Ability
---@return void
function ability.mpCostValue(obj, whichLevel)
    local val = ability.caleValueNumber(obj, whichLevel, "mpCost", "costPercent", "cost")
    return math.ceil(math.max(0, val))
end

--- [条件]MP
--- MP消耗条件的判定方法
---@param obj Ability
---@return boolean
function ability.mpCostCond(obj)
    local val = ability.mpCostValue(obj)
    return not (val > 0 and val > obj:bindUnit():mpCur())
end

--- [实消]MP
--- MP变动消耗后削减的执行方法
---@param obj Ability
---@return void
function ability.mpCostDeplete(obj)
    sync.must()
    local val = ability.mpCostValue(obj)
    obj:bindUnit():mpCur("-=" .. val)
end

--- [实际]资源型
--- 用于获取财物资源实际消耗的计算方法
---@param obj Ability
---@return void
function ability.worthCostValue(obj, whichLevel)
    local val = ability.caleValueWorth(obj, whichLevel)
    return worth.l2u(val)
end

--- [条件]资源型
--- 财物资源消耗条件的判定方法
---@param obj Ability
---@return boolean
function ability.worthCostCond(obj)
    local val = ability.worthCostValue(obj)
    return not (nil ~= val and worth.greater(val, obj:bindUnit():owner():worth()))
end

--- [实消]资源型
--- 财物资源变动消耗后削减的执行方法
---@param obj Ability
---@return void
function ability.worthCostDeplete(obj)
    sync.must()
    local val = ability.worthCostValue(obj)
    obj:bindUnit():owner():worth("-", val)
end