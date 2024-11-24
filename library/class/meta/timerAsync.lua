--- 异步计帧器
---@class TimerAsync
local _index = Meta(TimerAsyncClass)

---@protected
function _index:destruct()
    japi.CancelAsyncExecDelay(self._id)
    self._id = nil
    self._fin = -1
end

--- 获取是否循环计帧器
---@return boolean
function _index:isInterval()
    return self._interval
end

--- 设置|获取 剩余帧数
---@param frame number|nil
---@return void|number
function _index:remain(frame)
    if (type(frame) == "number") then
        frame = math.min(frame, self._period)
        japi.CancelAsyncExecDelay(self._id)
        self:run(frame)
    else
        local remain = self._pause or -1
        local l = self._fin or 0
        if (remain == -1) then
            if (l > 0) then
                remain = l - japi._asyncInc
            end
        end
        return remain
    end
end

--- 设置|获取 周期帧数
---@param frame number|nil integer 帧值
---@return void|number
function _index:period(frame)
    if (type(frame) == "number") then
        self._period = frame
    else
        return self._period
    end
end

--- 获取已逝帧数（周期帧数-剩余帧数）
---@return number
function _index:elapsed()
    return math.max(0, self._period - self:remain())
end

--- 运行计帧器
---@param period number sec 指定当前倒计帧数，不设置时则为当前设定周期
---@return void
function _index:run(period)
    period = period or self._period
    self._id = japi.AsyncExecDelay(period, self._aid, self._call)
    local ids = string.explode('.', self._id)
    self._fin = math.round(ids[1])
end

--- 暂停计帧器
---@return void
function _index:pause()
    if (self._fin > japi._asyncInc) then
        japi.CancelAsyncExecDelay(self._id)
        self._pause = self._fin - japi._asyncInc
    end
    self._id = nil
    self._fin = -1
end

--- 恢复计帧器
---@return void
function _index:resume()
    if (type(self._pause) == "number") then
        self:run(self._pause)
        self._pause = nil
    end
end

---@param interval boolean
---@param frame number integer 帧值
---@param call fun(curTimer:TimerAsync):TimerAsync
---@return TimerAsync
function TimerAsync(interval, frame, call)
    async.must()
    must(type(interval) == "boolean", "interval@boolean")
    must(type(frame) == "number", "frame@integer")
    must(type(call) == "function", "call@function")
    ---@type TimerAsync
    local t = oMeta({ _interval = interval, _period = frame, _aid = async._id }, _index)
    t._call = function()
        if (t._fin ~= -1) then
            call(t)
            if (true == t._interval) then
                if (t._fin ~= -1) then
                    t:run()
                end
            else
                class.destroy(t)
            end
        end
    end
    t:run()
    return t
end