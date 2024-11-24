--- 魔兽自带漂浮字
--- 常用于伤害文字
---@class ttg
ttg = ttg or {}

ttg._limit = 100
ttg._count = ttg._count or 0

--- 销毁漂浮字
---@param whichTag number
---@return void
function ttg.destroy(whichTag)
    sync.must()
    J.DestroyTextTag(whichTag)
    ttg._count = ttg._count - 1
end

--- 创建漂浮字
---@return number integer
function ttg.create()
    sync.must()
    ttg._count = ttg._count + 1
    return J.CreateTextTag()
end

--- 常驻显示漂浮文字
---@param x number
---@param y number
---@param content string 内容
---@param options {size:number,opacity:number,zOffset:number}
---@return number
function ttg.permanent(x, y, content, options)
    content = tostring(content)
    if (string.len(content) <= 0) then
        return
    end
    if (ttg._count > ttg._limit) then
        return
    end
    local size = 10
    local opacity = 255
    local zOffset = 0
    if (type(options) == "table") then
        size = options.size or size
        opacity = options.opacity or opacity
        zOffset = options.zOffset or zOffset
    end
    local this = ttg.create()
    J.SetTextTagPermanent(this, true)
    J.SetTextTagText(this, content, size * 0.023 / 10)
    J.SetTextTagColor(this, 255, 255, 255, math.floor(opacity))
    J.SetTextTagPos(this, x - vistring.len(content) * size * 0.5, y, zOffset)
    return this
end

--- 显示漂浮文字
--- size number
--- opacity number 透明度 0-255，为0则不可见
--- xOffset number x轴偏移速度
--- yOffset number y轴偏移速度
--- zOffset number z轴高度偏移量
---@param x number
---@param y number
---@param content string 内容
---@param during number 持续时间，大于0
---@param options {size:number,opacity:number,zOffset:number,xOffset:number,yOffset:number}
---@return void
function ttg.display(x, y, content, during, options)
    sync.must()
    content = tostring(content)
    if (string.len(content) <= 0 or during <= 0) then
        return
    end
    if (ttg._count > ttg._limit) then
        return
    end
    local size = 10
    local opacity = 255
    local zOffset = 0
    local xOffset = 0
    local yOffset = 0
    if (type(options) == "table") then
        size = options.size or size
        opacity = options.opacity or opacity
        zOffset = options.zOffset or zOffset
        xOffset = options.xOffset or xOffset
        yOffset = options.yOffset or yOffset
    end
    local tt = ttg.create()
    J.SetTextTagText(tt, content, size * 0.023 / 10)
    J.SetTextTagColor(tt, 255, 255, 255, math.floor(opacity))
    J.SetTextTagPos(tt, x - vistring.len(content) * size * 0.5, y, zOffset)
    if (xOffset ~= 0 or yOffset ~= 0) then
        J.SetTextTagVelocity(tt, xOffset, yOffset)
    end
    if (nil == tt or 0 == tt) then
        return
    end
    time.setTimeout(during, function()
        ttg.destroy(tt)
    end)
end