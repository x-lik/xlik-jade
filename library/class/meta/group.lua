--- 群数据集，常用于区域内选取对象
---@class Group:Meta
local _index = Meta(GroupClass)

---@protected
function _index:destruct()
    class.cache(GroupClass)[self._scope] = nil
end

--- 域数据
---@return Array
function _index:data()
    return self._data
end

--- 统计
---@return Array
function _index:count()
    return self._data:count()
end

--- 插入对象
---@param enum datumEnum
---@return void
function _index:insert(enum)
    sync.must()
    local key = datum.enumKey(enum)
    must(nil ~= key, "Invalid enum")
    if (class.is(enum) and class.isDestroy(enum)) then
        return
    end
    local d = self._data
    if (false == d:keyExists(key)) then
        d:set(key, enum)
    end
end

--- 删除对象
---@param enum datumEnum
---@return void
function _index:remove(enum)
    sync.must()
    local key = datum.enumKey(enum)
    must(nil ~= key, "Invalid enum")
    local d = self._data
    if (d:keyExists(key)) then
        d:set(key, nil)
    end
end

--- 根据条件，获取域内对象数组
--- 参数GroupOptionsCorner长度为4的number数组，对应{xMin,yMin,xMax,yMax}
---@alias GroupOptionsCircle {x:number,y:number,radius:number}
---@alias GroupOptionsSquare {x:number,y:number,width:number,height:number}
---@alias GroupOptionsCorner number[]
---@alias GroupOptions {region:Region,square:GroupOptionsSquare,circle:GroupOptionsCircle,corner:GroupOptionsCorner,limit:number,filter:fun(enum:datumEnum)}
---@param options GroupOptions
---@return datumEnum[]
function _index:catch(options)
    local res = {}
    ---@type Array
    local data = self._data
    ---@param enum datumEnum
    data:backEach(function(_, enum)
        if (type(options) == "table") then
            if (#res >= (options.limit or 100)) then
                return false
            end
            if (options.region or options.square or options.circle or options.corner) then
                local ex, ey = datum.enumXY(enum, self._scope)
                if (nil == ex or nil == ey) then
                    return
                end
                if (class.isObject(options.region, RegionClass)) then
                    if (options.region:isBorder(ex, ey)) then
                        return
                    end
                end
                if (type(options.square) == "table") then
                    if (ex > (options.square.x + options.square.width * 0.5) or
                        ex < (options.square.x - options.square.width * 0.5) or
                        ey > (options.square.y + options.square.height * 0.5) or
                        ey < (options.square.y - options.square.height * 0.5)) then
                        return
                    end
                end
                if (type(options.circle) == "table") then
                    if (options.circle.radius < vector2.distance(options.circle.x, options.circle.y, ex, ey)) then
                        return
                    end
                end
                if (type(options.corner) == "table" and #options.corner == 4) then
                    if (ex < options.corner[1] or ey < options.corner[2] or ex > options.corner[3] or ey > options.corner[4]) then
                        return
                    end
                end
            end
            if (type(options.filter) == "function") then
                if (true ~= options.filter(enum)) then
                    return
                end
            end
        end
        res[#res + 1] = enum
    end)
    return res
end

--- 遍历域对象
---@param options GroupOptions
---@param action fun(enum:datumEnum):void
---@return void
function _index:forEach(options, action)
    local catch = self:catch(options)
    if (#catch > 0) then
        for i = #catch, 1, -1 do
            action(catch[i])
        end
    end
end

--- 获取域内随机1|N个对象
--- 此方法不能超出符合捕获条件的数量极限
---@param options GroupOptions
---@param n number 默认1
---@return datumEnum|datumEnum[]
function _index:rand(options, n)
    local catch = self:catch(options)
    n = n or 1
    if (#catch >= 1) then
        local m = math.min(#catch, n)
        local r = table.rand(catch, m)
        if (n == 1) then
            return r
        elseif (m == 1) then
            return { r }
        else
            return r
        end
    else
        if (n == 1) then
            return nil
        else
            return {}
        end
    end
end

--- 获取域内离选定的(x,y)最近的对象
--- 必须设定filter里面的x,y参数,radius默认600
---@param options GroupOptions
---@return datumEnum
function _index:closest(options)
    local x, y
    if (nil ~= options.circle) then
        x = x or options.circle.x
        y = y or options.circle.y
    end
    if (nil ~= options.square) then
        x = x or options.square.x
        y = y or options.square.y
    end
    if (nil == x or nil == y) then
        return nil
    end
    local catch = self:catch(options)
    if (#catch <= 0) then
        return nil
    end
    local closer
    local closestDst = 99999
    for _, c in ipairs(catch) do
        local dst = vector2.distance(x, y, c:x(), c:y())
        if (dst < closestDst) then
            closer = c
            closestDst = dst
        end
    end
    return closer
end

---@param scope string
---@return Group
function Group(scope)
    must(type(scope) == "string", "scope@string")
    local cache = class.cache(GroupClass)
    if (nil == cache[scope]) then
        cache[scope] = oMeta({ _scope = scope, _data = Array() }, _index)
    end
    return cache[scope]
end

--- Group是否已实例
---@param scope string
---@return boolean
function isGroup(scope)
    if (type(scope) ~= "string") then
        return false
    end
    return nil ~= class._cache[GroupClass] and nil ~= class._cache[GroupClass][scope]
end