--- 底层技能 视野修改
---@param whichUnit Unit
---@param value number 目标白天视野值
function ability.sight(whichUnit, value)
    sync.must()
    local h = whichUnit:handle()
    local diff = math.floor(value - whichUnit:sightBase())
    for _, v in ipairs(LK_SLK_ID_SIGHT_MAP) do
        if (J.GetUnitAbilityLevel(h, LK_SLK_ID_SIGHT_ADD[v]) > 0) then
            J.UnitRemoveAbility(h, LK_SLK_ID_SIGHT_ADD[v])
        end
        if (J.GetUnitAbilityLevel(h, LK_SLK_ID_SIGHT_SUB[v]) > 0) then
            J.UnitRemoveAbility(h, LK_SLK_ID_SIGHT_SUB[v])
        end
    end
    local tempVal = math.round(math.abs(diff))
    local sight_gradient = table.clone(LK_SLK_ID_SIGHT_MAP)
    if (tempVal ~= 0) then
        while (true) do
            local flag = false
            for i, v in ipairs(sight_gradient) do
                if (tempVal >= v) then
                    tempVal = math.round(tempVal - v)
                    table.remove(sight_gradient, i)
                    if (diff > 0) then
                        if (J.GetUnitAbilityLevel(h, LK_SLK_ID_SIGHT_ADD[v]) == 0) then
                            J.UnitAddAbility(h, LK_SLK_ID_SIGHT_ADD[v])
                        end
                    else
                        if (J.GetUnitAbilityLevel(h, LK_SLK_ID_SIGHT_SUB[v]) == 0) then
                            J.UnitAddAbility(h, LK_SLK_ID_SIGHT_SUB[v])
                        end
                    end
                    flag = true
                    break
                end
            end
            if (false == flag) then
                break
            end
        end
    end
end