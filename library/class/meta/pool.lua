--- 池数据集，常用于数据整合归类读取
---@class Pool
local _index = Meta(PoolClass)

---@protected
function _index:destruct()
    class.cache(PoolClass)[self._scope] = nil
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

--- 删除所有对象
---@return void
function _index:removeAll()
    self._data:reset()
end

--- 获取组内随机1|N个对象
--- 此方法不能超出符合捕获条件的数量极限
---@return datumEnum|datumEnum[]
function _index:rand(n)
    ---@type Array
    local data = self._data
    n = n or 1
    if (data:count() >= 1) then
        local keys = data:keys()
        local m = math.min(#keys, n)
        local k = table.rand(keys, m)
        local r = data:get(k)
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

--- 正向遍历对象组
---@param action fun(enumObj:datumEnum):void
---@return void
function _index:forEach(action)
    if (type(action) == "function") then
        ---@type Array
        local data = self._data
        data:forEach(function(_, enumObj)
            return action(enumObj)
        end)
    end
end

--- 反向遍历对象组
---@param action fun(enumObj:datumEnum):void
---@return void
function _index:backEach(action)
    if (type(action) == "function") then
        local d = self._data
        d:backEach(function(_, enumObj)
            return action(enumObj)
        end)
    end
end

--- 乱序遍历对象组
---@param action fun(enumObj:datumEnum):void
---@return void
function _index:randEach(action)
    if (type(action) == "function") then
        local d = self._data
        local c = d:count()
        if (c > 0) then
            local ks = table.rand(d:keys(), c)
            for _, k in ipairs(ks) do
                return action(d:get(k))
            end
        end
    end
end

---@param scope string
---@return Pool
function Pool(scope)
    must(type(scope) == "string", "scope@string")
    local cache = class.cache(PoolClass)
    if (nil == cache[scope]) then
        cache[scope] = oMeta({ _scope = scope, _data = Array() }, _index)
    end
    return cache[scope]
end

--- Pool是否已实例
---@param scope string
---@return boolean
function isPool(scope)
    if (type(scope) ~= "string") then
        return false
    end
    return nil ~= class._cache[PoolClass] and nil ~= class._cache[PoolClass][scope]
end