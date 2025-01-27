--- 鼠标方法
--- 用于注册鼠标事件，控制鼠标等方法
--- 注意键盘callFunc函数内为异步环境
---@class mouse
mouse = mouse or {}

--- [异步]设置鼠标坐标
---@param x number
---@param y number
---@return void
function mouse.position(x, y)
    japi.DZ_SetMousePos(x, y)
end

--- [异步]当鼠标左键点击
---@param key string
---@param callFunc fun(evtData:eventOnMouseLeftClick)
---@return void
function mouse.onLeftClick(key, callFunc)
    event.asyncRegister("mouse", eventKind.mouseLeftClick, key, callFunc)
end

--- [异步]当鼠标左键释放
---@param key string
---@param callFunc fun(evtData:eventOnMouseLeftRelease)
---@return void
function mouse.onLeftRelease(key, callFunc)
    event.asyncRegister("mouse", eventKind.mouseLeftRelease, key, callFunc)
end

--- [异步]当鼠标左键长按
--- 必须包含：可能打断->顺利开始->结束，完整3种流程设定才生效，任一流程缺失都取消注册
---@param key string
---@param startFunc fun(evtData:eventOnMouseLeftLongPressStart) 长按开始回调
---@param brokenFunc fun(evtData:eventOnMouseLeftLongPressBroken) 长按打断回调
---@param overFunc fun(evtData:eventOnMouseLeftLongPressOver) 长按开始回调
---@return void
function mouse.onLeftLongPress(key, startFunc, brokenFunc, overFunc)
    if (type(startFunc) ~= "function" or type(brokenFunc) ~= "function" or type(overFunc) ~= "function") then
        event.asyncUnregister("mouse", eventKind.mouseLeftLongPressBroken, key, nil)
        event.asyncUnregister("mouse", eventKind.mouseLeftLongPressStart, key, nil)
        event.asyncUnregister("mouse", eventKind.mouseLeftLongPressOver, key, nil)
        return
    end
    event.asyncRegister("mouse", eventKind.mouseLeftLongPressBroken, key, brokenFunc)
    event.asyncRegister("mouse", eventKind.mouseLeftLongPressStart, key, startFunc)
    event.asyncRegister("mouse", eventKind.mouseLeftLongPressOver, key, overFunc)
end

--- [异步]当鼠标右键点击
---@param key string
---@param callFunc fun(evtData:eventOnMouseRightClick)
---@return void
function mouse.onRightClick(key, callFunc)
    event.asyncRegister("mouse", eventKind.mouseRightClick, key, callFunc)
end

--- [异步]当鼠标右键释放
---@param key string
---@param callFunc fun(evtData:eventOnMouseRightRelease)
---@return void
function mouse.onRightRelease(key, callFunc)
    event.asyncRegister("mouse", eventKind.mouseRightRelease, key, callFunc)
end

--- [异步]当鼠标右键长按
--- 必须包含：可能打断->顺利开始->结束，完整3种流程设定才生效，任一流程缺失都取消注册
---@param key string
---@param startFunc fun(evtData:eventOnMouseRightLongPressStart) 长按开始回调
---@param brokenFunc fun(evtData:eventOnMouseRightLongPressBroken) 长按打断回调
---@param overFunc fun(evtData:eventOnMouseRightLongPressOver) 长按开始回调
---@return void
function mouse.onRightLongPress(key, startFunc, brokenFunc, overFunc)
    if (type(startFunc) ~= "function" or type(brokenFunc) ~= "function" or type(overFunc) ~= "function") then
        event.asyncUnregister("mouse", eventKind.mouseRightLongPressBroken, key, nil)
        event.asyncUnregister("mouse", eventKind.mouseRightLongPressStart, key, nil)
        event.asyncUnregister("mouse", eventKind.mouseRightLongPressOver, key, nil)
        return
    end
    event.asyncRegister("mouse", eventKind.mouseRightLongPressBroken, key, brokenFunc)
    event.asyncRegister("mouse", eventKind.mouseRightLongPressStart, key, startFunc)
    event.asyncRegister("mouse", eventKind.mouseRightLongPressOver, key, overFunc)
end

--- [异步]当鼠标滚轮
---@param key string
---@param callFunc fun(evtData:eventOnMouseWheel)
---@return void
function mouse.onWheel(key, callFunc)
    event.asyncRegister("mouse", eventKind.mouseWheel, key, callFunc)
end

--- [异步]当鼠标移动
---@param key string
---@param callFunc fun(evtData:eventOnMouseMove)
---@return void
function mouse.onMove(key, callFunc)
    event.asyncRegister("mouse", eventKind.mouseMove, key, callFunc)
end

--- [异步]是否鼠标安全区
--- 只有安全区可以显示指针
--- 自动根据 UIBlock 对象计算
---@param rx number|nil
---@param ry number|nil
---@return boolean
function mouse.isSafety(rx, ry)
    local is = true
    rx = rx or japi.MouseRX()
    ry = ry or japi.MouseRY()
    if (rx < 0.02 or rx > 0.78 or ry < 0.02 or ry > 0.58) then
        return false
    end
    local top, bottom = japi.GetBlackBorders()
    if (ry < bottom or ry > (0.8 - top)) then
        return false
    end
    if (Pool(UIBlockClass):count() == 0) then
        return is
    end
    ---@param b UIBlock
    Pool(UIBlockClass):forEach(function(b)
        if (isInsideUI(b, rx, ry)) then
            is = false
            return false
        end
    end)
    return is
end