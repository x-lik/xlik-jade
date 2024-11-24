--- 文本UI
---@class UIText:UI
local _index = UI(UITextClass, {
    ---@type string
    _content = '',
    ---@type number 文本字数限制，小于等于0不限制
    _textSizeLimit = 0,
    ---@type number 文本对齐
    _textAlign = TEXT_ALIGN_CENTER,
    ---@type number 字体大小
    _fontSize = 10,
})

---@protected
function _index:construct()
    japi.DZ_FrameSetFont(self._handle, 'fonts.ttf', self._fontSize * 0.001, 0)
    japi.DZ_FrameSetTextAlignment(self._handle, self._textAlign)
end

---@private
function _index:destruct()
    class.cache(UITextClass)[self._key] = nil
end

--- 设置文本对齐方式
---@param align number TEXT_ALIGN?
---@return self
function _index:textAlign(align)
    if (type(align) == "number" and self._textAlign ~= align) then
        self._textAlign = align
        japi.DZ_FrameSetTextAlignment(self._handle, align)
    end
    return self
end

--- 设置文本颜色
--- 可用colour.hex代替
---@param color number
---@return self
function _index:textColor(color)
    if (type(color) == "number" and self._textColor ~= color) then
        self._textColor = color
        japi.DZ_FrameSetTextColor(self._handle, color)
    end
    return self
end

--- 设置文本字数限制
---@param limit number
---@return self
function _index:textSizeLimit(limit)
    if (type(limit) == "number" and self._textSizeLimit ~= limit) then
        if (limit > 0) then
            japi.DZ_FrameSetText(self._handle, mbstring.sub(self._content, 1, limit))
        else
            japi.DZ_FrameSetText(self._handle, self._content)
        end
        self._textSizeLimit = limit
    end
    return self
end

--- 设置文本字号[5-18]
---@param size number
---@return self
function _index:fontSize(size)
    if (type(size) == "number" and self._fontSize ~= size) then
        self._fontSize = size
        size = math.max(5, size)
        size = math.min(18, size)
        japi.DZ_FrameSetFont(self._handle, 'fonts.ttf', size * 0.001, 0)
    end
    return self
end

--- 文本内容
---@param content string
---@return self
function _index:text(content)
    if (nil ~= content and self._content ~= content) then
        self._content = content
        local ct = tostring(content)
        local limit = self._textSizeLimit
        if (limit > 0) then
            ct = mbstring.sub(ct, 1, limit)
        end
        japi.DZ_FrameSetText(self._handle, ct)
    end
    return self
end

--- 创建 UI 文本
--- 支持 constructs 为初始化可选参数（只会在创建时有效，不会在创建后使用此方法以key获取时生效）
--- [constructs._fdfName][默认 'LK_TEXT'] 改用某个fdf模版
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@param constructs {_fdfName:string}
---@return UIText
function UIText(key, parent, constructs)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UITextClass)
    if (nil == cache[key]) then
        if (type(constructs) ~= "table") then
            constructs = {}
        end
        constructs._key = key
        constructs._parent = parent or UIGame
        constructs._fdfType = "TEXT"
        constructs._fdfName = constructs._fdfName or "LK_TEXT"
        cache[key] = oUI(constructs, _index)
    end
    return cache[key]
end

---@see alerter#message
--- 生成一个Text供alerter使用
game.onPhase("start", function()
    UITextAlerterMessage = UIText("lk_alerter_message", UIGame)
        :relation(UI_ALIGN_BOTTOM, UIGame, UI_ALIGN_BOTTOM, 0, 0.15)
        :fontSize(13)
        :textAlign(TEXT_ALIGN_CENTER)
        :text('')
end)