--- 游戏窗口
--- 窗口变动处理相关的方法
---@class window
window = window or {}

--- 当游戏窗口大小异步改变
---@param key string
---@param callFunc fun(evtData:eventOnWindowResize):void
---@return void
function window.onResize(key, callFunc)
    key = key or "default"
    if (type(callFunc) ~= "function") then
        callFunc = nil
    end
    event.asyncRegister("window", eventKind.windowResize, key, callFunc)
end