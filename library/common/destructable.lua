--- 可破坏物，操作可破坏物的一些方法
---@class destructable
destructable = destructable or {}

--- 可破坏物死亡触发器
---@type any
destructable._deadTrigger = destructable._deadTrigger or nil

---@param id string
---@return table
function destructable.slk(id)
    must(type(id) == "string", "id@string")
    local v = slk.i2v(id)
    if (v) then
        v = v.slk
    else
        v = J.Slk["destructable"][id]
    end
    must(nil ~= v, "Invalid id")
    return v
end

---@param slkId string 原生ID[如WTst夏季树木]
---@param x number X坐标
---@param y number Y坐标
---@param z number|nil Z坐标
---@param facing number|nil 面向角度
---@param scale number|nil 缩放
---@param variation number|nil 样式
---@return number
function destructable.create(slkId, x, y, z, facing, scale, variation)
    sync.must()
    must(type(slkId) == "string", "slkId@string")
    local dSlk = destructable.slk(slkId)
    local variationMax = math.floor(tonumber(dSlk.numVar) or 1)
    x = x or 0
    y = y or 0
    z = z or 0
    facing = facing or math.rand(0, 360)
    scale = scale or (math.rand(7, 11) * 0.1)
    variation = variation or math.rand(0, variationMax)
    local h = J.CreateDestructableZ(J.C2I(slkId), x, y, z, facing, scale, variation)
    J.HandleRef(h)
    -- 框架未做单位攻击装饰物箭矢，业务需求太低，此处设为无敌跳过业务
    -- 如需要破坏装饰物，推荐配置独立特殊技能指针完成
    J.SetDestructableInvulnerable(h, true)
    Grid("destructable"):insert(h)
    if (nil ~= destructable._deadTrigger) then
        J.TriggerRegisterDeathEvent(destructable._deadTrigger, h)
    end
end

--- 删除装饰物
---@param whichDest number
---@return void
function destructable.destroy(whichDest)
    sync.must()
    Grid("destructable"):remove(whichDest)
    J.RemoveDestructable(whichDest)
    J.HandleRef(whichDest)
end

--- 获取类型ID
---@param whichDest number
---@param toCode boolean 是否使用I2C
---@return number|string
function destructable.h2i(whichDest, toCode)
    local id = J.GetDestructableTypeId(whichDest)
    if (toCode) then
        return J.I2C(id)
    end
    return id
end

--- 获取闭塞高度
---@param whichDest number
---@return string
function destructable.getName(whichDest)
    return J.GetDestructableName(whichDest)
end

--- 获取X
---@param whichDest number
---@return number
function destructable.getX(whichDest)
    return J.GetDestructableX(whichDest)
end

--- 获取Y
---@param whichDest number
---@return number
function destructable.getY(whichDest)
    return J.GetDestructableY(whichDest)
end

--- 设置闭塞高度
---@param whichDest number
---@return void
function destructable.setOccluderHeight(whichDest, height)
    sync.must()
    J.SetDestructableOccluderHeight(whichDest, height)
end

--- 显示
---@param whichDest number
---@return void
function destructable.show(whichDest)
    sync.must()
    J.ShowDestructable(whichDest, true)
end

--- 隐藏
---@param whichDest number
---@return void
function destructable.hide(whichDest)
    sync.must()
    J.ShowDestructable(whichDest, false)
end

--- 杀死
---@param whichDest number
---@return void
function destructable.kill(whichDest)
    sync.must()
    Grid("destructable"):remove(whichDest)
    J.KillDestructable(whichDest)
end

--- 复活
---@param whichDest number
---@param hasAnimate boolean 是否播放动画
---@return void
function destructable.reborn(whichDest, hasAnimate)
    sync.must()
    J.DestructableRestoreLife(whichDest, J.GetDestructableMaxLife(whichDest), hasAnimate or false)
    Grid("destructable"):insert(whichDest)
end

--- 可破坏物死亡事件
--- 此事件注册的是所有可破坏物的事件，一般只需要使用一次
---@param key string
---@param callFunc fun(evtData:eventOnDestructableDead)
---@return void
function destructable.onDead(key, callFunc)
    if (nil == destructable._deadTrigger) then
        event.condition(J.Condition(
            function()
                event.syncTrigger(destructable, eventKind.destructableDead, { triggerDestructable = J.GetTriggerDestructable() })
            end),
            function(tgr)
                destructable._deadTrigger = tgr
            end)
        must(nil ~= destructable._deadTrigger, "Invalid destructable.dead Trigger")
        --- 注册全图可破坏物死亡事件
        local g = Grid("destructable")
        J.EnumDestructablesInRect(RegionWorld:handle(), nil, function()
            local enum = J.GetEnumDestructable()
            g:insert(enum)
            J.TriggerRegisterDeathEvent(destructable._deadTrigger, enum)
        end)
    end
    event.syncRegister(destructable, eventKind.destructableDead, key, callFunc)
end