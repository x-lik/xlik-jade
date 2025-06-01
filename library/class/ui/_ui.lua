--- 自定义UI视图类对象结构
--- 适用于编辑、展示界面的对象
--- UI分为Native型和非Native(自实现)型
---@class UI
local _index = {
    _type = "UI", _native = false,
    ---@type string fdf名称
    _fdfName = nil,
    ---@type string fdf类型
    _fdfType = nil,
    ---@type number
    _handle = nil,
    ---@type string ID
    _id = nil,
    ---@type string 绑定套件
    _kit = nil,
    ---@type UI
    _parent = nil,
    ---@type table<string,UI>
    _children = nil,
    ---@type boolean
    _adaptive = false,
    ---@type number
    _alpha = 255,
    ---@type number 设定宽度
    _width = 0,
    ---@type number 设定高度
    _height = 0,
    ---@type number 自适应后宽度
    _adaptiveWidth = 0,
    ---@type number 自适应后高度
    _adaptiveHeight = 0,
    ---@type boolean 显示状态
    _show = true,
    ---@type number 自相对位置绑定点
    _point = nil,
    ---@type UI 上相对位置UI（上级相对节点）
    _upNode = nil,
    ---@type number 上相对位置绑定点
    _upNodePoint = nil,
    ---@type Array 下级相对节点
    _lowNodes = nil,
    ---@type number 相对位置锚点x
    _x = nil,
    ---@type number 相对位置锚点y
    _y = nil,
    ---@type TimerAsync
    _gradientTimer = nil,
}

--- 继承
---@protected
---@param superName string
---@return self
function _index:extend(superName)
    must(type(superName) == "string", "superName@string")
    local cache = class.cache(_index._type)
    must(cache[superName] ~= nil, self._className .. " extended super does not exist")
    setmetatable(self, { __index = cache[superName] })
    return self
end

---@protected
function _index:destruct()
    sync.must()
    japi.UISetAdaptive(self._id, nil)
    -- 清理事件
    local events = event.get("async", self)
    if (type(events) == "table") then
        ---@param v Array
        for evt, v in pairx(events) do
            v:backEach(function(key)
                japi.UIEvent2Mouse(self, evt, true)
            end)
        end
    end
    local c = self._children
    if (type(c) == "table") then
        for k, v in pairx(c) do
            c[k] = nil
            class.destroy(v)
        end
    end
    self._children = nil
    local parent = self._parent
    if (nil ~= parent) then
        local pc = parent._children
        if (type(pc) == "table") then
            pc[self._id] = nil
        end
    end
    self._parent = nil
    self._upNode = nil
    self._lowNodes = nil
    class.destroy(self._gradientTimer)
    self._gradientTimer = nil
    japi.DZ_DestroyFrame(self._handle)
    self._handle = nil
end

--- 获取UI使用的fdf名称
---@return string
function _index:fdfName()
    return self._fdfName
end

--- 获取UI使用的fdf类型
---@return string
function _index:fdfType()
    return self._fdfType
end

--- 获取UI的key
--- cache key
--- key将以:号(冒号)分割字符串，第一个字串段自动定位套件kit
---@return any
function _index:key()
    return self._key
end

--- 获取handle
---@return number
function _index:handle()
    return self._handle
end

--- 获取对象ID
---@return number
function _index:id()
    return self._id
end

--- 获取UI的kit名
--- 由:号(冒号)分割切段字符组时，自动对应kit，如 key 是 xlik_debug 或 xlik_debug:myBar 或 xlik_debug:myBar:3 ，这3种自动对应套件 kit 都是 xlik_debug
--- tooltips的lik一般在content方法调用时动态设置
---@return number
function _index:kit()
    return self._kit
end

--- 重置UI的锚点数据
--- 锚指的是一个UI的中心，相对于屏幕左下角的{RX,RY,W,H}
---@private
---@alias anchorFourData number[]
---@return anchorFourData
function _index:resetAnchor()
    local point = self._point
    local upper = self._upNode
    local upperPoint = self._upNodePoint
    local x = self._xAdaptive
    local y = self._y
    local width = self._widthAdaptive
    local height = self._height
    if (nil ~= upper and nil ~= width) then
        local upperAnchor = upper:anchor()
        if (nil ~= upperAnchor) then
            -- 偏移度
            local aw, ah, pw, ph
            if (point == UI_ALIGN_LEFT_TOP or point == UI_ALIGN_LEFT or point == UI_ALIGN_LEFT_BOTTOM) then
                aw = 1
            elseif (point == UI_ALIGN_TOP or point == UI_ALIGN_CENTER or point == UI_ALIGN_BOTTOM) then
                aw = 0
            elseif (point == UI_ALIGN_RIGHT_TOP or point == UI_ALIGN_RIGHT or point == UI_ALIGN_RIGHT_BOTTOM) then
                aw = -1
            end
            if (point == UI_ALIGN_LEFT_TOP or point == UI_ALIGN_TOP or point == UI_ALIGN_RIGHT_TOP) then
                ah = -1
            elseif (point == UI_ALIGN_LEFT or point == UI_ALIGN_CENTER or point == UI_ALIGN_RIGHT) then
                ah = 0
            elseif (point == UI_ALIGN_LEFT_BOTTOM or point == UI_ALIGN_BOTTOM or point == UI_ALIGN_RIGHT_BOTTOM) then
                ah = 1
            end
            if (upperPoint == UI_ALIGN_LEFT_TOP or upperPoint == UI_ALIGN_LEFT or upperPoint == UI_ALIGN_LEFT_BOTTOM) then
                pw = -1
            elseif (upperPoint == UI_ALIGN_TOP or upperPoint == UI_ALIGN_CENTER or upperPoint == UI_ALIGN_BOTTOM) then
                pw = 0
            elseif (upperPoint == UI_ALIGN_RIGHT_TOP or upperPoint == UI_ALIGN_RIGHT or upperPoint == UI_ALIGN_RIGHT_BOTTOM) then
                pw = 1
            end
            if (upperPoint == UI_ALIGN_LEFT_TOP or upperPoint == UI_ALIGN_TOP or upperPoint == UI_ALIGN_RIGHT_TOP) then
                ph = 1
            elseif (upperPoint == UI_ALIGN_LEFT or upperPoint == UI_ALIGN_CENTER or upperPoint == UI_ALIGN_RIGHT) then
                ph = 0
            elseif (upperPoint == UI_ALIGN_LEFT_BOTTOM or upperPoint == UI_ALIGN_BOTTOM or upperPoint == UI_ALIGN_RIGHT_BOTTOM) then
                ph = -1
            end
            must(nil ~= aw and nil ~= ah and nil ~= pw and nil ~= ph, "setAnchor failed")
            local offsetX, offsetY = x, y
            local upperX, upperY, upperW, upperH = upperAnchor[1], upperAnchor[2], upperAnchor[3], upperAnchor[4]
            local anchorX, anchorY
            local anchorW, anchorH = width, height
            local pwHalf = upperW / 2
            local phHalf = upperH / 2
            local awHalf = anchorW / 2
            local ahHalf = anchorH / 2
            anchorX = offsetX + upperX + pw * pwHalf + aw * awHalf
            anchorY = offsetY + upperY + ph * phHalf + ah * ahHalf
            anchorX = math.min(anchorX, 0.8 - awHalf)
            anchorX = math.max(anchorX, awHalf)
            anchorY = math.min(anchorY, 0.6 - ahHalf)
            anchorY = math.max(anchorY, ahHalf)
            self._anchor = { anchorX, anchorY, anchorW, anchorH }
        end
    end
    local lns = self._lowNodes
    if (isArray(lns) and lns:count() > 0) then
        lns:forEach(function(_, c)
            c:resetAnchor()
        end)
    end
end

--- 获取锚
--- 记录从屏幕左下角为原点的(偏移X,偏移Y，宽，高）
--- 数据格式为 {x,y,width,height}
---@return anchorFourData
function _index:anchor()
    return self._anchor
end

--- 获取父节点
---@return UI
function _index:parent()
    return self._parent
end

--- 获取所有子节点
---@return table<string,UI>
function _index:children()
    return self._children
end

--- 获取上级关系节点
---@return UI
function _index:upNode()
    return self._upNode
end

--- 获取所有下级关系节点
---@return Array
function _index:lowNodes()
    return self._lowNodes
end

--- 是否聚焦（焦点）中
---@return boolean
function _index:isFocus()
    return japi.DZ_GetMouseFocus() == self._handle
end

--- 设置自适应[true,false]
---@param status boolean
---@return self
function _index:adaptive(status)
    if (type(status) == "boolean" and self._adaptive ~= status) then
        self._adaptive = status
        if (true == status) then
            japi.UISetAdaptive(self._id, self)
        else
            japi.UISetAdaptive(self._id, nil)
        end
        if (nil ~= self._upNode) then
            self:relation(self._point, self._upNode, self._upNodePoint, self._xAdaptive, self._y)
        end
        if (type(self._width) == "number") then
            self:size(self._widthAdaptive, self._height)
        end
        local child = self._children
        if (type(child) == "table") then
            for _, c in pairx(child) do
                c:adaptive(true)
            end
        end
    end
    return self
end

--- 设置相对锚点
---@param point number integer 参考 blizzard:^UI_ALIGN_*
---@param upperUI UI 相对节点ID(def:UI_Game)
---@param upperPoint number 以 align-> alignUpper 对齐
---@param x number 锚点X
---@param y number 锚点Y
---@return self
function _index:relation(point, upperUI, upperPoint, x, y)
    if (nil ~= point and nil ~= upperUI and nil ~= upperPoint and nil ~= x and nil ~= y) then
        -- exclusion UIGame
        if (upperUI == self) then
            return
        end
        local ax = x
        if (true == self._adaptive) then
            ax = japi.UIAdaptive(x)
        end
        self:gradientStop()
        if (self._upNode ~= upperUI) then
            if (nil ~= self._upNode and false == isUIGame(self._upNode)) then
                local ls = self._upNode._lowNodes
                if (nil ~= ls) then
                    ls:set(self._id, nil)
                end
            end
            if (false == isUIGame(upperUI)) then
                if (nil == upperUI._lowNodes) then
                    upperUI._lowNodes = Array()
                end
                local ls = upperUI._lowNodes
                if (false == ls:keyExists(self._id)) then
                    ls:set(self._id, self)
                end
            end
        end
        japi.DZ_FrameClearAllPoints(self._handle)
        japi.DZ_FrameSetPoint(self._handle, point, upperUI._handle, upperPoint, ax, y)
        self._point = point
        self._upNode = upperUI
        self._upNodePoint = upperPoint
        self._xAdaptive = ax
        self._x = x
        self._y = y
        self:resetAnchor()
    end
    return self
end

--- 设置绝对锚点
---@param point number
---@param x number
---@param y number
---@return self
function _index:absolut(point, x, y)
    return self:relation(point, UIGame, point, x, y)
end

--- 设置透明度[0-255]
---@param alpha number
---@return self
function _index:alpha(alpha)
    if (type(alpha) == "number" and self._alpha ~= alpha) then
        japi.DZ_FrameSetAlpha(self._handle, alpha)
        self._alpha = alpha
    end
    return self
end

--- 设置宽高尺寸[0-0.8,0-0.6]
---@param width number
---@param height number
---@return self
function _index:size(width, height)
    if (type(width) == "number" and type(height) == "number") then
        if (self._width ~= width or self._height ~= height) then
            local aw = width
            if (true == self._adaptive) then
                aw = japi.UIAdaptive(width)
            end
            self:gradientStop()
            self._widthAdaptive = aw
            self._width = width
            self._height = height
            self:resetAnchor()
            japi.DZ_FrameSetSize(self._handle, aw, height)
        end
    end
    return self
end

--- 控制显示|隐藏
---@param status boolean
---@return self
function _index:show(status)
    if (type(status) == "boolean" and self._show ~= status) then
        self._show = status
        japi.DZ_FrameShow(self._handle, status)
        if (true == status) then
            event.asyncTrigger(self, eventKind.uiShow)
        else
            event.asyncTrigger(self, eventKind.uiHide)
        end
        --- only plate
        if (true == self._esc) then
            if (true == status) then
                japi.UISetEsc(self:id(), self)
            else
                japi.UISetEsc(self:id(), nil)
            end
        end
        local _f = nil
        _f = function(o)
            local evtList = event.get("async", o)
            if (type(evtList) == "table") then
                ---@param v Array
                for evt, v in pairx(evtList) do
                    v:backEach(function(key, callFunc)
                        japi.UIEvent2Mouse(o, evt, false == status or type(callFunc) ~= "function")
                    end)
                end
            end
            local child = o:children()
            if (type(child) == "table") then
                for _, c in pairx(child) do
                    _f(c)
                end
            end
        end
        _f(self)
    end
    return self
end

--- 是否显示中
---@return boolean
function _index:isShow()
    local o = self
    local s = o._show
    while (true == s) do
        local p = o._parent
        if (nil == p or p == UIGame) then
            break
        end
        o = p
        s = o._show
        if (false == s) then
            break
        end
    end
    return s
end

--- 本对象事件注册
---@see eventKind
---@param evt string 事件类型字符，参考eventKind
---@vararg string|function 可以填写(function)或(string, function)当有string参数时作为事件的key
---@return self
function _index:onEvent(evt, ...)
    local key, func = datum.keyFunc(...)
    event.asyncRegister(self, evt, key, func)
    japi.UIEvent2Mouse(self, evt, false == self:isShow() or type(func) ~= "function")
    return self
end

--- 设置tooltips回调
--- 可以直接设置静态的content数据
--- 也可以设置回调content数据的回调函数
--- 此tooltips方法直接调用UITooltips(1)，也就是平时最惯用的UITooltips()
--- 此tooltips方法唤出的UITooltips位置根据self定位和尺寸而自动选择，若需要强制定位可自行安排uiLeave|uiEnter事件处理
---@param content TooltipContent|fun(this:self):TooltipContent
---@return self
function _index:tooltips(content)
    if (type(content) == "table" or type(content) == "function") then
        self:onEvent(eventKind.uiLeave, "lk_tlt", function()
            UITooltips():show(false)
        end)
        self:onEvent(eventKind.uiEnter, "lk_tlt", function()
            local con = nil
            if (type(content) == "table") then
                con = content
            elseif (type(content) == "function") then
                con = content(self)
            end
            if (nil == con) then
                return
            end
            local tt = UITooltips()
            tt:content(con)
            local tw, th = tt._widthAdaptive / 2, tt._height / 2
            local ar = self:anchor()
            local rx, ry = ar[1], ar[2]
            if (rx > 0.68 or rx < 0.12) then
                local y = 0
                if ((ry - th) < 0.002) then
                    y = th - ry + 0.002
                elseif ((ry + th) > 0.598) then
                    y = th - 0.602 + ry
                end
                if (rx > 0.68) then
                    tt:relation(UI_ALIGN_RIGHT, self, UI_ALIGN_LEFT, -0.002, y)
                else
                    tt:relation(UI_ALIGN_LEFT, self, UI_ALIGN_RIGHT, 0.002, 0)
                end
            else
                local x = 0
                if (rx - tw < 0.002) then
                    x = tw - rx + 0.002
                elseif (rx + tw > 0.798) then
                    x = -(tw - rx + 0.002)
                end
                if (ry > 0.37) then
                    tt:relation(UI_ALIGN_TOP, self, UI_ALIGN_BOTTOM, x, -0.002)
                else
                    tt:relation(UI_ALIGN_BOTTOM, self, UI_ALIGN_TOP, x, 0.002)
                end
            end
            tt:show(true)
        end)
    else
        self:onEvent(eventKind.uiLeave, "lk_tlt", nil)
        self:onEvent(eventKind.uiEnter, "lk_tlt", nil)
    end
    return self
end

--- UI强制停止匀渐变
---@return void
function _index:gradientStop()
    local t = self._gradientTimer
    if (class.isObject(t, TimerAsyncClass)) then
        class.destroy(t)
        self._gradientTimer = nil
        japi.DZ_FrameClearAllPoints(self._handle)
        if (nil ~= self._upNode) then
            japi.DZ_FrameSetPoint(self._handle, self._point, self._upNode._handle, self._upNodePoint, self._x, self._y)
        end
        if (type(self._widthAdaptive) == "number") then
            japi.DZ_FrameSetSize(self._handle, self._widthAdaptive, self._height)
        end
        japi.DZ_FrameSetAlpha(self._handle, self._alpha)
        japi.DZ_FrameShow(self._handle, self:isShow())
    end
end

--- UI匀渐变
--- 使用渐变开始时会强制显示此UI（不显示等于0效果，没有任何意义）
--- 过程中引起的变化都是临时修改不会改变UI对象的具体数据
--- duration number 渐变时间，最快0.1秒
--- alpha number|1|-1 设1表示逐渐显示，设-1表示逐渐消失
--- x number 坐标偏移量总量
--- y number 坐标偏移量总量
--- size number 尺寸偏移百分比，如30，最终尺寸必定是真实尺寸
---@param options {duration:number,alpha:number,x:number,y:number,size:number}
---@param callback fun(callUI:UI):void 动画结束后回调，可处理隐藏等操作
---@return self
function _index:gradientStart(options, callback)
    self:gradientStop()
    options.duration = math.max(0.1, options.duration or 0.1)
    local step = 10
    local baseAlpha = self._alpha
    local basePoint = self._point
    local baseUpper = self._upNode
    local baseUpperPoint = self._upNodePoint
    local baseX = self._x
    local baseY = self._y
    local baseWidth = self._widthAdaptive
    local baseHeight = self._height
    local dtX = (options.x or 0) / step
    local dtY = (options.y or 0) / step
    local dtA = 0
    local dtW = 0
    local dtH = 0
    if (nil == baseUpper) then
        dtX = 0
        dtY = 0
    end
    local curAlpha = nil
    if (type(options.alpha) == "number") then
        if (options.alpha == 1) then
            curAlpha = 0
            dtA = baseAlpha / step
        elseif (options.alpha == -1) then
            curAlpha = baseAlpha
            dtA = -baseAlpha / step
        end
        if (nil ~= curAlpha) then
            japi.DZ_FrameSetAlpha(self._handle, curAlpha)
        end
    end
    if (type(options.size) == "number" and nil ~= baseWidth) then
        options.size = math.max(options.size, 0)
        options.size = math.min(options.size, 100)
        if (options.size ~= 0) then
            dtW = baseWidth * options.size * 0.01 / step
            dtH = baseHeight * options.size * 0.01 / step
        end
    end
    if (dtX ~= 0 or dtY ~= 0) then
        japi.DZ_FrameClearAllPoints(self._handle)
        japi.DZ_FrameSetPoint(self._handle, basePoint, baseUpper._handle, baseUpperPoint, baseX + dtX * step, baseY + dtY * step)
    end
    if (dtW ~= 0 and dtH ~= 0) then
        japi.DZ_FrameSetSize(self._handle, baseWidth + dtW * step, baseHeight + dtH * step)
    end
    japi.DZ_FrameShow(self._handle, true)
    self._gradientTimer = async.setInterval(options.duration / step * 60, function(_)
        step = step - 1
        if (step <= 0) then
            if (type(callback) == "function") then
                callback(self)
            end
            self:gradientStop()
            return
        end
        if (nil ~= curAlpha) then
            curAlpha = curAlpha + dtA
            japi.DZ_FrameSetAlpha(self._handle, curAlpha)
        end
        if (dtX ~= 0 or dtY ~= 0) then
            japi.DZ_FrameClearAllPoints(self._handle)
            japi.DZ_FrameSetPoint(self._handle, basePoint, baseUpper._handle, baseUpperPoint, baseX + dtX * step, baseY + dtY * step)
        end
        if (dtW ~= 0 and dtH ~= 0) then
            japi.DZ_FrameSetSize(self._handle, baseWidth + dtW * step, baseHeight + dtH * step)
        end
    end)
    return self
end

--- 屏幕相对坐标是否在UI内
---@param rx number 默认鼠标RX
---@param ry number 默认鼠标RY
---@param checkShow boolean 是否检查可见性
---@return boolean
function _index:isInside(rx, ry, checkShow)
    if (type(checkShow) ~= "boolean") then
        checkShow = true
    end
    if (true == checkShow and false == self:isShow()) then
        return false
    end
    local anchor = self:anchor()
    if (nil == anchor) then
        return false
    end
    rx = rx or japi.MouseRX()
    ry = ry or japi.MouseRY()
    local ax = anchor[1]
    local ay = anchor[2]
    local w = anchor[3]
    local h = anchor[4]
    local xMin = ax - w / 2
    local xMax = ax + w / 2
    local yMin = ay - h / 2
    local yMax = ay + h / 2
    return rx < xMax and rx > xMin and ry < yMax and ry > yMin
end

--- 屏幕相对坐标是否在UI外
---@param rx number 默认鼠标RX
---@param ry number 默认鼠标RY
---@return boolean
function _index:isBorder(rx, ry)
    if (false == self:isShow()) then
        return false
    end
    local anchor = self:anchor()
    if (nil == anchor) then
        return false
    end
    rx = rx or japi.MouseRX()
    ry = ry or japi.MouseRY()
    local ax = anchor[1]
    local ay = anchor[2]
    local w = anchor[3]
    local h = anchor[4]
    local xMin = ax - w / 2
    local xMax = ax + w / 2
    local yMin = ay - h / 2
    local yMax = ay + h / 2
    return rx > xMax or rx < xMin or ry > yMax or ry < yMin
end

--- 指针相对坐标是否已进入UI内
--- 只有注册了指针进出事件的UI对象才会生效
---@return boolean
function _index:isEntering()
    return true == self._entering
end

--- 构造UI对象
---@param name string
---@param prototype table 原型数据
---@return UI
function UI(name, prototype)
    sync.must()
    must(type(name) == "string", "name@string")
    local cache = class.cache(_index._type)
    if (nil == cache[name]) then
        if (nil == prototype) then
            prototype = {}
        end
        prototype._className = name
        cache[name] = setmetatable(prototype, { __index = _index })
    end
    return cache[name]
end