-- 事件反应
---@param u Unit
local function _z(u, offset)
    return u:h() + 130 + offset
end

---@param evtData eventOnUnitHurt
event.syncRegister(UnitClass, eventKind.unitHurt, function(evtData)
    local str = math.format(evtData.damage, 0)
    local height = -50
    local u = evtData.triggerUnit
    mtg.word({
        style = "default",
        str = str,
        width = 12,
        size = 0.7,
        x = u:x(),
        y = u:y(),
        z = _z(u, 0),
        height = height,
        duration = 0.7,
    })
end)
---@param evtData eventOnUnitImmuneEnchant
event.syncRegister(UnitClass, eventKind.unitImmuneEnchant, function(evtData)
    mtg.model({
        model = "lk_ttg_immune_enchant",
        size = 0.7,
        x = evtData.triggerUnit:x(),
        y = evtData.triggerUnit:y(),
        z = _z(evtData.triggerUnit, -44),
        height = 100,
        duration = 1,
    })
end)
---@param evtData eventOnUnitEnchant
event.syncRegister(UnitClass, eventKind.unitEnchant, function(evtData)
    local m = {
        [injury.damageType.fire.value] = "lk_ttg_e_fire",
        [injury.damageType.water.value] = "lk_ttg_e_water",
        [injury.damageType.ice.value] = "lk_ttg_e_ice",
        [injury.damageType.rock.value] = "lk_ttg_e_rock",
        [injury.damageType.wind.value] = "lk_ttg_e_wind",
        [injury.damageType.light.value] = "lk_ttg_e_light",
        [injury.damageType.dark.value] = "lk_ttg_e_dark",
        [injury.damageType.grass.value] = "lk_ttg_e_grass",
        [injury.damageType.thunder.value] = "lk_ttg_e_thunder",
        [injury.damageType.poison.value] = "lk_ttg_e_poison",
        [injury.damageType.steel.value] = "lk_ttg_e_steel",
    }
    if (nil ~= m[evtData.enchantType.value]) then
        local u = evtData.triggerUnit
        mtg.model({
            model = m[evtData.enchantType.value],
            size = 1.2,
            x = u:x() - math.rand(30, -30),
            y = u:y(),
            z = _z(u, -u:stature() * 2),
            height = 160,
            speed = 0.4,
            duration = 1,
        })
    end
end)