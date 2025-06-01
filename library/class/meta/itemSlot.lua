--- current class name
ItemSlotClass = "ItemSlot"

--- 单位物品栏
--- 自定义单位物品栏数据结构
---@class ItemSlot:Meta
local _index = Meta(ItemSlotClass)

---@protected
function _index:destruct()
    ---@type Item[]
    local s = self._storage
    if (nil ~= s) then
        for i = 1, self._volume do
            if (class.isObject(s[i], ItemClass)) then
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
        local max = #keyboard.itemHotkey()
        vol = math.round(vol)
        vol = math.min(vol, max)
        local s = self._storage
        if (nil ~= s) then
            for i = vol, max do
                if (class.isObject(s[i], ItemClass)) then
                    class.destroy(s[i])
                    s[i] = nil
                end
            end
        end
        self._volume = vol
    end
end

--- 获取存贮数据
---@return Item[]
function _index:storage()
    return self._storage
end

--- 获取空位数量
---@return number
function _index:empty()
    local n = 0
    ---@type Item[]
    local s = self._storage
    for i = 1, self._volume, 1 do
        if (false == class.isObject(s[i], ItemClass)) then
            n = n + 1
        end
    end
    return n
end

--- 找出物品栏某种物品的第一索引
--- 找不到则返回-1
---@param whichTpl ItemTpl 使用TPL来判别类别
---@return number
function _index:index(whichTpl)
    local idx = -1
    if (false == class.isObject(whichTpl, ItemTplClass)) then
        return idx
    end
    ---@type Item[]
    local s = self._storage
    for i = 1, self._volume, 1 do
        if (class.isObject(s[i], ItemClass)) then
            if (s[i]:tpl():id() == whichTpl:id()) then
                idx = i
                break
            end
        end
    end
    return idx
end

--- 判断物品栏中是否拥有某种物品
---@param whichTpl ItemTpl 使用TPL来判别类别
---@return boolean
function _index:has(whichTpl)
    return -1 ~= self:index(whichTpl)
end

--- 触发变化
---@protected
---@return void
function _index:triggerChange()
    local tailAuto = nil
    ---@type Item[]
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
        event.syncTrigger(bu, eventKind.unitItemChange, { triggerSlot = self })
    end
end

--- 插入一个物品
---@param whichItem ItemTpl|Item
---@param index number|nil 对应的物品栏位置[如1-6]
---@return void
function _index:insert(whichItem, index)
    ---@type Item
    local it = nil
    if (class.isObject(whichItem, ItemClass)) then
        it = whichItem
    elseif (class.isObject(whichItem, ItemTplClass)) then
        it = Item(whichItem)
    end
    must(class.isObject(it, ItemClass), "whichItem@Item|ItemTpl")
    ---@type Item[]
    local s = self._storage
    ---@type Unit
    local bu = self._bindUnit
    
    if (nil == index) then
        if (it:bindUnit() == bu) then
            return
        end
        for i = 1, self._volume, 1 do
            if (nil == s[i]) then
                index = i
                break
            end
        end
        if (nil == index) then
            local p = bu:owner()
            if (p:pickMode() == player.pickMode.itemWarehouse) then
                p:warehouseSlot():insert(whichItem)
                alerter.message(p, "物品栏已满已移至仓库", nil, false)
            elseif (p:pickMode() == player.pickMode.itemOnly) then
                alerter.message(p, "物品栏已满", nil, false)
            end
            return
        end
    end
    if (type(index) ~= "number") then
        return
    end
    if (true == it:instance()) then
        it:instance(false)
    end
    local prev = s[index]
    if (class.isObject(prev, ItemClass)) then
        local swap = 0
        for i = 1, self._volume, 1 do
            if (s[i] == it) then
                swap = i
                break
            end
        end
        if (swap > 0) then
            -- 交换物品的情况
            prev:bindUnit(bu)
            if (false == class.isDestroy(prev)) then
                s[swap] = prev:itemSlotIndex(swap)
            end
            it:bindUnit(bu)
            if (false == class.isDestroy(it)) then
                s[index] = it:itemSlotIndex(index)
            end
        else
            local replace = 0
            for i = 1, self._volume, 1 do
                if (nil == s[i]) then
                    replace = i
                    break
                end
            end
            if (replace > 0) then
                -- 挤开物品的情况
                prev:bindUnit(bu)
                if (false == class.isDestroy(prev)) then
                    s[replace] = prev:itemSlotIndex(replace)
                end
            else
                -- 删除物品的情况
                self:remove(index)
            end
            it:bindUnit(bu)
            if (false == class.isDestroy(it)) then
                s[index] = it:itemSlotIndex(index)
            end
        end
    else
        if (it:bindUnit() == bu) then
            if (it:itemSlotIndex() ~= index) then
                s[it:itemSlotIndex()] = nil
                s[index] = it:itemSlotIndex(index)
            end
        else
            it:bindUnit(bu)
            if (false == class.isDestroy(it)) then
                s[index] = it:itemSlotIndex(index)
            end
        end
    end
    self:triggerChange()
end

--- 移除一个物品
---@param index number|nil 对应的物品栏位置[如1-6]
---@return void
function _index:remove(index)
    ---@type Item[]
    local s = self._storage
    if (type(index) == "number" and index > 0 and index <= self._volume) then
        if (class.isObject(s[index], ItemClass)) then
            s[index]:setNil("bindUnit")
        end
    end
end

--- 丢弃一个物品到X,Y
---@param index number|nil 对应的物品栏位置[如1-6]
---@param x number
---@param y number
---@param isTask boolean 是否任务指令
---@return void
function _index:drop(index, x, y, isTask)
    ---@type Item[]
    local s = self._storage
    if (false == class.isObject(s[index], ItemClass)) then
        return
    end
    if (nil == x or nil == y) then
        ---@type Unit
        local bu = self._bindUnit
        if (false == class.isObject(bu, UnitClass)) then
            return
        end
        x = bu:x()
        y = bu:y()
    end
    s[index]:drop(x, y, isTask)
end

--- 丢弃所有物品到X,Y
---@param x number
---@param y number
---@return void
function _index:dropAll(x, y)
    for i = 1, self._volume do
        self:drop(i, x, y, true)
    end
end

--- 构造物品栏对象
---@param bindUnit Unit 绑定单位
---@return ItemSlot
function ItemSlot(bindUnit)
    if (nil == bindUnit._itemSlot) then
        sync.must()
        must(class.isObject(bindUnit, UnitClass), "bindUnit@Unit")
        bindUnit._itemSlot = oMeta({ _bindUnit = bindUnit, _storage = {} }, _index)
        bindUnit._itemSlot._volume = #keyboard.itemHotkey()
    end
    return bindUnit._itemSlot
end