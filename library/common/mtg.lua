--- 模型漂浮字
--- 常用于特效伤害文字
---@class mtg
mtg = mtg or {}

mtg._max = 100
mtg._count = mtg._count or 0
mtg._char = mtg._char or {}
mtg._site = mtg._site or {}

--- 注册字符对应的模型和位宽
---@param style string 样式组
---@param char string
---@param model string 模型路径
---@param bit number
---@return void
function mtg.char(style, char, model, bit)
    sync.must()
    if (nil == mtg._char[style]) then
        mtg._char[style] = {}
    end
    mtg._char[style][tostring(char)] = { model, bit }
end

--[[
    字串模型
    style string 漂浮字样式组
    str number 漂浮字信息
    width number 字间
    speed number 速度
    size number 尺寸
    scale number[] len:2 缩放变化如，{1,1}
    x number 创建坐标X
    y number 创建坐标Y
    z number 创建坐标Z
    height number 上升高度
    duration number 持续时间
]]
---@param options {style:string,str:number,width:number,speed:number,size:number,scale:number[],x:number,y:number,z:number,height:number,duration:number}
---@return void
function mtg.word(options)
    sync.must()
    if (mtg._count > mtg._max) then
        return
    end
    local style = options.style or "default"
    must(nil ~= mtg._char[style], "Invalid options.style")
    local str = tostring(options.str) or ""
    local width = options.width or 10
    local speed = options.speed or 1
    local size = options.size or 0.25
    local scale = options.scale or { 1, 1 }
    local x = options.x or 0
    local y = options.y or 0
    local z = options.z or 150
    local height = options.height or 200
    local duration = options.duration or 0.5
    local frequency = 0.05
    local spd = height / (duration / frequency)
    --
    local words = mbstring.split(str, 1)
    if (#words > 0) then
        x = math.floor(x)
        y = math.floor(y)
        local site = x .. y
        if (nil == mtg._site[site]) then
            mtg._site[site] = {}
        end
        if (nil == mtg._site[site][str]) then
            mtg._site[site][str] = true
            time.setTimeout(0.2, function()
                mtg._site[site][str] = nil
            end)
            mtg._count = mtg._count + 1
            local xs = {}
            local x0 = x
            for i, w in ipairs(words) do
                must(nil ~= mtg._char[style][w], "Invalid words:" .. w)
                local bit = mtg._char[style][w][2]
                xs[i] = x0
                x0 = xs[i] + width * bit
            end
            ---@type number[]
            local effs = {}
            for i, w in ipairs(words) do
                local mdl = mtg._char[style][w][1]
                effs[i] = effector.point(mdl, xs[i], y, z, duration)
                japi.YD_SetEffectSpeed(effs[i], speed)
                japi.YD_EffectMatScale(effs[i], size, size, size)
            end
            local d = 0
            local h = z
            local ani = 0
            time.setInterval(frequency, function(curTimer)
                d = d + frequency
                if (d >= duration) then
                    class.destroy(curTimer)
                    mtg._count = mtg._count - 1
                    return
                end
                h = h + spd
                local siz
                if (scale[1] ~= 1 or scale[2] ~= 1) then
                    ani = ani + frequency
                    if (ani >= 0.1) then
                        ani = 0
                        if (d < duration * 0.5) then
                            siz = scale[1]
                            width = width * siz
                        else
                            siz = scale[2]
                            width = width * siz
                        end
                    end
                end
                for i, _ in ipairs(words) do
                    japi.YD_SetEffectXY(effs[i], xs[i], y)
                    japi.YD_SetEffectZ(effs[i], h)
                    if (nil ~= siz) then
                        japi.YD_EffectMatScale(effs[i], siz, siz, siz)
                    end
                end
            end)
        end
    end
end

--[[
    单模型漂浮
    model string 模型路径
    speed number 速度
    size number 尺寸
    scale number 缩放
    x number 创建坐标X
    y number 创建坐标Y
    z number 创建坐标Z
    offset number 偏移
    height number 上升高度
    duration number 持续时间
]]
---@param options {model:string,speed:number,size:number,scale:number,x:number,y:number,z:number,offset:number,height:number,duration:number}
---@return void
function mtg.model(options)
    sync.must()
    local model = japi.AssetsModel(options.model)
    if (nil == model) then
        return
    end
    if (mtg._count > mtg._max) then
        return
    end
    local size = options.size or 0.25
    local scale = options.scale or { 1, 1 }
    local x = options.x or 0
    local y = options.y or 0
    local z = options.z or 150
    local offset = math.floor(options.offset or 0)
    local height = options.height or 1000
    local speed = options.speed or 1
    local duration = options.duration or 1
    local frequency = 0.05
    x = math.floor(x)
    y = math.floor(y)
    local site = x .. y
    if (nil == mtg._site[site]) then
        mtg._site[site] = {}
    end
    if (nil == mtg._site[site][model]) then
        mtg._site[site][model] = true
        time.setTimeout(duration, function()
            mtg._site[site][model] = nil
        end)
        mtg._count = mtg._count + 1
        local spd = height / (duration / frequency)
        local eff = effector.point(model, x, y, z, duration)
        japi.YD_SetEffectSpeed(eff, speed)
        japi.YD_EffectMatScale(eff, size, size, size)
        local dur = 0
        local h = z
        local randX = 0
        local randY = 0
        if (offset ~= 0) then
            randX = math.rand(-offset, offset)
            randY = math.rand(-offset, offset)
        end
        local ani = 0
        time.setInterval(frequency, function(curTimer)
            dur = dur + frequency
            if (dur >= duration) then
                class.destroy(curTimer)
                mtg._count = mtg._count - 1
                return
            end
            h = h + spd
            local siz
            if (scale[1] ~= 1 or scale[2] ~= 1) then
                ani = ani + frequency
                if (ani >= 0.1) then
                    ani = 0
                    if (dur < duration * 0.5) then
                        siz = scale[1]
                    else
                        siz = scale[2]
                    end
                end
            end
            x = x + randX
            y = y + randY
            japi.YD_SetEffectXY(eff, x, y)
            japi.YD_SetEffectZ(eff, h)
            if (nil ~= siz) then
                japi.YD_EffectMatScale(eff, siz, siz, siz)
            end
        end)
    end
end