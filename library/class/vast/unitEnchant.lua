--- current class name
UnitEnchantClass = "UnitEnchant"

--- 单位附魔属性特殊数据
---[[:use library/class/vast/unitAttr]]
---@class UnitEnchantVast:UnitAttrVast
local _index = Vast(UnitEnchantClass, {
    ---@type number 附魔上身默认持续时间[秒]
    _enchantAppendDuration = 10,
    ---@type number 附魔精通[%]
    _enchantMystery = 0,
}):extend(UnitAttrClass)

---@protected
function _index:construct()
    -- 补充各元素附魔强化和抵抗数据
    EnchantForeach(function(k)
        local e = Enchant(k)
        local strengthen = e:strengthen()
        local resistance = e:resistance()
        -- 强化
        if (type(strengthen) == "number") then
            self[SYMBOL_E .. k] = strengthen
        end
        -- 抗性
        if (type(resistance) == "number") then
            self[SYMBOL_RES .. SYMBOL_E .. k] = resistance
        end
        -- 免疫，大于0则免疫k元素
        -- 不采用布尔值是因为方便处理多次值设置
        self[SYMBOL_EI .. k] = 0
    end)
    -- 原始材质
    if (nil ~= self._enchantMaterial) then
        self:enchantAppend(self._enchantMaterial, -99999)
    end
end

--- 附魔强化[%]
---@see injury#damageType
---@param eType string|MappingValue 附魔类型字符串 或 injury.damageType
---@param variety number|nil
---@return self|number
function _index:enchantStrengthen(eType, variety)
    if (type(eType) == "table") then
        eType = eType.value
        must(type(eType) == "string", "key@string")
    end
    return self:modify(eType, variety, nil, SYMBOL_E, 0)
end

--- 附魔抵抗[%]
---@see injury#damageType
---@param eType string|MappingValue 附魔类型字符串 或 injury.damageType
---@param variety number|nil
---@return self|number
function _index:enchantResistance(eType, variety)
    if (type(eType) == "table") then
        eType = eType.value
        must(type(eType) == "string", "key@string")
    end
    return self:modify(eType, variety, nil, SYMBOL_RES .. SYMBOL_E, 0)
end

--- 附魔免疫
---@see injury#damageType
---@param eType string|MappingValue 附魔类型字符串 或 injury.damageType
---@param variety number|nil
---@return self|number
function _index:enchantImmune(eType, variety)
    if (type(eType) == "table") then
        eType = eType.value
        must(type(eType) == "string", "key@string")
    end
    return self:modify(eType, variety, nil, SYMBOL_EI, 0)
end

--- 附魔精通[%]
--- 影响所有元素伤害，影响附魔反应的效果
---@param variety number
---@return self|number
function _index:enchantMystery(variety)
    return self:modify("enchantMystery", variety)
end

--- 是否附魔免疫
---@see injury#damageType
---@param key string|MappingValue 附魔类型字符串 或 injury.damageType
---@return boolean
function _index:isEnchantImmune(key)
    return self:enchantImmune(key) > 0
end

--- 附魔伤型附着持续时间（秒）
---@param second number|nil
---@return self|number
function _index:enchantAppendDuration(second)
    return self:modify("enchantAppendDuration", second)
end

--- 附魔原始材质
--- 添加或移除附魔永久附带属性
--- 如火史莱姆之类的会用这方法在初始化就绑定1种属性
--- 只能设置1种元素属性，后设置会替换先设置的属性
---@see injury#damageType
---@param eType MappingValue|string|boolean 附魔元素，可以设为false移除属性
---@return self|any
function _index:enchantMaterial(eType)
    if (nil == eType) then
        return self._enchantMaterial
    end
    if (class.isReality(self)) then
        if (false == eType) then
            self:enchantSubtract(eType, -99999)
            self._enchantMaterial = nil
        else
            if (nil ~= self._enchantMaterial) then
                self:enchantSubtract(eType, -99999)
                self._enchantMaterial = nil
            end
            self:enchantAppend(eType, -99999)
        end
    else
        self._enchantMaterial = eType
    end
    return self
end

--- 获取单位是否正在附魔
--- 只能在实例化后使用
---@param key table|string 附魔种类
---@return boolean
function _index:isEnchantAppending(key)
    must(class.isReality(self), "Not reality Object")
    if (type(key) == "table") then
        key = key.value
    end
    if (type(key) ~= "string") then
        return false
    end
    return self:enchantLevel(key) ~= 0
end

--- 获取单位某种附魔等级
--- 只能在实例化后使用
---@param eType table|string 附魔种类
---@return number int
function _index:enchantLevel(eType)
    must(class.isReality(self), "Not reality Object")
    if (type(eType) == "table") then
        eType = eType.value
    end
    if (type(eType) ~= "string") then
        return 0
    end
    local a = self._enchantAppendingData
    if (type(a) == "table" and type(a[eType]) == "table") then
        return a[eType].level or 0
    end
    return 0
end

--- 伤型附着
--- 只能在实例化后使用
---@return nil|table<string,unitEnchantAppendingData>
function _index:enchantAppendingData()
    return self._enchantAppendingData
end

--- 清理某属性伤型附着数据
--- 只能在实例化后使用
---@private
---@param eKey string 附魔类型字符串 或 injury.damageType
---@param isDelete boolean 是否顺便置nil
---@return void
function _index:cls(eKey, isDelete)
    local data = self._enchantAppendingData
    if (type(data) == "table") then
        return
    end
    data = data[eKey]
    if (type(data) == "table") then
        if (type(data.effs) == "table") then
            for _, eff in ipairs(data.effs) do
                class.destroy(eff)
            end
            data.effs = nil
        end
        if (class.isObject(data.timer, TimerClass)) then
            class.destroy(data.timer)
            data.timer = nil
        end
    end
    if (true == isDelete) then
        self._enchantAppendingData[eKey] = nil
    end
end

--- 附魔附着
--- 只能在实例化后使用
---@alias unitEnchantAppendingData {level:number,effs:attachEffect[],timer:Timer}
---@param eType table|string injury.damageType
---@param level number 等级负数时，不会被自动泯灭；等级0时，不会附着
---@param sourceUnit Unit|nil 罪魁祸首
---@return void
function _index:enchantAppend(eType, level, sourceUnit)
    sync.must()
    if (type(eType) == "table") then
        eType = eType.value
    end
    must(type(eType) == "string", "eType@string,injury.damageType")
    must(class.isReality(self), "Not reality Object")
    level = level or 0
    local data = self._enchantAppendingData
    if (type(data) == "table") then
        -- 有过去的附着，检测反应
        EnchantForeach(function(e)
            local a = data[e]
            if (type(a) == "table") then
                -- 反应
                local react = Enchant(e):reaction(eType)
                if (type(react) == "function") then
                    if (a.level < 0) then
                        if (level < 0) then
                            a.level = a.level + level
                        end
                    elseif (a.level > 0) then
                        if (level < 0) then
                            -- 新附魔不泯灭，泯灭旧附魔
                            self:cls(e, true)
                        elseif (level == a.level) then
                            -- 泯灭新旧附魔，都被反应用光了
                            level = 0
                            self:cls(e, true)
                        elseif (level > a.level) then
                            -- 泯灭旧附魔，被新反应用光了
                            level = level - a.level
                            self:cls(e, true)
                        else
                            -- 泯灭新附魔，被旧反应用光了
                            -- 0级反应一样要消耗附着元素，消耗完泯灭之
                            a.level = a.level - math.max(1, level)
                            if (a.level == 0) then
                                self:cls(e, true)
                            end
                            level = 0
                        end
                    end
                    react({
                        targetUnit = self,
                        sourceUnit = sourceUnit,
                        from = e,
                        to = eType,
                    })
                end
            end
        end)
    end
    if (level ~= 0) then
        if (nil == data) then
            data = {}
        end
        local ec = Enchant(eType)
        if (nil == data[eType]) then
            data[eType] = {}
        end
        self:cls(eType, false)
        if (level > 0) then
            if (type(data[eType].level) == "number" and data[eType].level > 0) then
                level = math.max(level, data[eType].level)
            end
        else
            if (type(data[eType].level) == "number" and data[eType].level < 0) then
                level = math.min(level, data[eType].level)
            end
        end
        data[eType].level = level
        if (level ~= 0) then
            local ae = ec:effectAppend()
            if (isArray(ae)) then
                if (nil == data[eType].effs) then
                    data[eType].effs = {}
                    ae:forEach(function(attach, model)
                        local e2 = effector.attach(self, model, attach, -1)
                        if (nil ~= e2) then
                            table.insert(data[eType].effs, e2)
                        end
                    end)
                end
            end
            if (level > 0) then
                data[eType].timer = time.setTimeout(self._enchantAppendDuration, function()
                    self:enchantSubtract(eType, -level)
                end)
            end
        end
    end
    if (nil ~= data) then
        self._enchantAppendingData = data
    end
end

--- 强制修改伤型附着等级
--- 只能在实例化后使用
---@param eType string|table 附魔类型字符串 或 injury.damageType
---@param targetLevel number 目标等级
---@return void
function _index:enchantSetAppendingLevel(eType, targetLevel)
    sync.must()
    must(class.isReality(self), "Not reality Object")
    if (type(eType) == "table") then
        eType = eType.value
    end
    must(type(eType) == "string", "eType@string,injury.damageType")
    local data = self._enchantAppendingData
    if (type(data) == "table" and type(data[eType]) == "table") then
        data[eType].level = targetLevel
    end
end

--- 附魔移除去着
--- 只能在实例化后使用
---@param eType table|string injury.damageType
---@param level number|nil 削去的等级
---@return void
function _index:enchantSubtract(eType, level)
    sync.must()
    must(class.isReality(self), "Not reality Object")
    must(type(level) == "number", "level@integer")
    if (type(eType) == "table") then
        eType = eType.value
    end
    must(type(eType) == "string", "eType@string,injury.damageType")
    local data = self._enchantAppendingData
    if (type(data) ~= "table") then
        return
    end
    if (type(data[eType]) == "table") then
        data[eType].level = data[eType].level - level
        if (data[eType].level >= 0) then
            self:cls(eType, true)
        end
    end
end

--- 所有附魔移除去着
--- 只能在实例化后使用
---@return void
function _index:enchantSubtractAll()
    sync.must()
    must(class.isReality(self), "Not reality Object")
    local data = self._enchantAppendingData
    if (type(data) ~= "table") then
        return
    end
    EnchantForeach(function(v)
        self:cls(v, true)
    end)
    self._enchantAppendingData = nil
end