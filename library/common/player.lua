--- 玩家方法
--- 主要对原生玩家执行一些必要的处理
--- 包含一些与玩家相关的函数及方法
---@class player
player = player or {}

--- 游戏开始时玩家数
player.startQuantity = player.startQuantity or 1
--- 游戏当前玩家数
player.currentQuantity = player.currentQuantity or 1
-- 玩家状态
local m_ps = Mapping("playerStatus")
player.status = {
    empty = m_ps:set("empty", "空置"),
    playing = m_ps:set("playing", "在线"),
    leave = m_ps:set("leave", "离线"),
}
--- 仓库栏默认容量
player.warehouseSlotVolume = player.warehouseSlotVolume or 12
--- 游戏物品拾取执行范围
player.pickActionRadius = player.pickActionRadius or 200
--- 游戏物品拾取格子判定范围
player.pickGridRadius = player.pickGridRadius or 32
-- 玩家物品拾取模式
local m_pm = Mapping("playerPickMode")
player.pickMode = {
    itemWarehouse = m_pm:set("itemWarehouse", "优先物品栏，满则转移至仓库"),
    itemOnly = m_pm:set("itemOnly", "只拾取到物品栏"),
    warehouseOnly = m_pm:set("warehouseOnly", "只拾取到仓库"),
}
-- 玩家聊天正则匹配规则
---@type Array
player._chatPattern = nil

---@type number
player._evtEsc = J.Condition(function()
    local triggerPlayer = class.h2p(J.GetTriggerPlayer())
    event.syncTrigger(triggerPlayer, eventKind.playerEsc)
    --- 清空技能引用
    async.call(triggerPlayer, function()
        if (false == japi.IsLongPressing("keyboard")) then
            cursor.quoteOver()
        end
    end)
    local sel = triggerPlayer:selection()
    if (class.isObject(sel, UnitClass) and sel:owner() == triggerPlayer) then
        sel:abilityCaptureRevert()
    end
end)

---@type number
player._evtSelect = J.Condition(function()
    local triggerPlayer = class.h2p(J.GetTriggerPlayer())
    local triggerUnit = class.h2u(J.GetTriggerUnit())
    local prevUnit = triggerPlayer:selection()
    local isChanged = true
    if (false == class.isObject(triggerUnit, UnitClass)) then
        print("Select2Obj=Nil", J.GetTriggerUnit(), J.GetUnitName(J.GetTriggerUnit()), triggerUnit)
        return
    end
    --- 多选记录
    if (class.isObject(prevUnit, UnitClass)) then
        if (prevUnit:id() == triggerUnit:id()) then
            isChanged = false
        end
    end
    if (class.isObject(triggerPlayer._selectTimer, TimerClass)) then
        class.destroy(triggerPlayer._selectTimer)
        triggerPlayer._selectTimer = nil
    end
    if (isChanged) then
        triggerPlayer._selectTimes = 0
        triggerPlayer:set("selection", triggerUnit)
    end
    triggerPlayer._selectTimes = triggerPlayer._selectTimes + 1
    triggerPlayer._selectTimer = time.setTimeout(0.3, function()
        class.destroy(triggerPlayer._selectTimer)
        triggerPlayer._selectTimer = nil
        if (triggerPlayer._selectTimes > 0 and triggerUnit:isAlive()) then
            for ti = 4, 2, -1 do
                if (triggerPlayer._selectTimes >= ti) then
                    triggerPlayer._selectTimes = 0
                    event.syncTrigger("player", eventKind.playerMultipleSelect .. "#" .. ti, {
                        triggerPlayer = triggerPlayer,
                        triggerUnit = triggerUnit,
                        times = ti,
                    })
                    break
                end
            end
        end
        triggerPlayer._selectTimes = 0
    end)
end)

---@type number
player._evtLeave = J.Condition(function()
    local triggerPlayer = class.h2p(J.GetTriggerPlayer())
    triggerPlayer:status(player.status.leave)
    async.call(triggerPlayer, function()
        cursor.quoteOver()
    end)
    echo(triggerPlayer:name() .. "离开了游戏～")
    player.currentQuantity = player.currentQuantity - 1
    event.syncTrigger(triggerPlayer, eventKind.playerQuit)
end)

---@type number
player._evtChat = J.Condition(function()
    local triggerPlayer = class.h2p(J.GetTriggerPlayer())
    event.syncTrigger("player", eventKind.playerChat, {
        triggerPlayer = triggerPlayer,
        chatString = J.GetEventPlayerChatString(),
    })
end)

---@type number
player._evtAttacked = J.Condition(function()
    local attacker = class.h2u(J.GetAttacker())
    if (nil == attacker) then
        return
    end
    local target = class.h2u(J.GetTriggerUnit())
    if (false == class.isObject(target, UnitClass)) then
        return
    end
    local attackRangeMin = attacker:attackRangeMin()
    if (attackRangeMin > 0) then
        local ax, ay, tx, ty = attacker:x(), attacker:y(), target:x(), target:y()
        if (attackRangeMin > vector2.distance(ax, ay, tx, ty)) then
            local px, py = vector2.polar(tx, ty, attackRangeMin + 20, vector2.angle(tx, ty, ax, ay))
            time.setTimeout(0, function()
                player.unitDistanceAction(attacker, { px, py }, 10, function()
                    attacker:orderAttackTargetUnit(target)
                end)
            end)
            return
        end
    end
    local v = slk.i2v(attacker:slkId())
    if (nil == v) then
        print("attackerError")
        return
    end
    event.syncTrigger(attacker, eventKind.unitBeforeAttack, { targetUnit = target })
    event.syncTrigger(target, eventKind.unitBeBeforeAttack, { sourceUnit = attacker })
    local dmgpt = math.trunc(v.slk.dmgpt1, 3)
    local attackSpeed = math.min(math.max(attacker:attackSpeed(), -80), 400)
    local delay = 0.25 + attacker:attackPoint() * dmgpt / (1 + attackSpeed * 0.01)
    if (nil == attacker._attackTimers) then
        attacker._attackTimers = {}
    end
    local t = time.setTimeout(delay, function(curTimer)
        local id = curTimer._id
        class.destroy(curTimer)
        if (nil ~= attacker._attackTimers[id]) then
            attacker._attackTimers[id] = nil
            if (attacker:weaponSoundMode() == 2) then
                sound.vwp(attacker, target)
            end
            injury.attack(attacker, target)
        end
    end)
    attacker._attackTimers[t._id] = t
end)

---@type number
player._evtOrder = J.Condition(function()
    local triggerUnit = class.h2u(J.GetTriggerUnit())
    if (false == class.isObject(triggerUnit, UnitClass)) then
        return
    end
    local orderId = J.GetIssuedOrderId()
    local orderTargetUnit = J.GetOrderTargetUnit()
    local tx, ty, tz
    if (orderTargetUnit ~= 0) then
        tx = J.GetUnitX(orderTargetUnit)
        ty = J.GetUnitY(orderTargetUnit)
        tz = japi.Z(tx, ty)
    else
        tx = J.GetOrderPointX()
        ty = J.GetOrderPointY()
        tz = japi.Z(tx, ty)
    end
    local owner = triggerUnit:owner()
    if (owner:isPlaying() and owner:isUser() and false == owner:isComputer()) then
        owner._operand = owner._operand + 1
        owner._apm = owner._operand / (time._min + 1)
    end
    async.call(owner, function()
        if (false == japi.IsLongPressing("keyboard")) then
            cursor.quoteOver()
        end
    end)
    if (class.isObject(triggerUnit._distanceActionTimer, TimerClass)) then
        class.destroy(triggerUnit._distanceActionTimer)
        triggerUnit._distanceActionTimer = nil
    end
    --[[
       851971:smart
       851972:stop 停止
       851974:nil 无
       851983:attack 攻击
       851986:move 移动
       851988:AImove AI移动
       851990:patrol 巡逻
       851993:holdposition 保持原位
    ]]
    if (orderId ~= 851983) then
        if (nil ~= triggerUnit._attackTimers) then
            triggerUnit._attackTimers = {}
        end
    end
    if (orderId == 851993) then
        event.syncTrigger(triggerUnit, eventKind.unitOrderHold)
    elseif (orderId == 851972) then
        event.syncTrigger(triggerUnit, eventKind.unitOrderStop)
    elseif (orderId == 851974) then
        --
    else
        if (nil ~= tx and nil ~= ty and nil ~= tz) then
            if (orderId == 851971) then
                local ci = Grid(ItemClass):closest({
                    circle = {
                        x = tx,
                        y = ty,
                        radius = player.pickGridRadius
                    }
                })
                if (ci) then
                    triggerUnit:pickItem(ci)
                else
                    event.syncTrigger(triggerUnit, eventKind.unitOrderMove, { x = tx, y = ty })
                end
            elseif (orderId == 851988) then
                event.syncTrigger(triggerUnit, eventKind.unitOrderMove, { x = tx, y = ty })
            elseif (orderId == 851983) then
                event.syncTrigger(triggerUnit, eventKind.unitOrderAttack, { x = tx, y = ty })
            elseif (orderId == 851986) then
                event.syncTrigger(triggerUnit, eventKind.unitOrderMove, { x = tx, y = ty })
            end
        end
    end
end)

---@type number
player._evtDead = J.Condition(function()
    local deadUnit = class.h2u(J.GetTriggerUnit())
    if (nil == deadUnit) then
        return
    end
    injury.kill(deadUnit)
end)

--- 检测是否属于有效的玩家状态
---@param whichStatus table player.status.*
---@return boolean
function player.isValidStatus(whichStatus)
    return type(whichStatus) == "table" and whichStatus._type == _ps._type
end

--- 检测是否属于有效的玩家拾取模式
---@param whichMode table player.pickMode.*
---@return boolean
function player.isValidPickMode(whichMode)
    return type(whichMode) == "table" and whichMode._type == _pm._type
end

--- 单位距离过程
---@param whichUnit Unit
---@param target Unit|Item|number[] target可以是个数组如{0,0}指向目标坐标
---@param judgeDistance number
---@param callFunc fun():void
---@return void
function player.unitDistanceAction(whichUnit, target, judgeDistance, callFunc)
    sync.must()
    if (class.isObject(whichUnit._distanceActionTimer, TimerClass)) then
        class.destroy(whichUnit._distanceActionTimer)
        whichUnit._distanceActionTimer = nil
    end
    local move = whichUnit:move()
    if (move <= 0) then
        return
    end
    --- 距离判断
    local _target = function(tar)
        if (class.isObject(tar, UnitClass) or class.isObject(tar, ItemClass)) then
            return tar:x(), tar:y()
        elseif (type(tar) == "table") then
            return tar[1], tar[2]
        end
    end
    local ux, uy = whichUnit:x(), whichUnit:y()
    local tx, ty = _target(target)
    local d1 = vector2.distance(tx, ty, ux, uy)
    if (d1 > judgeDistance) then
        local angle = vector2.angle(tx, ty, ux, uy)
        local px, py = vector2.polar(tx, ty, judgeDistance - 75, angle)
        J.IssuePointOrder(whichUnit:handle(), "move", px, py)
        local frq = math.max(0.05, d1 / move / 2)
        whichUnit._distanceActionTimer = time.setInterval(frq, function(actTimer)
            local x, y = _target(target)
            if (nil == x or whichUnit:isInterrupt()) then
                class.destroy(whichUnit._distanceActionTimer)
                whichUnit._distanceActionTimer = nil
                return
            end
            local d2 = vector2.distance(x, y, whichUnit:x(), whichUnit:y())
            if (d2 <= judgeDistance) then
                class.destroy(whichUnit._distanceActionTimer)
                whichUnit._distanceActionTimer = nil
                callFunc()
            end
            move = math.max(10, whichUnit:move())
            frq = math.max(0.05, d2 / move / 2)
            actTimer:period(frq)
        end)
    else
        callFunc()
    end
end

--- 当玩家选择单位
---@param key string
---@param callFunc fun(evtData:eventOnPlayerSelect)
---@return void
function player.onSelect(key, callFunc)
    event.syncRegister("player", eventKind.playerSelect, key, callFunc)
end

--- 当玩家选择单位 times 次
---@param key string
---@param times number integer
---@param callFunc fun(evtData:eventOnPlayerMultipleSelect)
---@return void
function player.onMultipleSelect(key, times, callFunc)
    event.syncRegister("player", eventKind.playerMultipleSelect .. "#" .. times, key, callFunc)
end

--- 当玩家取消选择单位
---@param key string
---@param callFunc fun(evtData:eventOnPlayerDeSelect)
---@return void
function player.onDeSelect(key, callFunc)
    event.syncRegister("player", eventKind.playerDeSelect, key, callFunc)
end

--- 当聊天时
---@param pattern string 正则匹配内容
---@param callFunc fun(evtData:eventOnPlayerChat)
---@return void
function player.onChat(pattern, callFunc)
    sync.must()
    if (nil == player._chatPattern) then
        player._chatPattern = Array()
        --注册聊天模式
        event.syncRegister("player", eventKind.playerChat, function(evtData)
            player._chatPattern:forEach(function(p, c)
                local m = string.match(evtData.chatString, p)
                if (nil ~= m) then
                    evtData.matchedString = m
                    promise(c, nil, nil, evtData)
                end
            end)
        end)
    end
    if (type(callFunc) == "function") then
        player._chatPattern:set(pattern, callFunc)
    else
        player._chatPattern:set(pattern, nil)
    end
end

--- 撤销指令
---@param pattern string 正则字符串
---@return void
function player.unCommand(pattern)
    if (type(pattern) == "string") then
        player.onChat(pattern, nil)
    end
end

--- 配置这局游戏支持的框架指令
---@param pattern string 正则字符串
---@param callFunc fun(evtData:eventOnPlayerChat)
---@return void
function player.command(pattern, callFunc)
    if (type(pattern) == "string") then
        player.onChat(pattern, callFunc)
    end
end