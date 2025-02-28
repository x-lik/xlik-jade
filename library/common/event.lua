--- 对象事件，管理事件的注册及触发
--- 事件分为3种：
--- 1. 原生型注入事件 condition
--- 2. 自定义同步事件 sync
--- 3. 自定义异步事件 async
event = event or {}

---@private
event._condition = event._condition or {}
---@private
event._sync = event._sync or {}
---@private
event._async = event._async or {}

--- 切换事件数据源
---@private
---@param source 'sync'|'async'|string 数据源
---@param symbol string|table 标识物
---@return table|nil
function event.source(source, symbol)
    must(type(source) == "string", "source@string")
    must(type(symbol) == "string" or type(symbol) == "table", "symbol@string|table")
    local src = nil
    if (source == "sync") then
        -- 同步事件时
        -- 必须处在同步环境
        sync.must()
        if (type(symbol) == "string") then
            if (nil == event._sync[symbol]) then
                event._sync[symbol] = {}
            end
            src = event._sync[symbol]
        else
            if (nil == symbol._eventSync) then
                symbol._eventSync = {}
            end
            src = symbol._eventSync
        end
    elseif (source == "async") then
        -- 异步事件时
        -- 允许处在同步环境或异步环境
        if (type(symbol) == "string") then
            if (nil == event._async[symbol]) then
                event._async[symbol] = {}
            end
            src = event._async[symbol]
        else
            if (nil == symbol._eventAsync) then
                symbol._eventAsync = {}
            end
            src = symbol._eventAsync
        end
    end
    return src
end

--- 设置事件数据
---@param source 'sync'|'async'|string 数据源
---@param symbol string|table 标识物
---@param evtKind string 事件类型
---@param key string|nil 特定键值判断
---@param callFunc function|nil 特定键值判断，为空时清除数据
---@return void
function event.set(source, symbol, evtKind, key, callFunc)
    if (type(evtKind) ~= "string" or type(key) ~= "string") then
        return
    end
    local data = event.source(source, symbol)
    if (nil == data) then
        return
    end
    if (nil == data[evtKind]) then
        data[evtKind] = Array()
    end
    data[evtKind]:set(key, callFunc)
end

--- 获取事件数据
---@param source 'sync'|'async'|string 数据源
---@param symbol string|table 标识物
---@param evtKind string|nil 事件类型，可为空
---@param key string|nil 特定键值判断，可为空
---@return table<string,Array>|Array|function|nil
function event.get(source, symbol, evtKind, key)
    local data = event.source(source, symbol)
    if (nil == data) then
        return
    end
    if (type(evtKind) == "string") then
        data = data[evtKind] -- Array
        if (false == isArray(data)) then
            return
        end
    end
    if (type(key) == "string") then
        data = data:get(key) -- function
    end
    return data
end

-------------------------------- 原生 --------------------------------

--- 触发原生条件注入
--- 使用一个handle，以不同的conditionAction累计计数
--- 分配触发到回调注册
--- 注入的action是不会被同一个handle注册两次的，与on事件并不相同
---@param conditionFunc number
---@param regEvent function
---@return void
function event.condition(conditionFunc, regEvent)
    sync.must()
    if (type(regEvent) ~= "function") then
        return
    end
    local id = J.GetHandleId(conditionFunc)
    -- 如果这个handle已经注册过此动作，则不重复注册
    local tgr = event._condition[id]
    if (nil == tgr) then
        tgr = J.CreateTrigger()
        J.HandleRef(tgr)
        J.TriggerAddCondition(tgr, conditionFunc)
        event._condition[id] = tgr
    end
    regEvent(event._condition[id])
end

-------------------------------- 异步 --------------------------------

--- 是否拥有异步事件
---@param symbol string|table
---@param evtKind string 事件类型
---@param key string|nil 特定键值判断
---@return boolean
function event.asyncHas(symbol, evtKind, key)
    return type(evtKind) == "string" and nil ~= event.get("async", symbol, evtKind, key)
end

--- 注销异步事件|异步事件集
---@param symbol string|table
---@param evtKind string 事件类型
---@param key string|nil
---@return void
function event.asyncUnregister(symbol, evtKind, key)
    event.set("async", symbol, evtKind, key, nil)
end

--- 注册异步事件
--- 这是根据 key 值决定的，key 默认就是default，需要的时候可以自定义
---@param symbol string|table
---@param evtKind string 事件类型字符
---@vararg string|function 可以填写(function)或(string, function)当有string参数时作为事件的key
---@return void
function event.asyncRegister(symbol, evtKind, ...)
    local key, func = datum.keyFunc(...)
    event.set("async", symbol, evtKind, key, func)
end

--- 触发异步事件
--- 触发前会同步尝试触发拓扑域的异步事件
---@param symbol string|table
---@param evtKind string 事件类型
---@param triggerData table
---@return void
function event.asyncTrigger(symbol, evtKind, triggerData)
    if (nil == symbol or nil == evtKind) then
        return
    end
    -- 回调数据
    local td = setmetatable({}, { __index = triggerData })
    local p = td.triggerPlayer or PlayerLocal()
    async.call(p, function()
        if (class.is(symbol)) then
            local topSymbol = symbol._className
            if (string.sub(topSymbol, 1, 2) == "UI") then
                td.triggerUI = symbol
            else
                td["trigger" .. topSymbol] = symbol
            end
            -- 触发拓扑域的异步事件
            if (nil ~= topSymbol) then
                local data = event.get("async", topSymbol, evtKind)
                if (isArray(data) and data:count() > 0) then
                    local keys = data:keys()
                    local kLen = #keys
                    for i = 1, kLen, 1 do
                        local callFunc = data:get(keys[i])
                        if (nil ~= callFunc) then
                            promise(callFunc, nil, nil, td)
                        end
                    end
                end
            end
        end
        -- 触发异步事件
        local data = event.get("async", symbol, evtKind)
        if (isArray(data) and data:count() > 0) then
            local keys = data:keys()
            local kLen = #keys
            for i = 1, kLen, 1 do
                local callFunc = data:get(keys[i])
                if (nil ~= callFunc) then
                    promise(callFunc, nil, nil, td)
                end
            end
        end
    end)
end

-------------------------------- 同步 --------------------------------

--- 是否拥有同步事件
---@param symbol string|table
---@param evtKind string 事件类型
---@param key string|nil 特定键值判断
---@return boolean
function event.syncHas(symbol, evtKind, key)
    return type(evtKind) == "string" and nil ~= event.get("sync", symbol, evtKind, key)
end

--- 注销同步事件|同步事件集
---@param symbol string|table
---@param evtKind string 事件类型
---@param key string|nil
---@return void
function event.syncUnregister(symbol, evtKind, key)
    event.set("sync", symbol, evtKind, key, nil)
end

--- 注册同步事件
--- 这是根据 key 值决定的，key 默认就是default，需要的时候可以自定义
---@param symbol string|table
---@param evtKind string 事件类型字符
---@vararg string|function 可以填写(function)或(string, function)当有string参数时作为事件的key
---@return void
function event.syncRegister(symbol, evtKind, ...)
    local key, func = datum.keyFunc(...)
    event.set("sync", symbol, evtKind, key, func)
end

--- 触发同步事件
--- 触发前会同步尝试触发拓扑域的同步事件
--- 触发后会延后尝试触发同级域的异步事件
---@param symbol string|table
---@param evtKind string 事件类型
---@param triggerData table
---@return void
function event.syncTrigger(symbol, evtKind, triggerData)
    if (nil == symbol or nil == evtKind) then
        return
    end
    -- 回调数据
    local td = setmetatable({}, { __index = triggerData })
    if (class.is(symbol)) then
        local topSymbol = symbol._className
        td["trigger" .. topSymbol] = symbol
        -- 触发拓扑域的同步事件
        if (nil ~= topSymbol) then
            local data = event.get("sync", topSymbol, evtKind)
            if (isArray(data) and data:count() > 0) then
                local keys = data:keys()
                local kLen = #keys
                for i = 1, kLen, 1 do
                    local callFunc = data:get(keys[i])
                    if (nil ~= callFunc) then
                        promise(callFunc, nil, nil, td)
                    end
                end
            end
        end
    end
    -- 触发该域的同步事件
    local data = event.get("sync", symbol, evtKind)
    if (isArray(data) and data:count() > 0) then
        local keys = data:keys()
        local kLen = #keys
        for i = 1, kLen, 1 do
            local callFunc = data:get(keys[i])
            if (nil ~= callFunc) then
                promise(callFunc, nil, nil, td)
            end
        end
    end
    -- 触发同级域的异步事件
    event.asyncTrigger(symbol, evtKind, triggerData)
end