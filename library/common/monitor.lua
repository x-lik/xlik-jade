--- 监听器
---@alias monitorActionFunc fun(object: any):void
---@alias monitorRemoveFilter fun(object: any):boolean
---@class monitor
monitor = monitor or {}

--- 数据缓存
monitor._cache = monitor._cache or {}

--- 创建监听器
---@param key string 唯一键
---@param frq number 周期间隔(秒)，每个周期会把受监听对象回调
---@param action monitorActionFunc 监听操作
---@param ignore monitorRemoveFilter 移除监听对象的适配条件
---@return void
function monitor.create(key, frq, action, ignore)
    sync.must()
    if (nil == monitor._cache[key]) then
        monitor._cache[key] = { frq = frq, action = action, ignore = ignore, objects = Array() }
    end
    monitor.setup(key)
end

--- 销毁监听器
---@param key string 唯一键
---@return void
function monitor.destroy(key)
    sync.must()
    local cache = monitor._cache[key]
    if (nil == cache) then
        return
    end
    class.destroy(cache.objects)
    cache.objects = nil
    class.destroy(cache.timer)
    cache.timer = nil
    monitor._cache[key] = nil
end

--- 让监听器运转起来
---@param key string 唯一键
---@return void
function monitor.setup(key)
    sync.must()
    local cache = monitor._cache[key]
    if (nil == cache) then
        return
    end
    ---@type Array
    local objects = cache.objects
    if (objects:count() <= 0) then
        class.destroy(cache.timer)
        cache.timer = nil
        return
    end
    local action = cache.action
    if (nil == action) then
        return
    end
    local ignore = cache.ignore
    if (nil == cache.timer) then
        cache.timer = time.setInterval(cache.frq, function(curTimer)
            ---@type Array
            if (nil == objects or objects:count() <= 0) then
                class.destroy(curTimer)
                cache.timer = nil
                return
            end
            objects:forEach(function(id, o)
                if (nil == o or (type(ignore) == "function" and true == ignore(o))) then
                    objects:set(id, nil)
                    return
                end
                promise(action, nil, nil, o)
            end)
        end)
    end
end

--- 检查一个对象是否正在受到监听
---@param key string 唯一键
---@param obj Object 监听对象
---@return boolean
function monitor.isListening(key, obj)
    if (nil == obj) then
        return false
    end
    local cache = monitor._cache[key]
    if (nil == cache) then
        return false
    end
    return cache.objects:keyExists(obj:id())
end

--- 监听对象
---@param key string 唯一键
---@param obj Object 监听对象
---@return void
function monitor.listen(key, obj)
    sync.must()
    if (nil == obj) then
        return
    end
    local cache = monitor._cache[key]
    if (nil == cache) then
        return false
    end
    cache.objects:set(obj:id(), obj)
    monitor.setup(key)
end

--- 忽略对象
--- 由于监听器的特殊性和长效性
--- 不建议手动忽略，推荐在build时严谨地编写ignore中返回true从而自动忽略
---@protected
---@param key string 唯一键
---@param obj Object 监听对象
---@return void
function monitor.ignore(key, obj)
    sync.must()
    if (nil == obj) then
        return
    end
    local cache = monitor._cache[key]
    if (nil == cache) then
        return false
    end
    cache.objects:set(obj:id(), nil)
    monitor.setup(key)
end