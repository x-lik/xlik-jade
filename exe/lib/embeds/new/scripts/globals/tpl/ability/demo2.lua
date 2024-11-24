---@param abData eventOnAbilityGet
TPL_ABILITY.DEMO2 = AbilityTpl()
    :name("盾之结晶")
    :description(
    {
        "越战越勇，每减少10%的HP则会增加1点防御力",
        "效果最多叠加9层，最大9点防御力",
    })
    :targetType(ability.targetType.pas)
    :icon("ReplaceableTextures\\CommandButtons\\BTNAdvancedUnholyArmor.blp")
    :onEvent(eventKind.abilityGet,
    function(abData)
        local ak = abData.triggerAbility:id()
        ---@param evtData eventOnClassAfterChange
        event.syncRegister(abData.triggerUnit, eventKind.classAfterChange .. "hpCur", ak, function(evtData)
            local u = evtData.triggerUnit
            BuffClear(u, { key = "盾之结晶" .. ak })
            local cur = evtData.new
            if (cur > 0) then
                local hp = u:hp()
                local n = math.floor((hp - cur) / hp * 10)
                if (n > 0) then
                    local def = n
                    Buff({
                        object = u,
                        key = "盾之结晶" .. ak,
                        name = "盾之结晶" .. n .. "层",
                        signal = buffSignal.up,
                        icon = "ReplaceableTextures\\CommandButtons\\BTNAdvancedUnholyArmor.blp",
                        text = colour.hex(colour.gold, n),
                        description = {
                            colour.hex(colour.gold, n .. "层") .. "盾之结晶",
                            colour.hex(colour.lawngreen, "防御：+" .. def),
                        },
                        ---@param buffObj Unit
                        purpose = function(buffObj)
                            buffObj:defend("+=" .. def)
                            effector.attach(buffObj, "AIdaTarget", "overhead")
                        end,
                        ---@param buffObj Unit
                        rollback = function(buffObj)
                            buffObj:defend("-=" .. def)
                            effector.detach(buffObj, "AIdaTarget", "overhead")
                        end
                    })
                end
            end
        end)
    end)
    :onEvent(eventKind.abilityLose,
    function(abData)
        local ak = abData.triggerAbility:id()
        event.syncUnregister(abData.triggerUnit, eventKind.classAfterChange .. "hpCur", ak)
        BuffClear(abData.triggerUnit, { key = "盾之结晶" .. ak })
    end)