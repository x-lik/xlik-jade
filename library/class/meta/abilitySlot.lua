--- current class name
AbilitySlotClass = "AbilitySlot"

--- 单位技能栏
--- 自定义单位技能栏数据结构
---@class AbilitySlot:Meta
local _index = Meta(AbilitySlotClass, {
    _tail = 0, -- 技能最后位置索引
    _tailAuto = 0, -- 程序自动技能最后位置索引
})

---@protected
function _index:destruct()
    ---@type Ability[]
    local s = self._storage
    if (nil ~= s) then
        for i = 1, self._volume do
            if (class.isObject(s[i], AbilityClass)) then
                class.destroy(s[i])
            end
        end
    end
    self._storage = nil
end

--- 获取绑定单位
---@return Unit
function _index:bindUnit()
    return self._bindUnit
end

--- 获取容量
---@return number
function _index:volume()
    return self._volume
end

--- 手动设置容量（缩小时超出范围对象会被直接销毁）
--- 默认取游戏热键数量
---@param vol number
---@return void
function _index:setVolume(vol)
    if (type(vol) == "number") then
        local max = #keyboard.abilityHotkey()
        vol = math.round(vol)
        vol = math.min(vol, max)
        local s = self._storage
        if (nil ~= s) then
            for i = vol, max do
                if (class.isObject(s[i], AbilityClass)) then
                    class.destroy(s[i])
                    s[i] = nil
                end
            end
        end
        self._volume = vol
    end
end

--- 获取存贮Ability
---@return Ability[]
function _index:storage()
    return self._storage
end

--- 获取空位数量
---@return number
function _index:empty()
    local n = 0
    ---@type Ability[]
    local s = self._storage
    for i = 1, self._volume, 1 do
        if (false == class.isObject(s[i], AbilityClass)) then
            n = n + 1
        end
    end
    return n
end

--- 获取单位技能最后位置索引
---@return number
function _index:tail()
    return math.max(self._tail, self._tailAuto)
end

--- 设置单位技能最后位置索引
---@param tail number
---@return self
function _index:setTail(tail)
    if (type(tail) == "number" and tail >= 0) then
        self._tail = math.round(tail)
    end
    return self
end

--- 找出技能栏某种技能的第一索引
--- 找不到则返回-1
---@param whichTpl AbilityTpl 使用TPL来判别类别
---@return number
function _index:index(whichTpl)
    local idx = -1
    if (false == class.isObject(whichTpl, AbilityTplClass)) then
        return idx
    end
    ---@type Ability[]
    local s = self._storage
    for i = 1, self._volume, 1 do
        if (class.isObject(s[i], AbilityClass)) then
            if (s[i]:tpl():id() == whichTpl:id()) then
                idx = i
                break
            end
        end
    end
    return idx
end

--- 判断技能栏中是否拥有某种技能
---@param whichTpl AbilityTpl 使用TPL来判别类别
---@return boolean
function _index:has(whichTpl)
    return -1 ~= self:index(whichTpl)
end

--- 触发变化
---@protected
---@return void
function _index:triggerChange()
    local tailAuto = nil
    ---@type Ability[]
    local s = self._storage
    for i = self._volume, 1, -1 do
        if (nil ~= s[i]) then
            tailAuto = i
            break
        end
    end
    self._tailAuto = tailAuto
    ---@type Unit
    local bu = self._bindUnit
    if (class.isObject(bu, UnitClass)) then
        event.syncTrigger(bu, eventKind.unitAbilityChange, { triggerSlot = self })
    end
end

--- 插入一个技能
--- 热键强制与位置顺序【ABILITY_HOTKEY】绑定，如果没有配置位置,从集合中选出一个位置自动赋予
---@param whichAbility AbilityTpl|Ability
---@param index number|nil 配置顺序位置
---@return void
function _index:insert(whichAbility, index)
    ---@type Ability
    local ab = nil
    if (class.isObject(whichAbility, AbilityClass)) then
        ab = whichAbility
    elseif (class.isObject(whichAbility, AbilityTplClass)) then
        ab = Ability(whichAbility)
    end
    must(class.isObject(ab, AbilityClass), "whichAbility@Ability|AbilityTpl")
    ---@type Ability[]
    local s = self._storage
    ---@type Unit
    local bu = self._bindUnit
    if (nil == index) then
        if (ab:bindUnit() == bu) then
            return
        end
        for i = 1, self._volume do
            if (nil == s[i]) then
                index = i
                break
            end
        end
    end
    if (type(index) ~= "number") then
        return
    end
    local prev = s[index]
    if (class.isObject(prev, AbilityClass)) then
        local swap = 0
        for i = 1, self._volume do
            if (s[i] == ab) then
                swap = i
                break
            end
        end
        if (swap > 0) then
            -- 交换技能的情况
            prev:bindUnit(bu)
            if (false == class.isDestroy(prev)) then
                s[swap] = prev:abilitySlotIndex(swap)
            end
            ab:bindUnit(bu)
            if (false == class.isDestroy(ab)) then
                s[index] = ab:abilitySlotIndex(index)
            end
        else
            local replace = 0
            for i = 1, self._volume do
                if (nil == s[i]) then
                    replace = i
                    break
                end
            end
            if (replace > 0) then
                -- 挤开技能的情况
                prev:bindUnit(bu)
                if (false == class.isDestroy(prev)) then
                    s[replace] = prev:abilitySlotIndex(replace)
                end
            else
                -- 删除技能的情况
                self:remove(index)
            end
            ab:bindUnit(bu)
            if (false == class.isDestroy(ab)) then
                s[index] = ab:abilitySlotIndex(index)
            end
        end
    else
        if (ab:bindUnit() == bu) then
            if (ab:abilitySlotIndex() ~= index) then
                s[ab:abilitySlotIndex()] = nil
                s[index] = ab:abilitySlotIndex(index)
            end
        else
            ab:bindUnit(bu)
            if (false == class.isDestroy(ab)) then
                s[index] = ab:abilitySlotIndex(index)
            end
        end
    end
    self:triggerChange()
end

--- 移除一个技能
---@param index number|nil 技能在技能栏中的索引
---@return void
function _index:remove(index)
    ---@type Ability[]
    local s = self._storage
    if (type(index) == "number" and index > 0 and index <= self._volume) then
        if (class.isObject(s[index], AbilityClass)) then
            s[index]:setNil("bindUnit")
        end
    end
end

--- 构造技能栏对象
---@param bindUnit Unit 绑定单位
---@return AbilitySlot
function AbilitySlot(bindUnit)
    if (nil == bindUnit._abilitySlot) then
        sync.must()
        must(class.isObject(bindUnit, UnitClass), "bindUnit@Unit")
        bindUnit._abilitySlot = oMeta({ _bindUnit = bindUnit, _storage = {} }, _index)
        bindUnit._abilitySlot._volume = #keyboard.abilityHotkey()
    end
    return bindUnit._abilitySlot
end