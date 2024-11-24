-- 定义物品技能描述体
-- [基础信息]
---@param this Ability
description.define("itemAbility", function(this)
    local desc = { '' }
    local lv = math.floor(this:level())
    local tt = this:targetType()
    table.insert(desc, colour.hex(colour.lightskyblue, "技能类型：" .. tt.label))
    if (tt ~= ability.targetType.pas) then
        local chantCast = this:castChant(lv)
        if (chantCast > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间：" .. chantCast .. " 秒"))
        else
            table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间：瞬间施法"))
        end
        local keepCast = this:castKeep(lv)
        if (keepCast > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "施法持续：" .. keepCast .. " 秒"))
        end
        if (tt ~= ability.targetType.none) then
            table.insert(desc, colour.hex(colour.lightskyblue, "施法距离: " .. this:castDistance(lv)))
        end
        if (tt == ability.targetType.circle) then
            table.insert(desc, colour.hex(colour.lightskyblue, "圆形半径: " .. this:castRadius(lv)))
        elseif (tt == ability.targetType.square) then
            local castWidth = this:castWidth(lv)
            local castHeight = this:castHeight(lv)
            table.insert(desc, colour.hex(colour.lightskyblue, "方形范围: " .. castWidth .. '*' .. castHeight))
        end
    end
    return desc
end)

-- 定义物品描述体
-- [基础信息]
---@param this Item
description.define("itemBase", function(this, options)
    local desc = {}
    local name
    if (this:level() > 0 and this:levelMax() > 1) then
        name = this:name() .. "[" .. colour.hex(colour.white, this:level()) .. "级]"
    else
        name = this:name()
    end
    table.insert(desc, name)
    if (true ~= options.after) then
        table.insert(desc, '')
        local de = this:description()
        if (type(de) == "string") then
            table.insert(desc, colour.hex(colour.darkgray, de))
        elseif (type(de) == "table") then
            for _, de2 in ipairs(de) do
                table.insert(desc, colour.hex(colour.darkgray, de2))
            end
        end
    end
    local ab = this:bindAbility()
    if (class.isObject(ab, AbilityClass)) then
        local tt = ab:targetType()
        if (class.isObject(this, ItemClass)) then
            if (tt ~= ability.targetType.pas and nil ~= this:hotkey()) then
                name = name .. "（" .. colour.hex(colour.gold, "数字" .. keyboard.i2s(this:hotkey())) .. "）"
            end
            desc[1] = name
        else
            desc[1] = name
        end
        desc = table.merge(desc, description.combine(ab, nil, "itemAbility", SYMBOL_D, "attributes"))
        if (this:charges() > 0) then
            table.insert(desc, colour.hex(colour.white, "|n剩余次数：" .. this:charges()))
        end
    else
        desc[1] = name
    end
    desc = table.merge(desc, description.combine(this, nil, "attributes"))
    return desc
end)