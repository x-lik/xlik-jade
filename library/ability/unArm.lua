--- 底层技能 缴械
--[[
    使用 Unit:isUnArming() 判断是否缴械
    options = {
        whichUnit 目标单位
        duration 持续时间
        effect 绑定特效路径
        attach 绑定特效位置
    }
]]
---@param options {whichUnit:Unit,duration:number,model:string,attach:string}|abilityBuffAddon
function ability.unArm(options)
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
    local attach = options.attach or "weapon"
    Buff({
        key = "unArm",
        object = whichUnit,
        signal = buffSignal.down,
        name = options.name,
        icon = options.icon,
        description = options.description,
        duration = duration,
        ---@param buffObj Unit
        purpose = function(buffObj)
            effector.attach(buffObj, model, attach)
            superposition.plus(buffObj, "unArm")
            superposition.plus(buffObj, "noAttack")
        end,
        ---@param buffObj Unit
        rollback = function(buffObj)
            effector.detach(buffObj, model, attach)
            superposition.minus(buffObj, "noAttack")
            superposition.minus(buffObj, "unArm")
        end
    })
end