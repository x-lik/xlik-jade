--- 物品对象
--- 此对象在实例化时再继承对应的ItemTpl对象
--- 当Tpl对象数据改动时，也会跟随改动，但独立设置数据后不再变动跟随
---@class Item:ItemTpl
local _index = Vast(ItemClass, {
    _x = 0,
    _y = 0,
    _z = 0,
    ---@type boolean 是否具现化
    _instance = false,
})

---@protected
function _index:destruct()
    class.destroy(self._durationTimer)
    self._durationTimer = nil
    if (true == self:instance()) then
        self:instance(false)
    else
        -- 清除掉绑定的数据和对象
        if (class.isObject(self._bindPlayer, PlayerClass)) then
            self._bindPlayer:warehouseSlot():remove(self._warehouseSlotIndex)
        end
        ---@type Unit
        if (class.isObject(self._bindUnit, UnitClass)) then
            local slot = self._bindUnit:itemSlot()
            if (class.isObject(slot, ItemSlotClass)) then
                slot:remove(self._itemSlotIndex)
            end
        end
        self._itemSlotIndex = nil
    end
    --
    class.destroy(self._bindAbility)
    self._bindAbility = nil
end

--- 预设事件数据数组
---@see eventKind
---@param evt string 事件类型字符，参考eventKind
---@vararg string|function 可以填写(function)或(string, function)当有string参数时作为事件的key
---@return self
function _index:onEvent(evt, ...)
    event.syncRegister(self, evt, ...)
    return self
end

--- 通用型单位事件注册
---@see eventKind
---@param evt string 事件类型字符，参考eventKind
---@vararg string|function 可以填写(function)或(string, function)当有string参数时作为事件的key
---@return self
function _index:onUnitEvent(evt, ...)
    local opt = { ... }
    local key
    local callFunc
    if (type(opt[1]) == "function") then
        key = self:id() .. evt
        callFunc = opt[1]
    elseif (type(opt[1]) == "string" and type(opt[2]) == "function") then
        key = self:id() .. evt .. opt[1]
        callFunc = opt[2]
    end
    if (nil ~= key) then
        local eKey = "ue#" .. key
        if (nil == callFunc) then
            event.syncUnregister(self, eventKind.itemGet, eKey)
            event.syncUnregister(self, eventKind.itemLose, eKey)
        else
            ---@param getData eventOnItemGet
            self:onEvent(eventKind.itemGet, eKey, function(getData)
                event.syncRegister(getData.triggerUnit, evt, eKey, function(callData)
                    callData.triggerItem = getData.triggerItem
                    callFunc(callData)
                end)
            end)
            ---@param loseData eventOnItemLose
            self:onEvent(eventKind.itemLose, eKey, function(loseData)
                event.syncUnregister(loseData.triggerUnit, evt, eKey)
            end)
        end
    end
    return self
end

--- 物品TPL
---@return ItemTpl
function _index:tpl()
    return self._tpl
end

--- handle
--- 如有数据则返回一个灵动型特效
---@return agileEffect
function _index:handle()
    return self._handle
end

--- 物品具现化，没有具现化的物品不会出现在大地图
--- 物品处于单位身上时自动失去具现化意义
---@param status boolean|nil
---@return boolean
function _index:instance(status)
    return self:modify("instance", status)
end

--- 当前热键键值
---@return number|nil
function _index:hotkey()
    return self._hotkey
end

--- 绑定的技能
---@param variety Ability|nil
---@return self|Ability
function _index:bindAbility(variety)
    return self:modify("bindAbility", variety)
end

--- 当前物品在某玩家仓库
---@param variety Player|nil
---@return self|Player
function _index:bindPlayer(variety)
    return self:modify("bindPlayer", variety)
end

--- 绑定单位（当前物品被某单位持有）
---@param variety Unit|nil
---@return self|Unit
function _index:bindUnit(variety)
    return self:modify("bindUnit", variety)
end

--- 物品拥有者
--- 无实质意义，仅配置自定义实现
---@param whichPlayer Player|nil
---@return self|Player
function _index:owner(whichPlayer)
    return self:modify("owner", whichPlayer)
end

--- 持续时间
--- 默认-1
---@param second number|nil 秒
---@return self|number
function _index:duration(second)
    return self:modify("duration", second)
end

--- 获取剩余持续时间
---@return number
function _index:durationRemain()
    if (class.isObject(self._durationTimer, TimerClass)) then
        return self._durationTimer:remain()
    end
    return -1
end

--- 当前物品栏位置
---@param index number|nil 索引
---@return self|number|nil
function _index:itemSlotIndex(index)
    return self:modify("itemSlotIndex", index)
end

--- 当前仓库栏位置
---@param index number|nil 索引
---@return self|number|nil
function _index:warehouseSlotIndex(index)
    return self:modify("warehouseSlotIndex", index)
end

--- X坐标
---@return number
function _index:x()
    if (false == self:instance()) then
        return 0
    end
    return self._x
end

--- Y坐标
---@return number
function _index:y()
    if (false == self:instance()) then
        return 0
    end
    return self._y
end

--- Z坐标
---@return number
function _index:z()
    if (false == self:instance()) then
        return 0
    end
    return self._z
end

--- 移动物品到X,Y坐标
--- 物品会强行具现化
--- 如果物品在单位身上，会自动失去
---@param x number
---@param y number
---@return void
function _index:position(x, y)
    sync.must()
    if (type(x) == "number" and type(y) == "number") then
        x, y = datum.findPosition(x, y)
        self._x = x
        self._y = y
        self._z = japi.Z(self._x, self._y)
        if (false == self:instance()) then
            self:instance(true)
        else
            effector.position(self:handle(), self._x, self._y, self._z)
            Grid(ItemClass):update(self)
        end
    end
end

--- 回收价（返卖给商铺或机构在游戏中列为回收）
--- 与 Player 回收率数据有关连
---@return table,Player
function _index:recoveryPrice()
    ---@type Player
    local bp = self:bindPlayer()
    if (false == class.isObject(bp, PlayerClass)) then
        local bu = self:bindUnit()
        if (class.isObject(bu, UnitClass)) then
            bp = bu:owner()
        else
            return nil, nil
        end
    end
    return worth.cale(self:worth(), "*", bp:recoveryRatio() * 0.01), bp
end

--- 触发技能变动机制
---@param evtData nil|{triggerUnit:Unit,triggerItem:Item}
---@return void
function _index:triggerChange(evtData)
    if (nil == evtData) then
        evtData = { triggerUnit = self:bindUnit(), triggerItem = self }
    end
    if (nil == evtData.triggerItem) then
        evtData.triggerItem = self
    end
    local tu = evtData.triggerUnit
    if (nil ~= tu) then
        event.syncTrigger(tu, eventKind.unitItemChange, evtData)
    end
end

--- 丢弃物品
---@param x number
---@param y number
---@param isTask boolean 默认是任务指令，设false强制取消
---@return void
function _index:drop(x, y, isTask)
    sync.must()
    local u = self:bindUnit()
    if (false == class.isObject(u, UnitClass)) then
        local bp = self:bindPlayer()
        if (class.isObject(bp, PlayerClass)) then
            u = bp:selection()
            if (u:owner() ~= bp) then
                return
            end
        else
            return
        end
    end
    x = x or u:x()
    y = y or u:y()
    local task = Task(u)
    if (false == isTask) then
        task:clear()
    end
    task:develop(function()
        player.unitDistanceAction(u, { x, y }, player.pickActionRadius, function()
            if (false == class.isDestroy(self)) then
                self:position(x, y)
                event.syncTrigger(self, eventKind.itemDrop, { triggerUnit = u, targetX = x, targetY = y })
                if (false == class.isDestroy(self)) then
                    event.syncTrigger(u, eventKind.unitItemDrop, { triggerItem = self, targetX = x, targetY = y })
                end
            end
            async.call(u:owner(), function()
                sound.vcm("war3_HeroDropItem1")
            end)
            task:next()
        end)
    end)
end

--- 传递物品
---@param targetUnit Unit
---@param isTask boolean 默认是任务指令，设false强制取消
---@return void
function _index:deliver(targetUnit, isTask)
    sync.must()
    local u = self:bindUnit()
    if (false == class.isObject(u, UnitClass)) then
        local bp = self:bindPlayer()
        if (class.isObject(bp, PlayerClass)) then
            u = bp:selection()
            if (false == table.equal(u:owner(), bp)) then
                return
            end
        else
            return
        end
    end
    if (class.isObject(targetUnit, UnitClass) and targetUnit:isAlive()) then
        local slot = targetUnit:itemSlot()
        if (slot) then
            local x = targetUnit:x()
            local y = targetUnit:y()
            local task = Task(u)
            if (false == isTask) then
                task:clear()
            end
            task:develop(function()
                player.unitDistanceAction(u, { x, y }, player.pickActionRadius, function()
                    if (false == class.isDestroy(self)) then
                        slot:insert(self)
                        event.syncTrigger(self, eventKind.itemDeliver, { triggerUnit = u, targetUnit = targetUnit })
                        if (false == class.isDestroy(self)) then
                            event.syncTrigger(u, eventKind.unitItemDeliver, { triggerItem = self, targetUnit = targetUnit })
                        end
                    end
                    async.call(u:owner(), function()
                        sound.vcm("war3_HeroDropItem1")
                    end)
                    task:next()
                end)
            end)
        end
    end
end

--- 抵押物品
--- 需要实现类似原生单位型店铺售卖时
--- 可设定单位型店铺unitItemGet事件后执行本pawn
---@return void
function _index:pawn()
    sync.must()
    local rp, bp = self:recoveryPrice()
    if (class.isObject(bp, PlayerClass)) then
        rp = worth.floor(rp)
        bp:worth("+", rp)
        local bu = self:bindUnit()
        event.syncTrigger(self, eventKind.itemPawn, { triggerUnit = bu })
        if (false == class.isDestroy(self)) then
            event.syncTrigger(bu, eventKind.unitItemPawn, { triggerItem = self })
        end
    end
    class.destroy(self)
end

--- 物品使用起效
---@param evtData AbilitySpellEvtData
---@return void
function _index:spell(evtData)
    sync.must()
    ---@type Ability
    local ab = self:ability()
    if (class.isObject(ab, AbilityClass)) then
        ab:spell(evtData)
    end
end

--- 物品对象
--- 继承tpl创建物品
---@param tpl ItemTpl
---@return Item
function Item(tpl)
    must(class.isObject(tpl, ItemTplClass), "tpl@ItemTpl")
    ---@type Item
    local o = oVast({ _tpl = tpl }, _index, tpl)
    --- modifier do action
    VastModifierAct(o)
    --- 事件注册
    if (type(tpl._onEvent) == "table") then
        for _, e in ipairs(tpl._onEvent) do
            o:onEvent(table.unpack(e))
        end
    end
    --- 单位事件注册
    if (type(tpl._onUnitEvent) == "table") then
        for _, e in ipairs(tpl._onUnitEvent) do
            o:onUnitEvent(table.unpack(e))
        end
    end
    --- tpl技能转实例化技能对象
    if (class.isObject(tpl._bindAbilityTpl, AbilityTplClass)) then
        o:bindAbility(Ability(tpl._bindAbilityTpl))
    end
    --- 拥有使用次数的物品消减
    ---@param usedData eventOnItemUsed
    o:onEvent(eventKind.itemUsed, "_charges", function(usedData)
        local it = usedData.triggerItem
        local charges = it:charges()
        if (charges > 0) then
            charges = charges - 1
            if (charges <= 0 and it:consumable()) then
                class.destroy(it)
            else
                it:charges(charges)
            end
        end
        o:triggerChange()
    end)
    return o
end