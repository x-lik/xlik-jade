--- 警示器，分为直线型、圆型、圆型（跟踪）、矩形型
--- 警示效果取决于interface特效的使用，默认已配置几种特效
--- 常用于警示玩家躲避攻击和技能
--- 在Unit对象中，使用(Unit):alerter(true)可使单位的施法带警示，常用于BOSS单位
---@class alerter
alerter = alerter or {}

---@type TimerAsync
alerter._messageTimer = alerter._messageTimer or nil

--- 直线方向
---@param x number
---@param y number
---@param distance number 距离
---@param angle number 角度0-359
---@param duration number 默认1
---@return void
function alerter.line(x, y, distance, angle, duration)
    sync.must()
    duration = duration or 1
    local e = effector.force("interface/BossAlert", x, y, 30 + japi.Z(x, y), duration)
    japi.YD_EffectMatRotateZ(e, angle)
    japi.YD_EffectMatScale(e, 128 / 100, distance / 750, 1)
end

--- 圆形范围
---@param x number
---@param y number
---@param radius number 半径
---@param duration number 默认1
---@return void
function alerter.circle(x, y, radius, duration)
    sync.must()
    duration = duration or 1
    local e = effector.force("interface/BossAlertRing", x, y, 30 + japi.Z(x, y), duration)
    local siz = radius / 160
    japi.YD_EffectMatScale(e, siz, siz, 1)
end

--- 跟踪型
---@param whichUnit Unit
---@param radius number 半径
---@param duration number 默认1
---@return void
function alerter.follow(whichUnit, radius, duration)
    sync.must()
    if (false == class.isObject(whichUnit, UnitClass)) then
        return
    end
    duration = duration or 1
    local x, y = whichUnit:x(), whichUnit:y()
    local e = effector.force("interface/BossAlertRing", x, y, 30 + japi.Z(x, y), duration)
    local siz = radius / 160
    japi.YD_EffectMatScale(e, siz, siz, 1)
    local ti = 0
    time.setInterval(0.03, function(curTimer)
        ti = ti + 0.03
        if (ti > duration or false == class.isObject(whichUnit, UnitClass) or whichUnit:isDead()) then
            class.destroy(curTimer)
            return
        end
        x, y = whichUnit:x(), whichUnit:y()
        japi.YD_SetEffectXY(e, x, y)
        japi.YD_SetEffectZ(e, 30 + japi.Z(x, y))
    end)
end

--- 矩形范围
---@param x number
---@param y number
---@param width number 宽
---@param height number 高
---@param duration number 默认1
---@return void
function alerter.square(x, y, width, height, duration)
    sync.must()
    duration = duration or 1
    local e = effector.force("interface/BossAlertSquare", x, y, 30 + japi.Z(x, y), duration)
    japi.YD_EffectMatScale(e, width / 320, height / 320, 1)
end

--- 玩家异步警告提示
---@param whichPlayer Player
---@param msg string 警告信息
---@param hexColor string|nil 外置颜色，如 colour.red，也可以直接修改msg使其的内容带有颜色
---@param vcm string|boolean 警告音效，默认为 war3_Error，可自定义播放音效路径，填false则不播放
---@return void
function alerter.message(whichPlayer, msg, hexColor, vcm)
    if (false == class.isObject(whichPlayer, PlayerClass)) then
        return
    end
    async.call(whichPlayer, function()
        if (type(hexColor) == "string") then
            msg = colour.hex(hexColor, msg)
        end
        if (nil == vcm) then
            vcm = "war3_Error" -- 默认报错音，Sound\\Interface\\Error.wav
        end
        if (type(vcm) == "string") then
            sound.vcm(vcm)
        end
        UITextAlerterMessage:text(msg)
        if (nil ~= alerter._messageTimer) then
            class.destroy(alerter._messageTimer)
            alerter._messageTimer = nil
        end
        local frm = math.max(3, 0.2 * vistring.len(msg)) * 60
        alerter._messageTimer = async.setTimeout(frm, function()
            UITextAlerterMessage:text('')
        end)
    end)
end