--- 模版技能 眩晕
--[[
    使用 Unit:isStunning() 判断是否眩晕
    options = {
        sourceUnit = Unit, --[可选]源单位
        targetUnit = Unit, --[必须]目标单位
        duration = number, --[必须]持续时间（秒），默认0（小于等于0无效）
        odds = number, --[可选]几率，默认100，建议范围[0-100]（小于等于0无效）
        model = string, --[可选]绑定特效路径，默认ThunderclapTarget
        attach = string, --[可选]绑定特效位置，默认overhead
    }
]]
---@param options {targetUnit:Unit,sourceUnit:Unit,duration:number,odds:number,model:string,attach:string}|abilityBuffAddon
function ability.stun(options)
    sync.must()
    local targetUnit = options.targetUnit
    local sourceUnit = options.sourceUnit
    if (false == class.isObject(targetUnit, UnitClass) or targetUnit:isDead()) then
        return
    end
    if (class.isObject(sourceUnit, UnitClass)) then
        if (sourceUnit:isDead()) then
            return
        end
    end
    local duration = options.duration or 0
    if (duration <= 0) then
        return
    end
    local odds = (options.odds or 100) - targetUnit:resistance("stun")
    if (odds < math.rand(1, 100)) then
        return
    end
    if (sourceUnit) then
        event.syncTrigger(sourceUnit, eventKind.unitStun, { targetUnit = targetUnit, duration = duration })
    end
    event.syncTrigger(targetUnit, eventKind.unitBeStun, { sourceUnit = sourceUnit, duration = duration })
    local model = options.model or "ThunderclapTarget"
    local attach = options.attach or "overhead"
    Buff({
        key = "stun",
        object = targetUnit,
        signal = buffSignal.down,
        name = options.name,
        icon = options.icon,
        duration = duration,
        description = options.description,
        ---@param buffObj Unit
        purpose = function(buffObj)
            effector.attach(buffObj, model, attach)
            superposition.plus(buffObj, "stun")
            superposition.plus(buffObj, "pause")
        end,
        ---@param buffObj Unit
        rollback = function(buffObj)
            effector.detach(buffObj, model, attach)
            superposition.minus(buffObj, "pause")
            superposition.minus(buffObj, "stun")
        end
    })
end