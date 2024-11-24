--- 游戏机制，自定义游戏核心数据

--- 公式：取整(固定值*极限内等级 + 固定值*极限内等级*(1+百分比值)^极限内等级 + 极限值*极限外等级)
---@param kind string
---@param targetLevel number
---@return number
local _lv2exp = function(kind, targetLevel)
    if (targetLevel <= 1) then
        return 0
    end
    local params = game.expParams[kind]
    if (targetLevel > params.maxLv) then
        targetLevel = params.maxLv
    end
    local lineLevel = params.lineLevel or 0
    local exLv = 0
    if (lineLevel > 0 and lineLevel < targetLevel) then
        exLv = targetLevel - lineLevel
        targetLevel = lineLevel
    end
    local lv = targetLevel - 1
    return math.ceil(params.fixed * lv + params.fixed * lv * ((1 + params.ratio) ^ lv) + exLv * params.limit)
end

--- 游戏根据经验获取等级
---@param kind string
---@param exp number
---@return number
local _exp2lv = function(kind, exp)
    local lvn = 0
    local l, r = 1, game.expParams[kind].maxLv
    while l <= r do
        local m = math.floor((l + r) / 2)
        if exp >= _lv2exp(kind, m) then
            lvn = m
            l = m + 1
        else
            r = m - 1
        end
    end
    return lvn
end

--- 游戏计算极限基准值
---@param maxLv number
---@param fixed number
---@param ratio number
---@param limit number
---@return number
local _line = function(maxLv, fixed, ratio, limit)
    local lv = 0
    local lvLine = 1
    local epsilon = 1e-6
    while (lvLine <= maxLv and math.abs(lvLine - lv) > epsilon) do
        lv = lvLine
        lvLine = lv - (fixed * lv + fixed * lv * ((1 + ratio) ^ lv) - limit) / (fixed + 2 * fixed * lv * ((1 + ratio) ^ lv))
    end
    if (math.isNaN(lvLine)) then
        error("TheNumberIsTooLarge_Lv")
    end
    lvLine = math.ceil(lvLine + 1)
    if (lvLine >= maxLv) then
        lvLine = 0
    end
    return lvLine
end

---@class game 游戏机制
game = game or {}

--- 游戏阶段
--- 默认阶段有：start、process
--- [start] 游戏进入开始触发（UIKit start、同步时钟、异步帧钟之前）
--- [process] 游戏进入流程（Process start 之前）
game._phase = game._phase or {
    ---@type function[] 执行段
    actions = {},
    ---@type table<string,function[]> 阶段状态
    passed = {},
}
--- [皮肤]虚构型皮肤参数，默认人族皮肤后续跟随种族或手动配置，可用于UI记录
---@type string
game.skin = game.skin or RACE_HUMAN_NAME
--- 经验计算参数集
game.expParams = game.expParams or {
    ability = {
        maxLv = 99, -- [技能]最大等级数
        fixed = 100, -- [技能]每级需要经验固定值
        ratio = 0.00, -- [技能]每级需要经验对锚定固定值的增长比率
        limit = 10000, -- [技能]每级经验增长上限，当fixed、ratio计算超过这个值的时候进行约束
    },
    item = {
        maxLv = 99, -- [物品]最大等级数
        fixed = 100, -- [物品]每级需要经验固定值
        ratio = 0.00, -- [物品]每级需要经验对锚定固定值的增长比率
        limit = 10000, -- [物品]每级经验增长上限，当fixed、ratio计算超过这个值的时候进行约束
    },
    unit = {
        maxLv = 100, -- [单位]最大等级数
        fixed = 100, -- [单位]每级需要经验固定值
        ratio = 0.05, -- [单位]每级需要经验对锚定固定值的增长比率
        limit = 100000, -- [单位]每级经验增长上限，当fixed、ratio计算超过这个值的时候进行约束
    },
}
---@type string 游戏名字（地图名字）
game.name = game.name or LK_MAP_NAME

--- 游戏是否已运行
---@return boolean
function game.isRunning()
    return true == game._phase.passed["process"]
end

--- 设定游戏度过[name]阶段
--- 每种阶段仅能度过一次
---@param name string phase 阶段名
---@return boolean
function game.phase(name)
    sync.must()
    must(type(name) == "string", "name@string")
    if (true == game._phase.passed[name]) then
        return
    end
    game._phase.passed[name] = true
    local as = game._phase.actions[name]
    if (nil ~= as) then
        for i = 1, #as, 1 do
            promise(as[i])
        end
        game._phase.actions[name] = nil
    end
    print("Phase:" .. name)
end

--- [同步]游戏阶段特殊事件，当游戏到达某个阶段时执行
--- 执行注入需在game加载后才有效
--- action注入后无法正常销毁，除非强制修改注册数据
--- 在游戏在度过某阶段度过后再注入action无效
---@param name string phase 阶段名
---@param action function 阶段执行段
---@return void
function game.onPhase(name, action)
    sync.must()
    must(type(name) == "string", "name@string")
    must(type(action) == "function", "name@action")
    if (true == game._phase.passed[name]) then
        return
    end
    if (nil == game._phase.actions[name]) then
        game._phase.actions[name] = {}
    end
    table.insert(game._phase.actions[name], action)
end

--- 设置升级经验参数(技能|物品|单位等)
---@param kind string|'ability'|'item'|'unit'
---@param maxLv number 最大等级
---@param fixed number 每级需要经验固定值
---@param ratio number 每级需要经验对锚定固定值的增长比率
---@param limit number 每级经验增长上限，当fixed、ratio计算超过这个值的时候进行约束
---@return void
function game.setExpNeedsParams(kind, maxLv, fixed, ratio, limit)
    sync.must()
    if (nil ~= game.expParams[kind]) then
        game.expParams[kind].maxLv = maxLv
        game.expParams[kind].fixed = fixed
        game.expParams[kind].ratio = ratio
        game.expParams[kind].limit = limit
        if (limit > 0) then
            game.expParams[kind].lineLevel = _line(maxLv, fixed, ratio, limit)
            if (math.isNaN(game.unitExpNeeds(maxLv))) then
                error("TheNumberIsTooLarge_Needs")
            end
        end
    end
end

--- 游戏技能升级经验需要条件
---@param targetLevel number
---@return number|number[]
function game.abilityExpNeeds(targetLevel)
    return _lv2exp("ability", targetLevel)
end

--- 游戏技能根据经验获取等级
---@param exp number
---@return number
function game.abilityExpToLevel(exp)
    return _exp2lv("ability", exp)
end

--- 游戏物品升级经验需要条件
---@param targetLevel number
---@return number|number[]
function game.itemExpNeeds(targetLevel)
    return _lv2exp("item", targetLevel)
end

--- 游戏物品根据经验获取等级
---@param exp number
---@return number
function game.itemExpToLevel(exp)
    return _exp2lv("item", exp)
end

--- 游戏单位升级经验需要条件
---@param targetLevel number
---@return number|number[]
function game.unitExpNeeds(targetLevel)
    return _lv2exp("unit", targetLevel)
end

--- 游戏单位根据经验获取等级
---@param exp number
---@return number
function game.unitExpToLevel(exp)
    return _exp2lv("unit", exp)
end