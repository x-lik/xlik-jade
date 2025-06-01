--- current class name
UIPlateClass = "UIPlate"

--- 面板UI
--- 支持esc、close的Backdrop
--- esc 指面板打开后支持按Esc键将以出栈的方式隐藏面板
--- close 指面板右上角带有关闭按钮
---[[:use library/class/ui/backdrop]]
---@class UIPlate:UIBackdrop
local _index = UI(UIPlateClass, {
    -----@type boolean 支持esc关闭状态状态
    _esc = false,
}):extend(UIBackdropClass)

---@protected
function _index:construct()
    local closer = UIButton(self._key .. 'Closer', self, { highlightFdfName = self._closerHighlightFdfName })
    closer:texture(self._closerTexture)
    self._closerHighlightFdfName = nil
    self._closerTexture = nil
    closer:onEvent(eventKind.uiLeftClick, function()
        self:show(false)
        sound.vcm("war3_MouseClick2")
    end)
    closer:show(false)
    self._closer = closer
end

---@protected
function _index:destruct()
    class.destroy(self._closer)
    self._closer = nil
end

--- 设定ESC隐藏功能绑定
---@param status boolean|nil 开启|关闭
---@return self
function _index:esc(status)
    if (type(status) == "boolean" and self._esc ~= status) then
        self._esc = status
        if (true == status and self:isShow()) then
            japi.UISetEsc(self:id(), self)
        else
            japi.UISetEsc(self:id(), nil)
        end
    end
    return self
end

--- 设定关闭功能按钮绑定
---@param enable boolean
---@param size number
---@param side string|'left'|'right'
---@param texture string
---@return self
function _index:closer(enable, size, side, texture)
    local c = self._closer
    if (true == enable) then
        side = side or "right"
        size = size or 0.02
        texture = texture or "interfaces/iconClose"
        if (side == "left") then
            c:relation(UI_ALIGN_LEFT_TOP, self, UI_ALIGN_LEFT_TOP, -size / 4, size / 4)
        else
            c:relation(UI_ALIGN_RIGHT_TOP, self, UI_ALIGN_RIGHT_TOP, size / 4, size / 4)
        end
        c:size(size, size):texture(texture)
    end
    c:show(enable)
    return self
end

--- 构造UI面板对象
--- 支持 constructs 为初始化可选参数（只会在创建时有效，不会在创建后使用此方法以key获取时生效）
--- [constructs._fdfName][默认 'LK_BACKDROP'] 改用某个fdf模版
--- [constructs._closerTexture][默认 'interfaces/iconClose'] 关闭按钮贴图
--- [constructs._closerHighlightFdfName][默认 'LK_HIGHLIGHT_HUMAN_QUEST'] 关闭按钮高亮fdf模版
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@param constructs {_fdfName:string,_closerTexture:string,_closerHighlightFdfName:string}
---@return UIPlate
function UIPlate(key, parent, constructs)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UIPlateClass)
    if (nil == cache[key]) then
        if (type(constructs) ~= "table") then
            constructs = {}
        end
        constructs._key = key
        constructs._parent = parent or UIGame
        constructs._fdfType = "BACKDROP"
        constructs._fdfName = constructs._fdfName or "LK_BACKDROP"
        constructs._closerTexture = constructs._closerTexture or "interfaces/iconClose"
        constructs._closerHighlightFdfName = constructs._closerHighlightFdfName or "LK_HIGHLIGHT_HUMAN_QUEST"
        cache[key] = oUI(constructs, _index)
    end
    return cache[key]
end