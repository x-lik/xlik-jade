--- 拖拽UI面板
---@class UIDrag:UIPlate
local _index = UI(UIDragClass, {
    ---@type string
    _blocking = true,
    ---@type number
    _paddingTop = 0,
    ---@type number
    _paddingBottom = 0,
    ---@type number
    _paddingLeft = 0,
    ---@type number
    _paddingRight = 0,
}):extend(UIPlateClass)

---@private
function _index:destruct()
    self:onEvent(eventKind.uiLeftClick, nil)
    self:onEvent(eventKind.uiLeftRelease, nil)
    class.cache(UIDragClass)[self._key] = nil
end

--- 设置填充空间
--- 影响移动的极限
---@param top number
---@param right number
---@param bottom number
---@param left number
---@return self
function _index:padding(top, right, bottom, left)
    if (type(top) == "number" and type(right) == "number" and type(bottom) == "number" and type(left) == "number") then
        self._paddingTop = top
        self._paddingBottom = bottom
        self._paddingLeft = left
        self._paddingRight = right
    end
    return self
end

--- 设定坐标供Release时移动UI
---@param x number
---@param y number
---@return self
function _index:releaseXY(x, y)
    if (type(x) == "number" and type(y) == "number") then
        self._releaseX = x
        self._releaseY = y
    end
end

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
        -- drag事件处理
        -- 参考 setQuote("drag")
        ---@param evtData eventOnUILeftClick
        o:onEvent(eventKind.uiLeftClick, function(evtData)
            japi.DZ_FrameSetAlpha(o._handle, o._alpha * 0.8)
            event.asyncTrigger(o, eventKind.uiDragStart, evtData)
            cursor.quote("drag", { ui = o })
        end)
        ---@param evtData eventOnUILeftRelease
        o:onEvent(eventKind.uiLeftRelease, function(evtData)
            local data = cursor.currentData()
            if (nil ~= data and data.ui == o) then
                japi.DZ_FrameSetAlpha(o._handle, o._alpha)
                cursor.quoteOver("drag")
                local rlx, rly = o._releaseX, o._releaseY
                if (type(rlx) == "number") then
                    local x, y = rlx, rly
                    if (true == o._adaptive) then
                        x = japi.UIDisAdaptive(x)
                    end
                    o:relation(UI_ALIGN_CENTER, UIGame, UI_ALIGN_LEFT_BOTTOM, x, y)
                    o._releaseX = nil
                    o._releaseY = nil
                    event.asyncTrigger(o, eventKind.uiDragStop, evtData)
                end
            end
        end)
        cache[key] = o
    end
    return cache[key]
end