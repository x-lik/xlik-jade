--- 组队势力配置
--- 同一个队伍可视为同一种势力
---@class Team
local _index = Meta(TeamClass)

---@private
function _index:destruct()
    class.cache(TeamClass)[self._name] = nil
end

--- 获取队伍名称
---@return string
function _index:name()
    return self._name
end

--- 配置队伍成员玩家（只控制索引1-12）
---@param indexes number[]
---@return void
function _index:members(indexes)
    sync.must()
    if (type(indexes) ~= "table") then
        return
    end
    local pls = {}
    local color, name
    if (self._colorSync) then
        color = self._color
    end
    if (self._nameSync) then
        name = self._name
    end
    for _, m in ipairs(indexes) do
        if (type(m) == "number") then
            if (false == table.includes(pls, m)) then
                table.insert(pls, m)
                if (nil ~= color) then
                    Player(m):teamColor(color)
                end
                if (nil ~= name) then
                    Player(m):name(name)
                end
            end
        end
    end
    self._members = pls
    -- 联盟
    if (#pls > 0) then
        for _, i in ipairs(pls) do
            for _, j in ipairs(pls) do
                if (i ~= j) then
                    alliance.ally(Player(i), Player(j), true)
                    alliance.vision(Player(i), Player(j), true)
                    alliance.control(Player(i), Player(j), false)
                    alliance.fullControl(Player(i), Player(j), false)
                end
            end
        end
    end
end

--- 在设定队伍中分配并返回一个合适的玩家索引[1-16]
--- 索引会自动分配给队伍内的某个玩家
--- 一般用于Unit生成通用共同敌人
--- 返回0说明分配失败
---@return number
function _index:index()
    sync.must()
    local idx = 0
    local ms = self._members
    if (#ms > 0) then
        local counter = self._counter
        local c = 101
        for _, m in ipairs(ms) do
            if (nil == counter[m]) then
                counter[m] = 0
                idx = m
                break
            end
            if (counter[m] < c) then
                idx = m
                c = counter[m]
            end
        end
        counter[idx] = counter[idx] + 1
        if (counter[idx] >= 100) then
            for _, m in ipairs(ms) do
                counter[m] = 0
            end
        end
    end
    return idx
end

--- 判定一个玩家或单位是否属于这个队伍
---@param whichOne Player|Unit
---@return boolean
function _index:is(whichOne)
    if (class.isObject(whichOne, PlayerClass)) then
        return table.includes(self._members, whichOne:index())
    elseif (class.isObject(whichOne, UnitClass)) then
        return table.includes(self._members, whichOne:owner():index())
    end
    return false
end

--- 队伍势力
---@param name string
---@param color number 队伍颜色 0-12，可参考 PLAYER_COLOR_* 的颜色对应值
---@param nameSync boolean 是否队名同步，设为true后，成员的名称会同步跟随队伍的名称（一般用于通用共同敌人）
---@param colorSync boolean 是否队色同步，设为true后，成员的颜色以及他单位的颜色都会同步跟随队伍的颜色（一般用于通用共同敌人）
---@return Team
function Team(name, color, nameSync, colorSync)
    sync.must()
    local cache = class.cache(TeamClass)
    if (nil == cache[name]) then
        cache[name] = oMeta({
            _name = name,
            _color = color,
            _nameSync = nameSync,
            _colorSync = colorSync,
            _members = {},
            _counter = {},
        }, _index)
    end
    return cache[name]
end