--- 底层技能 复活重生
--- 复活的回调操作
---@param whichUnit Unit
---@param invulnerable number
function ability.rebornRevive(whichUnit, invulnerable, x, y, eff)
    sync.must()
    if (false == class.isObject(whichUnit, UnitClass)) then
        return
    end
    superposition.minus(whichUnit, "dead")
    J.RemoveUnit(whichUnit._handle)
    J.HandleUnRef(whichUnit._handle)
    class.handle(whichUnit, nil)
    local h = J.CreateUnit(whichUnit:owner():handle(), whichUnit:slkId(), x, y, 270)
    J.HandleRef(h)
    class.handle(whichUnit, h)
    local hp = math.max(1, whichUnit:hp() * 0.01 * whichUnit:rebornHP())
    local mp = math.max(whichUnit:mp(), whichUnit:mp() * 0.01 * whichUnit:rebornMP())
    whichUnit:set("hpCur", hp)
    whichUnit:set("mpCur", mp)
    VastModifierAct(whichUnit)
    effector.attach(whichUnit, eff, "origin", 3)
    if (invulnerable > 0) then
        ability.invulnerable({
            whichUnit = whichUnit,
            duration = invulnerable,
        })
    end
    --- 触发复活事件
    event.syncTrigger(whichUnit, eventKind.unitReborn)
end

--- 底层技能 复活重生
--- 使用 Unit:isAlive() 判断是否存活中
--- 使用 Unit:isDead() 判断是否已死亡
---@param whichUnit Unit
---@param delay number 延时，默认且最低0.2
---@param invulnerable number 复活后的无敌时间
---@param x number 在哪复活X
---@param y number 在哪复活Y
---@return Timer|nil
function ability.reborn(whichUnit, delay, invulnerable, x, y)
    sync.must()
    if (false == class.isObject(whichUnit, UnitClass)) then
        return
    end
    local rebornTimer
    if (delay < 1) then
        delay = math.max(0.2, delay)
        time.setTimeout(delay, function()
            ability.rebornRevive(whichUnit, invulnerable, x, y, "DispelMagicTarget")
        end)
    else
        async.call(whichUnit:owner(), function()
            mark.display(mark.texture.dream, delay, 255, 0, 0)
        end)
        --- 复活标志
        local ux, uy = whichUnit:x(), whichUnit:y()
        local unitGhost = J.CreateUnit(PlayerPassive:handle(), whichUnit:slkId(), ux, uy, 270)
        J.HandleRef(unitGhost)
        J.SetUnitVertexColor(unitGhost, 255, 255, 255, 100)
        J.SetUnitScale(unitGhost, whichUnit:modelScale() * 0.9, whichUnit:modelScale() * 0.9, whichUnit:modelScale() * 0.9)
        J.SetUnitColor(unitGhost, PLAYER_COLOR[whichUnit:owner():teamColor()])
        J.SetUnitPathing(unitGhost, false)
        J.UnitAddAbility(unitGhost, LK_SLK_ID_ABILITY_FLY)
        J.UnitRemoveAbility(unitGhost, LK_SLK_ID_ABILITY_FLY)
        J.SetUnitFlyHeight(unitGhost, 40, 9999)
        J.SetUnitFacing(unitGhost, 270)
        J.UnitAddAbility(unitGhost, LK_SLK_ID_ABILITY_LOCUST)
        J.UnitAddAbility(unitGhost, LK_SLK_ID_ABILITY_INVULNERABLE)
        local deathToken = J.CreateUnit(PlayerPassive:handle(), LK_SLK_ID_UNIT_TOKEN_REBORN, ux, uy, 270)
        J.HandleRef(deathToken)
        J.SetUnitVertexColor(deathToken, 255, 255, 255, 180)
        J.SetUnitScale(deathToken, whichUnit:modelScale() * 0.75, whichUnit:modelScale() * 0.75, whichUnit:modelScale() * 0.75)
        J.SetUnitTimeScale(deathToken, 10 / delay)
        rebornTimer = time.setTimeout(delay, function()
            J.RemoveUnit(deathToken)
            J.HandleUnRef(deathToken)
            J.RemoveUnit(unitGhost)
            J.HandleUnRef(unitGhost)
            ability.rebornRevive(whichUnit, invulnerable, x, y, "ResurrectTarget")
        end)
    end
    return rebornTimer
end