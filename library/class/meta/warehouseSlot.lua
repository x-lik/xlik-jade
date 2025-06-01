--- current class name
WarehouseSlotClass = "WarehouseSlot"

--- 玩家仓库，自定义玩家仓库栏数据结构
---@class WarehouseSlot:Meta
local _index = Meta(WarehouseSlotClass)

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

--- 获取绑定玩家
---@return Player
function _index:bindPlayer()
    return self._bindPlayer
end

--- 获取容量
---@return number
function _index:volume()
    return self._volume
end

--- 手动设置容量（缩小时超出范围对象会被直接销毁）
--- 默认取游戏仓库数量
---@param vol number
---@return void
function _index:setVolume(vol)
    if (type(vol) == "number") then
        local max = player.warehouseSlotVolume
        vol = math.round(vol)
        vol = math.min(vol, max)
        ---@type Item[]
        local s = self._storage
        if (nil ~= s) then
            for i = vol, max do
                if (class.isObject(s[i], ItemClass)) then
                    s[i]:drop()
                    s[i] = nil
                end
            end
        end
        self._volume = vol
    end
end

--- 获取存贮Item
---@return Item[]
function _index:storage()
    return self._storage
end

--- 获取空位数量
---@return number
function _index:empty()
    local n = 0
    ---@type Item[]
    local storage = self._storage
    for i = 1, self._volume, 1 do
        if (false == class.isObject(storage[i], ItemClass)) then
            n = n + 1
        end
    end
    return n
end

--- 返回仓库栏某种物品的总数量
---@param whichTpl ItemTpl 使用TPL来判别类别
---@return boolean
function _index:quantity(whichTpl)
    local n = 0
    if (class.isObject(whichTpl, ItemTplClass)) then
        ---@type Item[]
        local s = self._storage
        for i = 1, self._volume, 1 do
            if (class.isObject(s[i], ItemClass)) then
                if (s[i]:tpl():id() == whichTpl:id()) then
                    n = n + 1
                end
            end
        end
    end
    return n
end

--- 找出仓库栏某种物品的第一索引
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

--- 判断仓库栏中是否拥有某种物品
---@param whichTpl ItemTpl 使用TPL来判别类别
---@return boolean
function _index:has(whichTpl)
    return -1 ~= self:index(whichTpl)
end

--- 触发变化
---@protected
---@return void
function _index:triggerChange()
    event.syncTrigger(self._bindPlayer, eventKind.playerWarehouseChange, { triggerSlot = self })
end

--- 插入一个物品
---@param whichItem ItemTpl|Item
---@param index number|nil 对应的仓库栏位置[1-18]
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
    ---@type Player
    local bp = self._bindPlayer
    if (nil == index) then
        if (it:bindPlayer() == bp) then
            return
        end
        for i = 1, self._volume, 1 do
            if (nil == s[i]) then
                index = i
                break
            end
        end
        if (nil == index) then
            alerter.message(bp, "仓库已满", colour.red, false)
            return
        end
    end
    if (type(index) ~= "number") then
        return
    end
    if (true == it:instance()) then
        it:instance(false)
    end
    if (nil ~= it:bindUnit()) then
        if (nil ~= it:itemSlotIndex()) then
            it:bindUnit():itemSlot():remove(it:itemSlotIndex())
        end
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
            s[swap] = prev:warehouseSlotIndex(swap)
            s[index] = it:bindPlayer(bp):warehouseSlotIndex(index)
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
                s[replace] = prev:bindPlayer(bp):warehouseSlotIndex(replace)
            else
                -- 删除物品的情况
                self:remove(index)
            end
            s[index] = it:bindPlayer(bp):warehouseSlotIndex(index)
        end
    else
        if (it:bindPlayer() == bp) then
            if (it:warehouseSlotIndex() ~= index) then
                s[it:warehouseSlotIndex()] = nil
                s[index] = it:bindPlayer(bp):warehouseSlotIndex(index)
            end
        else
            s[index] = it:bindPlayer(bp):warehouseSlotIndex(index)
        end
    end
    self:triggerChange()
end

--- 删除一个物品
---@param index number|nil 对应的仓库栏位置[1-6]
---@return void
function _index:remove(index)
    local s = self._storage
    if (type(index) == "number" and index > 0 and index <= self._volume and class.isObject(s[index], ItemClass)) then
        s[index]._warehouseSlotIndex = nil
        s[index]._bindPlayer = nil
        s[index] = nil
        self:triggerChange()
    end
end

--- 删除仓库栏某种物品
---@param whichTpl ItemTpl 使用TPL来判别类别
---@param qty number 删除数量，默认-1：全部删除
---@return void
function _index:removeTpl(whichTpl, qty)
    if (class.isObject(whichTpl, ItemTplClass)) then
        qty = qty or -1
        local qi = 0
        ---@type Item[]
        local s = self._storage
        for i = self._volume, 1, -1 do
            if (class.isObject(s[i], ItemClass)) then
                if (s[i]:tpl():id() == whichTpl:id()) then
                    self:remove(i)
                    if (qty > 0) then
                        qi = qi + 1
                        if (qi >= qty) then
                            break
                        end
                    end
                end
            end
        end
        self:triggerChange()
    end
end

--- 删除仓库栏所有物品
---@return void
function _index:removeAll()
    ---@type Item[]
    local s = self._storage
    for i = self._volume, 1, -1 do
        if (class.isObject(s[i], ItemClass)) then
            self:remove(i)
        end
    end
    self:triggerChange()
end

--- 丢弃一个物品到X,Y
---@param index number|nil 对应的仓库栏位置[1-6]
---@param x number
---@param y number
---@return void
function _index:drop(index, x, y)
    ---@type Item[]
    local s = self._storage
    if (false == class.isObject(s[index], ItemClass)) then
        return
    end
    s[index]:drop(x, y)
    s[index] = nil
    self:triggerChange()
end

--- 构造玩家仓库对象
---@param bindPlayer Player 绑定玩家
---@return WarehouseSlot
function WarehouseSlot(bindPlayer)
    must(class.isObject(bindPlayer, PlayerClass), "bindPlayer@Player")
    if (nil == bindPlayer._warehouseSlot) then
        sync.must()
        bindPlayer._warehouseSlot = oMeta({ _bindPlayer = bindPlayer, _storage = {} }, _index)
        bindPlayer._warehouseSlot._volume = player.warehouseSlotVolume
    end
    return bindPlayer._warehouseSlot
end