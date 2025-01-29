--- 按钮UI
---@class UIButton:UI
local _index = UI(UIButtonClass, {
    ---@type number 边框宽拉伸度
    _borderScaleWidth = 1,
    ---@type number 边框高拉伸度
    _borderScaleHeight = 1,
    ---@type number 遮罩值
    _maskRatio = 0,
})

---@protected
function _index:construct()
    self:texture(X_UI_NIL)
    -- 高亮
    if (type(self._highlightFdfName) == "string") then
        self._highlight = UIHighlight(self._key .. ':hl', self, { _fdfName = self._highlightFdfName })
            :relation(UI_ALIGN_CENTER, self, UI_ALIGN_CENTER, 0, 0)
            :show(false)
        self:onEvent(eventKind.uiLeave, "lk_highlight", function()
            self._highlight:show(false)
        end)
        self:onEvent(eventKind.uiEnter, "lk_highlight", function()
            if (self._maskRatio > 0) then
                return
            end
            self._highlight:show(true)
        end)
        self._highlightFdfName = nil
    end
    -- 边框
    if (false ~= self._hasBorder) then
        self._border = UIBackdrop(self._key .. ':border', self)
            :relation(UI_ALIGN_CENTER, self, UI_ALIGN_CENTER, 0, 0)
        self._hasBorder = nil
    end
    -- 遮罩
    if (false ~= self._hasMark) then
        self._mask = UIBackdrop(self._key .. ':mask', self)
            :relation(UI_ALIGN_BOTTOM, self, UI_ALIGN_BOTTOM, 0, 0)
            :show(false)
        self._hasMark = nil
    end
    -- 阻碍
    self._blocker = UIBlock(self._key .. ':block', self)
        :relation(UI_ALIGN_CENTER, self, UI_ALIGN_CENTER, 0, 0)
    -- 主文本（默认在中间）
    self._text = UIText(self._key .. ':text', self)
        :relation(UI_ALIGN_CENTER, self, UI_ALIGN_CENTER, 0, 0)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(8)
    -- 热键文本（默认在按钮正下方，如需要可使用 self._hotkey:relation 手动修改）
    self._hotkey = UIText(self._key .. ':hk', self)
        :relation(UI_ALIGN_BOTTOM, self, UI_ALIGN_BOTTOM, 0, -0.01)
        :textAlign(TEXT_ALIGN_CENTER)
        :fontSize(10)
end

---@protected
function _index:destruct()
    class.cache(UIButtonClass)[self._key] = nil
    class.destroy(self._borderTimer)
    self._borderTimer = nil
end

--- 设置宽高尺寸[0-0.8,0-0.6]
--- highlight、border、blocker自动跟随
---@param width number
---@param height number
---@return self
function _index:size(width, height)
    if (nil ~= width and nil ~= height) then
        class.super(_index).size(self, width, height)
        self._blocker:size(width, height)
        if (nil ~= self._highlight) then
            self._highlight:size(width, height)
        end
        if (nil ~= self._border) then
            self._border:size(width * self._borderScaleWidth, height * self._borderScaleHeight)
        end
        self:maskRatio(self._maskRatio) -- 刷新遮罩状态
    end
    return self
end

--- 设置贴图
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

--- 设置边框贴图
---@param path string|string[]
---@param frames number integer 贴图刷新帧率，当path为贴图组时有效
---@return self
function _index:border(path, frames)
    if (nil ~= self._border) then
        class.destroy(self._borderTimer)
        self._borderTimer = nil
        if (type(path) == "string") then
            self._border:texture(path)
        elseif (type(path) == "table" and #path > 0) then
            self._border:texture(path[1])
            self._borderIdx = 1
            local _fresh = function()
                self._borderIdx = self._borderIdx + 1
                if (self._borderIdx > #path) then
                    self._borderIdx = 1
                end
                self._border:texture(path[self._borderIdx])
            end
            if (self:isShow()) then
                async.loc(function()
                    self._borderTimer = async.setInterval(frames or 1, _fresh)
                end)
            end
            ---@param evtData eventOnUIHide
            self:onEvent(eventKind.uiHide, "lk_border", function(evtData)
                class.destroy(evtData.triggerUI._borderTimer)
                evtData.triggerUI._borderTimer = nil
            end)
            ---@param evtData eventOnUIShow
            self:onEvent(eventKind.uiShow, "lk_border", function(evtData)
                evtData.triggerUI._borderTimer = async.setInterval(frames or 1, _fresh)
            end)
        end
    end
    return self
end

--- 设置边框透明度
---@param alpha string
---@return self
function _index:borderAlpha(alpha)
    if (nil ~= self._border) then
        if (nil ~= alpha) then
            self._border:alpha(alpha)
        end
    end
    return self
end

--- 设置边框宽高拉伸度
---@param width number 默认1
---@param height number 默认1
---@return self
function _index:borderScale(width, height)
    if (nil ~= self._border) then
        if (type(width) == "number") then
            self._borderScaleWidth = width
        end
        if (type(height) == "number") then
            self._borderScaleHeight = height
        end
        self._border:size(self._width * self._borderScaleWidth, self._height * self._borderScaleHeight)
    end
    return self
end

--- 设置遮罩贴图
---@param path string|string[]
---@return self
function _index:mask(path)
    if (nil ~= self._mask) then
        if (type(path) == "string") then
            self._maskTexture = path
            self._maskIdx = nil
            self._mask:texture(path)
        elseif (type(path) == "table") then
            self._maskTexture = path
            self._maskIdx = 1
            self._mask:size(self._width, self._height)
            self._mask:texture(path[1])
        end
    end
    return self
end

--- 设置遮罩透明度
---@param alpha number
---@return self
function _index:maskAlpha(alpha)
    if (nil ~= self._mask) then
        self._mask:alpha(alpha)
    end
    return self
end

--- 设置遮罩值
---@param value number 取值范围[0.00-1.00]
---@return self
function _index:maskRatio(value)
    if (nil ~= self._mask and nil ~= value) then
        local w, h = self._width, self._height
        if (value <= 0) then
            self._mask:show(false)
        elseif (nil ~= w) then
            if (nil == self._maskIdx) then
                self._mask:size(w, h * value)
            else
                local l = #self._maskTexture
                local i = math.min(l, math.ceil(value * l))
                i = math.max(1, i)
                self._mask:texture(self._maskTexture[i])
            end
            self._mask:show(true)
        end
        self._maskRatio = value
    end
    return self
end

--- 设置主文本内容
---@param content string
---@return self
function _index:text(content)
    if (nil ~= content) then
        self._text:text(content)
    end
    return self
end

--- 设置主文本字号[5-18]
---@param size number
---@return self
function _index:fontSize(size)
    if (type(size) == "number") then
        self._text:fontSize(size)
    end
    return self
end

--- 设置热键键值和回调
---@param keycode number 如 keyboard.code["G"]
---@param call function 可设为false强制取消回调
---@return self
function _index:hotkey(keycode, call)
    if (type(keycode) == "number") then
        local keyName = keyboard.i2s(keycode)
        self._hotkey:text(keyName)
        local key = "lk_bhk_" .. self._id
        if (false == call) then
            keyboard.onPress(keycode, key, nil)
            keyboard.onRelease(keycode, key, nil)
        elseif (keyName ~= '' and type(call) == "function") then
            local f
            f = function()
                keyboard.onPress(keycode, key, nil)
                keyboard.onRelease(keycode, key, function()
                    keyboard.onPress(keycode, key, f)
                end)
                if (japi.IsLongPressing("keyboard")) then
                    return
                end
                call()
            end
            keyboard.onRelease(keycode, key, nil)
            keyboard.onPress(keycode, key, f)
        end
    end
    return self
end

--- 设置热键字号[5-18]
---@param size number
---@return self
function _index:hotkeyFontSize(size)
    if (type(size) == "number") then
        self._hotkey:fontSize(size)
    end
    return self
end

--- 设置热键锚点
--- 热键默认在主体正下方，一般不用改位置
---@param point number integer 参考 blizzard:^UI_ALIGN_*
---@param upperPoint number 以 align-> alignUpper 对齐
---@param x number 锚点X
---@param y number 锚点Y
---@return self
function _index:hotkeyRelation(point, upperPoint, x, y)
    if (nil ~= point and nil ~= upperPoint and nil ~= x and nil ~= y) then
        self._hotkey:relation(point, self, upperPoint, x, y)
    end
    return self
end

--- 构造UI按钮对象
--- 支持 constructs 为初始化可选参数（只会在创建时有效，不会在创建后使用此方法以key获取时生效）
--- [constructs._fdfName][默认 'LK_BACKDROP'] 改用某个fdf模版（按钮）
--- [constructs._highlightFdfName][默认 'LK_HIGHLIGHT_HUMAN_CONSOLE'] 改用某个高亮fdf模版，可设为false关闭高亮
--- [constructs._hasBorder][默认 true] 可设为false关闭边框
--- [constructs._hasMark][默认 true] 可设为false关闭遮罩
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@param constructs {_fdfName:string,_highlightFdfName:string|boolean,_hasBorder:boolean,_hasMark:boolean}
---@return UIButton
function UIButton(key, parent, constructs)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UIButtonClass)
    if (nil == cache[key]) then
        if (type(constructs) ~= "table") then
            constructs = {}
        end
        constructs._key = key
        constructs._parent = parent or UIGame
        constructs._fdfType = "BACKDROP"
        constructs._fdfName = constructs._fdfName or "LK_BACKDROP"
        if (constructs._highlightFdfName ~= nil and type(constructs._highlightFdfName) ~= "string") then
            constructs._highlightFdfName = nil
        else
            constructs._highlightFdfName = constructs._highlightFdfName or "LK_HIGHLIGHT_HUMAN_CONSOLE"
        end
        cache[key] = oUI(constructs, _index)
    end
    return cache[key]
end