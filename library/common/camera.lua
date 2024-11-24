--- 镜头，操作镜头方法、镜头数据获取
---@class camera
camera = camera or {}

--- 镜头眼源X
---@return number
function camera.ex()
    return japi.CameraGetField("ex")
end

--- 镜头眼源Y
---@return number
function camera.ey()
    return japi.CameraGetField("ey")
end

--- 镜头眼源Z
---@return number
function camera.ez()
    return japi.CameraGetField("ez")
end

--- 当前镜头X地图目标坐标
---@return number
function camera.tx()
    return japi.CameraGetField("tx")
end

--- 当前镜头Y地图目标坐标
---@return number
function camera.ty()
    return japi.CameraGetField("ty")
end

--- 当前镜头Z地图目标坐标
---@return number
function camera.tz()
    return japi.CameraGetField("tz")
end

--- 远景截断距离
---@param value number|nil
---@return number
function camera.farZ(value)
    if (type(value) == "number") then
        japi.CameraSetField("farZ", value, 100, 3000)
        return
    end
    return japi.CameraGetField("farZ")
end

--- Z轴偏移（高度偏移）
---@param value number|nil
---@return number
function camera.zOffset(value)
    if (type(value) == "number") then
        japi.CameraSetField("zOffset", value, -1000, 3000)
        return
    end
    return japi.CameraGetField("zOffset")
end

--- 观察角度
---@param value number|nil
---@return number
function camera.fov(value)
    if (type(value) == "number") then
        japi.CameraSetField("fov", value, 20, 120)
        return
    end
    return math._r2d * japi.CameraGetField("fov")
end

--- X轴翻转角度
---@param value number|nil
---@return number
function camera.traX(value)
    if (type(value) == "number") then
        japi.CameraSetField("traX", value, 270, 350)
        return
    end
    return math._r2d * japi.CameraGetField("traX")
end

--- Y轴翻转角度
---@param value number|nil
---@return number
function camera.traY(value)
    if (type(value) == "number") then
        japi.CameraSetField("traY", value, 80, 280)
        return
    end
    return math._r2d * japi.CameraGetField("traY")
end

--- Z轴翻转角度
---@param value number|nil
---@return number
function camera.traZ(value)
    if (type(value) == "number") then
        japi.CameraSetField("traZ", value, 80, 280)
        return
    end
    return math._r2d * japi.CameraGetField("traZ")
end

--- 镜头距离
---@param value number|nil
---@return number
function camera.distance(value)
    if (type(value) == "number") then
        japi.CameraSetField("distance", value, 400, 3000)
        return
    end
    return japi.CameraGetField("distance")
end

--- 重置镜头
---@param duration number
---@return void
function camera.reset(duration)
    J.CameraSetSourceNoise(0, 0)
    J.CameraSetTargetNoise(0, 0)
    J.ResetToGameCamera(duration)
end

--- 设置空格坐标
--- 空格设置魔兽最大记录8个队列位置，不定死坐标则按空格时轮循跳转
--- 如要完全定死一个坐标，需要强行覆盖8次
---@param x number
---@param y number
---@param unique boolean 是否定死坐标记录,默认不锁死
---@return void
function camera.spacePosition(x, y, unique)
    if (type(unique) ~= "boolean") then
        unique = false
    end
    if (unique) then
        for _ = 1, 8, 1 do
            J.SetCameraQuickPosition(x, y)
        end
    else
        J.SetCameraQuickPosition(x, y)
    end
end

--- 移动镜头坐标到XY
---@param x number
---@param y number
---@param duration number
---@return void
function camera.to(x, y, duration)
    duration = duration or 0
    J.PanCameraToTimed(x, y, duration)
end

--- 锁定镜头跟踪某单位
---@param whichUnit Unit
---@return void
function camera.follow(whichUnit)
    J.SetCameraTargetController(whichUnit:handle(), 0, 0, false)
end

--- 镜头是否在摇晃
---@return boolean
function camera.isShaking()
    return superposition.is("camera", "shaking")
end

--- 镜头是否在震动
---@return boolean
function camera.isQuaking()
    return superposition.is("camera", "quaking")
end

--- 摇晃镜头
---@param magnitude number 幅度
---@param velocity number 速率
---@param duration number 持续时间
---@return void
function camera.shake(magnitude, velocity, duration)
    magnitude = magnitude or 0
    velocity = velocity or 0
    duration = math.trunc(duration or 0, 2)
    if (magnitude <= 0 or velocity <= 0 or duration <= 0) then
        return
    end
    if (sync.is()) then
        superposition.plus("camera", "shaking")
        J.CameraSetTargetNoise(magnitude, velocity)
        time.setTimeout(duration, function()
            superposition.minus("camera", "shaking")
            if (false == camera.isShaking()) then
                J.CameraSetTargetNoise(0, 0)
            end
        end)
    else
        superposition.plus("camera", "shaking")
        J.CameraSetTargetNoise(magnitude, velocity)
        async.setTimeout(duration * 60, function()
            superposition.minus("camera", "shaking")
            if (false == camera.isShaking()) then
                J.CameraSetTargetNoise(0, 0)
            end
        end)
    end
end

--- 震动镜头
---@param magnitude number 幅度
---@param duration number 持续时间
---@return self
function camera.quake(magnitude, duration)
    magnitude = magnitude or 0
    duration = math.trunc(duration or 0, 2)
    if (magnitude <= 0 or duration <= 0) then
        return
    end
    local richter = magnitude
    if (richter > 5) then
        richter = 5
    end
    if (richter < 2) then
        richter = 2
    end
    if (sync.is()) then
        superposition.plus("camera", "quaking")
        J.CameraSetTargetNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
        J.CameraSetSourceNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
        time.setTimeout(duration, function()
            superposition.minus("camera", "quaking")
            if (false == camera.isQuaking()) then
                J.CameraSetSourceNoise(0, 0)
                if (false == camera.isShaking()) then
                    J.CameraSetTargetNoise(0, 0)
                end
            end
        end)
    else
        superposition.plus("camera", "quaking")
        J.CameraSetTargetNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
        J.CameraSetSourceNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
        async.setTimeout(duration * 60, function()
            superposition.minus("camera", "quaking")
            if (false == camera.isQuaking()) then
                J.CameraSetSourceNoise(0, 0)
                if (false == camera.isShaking()) then
                    J.CameraSetTargetNoise(0, 0)
                end
            end
        end)
    end
end

--- 当镜头移动
---@param key string
---@param callFunc function
---@return void
function camera.onMove(key, callFunc)
    event.asyncRegister("camera", eventKind.cameraMove, key, callFunc)
end

--- 当镜头缩放
---@param key string
---@param callFunc function
---@return void
function camera.onZoom(key, callFunc)
    event.asyncRegister("camera", eventKind.cameraZoom, key, callFunc)
end

--- 当镜头旋转
---@param key string
---@param callFunc function
---@return void
function camera.onRotate(key, callFunc)
    event.asyncRegister("camera", eventKind.cameraRotate, key, callFunc)
end

--- 当镜头变动
---@param key string
---@param callFunc function
---@return void
function camera.onChange(key, callFunc)
    event.asyncRegister("camera", eventKind.cameraChange, key, callFunc)
end