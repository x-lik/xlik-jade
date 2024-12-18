--- 单位Tpl模版数据
---@class UnitTpl:UnitEnchantVast
local _index = Vast(UnitTplClass, {
    ---@type string
    _speech = '',
    ---@type string
    _speechExtra = '',
    ---@type number 当前经验值
    _exp = 0,
    ---@type number 最大等级
    _levelMax = game.expParams.unit.maxLv,
    ---@type number 当前等级
    _level = 1,
    ---@type number
    _animateScale = 1,
    ---@type number
    _attackPoint = 0.8,
    ---@type number
    _stature = 50,
    ---@type string
    _properName = "",
    ---@type table
    _material = attribute.unitMaterial.flesh,
    ---@type number
    _period = -1,
    ---@type number
    _duration = -1,
    ---@type number
    _abilityPoint = 0,
    ---@type boolean
    _building = false,
    ---@type boolean
    _immovable = false,
    ---@type boolean
    _alerter = false,
    ---@type number
    _weaponSoundMode = 1,
    ---@type number
    _weaponLength = 50,
    ---@type number
    _weaponHeight = 30,
    ---@type table
    _moveType = attribute.unitMoveType.foot,
}):extend(UnitEnchantClass)

--- 预设事件数据数组
---@see eventKind
---@param evt string 事件类型字符，参考eventKind
---@vararg string|function 可以填写(function)或(string, function)当有string参数时作为事件的key
---@return self
function _index:onEvent(evt, ...)
    if (nil == self._onEvent) then
        self._onEvent = {}
    end
    table.insert(self._onEvent, { evt, ... })
    return self
end

--- 预设置单位无技能栏
---@return self
function _index:preNoAbilitySlot()
    must(class.isObject(self, UnitTplClass), "Unit already instantiated cannot use the pre method")
    self._preNoAbilitySlot = true
    return self
end

--- 预设置单位无物品栏
---@return self
function _index:preNoItemSlot()
    must(class.isObject(self, UnitTplClass), "Unit already instantiated cannot use the pre method")
    self._preNoItemSlot = true
    return self
end

--- 预设置单位禁止攻击
---@return self
function _index:preNoAttack()
    must(class.isObject(self, UnitTplClass), "Unit already instantiated cannot use the pre method")
    self._preNoAttack = true
    return self
end

--- 预设置单位无碰撞（会关闭路径、单位、建筑碰撞）
---@return self
function _index:preNoPath()
    must(class.isObject(self, UnitTplClass), "Unit already instantiated cannot use the pre method")
    self._preNoPath = true
    return self
end

--- 预设置单位无敌
---@return self
function _index:preInvulnerable()
    must(class.isObject(self, UnitTplClass), "Unit already instantiated cannot use the pre method")
    self._preInvulnerable = true
    return self
end

--- 预设置单位蝗虫
---@return self
function _index:preLocust()
    must(class.isObject(self, UnitTplClass), "Unit already instantiated cannot use the pre method")
    self._preLocust = true
    return self
end

--- 单位TPL模版设定的技能集
---@param tpl AbilityTpl[]
---@return self
function _index:preAbility(tpl)
    must(class.isObject(self, UnitTplClass), "Unit already instantiated cannot use the pre method")
    self._preAbility = tpl
    return self
end

--- 单位TPL模版设定的物品集
---@param tpl ItemTpl[]
---@return self
function _index:preItem(tpl)
    must(class.isObject(self, UnitTplClass), "Unit already instantiated cannot use the pre method")
    self._preItem = tpl
    return self
end

--- SLK id
---@return number
function _index:slkId()
    return self._slkId
end

--- 单位碰撞体积
---@return number
function _index:collision()
    return self._collision
end

--- 单位模型
---@param variety string|nil 支持别称
---@return self|string
function _index:model(variety)
    return self:modify("model", variety)
end

--- 单位模型缩放[0.2f]
---@param variety number|nil
---@return self|number
function _index:modelScale(variety)
    return self:modify("modelScale", variety)
end

--- 单位选择圈缩放[0.2f]
---@param variety number|nil
---@return self|number
function _index:scale(variety)
    return self:modify("scale", variety)
end

--- 自定义地面纹理
--- 有splat数据的单位将被视为建筑
--- 你也可以在speech中的slk数据中设定uberSplat处理地面纹理替代此方法
---@param variety string|nil
---@return self|string
function _index:splat(variety)
    return self:modify("splat", variety)
end

--- 单位动画速度[0.2f]
---@param variety number|nil
---@return self|number
function _index:animateScale(variety)
    return self:modify("animateScale", variety)
end

--- 设置单位动画动作
---@param variety string[]|nil
---@return self|string[]
function _index:animateProperties(variety)
    return self:modify("animateProperties", table.unique(variety))
end

--- 施法通用动作
--- 优先级比Ability的动作高
---@param variety string|nil
---@return self|string
function _index:spellAnimation(variety)
    return self:modify("spellAnimation", variety)
end

--- 持续施法动作
--- 优先级比Ability的动作高
---@param variety string|nil
---@return self|string
function _index:castKeepAnimation(variety)
    return self:modify("castKeepAnimation", variety)
end

--- 单位攻击动作击出比率点[%]
--- 默认0.8，范围[0-1.5]
---@param variety number|nil
---@return self|number
function _index:attackPoint(variety)
    return self:modify("attackPoint", variety)
end

--- 单位转身速度[0.2f]
---@param variety number|nil
---@return self|number
function _index:turnSpeed(variety)
    return self:modify("turnSpeed", variety)
end

--- 单位身材高度
---@param variety number|nil
---@return self|number
function _index:stature(variety)
    return self:modify("stature", variety)
end

--- 称谓
---@param variety string|nil
---@return self|string
function _index:properName(variety)
    return self:modify("properName", variety)
end

--- 单位动画颜色
---@param red number 红0-255
---@param green number 绿0-255
---@param blue number 蓝0-255
---@param alpha number 透明度0-255
---@param duration number 持续时间 -1无限
---@return self|number[]
function _index:rgba(red, green, blue, alpha, duration)
    if (type(red) == "number" or type(green) == "number" or type(blue) == "number" or type(alpha) == "number") then
        self:set("rgba", { red, green, blue, alpha }, duration)
        return self
    end
    return self:get("rgba")
end

--- 单位身体材质
---@param variety table|nil 看attribute.unitMaterial
---@return self|table
function _index:material(variety)
    return self:modify("material", variety)
end

--- 预配置默认攻击模式
---@param variety Assault
---@return self|Assault
function _index:assault(variety)
    return self:modify("assault", variety)
end

--- 单位武器声音模式
--- 默认1，可选2
--- 1为击中时发声，2为攻击点动作时发声
---@param variety number|nil
---@return self|number
function _index:weaponSoundMode(variety)
    return self:modify("weaponSoundMode", variety)
end

--- 单位武器声音
---@param variety string|nil
---@return self|string
function _index:weaponSound(variety)
    return self:modify("weaponSound", variety)
end

--- 武器长度
--- 默认50，箭矢将从伸长的位置开始生成
---@param variety number|nil
---@return self|number
function _index:weaponLength(variety)
    return self:modify("weaponLength", variety)
end

--- 武器高度
--- 默认30，箭矢将从对应高度的位置开始生成
---@param variety number|nil
---@return self|number
function _index:weaponHeight(variety)
    return self:modify("weaponHeight", variety)
end

--- 单位移动类型
---@param variety table|nil 看attribute.unitMoveType
---@return self|table
function _index:moveType(variety)
    return self:modify("moveType", variety)
end

--- 生命周期
--- 默认-1
---@param variety number|nil
---@return self|number
function _index:period(variety)
    return self:modify("period", variety)
end

--- 存在时间（不会触发死亡）
--- 默认-1
---@param variety number|nil
---@return self|number
function _index:duration(variety)
    return self:modify("duration", variety)
end

--- 主属性（假设的）
--- 假定模拟魔兽3属性，实质无功能，框架未做其余任何处理
---@param variety table|nil 看 attribute.unitPrimary
---@return self|table
function _index:primary(variety)
    return self:modify("primary", variety)
end

--- 单位飞行高度
---@param variety number|nil
---@return self|number
function _index:flyHeight(variety)
    return self:modify("flyHeight", variety)
end

--- 单位当前经验
---@param variety number|nil
---@return self|number
function _index:exp(variety)
    if (nil ~= variety) then
        variety = math.cale(variety, self._exp)
        variety = math.max(0, variety)
        variety = math.min(game.unitExpNeeds(game.expParams.unit.maxLv), variety)
    end
    return self:modify("exp", variety)
end

--- 单位最大级
---@param variety number|nil
---@return self|number
function _index:levelMax(variety)
    if (nil ~= variety) then
        variety = math.cale(variety, self._levelMax)
        variety = math.min(game.expParams.unit.maxLv, variety)
    end
    return self:modify("levelMax", variety)
end

--- 单位当前等级
---@param variety number|nil
---@return self|number
function _index:level(variety)
    if (nil ~= variety) then
        variety = math.cale(variety, self._level)
        variety = math.max(1, variety)
        variety = math.min(self._levelMax, variety)
    end
    return self:modify("level", variety)
end

--- 单位技能点数量
---@param variety number|nil
---@return self|number
function _index:abilityPoint(variety)
    return self:modify("abilityPoint", variety)
end

--- 警示单位设定，令它释放技能时有范围提示
--- 一般用于boss
---@param variety nil|boolean
---@return self|boolean
function _index:alerter(variety)
    return self:modify("alerter", variety)
end

--- 尸体持续时间
--- 默认[slk.death]秒，小于等于0则无尸体
---@param variety number|nil
---@return self|number
function _index:corpse(variety)
    return self:modify("corpse", variety)
end

--- 构造单位Tpl对象
--- 构建模版数据供Unit方法使用
--- Tpl数据修改时会影响引用的上层对象，但无法触发对象的modifier执行
--- 可手动执行VastModifierAct，额外补充执行
---@param speech string 定义时固定，后续不允许修改
---@param speechExtra string 定义时固定，后续不允许修改
---@return UnitTpl
function UnitTpl(speech, speechExtra)
    local params = {}
    if (type(speech) == "string") then
        params._speech = speech
    end
    if (type(speechExtra) == "string") then
        params._speechExtra = speechExtra
    end
    ---@type UnitTpl
    local o = oVast(params, _index)
    local s = japi.AssetsSpeech(o._speech)
    must(type(s) == "string", "Invalid speech")
    local id
    if (type(o._speechExtra) == "string" and o._speechExtra ~= '') then
        id = slk.n2i(s .. "|EX|" .. o._speechExtra)
    end
    if (nil == id) then
        id = slk.n2i(s .. "|D")
    end
    -- TPL在创建时分配模版数据
    -- 故不应该也不支持后续修改speech、speechExtra
    o:set("slkId", J.C2I(id))
    return o
end