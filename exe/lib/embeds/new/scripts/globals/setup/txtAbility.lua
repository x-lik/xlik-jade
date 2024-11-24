-- 定义技能描述体
-- [基础信息]
---@param this Ability
---@param options {level:number}
description.define("abilityBase", function(this, options)
    local desc = {}
    local lv = math.floor(options.level or this:level())
    local tt = this:targetType()
    if (class.isObject(this, AbilityClass)) then
        local lvTxt = ''
        if (this:levelMax() > 1) then
            lvTxt = " - 等级 " .. colour.hex(colour.gold, lv)
        end
        if (tt ~= ability.targetType.pas) then
            table.insert(desc, this:name() .. lvTxt .. "（" .. colour.hex(colour.gold, keyboard.i2s(this:hotkey())) .. "）")
        else
            table.insert(desc, this:name() .. lvTxt)
        end
    else
        table.insert(desc, this:name())
    end
    table.insert(desc, colour.hex(colour.gold, "类型: " .. tt.label))
    local chantCast = this:castChant(lv)
    if (chantCast > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: " .. chantCast .. " 秒"))
    elseif (tt ~= ability.targetType.pas) then
        table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: 瞬间施法"))
    end
    local keepCast = this:castKeep(lv)
    if (keepCast > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "最大施法持续: " .. keepCast .. " 秒"))
    end
    if (tt ~= ability.targetType.none and tt ~= ability.targetType.pas) then
        table.insert(desc, colour.hex(colour.lightskyblue, "施法距离: " .. this:castDistance(lv)))
    end
    local castRadius = this:castRadius(lv)
    if (castRadius > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "圆形半径: " .. this:castRadius(lv)))
    end
    local castWidth = this:castWidth(lv)
    local castHeight = this:castHeight(lv)
    if (castWidth > 0 and castHeight > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "方形范围: " .. castWidth .. '*' .. castHeight))
    end
    table.insert(desc, '')
    return desc
end)

-- [技能点信息]
---@param this Ability
description.define("abilityLvPoint", function(this, _)
    if (this:levelUpNeedPoint() > 0) then
        return { colour.hex("EFBA16", "升级需要技能点: " .. this:levelUpNeedPoint()) }
    end
end)