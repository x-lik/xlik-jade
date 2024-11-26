--- 格数据集，常用于区域内选取对象
--- 非常适用于不移动的对象。若对象移动，则需要及时刷新位置信息
---@class Grid:Meta
local _index = Meta(GridClass, {
    ---@type number 计数
    _count = 0,
    ---@type number 分格大小
    _size = 256,
})

---@protected
function _index:destruct()
    class.cache(GridClass)[self._scope] = nil
end

--- 设置分格大小
--- 一般只用于Grid初始化时
--- 只有数据集内没有对象时能顺利修改
---@param d number 分格大小，默认256
---@return void
function _index:size(d)
    if (self._count == 0) then
        self._size = d
    end
end

--- 统计
---@return number
function _index:count()
    return self._count
end

--- 根据坐标找出数据集
---@protected
---@param x number
---@param y number
---@return Array
function _index:xy2data(x, y)
    local mx, my = math.boundary(x / self._size), math.boundary(y / self._size)
    local k = mx .. '_' .. my
    if (nil == self._data[k]) then
        self._data[k] = Array()
    end
    return self._data[k]
end

--- 插入对象
---@param enum datumEnum
---@return void
function _index:insert(enum)
    sync.must()
    local key = datum.enumKey(enum)
    must(nil ~= key, "Invalid enum")
    local scope = self._scope
    local x, y = datum.enumXY(enum, scope)
    if (nil == x or nil == y) then
        return
    end
    local d = self:xy2data(x, y)
    if (false == d:keyExists(key)) then
        setmetatable({}, { __mode = "v" })
        d:set(key, enum)
        self._count = self._count + 1
        if (class.is(enum)) then
            if (nil == enum._grid) then
                enum._grid = setmetatable({}, { __mode = "v" })
            end
            enum._grid[self._id] = d
        end
    end
end

--- 更新对象
---@param enum datumEnum
---@return void
function _index:update(enum)
    sync.must()
    local key = datum.enumKey(enum)
    must(nil ~= key, "Invalid enum")
    local scope = self._scope
    if (class.is(enum)) then
        if (nil ~= enum._grid and nil ~= enum._grid[self._id]) then
            enum._grid[self._id]:set(key, nil)
            enum._grid[self._id] = nil
        end
    end
    local x, y = datum.enumXY(enum, scope)
    if (nil == x or nil == y) then
        return
    end
    local d = self:xy2data(x, y)
    if (false == d:keyExists(key)) then
        d:set(key, enum)
        if (class.is(enum)) then
            enum._grid[self._id] = d
        end
    end
end

--- 删除对象
---@param enum datumEnum
---@return void
function _index:remove(enum)
    sync.must()
    local key = datum.enumKey(enum)
    must(nil ~= key, "Invalid enum")
    local scope = self._scope
    local x, y = datum.enumXY(enum, scope)
    if (nil == x or nil == y) then
        return
    end
    local d = self:xy2data(x, y)
    if (d:keyExists(key)) then
        d:set(key, nil)
        self._count = self._count - 1
        if (class.is(enum)) then
            if (nil ~= enum._grid and nil ~= enum._grid[self._id]) then
                enum._grid[self._id] = nil
            end
        end
    end
end

--- 根据条件，获取格内对象数组
--- 参数GridOptionsCorner长度为4的number数组，对应{xMin,yMin,xMax,yMax}
---@alias GridOptionsCircle {x:number,y:number,radius:number}
---@alias GridOptionsSquare {x:number,y:number,width:number,height:number}
---@alias GridOptionsCorner number[]
---@alias GridOptions {region:Region,square:GridOptionsSquare,circle:GridOptionsCircle,corner:GridOptionsCorner,limit:number,filter:fun(enum:datumEnum)}
---@param options GridOptions
---@return datumEnum[]
function _index:catch(options)
    local res = {}
    local scope = self._scope
    if (self._count > 0) then
        local xMin, yMin, xMax, yMax = RegionPlayable:xMin(), RegionPlayable:yMin(), RegionPlayable:xMax(), RegionPlayable:yMax()
        if (class.isObject(options.region, RegionClass)) then
            xMin = math.max(xMin, options.region:xMin())
            yMin = math.max(yMin, options.region:yMin())
            xMax = math.min(xMax, options.region:xMax())
            yMax = math.min(yMax, options.region:yMax())
        end
        if (type(options.square) == "table") then
            xMin = math.max(xMin, options.square.x - options.square.width * 0.5)
            yMin = math.max(yMin, options.square.y - options.square.height * 0.5)
            xMax = math.min(xMax, options.square.x + options.square.width * 0.5)
            yMax = math.min(yMax, options.square.y + options.square.height * 0.5)
        end
        if (type(options.circle) == "table") then
            xMin = math.max(xMin, options.circle.x - options.circle.radius)
            yMin = math.max(yMin, options.circle.y - options.circle.radius)
            xMax = math.min(xMax, options.circle.x + options.circle.radius)
            yMax = math.min(yMax, options.circle.y + options.circle.radius)
        end
        if (type(options.corner) == "table" and #options.corner == 4) then
            xMin = math.max(xMin, options.corner[1])
            yMin = math.max(yMin, options.corner[2])
            xMax = math.min(xMax, options.corner[3])
            yMax = math.min(yMax, options.corner[4])
        end
        local limit = options.limit or 100
        local siz = self._size
        local mx, my = math.boundary((xMax + xMin) / 2 / siz), math.boundary((yMax + yMin) / 2 / siz)
        local bx, by = math.ceil((xMax - xMin) / 2 / siz), math.ceil((yMax - yMin) / 2 / siz)
        local md = math.max(0, bx, by)
        local left, right, bottom, top = mx - bx, mx + bx, my - by, my + by
        local _find = function(x, y)
            if (x < left or x > right or y < bottom or y > top) then
                return
            end
            local ds = self._data[x .. '_' .. y]
            if (isArray(ds) and ds:count() > 0) then
                ---@param enum datumEnum
                ds:forEach(function(_, enum)
                    if (type(options) == "table") then
                        if (#res >= limit) then
                            return false
                        end
                        if (options.region or options.square or options.circle or options.corner) then
                            local ex, ey = datum.enumXY(enum, scope)
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
            end
        end
        local _do
        _do = function(d)
            if (d > md or #res >= limit) then
                return
            end
            if (d == 0) then
                _find(mx, my)
                _do(1)
                return
            end
            local t, r, b, l = my + d, mx + d, my - d, mx - d
            local x, y, dt = l, b, 1
            while (#res < limit) do
                _find(x, y)
                if (dt == 1) then
                    if (y >= t) then
                        dt = 2
                        x = x + 1
                    else
                        y = y + 1
                    end
                elseif (dt == 2) then
                    if (x >= r) then
                        dt = 3
                        y = y - 1
                    else
                        x = x + 1
                    end
                elseif (dt == 3) then
                    if (y <= b) then
                        dt = 4
                        x = x - 1
                    else
                        y = y - 1
                    end
                elseif (dt == 4) then
                    if (x > l + 1) then
                        x = x - 1
                    else
                        _do(d + 1)
                        break
                    end
                end
            end
        end
        _do(0)
    end
    return res
end

--- 遍历域对象
---@param options GridOptions
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
---@param options GridOptions
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
---@param options GridOptions
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
        local cx, cy = datum.enumXY(c, self._scope)
        local dst = vector2.distance(x, y, cx, cy)
        if (dst < closestDst) then
            closer = c
            closestDst = dst
        end
    end
    return closer
end

---@param scope string
---@return Grid
function Grid(scope)
    must(type(scope) == "string", "scope@string")
    local cache = class.cache(GridClass)
    if (nil == cache[scope]) then
        ---@type Grid
        local o = oMeta({ _scope = scope, _data = {} }, _index)
        -- ID
        class.id(o, false)
        cache[scope] = o
    end
    return cache[scope]
end

--- Grid是否已实例
---@param scope string
---@return boolean
function isGrid(scope)
    if (type(scope) ~= "string") then
        return false
    end
    return nil ~= class._cache[GridClass] and nil ~= class._cache[GridClass][scope]
end