--- Buff状态控制，控制状态的执行与回滚

--- buff标识
buffSignal = {
    up = "up", -- 提升;增益
    down = "down", -- 下降;负面
}

--- Buff对象
---@class Buff:Meta
local _index = Meta(BuffClass, {
    ---@type string 凸显文本（一般用不到）
    _text = '',
    ---@type number
    _duration = -1,
    ---@type boolean 可视判断（可根据此值决定UI显隐等，默认true）
    _visible = true,
    ---@type boolean
    _running = false,
})

---@protected
function _index:destruct()
    if (true == self._running) then
        self:rollback()
    end
end

--- 是否在执行中
---@return boolean
function _index:isRunning()
    return self._running
end

--- 设置|获取 剩余时间
---@param second number|nil
---@return void|number
function _index:remain(second)
    if (type(second) == "number") then
        if (class.isObject(self._durationTimer, TimerClass)) then
            self._durationTimer:remain(second)
        end
    else
        if (class.isObject(self._durationTimer, TimerClass)) then
            return self._durationTimer:remain()
        end
        return 0
    end
end

--- 获取凸显信息（一般为图标中间文本）默认为''
---@return string
function _index:text()
    return self._text
end

--- 强制设置凸显信息
---@return void
function _index:setText(content)
    self._text = content
end

--- 获取持续时间（默认-1）
---@return self
function _index:duration()
    return self._duration
end

--- 获取可视判断
--- 可根据此值决定UI显隐等，默认true
---@return boolean
function _index:visible()
    return self._visible
end

--- 获取标识（buffSignal）
--- 例如增益buff可以给个标识up，负面buff可以给个down，用以区分buff种类
---@return string|nil
function _index:signal()
    return self._signal
end

--- 获取Key
---@return string
function _index:key()
    return self._key
end

--- 获取Buff名称
---@return string
function _index:name()
    return self._name
end

--- 获取Buff图标
---@return string
function _index:icon()
    return self._icon
end

--- 获取Buff描述字符串数据组
---@return string[]
function _index:description()
    local d = { self._name }
    ---@type BuffDescription
    local description = self._description
    if (type(description) == "string") then
        d[#d + 1] = description
    elseif (type(description) == "table") then
        for _, v in ipairs(description) do
            d[#d + 1] = tostring(v)
        end
    elseif (type(description) == "function") then
        d = table.merge(d, description(self))
    end
    return d
end

--- 执行回滚
--- Buff回滚后会自动destroy
---@return void
function _index:rollback()
    sync.must()
    if (true == self._running) then
        local o = self._object
        if (false == class.isDestroy(o)) then
            self._rollback(o)
            o._buffs:set(self._id, nil)
        end
        if (class.isObject(self._durationTimer, TimerClass)) then
            class.destroy(self._durationTimer)
            self._durationTimer = nil
        end
        self._running = false
    end
    class.destroy(self)
end

--- 构造Buff对象
---@alias BuffDescription string|string[]|fun(obj:Buff):string[]
---@alias BuffFunc fun(buffObj:Object):void
---@alias BuffInfos {name:string,duration:number,signal:string,icon:string,description:BuffDescription,visible:boolean,text:string}
---@alias BuffParams {object:Object|Unit,key:string,purpose:BuffFunc,rollback:BuffFunc}|BuffInfos
---@param params BuffParams
---@return Buff
function Buff(params)
    sync.must()
    local obj = params.object
    local key = params.key
    local purpose = params.purpose
    local rollback = params.rollback
    must(class.is(obj), "params.object@Object")
    must(type(key) == "string", "params.key@string")
    must(type(purpose) == "function", "params.purpose@buffCallFunc")
    must(type(rollback) == "function", "params.rollback@buffCallFunc")
    if (nil == obj._buffs) then
        obj._buffs = Array()
    end
    local p = {
        _object = obj,
        _key = key,
        _name = params.name or attribute._labels[key] or key,
        _purpose = purpose,
        _rollback = rollback,
    }
    if (type(params.duration) == "number") then
        p._duration = params.duration
    end
    if (type(params.visible) == "boolean") then
        p._visible = params.visible
    end
    if (type(params.icon) == "string") then
        p. _icon = japi.AssetsImage(params.icon or attribute.icon(key))
    end
    if (type(params.text) == "string") then
        p._text = params.text
    end
    if (nil ~= params.description) then
        p._description = params.description
    end
    if (type(params.visible) == "boolean") then
        p._visible = params.visible
    end
    if (type(params.signal) == "table") then
        p._signal = params._signal
    end
    ---@type Buff
    local o = oMeta(p, _index)
    --- ID
    class.id(o, false)
    --- 执行预期（auto run）
    if (false == class.isDestroy(obj)) then
        o._running = true
        o._purpose(obj)
        obj._buffs:set(o._id, o)
        local dur = o._duration
        if (dur > 0) then
            o._durationTimer = time.setTimeout(dur, function()
                o:rollback()
            end)
        end
    end
    return o
end

--- Buff提取器
---@alias BuffCatchFilter {forward:boolean,key:string,name:string,signal:string,limit:number,filter:fun(enumBuff:Buff)}
---@param object Object|Unit
---@param filter BuffCatchFilter filter.forward boolean类型，正序(true)，反序(false)
---@return Buff[]
function BuffCatch(object, filter)
    local catch = {}
    ---@type Array
    local b = object._buffs
    if (isArray(b)) then
        local forward = true
        if (type(filter) == "table") then
            if (type(filter.forward) == "boolean") then
                forward = filter.forward
            end
            if (type(filter.limit) ~= "number") then
                filter.limit = 100
            end
        end
        local des = {}
        ---@param enumBuff Buff
        local act = function(ek, enumBuff)
            if (class.isDestroy(enumBuff)) then
                des[#des + 1] = ek
                return
            end
            if (type(filter) == "table") then
                if (#catch >= filter.limit) then
                    return false
                end
                if (type(filter.key) == "string") then
                    if (filter.key ~= enumBuff._key) then
                        return
                    end
                end
                if (type(filter.name) == "string") then
                    if (filter.name ~= enumBuff._name) then
                        return
                    end
                end
                if (type(filter.signal) == "string") then
                    if (filter.signal ~= enumBuff._signal) then
                        return
                    end
                end
                if (type(filter.filter) == "function") then
                    if (true ~= filter.filter(enumBuff)) then
                        return
                    end
                end
            end
            table.insert(catch, enumBuff)
        end
        if (forward) then
            b:forEach(act)
        else
            b:backEach(act)
        end
        for _, k in ipairs(des) do
            b:set(k, nil)
        end
    end
    return catch
end

--- 某条件统计Buff数量
---@param object Object|Unit
---@param filter string
---@return number
function BuffCount(object, filter)
    local b = BuffCatch(object, filter)
    return #b
end

--- 根据条件获取1个Buff，可能返回nil
---@param object Object|Unit
---@param filter BuffCatchFilter
---@return Buff|nil
function BuffOne(object, filter)
    filter.limit = 1
    local b = BuffCatch(object, filter)
    if (#b > 0) then
        return b[1]
    end
end

--- 是否存在某个key的Buff
---@param object Object|Unit
---@param key string
---@return boolean
function BuffHas(object, key)
    return class.isObject(BuffOne(object, { key = key }), BuffClass)
end

--- 根据条件清理Buffs
---@param object Object|Unit
---@param filter BuffCatchFilter
function BuffClear(object, filter)
    local buffs = BuffCatch(object, filter)
    if (#buffs > 0) then
        for _, b in ipairs(buffs) do
            b:rollback()
        end
    end
end