--- 鼠标右键点击
J.Japi["DzTriggerRegisterMouseEventByCode"](nil, GAME_KEY_MOUSE_RIGHT, GAME_KEY_ACTION_PRESS, false, function()
    if (true ~= japi.DZ_IsWindowActive()) then
        return
    end
    local symbol = "mouse"
    local has0 = event.asyncHas(symbol, eventKind.mouseRightClick)
    local hasL = event.asyncHas(symbol, eventKind.mouseRightLongPressStart)
    local has = has0 or hasL
    if (false == has) then
        return
    end
    local index = 1 + J.GetPlayerId(japi.DZ_GetTriggerKeyPlayer())
    local evtData = {
        triggerPlayer = Player(index),
        rx = japi._cursor.rx,
        ry = japi._cursor.ry
    }
    if (has0) then
        event.asyncTrigger(symbol, eventKind.mouseRightClick, evtData)
    end
    -- long press
    if (hasL) then
        if (japi.IsLongPressing("mouse", "right")) then
            return
        end
        japi._longPress.mouse["right"] = {
            start = 0,
            id = japi.AsyncExecDelay(8, index, function()
                local lp = japi._longPress.mouse["right"]
                lp.start = japi._asyncInc
                event.asyncTrigger(symbol, eventKind.mouseRightLongPressStart, setmetatable({ frame = lp.start }, { __index = evtData }))
            end),
        }
    end
end)