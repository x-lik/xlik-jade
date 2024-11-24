--- 鼠标移动
J.Japi["DzTriggerRegisterMouseMoveEventByCode"](nil, false, function()
    if (true ~= japi.DZ_IsWindowActive()) then
        return
    end
    japi._cursor.rx = japi.RX(japi.DZ_GetMouseXRelative())
    japi._cursor.ry = japi.RY(japi._clientHeight - japi.DZ_GetMouseYRelative())
    local triggerPlayer = Player(1 + J.GetPlayerId(japi.DZ_GetTriggerKeyPlayer()))
    -- events
    event.asyncTrigger("mouse", eventKind.mouseMove, {
        triggerPlayer = triggerPlayer,
        rx = japi._cursor.rx,
        ry = japi._cursor.ry
    })
end)