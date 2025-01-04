--- 点特性/附着特效
--- 包括创造、销毁、操作
---@class effector
effector = effector or {}

---@private
---@alias agileEffect {_id:string,_handle:number,_model:string,_visible:boolean,_x:number,_y:number,_z:number,_rotateX:number,_rotateY:number,_rotateZ:number,_size:number,_speed:number,_alpha:number,_red:number,_green:number,_blue:number}
---@type table<number,agileEffect>
effector._agile = effector._agile or {}

--- 销毁特效
---@param whichEffect number|agileEffect
---@return void
function effector.destroy(whichEffect)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.DZ_SetEffectVisible(whichEffect._handle, false)
        J.DestroyEffect(whichEffect._handle)
        J.HandleUnRef(whichEffect._handle)
        effector._agile[whichEffect] = nil
    elseif (type(whichEffect) == "number") then
        japi.DZ_SetEffectVisible(whichEffect, false)
        J.DestroyEffect(whichEffect)
        J.HandleUnRef(whichEffect)
    end
end

--- 重置特效
---@param whichEffect number|agileEffect
---@return void
function effector.reset(whichEffect)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.YD_EffectMatReset(whichEffect._handle)
        whichEffect._rotateX = 0
        whichEffect._rotateY = 0
        whichEffect._rotateZ = 0
    elseif (type(whichEffect) == "number") then
        japi.YD_EffectMatReset(whichEffect)
    end
end

--- 获取特效X坐标
---@param whichEffect number|agileEffect
---@return number
function effector.x(whichEffect)
    if (effector.isAgile(whichEffect)) then
        return whichEffect._x or 0
    elseif (type(whichEffect) == "number") then
        return japi.YD_GetEffectX(whichEffect)
    end
    return 0
end

--- 获取特效Y坐标
---@param whichEffect number|agileEffect
---@return number
function effector.y(whichEffect)
    if (effector.isAgile(whichEffect)) then
        return whichEffect._y or 0
    elseif (type(whichEffect) == "number") then
        return japi.YD_GetEffectY(whichEffect)
    end
    return 0
end

--- 获取特效Z坐标
---@param whichEffect number|agileEffect
---@return number
function effector.z(whichEffect)
    if (effector.isAgile(whichEffect)) then
        return whichEffect._z or 0
    elseif (type(whichEffect) == "number") then
        return japi.YD_GetEffectZ(whichEffect)
    end
    return 0
end

--- 设置特效显示/隐藏
---@param whichEffect number|agileEffect
---@param enable boolean
---@return void
function effector.visible(whichEffect, enable)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.DZ_SetEffectVisible(whichEffect._handle, enable)
        whichEffect._visible = enable
    elseif (type(whichEffect) == "number") then
        japi.DZ_SetEffectVisible(whichEffect, enable)
    end
end

--- 设置特效模型
---@param whichEffect number|agileEffect
---@param path string
---@return void
function effector.model(whichEffect, path)
    sync.must()
    path = japi.AssetsModel(path)
    if (nil == path) then
        return
    end
    if (effector.isAgile(whichEffect)) then
        japi.DZ_SetEffectModel(whichEffect._handle, path)
        whichEffect._model = path
    elseif (type(whichEffect) == "number") then
        japi.DZ_SetEffectModel(whichEffect, path)
    end
end

--- 设置特效队伍颜色
---@param whichEffect number|agileEffect
---@param playerId number integer
---@return void
function effector.teamColor(whichEffect, playerId)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.DZ_SetEffectTeamColor(whichEffect._handle, playerId)
    elseif (type(whichEffect) == "number") then
        japi.DZ_SetEffectTeamColor(whichEffect, playerId)
    end
end

--- 设置点特效大小
---@param whichEffect number|agileEffect
---@param size number
---@return void
function effector.size(whichEffect, size)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.YD_SetEffectSize(whichEffect._handle, size)
        whichEffect._size = size
    elseif (type(whichEffect) == "number") then
        japi.YD_SetEffectSize(whichEffect, size)
    end
end

--- 设置点特效速度
---@param whichEffect number|agileEffect
---@param speed number
---@return void
function effector.speed(whichEffect, speed)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.YD_SetEffectSpeed(whichEffect._handle, speed)
        whichEffect._speed = speed
    elseif (type(whichEffect) == "number") then
        japi.YD_SetEffectSpeed(whichEffect, speed)
    end
end

--- 设置特效透明度
---@param whichEffect number|agileEffect
---@param alpha number 透明度0-255
---@return void
function effector.alpha(whichEffect, alpha)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.DZ_SetEffectVertexAlpha(whichEffect._handle, alpha)
        whichEffect._alpha = alpha
    elseif (type(whichEffect) == "number") then
        japi.DZ_SetEffectVertexAlpha(whichEffect, alpha)
    end
end

--- 设置特效颜色
---@param whichEffect number|agileEffect
---@param red number 红 0-255
---@param green number 绿 0-255
---@param blue number 蓝 0-255
---@param alpha number 透明 0-255 此透明为颜色透明值不等同特效透明度
---@return void
function effector.color(whichEffect, red, green, blue, alpha)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.DZ_SetEffectVertexColor(whichEffect._handle, red, green, blue, alpha)
        whichEffect._red = red
        whichEffect._green = green
        whichEffect._blue = blue
        whichEffect._alpha = alpha
    elseif (type(whichEffect) == "number") then
        japi.DZ_SetEffectVertexColor(whichEffect, red, green, blue, alpha)
    end
end

--- 设置灵动点特效X轴翻转
---@param whichEffect agileEffect
---@param angle number 角度
---@return void
function effector.rotateX(whichEffect, angle)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.YD_EffectMatRotateX(whichEffect._handle, angle - (whichEffect._rotateX or 0)) -- 参数angle为结果量
        whichEffect._rotateX = angle
    elseif (type(whichEffect) == "number") then
        japi.YD_EffectMatRotateX(whichEffect, angle) -- 参数angle为变化量
    end
end

--- 设置灵动点特效Y轴翻转
---@param whichEffect agileEffect
---@param angle number 角度
---@return void
function effector.rotateY(whichEffect, angle)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        local prev = whichEffect._rotateY or 0
        local ry, rz = angle, (whichEffect._rotateZ or 0)
        local change = ry - prev
        if (rz > 90 and rz < 270) then
            change = -change
        end
        japi.YD_EffectMatRotateY(whichEffect._handle, change) -- 参数angle为结果量
        whichEffect._rotateY = angle
    elseif (type(whichEffect) == "number") then
        japi.YD_EffectMatRotateY(whichEffect, angle) -- 参数angle为变化量
    end
end

--- 设置灵动点特效Z轴翻转
---@param whichEffect agileEffect
---@param angle number 角度
---@return void
function effector.rotateZ(whichEffect, angle)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.YD_EffectMatRotateZ(whichEffect._handle, angle - (whichEffect._rotateZ or 0)) -- 参数angle为结果量
        whichEffect._rotateZ = angle
    elseif (type(whichEffect) == "number") then
        japi.YD_EffectMatRotateZ(whichEffect, angle) -- 参数angle为变化量
    end
end

--- 播放特效播放（动作名）动画
---@param whichEffect number|agileEffect
---@param anim string 动画名称
---@param link string 变身动画才需要链接名，一般填''空字符串就行
---@return void
function effector.animation(whichEffect, anim, link)
    sync.must()
    if (effector.isAgile(whichEffect)) then
        japi.DZ_PlayEffectAnimation(whichEffect._handle, anim, link)
    elseif (type(whichEffect) == "number") then
        japi.DZ_PlayEffectAnimation(whichEffect, anim, link)
    end
end

--- 移动点特效到X,Y,Z坐标
---@param whichEffect number|agileEffect
---@param x number
---@param y number
---@param z number
---@return void
function effector.position(whichEffect, x, y, z)
    sync.must()
    if (type(x) == "number" and type(y) == "number") then
        x = math.min(x, RegionWorld:xMax())
        x = math.max(x, RegionWorld:xMin())
        y = math.min(y, RegionWorld:yMax())
        y = math.max(y, RegionWorld:yMin())
        --- 灵动型点特效时，覆盖远距缺陷
        if (effector.isAgile(whichEffect)) then
            local h = whichEffect._handle
            local d = vector2.distance(whichEffect._x, whichEffect._y, x, y)
            if (d > 1024) then
                local model = whichEffect._model
                effector.destroy(h)
                h = J.AddSpecialEffect(model, x, y)
                J.HandleRef(h)
                whichEffect._handle = h
                effector._agile[h] = whichEffect
                -- redo
                local rx = whichEffect._rotateX
                if (type(rx) == "number") then
                    japi.YD_EffectMatRotateX(h, rx)
                end
                local ry = whichEffect._rotateY
                if (type(ry) == "number") then
                    japi.YD_EffectMatRotateY(h, ry)
                end
                local rz = whichEffect._rotateZ
                if (type(rz) == "number") then
                    japi.YD_EffectMatRotateZ(h, rz)
                end
                local visible = whichEffect._visible
                if (type(visible) == "boolean") then
                    japi.DZ_SetEffectVisible(h, visible)
                end
                local size = whichEffect._size
                if (type(size) == "number") then
                    japi.YD_SetEffectSize(h, size)
                end
                local speed = whichEffect._speed
                if (type(speed) == "number") then
                    japi.YD_SetEffectSpeed(h, speed)
                end
                local alpha = whichEffect._alpha
                if (type(alpha) == "number") then
                    japi.DZ_SetEffectVertexAlpha(h, alpha)
                end
                if (type(whichEffect._red) == "number") then
                    japi.DZ_SetEffectVertexColor(h, whichEffect._red, whichEffect._green, whichEffect._blue, whichEffect._alpha)
                end
                whichEffect._x = x
                whichEffect._y = y
                whichEffect._z = z
            end
            japi.YD_SetEffectXY(h, x, y)
            japi.YD_SetEffectZ(h, z)
        elseif (type(whichEffect) == "number") then
            japi.YD_SetEffectXY(whichEffect, x, y)
            japi.YD_SetEffectZ(whichEffect, z)
        end
    end
end

--- 绑定特效削去一层
---@type fun(attach:Array,key:string,whichEffect:attachEffect)
local _pile = function(attach, key, whichEffect)
    local p = whichEffect._pile
    p = p - 1
    if (p <= 0) then
        class.destroy(whichEffect._timer)
        whichEffect._timer = nil
        if (isArray(attach)) then
            attach:set(key, nil)
        end
        effector.destroy(whichEffect._handle)
        whichEffect = nil
    else
        whichEffect._pile = p
    end
end

--- 点特效
--- 会受到weak设定的影响
--- 有的模型删除时不会播放，需要duration > 0
---@param path string model模型路径，支持alias
---@param x number
---@param y number
---@param z number
---@param duration number 当等于0时为删除型播放，大于0时持续一段时间，-1永远
---@return number|nil
function effector.point(path, x, y, z, duration)
    sync.must()
    local model = japi.AssetsModel(path)
    if (nil == model) then
        return
    end
    z = z or japi.Z(x, y)
    if (type(duration) ~= "number") then
        duration = 0
    end
    local e = J.AddSpecialEffect(model, x, y)
    if (e > 0) then
        J.HandleRef(e)
        japi.YD_SetEffectZ(e, z)
        if (duration == 0) then
            effector.destroy(e)
            return
        elseif (duration > 0) then
            time.setTimeout(duration, function()
                effector.destroy(e)
            end)
        end
    end
    return e
end

--- 单位点特效
--- 有的模型删除时不会播放，需要duration > 0
---@param path string model模型路径，支持alias
---@param whichUnit Unit
---@param duration number 当等于0时为删除型播放，大于0时持续一段时间，-1永远
---@return number|nil
function effector.unit(path, whichUnit, duration)
    return effector.point(path, whichUnit:x(), whichUnit:y(), whichUnit:z(), duration)
end

--- 强制点特效
--- 有的模型删除时不会播放，需要duration > 0
---@param path string model模型路径，支持alias
---@param x number
---@param y number
---@param z number
---@param duration number 当等于0时为删除型播放，大于0时持续一段时间，-1永远
---@return number|nil
function effector.force(path, x, y, z, duration)
    sync.must()
    local model = japi.AssetsModel(path)
    if (nil == model) then
        return
    end
    z = z or japi.Z(x, y)
    if (type(duration) ~= "number") then
        duration = 0
    end
    local e = J.AddSpecialEffect(model, x, y)
    if (e > 0) then
        J.HandleRef(e)
        japi.YD_SetEffectZ(e, z)
        if (duration == 0) then
            effector.destroy(e)
            return
        elseif (duration > 0) then
            time.setTimeout(duration, function()
                effector.destroy(e)
            end)
        end
    end
    return e
end

--- 灵动点特效
--- 灵动型点特效默认持久存在，直到销毁
--- 注意灵动返回的是一个table而不是number
---@param path string model模型路径，支持alias
---@param x number
---@param y number
---@param z number
---@return agileEffect|nil
function effector.agile(path, x, y, z)
    sync.must()
    local model = japi.AssetsModel(path)
    must(type(model) == "string", "Invalid path")
    z = z or japi.Z(x, y)
    local e = J.AddSpecialEffect(model, x, y)
    J.HandleRef(e)
    japi.YD_SetEffectZ(e, z)
    ---@type agileEffect
    local a = { _handle = e, _model = model, _x = x, _y = y, _z = z }
    effector._agile[e] = a
    return a
end

--- 是否灵动特效
---@param whichEffect number|agileEffect
---@return boolean
function effector.isAgile(whichEffect)
    return type(whichEffect) == "table" and nil ~= whichEffect._handle and nil ~= effector._agile[whichEffect._handle]
end

--- 单位绑定特效
---@alias attachEffect {_handle:number,_model:string,_position:string,_duration:number,_pile:number,_timer:Timer}
---@param attachUnit Unit
---@param path string
---@param position string | "'origin'" | "'head'" | "'chest'" | "'weapon'"
---@param duration number 默认-1，无限持续
---@return attachEffect
function effector.attach(attachUnit, path, position, duration)
    sync.must()
    local model = japi.AssetsModel(path)
    if (type(model) ~= "string" or true ~= class.isObject(attachUnit, UnitClass)) then
        return
    end
    local au = attachUnit:handle()
    if (nil == J.GetUnitName(au)) then
        return
    end
    duration = duration or -1
    position = position or "origin"
    ---@type Array
    local ua = attachUnit._attach
    if (nil == ua) then
        ua = Array()
        attachUnit._attach = ua
    end
    local k = model .. position
    ---@type attachEffect
    local e = ua:get(k)
    if (nil == e) then
        local h = J.AddSpecialEffectTarget(model, attachUnit:handle(), position)
        J.HandleRef(h)
        e = { _handle = h, _model = model, _position = position, _duration = duration, _pile = 0 }
        ua:set(k, e)
    end
    ---@type Timer
    local t = e._timer
    if (class.isObject(t, TimerClass)) then
        if (duration > 0) then
            if (duration > t:remain()) then
                if (duration > t:period()) then
                    t:period(duration)
                end
                t:remain(duration)
            end
            return
        end
        class.destroy(t)
        e._timer = nil
    else
        e._pile = e._pile + 1
    end
    if (duration > 0) then
        e._timer = time.setTimeout(duration, function()
            e._timer = nil
            _pile(ua, k, e)
        end)
    end
    return e
end

--- 单位解绑特效
---@param detachUnit Unit
---@param path string
---@param attachPosition string | "'origin'" | "'head'" | "'chest'" | "'weapon'"
---@return void
function effector.detach(detachUnit, path, attachPosition)
    sync.must()
    local model = japi.AssetsModel(path)
    if (type(model) ~= "string" or true ~= class.isObject(detachUnit, UnitClass)) then
        return
    end
    if (nil == J.GetUnitName(detachUnit:handle())) then
        return
    end
    attachPosition = attachPosition or "origin"
    ---@type Array
    local ua = detachUnit._attach
    if (isArray(ua)) then
        local k = model .. attachPosition
        ---@type attachEffect
        local e = ua:get(k)
        if (nil ~= e) then
            _pile(ua, k, e)
        end
    end
end

--- 清理某Unit所有附着特效
---@param whichUnit Unit
---@return void
function effector.clearAttach(whichUnit)
    sync.must()
    ---@type Array
    local es = whichUnit._attach
    if (isArray(es)) then
        es:forEach(function(_, e)
            effector.destroy(e._handle)
            e = nil
        end)
        class.destroy(es)
        whichUnit._attach = nil
    end
end