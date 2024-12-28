--- LIK自实现方法，包含kk平台引擎自带的japi方法，方法没有特定开头
--- lik已接管DzFrameSetUpdateCallbackByCode方法，此方法不可私自使用

--- 数据配置
---@protected
japi._asyncExec = japi._asyncExec or {}
---@protected
japi._asyncExecDelay = japi._asyncExecDelay or {}
---@protected
japi._asyncExecDelayId = japi._asyncExecDelayId or 0
---@protected
japi._asyncInc = japi._asyncInc or 0
---@protected
japi._asyncRefresh = japi._asyncRefresh or {}
---@protected
japi._asyncRandPool = japi._asyncRandPool or { i = {}, d = {} }
---@protected
japi._blackBordersBottom = japi._blackBordersBottom or 0.130
---@protected
japi._blackBordersInner = japi._blackBordersInner or 0.45
---@protected
japi._blackBordersTop = japi._blackBordersTop or 0.020
---@protected
japi._cameraFieldDelay = japi._cameraFieldDelay or {}
---@protected
japi._cameraField = japi._cameraField or {}
---@protected
japi._cameraF2S = japi._cameraF2S or {
    distance = CAMERA_FIELD_TARGET_DISTANCE,
    farZ = CAMERA_FIELD_FARZ,
    fov = CAMERA_FIELD_FIELD_OF_VIEW,
    traX = CAMERA_FIELD_ANGLE_OF_ATTACK,
    traY = CAMERA_FIELD_ROLL,
    traZ = CAMERA_FIELD_ROTATION,
    zOffset = CAMERA_FIELD_ZOFFSET,
}
---@protected
japi._clientHeight = japi._clientHeight or 0
---@protected
japi._clientWidth = japi._clientWidth or 0
---@protected
japi._cursor = japi._cursor or { rx = 0.4, ry = 0.3 }
---@protected
japi._hasMallItem = japi._hasMallItem or {}
---@protected
japi._isWideScreen = datum.default(japi._isWideScreen, false)
---@protected
japi._loadToc = japi._loadToc or {}
---@protected
japi._longPress = japi._longPress or { keyboard = {}, mouse = {} }
---@protected
japi._mouse = japi._mouse or { llp = 0, rlp = 0 }
---@protected
japi._roulette = japi._roulette or nil
---@protected
japi._rouletteWait = datum.default(japi._rouletteWait, false)
---@protected
japi._rouletteWaitTimer = japi._rouletteWaitTimer or nil
---@protected
japi._uiAdaptive = japi._uiAdaptive or nil
---@protected
japi._uiEsc = japi._uiEsc or nil
---@protected
japi._uiTagIndex = japi._uiTagIndex or 0
---@protected
japi._z = japi._z or {}

--- 单位语音资源路径
---@param name string
---@return string
function japi.AssetsSpeech(name)
    return assets_pget("speech", name)
end

--- 获取资源字体
---@return string
function japi.AssetsFont()
    return assets_pget("font")
end

--- 获取资源图片
---@param alias string
---@return string
function japi.AssetsImage(alias)
    return assets_pget("image", alias)
end

--- 获取资源模型
---@param alias string
---@return string
function japi.AssetsModel(alias)
    return assets_pget("model", alias)
end

--- 获取资源Bgm
---@param alias string
---@return string,number 路径,音量
function japi.AssetsBgm(alias)
    return assets_pget("bgm", alias)
end

--- 获取资源Vcm
---@param alias string
---@return number handle
function japi.AssetsVcm(alias)
    return assets_pget("vcm", alias)
end

--- 获取资源V3d
---@param alias string
---@return number handle
function japi.AssetsV3d(alias)
    return assets_pget("v3d", alias)
end

--- 获取资源Vwp
---@param sourceUnit Unit
---@param targetObj Unit
---@return number handle
function japi.AssetsVwp(sourceUnit, targetObj)
    return assets_pget("vwp", sourceUnit, targetObj)
end

--- 获取UI套件内的资源
--- 如要获取 xlik_plate/assets/bar/blue.tga 则 kit='xlik_plate',alias='assets/bar/blue.tga' 或 'assets/bar/blue'
---@param kit string 如 xlik_plate
---@param alias string 如 attack/01 ; UI套件内的assets会自动引入到项目中而无需手动引入，以左斜杠的别称即可
---@param backup string ui资源不存在时的备用资源搜索策略，如 'image'|'model',常用最多只有image可自行拓展
---@return string
function japi.AssetsUI(kit, alias, backup)
    return assets_pget("ui", kit, alias, backup)
end

--- 使用宽屏模式
--- 地图可以根据自身特点，强制打开或关闭的宽屏优化支持功能。
--- 开启宽屏模式可以解决单位被拉伸显得比较“胖”的问题。
--- 必须使用这个才能使用lk的世界坐标
---@param enable boolean
---@return void
function japi.EnableWideScreen(enable)
    japi._isWideScreen = enable
    japi.DZ_EnableWideScreen(enable)
end

--- 是否宽屏模式
---@return boolean
function japi.IsWideScreen()
    return japi._isWideScreen
end

--- 获取魔兽客户端宽度
--- 不包括魔兽窗口边框
---@return number
function japi.GetClientWidth()
    return japi._clientWidth
end

--- 获取魔兽客户端高度
--- 不包括魔兽窗口边框
---@return number
function japi.GetClientHeight()
    return japi._clientHeight
end

--- [别名]DzFrameEditBlackBorders
--- 修改游戏渲染黑边: 上方高度:topHeight,下方高度:bottomHeight
--- 上下加起来不要大于0.6
---@param topHeight number
---@param bottomHeight number
---@return void
function japi.SetBlackBorders(topHeight, bottomHeight)
    japi._blackBordersTop = topHeight
    japi._blackBordersBottom = bottomHeight
    japi._blackBordersInner = 0.6 - topHeight - bottomHeight
    japi.DZ_FrameEditBlackBorders(topHeight, bottomHeight)
end

--- 获得游戏渲染的：离顶黑边高、离底黑边高、中间显示高、
---@return number,number,number top,bottom,inner
function japi.GetBlackBorders()
    return japi._blackBordersTop, japi._blackBordersBottom, japi._blackBordersInner
end

--- 玩家[本地调试环境下]是否拥有该商城道具（平台地图商城）
--- 平台地图商城玩家拥有该道具返还true
---@param whichPlayer number
---@param key string
---@return boolean
function japi.HasMallItem(whichPlayer, key)
    if (LK_DEBUG) then
        return true == japi._hasMallItem[key]
    end
    return japi.DZ_Map_HasMallItem(whichPlayer, key)
end

--- 强制[本地调试环境下]所有玩家拥有该商城道具
--- 参数支持多个字符串key，如：japi.SetMallItem("item1","item2","item3")
---@vararg string
---@return void
function japi.SetMallItem(...)
    if (LK_DEBUG) then
        for _, k in ipairs({ ... }) do
            japi._hasMallItem[k] = true
        end
    end
end

--- 新建一个UI的Tag索引
---@return string
function japi.UITagIndex()
    japi._uiTagIndex = japi._uiTagIndex + 1
    return "UI#" .. japi._uiTagIndex
end

--- 执行自适应UI大小
--- 以流行尺寸作为基准比例，以高为基准结合魔兽4:3计算自动调节宽度的自适应规则
---@param w number 宽
---@return number
function japi.UIAdaptive(w)
    w = w or 0
    if (w == 0) then
        return 0
    end
    local sr = 4 / 3
    local pr = 16 / 9
    local tr = sr / pr
    local dr = japi._clientWidth / japi._clientHeight / pr
    w = w * tr / dr
    if (w > 0) then
        w = math.max(0.0002, w)
        w = math.min(0.8, w)
    elseif (w < 0) then
        w = math.max(-0.8, w)
        w = math.min(-0.0002, w)
    end
    return w
end

--- 执行自适应UI大小反算
--- 以流行尺寸作为基准比例，以高为基准结合魔兽4:3计算自动调节宽度的自适应规则
---@param w number 宽
---@return number
function japi.UIDisAdaptive(w)
    w = w or 0
    if (w == 0) then
        return 0
    end
    local sr = 4 / 3
    local pr = 16 / 9
    local tr = sr / pr
    local dr = japi._clientWidth / japi._clientHeight / pr
    w = w * dr / tr
    if (w > 0) then
        w = math.max(0.0002, w)
        w = math.min(1.6, w)
    elseif (w < 0) then
        w = math.max(-1.6, w)
        w = math.min(-0.0002, w)
    end
    return w
end

--- 注册UI对象自适应处理
---@param key string
---@param ui UI
---@return void
function japi.UISetAdaptive(key, ui)
    japi._uiAdaptive:set(key, ui)
end

--- 注册UI对象Esc叠层处理
---@param key string
---@param ui UI
---@return void
function japi.UISetEsc(key, ui)
    japi._uiEsc:set(key, ui)
end

--- 注册UI对象Esc叠层处理
---@param whichUI UI 操作的UI对象
---@param evt string 事件种类
---@param ban boolean 是否强制禁止，ban为true时无视其他条件必定注销事件
---@return void
function japi.UIEvent2Mouse(whichUI, evt, ban)
    if (nil == whichUI or nil == evt) then
        return
    end
    if (nil == whichUI._ui2mouse) then
        whichUI._ui2mouse = {}
    end
    --- 检查弹层区,指针区可以限制某些功能,自动根据UITooltips对象计算
    ---@type fun(rx:number|nil,ry:number|nil):boolean
    local _checkTooltips = function(rx, ry)
        local is = true
        if (Pool(UITooltipsClass):count() == 0) then
            return is
        end
        rx = rx or japi.MouseRX()
        ry = ry or japi.MouseRY()
        Pool(UITooltipsClass):forEach(function(enumObj)
            if (isInsideUI(enumObj, rx, ry)) then
                is = false
                return false
            end
        end)
        if (false == is) then
            local f = whichUI
            while (false == is) do
                is = (class.isObject(f, UITooltipsClass))
                if (true == is) then
                    break
                end
                f = f:parent()
                if (f == UIGame) then
                    break
                end
            end
        end
        return is
    end
    local meKey = "kl_u2m_" .. whichUI:id()
    local elKey = meKey .. "#el"
    ---@type boolean 内判定
    local isInside = isInsideUI(whichUI) and _checkTooltips()
    local isDrtReg = (false == event.asyncHas(whichUI, eventKind.uiEnter) or isInside)
    local insideEvents = { eventKind.mouseLeftClick, eventKind.mouseLeftRelease, eventKind.mouseRightClick, eventKind.mouseRightRelease, eventKind.mouseWheel, eventKind.mouseMove }
    local transEvents = { eventKind.uiLeftClick, eventKind.uiLeftRelease, eventKind.uiRightClick, eventKind.uiRightRelease, eventKind.uiWheel, eventKind.uiMove }
    --- u2m uiEvents To mouseEvents
    --- ui事件在onEvent时已写入数据，而本质上ui事件是不存在的，只存在mouse事件
    --- 所以此处合并处理ui的事件数据桥接到mouse事件上去
    ---@type table<number,number>
    local u2m = whichUI._ui2mouse
    --- insideEvents注册器
    local u2mRegister = function(mEvt, uEvt, status)
        if (true == status) then
            if ((u2m[mEvt] or 0) <= 0) then
                return
            end
            if (event.asyncHas("mouse", mEvt, meKey)) then
                return
            end
            -- 左右键松开事件绝大多数都处理清扫业务，此处设计为不需要检测是否UI之内
            if (uEvt == eventKind.uiLeftRelease or uEvt == eventKind.uiRightRelease) then
                event.asyncRegister("mouse", mEvt, meKey, function(evtData)
                    if (cursor.isQuoting() and false == cursor.isDragging()) then
                        return
                    end
                    event.asyncTrigger(whichUI, uEvt, evtData)
                end)
            else
                event.asyncRegister("mouse", mEvt, meKey, function(evtData)
                    if (cursor.isQuoting() and false == cursor.isDragging()) then
                        return
                    end
                    -- 检测是否UI之内，是否有弹层遮挡
                    local rx, ry = evtData.rx, evtData.ry
                    if (isInsideUI(whichUI, rx, ry) and _checkTooltips(rx, ry)) then
                        event.asyncTrigger(whichUI, uEvt, evtData)
                    end
                end)
            end
        else
            event.asyncRegister("mouse", mEvt, meKey, nil)
        end
    end
    local u2mHandler = function(mEvt, n)
        -- enter&leave事件是同时共存的，且具有最高优先级
        -- 并能决定其他inside-mouse事件的注册与否
        if (evt == eventKind.uiEnter or evt == eventKind.uiLeave) then
            -- 当事件为enter或leave时，临界值以elKey为准不以鼠标事件为准
            if (nil == u2m[elKey]) then
                u2m[elKey] = 0
            end
            u2m[elKey] = math.max(0, u2m[elKey] + n)
            if (u2m[elKey] <= 0) then
                event.asyncRegister("mouse", eventKind.mouseMove, elKey, nil)
            else
                if (event.asyncHas("mouse", eventKind.mouseMove, elKey)) then
                    return
                end
                local _out
                local _in = function(evtData)
                    if (cursor.isQuoting() and false == cursor.isDragging()) then
                        return
                    end
                    local rx, ry = evtData.rx, evtData.ry
                    if (isInsideUI(whichUI, rx, ry) and _checkTooltips(rx, ry)) then
                        event.asyncTrigger(whichUI, eventKind.uiEnter, evtData)
                        _out()
                    end
                end
                _out = function()
                    --- register all inside events
                    for mi, m in ipairs(insideEvents) do
                        u2mRegister(m, transEvents[mi], true)
                    end
                    ---@param evtData eventOnMouseMove
                    event.asyncRegister("mouse", eventKind.mouseMove, elKey, function(evtData)
                        if (isBorderUI(whichUI)) then
                            event.asyncRegister("mouse", eventKind.mouseMove, elKey, nil)
                            --- clear(unregister) all inside events
                            for mi, m in ipairs(insideEvents) do
                                u2mRegister(m, transEvents[mi], false)
                            end
                            event.asyncTrigger(whichUI, eventKind.uiLeave, evtData)
                            event.asyncRegister("mouse", eventKind.mouseMove, elKey, _in)
                        end
                    end)
                end
                --- clear(unregister) all inside events
                for mi, m in ipairs(insideEvents) do
                    u2mRegister(m, transEvents[mi], false)
                end
                if (isInside) then
                    _out()
                else
                    event.asyncRegister("mouse", eventKind.mouseMove, elKey, _in)
                end
            end
            return
        end
        -- inside事件的处理
        if (nil == u2m[mEvt]) then
            u2m[mEvt] = 0
        end
        u2m[mEvt] = math.max(0, u2m[mEvt] + n)
        if (u2m[mEvt] <= 0) then
            u2mRegister(mEvt, evt, false)
        elseif (isDrtReg) then
            u2mRegister(mEvt, evt, true)
        end
    end
    --
    local disabled = (true == ban)
    if (disabled) then
        if (evt == eventKind.uiLeftClick) then
            u2mHandler(eventKind.mouseLeftClick, -1)
        elseif (evt == eventKind.uiLeftRelease) then
            u2mHandler(eventKind.mouseLeftRelease, -1)
        elseif (evt == eventKind.uiRightClick) then
            u2mHandler(eventKind.mouseRightClick, -1)
        elseif (evt == eventKind.uiRightRelease) then
            u2mHandler(eventKind.mouseRightRelease, -1)
        elseif (evt == eventKind.uiWheel) then
            u2mHandler(eventKind.mouseWheel, -1)
        elseif (evt == eventKind.uiMove) then
            u2mHandler(eventKind.mouseMove, -1)
        elseif (evt == eventKind.uiEnter or evt == eventKind.uiLeave) then
            u2mHandler(nil, -1)
        end
        return
    end
    if (evt == eventKind.uiLeftClick) then
        u2mHandler(eventKind.mouseLeftClick, 1)
    elseif (evt == eventKind.uiRightClick) then
        u2mHandler(eventKind.mouseRightClick, 1)
    elseif (evt == eventKind.uiLeftRelease) then
        u2mHandler(eventKind.mouseLeftRelease, 1)
    elseif (evt == eventKind.uiRightRelease) then
        u2mHandler(eventKind.mouseRightRelease, 1)
    elseif (evt == eventKind.uiWheel) then
        u2mHandler(eventKind.mouseWheel, 1)
    elseif (evt == eventKind.uiMove) then
        u2mHandler(eventKind.mouseMove, 1)
    elseif (evt == eventKind.uiEnter or evt == eventKind.uiLeave) then
        u2mHandler(nil, 1)
    end
end

--- 加载Toc文件列表
--- 加载--> *.toc
--- 载入自己的fdf列表文件
---@return void
function japi.LoadToc(tocFilePath)
    if (true == japi._loadToc[tocFilePath]) then
        return true
    end
    japi._loadToc[tocFilePath] = true
    japi.DZ_LoadToc(tocFilePath)
end

--- 获取某个坐标的Z轴高度
---@param x number
---@param y number
---@return number
function japi.Z(x, y)
    if (type(x) == "number" and type(y) == "number") then
        local zi = 32
        local hf = zi / 2
        local xi, yi = math.round(x / zi), math.round(y / zi)
        local xd, yd = (x - xi * zi), (y - yi * zi)
        local x1, x2, xo, yo
        if (xd > hf) then
            x1 = xi + 1
            x2 = xi
        else
            x1 = xi
            x2 = xi + 1
        end
        local xt, yt
        if (nil == japi._z[x1]) then
            if (nil == japi._z[x2]) then
                return 0
            end
            xo = x2
        else
            xo = x1
            if (japi._z[x2] and math.abs(xd - hf) < hf / 2) then
                xt = x2
            end
        end
        yo = yi
        if (yd > hf and yi < math.boundary(RegionPlayable:yMax() / zi)) then
            yo = yi + 1
            if (math.abs(yd - hf) < hf / 2) then
                yt = yi
            end
        end
        if (nil == xt and nil == yt) then
            return japi._z[xo][yo] or 0
        elseif (nil == xt) then
            return ((japi._z[xo][yo] or 0) + (japi._z[xo][yt] or 0)) / 2
        elseif (nil == yt) then
            return ((japi._z[xo][yo] or 0) + (japi._z[xt][yo] or 0)) / 2
        else
            return (2 * (japi._z[xo][yo] or 0) + (japi._z[xt][yo] or 0) + (japi._z[xo][yt] or 0)) / 4
        end
    end
    return 0
end

--- 设置镜头属性
---@param key string cameraField表的key
---@param value number
---@param min number 下限值
---@param max number 上限值
---@return void
function japi.CameraSetField(key, value, min, max)
    if (nil ~= japi._cameraField[key]) then
        if (type(min) == "number") then
            value = math.max(min, value)
        end
        if (type(max) == "number") then
            value = math.min(max, value)
        end
        japi._cameraField[key] = value
        local state = japi._cameraF2S[key]
        if (nil ~= state) then
            J.SetCameraField(state, value, 0)
            if (key == "distance" or key == "fov" or key == "farZ" or key == "zOffset") then
                event.asyncTrigger("camera", eventKind.cameraZoom)
                event.asyncTrigger("camera", eventKind.cameraChange)
            elseif (key == "traX" or key == "traY" or key == "traZ") then
                event.asyncTrigger("camera", eventKind.cameraRotate)
                event.asyncTrigger("camera", eventKind.cameraChange)
            end
        end
    end
end

--- 获取镜头属性
---@param key string cameraField表的key
---@return number
function japi.CameraGetField(key)
    if (nil == japi._cameraField[key]) then
        local val
        if (key == "ex") then
            val = J.GetCameraEyePositionX()
        elseif (key == "ey") then
            val = J.GetCameraEyePositionY()
        elseif (key == "ez") then
            val = J.GetCameraEyePositionZ()
        elseif (key == "tx") then
            val = J.GetCameraTargetPositionX()
        elseif (key == "ty") then
            val = J.GetCameraTargetPositionY()
        elseif (key == "tz") then
            val = J.GetCameraTargetPositionZ()
        elseif (key == "distance") then
            val = math.floor(J.GetCameraField(CAMERA_FIELD_TARGET_DISTANCE))
        elseif (key == "farZ") then
            val = J.GetCameraField(CAMERA_FIELD_FARZ)
        elseif (key == "fov") then
            val = J.GetCameraField(CAMERA_FIELD_FIELD_OF_VIEW)
        elseif (key == "traX") then
            val = J.GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK)
        elseif (key == "traY") then
            val = J.GetCameraField(CAMERA_FIELD_ROLL)
        elseif (key == "traZ") then
            val = J.GetCameraField(CAMERA_FIELD_ROTATION)
        elseif (key == "zOffset") then
            val = J.GetCameraField(CAMERA_FIELD_ZOFFSET)
        end
        japi._cameraField[key] = val
    end
    return japi._cameraField[key]
end

--- X比例 转 像素
---@param x number
---@return number
function japi.PX(x)
    return japi._clientWidth * x / 0.8
end

--- Y比例 转 像素
---@param y number
---@return number
function japi.PY(y)
    return japi._clientHeight * y / 0.6
end

--- X像素 转 比例
---@param x number
---@return number
function japi.RX(x)
    return x / japi._clientWidth * 0.8
end

--- Y像素 转 比例
---@param y number
---@return number
function japi.RY(y)
    return y / japi._clientHeight * 0.6
end

--- 鼠标X像素 转 比例
---@return number
function japi.MouseRX()
    return japi._cursor.rx
end

--- 鼠标Y像素 转 比例
---@return number
function japi.MouseRY()
    return japi._cursor.ry
end

--- 判断XY是否在客户端内
---@param x number
---@param y number
---@return boolean
function japi.InWindow(x, y)
    return x > 0 and x < 0.8 and y > 0 and y < 0.6
end

--- 判断鼠标是否在客户端内
---@return boolean
function japi.InWindowMouse()
    return japi.InWindow(japi.MouseRX(), japi.MouseRY())
end

--- 获取异步自增值
---@return number integer
function japi.AsyncInc()
    return japi._asyncInc or 0
end

--- 异步刷新（不区分玩家默认一直刷新下去）
---@param key string 标识键
---@param callFunc fun():void
---@return void
function japi.AsyncRefresh(key, callFunc)
    if (type(callFunc) ~= "function") then
        japi._asyncRefresh[key] = callFunc
    else
        japi._asyncRefresh[key] = callFunc
    end
end

--- 异步执行（区分玩家只执行一次）
---@param playerIndex number integer 特定玩家(索引)才生效
---@param callFunc fun():void
---@return void
function japi.AsyncExec(playerIndex, callFunc)
    if (type(callFunc) ~= "function") then
        return
    end
    if (type(playerIndex) ~= "number") then
        playerIndex = player.localIndex
    end
    if (nil == japi._asyncExec[playerIndex]) then
        japi._asyncExec[playerIndex] = {}
    end
    table.insert(japi._asyncExec[playerIndex], callFunc)
end

--- 多少帧后异步执行（区分玩家且只执行一次）
---@param frame number 刷帧数，多少帧后执行，默认1
---@param playerIndex number integer 特定玩家(索引)才生效
---@param callFunc fun():void
---@return number 返回一个刷新Id，以此Id可取消本次刷新操作
function japi.AsyncExecDelay(frame, playerIndex, callFunc)
    if (type(callFunc) ~= "function") then
        callFunc = nil
    end
    if (type(playerIndex) ~= "number") then
        playerIndex = player.localIndex
    end
    frame = math.max(1, math.round(frame))
    local inc = japi._asyncInc + frame
    if (nil == japi._asyncExecDelay[inc]) then
        japi._asyncExecDelay[inc] = {}
    end
    if (nil == japi._asyncExecDelay[inc][playerIndex]) then
        japi._asyncExecDelay[inc][playerIndex] = {}
    end
    japi._asyncExecDelayId = japi._asyncExecDelayId + 1
    japi._asyncExecDelay[inc][playerIndex][japi._asyncExecDelayId] = callFunc
    return table.concat({ inc, playerIndex, japi._asyncExecDelayId }, '.')
end

--- 取消帧后异步执行
---@param execId number
---@return void
function japi.CancelAsyncExecDelay(execId)
    if (type(execId) == "string") then
        local ids = string.explode('.', execId)
        if (#ids == 3) then
            local inc = math.round(ids[1])
            if (nil ~= japi._asyncExecDelay[inc]) then
                local playerIndex = math.round(ids[2])
                if (nil ~= japi._asyncExecDelay[inc][playerIndex]) then
                    local id = math.round(ids[3])
                    if (nil ~= japi._asyncExecDelay[inc][playerIndex][id]) then
                        japi._asyncExecDelay[inc][playerIndex][id] = nil
                    end
                end
            end
        end
    end
end

--- 异步随机整数
--- 此方法只能写于异步区
--- 当范围数据池未重新打包建立时只会返回固定值
---@param min number
---@param max number
---@return number integer
function japi.AsyncRand(min, max)
    async.must()
    min = math.ceil(min)
    max = math.ceil(max)
    if (min == max) then
        return min
    end
    if (min > max) then
        min, max = max, min
    end
    local m = min .. '_' .. max
    local d = japi._asyncRandPool.d[async._id][m]
    if (nil == d) then
        return min
    end
    local i = japi._asyncRandPool.i[async._id][m]
    if (i >= #d) then
        i = 0
    end
    i = i + 1
    japi._asyncRandPool.i[async._id][m] = i
    return d[i]
end

--- 是否长按中(本地玩家)
---@see keyboard#code
---@param kind string|'keyboard'|'mouse'
---@param key string|'keyboard.code'|'left'|'right'
---@return boolean
function japi.IsLongPressing(kind, key)
    if (type(kind) == "string") then
        if (type(japi._longPress[kind]) ~= "table") then
            return false
        end
        if (type(key) == "string") then
            return type(japi._longPress[kind][key]) == "table" and (japi._longPress[key].start > 0)
        end
        local is = false
        for _, v in pairs(japi._longPress[kind]) do
            if (v.start > 0) then
                is = true
                break
            end
        end
        return is
    end
    local is = false
    for _, v in pairs(japi._longPress) do
        for _, v2 in pairs(v) do
            if (v2.start > 0) then
                is = true
                break
            end
        end
        if (is) then
            break
        end
    end
    return is
end

--- 轮盘队列
--- 此方法自带延迟策略，并且自动合并请求
--- 从而可以大大减轻执行压力
--- 只适用于无返回执行
---@param whichPlayer number
---@param key string
---@param func function
---@return void
function japi.Roulette(func, whichPlayer, key, value)
    sync.must()
    if (type(func) ~= "function" or type(key) ~= "string" or type(value) ~= "string") then
        return
    end
    local rf = function()
        if (japi.DZ_IsServerAlready(whichPlayer)) then
            func(whichPlayer, key, value)
        end
    end
    if (isArray(japi._roulette)) then
        japi._rouletteWait = false
        class.destroy(japi._rouletteWaitTimer)
        japi._rouletteWaitTimer = nil
        japi._roulette:set(key, rf)
        return
    end
    japi._roulette = Array()
    japi._roulette:set(key, rf)
    time.setInterval(0, function(curTimer)
        curTimer:period(5)
        local ks = japi._roulette:keys()
        local ksl = #ks
        if (ksl > 0) then
            local k1 = ks[1]
            local f = japi._roulette:get(k1)
            f()
            japi._roulette:set(k1, nil)
        end
        if (ksl == 0 or japi._roulette:count() == 0) then
            japi._rouletteWait = true
            japi._rouletteWaitTimer = time.setTimeout(4.99, function()
                japi._rouletteWaitTimer = nil
                if (true == japi._rouletteWait) then
                    class.destroy(curTimer)
                    japi._roulette = nil
                    japi._rouletteWait = false
                end
            end)
        end
    end)
end

--- 保存服务器存档
--- 会根据数据类型自动添加前缀
---@param whichPlayer number
---@param key string
---@param value string
function japi.ServerSaveValue(whichPlayer, key, value)
    if (string.len(key) > 63) then
        japi.Tips("63KeyTooLong")
        return
    end
    if (type(value) == "boolean") then
        if (true == value) then
            value = "B:1"
        else
            value = "B:0"
        end
    elseif (type(value) == "number") then
        value = "N:" .. tostring(value)
    elseif (type(value) ~= "string") then
        value = ""
    end
    if (string.len(value) > 63) then
        japi.Tips("63ValueTooLong")
        return
    end
    japi.Roulette(japi.DZ_Map_SaveServerValue, whichPlayer, key, value)
end

--- 获取服务器存档
--- 会处理根据数据类型自动添加前缀的数据
---@param whichPlayer number
---@param key string
---@return any
function japi.ServerLoadValue(whichPlayer, key)
    if (string.len(key) > 63) then
        japi.Tips("63KeyTooLong")
        return
    end
    if (japi.DZ_IsServerAlready(whichPlayer)) then
        local result = japi.DZ_Map_GetServerValue(whichPlayer, key)
        if (type(result) == "string") then
            local valType = string.sub(result, 1, 2)
            if (valType == "B:") then
                local v = string.sub(result, 3)
                return "1" == v
            elseif (valType == "N:") then
                local v = string.sub(result, 3)
                return tonumber(v or 0)
            end
            if (result == '') then
                return nil
            end
            return result
        end
    end
    return nil
end

--- 设置房间显示的数据
--- 为服务器存档显示的数据，对应作者之家的房间key
---@param whichPlayer number
---@param key string
---@param value string
function japi.ServerSaveRoom(whichPlayer, key, value)
    if (string.len(key) > 63) then
        japi.Tips("63KeyTooLong")
        return
    end
    key = string.upper(key)
    if (type(value) == "boolean") then
        if (true == value) then
            value = "true"
        else
            value = "false"
        end
    elseif (type(value) == "number") then
        value = math.numberFormat(value, 2)
    elseif (type(value) ~= "string") then
        value = ""
    end
    if (string.len(value) > 63) then
        japi.Tips("63ValueTooLong")
        return
    end
    japi.Roulette(japi.DZ_Map_Stat_SetStat, whichPlayer, key, value)
end