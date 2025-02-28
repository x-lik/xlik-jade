--- 类
--- 请勿覆盖class关键字，保留self键名：_key, _type, _id, _className, __reality, __indexes等
---@alias Object {_type:string,_className:string}
---@class class
class = class or {}

---@private
class._ids = class._ids or {}
---@private
class._i2o = class._i2o or setmetatable({}, { __mode = "v" })
---@private
class._h2o = class._h2o or {}
---@private
class._odg = class._odg or setmetatable({}, { __mode = "v" })
---@private
class._cache = class._cache or {}
---@private
class._extends = class._extends or {}

--- 调试用
---@protected
---@return { Meta:table, UI:table, Vast:table }
function class.debug(obj)
    if (LK_DEBUG) then
        if (nil == obj) then
            async.must()
            local a = { Meta = {}, UI = {}, Vast = {} }
            for _, v in pairs(class._odg) do
                if (false ~= v._type) then
                    local at = a[v._type]
                    if (at) then
                        if (nil == at[v._className]) then
                            at[v._className] = 0
                        end
                        at[v._className] = at[v._className] + 1
                    end
                end
            end
            return a
        elseif (type(obj) == "table" and nil ~= obj._className) then
            table.insert(class._odg, obj)
        end
    end
end

--- 调试用
---@protected
---@param key string
---@return table
function class.cache(key)
    if (nil == class._cache[key]) then
        sync.must()
        class._cache[key] = {}
    end
    return class._cache[key]
end

--- 继承寄存
---@protected
---@param key string
---@return table
function class.extends(key, set)
    sync.must()
    if (false == set) then
        class._extends[key] = nil
        return
    else
        if (nil == class._extends[key]) then
            class._extends[key] = {}
        end
        if (nil ~= set) then
            table.insert(class._extends[key], set)
        end
        return class._extends[key]
    end
end

--- 实例化ID
---@param obj Object
---@param isBind boolean 是否绑定数据，绑定后可使用i2o获取对象
---@return void
function class.id(obj, isBind)
    local key = obj._className
    if (nil == class._ids[key]) then
        class._ids[key] = 0
    end
    class._ids[key] = class._ids[key] + 1
    local id = string.format('%s:%s:%s', key, time._inc or 0, class._ids[key])
    obj._id = id
    if (true == isBind) then
        class._i2o[id] = obj
    end
end

---@param id string
---@return Object|nil
function class.i2o(id)
    if (nil == id) then
        return nil
    end
    return class._i2o[id]
end

--- 分析实例handle进行绑定
--- 使用此方法处理对象的handle时，可使用h2o获取对象
---@param obj Object
---@param handle number|nil 当为nil时，清除数据并解绑
---@return void
function class.handle(obj, handle)
    must(type(handle) == "number" or nil == handle, "handle@number|nil")
    if (obj._handle) then
        class._h2o[obj._handle] = nil
        obj._handle = nil
    end
    if (nil ~= handle) then
        obj._handle = handle
        class._h2o[obj._handle] = obj
    end
end

---@param handle number
---@return Object|nil
function class.h2o(handle)
    if (nil == handle) then
        return nil
    end
    return class._h2o[handle]
end

---@param handle number
---@return Player|nil
function class.h2p(handle)
    return class.h2o(handle)
end

---@param handle number
---@return Unit|nil
function class.h2u(handle)
    return class.h2o(handle)
end

---@param handle number
---@return Item|nil
function class.h2i(handle)
    return class.h2o(handle)
end

--- 是否类对象
---@param obj Object
---@return boolean
function class.is(obj)
    return type(obj) == "table" and type(obj._className) == "string"
end

--- 是否特定类别的类对象
---@param obj Object
---@param classType string 对象类别名，如 'Meta'|'UI'|'Vast'
---@return boolean
function class.isType(obj, classType)
    return class.is(obj) and obj._type == classType
end

--- 是否已实例化的数据对象
---@param obj Object
---@return boolean
function class.isReality(obj)
    local mt = getmetatable(obj)
    return type(mt) == "table" and true == mt.__reality
end

--- 是否特定类型的实例化对象
---@param obj Object
---@param name string 对象类型名，如 UnitClass
---@return boolean
function class.isObject(obj, name)
    if (class.isDestroy(obj)) then
        return false
    end
    local cache = class.cache(obj._type)
    if (nil == cache[name]) then
        return false
    end
    return obj._className == name
end

--- 是否某些特定类型的实例化对象
---@param obj Object
---@vararg string
---@return boolean
function class.inObject(obj, ...)
    local r = false
    for _, v in ipairs({ ... }) do
        if (class.isObject(obj, v)) then
            r = true
            break
        end
    end
    return r
end

--- super 父类访问
---@alias Class Vast|UI
---@param idx Class
---@return Class|nil
function class.super(idx)
    local mt = getmetatable(idx)
    if (type(mt) == "table" and mt.__index) then
        return mt.__index
    end
end

--- 判定对象是否是某个类的实例
---@param obj Object
---@param name string
---@return boolean
function class.instanceof(obj, name)
    if (false == class.is(obj)) then
        return false
    end
    if (class.isDestroy(obj)) then
        return false
    end
    local result = false
    local is = nil
    is = function(o)
        while (nil ~= o and false == result) do
            if (o._className == name) then
                result = true
                break
            end
            local mt = getmetatable(o)
            if (type(mt) == "table") then
                if (mt.__indexes) then
                    for _, es in ipairs(mt.__indexes) do
                        is(es)
                        if (true == result) then
                            break
                        end
                    end
                    break
                elseif (mt.__index) then
                    o = mt.__index
                else
                    break
                end
            else
                break
            end
        end
    end
    is(obj)
    return result
end

--- 类层链
---@param obj Object
---@return string[]
function class.hierarchy(obj)
    local chain = {}
    if (type(obj) ~= "table" or class.isDestroy(obj)) then
        return chain
    end
    local link = nil
    link = function(o)
        while (nil ~= o) do
            local mt = getmetatable(o)
            if (type(mt) == "table") then
                if (mt.__indexes) then
                    for _, es in ipairs(mt.__indexes) do
                        if (class.isReality(es)) then
                            link(es)
                        else
                            chain[#chain + 1] = es._className
                            link(es)
                        end
                    end
                    break
                elseif (mt.__index) then
                    chain[#chain + 1] = mt.__index._className
                    o = mt.__index
                else
                    break
                end
            else
                break
            end
        end
    end
    link(obj)
    return chain
end

--- 类层链串
---@param obj Object
---@return string
function class.hierarchyString(obj)
    return table.concat(class.hierarchy(obj), '->')
end

--- 判定实例化对象是否已销毁
---@param obj Meta|Vast|UI
---@return boolean
function class.isDestroy(obj)
    if (type(obj) ~= "table") then
        return true
    end
    return type(obj._type) ~= "string"
end

--- 销毁实例化对象
---@param obj Meta|Vast|UI
---@return void
function class.destroy(obj)
    if (class.isDestroy(obj)) then
        return
    end
    if (true == obj._protect) then
        print(obj._id .. "IsProtecting")
        return
    end
    if (nil ~= obj._id) then
        class._i2o[obj._id] = nil
    end
    local objType = nil
    if (obj._type == "Meta") then
        objType = Meta(obj._className)
    elseif (obj._type == "Vast") then
        objType = Vast(obj._className)
    elseif (obj._type == "UI") then
        objType = UI(obj._className)
    end
    if (nil == objType) then
        return
    end
    do
        local destruct = nil
        destruct = function(c)
            if rawget(c, "destruct") then
                c.destruct(obj)
            end
            local super = getmetatable(c)
            if type(super) == "table" then
                if super.__indexes then
                    for i = 1, #super.__indexes, 1 do
                        destruct(super.__indexes[i])
                    end
                elseif super.__index then
                    destruct(super.__index)
                end
            end
        end
        destruct(objType)
    end
    local cc = class._cache[obj._className]
    if (cc and obj._key and cc[obj._key]) then
        cc[obj._key] = nil
    end
    obj._type = false
    obj = nil
end