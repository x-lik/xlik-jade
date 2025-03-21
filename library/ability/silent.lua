--- 底层技能 沉默
--[[
    使用 Unit:isSilencing() 判断是否被沉默
    options = {
        whichUnit = Unit, --[必须]目标单位
        duration = number, --[必须]持续时间（秒），默认0（小于等于0无效）
        model = string, --[可选]绑定特效路径，默认SilenceTarget
        attach = string, --[可选]绑定特效位置，默认origin
    }
]]
---@param options {whichUnit:Unit,duration:number,model:string,attach:string}|abilityBuffAddon
function ability.silent(options)
    sync.must()
    local whichUnit = options.whichUnit
    if (false == class.isObject(whichUnit, UnitClass) or whichUnit:isDead()) then
        return
    end
    local duration = options.duration or 0
    if (duration <= 0) then
        return
    end
    local model = options.model or "SilenceTarget"
    local attach = options.attach or "origin"
    Buff({
        key = "silent",
        object = whichUnit,
        signal = buffSignal.down,
        name = options.name,
        icon = options.icon,
        duration = duration,
        description = options.description,
        ---@param buffObj Unit
        purpose = function(buffObj)
            effector.attach(buffObj, model, attach)
            superposition.plus(buffObj, "silent")
        end,
        ---@param buffObj Unit
        rollback = function(buffObj)
            effector.detach(buffObj, model, attach)
            superposition.minus(buffObj, "silent")
        end,
    })
end