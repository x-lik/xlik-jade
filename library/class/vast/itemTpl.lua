--- 物品Tpl模版数据
--- 由于需要可能性较少，xlik的物品由模型特效强制模拟而成
--- 不涉及被攻击、死亡等操作，如有需要，你可沿用原来的魔兽物品或从过去框架中获得旧的物品实现
---@class ItemTpl:Tpl
local _index = Vast(ItemTplClass, {
    ---@type number 当前经验值
    _exp = 0,
    ---@type number 最大等级
    _levelMax = game.expParams.item.maxLv,
    ---@type number 当前等级
    _level = 1,
    ---@type number 持续时间，-1无限
    _duration = -1,
    ---@type boolean 是否消耗品(消耗品使用会减少charges使用次数)
    _consumable = false,
    ---@type boolean 是否能抵押(卖)
    _pawnable = true,
    ---@type boolean 是否能丢弃
    _dropable = true,
    ---@type boolean 是否自动使用
    _autoUse = false,
    ---@type number 使用次数
    _charges = 0,
    ---@type number 模型缩放
    _modelScale = 1.00,
    ---@type number 动画缩放
    _animateScale = 1.00,
    ---@type string 模型路径
    _model = "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl",
}):extend(TplClass)

--- 预设事件数据数组
---@see eventKind
---@param evt string 事件类型字符，参考eventKind
---@vararg string|function 可以填写一个function或string,function 当拥有string参数时作为其key
---@return self
function _index:onEvent(evt, ...)
    if (nil == self._onEvent) then
        self._onEvent = {}
    end
    table.insert(self._onEvent, { evt, ... })
    return self
end

--- 通用型单位事件注册
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

--- 物品当前经验
---@param variety number|nil
---@return self|number
function _index:exp(variety)
    if (nil ~= variety) then
        variety = math.cale(variety, self._exp)
        variety = math.max(0, variety)
        variety = math.min(game.itemExpNeeds(game.expParams.item.maxLv), variety)
    end
    return self:modify("exp", variety)
end

--- 物品最大级
---@param variety number|nil
---@return self|number
function _index:levelMax(variety)
    if (nil ~= variety) then
        variety = math.cale(variety, self._levelMax)
        variety = math.min(game.expParams.item.maxLv, variety)
    end
    return self:modify("levelMax", variety)
end

--- 物品当前等级
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

--- 绑定的技能TPL
--- 实例化物品对象时，此tpl会转为具体的技能对象
---@param variety AbilityTpl|nil
---@return self|AbilityTpl
function _index:bindAbilityTpl(variety)
    return self:modify("bindAbilityTpl", variety)
end

--- 物品模型
---@param variety string|nil 支持别称
---@return self|string
function _index:model(variety)
    return self:modify("model", variety)
end

--- 模型缩放
---@param size number|nil 默认1.00
---@return self|number
function _index:modelScale(size)
    return self:modify("modelScale", size)
end

--- 动画时长缩放
---@param speed number|nil  默认1.00
---@return self|number
function _index:animateScale(speed)
    return self:modify("animateScale", speed)
end

--- 是否捡取自动使用
---@param enable nil|boolean 默认false
---@return self|boolean
function _index:autoUse(enable)
    return self:modify("autoUse", enable)
end

--- 是否消耗品
--- 消耗品的数目小于1时，物品会自动销毁
---@param enable boolean|nil 默认false
---@return self|boolean
function _index:consumable(enable)
    return self:modify("consumable", enable)
end

--- 是否可抵押
--- 不可抵押则没法出售
---@param enable boolean|nil 默认true
---@return self|boolean
function _index:pawnable(enable)
    return self:modify("pawnable", enable)
end

--- 是否可丢弃
---@param enable boolean|nil 默认true
---@return self|boolean
function _index:dropable(enable)
    return self:modify("dropable", enable)
end

--- 使用次数
--- 默认0
---@param variety number|nil
---@return self|number
function _index:charges(variety)
    if (nil ~= variety) then
        variety = math.cale(variety, self._charges)
        variety = math.max(0, math.round(variety))
    end
    return self:modify("charges", variety)
end

--- 构造物品Tpl对象
--- 构建模版数据供Item方法使用
--- Tpl数据修改时会影响引用的上层对象，但无法触发对象的modifier执行
--- 可手动执行VastModifierAct，额外补充执行
---@return ItemTpl
function ItemTpl()
    return oVast({}, _index)
end