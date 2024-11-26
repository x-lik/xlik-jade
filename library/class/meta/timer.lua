--- 计时器
---@class Timer:Meta
local _index = Meta(TimerClass, {
    _fin = 0,
})

---@protected
function _index:destruct()
    local l = self._fin
    self._fin = -1
    if (nil ~= l and l > time._inc) then
        local kl = time._kernel
        local id = self._id
        if (nil ~= kl[l] and nil ~= kl[l][id]) then
            kl[l][id] = nil
        end
    end
end

--- 获取是否循环计时器
---@return boolean
function _index:isInterval()
    return self._interval
end

--- 设置|获取 剩余时间(秒)
---@param second number|nil
---@return void|number
function _index:remain(second)
    if (type(second) == "number") then
        local kl = time._kernel
        local id = self._id
        local l = self._fin
        if (nil ~= kl[l] and nil ~= kl[l][id]) then
            kl[l][id] = nil
            self:run(math.min(self._period, math.max(0, second)))
        end
    else
        local remain = self._pause or -1
        local l = self._fin
        if (remain == -1) then
            if (l > 0) then
                remain = (l - time._inc) / 100
            end
        end
        return remain
    end
end

--- 设置|获取 周期时间(秒)
---@param second number|nil
---@return void|number
function _index:period(second)
    if (type(second) == "number") then
        self._period = second
        local l = self._fin
        if (l > 0) then
            if (self._remain > self._period) then
                local kl = time._kernel
                kl[l][self._id] = nil
                self:run(self._period)
            end
        end
    else
        return self._period or -1
    end
end

--- 获取已逝时间(秒)（周期时间-剩余时间）
---@return number
function _index:elapsed()
    return math.max(0, self._period - self:remain())
end

--- 运行计时器
---@param period number sec 指定当前倒计时间，不设置时则为当前设定周期
---@return void
function _index:run(period)
    period = period or self._period
    local l = math.ceil(time._inc + math.max(1, period * 100))
    self._fin = l
    local kl = time._kernel
    if (nil == kl[l]) then
        kl[l] = Array()
    end
    kl[l]:set(self._id, self)
end

--- 暂停计时器
---@return void
function _index:pause()
    local l = self._fin
    if (l > time._inc) then
        local kl = time._kernel
        kl[l][self._id] = nil
    end
    self._pause = (l - time._inc) / 100
    self._fin = -1
end

--- 恢复计时器
---@return void
function _index:resume()
    if (type(self._pause) == "number") then
        self:run(self._pause)
        self._pause = nil
    end
end

---@param interval boolean
---@param period number
---@param call fun(curTimer:Timer):Timer
---@return Timer
function Timer(interval, period, call)
    sync.must()
    must(type(interval) == "boolean", "interval@boolean")
    must(type(period) == "number", "period@number")
    must(type(call) == "function", "call@function")
    local t = oMeta({ _interval = interval, _period = period, _remain = period, _call = call }, _index)
    -- ID
    class.id(t, false)
    t:run()
    return t
end

-- 注册计时器时钟
time.registerClock(function()
    local inc = time._inc
    local kl = time._kernel
    ---@type Array
    local ki = kl[inc]
    if (isArray(ki)) then
        ---@param t Timer
        ki:forEach(function(_, t)
            if (t._fin ~= -1) then
                promise(t._call,
                    function()
                        class.destroy(t)
                    end,
                    function()
                        if (true == t._interval) then
                            if (t._fin ~= -1) then
                                t:run()
                            end
                        else
                            class.destroy(t)
                        end
                    end
                , t)
            end
        end)
    end
    kl[inc] = nil
end)