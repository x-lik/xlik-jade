--- 条UI
---@class UIBar:UI
local _index = UI(UIBarClass, {
    ---@type number 边框模式下的内置位置调整值，默认0
    _borderOffset = 0,
    ---@type number 值比率
    _ratio = 0,
})

---@protected
function _index:construct()
    if (self._fdfName == "LK_BACKDROP") then
        japi.DZ_FrameSetTexture(self._handle, X_UI_NIL, 0)
    end
    --- 下条层(数值层)
    self._textureValue = UIBackdrop(self._key .. ":texVal", self)
        :relation(UI_ALIGN_CENTER, self, UI_ALIGN_CENTER, 0, 0)
        :texture(BLP_COLOR_BLUE)
    --- 上条层(遮罩层)
    self._textureMark = UIBackdrop(self._key .. ":texMark", self)
        :relation(UI_ALIGN_RIGHT, self._textureValue, UI_ALIGN_RIGHT, 0, 0)
        :texture(BLP_COLOR_BLACK)
    --- layouts
    if (type(self._layouts) == "table") then
        for _, v in ipairs(self._layouts) do
            local t = UIText(self._key .. ":txt" .. v, self)
            t:fontSize(10)
            if (v == LAYOUT_ALIGN_LEFT_TOP) then
                t:textAlign(TEXT_ALIGN_LEFT):relation(UI_ALIGN_LEFT_BOTTOM, self, UI_ALIGN_LEFT_TOP, 0, 0.002)
            elseif (v == LAYOUT_ALIGN_TOP) then
                t:textAlign(TEXT_ALIGN_CENTER):relation(UI_ALIGN_BOTTOM, self, UI_ALIGN_TOP, 0, 0.002)
            elseif (v == LAYOUT_ALIGN_RIGHT_TOP) then
                t:textAlign(TEXT_ALIGN_RIGHT):relation(UI_ALIGN_RIGHT_BOTTOM, self, UI_ALIGN_RIGHT_TOP, 0, 0.002)
            elseif (v == LAYOUT_ALIGN_LEFT) then
                t:textAlign(TEXT_ALIGN_LEFT):relation(UI_ALIGN_LEFT, self, UI_ALIGN_LEFT, 0, 0)
            elseif (v == LAYOUT_ALIGN_CENTER) then
                t:textAlign(TEXT_ALIGN_CENTER):relation(UI_ALIGN_CENTER, self, UI_ALIGN_CENTER, 0, 0)
            elseif (v == LAYOUT_ALIGN_RIGHT) then
                t:textAlign(TEXT_ALIGN_RIGHT):relation(UI_ALIGN_RIGHT, self, UI_ALIGN_RIGHT, 0, 0)
            elseif (v == LAYOUT_ALIGN_LEFT_BOTTOM) then
                t:textAlign(TEXT_ALIGN_LEFT):relation(UI_ALIGN_LEFT_TOP, self, UI_ALIGN_LEFT_BOTTOM, 0, -0.002)
            elseif (v == LAYOUT_ALIGN_BOTTOM) then
                t:textAlign(TEXT_ALIGN_CENTER):relation(UI_ALIGN_TOP, self, UI_ALIGN_BOTTOM, 0, -0.002)
            elseif (v == LAYOUT_ALIGN_RIGHT_BOTTOM) then
                t:textAlign(TEXT_ALIGN_RIGHT):relation(UI_ALIGN_RIGHT_TOP, self, UI_ALIGN_RIGHT_BOTTOM, 0, -0.002)
            end
            self["_txt" .. v] = t
        end
        self._layouts = nil
    end
end

---@protected
function _index:destruct()
    class.cache(UIBarClass)[self._key] = nil
end

--- 设置条数据值
---@param value number 取值范围[0.00-1.00]
---@param width number
---@param height number
---@return self
function _index:ratio(value, width, height)
    local w, h
    if (width or height or value or w or h) then
        if (width and height) then
            self:size(width, height)
            w = width - self._borderOffset
            h = height - self._borderOffset
            self._textureValue:size(w, h)
        end
        if (value and w and h) then
            value = math.min(1, value)
            value = math.max(0, value)
            self._ratio = value
            if (value <= 0) then
                self._textureValue:show(false)
                self._textureMark:size(w, h):show(true)
            else
                local wv = w * (1 - value)
                self._textureValue:show(true)
                self._textureMark:size(wv, h):show(wv > 0)
            end
        end
    end
    return self
end

--- 设置数值条状底图
---@param path string
---@return self
function _index:textureValue(path)
    if (path) then
        self._textureValue:texture(path)
    end
    return self
end

--- 设置遮罩条状底图
---@param path string
---@return self
function _index:textureMark(path)
    if (path) then
        self._textureMark:texture(path)
    end
    return self
end

--- 设置文本对齐方式
---@param layout number LAYOUT_ALIGN_?
---@param align number TEXT_ALIGN_?
---@return self
function _index:textAlign(layout, align)
    if (layout and align) then
        self["_txt" .. layout]:textAlign(align)
    end
    return self
end

--- 设置文本字号[5-18]
---@param layout number LAYOUT_ALIGN_?
---@param size number
---@return self
function _index:fontSize(layout, size)
    if (layout and size) then
        self["_txt" .. layout]:fontSize(size)
    end
    return self
end

--- 设置文本内容
---@param layout number LAYOUT_ALIGN_?
---@param content number|nil
---@return self
function _index:text(layout, content)
    if (layout and content) then
        self["_txt" .. layout]:text(content)
    end
    return self
end

--- 创建 UI 条
--- 支持 constructs 为初始化可选参数（只会在创建时有效，不会在创建后使用此方法以key获取时生效）
--- [constructs._fdfName][默认 'LK_BACKDROP'] 模版边框(可选) 启用边框时，边框也会算进整体宽高里，自行设置borderOffset调整
--- [constructs._borderOffset][默认 0] 边框模式下的内置位置调整值
--- [constructs._layouts][默认 nil] 方位文本，LAYOUT_ALIGN_* 如 {LAYOUT_ALIGN_LEFT_TOP,LAYOUT_ALIGN_LEFT}
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@param constructs {_fdfName:string,_borderOffset:number,_layouts:number[]}
---@return UIBar
function UIBar(key, parent, constructs)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UIBarClass)
    if (nil == cache[key]) then
        if (type(constructs) ~= "table") then
            constructs = {}
        end
        constructs._key = key
        constructs._parent = parent or UIGame
        constructs._fdfType = "BACKDROP"
        constructs._fdfName = constructs._fdfName or "LK_BACKDROP"
        constructs._borderOffset = constructs._borderOffset or 0
        cache[key] = oUI(constructs, _index)
    end
    return cache[key]
end