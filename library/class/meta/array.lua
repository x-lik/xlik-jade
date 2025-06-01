--- current class name
ArrayClass = "Array"

--- Array数据结构，常用于有序规整kv类型的遍历与取值
---@class Array:Meta
local _index = Meta(ArrayClass)

--- 数据重置
---@return void
function _index:reset()
    self._key = {}
    self._k2v = {}
end

--- 统计
--- 返回数组中元素的数目
---@return number integer
function _index:count()
    return #self._key
end

--- 返回数组中key索引的顺序；没有该key则返回-1
---@param key string
---@return number integer
function _index:index(key)
    local idx = -1
    for ki, k in ipairs(self._key) do
        if (k == key) then
            idx = ki
            break
        end
    end
    return idx
end

--- 返回数组中第一个数据的key与value
---@return any,any
function _index:first()
    if (#self._key < 1) then
        return
    end
    local k = self._key[1]
    return k, self:get(k)
end

--- 设置数组元素
---@param key string|number
---@param val any
---@return void
function _index:set(key, val)
    if (type(key) == "number") then
        if (nil == self._key[key]) then
            error("Set_NumberIndex_MustAlreadyExist")
        else
            key = self._key[key]
        end
    end
    if (type(key) ~= "string") then
        return
    end
    if (nil == val) then
        local i = self:index(key)
        if (i ~= -1) then
            table.remove(self._key, i)
        end
    else
        if (nil == self._k2v[key]) then
            self._key[#self._key + 1] = key
        end
    end
    self._k2v[key] = val
end

--- 根据key获取数据
---@param key string
---@return any
function _index:get(key)
    if (type(key) == "number") then
        if (nil == self._key[key]) then
            error("Get_Index_MustAlreadyExist")
        else
            key = self._key[key]
        end
    end
    if (type(key) ~= "string") then
        return
    end
    return self._k2v[key]
end

--- 返回数组中所有的键名
---@return string[]
function _index:keys()
    return self._key
end

--- 返回数组中所有的值
---@return any[]
function _index:values()
    local v = {}
    for _, key in ipairs(self._key) do
        v[#v + 1] = self._k2v[key]
    end
    return v
end

--- 检查指定的键名是否存在于数组中
function _index:keyExists(key)
    return nil ~= key and nil ~= self._k2v[key]
end

--- 遍历
---@param callFunc fun(key:string,val:any):void
---@return void
function _index:forEach(callFunc)
    if (type(callFunc) == "function") then
        local keys = self._key
        local i = 1
        while i <= #keys do
            local k = keys[i]
            if (nil == self._k2v[k]) then
                table.remove(self._key, i)
            else
                -- call返回false时中断遍历
                if (false == callFunc(k, self._k2v[k])) then
                    break
                end
                -- k2v为nil说明在遍历call时值被删了
                if (nil ~= self._k2v[k]) then
                    i = i + 1
                end
            end
        end
    end
end

--- 反向遍历
---@param callFunc fun(key:string,val:any):void
---@return void
function _index:backEach(callFunc)
    if (type(callFunc) == "function") then
        local keys = self._key
        local i = #keys
        while i >= 1 do
            local k = keys[i]
            if (nil ~= k) then
                if (nil == self._k2v[k]) then
                    table.remove(self._key, i)
                else
                    -- call返回false时中断遍历
                    if (false == callFunc(k, self._k2v[k])) then
                        break
                    end
                end
            end
            i = i - 1
        end
    end
end

--- 克隆一个副本
---@return Array
function _index:clone()
    local copy = Array()
    ---@param m Array
    self:forEach(function(key, m)
        if (isArray(m)) then
            copy:set(key, m:clone())
        else
            copy:set(key, m)
        end
    end)
    return copy
end

--- 合并
---@vararg Array
---@return void
function _index:merge(...)
    ---@param m Array
    for _, m in ipairs(...) do
        if (isArray(m)) then
            m:forEach(function(key, m2)
                if (isArray(m2)) then
                    self:set(key, m2:clone())
                else
                    self:set(key, m2)
                end
            end)
        end
    end
end

--- 键排序
---@return Array
function _index:sort()
    local sa = self:clone()
    table.sort(sa._key)
    return sa
end

--- 构造数组对象
---@return Array
function Array()
    return oMeta({ _key = {}, _k2v = {} }, _index)
end

--- 是否为数组
---@param arr any
---@return boolean
function isArray(arr)
    return type(arr) == "table" and arr._className == ArrayClass
end