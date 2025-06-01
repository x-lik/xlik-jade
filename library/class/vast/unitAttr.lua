--- current class name
UnitAttrClass = "UnitAttr"

--- 单位属性单项模版数据
--- 方便Unit对象单独设置某个属性
---[[:use library/class/vast/tpl]]
---@class UnitAttrVast:Tpl
local _index = Vast(UnitAttrClass, {
    ---@type number
    _reborn = -1e3,
    ---@type number
    _rebornHP = 100,
    ---@type number
    _rebornMP = 100,
    ---@type number
    _rebornInvulnerable = 3.476,
    ---@type number
    _hpRegen = 0,
    ---@type number
    _hp = 1e4,
    ---@type number
    _hpCur = 1e4,
    ---@type number
    _mpRegen = 0,
    ---@type number
    _mp = 1e4,
    ---@type number
    _mpCur = 1e4,
    ---@type number
    _sightBase = 0,
    ---@type number
    _sightDiff = 0,
    ---@type number
    _sight = 0,
    ---@type number
    _nsight = 0,
    ---@type number
    _attack = 0,
    ---@type number
    _attackSpaceBase = 0,
    ---@type number
    _attackSpace = 0,
    ---@type number
    _attackSpeed = 0,
    ---@type number
    _attackRangeAcquire = 0,
    ---@type number
    _attackRangeMin = 0,
    ---@type number
    _attackRange = 0,
    ---@type number
    _attackRipple = 0,
    ---@type number
    _defend = 0,
    ---@type number
    _move = 0,
    ---@type number
    _str = 0,
    ---@type number
    _agi = 0,
    ---@type number
    _int = 0,
    ---@type number
    _damageIncrease = 0,
    ---@type number
    _visible = 0,
    ---@type number
    _costPercent = 0,
    ---@type number
    _cost = 0,
    ---@type number
    _amassPercent = 0,
    ---@type number
    _amass = 0,
    ---@type number
    _coolDownPercent = 0,
    ---@type number
    _coolDown = 0,
    ---@type number
    _castChantPercent = 0,
    ---@type number
    _castChant = 0,
    ---@type number
    _castKeepPercent = 0,
    ---@type number
    _castKeep = 0,
    ---@type number
    _castDistancePercent = 0,
    ---@type number
    _castDistance = 0,
    ---@type number
    _castRangePercent = 0,
    ---@type number
    _castRange = 0,
}):extend(TplClass)

--- 复活时间
--- 负数表示不能复活，建议不能复活设置-999以上，排除动态影响
---@param variety number|nil
---@return self|number
function _index:reborn(variety)
    return self:modify("reborn", variety)
end

--- 复活HP百分比（%）0-100
--- 设为0复活HP最低也会有1点
---@param variety number|nil
---@return self|number
function _index:rebornHP(variety)
    return self:modify("rebornHP", variety)
end

--- 复活MP百分比（%）0-100
--- 当设定数值计算后比死亡前MP数值小，取前MP数值
---@param variety number|nil
---@return self|number
function _index:rebornMP(variety)
    return self:modify("rebornMP", variety)
end

--- 复活后无敌时间
--- 默认3.476
---@param variety number|nil
---@return self|number
function _index:rebornInvulnerable(variety)
    return self:modify("rebornInvulnerable", variety)
end

--- HP
---@param variety number
---@return self|number
function _index:hp(variety)
    return self:modify("hp", variety)
end

--- HP[当前]
---@param variety number
---@return self|number
function _index:hpCur(variety)
    return self:modify("hpCur", variety)
end

--- HP[恢复]
---@param variety number
---@return self|number
function _index:hpRegen(variety)
    return self:modify("hpRegen", variety)
end

--- MP
---@param variety number
---@return self|number
function _index:mp(variety)
    return self:modify("mp", variety)
end

--- MP[当前]
---@param variety number
---@return self|number
function _index:mpCur(variety)
    return self:modify("mpCur", variety)
end

--- MP[恢复]
---@param variety number
---@return self|number
function _index:mpRegen(variety)
    return self:modify("mpRegen", variety)
end

--- 基础视野
---@return self|number
function _index:sightBase()
    return self._sightBase
end

--- 昼夜视野差
---@return self|number
function _index:sightDiff()
    return self._sightDiff
end

--- 白昼视野
---@param variety number
---@return self|number
function _index:sight(variety)
    return self:modify("sight", variety)
end

--- 黑夜视野
---@param variety number
---@return self|number
function _index:nsight(variety)
    return self:modify("nsight", variety)
end

--- 攻击
---@param variety number
---@return self|number
function _index:attack(variety)
    return self:modify("attack", variety)
end

--- 攻击基础频率
---@param variety number
---@return self|number
function _index:attackSpaceBase(variety)
    return self:modify("attackSpaceBase", variety)
end

--- 攻击速度加成[%]
---@param variety number
---@return self|number
function _index:attackSpeed(variety)
    return self:modify("attackSpeed", variety)
end

--- 攻击频率[当前|实际]
---@return number
function _index:attackSpace()
    local as = self._attackSpace
    as = math.max(0.1, as)
    as = math.min(5, as)
    return as
end

--- 主动攻击范围
---@param variety number
---@return self|number
function _index:attackRangeAcquire(variety)
    return self:modify("attackRangeAcquire", variety)
end

--- 最小攻击范围
--- 默认0，只在攻击模式为远程时生效，不可大于攻击范围
---@param variety number
---@return self|number
function _index:attackRangeMin(variety)
    return self:modify("attackRangeMin", variety)
end

--- 攻击范围
---@param variety number
---@return self|number
function _index:attackRange(variety)
    return self:modify("attackRange", variety)
end

--- 随机浮动动态攻击
---@param variety number
---@return self|number
function _index:attackRipple(variety)
    return self:modify("attackRipple", variety)
end

--- 防御
--- 直接扣减伤害
---@param variety number
---@return self|number
function _index:defend(variety)
    return self:modify("defend", variety)
end

--- 移动
---@param variety number
---@return self|number
function _index:move(variety)
    return self:modify("move", variety)
end

--- 力量
---@param variety number
---@return self|number
function _index:str(variety)
    return self:modify("str", variety)
end

--- 敏捷
---@param variety number
---@return self|number
function _index:agi(variety)
    return self:modify("agi", variety)
end

--- 智力
---@param variety number
---@return self|number
function _index:int(variety)
    return self:modify("int", variety)
end

--- 反隐半径范围
--- 范围[100-2000]只对整百生效
---@param variety number
---@return self|number
function _index:visible(variety)
    return self:modify("visible", variety)
end

--- 技能消耗计算修正[值]
---@param variety number
---@return self|number
function _index:cost(variety)
    return self:modify("cost", variety)
end

--- 技能消耗计算修正[%]
---@param variety number
---@return self|number
function _index:costPercent(variety)
    return self:modify("costPercent", variety)
end

--- 技能蓄力计算修正[帧]
---@param variety number
---@return self|number
function _index:amass(variety)
    return self:modify("amass", variety)
end

--- 技能蓄力计算修正[%]
---@param variety number
---@return self|number
function _index:amassPercent(variety)
    return self:modify("amassPercent", variety)
end

--- 技能消耗计算修正[表值(资源型)]
--- 如单位所有技能消耗减少1金币,，可以设定Unit:costWorth({gold=-1})
---@param variety table
---@return self|table
function _index:costWorth(variety)
    return self:modify("costWorth", variety)
end

--- 技能施法前摇计算修正[秒]
---@param variety number
---@return self|number
function _index:castChant(variety)
    return self:modify("castChant", variety)
end

--- 技能施法前摇计算修正[%]
---@param variety number
---@return self|number
function _index:castChantPercent(variety)
    return self:modify("castChantPercent", variety)
end

--- 技能冷却计算修正[%]
--- 负数则技能变快
---@param variety number
---@return self|number
function _index:coolDownPercent(variety)
    return self:modify("coolDownPercent", variety)
end

--- 技能冷却计算修正[秒]
--- 负数则技能变快
---@param variety number
---@return self|number
function _index:coolDown(variety)
    return self:modify("coolDown", variety)
end

--- 施法持续时间计算修正[%]
---@param variety number
---@return self|number
function _index:castKeepPercent(variety)
    return self:modify("castKeepPercent", variety)
end

--- 施法持续时间计算修正[秒]
---@param variety number
---@return self|number
function _index:castKeep(variety)
    return self:modify("castKeep", variety)
end

--- 施法距离计算修正[%]
---@param variety number
---@return self|number
function _index:castDistancePercent(variety)
    return self:modify("castDistancePercent", variety)
end

--- 施法距离计算修正[px]
---@param variety number
---@return self|number
function _index:castDistance(variety)
    return self:modify("castDistance", variety)
end

--- 施法范围计算修正[%]
---@param variety number
---@return self|number
function _index:castRangePercent(variety)
    return self:modify("castRangePercent", variety)
end

--- 施法范围计算修正[px]
---@param variety number
---@return self|number
function _index:castRange(variety)
    return self:modify("castRange", variety)
end

--- 通用几率[%]
---@param key string
---@param variety number
---@return self|number
function _index:odds(key, variety)
    return self:modify(key, variety, nil, SYMBOL_ODD, 0)
end

--- 通用抵抗[%]
---@param key string
---@param variety number
---@return self|number
function _index:resistance(key, variety)
    return self:modify(key, variety, nil, SYMBOL_RES, 0)
end