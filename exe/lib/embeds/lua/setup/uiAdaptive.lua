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
                if (ui._widthAdaptive) then
                    ui:size(ui._width, ui._height)
                end
                if (ui._upNode) then
                    ui:relation(ui._point, ui._upNode, ui._upNodePoint, ui._x, ui._y)
                end
            end
        end)
        --- trigger camera change event for ui
        event.asyncTrigger("camera", eventKind.cameraChange)
    end)
end)