--- 底层技能 沉默
--[[
    使用 Unit:isSilencing() 判断是否被沉默
    options = {
        whichUnit 目标单位
        duration 持续时间
        model 绑定特效路径
        attach 绑定特效位置
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