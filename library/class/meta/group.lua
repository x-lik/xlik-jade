--- current class name
GroupClass = "Group"

--- 群数据集，常用于区域内选取对象
---@class Group:Meta
local _index = Meta(GroupClass)

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
                local ex, ey = datum.enumXY(enum, self._key)
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
--- 会尝试从options中的circle或square分析出(x,y)坐标，这种情况视为离条件区域内中心点作为判定目标
--- 也可以设定(x,y)坐标值作为判定目标而不是以条件中心作为判定目标
---@param options GroupOptions
---@param x number
---@param y number
---@return datumEnum
function _index:closest(options, x, y)
    if (type(x) ~= "number" or type(y) ~= "number") then
        if (nil ~= options.circle) then
            x = options.circle.x
            y = options.circle.y
        elseif (nil ~= options.square) then
            x = options.square.x
            y = options.square.y
        end
        if (type(x) ~= "number" or type(y) ~= "number") then
            return nil
        end
    end
    local catch = self:catch(options)
    if (#catch <= 0) then
        return nil
    end
    local closer = nil
    local closestDst = math.huge
    for _, c in ipairs(catch) do
        local cx, cy = datum.enumXY(c, self._key)
        local dst = vector2.distance(x, y, cx, cy)
        if (dst < closestDst) then
            closer = c
            closestDst = dst
        end
    end
    return closer
end

--- 构造Group对象
---@param key string
---@return Group
function Group(key)
    must(type(key) == "string", "key@string")
    local cache = class.cache(GroupClass)
    if (nil == cache[key]) then
        cache[key] = oMeta({ _key = key, _data = Array() }, _index)
    end
    return cache[key]
end

--- Group是否已实例
---@param key string
---@return boolean
function isGroup(key)
    if (type(key) ~= "string") then
        return false
    end
    return nil ~= class._cache[GroupClass] and nil ~= class._cache[GroupClass][key]
end