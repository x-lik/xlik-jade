--- 鼠标左键释放
J.Japi["DzTriggerRegisterMouseEventByCode"](nil, GAME_KEY_MOUSE_LEFT, GAME_KEY_ACTION_RELEASE, false, function()
    if (true ~= japi.DZ_IsWindowActive()) then
        return
    end
    local symbol = "mouse"
    local has0 = event.asyncHas(symbol, eventKind.mouseLeftRelease)
    local hasL = event.asyncHas(symbol, eventKind.mouseLeftLongPressStart)
    local has = has0 or hasL
    if (false == has) then
        return
    end
    local evtData = {
        triggerPlayer = Player(1 + J.GetPlayerId(japi.DZ_GetTriggerKeyPlayer())),
        rx = japi._cursor.rx,
        ry = japi._cursor.ry
    }
    if (has0) then
        event.asyncTrigger(symbol, eventKind.mouseLeftRelease, evtData)
    end
    -- long press
    if (hasL) then
        local lp = japi._longPress.mouse["left"]
        if (nil ~= lp) then
            if (lp.start > 0) then
                local duration = japi._asyncInc - lp.start
                event.asyncTrigger(symbol, eventKind.mouseLeftLongPressOver, setmetatable({ frame = japi._asyncInc, duration = duration }, { __index = evtData }))
            else
                japi.CancelAsyncExecDelay(lp.id)
                event.asyncTrigger(symbol, eventKind.mouseLeftLongPressBroken, setmetatable({}, { __index = evtData }))
            end
            lp.id = nil
            lp.start = 0
        end
    end
end)