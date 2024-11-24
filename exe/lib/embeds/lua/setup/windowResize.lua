--- Window Resize
J.Japi["DzTriggerRegisterWindowResizeEventByCode"](nil, false, function()
    if (true ~= japi.DZ_IsWindowActive()) then
        return
    end
    local triggerPlayer = Player(1 + J.GetPlayerId(japi.DZ_GetTriggerKeyPlayer()))
    event.asyncTrigger("window", eventKind.windowResize, {
        triggerPlayer = triggerPlayer
    })
end)