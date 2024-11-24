--- Tpl模版数据
---@class Tpl:Vast
local _index = Vast(TplClass, {
    ---@type string
    _category = "common",
    ---@type string
    _name = '',
    ---@type string
    _icon = X_UI_QUESTION,
    ---@type string
    _conditionTips = "无",
    ---@type string
    _conditionPass = "已达成",
})

--- 归类
---@param variety string|nil
---@return self|string
function _index:category(variety)
    return self:modify("category", variety)
end

--- 名称
---@param variety string|nil
---@return self|string
function _index:name(variety)
    return self:modify("name", variety)
end

--- 图标
---@param variety string|nil
---@return self|string
function _index:icon(variety)
    return self:modify("icon", japi.AssetsImage(variety))
end

--- 价值
--- 如{gold=1}
---@param variety number|nil
---@return self|number
function _index:worth(variety)
    return self:modify("worth", variety)
end

--- 描述体
---@param variety nil|string[]|string|fun(obj:Item|Ability|Unit):string[]
---@return self|string[]
function _index:description(variety)
    local t = type(variety)
    if (t == "string" or t == "table" or t == "function") then
        return self:modify("description", variety)
    end
    local d = {}
    local desc = self:get("description")
    if (type(desc) == "string") then
        d[#d + 1] = desc
    elseif (type(desc) == "table") then
        for _, v in ipairs(desc) do
            d[#d + 1] = v
        end
    elseif (type(desc) == "function") then
        d = desc(self)
    end
    return d
end

--[[
    配置智能属性数组
    属性配置单元 {param, baseValue, varyValue}
               属性参数名, 1级数值, 升级加成
    varyValue不设置时，自动取baseValue做线性加成
    方法不存在 或 1级数值、升级加成同时为0 会被忽略
    （只适用于部分数值型方法）
    例子：{
        {"attack", 10, 10}, -- 每级+10点攻击
        {"attackSpeed", 10, 0}, -- 1级+10点攻击
        {"attackSpeed", 10 }, -- 1级+10点攻击，后面升级默认不增加，与0一样
        {"defend", -1, -0.1}, -- 第1级-1防御，2级-1.1防御...
    }
]]
---@param data table|nil
---@return self|table|nil
function _index:attributes(data)
    return self:modify("attributes", data)
end

--- 条件
--- 条件可用于限制tpl的使用，具体用法不限
---@param variety fun(this:self):boolean|nil
---@return self|boolean
function _index:condition(variety)
    if (type(variety) == "function") then
        return self:modify("condition", variety)
    end
    local cond = self:modify("condition")
    if (type(cond) == "function") then
        local res = cond(self)
        if (type(res) == "boolean") then
            return res
        end
        return false
    end
    return true
end

--- 条件未达成时（常态）提示文本
---@param variety string|nil
---@return self|string
function _index:conditionTips(variety)
    return self:modify("conditionTips", variety)
end

--- 条件达成时（通过时）提示文本
---@param variety string|nil
---@return self|string
function _index:conditionPass(variety)
    return self:modify("conditionPass", variety)
end

---@return Tpl
function Tpl()
    return oVast({}, _index)
end