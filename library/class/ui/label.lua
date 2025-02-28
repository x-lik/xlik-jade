--- 标签UI
---@class UILabel:UI
local _index = UI(UILabelClass, {
    _autoSize = false,
})

---@protected
function _index:construct()
    self:texture(X_UI_NIL)
    -- 图标
    self._icon = UIBackdrop(self._key .. ':icon', self)
    -- 行文
    self._label = UIText(self._key .. ':label', self)
        :textAlign(TEXT_ALIGN_LEFT)
        :fontSize(10)
    self:side(LAYOUT_ALIGN_LEFT)
    -- 自动尺寸
    if (true == self._autoSize) then
        self:size()
    end
end

--- 设置主题宽高尺寸[0-0.8,0-0.6]
--- 这里icon的尺寸跟随主题而变化
--- 只有autoSize不为true时可设置
--- 因为autoSize为true时，主题和icon的尺寸跟随label而变化
---@param width number
---@param height number
---@return self
function _index:size(width, height)
    if (true ~= self._autoSize) then
        if (nil ~= width and nil ~= height) then
            self._icon:size(height, height)
            class.super(_index).size(self, width, height)
        end
    elseif (nil ~= self._label) then
        local tw = self._textWidth or vistring.width(self._label._content, self._label._fontSize)
        local th = vistring.height(1, self._label._fontSize)
        local iw = th -- 图标宽度与高度一致
        if (true ~= self._adaptive) then
            iw = iw * 0.75
        end
        self._icon:size(th, th)
        self._label:size(tw, th)
        class.super(_index).size(self, iw + tw + 0.001, th)
    end
    return self
end

--- 设置格式侧偏
--- 图标只有左和右两种，默认左[LAYOUT_ALIGN_LEFT]
--- 可以设置文本的align改变文本的对齐从而改变icon的偏移，它们总是同侧的
---@param align number LAYOUT_ALIGN_LEFT|LAYOUT_ALIGN_RIGHT|LAYOUT_ALIGN_LEFT_TOP|LAYOUT_ALIGN_RIGHT_TOP|LAYOUT_ALIGN_LEFT_BOTTOM|LAYOUT_ALIGN_RIGHT_BOTTOM 文本的align
---@return self
function _index:side(align)
    if (type(align) == "number" and align ~= self._side) then
        local ct = self._icon
        if (align == LAYOUT_ALIGN_LEFT) then
            ct:relation(UI_ALIGN_LEFT, self, UI_ALIGN_LEFT, 0, 0)
            self._label:relation(UI_ALIGN_LEFT, ct, UI_ALIGN_RIGHT, 0.002, 0)
        elseif (align == LAYOUT_ALIGN_RIGHT) then
            ct:relation(UI_ALIGN_RIGHT, self, UI_ALIGN_RIGHT, 0, 0)
            self._label:relation(UI_ALIGN_RIGHT, ct, UI_ALIGN_LEFT, -0.002, 0)
        elseif (align == LAYOUT_ALIGN_LEFT_TOP) then
            ct:relation(UI_ALIGN_LEFT, self, UI_ALIGN_LEFT, 0, 0)
            self._label:relation(UI_ALIGN_LEFT_TOP, ct, UI_ALIGN_RIGHT_TOP, 0.002, -0.001)
        elseif (align == LAYOUT_ALIGN_RIGHT_TOP) then
            ct:relation(UI_ALIGN_RIGHT, self, UI_ALIGN_RIGHT, 0, 0)
            self._label:relation(UI_ALIGN_RIGHT_TOP, ct, UI_ALIGN_LEFT_TOP, -0.002, -0.001)
        elseif (align == LAYOUT_ALIGN_LEFT_BOTTOM) then
            ct:relation(UI_ALIGN_LEFT, self, UI_ALIGN_LEFT, 0, 0)
            self._label:relation(UI_ALIGN_LEFT_BOTTOM, ct, UI_ALIGN_RIGHT_BOTTOM, 0.002, 0.001)
        elseif (align == LAYOUT_ALIGN_RIGHT_BOTTOM) then
            ct:relation(UI_ALIGN_RIGHT, self, UI_ALIGN_RIGHT, 0, 0)
            self._label:relation(UI_ALIGN_RIGHT_BOTTOM, ct, UI_ALIGN_LEFT_BOTTOM, -0.002, 0.001)
        end
        self._side = align
    end
    return self
end

--- 设置主体背景贴图
---@param path string
---@return self
function _index:texture(path)
    if (nil ~= path and self._texture ~= path) then
        self._texture = path
        path = japi.AssetsUI(self._kit, path, "image")
        japi.DZ_FrameSetTexture(self._handle, path, 0)
    end
    return self
end

--- 设置图标贴图
---@param path string
---@return self
function _index:icon(path)
    if (path) then
        self._icon:texture(path)
    end
    return self
end

--- 设置文本对齐方式
---@param align number
---@return self
function _index:textAlign(align)
    if (nil ~= align) then
        self._label:textAlign(align)
    end
    return self
end

--- 设置文本宽度
--- 强行设置文本宽度
---@param width number
---@return self
function _index:textWidth(width)
    self._textWidth = width
    self._label:size(width, vistring.height(1, self._label._fontSize))
    return self
end

--- 设置文本字号[5-18]
---@param size number
---@return self
function _index:fontSize(size)
    if (size ~= self._fontSize) then
        self._fontSize = size
        self._label:fontSize(size)
        self:size()
    end
    return self
end

--- 设置文本内容
---@param content string
---@return self
function _index:text(content)
    if (content ~= self._content) then
        self._label:text(content)
        self._content = content
        self:size()
    end
    return self
end

--- 构造UI标签对象
--- 支持 constructs 为初始化可选参数（只会在创建时有效，不会在创建后使用此方法以key获取时生效）
--- [constructs._autoSize][默认 false] 是否自动尺寸(以文本尺寸为准)
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@param constructs {_autoSize:boolean}
---@return UILabel
function UILabel(key, parent, constructs)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UILabelClass)
    if (nil == cache[key]) then
        if (type(constructs) ~= "table") then
            constructs = {}
        end
        constructs._key = key
        constructs._parent = parent or UIGame
        constructs._fdfType = "BACKDROP"
        constructs._fdfName = constructs._fdfName or "LK_BACKDROP"
        constructs._autoSize = constructs._autoSize or false
        cache[key] = oUI(constructs, _index)
    end
    return cache[key]
end