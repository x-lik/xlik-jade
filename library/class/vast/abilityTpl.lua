--- 技能Tpl模版数据
---@class AbilityTpl:Tpl
local _index = Vast(AbilityTplClass, {
    ---@type string 施法动作
    _spellAnimation = "spell",
    ---@type string 持续施法动作
    _castKeepAnimation = "spell",
    ---@type number 施法匣次数（默认0）（有匣则允许技能连续用多次，比如此匣拥有3次施法次数，可以连续使用3次后才不可使用）
    _castPotTimes = 0,
    ---@type number 施法匣余下次数
    _castPotRemain = 0,
    ---@type number 施法匣计数方式（默认1） 1一次施法后就进入多轮内冷却、2全部次数施法完毕才进入主冷却
    _castPotType = 1,
    ---@type number 施法距离[基础]
    _castDistanceBase = 600,
    ---@type number 施法圆半径[基础]
    _castRadiusBase = 0,
    ---@type number 施法宽度[基础]
    _castWidthBase = 0,
    ---@type number 施法高度[基础]
    _castHeightBase = 0,
    ---@type number 蓄力加成[%]
    _amassIncrease = 1,
    ---@type number 当前经验值
    _exp = 0,
    ---@type number 最大等级
    _levelMax = game.expParams.ability.maxLv,
    ---@type number 当前等级
    _level = 1,
    ---@type number 升级需求
    _levelUpNeedPoint = 0,
    ---@type number 指针规划距离
    _cursorPlanDistance = 64,
}):extend(TplClass)

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

--- 预设单位事件数据数组
---@see eventKind
---@param evt string 事件类型字符，参考eventKind
---@vararg string|function 可以填写(function)或(string, function)当有string参数时作为事件的key
---@return self
function _index:onUnitEvent(evt, ...)
    if (nil == self._onUnitEvent) then
        self._onUnitEvent = {}
    end
    table.insert(self._onUnitEvent, { evt, ... })
    return self
end

--- 技能当前经验
---@param variety number|nil
---@return self|number
function _index:exp(variety)
    if (nil ~= variety) then
        variety = math.cale(variety, self._exp)
        variety = math.max(0, variety)
        variety = math.min(game.abilityExpNeeds(game.expParams.ability.maxLv), variety)
    end
    return self:modify("exp", variety)
end

--- 技能最大级
---@param variety number|nil
---@return self|number
function _index:levelMax(variety)
    if (nil ~= variety) then
        variety = math.cale(variety, self._levelMax)
        variety = math.min(game.expParams.ability.maxLv, variety)
    end
    return self:modify("levelMax", variety)
end

--- 技能当前等级
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

--- 技能升级所需技能点,小于1则无法升级
---@param variety number|nil
---@return self|number
function _index:levelUpNeedPoint(variety)
    return self:modify("levelUpNeedPoint", variety)
end

--- 技能类型（目标类型）
---@param variety string|nil 看 ability.target
---@return self|string
function _index:targetType(variety)
    return self:modify("targetType", variety)
end

--- 技能目标允许过滤函数
--- 默认为nil，不允许任何目标
---@alias AbilityCastTargetFilter fun(self:Ability,targetUnit:Unit):boolean
---@param variety AbilityCastTargetFilter
---@return self|AbilityCastTargetFilter|nil
function _index:targetFilter(variety)
    return self:modify("targetFilter", variety)
end

--- 施法通用动作
---@param variety string|nil
---@return self|string
function _index:spellAnimation(variety)
    return self:modify("spellAnimation", variety)
end

--- [成长推导]血耗
---@param base number
---@param vary number
---@return self
function _index:hpCostAdv(base, vary)
    return ability.anyCostAdv(self, "hp", base, vary, ability.hpCostCond, ability.hpCostDeplete, ability.hpCostValue)
end

--- [实际]血耗
---@param whichLevel number|nil
---@return number
function _index:hpCost(whichLevel)
    return ability.anyCost(self, "hp", whichLevel, 0)
end

--- [成长推导]蓝耗
---@param base number
---@param vary number
---@return self
function _index:mpCostAdv(base, vary)
    return ability.anyCostAdv(self, "mp", base, vary, ability.mpCostCond, ability.mpCostDeplete, ability.mpCostValue)
end

--- [实际]蓝耗
---@param whichLevel number|nil
---@return number
function _index:mpCost(whichLevel)
    return ability.anyCost(self, "mp", whichLevel, 0)
end

--- [成长推导]财耗
---@param base table
---@param vary table
---@return self
function _index:worthCostAdv(base, vary)
    return ability.anyCostAdv(self, "worth", base, vary, ability.worthCostCond, ability.worthCostDeplete, ability.worthCostValue)
end

--- [实际]财耗
---@param whichLevel number|nil
---@return table|nil
function _index:worthCost(whichLevel)
    return ability.anyCost(self, "worth", whichLevel, nil)
end

--- [成长推导]蓄力时间（帧）
---@see Ability#amass
---@param base number
---@param vary number
---@return self
function _index:amassAdv(base, vary)
    if (nil ~= base) then self:set("amassBase", base) end
    if (nil ~= vary) then self:set("amassVary", vary) end
    return self
end

--- [计算推导]蓄力帧增幅（百分比%，默认1%）
--- 蓄力每经过1帧的效果加成，效果加成的具体效果需要在自定义技能中自行设计
--- 计算公式：蓄力比率*(最大蓄力帧数/蓄力帧增幅)%
--- amassRatio*(amass/amassIncrease)*0.01
--- 下面以默认值10%举例：
--- 例子1：如果最大蓄力时间为100帧，蓄力了50帧（之内），则amassRatio等于0.5，技能效果应为100%(原有的)+50%=150%
--- 例子2：如果最大蓄力时间为100帧，蓄力了120帧（溢出），则amassRatio等于1.0，技能效果应为100%(原有的)+100%=200%
---@param variety nil|number
---@return self|number
function _index:amassIncrease(variety)
    return self:modify("amassIncrease", variety)
end

--- [实际]最大蓄力时间（帧）
--- 蓄力的数据使用的帧来进行计算，秒数据为估算一般只用于UI大概知情显示
---@param whichLevel number|nil
---@param toSec boolean 是否估算为秒，默认nil即false
---@return number
function _index:amass(whichLevel, toSec)
    local val = ability.caleValueNumber(self, whichLevel, "amass", "amassPercent", "amass")
    val = math.max(0, math.ceil(val))
    if (true == toSec) then
        val = math.trunc(val / 60, 1)
    end
    return val
end

--- [实际]蓄力增幅比率
---@param ratio number 蓄力程度比率
---@return number
function _index:amassIncreaseRatio(ratio)
    if (type(ratio) ~= "number" or ratio <= 0) then
        return 0
    end
    local incr = self:amassIncrease()
    local amass = self:amass()
    if (incr <= 0 or amass <= 0) then
        return 0
    end
    return math.trunc(0.01 * ratio * amass * incr, 3)
end

--- [成长推导]冷却时间
---@param base number
---@param vary number
---@return self
function _index:coolDownAdv(base, vary)
    if (nil ~= base) then self:set("coolDownBase", base) end
    if (nil ~= vary) then self:set("coolDownVary", vary) end
    return self
end

--- [实际]冷却时间（秒）
---@param whichLevel number|nil
---@return number
function _index:coolDown(whichLevel)
    local val = ability.caleValueNumber(self, whichLevel, "coolDown", "coolDownPercent", "coolDown")
    return math.max(0, math.trunc(val))
end

--- 施法匣次数
---@param variety number|nil
---@return self|number
function _index:castPotTimes(variety)
    return self:modify("castPotTimes", variety)
end

--- 施法匣类型
---@param variety number|nil integer 1一次施法后就进入多轮内冷却、2全部次数施法完毕才进入主冷却
---@return self|number
function _index:castPotType(variety)
    return self:modify("castPotType", variety)
end

--- [成长推导]吟唱等待（秒）
---@param base number
---@param vary number
---@return self
function _index:castChantAdv(base, vary)
    if (nil ~= base) then self:set("castChantBase", base) end
    if (nil ~= vary) then self:set("castChantVary", vary) end
    return self
end

--- 吟唱附着(attach:origin)特效
--- 没有吟唱时间则附着特效无效
---@param variety nil|string
---@return self|string
function _index:castChantEffect(variety)
    return self:modify("castChantEffect", variety)
end

--- [实际]吟唱等待（秒）
--- 被动技能没有吟唱时间
---@param whichLevel number|nil
---@return number
function _index:castChant(whichLevel)
    local val = ability.caleValueNumber(self, whichLevel, "castChant", "castChantPercent", "castChant")
    return math.max(0, math.trunc(val, 2))
end

--- [成长推导]施法持续（秒）
---@param base number
---@param vary number
---@return self
function _index:castKeepAdv(base, vary)
    if (nil ~= base) then self:set("castKeepBase", base) end
    if (nil ~= vary) then self:set("castKeepVary", vary) end
    return self
end

--- [实际]施法持续（秒）
---@param whichLevel number|nil
---@return number
function _index:castKeep(whichLevel)
    local val = ability.caleValueNumber(self, whichLevel, "castKeep", "castKeepPercent", "castKeep")
    return math.max(0, math.trunc(val, 2))
end

--- 持续施法动作
---@param variety string|nil
---@return self|string
function _index:castKeepAnimation(variety)
    return self:modify("castKeepAnimation", variety)
end

--- [成长推导]施法距离 [默认600]
---@param base number
---@param vary number
---@return self
function _index:castDistanceAdv(base, vary)
    if (nil ~= base) then self:set("castDistanceBase", base) end
    if (nil ~= vary) then self:set("castDistanceVary", vary) end
    return self
end

--- [实际]施法距离
---@param whichLevel number|nil
---@return number
function _index:castDistance(whichLevel)
    local val = ability.caleValueNumber(self, whichLevel, "castDistance", "castDistancePercent", "castDistance")
    return math.max(0, math.round(val))
end

--- [成长推导]施法圆形半径 [默认0]
---@param base number
---@param vary number
---@return self
function _index:castRadiusAdv(base, vary)
    if (nil ~= base) then self:set("castRadiusBase", base) end
    if (nil ~= vary) then self:set("castRadiusVary", vary) end
    return self
end

--- [实际]施法圆形半径
---@param whichLevel number|nil
---@return number
function _index:castRadius(whichLevel)
    local val = ability.caleValueNumber(self, whichLevel, "castRadius", "castRangePercent", "castRange")
    return math.max(0, math.round(val))
end

--- [成长推导]施法方形宽度 [默认0]
---@param base number
---@param vary number
---@return self
function _index:castWidthAdv(base, vary)
    if (nil ~= base) then self:set("castWidthBase", base) end
    if (nil ~= vary) then self:set("castWidthVary", vary) end
    return self
end

--- [实际]施法方形宽度
---@param whichLevel number|nil
---@return number
function _index:castWidth(whichLevel)
    local val = ability.caleValueNumber(self, whichLevel, "castWidth", "castRangePercent", "castRange")
    return math.max(0, math.round(val))
end

--- [成长推导]施法方形高度 [默认0]
---@param base number
---@param vary number
---@return self
function _index:castHeightAdv(base, vary)
    if (nil ~= base) then self:set("castHeightBase", base) end
    if (nil ~= vary) then self:set("castHeightVary", vary) end
    return self
end

--- [实际]施法方形高度
---@param whichLevel number|nil
---@return number
function _index:castHeight(whichLevel)
    local val = ability.caleValueNumber(self, whichLevel, "castHeight", "castRangePercent", "castRange")
    return math.max(0, math.round(val))
end

--- 设置指针条件（一般用于指引指针的逻辑走势）
--- 需设置一个function，回调一个status，一般为integer
--- 默认返回数0，表示无条件，其他数字代表其他的自定义含义
---@alias AbilityCursorData {x:number,y:number,radius:number,width:number,height:number}
---@alias AbilityCursorFilter fun(data:AbilityCursorData):number
---@param variety AbilityCursorFilter|nil
---@return self|AbilityCursorFilter
function _index:cursorCond(variety)
    return self:modify("cursorCond", variety)
end

--- 构造技能Tpl对象
--- 构建模版数据供Ability方法使用
--- Tpl数据修改时会影响引用的上层对象，但无法触发对象的modifier执行
--- 可手动执行VastModifierAct，额外补充执行
---@return AbilityTpl
function AbilityTpl()
    return oVast({}, _index)
end