-- UI Esc
keyboard.onRelease(keyboard.code["Esc"], "lk_ui_esc", function()
    if (japi.DZ_IsChatBoxOpen()) then
        return
    end
    local keys = japi._uiEsc:keys()
    local l = #keys
    if (l > 0) then
        local key = keys[l]
        local fr = japi._uiEsc:get(key)
        japi._uiEsc:set(key, nil)
        fr:show(false)
    end
end)