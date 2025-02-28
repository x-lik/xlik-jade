--- 拖拽UI面板
---@class UIDrag:UIPlate
local _index = UI(UIDragClass, {
    ---@type string
    _blocking = true,
    ---@type string 额外指针引用
    _cursorQuote = "drag",
    ---@type number 外边距上
    _marginTop = 0,
    ---@type number 外边距下
    _marginBottom = 0,
    ---@type number 外边距左
    _marginLeft = 0,
    ---@type number 外边距右
    _marginRight = 0,
}):extend(UIPlateClass)

---@protected
function _index:destruct()
    self:onEvent(eventKind.uiLeftClick, nil)
    self:onEvent(eventKind.uiLeftRelease, nil)
end

--- 设置外边距排斥空间
--- 影响移动的极限
---@param top number
---@param right number
---@param bottom number
---@param left number
---@return self
function _index:margin(top, right, bottom, left)
    if (type(top) == "number" and type(right) == "number" and type(bottom) == "number" and type(left) == "number") then
        self._marginTop = top
        self._marginBottom = bottom
        self._marginLeft = left
        self._marginRight = right
    end
    return self
end

--- 是否拖拽中
---@return boolean
function _index:isDragging()
    return true == self._dragging
end

--- 使用指针引用（默认 drag）
--- 可以在指针添加位移外的修正，如被拖拽UI的透明度，可参考demo中的setQuote("drag")
--- 引用的指针未定义设置不存在时，引用自动失效
---@return boolean
function _index:cursorQuote()
    self._cursorQuote = "drag"
end

--- 构造 UI拖拽对象
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@return UIDrag
function UIDrag(key, parent)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UIDragClass)
    if (nil == cache[key]) then
        local o = oUI({
            _key = key,
            _parent = parent or UIGame,
            _fdfName = "LK_BACKDROP",
            _fdfType = "BACKDROP"
        }, _index)
        if (LK_DEBUG) then
            o:texture(BLP_COLOR_PINK)
        end
        -- UIDrag事件处理
        local eKey = "lk_drag"
        local over = function(ui, evtData)
            ui._dragging = false
            ui:onEvent(eventKind.uiHide, eKey, nil)
            mouse.onMove(eKey .. ui:id(), nil)
            cursor.quoteOver(ui._cursorQuote)
            local rlx, rly = ui._releaseX, ui._releaseY
            if (type(rlx) == "number") then
                local x, y = rlx, rly
                if (true == ui._adaptive) then
                    x = japi.UIDisAdaptive(x)
                end
                ui:relation(UI_ALIGN_CENTER, UIGame, UI_ALIGN_LEFT_BOTTOM, x, y)
                ui._releaseX = nil
                ui._releaseY = nil
                event.asyncTrigger(ui, eventKind.uiDragStop, evtData)
            end
        end
        ---@param evtData eventOnUILeftClick
        o:onEvent(eventKind.uiLeftClick, eKey, function(evtData)
            ---@type UIDrag
            local ui = evtData.triggerUI
            ui:onEvent(eventKind.uiHide, eKey, function()
                over(ui, evtData)
            end)
            cursor.quote(ui._cursorQuote, { ui = ui })
            event.asyncTrigger(ui, eventKind.uiDragStart, evtData)
            local a = ui:anchor()
            local f1 = japi.MouseRX() - a[1]
            local f2 = japi.MouseRY() - a[2]
            ui._dragging = true
            mouse.onMove(eKey .. ui:id(), function(msData)
                local x = msData.rx - f1
                local y = msData.ry - f2
                local mt, mb, ml, mr = ui._marginTop, ui._marginBottom, ui._marginLeft, ui._marginRight
                x = math.max(x, a[3] / 2 + ml)
                x = math.min(x, 0.8 - a[3] / 2 - mr)
                y = math.max(y, a[4] / 2 + mb)
                y = math.min(y, 0.6 - a[4] / 2 - mt)
                local h = ui:handle()
                japi.DZ_FrameClearAllPoints(h)
                japi.DZ_FrameSetPoint(h, UI_ALIGN_CENTER, UIGame:handle(), UI_ALIGN_LEFT_BOTTOM, x, y)
                ui._releaseX = x
                ui._releaseY = y
            end)
        end)
        ---@param evtData eventOnUILeftRelease
        o:onEvent(eventKind.uiLeftRelease, eKey, function(evtData)
            local ui = evtData.triggerUI
            if (true == ui._dragging) then
                over(ui, evtData)
            end
        end)
        cache[key] = o
    end
    return cache[key]
end