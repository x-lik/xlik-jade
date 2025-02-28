-- UI Adaptive
local smooth = {}
---@param evtData eventOnWindowResize
event.asyncRegister("window", eventKind.windowResize, "_li_resize", function(evtData)
    -- adaptive
    local pIdx = evtData.triggerPlayer:index()
    if (class.isObject(smooth[pIdx], TimerAsyncClass)) then
        smooth[pIdx]:remain(smooth[pIdx]:period())
        return
    end
    smooth[pIdx] = async.setTimeout(9, function()
        smooth[pIdx] = nil
        -- client
        japi._clientHeight = japi.DZ_GetClientHeight()
        japi._clientWidth = japi.DZ_GetClientWidth()
        ---@param ui UI
        japi._uiAdaptive:backEach(function(_, ui)
            if (class.isType(ui, "UI")) then
                if (ui._width and ui._height) then
                    local aw = japi.UIAdaptive(ui._width)
                    ui._widthAdaptive = aw
                    ui:resetAnchor()
                    japi.DZ_FrameSetSize(ui._handle, aw, ui._height)
                end
                if (ui._upNode) then
                    local ax = japi.UIAdaptive(ui._x)
                    japi.DZ_FrameClearAllPoints(ui._handle)
                    japi.DZ_FrameSetPoint(ui._handle, ui._point, ui._upNode._handle, ui._upNodePoint, ax, ui._y)
                    ui._xAdaptive = ax
                    ui:resetAnchor()
                end
            end
        end)
        --- trigger camera change event for ui
        event.asyncTrigger("camera", eventKind.cameraChange)
    end)
end)