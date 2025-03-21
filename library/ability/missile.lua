--- 模版技能 箭矢
---@private
---@param isComplete boolean
---@param options abilityMissileOptions
---@param vec number[] len:2
---@return void
local _call = function(isComplete, options, vec)
    effector.destroy(options.arrowToken)
    options.arrowToken = nil
    local res = isComplete
    if (true == res and type(options.onEnd) == "function") then
        res = options.onEnd(options, vec)
    end
    if (true == res and (options.reflex or 0) > 0) then
        if (class.isObject(options.targetUnit, UnitClass) and false == class.isDestroy(options.targetUnit)) then
            --- 目标为单位时的弹射，根据其余同势力单位发射，无下一个目标时弹射回击原目标
            local nextUnit = Group(UnitClass):rand({
                circle = {
                    x = vec[1],
                    y = vec[2],
                    radius = 600,
                },
                ---@param enumUnit Unit
                filter = function(enumUnit)
                    local ownerCheck = true
                    if (class.isObject(options.sourceUnit, UnitClass)) then
                        ownerCheck = enumUnit:isEnemy(options.sourceUnit:owner())
                    end
                    return ownerCheck and enumUnit:isOther(options.targetUnit) and enumUnit:isAlive()
                end
            })
            if (class.isObject(nextUnit, UnitClass)) then
                ability.missile(setmetatable({ reflex = options.reflex - 1, sourceVec = vec, targetUnit = nextUnit }, { __index = options }))
            else
                local reflexOffset = options.reflexOffset or 300
                local rx, ry = vector2.polar(vec[1], vec[2], reflexOffset, math.rand(0, 359))
                ability.missile(setmetatable({
                    height = (options.height or 0) / 2,
                    sourceVec = vec,
                    targetUnit = nextUnit,
                    targetVec = { rx, ry },
                    onEnd = function(options2, vec2)
                        if (class.isObject(options2.targetUnit, UnitClass)) then
                            options2.targetVec = nil
                            ability.missile(setmetatable({ reflex = options2.reflex - 1, sourceVec = vec2 }, { __index = options2 }))
                        end
                    end
                }, { __index = options }))
            end
        else
            --- 目标为坐标时的弹射，根据reflexOffset随机发射
            local reflexOffset = options.reflexOffset or 300
            local rx, ry = vector2.polar(vec[1], vec[2], reflexOffset, math.rand(0, 359))
            ability.missile(setmetatable({ height = (options.height or 0) * 0.8, reflex = options.reflex - 1, sourceVec = vec, targetVec = { rx, ry } }, { __index = options }))
        end
    end
end

--[[
    模版技能 虚拟箭矢
    options = {
        sourceUnit = Unit, --[可选]源单位（没有来源单位时，必须有sourceVec）
        targetUnit = Unit, --[可选]目标单位（有单位目标，那么冲击跟踪到单位就结束）
        sourceVec = number[], --[可选]len:3，强制设定初始坐标
        targetVec = number[], --[可选]len:3，强制设定目标坐标
        model = string, --[必须]虚拟箭矢的特效，默认nil
        animateScale = number, --[可选]虚拟箭矢的动画速度，默认1
        scale = number, --[可选]虚拟箭矢的模型缩放，默认1
        frequency = number, --[可选]刷新周期，默认0.03
        speed = number, --[可选]每秒冲击的距离，默认500（表示1秒移动500的距离）
        acceleration = number, --[可选]冲击加速度，默认0（每个周期[每隔frequency秒]都会增加一次）
        height = number, --[可选]飞跃高度，默认0
        weaponHeight = number, --[可选]武器高度，默认20
        weaponLength = number, --[可选]武器长度，默认20
        reflex = number, --[可选]弹射次数，默认0，优先选择其余单位，没有则跳回原target
        reflexOffset = number, --[可选]弹射跳回原target时的偏移距离，默认300
        twist = boolean, --[可选]是否扭曲，默认false
        onMove = abilityMissileFunc, --[可选]每周期回调,当return false时可强行中止循环
        onEnd = abilityMissileFunc, --[可选]结束回调,当return true时才会执行reflex
    }
]]
---@alias abilityMissileFunc fun(options:abilityMissileOptions,vec:number[]):boolean
---@alias abilityMissileOptions {model:string,animateScale:number,scale:number,frequency:number,speed:number,acceleration:number,height:number,weaponHeight:number,weaponLength:number,twist:boolean,reflex:number,reflexOffset:number,sourceUnit:Unit,targetUnit:Unit,sourceVec:number[],targetVec:number[],onMove:abilityMissileFunc,onEnd:abilityMissileFunc}
---@param options abilityMissileOptions
function ability.missile(options)
    sync.must()
    must(type(options.model) == "string", "options.model@string")
    if (type(options.targetVec) ~= "table") then
        must(class.isObject(options.targetUnit, UnitClass), "options.targetUnit@Unit")
    end
    options.acceleration = options.acceleration or 0
    options.animateScale = options.animateScale or 1
    options.scale = options.scale or 1
    local frequency = options.frequency or 0.03
    local speed = math.min(5000, math.max(50, options.speed or 500))
    local collision = 0
    local weaponHeight = options.weaponHeight
    if (nil == weaponHeight) then
        if (class.isObject(options.sourceUnit, UnitClass)) then
            weaponHeight = options.sourceUnit:weaponHeight()
        end
        if (nil == weaponHeight) then
            weaponHeight = 20
        end
    end
    
    local vec0 = options.sourceVec
    ---@type number[]
    local vec2 = nil
    if (type(options.targetVec) == "table") then
        vec2 = { options.targetVec[1], options.targetVec[2], options.targetVec[3] or japi.Z(options.targetVec[1], options.targetVec[2]) }
    else
        vec2 = { options.targetUnit:x(), options.targetUnit:y(), weaponHeight + options.targetUnit:h() }
        collision = options.targetUnit:collision()
    end
    local facing = 0
    if (type(vec0) ~= "table") then
        facing = vector2.angle(options.sourceUnit:x(), options.sourceUnit:y(), vec2[1], vec2[2])
        local wl = options.weaponLength or options.sourceUnit:weaponLength()
        local sx, sy = vector2.polar(options.sourceUnit:x(), options.sourceUnit:y(), wl, facing)
        vec0 = { sx, sy, weaponHeight + options.sourceUnit:h() }
    else
        vec0[3] = vec0[3] or japi.Z(vec0[1], vec0[2])
        facing = vector2.angle(vec0[1], vec0[2], vec2[1], vec2[2])
    end
    must(type(vec0) == "table", "options.sourceVec@table")
    
    local distance = vector2.distance(vec0[1], vec0[2], vec2[1], vec2[2])
    local deviateX = math.min(1, distance / 300)
    local deviateY = math.min(1, distance / 500)
    local width = distance * (1 - 0.5 * math.min(1, deviateX))
    local height = options.height or 0
    height = height * deviateY
    local agl = math.atan(math.abs(vec2[3] - vec0[3]), distance)
    local xRot, yRot = vector2.rotate(width, height, math._r2d * agl)
    local zRot = yRot + vec0[3]
    local rotL1 = -math._r2d * math.atan(yRot, xRot)
    local rotL2 = -math._r2d * math.atan(zRot - vec2[3], distance - xRot)
    
    local vec1
    if (height > 0) then
        local twist = 0
        local twDis = xRot
        if (true == options.twist) then
            twist = math.rand(110, 250)
            twDis = math.rand(distance / 3, distance / 1.5)
        end
        local mx, my = vector2.polar(vec0[1], vec0[2], twDis, facing + twist)
        vec1 = { mx, my, zRot }
    end
    
    options.arrowToken = effector.agile(options.model, vec0[1], vec0[2], vec0[3])
    effector.speed(options.arrowToken, options.animateScale)
    effector.size(options.arrowToken, options.scale)
    effector.rotateZ(options.arrowToken, facing)
    effector.rotateY(options.arrowToken, rotL1)
    
    local distancePrev = distance
    local faraway = frequency * speed * 25
    local rotY = rotL1
    local vecT = { vec0[1], vec0[2], vec0[3] }
    
    -- dt
    local dt = 0
    local dtStep = distance / speed / frequency
    local dtSpd = 1 / dtStep
    local dtRot1 = 2 * rotL1 / dtStep
    local dtRot2 = 1.5 * rotL2 / dtStep
    local dtAcc = 0
    if (options.acceleration ~= 0) then
        dtAcc = 1 / (distance / options.acceleration / frequency)
    end
    time.setInterval(frequency, function(curTimer)
        if (class.isObject(options.targetUnit, UnitClass) and class.isDestroy(options.targetUnit)) then
            class.destroy(curTimer)
            _call(false, options, vecT)
            return
        end
        local isDynTarget = type(options.targetVec) ~= "table" and nil ~= options.targetUnit and options.targetUnit:isAlive()
        local distortion = 1
        if (isDynTarget) then
            vec2[1], vec2[2], vec2[3] = options.targetUnit:x(), options.targetUnit:y(), options.targetUnit:h()
            distortion = math.max(0, distance / vector2.distance(vec0[1], vec0[2], vec2[1], vec2[2]))
            dt = dt + dtSpd * distortion
        else
            dt = dt + dtSpd
        end
        
        local distanceCur = distancePrev
        if (dt < 1) then
            local nx, ny, nz
            if (nil == vec1) then
                nx, ny, nz = vector3.linear(vec0, vec2, dt)
            else
                nx, ny, nz = vector3.bezier2(vec0, vec1, vec2, dt)
            end
            if (RegionPlayable:isBorder(nx, ny)) then
                class.destroy(curTimer)
                _call(false, options, vecT)
                return
            end
            vecT[1], vecT[2], vecT[3] = nx, ny, nz
            distanceCur = vector2.distance(vecT[1], vecT[2], vec2[1], vec2[2])
        end
        if (dt >= 1 or distanceCur <= collision) then
            class.destroy(curTimer)
            effector.position(options.arrowToken, vec2[1], vec2[2], vec2[3])
            effector.rotateZ(options.arrowToken, vector2.angle(vecT[1], vecT[2], vec2[1], vec2[2]))
            _call(true, options, vec2)
            return
        end
        if (true == isDynTarget and dt > 0.25 and (distancePrev - distanceCur) > faraway) then
            class.destroy(curTimer)
            _call(false, options, vecT)
            return
        end
        
        if (type(options.onMove) == "function") then
            if (false == options.onMove(options, vecT)) then
                class.destroy(curTimer)
                _call(false, options, vecT)
                return
            end
        end
        
        if (dt <= 0.5) then
            rotY = rotY - dtRot1 * distortion
        else
            rotY = rotY - dtRot2 * distortion
        end
        effector.position(options.arrowToken, vecT[1], vecT[2], vecT[3])
        effector.rotateZ(options.arrowToken, vector2.angle(vecT[1], vecT[2], vec2[1], vec2[2]))
        effector.rotateY(options.arrowToken, rotY)
        distancePrev = distanceCur
        if (dtAcc ~= 0) then
            dtSpd = dtSpd + dtAcc
        end
    end)
end