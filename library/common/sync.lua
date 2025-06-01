--- 同步管理，用于管理同步环境下的一些操作
---@class sync
sync = sync or {}

---@protected
sync._callback = sync._callback or {}
---@protected
sync._timer = sync._timer or {}
---@protected
sync._queue = sync._queue or {}

--- 是否处在同步执行中
---@return boolean
function sync.is()
    return async._id <= 0
end

--- 限制必须同步
--- 只对async.call调用有判定效果
function sync.must()
    must(sync.is(), "not sync runtime env")
end

---@private
function sync.data(key, data)
    data = data or {}
    if (type(data) ~= "table") then
        data = {}
    end
    return table.concat(table.merge({ key }, data), '|')
end

---@private
function sync.exec(syncKey, syncData, syncPlayer)
    if (type(sync._callback[syncKey]) ~= "function") then
        return
    end
    sync._callback[syncKey]({ syncPlayer = syncPlayer, syncKey = syncKey, transferData = syncData })
end

---@private
---@return boolean
function sync.query(aid)
    local ss = ''
    for q, _ in pairs(sync._queue[aid]) do
        if (ss == "") then
            ss = ss .. q
        else
            ss = ss .. "||" .. q
        end
        sync._queue[aid][q] = nil
        if (string.len(ss) > 512) then
            break
        end
    end
    local act = ss ~= ''
    if (act) then
        japi.DZ_SyncData("lk_send", ss)
    end
    return act
end

--- 在异步环境发起同步,发送执行一般消息同步操作
--- 与onSync配套，this.onSync 接数据
---@param key string
---@param data table<number,any>
---@return number
function sync.send(key, data)
    local aid = async._id
    must(aid > 0, "Invalid aid")
    if (key) then
        if (player.startQuantity > 1) then
            aid = tostring(aid)
            if (nil == sync._queue[aid]) then
                sync._queue[aid] = {}
            end
            local sData = sync.data(key, data)
            sync._queue[aid][sData] = 0
            if (nil == sync._timer[aid]) then
                sync.query(aid)
                sync._timer[aid] = async.setInterval(7, function(curTimer)
                    if (false == sync.query(aid)) then
                        class.destroy(curTimer)
                        sync._timer[aid] = nil
                    end
                end)
            end
        else
            async._id = 0
            sync.exec(key, data, Player1st())
            async._id = aid
        end
    end
end

--- 当收到同步操作
--- 与 send 配套
--- 此方法不能异步调用
---@param key string
---@param callback fun(syncData:{syncPlayer:Player,syncKey:"触发索引",transferData:"传输的数据"}):void
---@return number
function sync.receive(key, callback)
    if (key) then
        if (type(callback) == "function") then
            sync._callback[key] = callback
        else
            sync._callback[key] = nil
        end
    end
end

--- 是否设定了某key的请求
---@param key string
---@return boolean
function sync.hasQuery(key)
    return nil == sync._callback[key]
end

--- 默认游戏同步操作
---[[:use library/common/game]]
game.onPhase("process", function()
    sync.receive("lk_sync_g", function(syncData)
        local resetFollow = false
        local syncPlayer = syncData.syncPlayer
        local command = syncData.transferData[1]
        if (command == "ability_push") then
            resetFollow = true
            ---@type Unit
            local u = class.i2o(syncData.transferData[2])
            ---@type Ability
            local ab = class.i2o(syncData.transferData[3])
            local i = tonumber(syncData.transferData[4])
            if (class.isObject(u, UnitClass) and class.isObject(ab, AbilityClass)) then
                u:abilitySlot():insert(ab, i)
            end
        elseif (command == "ability_effective") then
            local abId = syncData.transferData[2]
            ---@type Ability
            local ab = class.i2o(abId)
            if (class.isObject(ab, AbilityClass)) then
                local amassRatio = syncData.transferData[3]
                if (nil ~= amassRatio) then
                    local increaseRatio = 1 + ab:amassIncreaseRatio(tonumber(amassRatio))
                    ab:spell({ increaseRatio = increaseRatio })
                else
                    ab:spell()
                end
            end
        elseif (command == "ability_effective_u") then
            local abId = syncData.transferData[2]
            local uId = syncData.transferData[3]
            ---@type Ability
            local ab = class.i2o(abId)
            local au = class.i2o(uId)
            if (class.isObject(ab, AbilityClass) and class.isObject(au, UnitClass)) then
                local amassRatio = syncData.transferData[4]
                if (nil ~= amassRatio) then
                    local increaseRatio = 1 + ab:amassIncreaseRatio(tonumber(amassRatio))
                    ab:spell({ targetUnit = au, increaseRatio = increaseRatio })
                else
                    ab:spell({ targetUnit = au })
                end
            end
        elseif (command == "ability_effective_xyz") then
            local abId = syncData.transferData[2]
            local tx = tonumber(syncData.transferData[3])
            local ty = tonumber(syncData.transferData[4])
            local tz = tonumber(syncData.transferData[5])
            if (nil == tx or nil == ty or nil == tz) then
                return
            end
            ---@type Ability
            local ab = class.i2o(abId)
            if (class.isObject(ab, AbilityClass)) then
                local amassRatio = syncData.transferData[6]
                if (nil ~= amassRatio) then
                    local increaseRatio = 1 + ab:amassIncreaseRatio(tonumber(amassRatio))
                    ab:spell({ targetX = tx, targetY = ty, targetZ = tz, increaseRatio = increaseRatio })
                else
                    ab:spell({ targetX = tx, targetY = ty, targetZ = tz })
                end
            end
        elseif (command == "ability_level_up") then
            local abId = syncData.transferData[2]
            ---@type Ability
            local ab = class.i2o(abId)
            if (class.isObject(ab, AbilityClass)) then
                if (ab:level() < ab:levelMax()) then
                    local bu = ab:bindUnit()
                    if (class.isObject(bu, UnitClass)) then
                        ab:bindUnit():abilityPoint('-=' .. ab:levelUpNeedPoint())
                        ab:level('+=1')
                    end
                end
            end
        elseif (command == "item_push") then
            resetFollow = true
            ---@type Unit
            local u = class.i2o(syncData.transferData[2])
            ---@type Item
            local it = class.i2o(syncData.transferData[3])
            local i = tonumber(syncData.transferData[4])
            if (class.isObject(u, UnitClass) and class.isObject(it, ItemClass)) then
                u:itemSlot():insert(it, i)
            end
        elseif (command == "item_to_warehouse") then
            resetFollow = true
            ---@type Unit
            local u = class.i2o(syncData.transferData[2])
            ---@type Item
            local it = class.i2o(syncData.transferData[3])
            local i = tonumber(syncData.transferData[4])
            if (class.isObject(u, UnitClass) and class.isObject(it, ItemClass)) then
                u:itemSlot():remove(it:itemSlotIndex())
                syncPlayer:warehouseSlot():insert(it, i)
                async.call(syncPlayer, function()
                    sound.vcm("war3_PickUpItem")
                end)
            end
        elseif (command == "warehouse_push") then
            resetFollow = true
            local itId = syncData.transferData[2]
            local i = tonumber(syncData.transferData[3])
            ---@type Item
            local it = class.i2o(itId)
            if (class.isObject(it, ItemClass)) then
                syncPlayer:warehouseSlot():insert(it, i)
            end
        elseif (command == "warehouse_to_item") then
            resetFollow = true
            ---@type Unit
            local u = class.i2o(syncData.transferData[2])
            ---@type Item
            local it = class.i2o(syncData.transferData[3])
            local i = tonumber(syncData.transferData[4])
            if (class.isObject(u, UnitClass) and class.isObject(it, ItemClass)) then
                syncPlayer:warehouseSlot():remove(it:warehouseSlotIndex())
                u:itemSlot():insert(it, i)
                async.call(syncPlayer, function()
                    sound.vcm("war3_PickUpItem")
                end)
            end
        elseif (command == "item_drop") then
            local itId = syncData.transferData[2]
            local mx = tonumber(syncData.transferData[3])
            local my = tonumber(syncData.transferData[4])
            ---@type Item
            local it = class.i2o(itId)
            if (class.isObject(it, ItemClass) and it:dropable()) then
                it:drop(mx, my)
            end
        elseif (command == "item_drop_cursor") then
            local itId = syncData.transferData[2]
            local mx = tonumber(syncData.transferData[3])
            local my = tonumber(syncData.transferData[4])
            local isTask = tonumber(syncData.transferData[5])
            ---@type Item
            local it = class.i2o(itId)
            if (class.isObject(it, ItemClass) and it:dropable()) then
                local eff = datum.ternary(syncPlayer == PlayerLocal(), 'UI\\Feedback\\Confirmation\\Confirmation.mdl', '')
                effector.force(eff, mx, my, 2 + japi.Z(mx, my), 1)
                it:drop(mx, my, 1 == isTask)
            end
        elseif (command == "item_deliver_cursor") then
            local itId = syncData.transferData[2]
            local uId = syncData.transferData[3]
            local isTask = tonumber(syncData.transferData[4])
            ---@type Item
            local it = class.i2o(itId)
            ---@type Unit
            local u = class.i2o(uId)
            if (class.isObject(it, ItemClass) and it:dropable() and class.isObject(u, UnitClass)) then
                if (u:isAlive()) then
                    local mx, my = u:x(), u:y()
                    local eff = datum.ternary(syncPlayer == PlayerLocal(), 'UI\\Feedback\\Confirmation\\Confirmation.mdl', '')
                    effector.force(eff, mx, my, 2 + japi.Z(mx, my), 1)
                    it:deliver(u, 1 == isTask)
                end
            end
        elseif (command == "item_pawn") then
            local itId = syncData.transferData[2]
            ---@type Item
            local it = class.i2o(itId)
            if (class.isObject(it, ItemClass) and it:pawnable()) then
                it:pawn()
            end
        end
        if (resetFollow) then
            async.call(syncPlayer, function()
                -- 这里跳帧而不是直接call是因为确保slot事件先刷新，减少图标显隐的颤动
                async.setTimeout(3, function()
                    cursor.quoteOver("follow")
                end)
            end)
        end
    end)
end)