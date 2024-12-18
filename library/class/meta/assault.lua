--- Assault，自定义攻击模式
---@class Assault:Meta
local _index = Meta(AssaultClass, {
    _mode = "instant", -- 模式，默认的立刻模式（指单位攻击动作结束无需过程瞬间就击中目标的情形）
    _priority = 0, -- 优先级，越大优先级越高越会被视为单位的首选攻击模式
    _damageType = injury.damageType.common, -- 伤害类型
    _damageTypeLevel = 0, -- 伤害强度等级，应用于附魔反应判定，强的等级能覆盖弱等级，反之不能，只能造成反应
    _model = nil, -- 弹道箭矢或电链的特效（构建时结合输入model参数自动分析定义）
    _scale = 1.0, -- 模型大小缩放 [missile]
    _speed = 600, -- 飞行速度 [missile]
    _height = 0, -- 飞行高度 [missile]
    _acceleration = 0, -- 飞行加速度 [missile]
    _twist = false, -- 箭矢扭曲 [missile]
    _homing = false, -- 自动跟踪 [missile]
    _gatling = 0, -- 加特林 [missile]
    _scatter = 0, -- 散射数量 [missile|lightning]
    _radius = 0, -- 散射捕捉范围 [missile|lightning]
    _reflex = 0, -- 反射次数 [missile|lightning]
    _focus = 0, -- 聚焦效果 [lightning]
})

--- 获取模式形态
---@return number
function _index:mode()
    return self._mode
end

--- 获取优先级（越大优先级越高越会被视为单位的首选攻击模式）
---@return number
function _index:priority()
    return self._priority
end

--- 获取伤害类型
---@see injury#damageType
---@return table
function _index:damageType()
    return self._damageType
end

--- 获取伤害类型等级，默认0
---@return number
function _index:damageTypeLevel()
    return self._damageTypeLevel
end

--- 获取箭矢路径或电链类型
---@return string|table
function _index:model()
    return self._model
end

--- 获取模型缩放，默认1.0
---@return number
function _index:scale()
    return self._scale
end

--- 获取箭矢飞行速度，默认600
---@return number
function _index:speed()
    return self._speed
end

--- 获取箭矢抛离地高度，默认0
--- 此为预期高度，实际上箭矢飞行中的高度会根据实况而变，箭矢并不会固定某高度
---@return number
function _index:height()
    return self._height
end

--- 获取箭矢飞行加速度，默认0
---@return number
function _index:acceleration()
    return self._acceleration
end

--- 是否扭曲，默认false
---@return boolean
function _index:twist()
    return true == self._twist
end

--- 是否自动追踪，默认false
---@return boolean
function _index:homing()
    return self._homing
end

--- 获取加特林效果，默认0
---@return number
function _index:gatling()
    return self._gatling
end

--- 获取散射目标数量，默认0
---@return number
function _index:scatter()
    return self._scatter
end

--- 获取散射范围，默认0
---@return number
function _index:radius()
    return self._radius
end

--- 获取反弹目标数量，默认0
---@return number
function _index:reflex()
    return self._reflex
end

--- 获取聚焦次数，默认0
---@return number
function _index:focus()
    return self._focus
end

--- 构造攻击模式对象
--- instant 立刻模式（指单位攻击动作结束无需过程瞬间就击中目标的情形）[默认]
--- missile 弹道模式
--- lightning 电链模式
--- 单位[nil 没有攻击模式]会被视为近战（不需要特定伤害类型攻击时则不需要设置攻击模式）
--- 单位[mode=='instant' and range<=200 攻击范围200以下的立即]也会被视为近战（需要特定伤害类型攻击时则用这个）
---@alias AssaultPotions0 {mode:'instant'|'missile'|'lightning',priority:number,damageType:table,damageTypeLevel:number}
---@alias AssaultPotions2 {model:string|table,scatter:number,radius:number,reflex:number}
---@alias AssaultPotionsM {scale:number,speed:number,height:number,acceleration:number,twist:boolean,gatling:number,homing:boolean}
---@alias AssaultPotionsL {focus:number}
---@alias AssaultPotions AssaultPotions0|AssaultPotions2|AssaultPotionsM|AssaultPotionsL
---@param options AssaultPotions
---@return Assault
function Assault(options)
    sync.must()
    local params = {}
    local mode = options.mode
    if (type(mode) == "string") then
        params._mode = mode
    end
    -- 分析模式
    if (mode == "missile") then
        -- missile参数组合
        must(type(options.model) == "string", "options.model@string")
        params._model = japi.AssetsModel(options.model)
        if (type(options.scale) == "number") then params._scale = options.scale end
        if (type(options.speed) == "number") then params._speed = options.speed end
        if (type(options.height) == "number") then params._height = options.height end
        if (type(options.acceleration) == "number") then params._acceleration = options.acceleration end
        if (type(options.twist) == "boolean") then params._twist = options.twist end
        if (type(options.gatling) == "number") then params._gatling = options.gatling end
        if (type(options.scatter) == "number") then params._scatter = options.scatter end
        if (type(options.radius) == "number") then params._radius = options.radius end
        if (type(options.reflex) == "number") then params._reflex = options.reflex end
        if (type(options.homing) == "boolean") then params._homing = options.homing end
    elseif (mode == "lightning") then
        -- lightning参数组合
        must(type(options.model) == "table", "options.model@table")
        params._model = options.model
        if (type(options.scatter) == "number") then params._scatter = options.scatter end
        if (type(options.radius) == "number") then params._radius = options.radius end
        if (type(options.reflex) == "number") then params._reflex = options.reflex end
        if (type(options.focus) == "number") then params._focus = options.focus end
    end
    if (type(options.priority) == "number") then params._priority = options.priority end
    if (type(options.damageType) == "table") then params._damageType = options.damageType end
    if (type(options.damageTypeLeve) == "number") then params._damageTypeLeve = options.damageTypeLeve end
    return oMeta(params, _index)
end

--- 默认攻击模式
--- 单位Unit没有设置模式时使用:assault()返回此值
---@type Assault
AssaultDefault = Assault({})