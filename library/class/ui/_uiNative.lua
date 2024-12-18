--- 魔兽原生ui视图对象
--- 适用于编辑、展示原生界面的对象
--- UI事件不适用，大部分UI方法也无效
---@class UINative
local _index = { _type = "UI", _native = true }

--- 获取handle
---@return number
function _index:handle()
    return self._handle
end

--- 获取UI的key
---@return any
function _index:key()
    return self._key
end

--- 获取锚
--- 记录从屏幕左下角为原点的[偏移XY，宽高]
---@return anchorFourData
function _index:anchor()
    return self._anchor
end

--- 所有子节点
---@return table<string,UI>
function _index:children()
    return self._children
end

--- 设置透明度
---@param alpha number
---@return self
function _index:alpha(alpha)
    if (isUIGame(self)) then
        return
    end
    japi.DZ_FrameSetAlpha(self._handle, alpha)
    return self
end

--- 设置宽高尺寸[0-0.8,0-0.6]
---@param w number
---@param h number
---@return self
function _index:size(w, h)
    if (isUIGame(self)) then
        return
    end
    japi.DZ_FrameSetSize(self._handle, w, h)
    return self
end

--- 设置相对锚点
---@param point number integer 参考 blizzard:^UI_ALIGN_*
---@param relativeFrame UI 相对节点ID(def:UIGame)
---@param relativePoint number 以 align-> alignUpper 对齐
---@param x number 锚点X
---@param y number 锚点Y
---@return self
function _index:relation(point, relativeFrame, relativePoint, x, y)
    if (isUIGame(self) or relativeFrame == self) then
        return
    end
    if (nil ~= point and nil ~= relativeFrame and nil ~= relativePoint and nil ~= x and nil ~= y) then
        japi.DZ_FrameClearAllPoints(self._handle)
        japi.DZ_FrameSetPoint(self._handle, point, relativeFrame:handle(), relativePoint, x, y)
    end
    return self
end

--- 设置绝对锚点
---@param point number
---@param x number
---@param y number
---@return self
function _index:absolut(point, x, y)
    if (isUIGame(self)) then
        return
    end
    return self:relation(point, UIGame, point, x, y)
end

--- 显示
---@param status boolean
---@return void
function _index:show(status)
    if (isUIGame(self)) then
        return
    end
    japi.DZ_FrameShow(self._handle, status)
end

--- UI原生接管
---@param name string 唯一UI名
---@param handle number
---@return UINative
function UINative(name, handle)
    sync.must()
    must(type(name) == "string", "name@string")
    local cache = class.cache(_index._type)
    if (nil == cache[name]) then
        cache[name] = setmetatable({ _className = name, _key = name, _handle = handle }, { __index = _index })
    end
    return cache[name]
end

--- 游戏UI对象
UIGame = UINative("Game", japi.DZ_GetGameUI())
UIGame._children = {} -- 子UI
UIGame._lowNodes = {} -- 子节点
UIGame._adaptive = false -- 自适应
UIGame._width = 0.8 -- 宽
UIGame._height = 0.6 -- 高
UIGame._anchor = { 0.4, 0.3, 0.8, 0.6 } -- 主屏锚点

--- 是否游戏UI对象
---@param whichUI UINative
---@return boolean
function isUIGame(whichUI)
    return nil ~= whichUI and true == whichUI._native and whichUI._handle == UIGame._handle
end