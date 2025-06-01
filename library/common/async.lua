--- 异步管理，用于管理异步操作的各种事务
---@class async
async = async or {}

---@type number 异步ID
async._id = async._id or 0

--- 是否处在异步执行中
---@return boolean
function async.is()
    return async._id > 0
end

--- 限制必须异步
--- 只对async.call调用有判定效果
---@return void
function async.must()
    must(async.is(), "not async runtime env")
end

--- 某玩家异步调用
--- 使用此方法后回调执行过程将检查同异步状态
---@param asyncPlayer Player
---@param callFunc function
---@return void
function async.call(asyncPlayer, callFunc)
    japi.AsyncExec(asyncPlayer:index(), callFunc)
end

--- 本地玩家异步调用
--- 使用此方法后回调执行过程将检查同异步状态
---@param callFunc function
---@return void
function async.loc(callFunc)
    japi.AsyncExec(nil, callFunc)
end

--- 当前异步玩家异步调用
--- 使用此方法后回调执行过程将检查同异步状态
---@param callFunc function
---@return void
function async.cur(callFunc)
    async.must()
    japi.AsyncExec(async._id, callFunc)
end

-- 设置一次性异步时帧器
---@param frame number
---@param callFunc fun(curTimer:TimerAsync):void
---@return TimerAsync
function async.setTimeout(frame, callFunc)
    return TimerAsync(false, frame, callFunc)
end

--- 设置周期性异步时帧器
---@param frame number
---@param callFunc fun(curTimer:TimerAsync):void
---@return TimerAsync
function async.setInterval(frame, callFunc)
    return TimerAsync(true, frame, callFunc)
end