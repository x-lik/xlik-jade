--- 鼠标滚轮
J.Japi["DzTriggerRegisterMouseWheelEventByCode"](nil, false, function()
    if (true ~= japi.DZ_IsWindowActive()) then
        return
    end
    local triggerPlayer = Player(1 + J.GetPlayerId(japi.DZ_GetTriggerKeyPlayer()))
    event.asyncTrigger("mouse", eventKind.mouseWheel, {
        triggerPlayer = triggerPlayer,
        delta = japi.DZ_GetWheelDelta()
    })
end)