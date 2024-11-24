--- JAPI自dz库，包含dz平台引擎自带的japi方法，方法以 DZ_ 开头

--- 原生 - 游戏UI
--- 一般用作创建自定义UI的父节点
---@return number integer
function japi.DZ_GetGameUI()
    return japi.Exec("DzGetGameUI")
end

--- 原生 - 玩家聊天信息框
---@return number integer
function japi.DZ_FrameGetChatMessage()
    return japi.Exec("DzFrameGetChatMessage")
end

--- 原生 - 技能按钮
--- 技能按钮:(row, column)
--- 参考物编中的技能按钮(x,y)坐标
--- (x,y)对应(column,row)反一下
---@param row number integer
---@param column number integer
---@return number integer
function japi.DZ_FrameGetCommandBarButton(row, column)
    return japi.Exec("DzFrameGetCommandBarButton", row, column)
end

--- 原生 - 英雄按钮
--- 左侧的英雄头像，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DZ_FrameGetHeroBarButton(buttonId)
    return japi.Exec("DzFrameGetHeroBarButton", buttonId)
end

--- 原生 - 英雄血条
--- 左侧的英雄头像下的血条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DZ_FrameGetHeroHPBar(buttonId)
    return japi.Exec("DzFrameGetHeroHPBar", buttonId)
end

--- 原生 - 英雄蓝条
--- 左侧的英雄头像下的蓝条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DZ_FrameGetHeroManaBar(buttonId)
    return japi.Exec("DzFrameGetHeroManaBar", buttonId)
end

--- 原生 - 物品栏按钮
--- 索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DZ_FrameGetItemBarButton(buttonId)
    return japi.Exec("DzFrameGetItemBarButton", buttonId)
end

--- 原生 - 小地图
---@return number integer
function japi.DZ_FrameGetMinimap()
    return japi.Exec("DzFrameGetMinimap")
end

--- 原生 - 小地图按钮
--- 小地图右侧竖排按钮，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DZ_FrameGetMinimapButton(buttonId)
    return japi.Exec("DzFrameGetMinimapButton", buttonId)
end

--- 原生 - 设置小地图背景贴图
---@param blp string
---@return void
function japi.DZ_SetWar3MapMap(blp)
    japi.Exec("DzSetWar3MapMap", blp)
end

--- 原生 - 单位大头像
--- 小地图右侧的大头像
---@return number integer
function japi.DZ_FrameGetPortrait()
    return japi.Exec("DzFrameGetPortrait")
end

--- 原生 - 鼠标提示
--- 鼠标移动到物品或技能按钮上显示的提示窗，初始位于技能栏上方
---@return number integer
function japi.DZ_FrameGetTooltip()
    return japi.Exec("DzFrameGetTooltip")
end

--- 原生 - 上方消息框
--- 高维修费用 等消息
---@return number integer
function japi.DZ_FrameGetTopMessage()
    return japi.Exec("DzFrameGetTopMessage")
end

--- 原生 - 系统消息框
--- 包含显示消息给玩家 及 显示Debug消息等
---@return number integer
function japi.DZ_FrameGetUnitMessage()
    return japi.Exec("DzFrameGetUnitMessage")
end

--- 原生 - 界面按钮
--- 左上的菜单等按钮，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DZ_FrameGetUpperButtonBarButton(buttonId)
    return japi.Exec("DzFrameGetUpperButtonBarButton", buttonId)
end

--- 原生 - 框选控件
--- 获取鼠标当前框选单位头像控件
---@param index number integer 索引
---@return number integer
function japi.DZ_FrameGetInfoPanelSelectButton(index)
    return japi.Exec("DzFrameGetInfoPanelSelectButton", index)
end

--- 原生 - BUFF控件
--- 获取BUFF控件地址
---@param index number integer 索引
---@return number integer
function japi.DZ_FrameGetInfoPanelBuffButton(index)
    return japi.Exec("DzFrameGetInfoPanelBuffButton", index)
end

--- 原生 - 农民控件
--- 获取农民控件地址
---@return number integer
function japi.DZ_FrameGetPeonBar()
    return japi.Exec("DzFrameGetPeonBar")
end

--- 原生 - 技能自动施法指示器
--- 获取技能自动施法指示器，控件类型为sprite frame
---@param frame number integer 控件地址
---@return number integer
function japi.DZ_FrameGetCommandBarButtonAutoCastIndicator(frame)
    return japi.Exec("DzFrameGetCommandBarButtonAutoCastIndicator", frame)
end

--- 原生 - 技能冷却指示器
--- 获取技能冷却指示器，控件类型为sprite frame
---@param frame number integer 控件地址
---@return number integer
function japi.DZ_FrameGetCommandBarButtonCoolDownIndicator(frame)
    return japi.Exec("DzFrameGetCommandBarButtonCooldownIndicator", frame)
end

--- 原生 - 技能右下角数字文本框体
--- 获取技能右下角数字文本框体
---@param frame number integer 控件地址
---@return number integer
function japi.DZ_FrameGetCommandBarButtonNumberOverlay(frame)
    return japi.Exec("DzFrameGetCommandBarButtonNumberOverlay", frame)
end

--- 原生 - 获取技能右下角数字文本控件
--- 获取技能右下角数字文本控件
---@param frame number integer 控件地址
---@return number integer
function japi.DZ_FrameGetCommandBarButtonNumberText(frame)
    return japi.Exec("DzFrameGetCommandBarButtonNumberText", frame)
end

--- 原生 - 游戏提示信息界面
--- 如建筑升级完成提示
--- 配合设置游戏提示信息一起用
---@return number integer
function japi.DZ_FrameGetWorldFrameMessage()
    return japi.Exec("DzFrameGetWorldFrameMessage")
end

--- 设置游戏提示信息
--- 设置游戏提示信息，如建造完成，技能没有目标等
---@param frame number integer 消息界面
---@param text string 消息内容
---@param color number integer 颜色
---@param duration number 时间
---@param permanent boolean 是否永久显示
---@return void
function japi.DZ_SimpleMessageFrameAddMessage(frame, text, color, duration, permanent)
    japi.Exec("DzSimpleMessageFrameAddMessage", frame, text, color, duration, permanent)
end

--- 清理游戏提示信息
---@param frame number integer 消息界面
---@return void
function japi.DZ_SimpleMessageFrameClear(frame)
    japi.Exec("DzSimpleMessageFrameClear", frame)
end

--- 新建Frame
--- 名字为fdf文件中的名字，ID默认填0。重复创建同名Frame会导致游戏退出时显示崩溃消息，如需避免可以使用Tag创建
---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
function japi.DZ_CreateFrame(frame, parent, id)
    return japi.Exec("DzCreateFrame", frame, parent, id)
end

--- 新建Frame[Tag]
--- 此处名字可以自定义，类型和模版填写fdf文件中的内容。通过此函数创建的Frame无法获取到子Frame
---@param frameType string
---@param name string
---@param parent number integer
---@param template string
---@param id number integer
---@return number integer frameId
function japi.DZ_CreateFrameByTagName(frameType, name, parent, template, id)
    return japi.Exec("DzCreateFrameByTagName", frameType, name, parent, template, id) or 0
end

---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
function japi.DZ_CreateSimpleFrame(frame, parent, id)
    return japi.Exec("DzCreateSimpleFrame", frame, parent, id)
end

--- 销毁Frame
--- 销毁一个被重复创建过的Frame会导致游戏崩溃，重复创建同名Frame请使用Tag创建
---@param frameId number integer
---@return void
function japi.DZ_DestroyFrame(frameId)
    return japi.Exec("DzDestroyFrame", frameId)
end

--- 限制鼠标移动，在frame内
---@param frame number integer
---@param enable boolean
---@return void
function japi.DZ_FrameCageMouse(frame, enable)
    japi.Exec("DzFrameCageMouse", frame, enable)
end

--- 清空frame所有锚点
---@param frame number integer
---@return void
function japi.DZ_FrameClearAllPoints(frame)
    japi.Exec("DzFrameClearAllPoints", frame)
end

--- 获取名字为name的子FrameID:Id"
--- ID默认填0，同名时优先获取最后被创建的。非Simple类的Frame类型都用此函数来获取子Frame
---@param name string
---@param id number integer
---@return number integer
function japi.DZ_FrameFindByName(name, id)
    return japi.Exec("DzFrameFindByName", name, id)
end

--- 获取Frame的透明度(0-255)
---@param frame number integer
---@return number integer
function japi.DZ_FrameGetAlpha(frame)
    return japi.Exec("DzFrameGetAlpha", frame)
end

--- frame控件是否启用
---@param frame number integer
---@return boolean
function japi.DZ_FrameGetEnable(frame)
    return japi.Exec("DzFrameGetEnable", frame)
end

--- 获取Frame的宽度
---@param frame number integer
---@return number floor
function japi.DZ_FrameGetWidth(frame)
    return japi.Exec("DzFrameGetWidth", frame)
end

--- 设置模型Frame播放动画（编号）
---@param frame number integer
---@param index number integer 播放第index个动画
---@param flag number integer 播放方式
---@return void
function japi.DZ_FrameSetAnimateByIndex(frame, index, flag)
    return japi.Exec("DzFrameSetAnimateByIndex", frame, index, flag)
end

--- 获取Frame的高度
---@param frame number integer
---@return number floor
function japi.DZ_FrameGetHeight(frame)
    return japi.Exec("DzFrameGetHeight", frame)
end

--- 获取 Frame 的名称
---@param frame number integer
---@return string
function japi.DZ_FrameGetName(frame)
    return japi.Exec("DzFrameGetName", frame)
end

--- 获取 Frame 的 Parent
---@param frame number integer
---@return number integer
function japi.DZ_FrameGetParent(frame)
    return japi.Exec("DzFrameGetParent", frame)
end

--- 获取 Frame 内的文字
--- 支持EditBox, TextFrame, TextArea, SimpleFontString
---@param frame number integer
---@return string
function japi.DZ_FrameGetText(frame)
    return japi.Exec("DzFrameGetText", frame)
end

--- 获取 Frame 的字数限制
--- 支持EditBox
---@param frame number integer
---@return number integer
function japi.DZ_FrameGetTextSizeLimit(frame)
    return japi.Exec("DzFrameGetTextSizeLimit", frame)
end

--- 获取frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@return number floor
function japi.DZ_FrameGetValue(frame)
    return japi.Exec("DzFrameGetValue", frame)
end

--- 获取指定Frame的子控件
---@param frame number integer
---@param index  number
---@return number integer
function japi.DZ_FrameGetChild(frame, index)
    return japi.Exec("DzFrameGetChild", frame, index)
end

--- 获取指定Frame的子控件数量
---@param frame number integer
---@return number integer
function japi.DZ_FrameGetChildrenCount(frame)
    return japi.Exec("DzFrameGetChildrenCount", frame)
end

--- 设置绝对位置
--- 设置 frame 的 Point 锚点 在 (x, y)
---@param frame number integer
---@param point number integer
---@param x number
---@param y number
---@return void
function japi.DZ_FrameSetAbsolutePoint(frame, point, x, y)
    japi.Exec("DzFrameSetAbsolutePoint", frame, point, x, y)
end

--- 移动所有锚点到Frame
--- 移动 frame 的 所有锚点 到 relativeFrame 上
---@param frame number integer
---@param relativeFrame number integer
---@return void
function japi.DZ_FrameSetAllPoints(frame, relativeFrame)
    japi.Exec("DzFrameSetAllPoints", frame, relativeFrame)
end

--- 设置frame的透明度(0-255)
---@param frame number integer
---@param alpha number integer
---@return void
function japi.DZ_FrameSetAlpha(frame, alpha)
    japi.Exec("DzFrameSetAlpha", frame, alpha)
end

--- 设置动画
---@param frame number integer
---@param animId number integer 播放序号的动画
---@param autoCast boolean 自动播放
---@return void
function japi.DZ_FrameSetAnimate(frame, animId, autoCast)
    japi.Exec("DzFrameSetAnimate", frame, animId, autoCast)
end

--- 设置动画进度
--- 自动播放为false时可用
---@param frame number integer
---@param offset number 进度
---@return void
function japi.DZ_FrameSetAnimateOffset(frame, offset)
    japi.Exec("DzFrameSetAnimateOffset", frame, offset)
end

--- 启用/禁用 frame
---@param frame number integer
---@param enable boolean
---@return void
function japi.DZ_FrameSetEnable(frame, enable)
    japi.Exec("DzFrameSetEnable", frame, enable)
end

--- 设置frame获取焦点
---@param frame number integer
---@param enable boolean
---@return void
function japi.DZ_FrameSetFocus(frame, enable)
    japi.Exec("DzFrameSetFocus", frame, enable)
end

--- 设置字体
--- 设置 frame 的字体为 font, 大小 height, flag flag
--- 支持EditBox、SimpleFontString、SimpleMessageFrame以及非SimpleFrame类型的例如TEXT，flag作用未知
---@param frame number integer
---@param fileName string
---@param height number
---@param flag number integer
---@return void
function japi.DZ_FrameSetFont(frame, fileName, height, flag)
    japi.Exec("DzFrameSetFont", frame, fileName, height, flag)
end

--- 设置最大/最小值
--- 设置 frame 的 最小值为 Min 最大值为 Max
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param minValue number
---@param maxValue number
---@return void
function japi.DZ_FrameSetMinMaxValue(frame, minValue, maxValue)
    japi.Exec("DzFrameSetMinMaxValue", frame, minValue, maxValue)
end

--- 设置模型
--- 设置 frame 的模型文件为 modelFile ModelType:modelType Flag:flag
---@param frame number integer
---@param modelFile string
---@param modelType number integer
---@param flag number integer
---@return void
function japi.DZ_FrameSetModel(frame, modelFile, modelType, flag)
    japi.Exec("DzFrameSetModel", frame, modelFile, modelType, flag)
end

--- 设置父窗口
--- 设置 frame 的父窗口为 parent
---@param frame number integer
---@param parent number integer
---@return void
function japi.DZ_FrameSetParent(frame, parent)
    japi.Exec("DzFrameSetParent", frame, parent)
end

--- 设置相对位置
--- 设置 frame 的 Point 锚点 (跟随relativeFrame 的 relativePoint 锚点) 偏移(x, y)
---@param frame number integer
---@param point number integer
---@param relativeFrame number integer
---@param relativePoint number integer
---@param x number
---@param y number
---@return void
function japi.DZ_FrameSetPoint(frame, point, relativeFrame, relativePoint, x, y)
    japi.Exec("DzFrameSetPoint", frame, point, relativeFrame, relativePoint, x, y)
end

--- 设置优先级
--- 设置 frame 优先级:int
---@param frame number integer
---@param priority number integer
---@return void
function japi.DZ_FrameSetPriority(frame, priority)
    japi.Exec("DzFrameSetPriority", frame, priority)
end

--- 设置缩放
--- 设置 frame 的缩放 scale
---@param frame number integer
---@param scale number
---@return void
function japi.DZ_FrameSetScale(frame, scale)
    japi.Exec("DzFrameSetScale", frame, scale)
end

--- 设置frame大小
---@param frame number integer
---@param w number 宽
---@param h number 高
---@return void
function japi.DZ_FrameSetSize(frame, w, h)
    japi.Exec("DzFrameSetSize", frame, w, h)
end

--- 设置frame步进值
--- 支持Slider
---@param frame number integer
---@param step number 步进
---@return void
function japi.DZ_FrameSetStepValue(frame, step)
    japi.Exec("DzFrameSetStepValue", frame, step)
end

--- 设置frame文本
--- 支持EditBox, TextFrame, TextArea, SimpleFontString、GlueEditBoxWar3、SlashChatBox、TimerTextFrame、TextButtonFrame、GlueTextButton
---@param frame number integer
---@param text string
---@return void
function japi.DZ_FrameSetText(frame, text)
    japi.Exec("DzFrameSetText", frame, text)
end

--- 设置frame文本对齐方式
--- 支持TextFrame、SimpleFontString、SimpleMessageFrame
---@param frame number integer
---@param align number integer ，参考blizzard:^TEXT_ALIGN
---@return void
function japi.DZ_FrameSetTextAlignment(frame, align)
    japi.Exec("DzFrameSetTextAlignment", frame, align)
end

---@param frame number integer
---@param color number integer
---@return void
function japi.DZ_FrameSetTextColor(frame, color)
    japi.Exec("DzFrameSetTextColor", frame, color)
end

--- 设置frame字数限制
--- 支持EditBox
---@param frame number integer
---@param limit number integer
---@return void
function japi.DZ_FrameSetTextSizeLimit(frame, limit)
    japi.Exec("DzFrameSetTextSizeLimit", frame, limit)
end

--- 设置frame贴图
--- 支持Backdrop、SimpleStatusBar
---@param frame number integer
---@param texture string 贴图路径
---@param flag number integer 是否平铺
---@return void
function japi.DZ_FrameSetTexture(frame, texture, flag)
    japi.Exec("DzFrameSetTexture", frame, texture, flag)
end

--- 设置提示
--- 设置 frame 的提示Frame为 tooltip
--- 设置tooltip
---@param frame number integer
---@param tooltip number integer
---@return void
function japi.DZ_FrameSetTooltip(frame, tooltip)
    japi.Exec("DzFrameSetTooltip", frame, tooltip)
end

--- 设置frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param value number
---@return void
function japi.DZ_FrameSetValue(frame, value)
    japi.Exec("DzFrameSetValue", frame, value)
end

--- 设置frame颜色
---@param frame number integer
---@param vertexColor number integer
---@return void
function japi.DZ_FrameSetVertexColor(frame, vertexColor)
    japi.Exec("DzFrameSetVertexColor", frame, vertexColor)
end

--- 设置frame显示与否
---@param frame number integer
---@param enable boolean
---@return void
function japi.DZ_FrameShow(frame, enable)
    japi.Exec("DzFrameShow", frame, enable)
end

--- 游戏界面是否限制在游戏窗口内
--- 当为false时游戏里的界面可以拖到游戏外面
---@param enable boolean
---@return void
function japi.DZ_FrameEnableClipRect(enable)
    japi.Exec("DzFrameEnableClipRect", enable)
end

--- 获取子SimpleFontString
--- ID默认填0，同名时优先获取最后被创建的。SimpleFontString为fdf中的Frame类型
---@param name string
---@param id number integer
---@return number
function japi.DZ_SimpleFontStringFindByName(name, id)
    return japi.Exec("DzSimpleFontStringFindByName", name, id)
end

--- 获取子SimpleFrame
--- ID默认填0，同名时优先获取最后被创建的。SimpleFrame为fdf中的Frame类型
---@param name string
---@param id number integer
---@return number
function japi.DZ_SimpleFrameFindByName(name, id)
    return japi.Exec("DzSimpleFrameFindByName", name, id)
end

--- 获取子SimpleTexture
--- ID默认填0，同名时优先获取最后被创建的。SimpleTexture为fdf中的Frame类型
---@param name string
---@param id number integer
---@return number
function japi.DZ_SimpleTextureFindByName(name, id)
    return japi.Exec("DzSimpleTextureFindByName", name, id)
end

--- [不明]自动重置原生UI锚点
---@param enable boolean
---@return void
function japi.DZ_OriginalUIAutoResetPoint(enable)
    japi.Exec("DzOriginalUIAutoResetPoint", enable)
end

--- 隐藏界面元素
--- 不在地图初始化时调用则会残留小地图和时钟模型
---@return void
function japi.DZ_FrameHideInterface()
    japi.Exec("DzFrameHideInterface")
end

--- 修改游戏渲染黑边
--- 上下加起来不要大于0.6
---@param upperHeight number 上方高度
---@param bottomHeight number 下方高度
---@return void
function japi.DZ_FrameEditBlackBorders(upperHeight, bottomHeight)
    japi.Exec("DzFrameEditBlackBorders", upperHeight, bottomHeight)
end

--- 使用宽屏模式
--- 地图可以根据自身特点，强制打开或关闭的宽屏优化支持功能。
--- 开启宽屏模式可以解决单位被拉伸显得比较“胖”的问题。
---@param enable boolean
---@return void
function japi.DZ_EnableWideScreen(enable)
    japi.Exec("DzEnableWideScreen", enable)
end

--- 修改屏幕比例(FOV)
---@param value number
---@return void
function japi.DZ_SetCustomFovFix(value)
    japi.Exec("DzSetCustomFovFix", value)
end

--- 获取魔兽窗口高度
---@return number
function japi.DZ_GetWindowHeight()
    return japi.Exec("DzGetWindowHeight")
end

--- 获取魔兽窗口宽度
---@return number
function japi.DZ_GetWindowWidth()
    return japi.Exec("DzGetWindowWidth")
end

--- 获取魔兽客户端高度
--- 不包括魔兽窗口边框
---@return number
function japi.DZ_GetClientHeight()
    return japi.Exec("DzGetClientHeight")
end

--- 获取魔兽客户端宽度
--- 不包括魔兽窗口边框
---@return number
function japi.DZ_GetClientWidth()
    return japi.Exec("DzGetClientWidth")
end

--- 获取魔兽窗口X坐标
---@return number integer
function japi.DZ_GetWindowX()
    return japi.Exec("DzGetWindowX")
end

--- 获取魔兽窗口Y坐标
---@return number integer
function japi.DZ_GetWindowY()
    return japi.Exec("DzGetWindowY")
end

--- 设置魔兽窗口大小
---@param width number
---@param height number
---@return number integer
function japi.DZ_ChangeWindowSize(width, height)
    return japi.Exec("DzChangeWindowSize", width, height)
end

--- 判断游戏窗口是否处于活动状态
---@return boolean
function japi.DZ_IsWindowActive()
    return japi.Exec("DzIsWindowActive")
end

--- 判断按键是否按下
---@param iKey number integer 参考 blizzard:^GAME_KEY_*
---@return boolean
function japi.DZ_IsKeyDown(iKey)
    return japi.Exec("DzIsKeyDown", iKey)
end

--- 事件响应 - 获取触发的按键
--- 响应 [硬件] - 按键事件
---@return number integer
function japi.DZ_GetTriggerKey()
    return japi.Exec("DzGetTriggerKey")
end

--- 事件响应 - 获取触发硬件事件的玩家
--- 响应 [硬件] - 按键事件 滚轮事件 窗口大小变化事件
---@return number player
function japi.DZ_GetTriggerKeyPlayer()
    return japi.Exec("DzGetTriggerKeyPlayer")
end

--- 鼠标是否在游戏内
---@return boolean
function japi.DZ_IsMouseOverUI()
    return japi.Exec("DzIsMouseOverUI")
end

--- 设置鼠标的坐标
---@param x number integer
---@param y number integer
---@return void
function japi.DZ_SetMousePos(x, y)
    return japi.Exec("DzSetMousePos", x, y)
end

--- 鼠标所在的Frame控件指针
--- 不是所有类型的Frame都能响应鼠标，能响应的有BUTTON，TEXT等
---@return number integer
function japi.DZ_GetMouseFocus()
    return japi.Exec("DzGetMouseFocus")
end

--- 获取鼠标在游戏内的坐标X
---@return number
function japi.DZ_GetMouseTerrainX()
    return japi.Exec("DzGetMouseTerrainX")
end

--- 获取鼠标在游戏内的坐标Y
---@return number
function japi.DZ_GetMouseTerrainY()
    return japi.Exec("DzGetMouseTerrainY")
end

--- 获取鼠标在游戏内的坐标Z
---@return number
function japi.DZ_GetMouseTerrainZ()
    return japi.Exec("DzGetMouseTerrainZ")
end

--- 获取鼠标在屏幕的坐标X
---@return number
function japi.DZ_GetMouseX()
    return japi.Exec("DzGetMouseX")
end

--- 获取鼠标游戏窗口坐标X
---@return number integer
function japi.DZ_GetMouseXRelative()
    return japi.Exec("DzGetMouseXRelative")
end

--- 获取鼠标在屏幕的坐标Y
---@return number
function japi.DZ_GetMouseY()
    return japi.Exec("DzGetMouseY")
end

--- 获取鼠标游戏窗口坐标Y
---@return number integer
function japi.DZ_GetMouseYRelative()
    return japi.Exec("DzGetMouseYRelative")
end

--- 获取鼠标指向的单位
---@return number unit
function japi.DZ_GetUnitUnderMouse()
    return japi.Exec("DzGetUnitUnderMouse")
end

--- 事件响应 - 获取滚轮变化值
--- 响应 [硬件] - 鼠标滚轮事件，正负区分上下
---@return number integer
function japi.DZ_GetWheelDelta()
    return japi.Exec("DzGetWheelDelta")
end

--- 设置可破坏物位置
---@param d number destructable
---@param x number
---@param y number
---@return void
function japi.DZ_DestructablePosition(d, x, y)
    japi.Exec("DzDestructablePosition", d, x, y)
end

--- 新建地形装饰物
---@param id number integer 地形装饰物
---@param var number integer 样式
---@param x number
---@param y number
---@param z number
---@param rotate number 角度
---@param scale number 缩放比例
---@return number integer
function japi.DZ_DoodadCreate(id, var, x, y, z, rotate, scale)
    return japi.Exec("DzDoodadCreate", id, var, x, y, z, rotate, scale)
end

--- 设置装饰物模型
---@param doodad number integer 地形装饰物
---@param path string 模型地址
---@return void
function japi.DZ_DoodadSetModel(doodad, path)
    japi.Exec("DzDoodadSetModel", doodad, path)
end

--- 删除装饰物
---@param doodad number integer 地形装饰物
---@return void
function japi.DZ_DoodadRemove(doodad)
    japi.Exec("DzDoodadRemove", doodad)
end

--- 让指定装饰物播放动画
---@param doodad number integer 地形装饰物
---@param animName string 动作名称
---@param animRandom boolean 是否随机播放
---@return void
function japi.DZ_DoodadSetAnimation(doodad, animName, animRandom)
    japi.Exec("DzDoodadSetAnimation", doodad, animName, animRandom)
end

--- 设置装饰物动画播放速度
---@param doodad number integer 地形装饰物
---@param scale number
---@return void
function japi.DZ_DoodadSetTimeScale(doodad, scale)
    japi.Exec("DzDoodadSetTimeScale", doodad, scale)
end

--- 设置装饰物位置到坐标xyz
---@param doodad number integer 地形装饰物
---@param x number
---@param y number
---@param z number
---@return void
function japi.DZ_DoodadSetPosition(doodad, x, y, z)
    japi.Exec("DzDoodadSetPosition", doodad, x, y, z)
end

--- 设置装饰物颜色
---@param doodad number integer 地形装饰物
---@param r number 红0-255
---@param g number 绿0-255
---@param b number 蓝0-255
---@param a number 透明度0-255
---@return void
function japi.DZ_DoodadSetColor(doodad, r, g, b, a)
    japi.Exec("DzDoodadSetColor", doodad, japi.DZ_GetColor(r, g, b, a))
end

--- 设置装饰物显示/隐藏
---@param doodad number integer 地形装饰物
---@param enable boolean
---@return void
function japi.DZ_DoodadSetVisible(doodad, enable)
    japi.Exec("DzDoodadSetVisible", doodad, enable)
end

--- 设置装饰物队伍颜色
---@param doodad number integer 地形装饰物
---@param color any PLAYER_COLOR_*
---@return void
function japi.DZ_DoodadSetTeamColor(doodad, color)
    japi.Exec("DzDoodadSetTeamColor", doodad, color)
end

--- 设置装饰物尺寸
---@param doodad number integer 地形装饰物
---@param x number
---@param y number
---@param z number
---@return void
function japi.DZ_DoodadSetOrientMatrixScale(doodad, x, y, z)
    japi.Exec("DzDoodadSetOrientMatrixScale", doodad, x, y, z)
end

--- 重置指定装饰物大小
---@param doodad number integer 地形装饰物
---@return void
function japi.DZ_DoodadSetOrientMatrixResize(doodad)
    japi.Exec("DzDoodadSetOrientMatrixResize", doodad)
end

--- 设置装饰物旋转
---@param doodad number integer 地形装饰物
---@param angle number 旋转角度
---@param axisX number
---@param axisY number
---@param axisZ number
---@return void
function japi.DZ_DoodadSetOrientMatrixRotate(doodad, angle, axisX, axisY, axisZ)
    japi.Exec("DzDoodadSetOrientMatrixRotate", doodad, angle, axisX, axisY, axisZ)
end

--- 获取装饰物的X坐标
---@param doodad number integer 地形装饰物
---@return number
function japi.DZ_DoodadGetX(doodad)
    return japi.Exec("DzDoodadGetX", doodad)
end

--- 获取装饰物的Y坐标
---@param doodad number integer 地形装饰物
---@return number
function japi.DZ_DoodadGetY(doodad)
    return japi.Exec("DzDoodadGetY", doodad)
end

--- 获取装饰物的Z坐标
---@param doodad number integer 地形装饰物
---@return number
function japi.DZ_DoodadGetZ(doodad)
    return japi.Exec("DzDoodadGetZ", doodad)
end

--- 获取装饰物动画播放速度
---@param doodad number integer 地形装饰物
---@return number
function japi.DZ_DoodadGetTimeScale(doodad)
    return japi.Exec("DzDoodadGetTimeScale", doodad)
end

--- 获取装饰物当前动画编号
---@param doodad number integer 地形装饰物
---@return number
function japi.DZ_DoodadGetCurrentAnimationIndex(doodad)
    return japi.Exec("DzDoodadGetCurrentAnimationIndex", doodad)
end

--- 获取装饰物动画数量
---@param doodad number integer 地形装饰物
---@return number
function japi.DZ_DoodadGetAnimationCount(doodad)
    return japi.Exec("DzDoodadGetAnimationCount", doodad)
end

--- 获取装饰物某个动画名
---@param doodad number integer 地形装饰物
---@param index number integer 第几个
---@return string
function japi.DZ_DoodadGetAnimationName(doodad, index)
    return japi.Exec("DzDoodadGetAnimationName", doodad, index)
end

--- 获取装饰物某个动画时间
---@param doodad number integer 地形装饰物
---@param index number integer 第几个
---@return number
function japi.DZ_DoodadGetAnimationTime(doodad, index)
    return japi.Exec("DzDoodadGetAnimationTime", doodad, index)
end

--- 降低玩家科技等级
---@param whichPlayer number 玩家
---@param techId number integer 科技
---@param removeLevels number integer 多少级
---@return void
function japi.DZ_RemovePlayerTechResearched(whichPlayer, techId, removeLevels)
    japi.Exec("DzRemovePlayerTechResearched", whichPlayer, techId, removeLevels)
end

--- 替换单位类型
--- 替换whichUnit的单位类型为:id
--- 不会替换大头像中的模型
---@param whichUnit number
---@param id number|string
---@return void
function japi.DZ_SetUnitID(whichUnit, id)
    japi.Exec("DzSetUnitID", whichUnit, id)
end

--- 替换单位模型
--- 替换whichUnit的模型:path(必须带.mdl)
--- 不会替换大头像中的模型
---@param whichUnit number
---@param model string
---@return void
function japi.DZ_SetUnitModel(whichUnit, model)
    japi.Exec("DzSetUnitModel", whichUnit, model)
end

--- 设置指定单位的名字
---@param whichUnit number
---@param name string
---@return void
function japi.DZ_SetUnitName(whichUnit, name)
    japi.Exec("DzSetUnitName", whichUnit, name)
end

--- 设置指定单位描述
---@param whichUnit number
---@param description string
---@return void
function japi.DZ_SetUnitDescription(whichUnit, description)
    japi.Exec("DzSetUnitDescription", whichUnit, description)
end

--- 设置单位头像模型
--- 用于修改指定单位的头像模型，预设英雄模型直接作为头像模型会显示异常，需找到对应的大头像地址进行绑定。
---@param whichUnit number
---@param model string
---@return void
function japi.DZ_SetUnitPortrait(whichUnit, model)
    japi.Exec("DzSetUnitPortrait", whichUnit, model)
end

--- 设置指定英雄的称谓
---@param whichUnit number
---@param name string
---@return void
function japi.DZ_SetUnitProperName(whichUnit, name)
    japi.Exec("DzSetUnitProperName", whichUnit, name)
end

--- 设置单位类型名
---@param uid number
---@param name string
---@return void
function japi.DZ_SetUnitTypeName(uid, name)
    japi.YD_SetUnitArrayString(uid, 10, 0, name)
    japi.YD_SetUnitInteger(uid, 10, 1)
end

--- 设置英雄类型称谓名
---@param uid number
---@param name string
---@return void
function japi.DZ_SetHeroTypeProperName(uid, name)
    japi.YD_SetUnitArrayString(uid, 61, 0, name)
    japi.YD_SetUnitInteger(uid, 61, 1)
end

--- 单位缩放
---@param whichUnit number
---@param scale number
---@return void
function japi.DZ_SetWidgetSpriteScale(whichUnit, scale)
    japi.Exec("DzSetWidgetSpriteScale", whichUnit, scale)
end

--- 设置单位位置 - 本地调用
---@param whichUnit number
---@param x number
---@param y number
---@return void
function japi.DZ_SetUnitPosition(whichUnit, x, y)
    japi.Exec("DzSetUnitPosition", whichUnit, x, y)
end

--- 替换单位贴图
--- 只能替换模型中有Replaceable ID x 贴图的模型，ID为索引。不会替换大头像中的模型
---@param whichUnit number
---@param path string
---@param texId number integer
---@return void
function japi.DZ_SetUnitTexture(whichUnit, path, texId)
    japi.Exec("DzSetUnitTexture", whichUnit, path, texId)
end

--- 设置单位的鼠标指向ui和血条显示/隐藏
--- 隐藏鼠标指向物品/单位时显示的血条和UI
---@param whichUnit number
---@param visible boolean
---@return void
function japi.DZ_SetUnitPreselectUIVisible(whichUnit, visible)
    japi.Exec("DzSetUnitPreselectUIVisible", whichUnit, visible)
end

--- 是否单位的护甲类型
---@param whichUnit number
---@param defenseType number 护甲类型 参考 blizzard:^DEFENSE_TYPE_*
---@return boolean
function japi.DZ_IsUnitDefenseType(whichUnit, defenseType)
    return math.round(J.GetUnitState(whichUnit, J.ConvertUnitState(0x50))) == defenseType
end

--- 设置单位的护甲类型
---@param whichUnit number
---@param defenseType number 护甲类型 参考 blizzard:^DEFENSE_TYPE_*
---@return void
function japi.DZ_SetUnitDefenseType(whichUnit, defenseType)
    japi.YD_SetUnitState(whichUnit, J.ConvertUnitState(0x50), defenseType)
end

--- 是否单位的攻击类型
---@param whichUnit number
---@param index number integer 攻击索引
---@param attackType any 攻击类型 参考 blizzard:^ATTACK_TYPE_*
---@return boolean
function japi.DZ_IsUnitAttackType(whichUnit, index, attackType)
    return J.ConvertAttackType(math.round(J.GetUnitState(whichUnit, J.ConvertUnitState(16 + 19 * index)))) == attackType
end

--- 设置单位的攻击类型
---@param whichUnit number
---@param index number integer 攻击索引
---@param attackType any 攻击类型 参考 blizzard:^ATTACK_TYPE_*
---@return void
function japi.DZ_SetUnitAttackType(whichUnit, index, attackType)
    japi.YD_SetUnitState(whichUnit, J.ConvertUnitState(16 + 19 * index), J.GetHandleId(attackType))
end

--- 禁用攻击
--- 设置单位的攻击状态，重复设置同一状态会引发bug
---@param whichUnit number
---@param disable boolean
---@return void
function japi.DZ_UnitDisableAttack(whichUnit, disable)
    japi.Exec("DzUnitDisableAttack", whichUnit, disable)
end

--- 禁用道具
--- 设置单位的道具状态，重复设置同一状态会引发bug
---@param whichUnit number
---@param disable boolean
---@return void
function japi.DZ_UnitDisableInventory(whichUnit, disable)
    japi.Exec("DzUnitDisableInventory", whichUnit, disable)
end

--- 沉默单位
--- 设置单位的沉默状态，重复设置同一状态会引发bug
---@param whichUnit number
---@param disable boolean
---@return void
function japi.DZ_UnitSilence(whichUnit, disable)
    japi.Exec("DzUnitSilence", whichUnit, disable)
end

--- 修改单位透明度
---@param whichUnit number
---@param alpha number 透明度0-255
---@param forceUpdate boolean 是否强制刷新
---@return void
function japi.DZ_UnitChangeAlpha(whichUnit, alpha, forceUpdate)
    japi.Exec("DzUnitChangeAlpha", whichUnit, alpha, forceUpdate)
end

--- 设置单位是否可以选中
---@param whichUnit number
---@param state boolean
---@return void
function japi.DZ_UnitSetCanSelect(whichUnit, state)
    japi.Exec("DzUnitSetCanSelect", whichUnit, state)
end

--- 设置单位是否可以被设置为目标
---@param whichUnit number
---@param state boolean
---@return void
function japi.DZ_UnitSetTargetAble(whichUnit, state)
    japi.Exec("DzUnitSetTargetable", whichUnit, state)
end

--- 设置单位移动类型
--- 设置单位实例的移动类型
---@param whichUnit number
---@param moveType string 移动类型，参考blizzard:^MOVE_NAME_*
---@return void
function japi.DZ_UnitSetMoveType(whichUnit, moveType)
    japi.Exec("DzUnitSetMoveType", whichUnit, moveType)
end

--- 设置单位普攻弹道速度
---@param whichUnit number
---@param speed number
---@return void
function japi.DZ_SetUnitMissileSpeed(whichUnit, speed)
    japi.Exec("DzSetUnitMissileSpeed", whichUnit, speed)
end

--- 设置单位普攻弹道模型
---@param whichUnit number
---@param path string
---@return void
function japi.DZ_SetUnitMissileModel(whichUnit, path)
    japi.Exec("DzSetUnitMissileModel", whichUnit, path)
end

--- 设置单位普攻弹道弧度
---@param whichUnit number
---@param arc number
---@return void
function japi.DZ_SetUnitMissileArc(whichUnit, arc)
    japi.Exec("DzSetUnitMissileArc", whichUnit, arc)
end

--- 设置单位普攻弹道自导允许
---@param whichUnit number
---@param enable boolean
---@return void
function japi.DZ_SetUnitMissileHoming(whichUnit, enable)
    japi.Exec("DzSetUnitMissileHoming", whichUnit, enable)
end

--- 获取升级所需经验
--- 获取单位 unit 的 level级 升级所需经验
---@param whichUnit number
---@param level number integer
---@return number integer
function japi.DZ_GetUnitNeededXP(whichUnit, level)
    return japi.Exec("DzGetUnitNeededXP", whichUnit, level)
end

--- 找出单位的指定技能
---@param whichUnit number
---@param abilityCode number integer
---@return number
function japi.DZ_UnitFindAbility(whichUnit, abilityCode)
    return japi.Exec("DzUnitFindAbility", whichUnit, abilityCode)
end

--- 获取单位普攻技能
---@param whichUnit number
---@return number
function japi.DZ_GetAttackAbility(whichUnit)
    return japi.Exec("DzGetAttackAbility", whichUnit)
end

--- 结束单位普攻技能CD
---@param whichUnit number
---@return void
function japi.DZ_AttackAbilityEndCoolDown(whichUnit)
    japi.Exec("DzAttackAbilityEndCooldown", japi.DZ_GetAttackAbility(whichUnit))
end

--- 设置道具模型
---@param whichItem number
---@param path string 模型路径
---@return void
function japi.DZ_ItemSetModel(whichItem, path)
    japi.Exec("DzItemSetModel", whichItem, path)
end

--- 设置道具颜色
---@param whichItem number
---@param color number integer [0-255]
---@return void
function japi.DZ_ItemSetVertexColor(whichItem, color)
    japi.Exec("DzItemSetVertexColor", whichItem, color)
end

--- 设置道具透明度
---@param whichItem number
---@param alpha number integer [0-255]
---@return void
function japi.DZ_ItemSetAlpha(whichItem, alpha)
    japi.Exec("DzItemSetAlpha", whichItem, alpha)
end

--- 设置物品头像
---@param whichItem number
---@param modelPath string 模型路径
---@return void
function japi.DZ_ItemSetPortrait(whichItem, modelPath)
    japi.Exec("DzItemSetPortrait", whichItem, modelPath)
end

--- 设置技能数据-字符串
---@param whichAbility number 技能
---@param key string 名字
---@param value string 内容
---@return void
function japi.DZ_AbilitySetStringData(whichAbility, key, value)
    japi.Exec("DzAbilitySetStringData", whichAbility, key, value)
end

--- 设置技能启用/禁用
--- 只对主动技能有效，可以对不同单位使用。
---@param whichAbility number
---@param enable boolean 启用状态
---@param hideUI boolean 隐藏UI
---@return void
function japi.DZ_AbilitySetEnable(whichAbility, enable, hideUI)
    japi.Exec("DzAbilitySetEnable", whichAbility, enable, hideUI)
end

--- 复活单位/英雄
---@param whichUnit number
---@param hp number 生命值
---@param mp number 魔法值
---@param x number 被复活在坐标x
---@param y number 被复活在坐标y
---@return void
function japi.DZ_ReviveUnit(whichUnit, hp, mp, x, y)
    japi.Exec("DzReviveUnit", whichUnit, hp, mp, x, y)
end

---@param whichUnit number
---@param id number integer
---@param index number integer
---@param v number integer
---@return void
function japi.DZ_SetUnitDataCacheInteger(whichUnit, id, index, v)
    japi.Exec("DzSetUnitDataCacheInteger", whichUnit, id, index, v)
end

---@param whichUnit number
---@param id number integer
---@param lv number integer
---@param v number integer
---@return void
function japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, id, lv, v)
    japi.Exec("DzUnitUIAddLevelArrayInteger", whichUnit, id, lv, v)
end

--- 绑定特效
--- 绑定特效到对象上，可以给单位/物品绑定
---@param widget number
---@param attach string
---@param whichEffect number handle
---@return void
function japi.DZ_BindEffect(widget, attach, whichEffect)
    japi.Exec("DzBindEffect", widget, attach, whichEffect)
end

--- 解除绑定特效
--- 可以让绑定在单位身上的特效分离出来，被分离的特效能设置坐标、缩放
---@param whichEffect number handle
---@return void
function japi.DZ_UnbindEffect(whichEffect)
    japi.Exec("DzUnbindEffect", whichEffect)
end

--- 设置特效透明度
---@param whichEffect number handle
---@param alpha number 透明度0-255
---@return void
function japi.DZ_SetEffectVertexAlpha(whichEffect, alpha)
    japi.Exec("DzSetEffectVertexAlpha", whichEffect, alpha)
end

--- 获取特效透明度
---@param whichEffect number handle
---@return number 透明度0-255
function japi.DZ_GetEffectVertexAlpha(whichEffect)
    return japi.Exec("DzGetEffectVertexAlpha", whichEffect)
end

--- 设置特效颜色
--- 设置特效颜色，透明无效
---@param whichEffect number handle
---@param r number 红0-255
---@param g number 绿0-255
---@param b number 蓝0-255
---@param a number 透明度0-255
---@return void
function japi.DZ_SetEffectVertexColor(whichEffect, r, g, b, a)
    japi.Exec("DzSetEffectVertexColor", whichEffect, japi.DZ_GetColor(r, g, b, a))
end

--- 获取特效颜色
---@param whichEffect number handle
---@return number integer
function japi.DZ_GetEffectVertexColor(whichEffect)
    return japi.Exec("DzGetEffectVertexColor", whichEffect)
end

--- 设置特效坐标，立即移动
---@param whichEffect number handle
---@param x number
---@param y number
---@param z number
---@return void
function japi.DZ_SetEffectPos(whichEffect, x, y, z)
    japi.Exec("DzSetEffectPos", whichEffect, x, y, z)
end

--- 特效缩放
---@param whichEffect number handle
---@param scale number
---@return void
function japi.DZ_SetEffectScale(whichEffect, scale)
    japi.Exec("DzSetEffectScale", whichEffect, scale)
end

--- 设置特效播放（编号）动画
--- 按照动画编号播放特效动画
---@param whichEffect number handle
---@param index number 动画编号
---@param flag number 播放方式
---@return void
function japi.DZ_SetEffectAnimation(whichEffect, index, flag)
    japi.Exec("DzSetEffectAnimation", whichEffect, index, flag)
end

--- 设置特效播放（动作名）动画
--- 按照动作名播放特效动画
---@param whichEffect number handle
---@param anim string 动画名称
---@param link string 变身动画才需要链接名，一般填''空字符串就行
---@return void
function japi.DZ_PlayEffectAnimation(whichEffect, anim, link)
    japi.Exec("DzPlayEffectAnimation", whichEffect, anim, link)
end

--- 设置显示/隐藏
---@param whichEffect number handle
---@param enable boolean
---@return void
function japi.DZ_SetEffectVisible(whichEffect, enable)
    japi.Exec("DzSetEffectVisible", whichEffect, enable)
end

--- 设置特效的模型
---@param whichEffect number handle
---@param model string
---@return void
function japi.DZ_SetEffectModel(whichEffect, model)
    japi.Exec("DzSetEffectModel", whichEffect, model)
end

--- 设置特效队伍颜色
---@param whichEffect number handle
---@param playerId number integer
---@return void
function japi.DZ_SetEffectTeamColor(whichEffect, playerId)
    japi.Exec("DzSetEffectTeamColor", whichEffect, playerId)
end

--- 转换屏幕坐标到世界x坐标
---@param x number
---@param y number
---@return number
function japi.DZ_ConvertScreenPositionX(x, y)
    return japi.Exec("DzConvertScreenPositionX", x, y)
end

--- 转换屏幕坐标到世界y坐标
---@param x number
---@param y number
---@return number
function japi.DZ_ConvertScreenPositionY(x, y)
    return japi.Exec("DzConvertScreenPositionY", x, y)
end

--- 转换世界坐标为屏幕坐标[异步]
---@param x number
---@param y number
---@param z number
---@param callback function
---@return boolean
function japi.DZ_ConvertWorldPosition(x, y, z, callback)
    return japi.Exec("DzConvertWorldPosition", x, y, z, callback)
end

--- 获取转换后的屏幕 X 坐标
--- 用于转换世界坐标为屏幕坐标[异步]callback中
---@return number
function japi.DZ_GetConvertWorldPositionX()
    return japi.Exec("DzGetConvertWorldPositionX")
end

--- 获取转换后的屏幕 Y 坐标
--- 用于转换世界坐标为屏幕坐标[异步]callback中
---@return number
function japi.DZ_GetConvertWorldPositionY()
    return japi.Exec("DzGetConvertWorldPositionY")
end

--- 转换世界坐标为屏幕深度[同步]
---@param x number
---@param y number
---@param z number
---@return number
function japi.DZ_ConvertWorldPositionDepth(x, y, z)
    return japi.Exec("DzConvertWorldPositionDepth", x, y, z)
end

--- 转换世界坐标为屏幕x坐标[同步]
---@param x number
---@param y number
---@param z number
---@return number
function japi.DZ_ConvertWorldPositionX(x, y, z)
    return japi.Exec("DzConvertWorldPositionX", x, y, z)
end

--- 转换世界坐标为屏幕y坐标[同步]
---@param x number
---@param y number
---@param z number
---@return number
function japi.DZ_ConvertWorldPositionY(x, y, z)
    return japi.Exec("DzConvertWorldPositionY", x, y, z)
end

--- 转换地图坐标为小地图x坐标
--- 转化地图坐标为小地图X坐标，小地图左下角为（0,0）
---@param x number
---@param y number
---@return number
function japi.DZ_FrameWorldToMinimapPosX(x, y)
    return japi.Exec("DzFrameWorldToMinimapPosX", x, y)
end

--- 转换地图坐标为小地图y坐标
--- 转化地图坐标为小地图y坐标，小地图左下角为（0,0）
---@param x number
---@param y number
---@return number
function japi.DZ_FrameWorldToMinimapPosY(x, y)
    return japi.Exec("DzFrameWorldToMinimapPosY", x, y)
end

--- 打开/关闭自定义单位的小地图图标
--- 打开关闭自定义单位的小地图图标，配合自定义指定单位的小地图图标使用
---@param whichUnit number
---@param enable boolean
---@return void
function japi.DZ_WidgetSetMinimapIconEnable(whichUnit, enable)
    japi.Exec("DzWidgetSetMinimapIconEnable", whichUnit, enable)
end

--- 自定义指定单位的小地图图标
--- 图标大小只支持16*16，设置图标之前需要打开指定单位的小地图图标显示
--- 需要 J.UnitSetUsesAltIcon(whichUnit, true) 开启中立建筑的小地图特殊标志
---@param whichUnit number
---@param path string
---@return number
function japi.DZ_WidgetSetMinimapIcon(whichUnit, path)
    return japi.Exec("DzWidgetSetMinimapIcon", whichUnit, path)
end

--- 加载Toc文件列表
---@return string
function japi.DZ_GetLocale()
    return japi.Exec("DzGetLocale")
end

--- 获取客户端语言
--- 对不同语言客户端返回不同
---@param fileName string
---@return void
function japi.DZ_LoadToc(fileName)
    japi.Exec("DzLoadToc", fileName)
end

--- 设置内存数值
--- 设置内存数据 address=value
---@param address number integer
---@param value number
---@return void
function japi.DZ_SetMemory(address, value)
    japi.Exec("DzSetMemory", address, value)
end

--- 保存内存数据
---@param cache string
---@return void
function japi.DZ_SaveMemoryCache(cache)
    japi.Exec("DzSaveMemoryCache", cache)
end

--- 设置加速倍率
---@param ratio number
---@return void
function japi.DZ_SetSpeed(ratio)
    japi.Exec("DzSetSpeed", ratio)
end

--- 获取字符串数量
---@return number
function japi.DZ_GetJassStringTableCount()
    return japi.Exec("DzGetJassStringTableCount")
end

--- 清除所有模型内存缓存
---@return void
function japi.DZ_ModelRemoveAllFromCache()
    japi.Exec("DzModelRemoveAllFromCache")
end

--- 清除指定模型内存缓存
---@param path string
---@return void
function japi.DZ_ModelRemoveFromCache(path)
    japi.Exec("DzModelRemoveFromCache", path)
end

--- 异步执行函数
--- 执行脱离代码段之内
---@param funcName string
---@return void
function japi.DZ_ExecuteFunc(funcName)
    japi.Exec("DzExecuteFunc", funcName)
end

--- 取 RGBA 色值
--- 将RGBA转换为色值，返回一个整数，用于设置DZ其他接口如Frame、Effect的颜色
---@param r number 红0-255
---@param g number 绿0-255
---@param b number 蓝0-255
---@param a number 透明度0-255
---@return number integer
function japi.DZ_GetColor(r, g, b, a)
    return japi.Exec("DzGetColor", a, r, g, b)
end

--- 获取商店目标
--- 获取指定商店选中指定玩家的哪个单位
---@param whichStore number 商店单位拥有出售物品选择英雄的单位
---@param whichPlayer number 玩家
---@return number 目标单位
function japi.DZ_GetActivePatron(whichStore, whichPlayer)
    return japi.Exec("DzGetActivePatron", whichStore, whichPlayer)
end

--- 获取玩家选中的第n个单位
--- 异步返回玩家选中的单位
---@param index number integer
---@return number 选中单位
function japi.DZ_GetLocalSelectUnit(index)
    return japi.Exec("DzGetLocalSelectUnit", index)
end

--- 获取玩家选中的单位数量
--- 异步获取玩家选中的单位数量，返回整数
---@return number integer
function japi.DZ_GetLocalSelectUnitCount()
    return japi.Exec("DzGetLocalSelectUnitCount")
end

--- 获取当前选择的单位
--- 异步获取当前预览窗口显示的单位
---@return number integer
function japi.DZ_GetSelectedLeaderUnit()
    return japi.Exec("DzGetSelectedLeaderUnit")
end

--- 获取聊天窗是否打开
--- 获取当前玩家聊天窗是否打开，异步获取
---@return boolean
function japi.DZ_IsChatBoxOpen()
    return japi.Exec("DzIsChatBoxOpen")
end

--- 获取FPS帧数
---@return number integer
function japi.DZ_GetFPS()
    return japi.Exec("DzGetFPS")
end

--- 设置FPS显示/隐藏
---@param show boolean
---@return void
function japi.DZ_ToggleFPS(show)
    japi.Exec("DzToggleFPS", show)
end

--- 解锁魔兽高清图片的512像素限制
---@param enable boolean
---@return void
function japi.DZ_UnlockBlpSizeLimit(enable)
    japi.Exec("DzUnlockBlpSizeLimit", enable)
end

--- 解锁JASS字节码限制
---@param enable boolean
---@return void
function japi.DZ_UnlockOpCodeLimit(enable)
    japi.Exec("DzUnlockOpCodeLimit", enable)
end

--- 设置剪切板内容
---@param content string
---@return boolean
function japi.DZ_SetClipboard(content)
    return japi.Exec("DzSetClipboard", content)
end

--- 打开QQ群链接
--- 调用后打开QQ群链接，必须以http://qm.qq.com开头，每分钟只会触发一次。
---@param url boolean
---@return void
function japi.DZ_OpenQQGroupUrl(url)
    japi.Exec("DzOpenQQGroupUrl", url)
end

--- 监听建筑选位置
---@param func function
---@return void
function japi.DZ_RegisterOnBuildLocal(func)
    japi.Exec("DzRegisterOnBuildLocal", func)
end

--- 获取建造的命令id
--- 用于监听建筑选位置后
---@return number
function japi.DZ_GetOnBuildOrderId()
    return japi.Exec("DzGetOnBuildOrderId")
end

--- 获取建造的命令类型
--- 用于监听建筑选位置后
---@return number
function japi.DZ_GetOnBuildOrderType()
    return japi.Exec("DzGetOnBuildOrderType")
end

--- 获取预建造对象
--- 用于监听建筑选位置后
---@return number
function japi.DZ_GetOnBuildAgent()
    return japi.Exec("DzGetOnBuildAgent")
end

--- 监听技能预选目标
---@param func function
---@return void
function japi.DZ_RegisterOnTargetLocal(func)
    japi.Exec("DzRegisterOnTargetLocal", func)
end

--- 获取监听到的技能
--- 用于监听技能预选后
---@return number
function japi.DZ_GetOnTargetAbilityId()
    return japi.Exec("DzGetOnTargetAbilId")
end

--- 获取监听到技能预选命令
--- 用于监听技能预选后
---@return number
function japi.DZ_GetOnTargetOrderId()
    return japi.Exec("DzGetOnTargetOrderId")
end

--- 获取监听到技能预选命令类型
--- 用于监听技能预选后
---@return number
function japi.DZ_GetOnTargetOrderType()
    return japi.Exec("DzGetOnTargetOrderType")
end

--- 获取监听到技能预选目标
--- 用于监听技能预选后
---@return number
function japi.DZ_GetOnTargetAgent()
    return japi.Exec("DzGetOnTargetAgent")
end

--- 获取监听到技能预选目标
--- 用于监听技能预选后
---@return number
function japi.DZ_GetOnTargetInstantTarget()
    return japi.Exec("DzGetOnTargetInstantTarget")
end

--- 同步游戏数据
--- 同步 标签：prefix  发送数据：data
---@param prefix string
---@param data string
---@return void
function japi.DZ_SyncData(prefix, data)
    japi.Exec("DzSyncData", prefix, data)
end

--- 同步游戏数据(立刻)
--- 立即同步 标签：prefix  发送数据：data
---@param prefix string
---@param data string
---@return void
function japi.DZ_SyncDataImmediately(prefix, data)
    japi.Exec("DzSyncDataImmediately", prefix, data)
end

--- 同步游戏数据（指定长度）
--- 可以按长度同步数据
---@param prefix string
---@param data string
---@param len number integer
---@return void
function japi.DZ_SyncBuffer(prefix, data, len)
    japi.Exec("DzSyncBuffer", prefix, data, len)
end

--- 数据同步
--- 标签为 prefix 的数据被同步 | 来自平台:server
--- 来自平台的参数填false
---@param trig number
---@param prefix string
---@param server boolean
---@return void
function japi.DZ_TriggerRegisterSyncData(trig, prefix, server)
    japi.Exec("DzTriggerRegisterSyncData", trig, prefix, server)
end

--- 事件响应 - 获取同步的数据
--- 响应 [同步] - 同步消息事件
---@return string
function japi.DZ_GetTriggerSyncData()
    return japi.Exec("DzGetTriggerSyncData")
end

--- 事件响应 - 获取同步数据的玩家
--- 响应 [同步] - 同步消息事件
---@return number player
function japi.DZ_GetTriggerSyncPlayer()
    return japi.Exec("DzGetTriggerSyncPlayer")
end

--- 注册实时购买商品事件（玩家获得平台道具事件）
--- 玩家在游戏中购买商城道具触发，可以配合打开商城界面使用，读取用实时购买玩家和实时购买商品
--- 玩家背包中新获得了当前地图道具的回调事件，用于地图实现玩家在游戏内商城购买成功后在游戏内立即生效。
--- 可在事件内配合<事件响应 - 获取同步数据的玩家><事件响应 - 获取同步的数据>获得回调数据
---@param trig number
---@return void
function japi.DZ_TriggerRegisterMallItemSyncData(trig)
    japi.DZ_TriggerRegisterSyncData(trig, "DZMIA", true)
end

--- 玩家消耗/使用商城道具事件
--- 注册玩家消耗地图商城道具事件（实时）
--- 玩家背包中消耗或使用商城道具的回调事件。
--- 可在事件内配合[触发的商城道具事件的玩家]、[触发的商城道具]和[商城道具最后变动的数量]使用。
---@param trig number
---@return void
function japi.DZ_TriggerRegisterMallItemConsumeEvent(trig)
    japi.DZ_TriggerRegisterSyncData(trig, "DZMIC", true)
end

--- 玩家删除商城道具事件
--- 注册玩家删除地图商城道具事件（实时）
--- 玩家背包中删除地图商城道具的回调事件。
--- 可在事件内配合[触发的商城道具事件的玩家]和[商城道具最后变动的数量]使用。（该事件一般不太可能用到，一般为商城商品被删除才会触发）
---@param trig number
---@return void
function japi.DZ_TriggerRegisterMallItemRemoveEvent(trig)
    japi.DZ_TriggerRegisterSyncData(trig, "DZMID", true)
end

--- 事件响应 - 实时获得地图商城道具的玩家
--- 实时获得地图商城道具的玩家
--- 获取是哪位玩家获得了平台道具。仅限在玩家实时获得地图商城道具事件内使用。
---@return number player
function japi.DZ_GetTriggerMallItemPlayer()
    return japi.DZ_GetTriggerSyncPlayer()
end

--- 事件响应 - 实时获得的地图商城道具
--- 实时获得的地图商城道具
--- 获取实时购买的地图商城道具。仅限在玩家实时获得地图商城道具事件内使用。
---@return string
function japi.DZ_GetTriggerMallItem()
    return japi.DZ_GetTriggerSyncData()
end

--- 全局存档变化事件
--- 本局游戏或其他游戏保存的全局存档都会触发这个事件，请使用[同步]分类下的获取同步数据来获得发生变化的全局存档KEY值
---@param trig number
---@return void
function japi.DZ_Map_Global_ChangeMsg(trig)
    japi.DZ_TriggerRegisterSyncData(trig, "DZGAU", true)
end

--- 获取公会名称
---@param whichPlayer number
---@return string
function japi.DZ_Map_GetGuildName(whichPlayer)
    return japi.Exec("DzAPI_Map_GetGuildName", whichPlayer)
end

--- 获取全局服务器存档值
---@param key string
---@return number
function japi.DZ_Map_GetMapConfig(key)
    return japi.Exec("DzAPI_Map_GetMapConfig", key)
end

--- 玩家是否拥有该商城道具（平台地图商城）
--- 平台地图商城玩家拥有该道具返还true
---@param whichPlayer number
---@param key string
---@return boolean
function japi.DZ_Map_HasMallItem(whichPlayer, key)
    return japi.Exec("DzAPI_Map_HasMallItem", whichPlayer, key)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return boolean
function japi.DZ_RequestExtraBooleanData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return japi.Exec("RequestExtraBooleanData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number integer
function japi.DZ_RequestExtraIntegerData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return japi.Exec("RequestExtraIntegerData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number
function japi.DZ_RequestExtraRealData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return japi.Exec("RequestExtraRealData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return string
function japi.DZ_RequestExtraStringData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return japi.Exec("RequestExtraStringData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

--- 活动完成
--- 完成平台活动[RPG大厅限定]
--- 用作完成某个任务，发奖励
---@param whichPlayer number
---@param key string
---@param value string
---@return void
function japi.DZ_Map_MissionComplete(whichPlayer, key, value)
    japi.DZ_RequestExtraIntegerData(1, whichPlayer, key, value, false, 0, 0, 0)
end

--- 用作取服务器上的活动数据
---@return string
function japi.DZ_Map_GetActivityData()
    return japi.DZ_RequestExtraStringData(2, nil, nil, nil, false, 0, 0, 0)
end

--- 获取玩家地图等级
---@param whichPlayer number
---@return number
function japi.DZ_Map_GetMapLevel(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(3, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 保存服务器存档
--- [错误代码]
--- 1750 地图未开通服务器存档功能
--- 1753 存档数据不一致
--- 1757 上传频率超限
--- 1758 超过每局最大值
--- 1759 数据类型不正确
--- 1191 存档变量Key长度超过64位
--- 1192 存档数量超过上限
--- 1941 服务器存档写入频率异常
--- 1250 增加的值超出上限（服务器存档防刷）
---@param whichPlayer number
---@param key string
---@param value string
---@return void
function japi.DZ_Map_SaveServerValue(whichPlayer, key, value)
    japi.DZ_RequestExtraBooleanData(4, whichPlayer, key, value, false, 0, 0, 0)
end

--- 获取服务器存档
--- [错误代码]
--- 1190 存档初始化加载失败
---@param whichPlayer number
---@param key string
---@return any|string
function japi.DZ_Map_GetServerValue(whichPlayer, key)
    return japi.DZ_RequestExtraStringData(5, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 玩家是否参与过内测
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsPresetAward(whichPlayer)
    if (japi.DZ_IsServerAlready(whichPlayer)) then
        return "1" == japi.DZ_Map_GetServerValue(whichPlayer, "preset_map_award")
    end
    return false
end

--- 读取加载服务器存档时的错误码
---@param whichPlayer number
---@return number integer
function japi.DZ_Map_GetServerValueErrorCode(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(6, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 读取玩家服务器存档成功
--- 如果返回false代表读取失败,反之成功,之后游戏里平台不会再发送“服务器保存失败”的信息，所以希望地图作者在游戏开始给玩家发下信息服务器存档是否正确读取。
---@param whichPlayer number
---@return boolean
function japi.DZ_IsServerAlready(whichPlayer)
    local res = japi.DZ_Map_GetServerValueErrorCode(whichPlayer)
    return type(res) == "number" and res == 0
end

--- 统计-提交地图数据
--- 设置房间显示的数据
--- 为服务器存档显示的数据，对应作者之家的房间key
---@param whichPlayer number
---@param key string
---@param value string
---@return void
function japi.DZ_Map_Stat_SetStat(whichPlayer, key, value)
    japi.DZ_RequestExtraIntegerData(7, whichPlayer, key, value, false, 0, 0, 0)
end

--- 天梯-统计数据
--- 天梯提交字符串数据
---@param whichPlayer number
---@param key string
---@param value string
---@return void
function japi.DZ_Map_Ladder_SetStat(whichPlayer, key, value)
    japi.DZ_RequestExtraIntegerData(8, whichPlayer, key, value, false, 0, 0, 0)
end

--- 天梯提交获得称号
---@param whichPlayer number
---@param value string
---@return void
function japi.DZ_Map_Ladder_SubmitTitle(whichPlayer, value)
    japi.DZ_Map_Ladder_SetStat(whichPlayer, value, "1")
end

--- 设置玩家额外分
---@param whichPlayer number
---@param value string
---@return void
function japi.DZ_Map_Ladder_SubmitPlayerExtraExp(whichPlayer, value)
    japi.DZ_Map_Ladder_SetStat(whichPlayer, "ExtraExp", math.floor(value))
end

--- 天梯-统计数据
---@param whichPlayer number
---@param key string
---@param value string
---@return void
function japi.DZ_Map_Ladder_SetPlayerStat(whichPlayer, key, value)
    japi.DZ_RequestExtraIntegerData(9, whichPlayer, key, value, false, 0, 0, 0)
end

--- 天梯提交玩家排名
---@param whichPlayer number
---@param value number
---@return void
function japi.DZ_Map_Ladder_SubmitPlayerRank(whichPlayer, value)
    japi.DZ_Map_Ladder_SetPlayerStat(whichPlayer, "RankIndex", math.floor(value))
end

--- 检查是否大厅地图
--- 判断当前地图是否rpg大厅来的
---@return boolean
function japi.DZ_Map_IsRPGLobby()
    return japi.DZ_RequestExtraBooleanData(10, nil, nil, nil, false, 0, 0, 0)
end

--- 获取当前游戏时间
--- 获取创建地图的游戏时间
--- 时间换算为时间戳
---@return number
function japi.DZ_Map_GetGameStartTime()
    return japi.DZ_RequestExtraIntegerData(11, nil, nil, nil, false, 0, 0, 0)
end

--- 判断地图是否在RPG天梯
---@return boolean
function japi.DZ_Map_IsRPGLadder()
    return japi.DZ_RequestExtraBooleanData(12, nil, nil, nil, false, 0, 0, 0)
end

--- 本局游戏的地图模式
--- 获取本局游戏所选择地图模式，地图模式均由作者在作者之家进行配置
--- 包括天梯排位赛模式、快速匹配模式、建房间时房主所选定的地图模式
---@return number int 本局游戏所选择的地图模式Key，该Key由作者在作者之家进行配置
function japi.DZ_Map_GetMatchType()
    return japi.DZ_RequestExtraIntegerData(13, nil, nil, nil, false, 0, 0, 0)
end

--- 获取天梯等级
--- 取值1~25，青铜V是1级
---@param whichPlayer number
---@return number
function japi.DZ_Map_GetLadderLevel(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(14, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取天梯排名
--- 排名>1000的获取值为0
---@param whichPlayer number
---@return number
function japi.DZ_Map_GetLadderRank(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(17, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家地图等级排名
--- 排名>100的获取值为0
---@param whichPlayer number
---@return number
function japi.DZ_Map_GetMapLevelRank(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(18, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取公会职责
--- 获取公会职责 Member=10 Admin=20 Leader=30
---@param whichPlayer number
---@return number
function japi.DZ_Map_GetGuildRole(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(20, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 地图配置参数
--- 获取作者在作者之家配置的地图参数（原只读类型的地图全局存档）
--- 作者可以通过此接口实现节日活动开关、口令等功能
---@param key string 栏位键，用于作者之家进行配置
---@return string 作者配置在作者之家上的参数值
function japi.DZ_Map_GetMapConfig(key)
    return japi.DZ_RequestExtraStringData(21, nil, key, nil, false, 0, 0, 0)
end

--- 读取服务器装备数据
---@param whichPlayer number
---@param key string
---@return number
function japi.DZ_Map_GetServerArchiveEquip(whichPlayer, key)
    return japi.DZ_RequestExtraIntegerData(26, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 读取服务器Boss掉落装备类型
---@param whichPlayer number
---@param key string
---@return string
function japi.DZ_Map_GetServerArchiveDrop(whichPlayer, key)
    return japi.DZ_RequestExtraStringData(27, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 触发boss击杀
---@param whichPlayer number
---@param key string
---@return void
function japi.DZ_Map_OrpgTrigger(whichPlayer, key)
    japi.DZ_RequestExtraIntegerData(28, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 获取玩家是否平台尊享会员
---@param whichPlayer number
---@return number
function japi.DZ_Map_GetPlatformVIP(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(30, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家是否平台VIP
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsPlatformVIP(whichPlayer)
    local res = japi.DZ_Map_GetPlatformVIP(whichPlayer)
    return type(res) == "number" and res > 0
end

--- 服务器公共存档组保存
--- 存储服务器存档组，服务器存档组有100个KEY，每个KEY64个字符串长度，使用前请在作者之家服务器存档组进行设置
---@param whichPlayer number
---@param key string
---@param value string
function japi.DZ_Map_SavePublicArchive(whichPlayer, key, value)
    return japi.DZ_RequestExtraBooleanData(31, whichPlayer, key, value, false, 0, 0, 0)
end

--- 读取公共服务器存档组数据
--- 服务器存档组有100个KEY，每个KEY64个字符长度，可以多张地图读取和保存，使用前先在作者之家服务器存档组设置
---@param whichPlayer number
---@param key string
---@return string
function japi.DZ_Map_GetPublicArchive(whichPlayer, key)
    return japi.DZ_RequestExtraStringData(32, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 使用地图商城道具（局数型）
--- 扣减玩家背包中的局数型道具1个，多次对同一个道具调用也只扣减1次。
--- 需先通过玩家地图商城道具剩余数量确保玩家背包中的道具剩余数量大于0。
---@param whichPlayer number
---@param key string
---@return void
function japi.DZ_Map_UseConsumablesItem(whichPlayer, key)
    japi.DZ_RequestExtraIntegerData(33, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 在游戏内的关键行为操作进行埋点，以便进行游戏内的玩家行为数据统计分析（比如某个英雄选择次数）
--- 上报前需先在作者之家创建埋点。
---@param whichPlayer number
---@param evtKey string 作者之家创建埋点时所填写的Key
---@param eventType string 预留参数，保持为空即可
---@param value number int 事件发生次数
function japi.DZ_Map_Statistics(whichPlayer, evtKey, eventType, value)
    return japi.DZ_RequestExtraBooleanData(34, whichPlayer, evtKey, eventType, false, value, 0, 0)
end

--- 读取全局存档
--- 只读的公共存档请使用另一个API读取
---@param key string 存档key
---@return string
function japi.DZ_Map_Global_GetStoreString(key)
    return japi.DZ_RequestExtraStringData(36, player.localHandle, key, nil, false, 0, 0, 0)
end

--- 保存全局存档
--- 将变量数据存储到平台服务器上的全局存档中，
--- 保存时会受到开发者平台所配置的保存规则限制。
--- 保存成功后本局游戏及同一时间正在进行的其他游戏局内的所有玩家都会收到全局存档变化事件的事件广播。
---@param key string 存档key
---@param value string
---@return void
function japi.DZ_Map_Global_StoreString(key, value)
    japi.DZ_RequestExtraBooleanData(37, player.localHandle, key, value, false, 0, 0, 0)
end

--- 读取服务器存档（区分大小写）
--- 从服务器上读取变量数据，存档变量Key区分大小写
--- [错误代码]
--- 1190 存档初始化加载失败
---@param whichPlayer number
---@param key string 存档变量Key
---@return string 服务器上最新的存档变量Value
function japi.DZ_Map_ServerArchive(whichPlayer, key)
    return japi.DZ_RequestExtraStringData(38, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 存储服务器存档（区分大小写）
--- 将变量存储到服务器，存档变量Key区分大小写。
--- 数据保存时会受到开发者平台配置的写入规则限制（防刷分、只增等）
--- [错误代码]
--- 1750 地图未开通服务器存档功能
--- 1753 存档数据不一致
--- 1757 上传频率超限
--- 1758 超过每局最大值
--- 1191 存档变量Key长度超过64位
--- 1192 存档数量超过上限
--- 1250 增加的值超出上限（服务器存档防刷）
---@param whichPlayer number
---@param key string 存档变量Key
---@param value number 存档变量Value
---@return void
function japi.DZ_Map_SaveServerArchive(whichPlayer, key, value)
    japi.DZ_RequestExtraBooleanData(39, whichPlayer, key, value, false, 0, 0, 0)
end

--- 本局游戏是否快速匹配
--- 判断玩家是否是通过匹配模式进入游戏
--- 具体模式ID使用 获取天梯和匹配的模式 获取
---@return boolean
function japi.DZ_Map_IsRPGQuickMatch()
    return japi.DZ_RequestExtraBooleanData(40, nil, nil, nil, false, 0, 0, 0)
end

--- 玩家平台道具剩余数量
--- 获取玩家 key 指定道具的剩余数量
--- 仅对次数消耗型商品有效
---@param whichPlayer number
---@param key string
---@return number integer
function japi.DZ_Map_GetMallItemCount(whichPlayer, key)
    return japi.DZ_RequestExtraIntegerData(41, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 使用地图商城道具（数量型）
--- 扣减玩家背包中的数量消耗型道具，可以多次调用
--- 使用玩家 key 商城道具 value 次
--- 仅对次数消耗型商品有效，只能使用不能恢复，请谨慎使用
---@param whichPlayer number
---@param key string
---@param value number integer
---@return void
function japi.DZ_Map_ConsumeMallItem(whichPlayer, key, value)
    japi.DZ_RequestExtraBooleanData(42, whichPlayer, key, nil, false, value, 0, 0)
end

--- 修改平台功能设置
--- 地图可以根据自身特点，强制开启/关闭游戏内辅助功能
---@param whichPlayer number
---@param option number integer 1为锁定镜头距离|2为显示血、蓝条|3为智能施法|4为平台改键|5为alt控制血条
---@param enable boolean
---@return boolean
function japi.DZ_Map_EnablePlatformSettings(whichPlayer, option, enable)
    return japi.DZ_RequestExtraBooleanData(43, whichPlayer, nil, nil, enable, option, 0, 0)
end

--- 获取玩家中游戏局数
---@param whichPlayer number
---@return number
function japi.DZ_Map_PlayedGames(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(45, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家的评论次数
--- 该功能已失效，始终返回1
---@param whichPlayer number
---@return number
function japi.DZ_Map_CommentCount(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(46, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家平台好友数量
---@param whichPlayer number
---@return number
function japi.DZ_Map_FriendCount(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(47, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- [废弃]玩家是鉴赏家
--- 评论里的鉴赏家
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsConnoisseur(whichPlayer)
    return japi.DZ_RequestExtraBooleanData(48, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家登录的是战网账号
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsBattleNetAccount(whichPlayer)
    return japi.DZ_RequestExtraBooleanData(49, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家是地图作者
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsAuthor(whichPlayer)
    return japi.DZ_RequestExtraBooleanData(50, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 地图评论次数
--- 获取该图总评论次数
---@return number integer
function japi.DZ_Map_CommentTotalCount()
    return japi.DZ_RequestExtraIntegerData(51, nil, nil, nil, false, 0, 0, 0)
end

--- [别名] DzAPI_Map_CommentTotalCount1
--- 获取自定义排行榜玩家排名
--- 100名以外的玩家排名为0
--- 该功能适用于作者之家-服务器存档-自定义排行榜
---@param whichPlayer number
---@param id number integer
---@return number integer
function japi.DZ_Map_CustomRanking(whichPlayer, id)
    return japi.DZ_RequestExtraIntegerData(52, whichPlayer, nil, nil, false, id, 0, 0)
end

--- 玩家标记
---@param whichPlayer number
---@param label number 曾经是平台回流用户=1，当前是平台回流用户=2，曾经是地图回流用户=4，当前是地图回流用户=8，地图是否被玩家收藏=16
---@return boolean
function japi.DZ_Map_PlayerFlags(whichPlayer, label)
    return japi.DZ_RequestExtraBooleanData(53, whichPlayer, nil, nil, false, label, 0, 0)
end

--- [别名] DzAPI_Map_Returns
--- 玩家曾经是地图回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsMapReturnUsed(whichPlayer)
    return japi.DZ_Map_PlayerFlags(whichPlayer, 1)
end

--- 玩家当前是平台回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsPlatformReturn(whichPlayer)
    return japi.DZ_Map_PlayerFlags(whichPlayer, 2)
end

--- 玩家曾经是平台回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsPlatformReturnUsed(whichPlayer)
    return japi.DZ_Map_PlayerFlags(whichPlayer, 4)
end

--- 玩家当前是地图回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsMapReturn(whichPlayer)
    return japi.DZ_Map_PlayerFlags(whichPlayer, 8)
end

--- 玩家收藏过地图
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsCollected(whichPlayer)
    return japi.DZ_Map_PlayerFlags(whichPlayer, 16)
end

--- 获取玩家在指定地图的地图签到数据
--- 玩家每天登录游戏后，自动签到
---@param whichPlayer number
---@return number integer
function japi.DZ_Map_ContinuousCount(whichPlayer, id)
    return japi.DZ_RequestExtraIntegerData(54, whichPlayer, nil, nil, false, id, 0, 0)
end

--- 玩家是真实玩家
--- 用于区别平台AI玩家。现在平台已经添加虚拟电脑玩家，不用再担心匹配没人问题了！如果你的地图有AI，试试在作者之家开启这个功能吧！
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_IsPlayer(whichPlayer)
    return japi.DZ_RequestExtraBooleanData(55, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 所有地图的总游戏时长
---@param whichPlayer number
---@return number
function japi.DZ_Map_MapsTotalPlayed(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(56, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 指定地图的地图等级
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function japi.DZ_Map_MapsLevel(whichPlayer, mapId)
    return japi.DZ_RequestExtraIntegerData(57, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图的平台金币消耗
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function japi.DZ_Map_MapsConsumeGold(whichPlayer, mapId)
    return japi.DZ_RequestExtraIntegerData(58, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 指定地图的平台木头消耗
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function japi.DZ_Map_MapsConsumeLumber(whichPlayer, mapId)
    return japi.DZ_RequestExtraIntegerData(59, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- [别名] DzAPI_Map_MapsConsumeLv1
--- 指定地图消费在（1~199）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.DZ_Map_MapsConsume_1_199(whichPlayer, mapId)
    return japi.DZ_RequestExtraBooleanData(60, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- [别名] DzAPI_Map_MapsConsumeLv2
--- 指定地图消费在（200~499）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.DZ_Map_MapsConsume_200_499(whichPlayer, mapId)
    return japi.DZ_RequestExtraBooleanData(61, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- [别名] DzAPI_Map_MapsConsumeLv3
--- 指定地图消费在（500~999）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.DZ_Map_MapsConsume_500_999(whichPlayer, mapId)
    return japi.DZ_RequestExtraBooleanData(62, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- [别名] DzAPI_Map_MapsConsumeLv4
--- 指定地图消费在（1000+）以上
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.DZ_Map_MapsConsume_1000(whichPlayer, mapId)
    return japi.DZ_RequestExtraBooleanData(63, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 玩家是否装备指定平台装饰、皮肤
--- 检查玩家是否装备着指定平台装饰（仅限平台和地图的合作装饰）。
--- 访问授权限制
--- 高级接口，仅限有出品平台和地图合作装饰的地图使用，平台道具ID请联系平台运营人员提供
---@param whichPlayer number
---@param skinType number int 头像=1、边框=2、称号=3、底纹=4
---@param id  number int
---@return boolean
function japi.DZ_Map_IsPlayerUsingSkin(whichPlayer, skinType, id)
    return japi.DZ_RequestExtraBooleanData(64, whichPlayer, nil, nil, false, skinType, id, 0)
end

--- 获取论坛数据
--- 是否发过贴子,是否版主时，返回为1代表肯定
---@param whichPlayer number
---@param data number integer 0=累计获得赞数，1=精华帖数量，2=发表回复次数，3=收到的欢乐数，4=是否发过贴子，5=是否版主，6=主题数量
---@return boolean
function japi.DZ_Map_GetForumData(whichPlayer, data)
    return japi.DZ_RequestExtraIntegerData(65, whichPlayer, nil, nil, false, data, 0, 0)
end

--- 游戏中弹出商城道具购买界面
--- 可以在游戏里打开指定商城道具购买界面（包括下架商品）,商品购买之后，请配合实时购买触发功能使用
---@param whichPlayer number
---@param key string
---@return boolean
function japi.DZ_Map_OpenMall(whichPlayer, key)
    return japi.DZ_RequestExtraIntegerData(66, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 玩家最近一次上安利墙时间
--- 获取玩家最近一次在当前地图的优质评论被推荐上安利墙的时间
---@param whichPlayer number
---@return number int 时间戳
function japi.DZ_Map_GetLastRecommendTime(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(67, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取玩家在当前地图的宝箱累计抽取次数
---@param whichPlayer number
---@return number int
function japi.DZ_Map_GetLotteryUsedCount(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(68, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 上报本局游戏玩家数据
--- 上报本局游戏的玩家数据，比如战斗力、杀敌数等。
--- 以下数据项 key 由平台统一定义，请勿随意自行上传：
--- RankIndex: 乱斗模式排名
--- InnerGameMode: 地图模式名称
--- GameResult: 游戏结果（上报后立即结束游戏），1=胜利，0=失败
--- GameResultNoEnd: 游戏结果（上报后不会立即结束游戏），1=胜利，0=失败
---@param whichPlayer number
---@param key string
---@param value string
---@return number int
function japi.DZ_Map_GameResult_CommitData(whichPlayer, key, value)
    return japi.DZ_RequestExtraIntegerData(69, whichPlayer, key, tostring(value), false, 0, 0, 0)
end

--- 玩家本局游戏距上一局游戏的时间差
--- 查询该玩家上次玩游戏时间至本次玩游戏时间的差值，可以利用此接口实现离线收益之类的功能。
--- 访问授权限制
--- 高级接口，需要授权后才允许使用
---@param whichPlayer number
---@return number int 时间差，单位为秒
function japi.DZ_Map_GetSinceLastPlayedSeconds(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(70, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 打开U币快速购买窗口
--- 弹出提示框询问玩家是否使用U币直接购买指定道具，作者需已在商城上架对应商品（商品信息中的道具和数量与接口所请求的参数一致）。
--- 如果前一次购买的提示框未关闭的情况下再次调用此接口，后续请求无效。
--- 购买成功后可通过玩家获得平台道具事件实现在游戏内立即生效
--- 访问授权限制
--- 高级接口，需要授权后才允许使用。
---@param whichPlayer number
---@param key string 平台道具key
---@param count number int 数量
---@param seconds number int 购买倒计时（秒数），最小5秒，最大99秒，0表示始终显示
---@return boolean
function japi.DZ_Map_CancelQuickBuy(whichPlayer, key, count, seconds)
    return japi.DZ_RequestExtraBooleanData(72, whichPlayer, key, nil, false, count, seconds, 0)
end

--- 关闭U币快速购买窗口
--- 关闭最后一次打开的U币快速购买窗口，结合打开U币快速购买窗口使用。
--- 适用于游戏场景切换后，之前的提示购买已不再适用的情况，比如游戏开始前1分钟可以更换英雄，提示玩家购买英雄更换道具，1分钟后关闭提示防止玩家误购买。
--- 访问授权限制
--- 高级接口，需要授权后才允许使用。
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_CancelQuickBuy(whichPlayer)
    return japi.DZ_RequestExtraBooleanData(73, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 本局游戏是否处于平台自测服
---@return boolean
function japi.DZ_Map_IsMapTest()
    return japi.DZ_RequestExtraBooleanData(74, nil, nil, nil, false, 0, 0, 0)
end

--- 玩家地图商城道具是否读取成功
--- 判断本局游戏中玩家的商城道具是否正确加载
---@param whichPlayer number
---@return boolean
function japi.DZ_Map_PlayerLoadedItems(whichPlayer)
    return japi.DZ_RequestExtraBooleanData(77, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 自定义排行榜上榜人数
--- 访问授权限制
--- 高级接口，需要授权后才允许使用。
---@param id number integer 开发者平台所配置的自定义排行榜key值,值为1~9
---@return boolean
function japi.DZ_Map_CustomRankCount(id)
    return japi.DZ_RequestExtraIntegerData(78, nil, nil, nil, false, id, 0, 0)
end

--- 获取排行榜上指定排名的用户名称
--- 访问授权限制
--- 高级接口，需要授权后才允许使用。
---@param id number integer 开发者平台所配置的自定义排行榜key值,值为1~9
---@return boolean
function japi.DZ_Map_CustomRankPlayerName(id, ranking)
    return japi.DZ_RequestExtraStringData(79, nil, nil, nil, false, id, ranking, 0)
end

--- 自定义排行榜上的玩家数值
--- 获取指定自定义排行榜上指定名次的玩家数值（排行榜值）。
--- 访问授权限制
--- 高级接口，需要授权后才允许使用。
---@param id number integer KK开发者平台所配置的自定义排行榜Key值
---@param ranking number 名次
---@return boolean
function japi.DZ_Map_CustomRankValue(id, ranking)
    return japi.DZ_RequestExtraIntegerData(80, nil, nil, nil, false, id, ranking, 0)
end

--- 获取玩家在平台的完整昵称（基础昵称#编号）
---@param whichPlayer number
---@return string
function japi.DZ_Map_GetPlayerUserName(whichPlayer)
    return japi.DZ_RequestExtraStringData(81, whichPlayer, nil, nil, false, 0, 0, 0)
end