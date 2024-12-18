--- 方/圆区域，用于划定范围及管理
---@class Region:Meta
local _index = Meta(RegionClass, {
    _eventMode = 2, --- 事件模式，默认为2。事件模式：[1]原生模式，挂载在原生的事件上[2]计时模式，需要控制间隔调节效果
    _eventPeriod = 0.5, --- 事件模式为2时的检测间隔
})

---@protected
function _index:destruct()
    local ws = self._weathers
    if (type(ws) == "table" and #ws > 0) then
        for i = #ws, 1, -1 do
            weather.destroy(ws[i])
        end
        self._weathers = nil
    end
    class.destroy(self._splat)
    -- mode1
    if (nil ~= self._rectRegion) then
        J.RemoveRegion(self._rectRegion)
        J.HandleUnRef(self._rectRegion)
        self._rectRegion = nil
    end
    if (nil ~= self._rectTgr1) then
        J.TriggerClearActions(self._rectTgr1)
        J.DestroyTrigger(self._rectTgr1)
        J.HandleUnRef(self._rectTgr1)
        self._rectTgr1 = nil
    end
    if (nil ~= self._rectTgr2) then
        J.TriggerClearActions(self._rectTgr2)
        J.DestroyTrigger(self._rectTgr2)
        J.HandleUnRef(self._rectTgr2)
        self._rectTgr2 = nil
    end
    -- mode2
    if (nil ~= self._modeTimer) then
        class.destroy(self._modeTimer)
        self._modeTimer = nil
        self._prevUnits = nil
    end
    -- self
    if (nil == self._handle) then
        J.RemoveRect(self._handle)
        J.HandleUnRef(self._handle)
    end
    class.cache(RegionClass)[self._name] = nil
end

--- 获取handle
---@return number
function _index:handle()
    if (nil == self._handle) then
        self._handle = J.Rect(self._xMin, self._yMin, self._xMax, self._yMax)
        J.HandleRef(self._handle)
    end
    return self._handle
end

--- 获取区域名
---@return string
function _index:name()
    return self._name
end

--- 坐标是否在区域里
---@param x number
---@param y number
---@return boolean
function _index:isInside(x, y)
    if (self._shape == "square") then
        return x < self._xMax and x > self._xMin and y < self._yMax and y > self._yMin
    elseif (self._shape == "circle") then
        return 1 >= (((self._x - x) ^ 2) / ((self._width) ^ 2) + ((self._y - y) ^ 2) / ((self._height / 2) ^ 2))
    end
    return false
end

--- 坐标是否超出区域边界
---@param x number
---@param y number
---@return boolean
function _index:isBorder(x, y)
    if (self._shape == "square") then
        return x >= self._xMax or x <= self._xMin or y >= self._yMax or y <= self._yMin
    elseif (self._shape == "circle") then
        return 1 < (((self._x - x) ^ 2) / ((self._width) ^ 2) + ((self._y - y) ^ 2) / ((self._height / 2) ^ 2))
    end
    return false
end

--- 区域左下角X坐标
---@return number
function _index:xMin()
    return self._xMin
end

--- 区域左下角Y坐标
---@return number
function _index:yMin()
    return self._yMin
end

--- 区域右上角X坐标
---@return number
function _index:xMax()
    return self._xMax
end

--- 区域右上角Y坐标
---@return number
function _index:yMax()
    return self._yMax
end

--- 中心X
---@return number
function _index:x()
    return self._x
end

--- 中心Y
---@return number
function _index:y()
    return self._y
end

--- 宽
---@return number
function _index:width()
    return self._width
end

--- 高
---@return number
function _index:height()
    return self._height
end

--- 内部随机坐标
---@return number,number
function _index:rand()
    return math.square(self._x, self._y, self._width, self._height)
end

--- 区域地表贴图
--- 为区域设定一个地表贴图
---@param texture string|boolean 贴图路径，设为false则删除贴图
---@param alpha number 透明度[0-255]
---@return void
function _index:splat(texture, alpha)
    sync.must()
    if (false == texture) then
        class.destroy(self._splat)
        self._splat = nil
        return
    end
    if (nil == self._splat) then
        self._splat = Image(japi.AssetsImage(texture), self._width, self._height)
        self._splat:position(self._x, self._y)
    end
    self._splat:rgba(255, 255, 255, alpha)
end

--- 添加天气
---@see weather#type
---@param weatherType weather 参考 weather.type，当设为nil且status为false时，去除所有天气，否则只去除1对应数量级
---@return number
function _index:weatherInsert(weatherType)
    must(type(weatherType) == "table", "weatherType@weather.type")
    ---@type number[]
    local ws = self._weathers
    if (nil == ws) then
        ws = {}
        self._weathers = ws
    end
    local w = weather.create(weatherType, self)
    table.insert(ws, w)
    return w
end

--- 删除天气
---@see weather#type
---@param weatherType nil|weather 参考 weather.type，当设为nil时，去除所有天气，否则只去除对应类型的1个数量级的天气
---@return void
function _index:weatherRemove(weatherType)
    ---@type number[]
    local ws = self._weathers
    if (nil == ws) then
        return
    end
    if (#ws > 0) then
        for i = #ws, 1, -1 do
            local wv = ws[i]
            if (nil == weatherType) then
                table.remove(ws, i)
                weather.destroy(wv)
            elseif (weatherType == weather.getType(wv)) then
                table.remove(ws, i)
                weather.destroy(wv)
                break
            end
        end
    end
end

--- 强行设置事件模式和模式数据
--- 当mode为1时，挂载原生
--- 当mode为2时，可以设置检测周期（秒）默认0.5
---@private
---@param mode number integer 事件模式，默认为2。事件模式：[1]原生模式，挂载在原生的事件上；[2]计时模式，挂载在计时器上需要控制间隔调节
---@param data number
---@return void
function _index:setEventMode(mode, data)
    if (mode == 1) then
        self._eventMode = mode
    elseif (mode == 2) then
        self._eventMode = mode
        if (type(data) == "number") then
            self._eventPeriod = data
        end
    end
end

---@private
function _index:initMode(callFunc)
    sync.must()
    self._eventEnable = (type(callFunc) == "function")
    local mode = self._eventMode
    if (mode == 1) then
        -- 模式1：原生模式，挂载在原生的事件上原生模式，挂载在原生的事件上
        -- 注意shape为circle时原生模式依然以矩形形状判定
        if (false == self._eventEnable) then
            return
        end
        if (nil == self._rectRegion) then
            if (self._eventEnable) then
                local r = J.CreateRegion()
                J.HandleRef(r)
                J.RegionAddRect(r, self:handle())
                local tgr1 = J.CreateTrigger()
                J.HandleRef(tgr1)
                J.TriggerRegisterEnterRegion(tgr1, r, nil)
                J.TriggerAddAction(tgr1, function()
                    if (true == self._eventEnable) then
                        local u = class.h2o(J.GetEnteringUnit())
                        if (class.isObject(u, UnitClass)) then
                            event.syncTrigger(self, eventKind.regionEnter, { triggerUnit = u })
                        end
                    end
                end)
                local tgr2 = J.CreateTrigger()
                J.HandleRef(tgr2)
                J.TriggerRegisterLeaveRegion(tgr2, r, nil)
                J.TriggerAddAction(tgr2, function()
                    if (true == self._eventEnable) then
                        local u = class.h2o(J.GetLeavingUnit())
                        if (class.isObject(u, UnitClass)) then
                            event.syncTrigger(self, eventKind.regionLeave, { triggerUnit = u })
                        end
                    end
                end)
                self._rectRegion = r
                self._rectTgr1 = tgr1
                self._rectTgr2 = tgr2
            end
        end
    elseif (mode == 2) then
        -- 模式2：计时模式，挂载在计时器上，需要控制间隔调节
        if (false == self._eventEnable) then
            class.destroy(self._modeTimer)
            self._modeTimer = nil
            return
        end
        if (false == class.isObject(self._modeTimer, TimerClass)) then
            self._modeTimer = time.setInterval(self._eventPeriod, function(curTimer)
                if (class.isDestroy(self)) then
                    class.destroy(curTimer)
                    self._modeTimer = nil
                    return
                end
                local newUnits
                local shape = self._shape
                if (shape == "square") then
                    newUnits = Group(UnitClass):catch({
                        square = {
                            x = self._x,
                            y = self._y,
                            width = self._width,
                            height = self._height,
                        },
                        ---@param enumUnit Unit
                        filter = function(enumUnit)
                            return enumUnit:isAlive()
                        end,
                    })
                elseif (shape == "circle") then
                    newUnits = Group(UnitClass):catch({
                        circle = {
                            x = self._x,
                            y = self._y,
                            radius = self._radius,
                        },
                        ---@param enumUnit Unit
                        filter = function(enumUnit)
                            return enumUnit:isAlive()
                        end,
                    })
                end
                if (nil == newUnits) then
                    return
                end
                local pus = self._prevUnits
                local preEnter = {}
                local newEnter = {}
                if (type(pus) == "table") then
                    for _, u in ipairs(pus) do
                        preEnter[u:id()] = true
                    end
                end
                for _, u in ipairs(newUnits) do
                    newEnter[u:id()] = true
                end
                if (type(pus) == "table") then
                    for _, u in ipairs(pus) do
                        if (nil == newEnter[u:id()]) then
                            event.syncTrigger(self, eventKind.regionLeave, { triggerUnit = u })
                        end
                    end
                end
                if (#newUnits > 0) then
                    for _, u in ipairs(newUnits) do
                        if (nil == preEnter[u:id()]) then
                            event.syncTrigger(self, eventKind.regionEnter, { triggerUnit = u })
                        end
                    end
                end
                self._prevUnits = newUnits
            end)
        end
    end
end

--- 当进入区域时
--- 此事件注册以覆盖形式执行，如果你非要一个区域注册多次可自行使用event.syncRegister
---@param callFunc fun(evtData:eventOnRegionEnter):void
---@return self
function _index:onEnter(callFunc)
    self:initMode(callFunc)
    event.syncRegister(self, eventKind.regionEnter, callFunc)
    return self
end

--- 当离开区域时
--- 此事件注册以覆盖形式执行，如果你非要一个区域注册多次可自行使用event.syncRegister
---@param callFunc fun(evtData:eventOnRegionLeave):void
---@return self
function _index:onLeave(callFunc)
    self:initMode(callFunc)
    event.syncRegister(self, eventKind.regionLeave, callFunc)
    return self
end

--- 构造区域对象
---@param name string 唯一标识名
---@param shape string | "'square'" | "'circle'"
---@param x number
---@param y number
---@param width number
---@param height number
---@return Region
function Region(name, shape, x, y, width, height)
    sync.must()
    local cache = class.cache(RegionClass)
    if (nil == cache[name]) then
        local o = oMeta({
            _name = name,
            _shape = shape,
            _x = x,
            _y = y,
            _width = width,
            _height = height,
        }, _index)
        o._xMin = o._x - o._width * 0.5
        o._yMin = o._y - o._height * 0.5
        o._xMax = o._x + o._width * 0.5
        o._yMax = o._y + o._height * 0.5
        -- ID
        class.id(o, false)
        cache[name] = o
    end
    return cache[name]
end