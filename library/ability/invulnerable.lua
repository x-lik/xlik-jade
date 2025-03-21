--- 底层技能 无敌
--[[
    使用 Unit:isInvulnerable() 判断是否无敌
    options = {
        whichUnit = Unit, --[必须]目标单位
        duration = Unit, --[必须]持续时间（秒），默认0
        model = string, --[可选]绑定特效路径，默认DivineShieldTarget
        attach = string, --[可选]绑定特效位置，默认origin
    }
]]
---@param options {whichUnit:Unit,duration:number,model:string,attach:string}|abilityBuffAddon
---@return void
function ability.invulnerable(options)
    sync.must()
    local whichUnit = options.whichUnit
    if (false == class.isObject(whichUnit, UnitClass) or whichUnit:isDead()) then
        return
    end
    local duration = options.duration or 0
    if (duration <= 0) then
        return
    end
    local model = options.model or "DivineShieldTarget"
    local attach = options.attach or "origin"
    Buff({
        key = "invulnerable",
        object = whichUnit,
        signal = buffSignal.up,
        name = options.name,
        icon = options.icon,
        duration = duration,
        description = options.description,
        ---@param buffObj Unit
        purpose = function(buffObj)
            effector.attach(buffObj, model, attach)
            superposition.plus(buffObj, "invulnerable")
        end,
        ---@param buffObj Unit
        rollback = function(buffObj)
            effector.detach(buffObj, model, attach)
            superposition.minus(buffObj, "invulnerable")
        end,
    })
end