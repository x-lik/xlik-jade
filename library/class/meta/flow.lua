--- 流执行，业务片段顺序执行定义
---@class Flow
local _index = Meta(FlowClass)

---@protected
function _index:destruct()
    class.cache(FlowClass)[self._key] = nil
end

--- 设置伤害过程中止条件
---@param func fun(data:table):boolean
---@return void
function _index:abort(func)
    sync.must()
    if (type(func) == "function") then
        self._abort = func
    end
end

--- 设置伤害过程的具体顺序执行
--- 当前Flow对象内先设置的flux执行函数在run时也会先执行
---@param key string
---@param func fun(data:table):void
---@return void
function _index:flux(key, func)
    sync.must()
    self._actions:set(key, func)
end

--- 伤害过程执行
function _index:run(data)
    sync.must()
    local actions = self._actions
    if (actions:count() > 0) then
        data = data or {}
        local abort = self._abort
        actions:forEach(function(_, func)
            promise(func, nil, nil, data)
            if (type(abort) == "function") then
                return not abort(data)
            end
        end)
    end
end

---@param key string 唯一key
---@return Flow
function Flow(key)
    sync.must()
    must(type(key) == "string", "key@string")
    local cache = class.cache(FlowClass)
    if (nil == cache[key]) then
        cache[key] = oMeta({ _key = key, _actions = Array() }, _index)
    end
    return cache[key]
end

--- Flow是否已实例
---@param key string 唯一key
---@return boolean
function isFlow(key)
    if (type(key) ~= "string") then
        return false
    end
    return nil ~= class._cache[FlowClass] and nil ~= class._cache[FlowClass][key]
end