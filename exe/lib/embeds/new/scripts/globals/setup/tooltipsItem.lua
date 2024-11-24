---@param whichItem Item|ItemTpl
---@return table
function tooltipsItem(whichItem)
    if (false == class.instanceof(whichItem, ItemTplClass)) then
        return nil
    end
    local icons = {
        { "lumber", "C49D5A", "木", "interfaces/iconLumber" },
        { "gold", "ECD104", "金", "interfaces/iconGold" },
        { "silver", "E3E3E3", "银", "interfaces/iconSilver" },
        { "copper", "EC6700", "铜", "interfaces/iconCopper" }
    }
    local content = {
        tips = description.combine(whichItem, nil, "itemBase"),
        icons = {},
        bars = {},
        list = {},
    }
    local wor = whichItem:worth()
    local cale = worth.cale(wor, "*", PlayerLocal():recoveryRatio() * 0.01)
    for _, c in ipairs(icons) do
        local key = c[1]
        local color = c[2]
        local uit = c[3]
        local val = math.floor(cale[key] or 0)
        if (val > 0) then
            if (nil ~= uit) then
                val = val .. " " .. uit
            end
            table.insert(content.icons, {
                texture = c[4],
                text = colour.hex(color, val),
            })
        end
    end
    if (class.isObject(whichItem, ItemClass)) then
        local lv = whichItem:level()
        if (lv < whichItem:levelMax()) then
            if (whichItem:exp() > 0) then
                local cur = whichItem:exp() or 0
                local prev = game.itemExpNeeds(lv)
                local need = game.itemExpNeeds(lv + 1)
                local percent = math.trunc((cur - prev) / (need - prev), 3)
                if (nil ~= percent) then
                    table.insert(content.bars, {
                        texture = "interfaces/tileWhite",
                        text = colour.hex(colour.white, "经验：" .. math.floor(cur - prev) .. "/" .. math.ceil(need - prev)),
                        ratio = percent,
                        width = 0.10,
                        height = 0.001,
                    })
                end
            end
        end
    end
    return content
end