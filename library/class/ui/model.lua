--- 模型UI
---@class UIModel:UI
local _index = UI(UIModelClass, {
    _autoCast = true,
})

---@protected
function _index:destruct()
    class.cache(UIModelClass)[self._key] = nil
end

--- 设置模型
---@param path string 模型路径
---@return self
function _index:model(path)
    if (nil ~= path and self._model ~= path) then
        self._model = path
        path = japi.AssetsModel(path)
        japi.DZ_FrameSetModel(self._handle, path, 0, 0)
    end
    return self
end

--- 设置动画
---@param animateId string 动画ID
---@param autoCast boolean 是否自动播放
---@return self
function _index:animate(animateId, autoCast)
    if (type(animateId) == "string" and type(autoCast) == "boolean") then
        self._animateId = animateId
        self._autoCast = autoCast
        japi.DZ_FrameSetAnimate(self._handle, animateId, autoCast)
    end
    return self
end

--- 构造UI模型对象
---@param key string 索引名
---@param parent UI|nil 默认 UI_Game
---@return UIModel
function UIModel(key, parent)
    must(type(key) == "string", "key@string")
    local cache = class.cache(UIModelClass)
    if (nil == cache[key]) then
        cache[key] = oUI({
            _key = key,
            _parent = parent or UIGame,
            _fdfName = "LK_MODEL",
            _fdfType = "SPRITE"
        }, _index)
    end
    return cache[key]
end