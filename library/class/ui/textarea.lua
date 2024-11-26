--- 文本域UI
---@class UITextarea:UIText
local _index = UI(UITextareaClass):extend(UITextClass)

---@protected
function _index:destruct()
    class.cache(UITextareaClass)[self._key] = nil
end

--- 创建 UI 文本域
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@return UITextarea
function UITextarea(key, parent)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UITextClass)
    if (nil == cache[key]) then
        cache[key] = oUI({
            _key = key,
            _parent = parent or UIGame,
            _fdfName = "LK_TEXTAREA",
            _fdfType = "TEXTAREA"
        }, _index)
    end
    return cache[key]
end