--- 描述定义
--- 操作静态/动态描述文本的方法集
---@alias descriptionObject Ability|Unit|Item
---@class description
description = description or {}

---@type Array 描述设定
description._define = nil

--- 定义某个key的描述结构设定
---@alias descriptionSetting fun(this:descriptionObject,options:table):string[]|string
---@param key string
---@param descSetting descriptionSetting
---@return descriptionSetting|nil
function description.define(key, descSetting)
    sync.must()
    if (type(descSetting) == "function") then
        if (nil == description._define) then
            description._define = Array()
        end
        description._define:set(key, descSetting)
    end
    return self
end

--- 获取描述结构的组合设定
---@vararg string
---@param obj Tpl
---@param options table
---@vararg table
---@return string[]
function description.combine(obj, options, ...)
    options = options or {}
    local joiner = {}
    if (nil == description._define) then
        return joiner
    end
    local _join = nil
    _join = function(ts)
        if (type(ts) == "string") then
            if (string.subPos(ts, "|n") == -1) then
                table.insert(joiner, ts)
            else
                _join(string.explode("|n", ts))
            end
        elseif (type(ts) == "table") then
            for _, v in ipairs(ts) do
                _join(v)
            end
        end
    end
    for _, data in ipairs({ ... }) do
        if (type(data) == "string" and data == SYMBOL_D) then
            _join(obj:description())
        elseif (type(data) == "string" and description._define:keyExists(data)) then
            _join(description._define:get(data)(obj, options))
        else
            _join(data)
        end
    end
    return joiner
end