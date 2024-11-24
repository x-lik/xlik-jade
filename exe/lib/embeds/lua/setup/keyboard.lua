--- 键盘事件
local allKeyboardCodes = keyboard.code
for _, kb in pairx(allKeyboardCodes) do
    J.Japi["DzTriggerRegisterKeyEventByCode"](nil, kb, GAME_KEY_ACTION_PRESS, false, function()
        if (true ~= japi.DZ_IsWindowActive() or true == japi.DZ_IsChatBoxOpen()) then
            return
        end
        local triggerKey = japi.DZ_GetTriggerKey()
        local symbol = "keyboard" .. triggerKey
        local has0 = event.asyncHas(symbol, eventKind.keyboardPress)
        local hasL = event.asyncHas(symbol, eventKind.keyboardLongPressStart)
        local has = has0 or hasL
        if (false == has) then
            return
        end
        local index = 1 + J.GetPlayerId(japi.DZ_GetTriggerKeyPlayer())
        local evtData = {
            triggerPlayer = Player(index),
            triggerKey = triggerKey
        }
        if (has0) then
            event.asyncTrigger(symbol, eventKind.keyboardPress, evtData)
        end
        -- long press
        if (hasL) then
            if (japi.IsLongPressing("keyboard", triggerKey)) then
                return
            end
            japi._longPress.keyboard[triggerKey] = {
                start = 0,
                id = japi.AsyncExecDelay(8, index, function()
                    local lp = japi._longPress.keyboard[triggerKey]
                    lp.start = japi._asyncInc
                    event.asyncTrigger(symbol, eventKind.keyboardLongPressStart, setmetatable({ triggerKey = triggerKey, frame = lp.start }, { __index = evtData }))
                end),
            }
        end
    end)
    J.Japi["DzTriggerRegisterKeyEventByCode"](nil, kb, GAME_KEY_ACTION_RELEASE, false, function()
        if (true ~= japi.DZ_IsWindowActive() or true == japi.DZ_IsChatBoxOpen()) then
            return
        end
        local triggerKey = japi.DZ_GetTriggerKey()
        local symbol = "keyboard" .. triggerKey
        local has0 = event.asyncHas(symbol, eventKind.keyboardRelease)
        local hasL = event.asyncHas(symbol, eventKind.keyboardLongPressStart)
        local has = has0 or hasL
        if (false == has) then
            return
        end
        local triggerPlayer = Player(1 + J.GetPlayerId(japi.DZ_GetTriggerKeyPlayer()))
        local evtData = {
            triggerPlayer = triggerPlayer,
            triggerKey = triggerKey
        }
        if (has0) then
            event.asyncTrigger(symbol, eventKind.keyboardRelease, evtData)
        end
        -- long press
        if (hasL) then
            local lp = japi._longPress.keyboard[triggerKey]
            if (nil ~= lp) then
                if (lp.start > 0) then
                    local duration = japi._asyncInc - lp.start
                    event.asyncTrigger(symbol, eventKind.keyboardLongPressOver, setmetatable({ triggerKey = triggerKey, frame = japi._asyncInc, duration = duration }, { __index = evtData }))
                else
                    japi.CancelAsyncExecDelay(lp.id)
                    event.asyncTrigger(symbol, eventKind.keyboardLongPressBroken, setmetatable({ triggerKey = triggerKey }, { __index = evtData }))
                end
                lp.id = nil
                lp.start = 0
            end
        end
    end)
end