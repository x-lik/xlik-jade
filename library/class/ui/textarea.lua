--- current class name
UITextareaClass = "UITextarea"

--- 文本域UI
---[[:use library/class/ui/text]]
---@class UITextarea:UIText
local _index = UI(UITextareaClass):extend(UITextClass)

--- 构造UI文本域对象
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