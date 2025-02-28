--- 背景UI
---@class UIBackdrop:UI
local _index = UI(UIBackdropClass)

---@protected
function _index:construct()
    if (self._fdfName == "LK_BACKDROP") then
        self:texture(X_UI_NIL)
    end
    -- 阻挡器
    self._blocker = UIBlock(self._key .. ":block", self, { _blocking = false })
        :relation(UI_ALIGN_CENTER, self, UI_ALIGN_CENTER, 0, 0)
end

--- 设置宽高尺寸[0-0.8,0-0.6]
--- blocker自动跟随
---@param width number
---@param height number
---@return self
function _index:size(width, height)
    if (nil ~= width and nil ~= height) then
        class.super(_index).size(self, width, height)
        if (nil ~= self._blocker) then
            self._blocker:size(width, height)
        end
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

--- 设置阻碍状态
---@param status boolean
---@return self
function _index:block(status)
    if (type(status) == "boolean") then
        self._blocker:block(status)
    end
    return self
end

--- 构造UI背景图对象
--- 支持 constructs 为初始化可选参数（只会在创建时有效，不会在创建后使用此方法以key获取时生效）
--- [constructs._fdfName][默认 'LK_BACKDROP'] 改用某个fdf模版
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@param constructs {_fdfName:string}
---@return UIBackdrop
function UIBackdrop(key, parent, constructs)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UIBackdropClass)
    if (nil == cache[key]) then
        if (type(constructs) ~= "table") then
            constructs = {}
        end
        constructs._key = key
        constructs._parent = parent or UIGame
        constructs._fdfType = "BACKDROP"
        constructs._fdfName = constructs._fdfName or "LK_BACKDROP"
        cache[key] = oUI(constructs, _index)
    end
    return cache[key]
end