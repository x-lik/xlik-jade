--- AI，自定义设定行为定义
---@class AI
local _index = Meta(AIClass, {
    _1st = "idle",
})

---@protected
function _index:destruct()
    class.cache(AIClass)[self._key] = nil
end

--- AI被启用后会执行设置的第一个行为的key
--- 默认行为为idle，如果第一个行为未定义执行函数，link将提示报错
---@param key string 默认idle
---@return self
function _index:behavior1st(key)
    if (type(self._1st) == "string") then
        self._1st = key
    end
    return self
end

--- 定义AI的行为
--- 可以在定义函数方法的执行中使用action方法执行下一个行为
---@param key string
---@param call fun(this:AI,linkUnit:Unit):void
---@return self
function _index:behavior(key, call)
    must(type(key) == "string", "key@string")
    must(type(call) == "function", "call@function")
    self._behavior[key] = call
    return self
end

--- 关联单位时执行
---@param call fun(linkUnit:Unit):void
---@return self
function _index:onLink(call)
    self._onLink = call
    return self
end

--- 取消关联单位时执行
---@param call fun(unlinkUnit:Unit):void
---@return self
function _index:onUnlink(call)
    self._onUnlink = call
    return self
end

--- 执行某个的行为
--- 若行为不存在，返回第一个行为
---@param key string
---@param linkUnit Unit
---@return void
function _index:action(key, linkUnit)
    if (type(key) == "string" and class.isObject(linkUnit, UnitClass)) then
        local b = self._behavior[key]
        if (nil == b) then
            b = self._behavior[self._1st]
        end
        ---@type Array
        if (nil ~= self._linkers) then
            local id = linkUnit:id()
            if (self._linkers:keyExists(id)) then
                b(self, linkUnit)
            end
        end
    end
end

--- 关联单位
--- 单位被关联后等于启用了此AI
--- 关联会自动执行设置的第一个行为
---@param linkUnit Unit
---@return void
function _index:link(linkUnit)
    sync.must()
    local b1st = self._behavior[self._1st]
    must(nil ~= b1st, "behaviour list undefined")
    must(class.isObject(linkUnit, UnitClass), "linkUnit@Unit")
    local id = linkUnit:id()
    if (false == self._linkers:keyExists(id)) then
        self._linkers:set(id, linkUnit)
        if (type(self._onLink) == "function") then
            self._onLink(linkUnit)
        end
        b1st(self, linkUnit)
    end
end

--- 断联单位
--- 单位被关联后等于关闭了此AI
---@param linkUnit Unit
---@return void
function _index:unlink(linkUnit)
    sync.must()
    must(class.isObject(linkUnit, UnitClass), "linkUnit@Unit")
    ---@type Array
    if (nil == self._linkers) then
        return
    end
    local id = linkUnit:id()
    if (self._linkers:keyExists(id)) then
        self._linkers:set(id, nil)
        if (type(self._onUnlink) == "function") then
            self._onUnlink(linkUnit)
        end
    end
end

---@param key string 唯一key
---@return AI
function AI(key)
    sync.must()
    must(type(key) == "string", "key@string")
    local cache = class.cache(AIClass)
    if (nil == cache[key]) then
        cache[key] = oMeta({ _key = key, _behavior = {}, _linkers = Array() }, _index)
    end
    return cache[key]
end

--- AI是否已实例
---@param key string 唯一key
---@return boolean
function isAI(key)
    if (type(key) ~= "string") then
        return false
    end
    return nil ~= class._cache[AIClass] and nil ~= class._cache[AIClass][key]
end