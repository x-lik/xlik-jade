---@param abData eventOnAbilityGet
TPL_ABILITY.DEMO = AbilityTpl()
    :name("剑之勇气")
    :description(
    {
        "越战越勇，每减少10%的HP则会增加10点攻击力",
        "效果最多叠加9层，最大90点攻击力",
    })
    :targetType(ability.targetType.pas)
    :icon("ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp")
    :onEvent(eventKind.abilityGet,
    function(abData)
        local ak = abData.triggerAbility:id()
        ---@param evtData eventOnClassAfterChange
        event.syncRegister(abData.triggerUnit, eventKind.classAfterChange .. "hpCur", ak, function(evtData)
            local u = evtData.triggerUnit
            BuffClear(u, { key = "剑之勇气" .. ak })
            local cur = evtData.new
            if (cur > 0) then
                local hp = u:hp()
                local n = math.floor((hp - cur) / hp * 10)
                if (n > 0) then
                    local atk = 10 * n
                    Buff({
                        object = u,
                        key = "剑之勇气" .. ak,
                        name = "剑之勇气" .. n .. "层",
                        signal = buffSignal.up,
                        icon = "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp",
                        text = colour.hex(colour.gold, n),
                        description = {
                            colour.hex(colour.gold, n .. "层") .. "剑之勇气",
                            colour.hex(colour.lawngreen, "攻击：+" .. atk),
                        },
                        ---@param buffObj Unit
                        purpose = function(buffObj)
                            buffObj:attack("+=" .. atk)
                            effector.attach(buffObj, "SmallBuildingFire0", "origin")
                        end,
                        ---@param buffObj Unit
                        rollback = function(buffObj)
                            buffObj:attack("-=" .. atk)
                            effector.detach(buffObj, "SmallBuildingFire0", "origin")
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
        BuffClear(abData.triggerUnit, { key = "剑之勇气" .. ak })
    end)