--- 数据处理，包含一些通用或专用的数据处理方法
---@class datum 数据
datum = datum or {}

--- 坐标位置集合
---@type table<string,number>
datum._position = datum._position or {}

--- 默认值
--- 当value可能为false不能简单使用or处理时可使用此方法
---@param value any 原数据
---@param defValue any 备用数据
---@return any
function datum.default(value, defValue)
    if (nil == value) then
        return defValue
    end
    return value
end

--- 比较两个数据是否相同
---@param data1 table array
---@param data2 table array
---@return boolean
function datum.equal(data1, data2)
    if (nil == data1 and nil == data2) then
        return true
    end
    if (nil == data1 or nil == data2) then
        return false
    end
    if (type(data1) ~= type(data2)) then
        return false
    end
    if (type(data1) == "table") then
        return table.equal(data1, data2)
    end
    return data1 == data2
end

--- 返回一个key<string>和function
--- 当复合参数key不存在时，key默认为default
--- 当func不存在时，为nil
---@vararg string|function
---@return string,function|nil
function datum.keyFunc(...)
    local data = { ... }
    local key = "default"
    if (type(data[1]) == "string") then
        key = data[1]
        table.remove(data, 1)
    end
    return key, table.unpack(data)
end

--- 三目值
---@param bool boolean 当有且仅有等于true时返回tVal，否则返回fVal
---@param tVal any True值
---@param fVal any False值
---@return any
function datum.ternary(bool, tVal, fVal)
    if (true == bool) then
        return tVal
    else
        return fVal
    end
end

--- 选取物返唯一key
---@alias datumEnum Unit|Item|UIKit|agileEffect|number
---@param enum datumEnum
---@return string|nil
function datum.enumKey(enum)
    if (type(enum) == "string") then
        return enum
    elseif (type(enum) == "number") then
        return tostring(enum)
    elseif (type(enum) == "table") then
        if (enum._id) then
            return enum._id
        elseif (enum._handle) then
            return tostring(enum._handle)
        end
    end
    return nil
end

--- 选取物返坐标
---@param enum any
---@param scope string|nil 指引域
---@return number,number|nil,nil
function datum.enumXY(enum, scope)
    local x, y
    if (class.inObject(enum, UnitClass, ItemClass) and false == class.isDestroy(enum)) then
        x, y = enum:x(), enum:y()
    elseif (effector.isAgile(enum)) then
        x, y = effector.x(enum), effector.y(enum)
    elseif (type(enum) == "number" and scope == "destructable") then
        x, y = J.GetDestructableX(enum), J.GetDestructableY(enum)
    end
    return x, y
end

--- 寻找未被占用坐标
---@protected
---@param x number
---@param y number
---@return number,number
function datum.findPosition(x, y)
    local nx = 0
    local ny = 0
    local d = 32
    if (nil ~= x and nil ~= y) then
        x = d * math.round(x / d)
        y = d * math.round(y / d)
        nx = x
        ny = y
        local pos = datum._position
        local ik = x .. '_' .. y
        local bic = 0
        local bor = 1
        local bi = 0
        while (pos[ik] == 1) do
            if (bi == 0) then
                bic = bic + 1
                bor = bor + 2
                nx = x + d * bic
                ny = y + d * bic
            elseif (bi < bor * 1 - 0) then
                ny = ny - d
            elseif (bi < bor * 2 - 1) then
                nx = nx - d
            elseif (bi < bor * 3 - 2) then
                ny = ny + d
            else
                nx = nx + d
            end
            bi = bi + 1
            if (bi >= (bor - 1) * 4) then
                bi = 0
            end
            ik = nx .. '_' .. ny
        end
        pos[ik] = 1
    end
    return nx, ny
end

--- 施放占用坐标
---@protected
---@return void
function datum.freePosition(x, y)
    if (nil ~= x and nil ~= y) then
        x = math.round(x)
        y = math.round(y)
        local ik = x .. '_' .. y
        datum._position[ik] = nil
    end
end