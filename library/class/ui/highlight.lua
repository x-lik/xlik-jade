--- 高亮UI
---@class UIHighlight:UI
local _index = UI(UIHighlightClass)

---@private
function _index:destruct()
    class.cache(UIHighlightClass)[self._key] = nil
end

--- 创建 UI 高亮
--- 支持 constructs 为初始化可选参数（只会在创建时有效，不会在创建后使用此方法以key获取时生效）
--- [constructs._fdfName][默认 'LK_HIGHLIGHT_HUMAN_CONSOLE'] 改用某个fdf模版
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@param constructs {_fdfName:string}
---@return UIHighlight
function UIHighlight(key, parent, constructs)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UIHighlightClass)
    if (nil == cache[key]) then
        if (type(constructs) ~= "table") then
            constructs = {}
        end
        constructs._key = key
        constructs._parent = parent or UIGame
        constructs._fdfType = "HIGHLIGHT"
        constructs._fdfName = constructs._fdfName or "LK_HIGHLIGHT_HUMAN_CONSOLE"
        cache[key] = oUI(constructs, _index)
    end
    return cache[key]
end