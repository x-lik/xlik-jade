--- Player玩家
---@class Player:Vast
local _index = Vast(PlayerClass, {
    ---@private
    _protect = true,
    ---@type number
    _operand = 0,
    ---@type number APM
    _apm = 0,
    ---@type string 称呼
    _prestige = '-',
    ---@type number 财产获得率
    _worthRatio = 100,
    ---@type number 回收折价率
    _recoveryRatio = 50,
    ---@type table 拾取模式
    _pickMode = player.pickMode.itemWarehouse,
})

---@protected
function _index:destruct()
    J.RemovePlayer(self._handle, PLAYER_GAME_RESULT_DEFEAT)
    J.HandleUnRef(self._handle)
    class.handle(self, nil)
end

--- 获取handle
---@return number
function _index:handle()
    return self._handle
end

--- 获取索引[1-16]
---@return number
function _index:index()
    return self._index
end

--- 是否中立玩家
---@return boolean
function _index:isNeutral()
    return self._index >= 13
end

--- 是否电脑(如果位置为电脑玩家或无玩家，则为true)【常用来判断电脑AI是否开启】
---@return boolean
function _index:isComputer()
    return self._isComputer
end

--- 是否玩家位置(如果位置为真实玩家或为空，则为true；而如果选择了电脑玩家补充，则为false)【常用来判断该是否玩家可填补位置】
---@return boolean
function _index:isUser()
    return self._isUser
end

--- 是否正在游戏
---@return boolean
function _index:isPlaying()
    return self._status == player.status.playing
end

--- 是否正在受伤
---@return boolean
function _index:isHurting()
    return superposition.is(self, "hurt")
end

--- 是否正在造成伤害
---@return boolean
function _index:isDamaging()
    return superposition.is(self, "damage")
end

--- 是否有屏幕贴图正在展示
---@return boolean
function _index:isMarking()
    return superposition.is(self, "mark")
end

--- 单位是否在某玩家真实视野内
---@param whichObj Unit|Item
---@return boolean
function _index:isDetectedUnit(whichObj)
    if (class.isObject(whichObj, UnitClass)) then
        return true == J.IsUnitDetected(whichObj:handle(), self:handle())
    end
    return false
end

--- 单位是否对某玩家不可见
---@param whichUnit Unit
---@return boolean
function _index:isInvisibleUnit(whichUnit)
    if (class.isObject(whichUnit, UnitClass)) then
        return true == J.IsUnitInvisible(whichUnit:handle(), self:handle())
    end
    return true
end

--- 单位是否对某玩家可见
---@param whichUnit Unit
---@return boolean
function _index:isVisibleUnit(whichUnit)
    if (class.isObject(whichUnit, UnitClass)) then
        return true == J.IsUnitVisible(whichUnit:handle(), self:handle())
    end
    return false
end

--- 坐标是否对某玩家可见
---@param x number
---@param y number
---@return boolean
function _index:isVisible(x, y)
    return true == J.IsVisibleToPlayer(x, y, self:handle())
end

--- 坐标是否对某玩家存在迷雾
---@param x number
---@param y number
---@return boolean
function _index:isFogged(x, y)
    return true == J.IsFoggedToPlayer(x, y, self:handle())
end

--- 坐标是否对某玩家存在迷雾
---@param x number
---@param y number
---@return boolean
function _index:isMasked(x, y)
    return true == J.IsMaskedToPlayer(x, y, self:handle())
end

--- 名称
---@param n string
---@return string|self
function _index:name(n)
    return self:modify("name", n)
end

--- 称号
---@param variety string|nil
---@return self|string
function _index:prestige(variety)
    return self:modify("prestige", variety)
end

--- 仓库栏
---@return WarehouseSlot
function _index:warehouseSlot()
    return self._warehouseSlot
end

--- APM
---@return number
function _index:apm()
    return math.floor(self._apm)
end

--- 魔兽原生队伍索引，与Team对象无关
--- 存在负数的索引
---@return number
function _index:team()
    return self._team
end

--- 队伍颜色
--- 使用玩家索引决定颜色值,单位不会自动同步需要请手动修改
---@param color number 范围[1-12]
---@return any|self
function _index:teamColor(color)
    return self:modify("teamColor", color)
end

--- 状态值
---@see player#status
---@param variety table|nil
---@return self|table
function _index:status(variety)
    return self:modify("status", variety)
end

--- 种族
---@param whichRace string 修改种族
---@return string|self
function _index:race(whichRace)
    return self:modify("race", whichRace)
end

--- 玩家的捡取模式
--- 默认捡去物品栏，满了转移至仓库
---@see player#pickMode
---@param variety table|nil
---@return self|table
function _index:pickMode(variety)
    return self:modify("pickMode", variety)
end

--- 资源管理
--- 当operator、data同时存在时，会根据当前玩家资源计算
--- 当operator为=符号时，设定价值，当operator为+-*/时，会进行运算
---@param operator string|nil|"="|"+"|"-"|"*"|"/"
---@param data table|number 计算变动值
---@return self|table
function _index:worth(operator, data)
    local w -- 计算后价值，无计算则此值为nil，走get取值
    if (type(operator) == "string" and (type(data) == "table" or type(data) == "number")) then
        if (operator == "=") then
            w = worth.l2u(worth.u2l(data))
        else
            local ratio = self._worthRatio
            if (ratio ~= 100 and operator == "+") then
                local r = math.max(0, ratio * 0.01)
                data = worth.cale(data, '*', r)
            end
            w = worth.cale(self._worth, operator, data)
        end
    end
    return self:modify("worth", w)
end

--- 资源获得率[%]
--- 默认100
--- 当使用worth方法且operator为+时有作用
---@param variety number|nil
---@return self|number
function _index:worthRatio(variety)
    return self:modify("worthRatio", variety)
end

--- 回收折价率[%]
---@param variety number|nil
---@return self|number
function _index:recoveryRatio(variety)
    return self:modify("recoveryRatio", variety)
end

--- 选择一个单位
---@return Unit|Item|nil
function _index:select(targetUnit)
    self._selection = nil
    if (class.isObject(targetUnit, UnitClass)) then
        async.call(self, function()
            J.ClearSelection()
            J.SelectUnit(targetUnit:handle(), true)
        end)
    end
end

--- 最后选中单位
---@return Unit|Item|nil
function _index:selection()
    return self._selection
end

--- 令玩家退出
---@param reason string 原因
function _index:quit(reason)
    reason = reason or "已被系统判定出局"
    echo(self:name() .. reason .. "，退出了游戏", nil, 30)
    if (self:isUser()) then
        Dialog(reason, { { value = "Q", label = J.GetLocalizedString("GAMEOVER_QUIT_MISSION") } }, function(evtData)
            async.call(evtData.triggerPlayer, function()
                J.EndGame(true)
            end)
        end):display(self)
    end
end

---@param index number integer
---@return Player
function Player(index)
    index = math.floor(index)
    must(type(index) == "number" and index > 0 and index <= BJ_MAX_PLAYER_SLOTS, "index@integer")
    local cache = class.cache(PlayerClass)
    if (nil == cache[index]) then
        ---@type Player 玩家索引[1-16]
        local o = oVast({ _index = index, _teamColor = index }, _index)
        local h = J.Player(index - 1)
        J.HandleRef(h)
        class.handle(o, h)
        o._isUser = (J.GetPlayerController(h) == MAP_CONTROL_USER)
        o._isComputer = (J.GetPlayerController(h) == MAP_CONTROL_COMPUTER or J.GetPlayerSlotState(h) ~= PLAYER_SLOT_STATE_PLAYING)
        o._name = J.GetPlayerName(h)
        o._team = J.GetPlayerTeam(h)
        local r = J.GetPlayerRace(h)
        if (r == RACE_UNDEAD or r == RACE_PREF_UNDEAD or r == RACE_DEMON or r == RACE_PREF_DEMON) then
            o._race = RACE_UNDEAD_NAME
        elseif (r == RACE_NIGHTELF or r == RACE_PREF_NIGHTELF) then
            o._race = RACE_NIGHTELF_NAME
        elseif (r == RACE_ORC or r == RACE_PREF_ORC) then
            o._race = RACE_ORC_NAME
        else
            o._race = RACE_HUMAN_NAME
        end
        game.skin = o._race
        local pss = J.GetPlayerSlotState(h)
        if (pss == PLAYER_SLOT_STATE_EMPTY) then
            o._status = player.status.empty
        elseif (pss == PLAYER_SLOT_STATE_PLAYING) then
            o._status = player.status.playing
        elseif (pss == PLAYER_SLOT_STATE_LEFT) then
            o._status = player.status.leave
        end
        J.SetPlayerHandicapXP(h, 0) -- 经验置0
        o._handle = h
        o._worth = {}
        WarehouseSlot(o) -- 生成一个玩家仓库
        -- evt
        event.condition(player._evtDead, function(tgr)
            J.TriggerRegisterPlayerUnitEvent(tgr, h, EVENT_PLAYER_UNIT_DEATH, nil)
        end)
        event.condition(player._evtAttacked, function(tgr)
            J.TriggerRegisterPlayerUnitEvent(tgr, h, EVENT_PLAYER_UNIT_ATTACKED, nil)
        end)
        event.condition(player._evtOrder, function(tgr)
            J.TriggerRegisterPlayerUnitEvent(tgr, h, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, nil)
            J.TriggerRegisterPlayerUnitEvent(tgr, h, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, nil)
            J.TriggerRegisterPlayerUnitEvent(tgr, h, EVENT_PLAYER_UNIT_ISSUED_ORDER, nil)
        end)
        if (true ~= o._isComputer) then
            event.condition(player._evtLeave, function(tgr)
                J.TriggerRegisterPlayerEvent(tgr, h, EVENT_PLAYER_LEAVE)
            end)
            event.condition(player._evtEsc, function(tgr)
                J.TriggerRegisterPlayerEvent(tgr, h, EVENT_PLAYER_END_CINEMATIC)
            end)
            event.condition(player._evtChat, function(tgr)
                J.TriggerRegisterPlayerChatEvent(tgr, h, "", false)
            end)
            event.condition(player._evtSelect, function(tgr)
                J.TriggerRegisterPlayerUnitEvent(tgr, h, EVENT_PLAYER_UNIT_SELECTED, nil)
            end)
        end
        cache[index] = o
    end
    return cache[index]
end

--- 最上位玩家
---@return Player
function Player1st()
    local cache = class.cache(PlayerClass)
    local i = 1
    for j = 1, BJ_MAX_PLAYERS do
        if (cache[j]:isPlaying() and cache[j]:isUser()) then
            i = j
            break
        end
    end
    return cache[i]
end

--- 本地玩家
---@return Player
function PlayerLocal()
    local cache = class.cache(PlayerClass)
    return cache[player.localIndex]
end

--- 玩家遍历
---@param call fun(enumPlayer:Player)
---@return void
function PlayersForeach(call)
    local cache = class.cache(PlayerClass)
    for i = 1, BJ_MAX_PLAYERS do
        local p = cache[i]
        if (p:isPlaying() and p:isUser()) then
            call(p, i)
        end
    end
end