--- 阻碍UI
---@class UIBlock:UI
local _index = UI(UIBlockClass, {
    ---@type boolean 是否开启阻碍中
    _blocking = true,
})

---@protected
function _index:construct()
    if (true == self._blocking) then
        Pool(UIBlockClass):insert(self)
    else
        self:show(false)
    end
end

---@protected
function _index:destruct()
    class.cache(UIBlockClass)[self._key] = nil
    if (true == self._blocking) then
        Pool(UIBlockClass):remove(self)
    end
end

--- 设置阻碍状态
---@param status boolean
---@return self
function _index:block(status)
    if (type(status) == "boolean" and self._blocking ~= status) then
        self._blocking = status
        if (status) then
            Pool(UIBlockClass):insert(self)
        else
            Pool(UIBlockClass):remove(self)
        end
        self:show(status)
    end
    return self
end

--- 构造UI阻挡器对象
--- 支持 constructs 为初始化可选参数（只会在创建时有效，不会在创建后使用此方法以key获取时生效）
--- [constructs._blocking][默认 true] 阻碍状态
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@param constructs {_blocking:boolean}
---@return UIBlock
function UIBlock(key, parent, constructs)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UIBlockClass)
    if (nil == cache[key]) then
        if (type(constructs) ~= "table") then
            constructs = {}
        end
        constructs._key = key
        constructs._parent = parent or UIGame
        constructs._fdfType = "TEXT"
        constructs._fdfName = "LK_BLOCK"
        cache[key] = oUI(constructs, _index)
    end
    return cache[key]
end