--- 单位对象
--- 此对象在实例化时再继~承对应的UnitTpl对象
--- 当Tpl对象数据改动时，也会跟随改动，但独立设置数据后不再变动跟随
---@class Unit:UnitTpl
local _index = Vast(UnitClass)

---@protected
function _index:destruct()
    self:enchantSubtractAll()
    Group(UnitClass):remove(self)
    class.destroy(self._abilitySlot)
    self._abilitySlot = nil
    class.destroy(self._itemSlot)
    self._itemSlot = nil
    effector.clearAttach(self)
    local ag = self._attackTimers
    if (type(ag) == "table") then
        for _, v in ipairs(ag) do
            class.destroy(v)
        end
        self._attackTimers = nil
    end
    --
    if (nil ~= self._orderRoute) then
        class.destroy(self._orderRoute.timer)
        self._orderRoute = nil
    end
    class.destroy(self._splatImage)
    class.destroy(self._moveTyre.timer)
    class.destroy(self._periodTimer)
    class.destroy(self._durationTimer)
    class.destroy(self._distanceTimer)
    self._moveTyre = nil
    self._periodTimer = nil
    self._durationTimer = nil
    self._distanceTimer = nil
    J.RemoveUnit(self._handle)
    J.HandleUnRef(self._handle)
    class.handle(self, nil)
end

--- 预设事件数据数组
---@see eventKind
---@param evt string 事件类型字符，参考eventKind
---@vararg string|function 可以填写(function)或(string, function)当有string参数时作为事件的key
---@return self
function _index:onEvent(evt, ...)
    event.syncRegister(self, evt, ...)
    return self
end

--- 单位TPL
---@return UnitTpl
function _index:tpl()
    return self._tpl
end

--- 获取handle
---@return number
function _index:handle()
    return self._handle
end

--- 语音模型
---@param variety string|nil
---@return self|string
function _index:speech(variety)
    return self:modify("speech", variety)
end

--- 单位语音Extra配置
---@param variety string|nil
---@return self|string
function _index:speechExtra(variety)
    return self:modify("speechExtra", variety)
end

--- 单位拥有者
---@param variety Player|nil
---@return self|Player
function _index:owner(variety)
    return self:modify("owner", variety)
end

--- 单位队伍颜色
--- 使用玩家索引决定颜色值
---@param index number|nil 玩家索引[1-12]
---@return self|number
function _index:teamColor(index)
    return self:modify("teamColor", index)
end

--- 获取剩余生命周期
---@return number
function _index:periodRemain()
    if (class.isObject(self._periodTimer, TimerClass)) then
        return self._periodTimer:remain()
    end
    return -1
end

--- 获取剩余存在时间
---@return number
function _index:durationRemain()
    if (class.isObject(self._durationTimer, TimerClass)) then
        return self._durationTimer:remain()
    end
    return -1
end

--- 单位物品栏
---@return ItemSlot|nil
function _index:itemSlot()
    return self._itemSlot
end

--- 单位技能栏
---@return AbilitySlot|nil
function _index:abilitySlot()
    return self._abilitySlot
end

--- 当前吟唱设定时间
---@return number
function _index:castChantPeriod()
    if (self:isCastChanting()) then
        return self._abCap.period
    end
    return 0
end

--- 当前吟唱剩余时间
---@return number
function _index:castChantRemain()
    if (self:isCastChanting()) then
        return 0.1 * (self._abCap.limit - self._abCap.i)
    end
    return 0
end

--- 当前持续施法设定时间
---@return number
function _index:castKeepPeriod()
    if (self:isCastKeeping()) then
        return self._abCap.period
    end
    return 0
end

--- 当前持续施法剩余时间
---@return number
function _index:castKeepRemain()
    if (self:isCastKeeping()) then
        return 0.1 * (self._abCap.limit - self._abCap.i)
    end
    return 0
end

--- 中断当前技能持续状态，并执行revert回调
---@param status boolean 回调后是否继续技能的流程，一般为false
---@return void
function _index:abilityCaptureRevert(status)
    if (type(status) ~= "boolean") then
        status = false
    end
    if (type(self._abCap) == "table") then
        self._abCap.revert(status)
    end
end

--- 是否自己
---@param Who Unit
---@return boolean
function _index:isSelf(Who)
    return self:id() == Who:id()
end

--- 是否别人
---@param Who Unit
---@return boolean
function _index:isOther(Who)
    return not self:isSelf(Who)
end

--- 是否敌方玩家
---@param judgePlayer Player
---@return boolean
function _index:isEnemy(judgePlayer)
    return J.IsUnitEnemy(self:handle(), judgePlayer:handle())
end

--- 是否友方玩家
---@param judgePlayer Player
---@return boolean
function _index:isAlly(judgePlayer)
    return J.IsUnitAlly(self:handle(), judgePlayer:handle())
end

--- 是否地面单位
---@return boolean
function _index:isGround()
    return self._moveType == attribute.unitMoveType.foot
end

--- 是否空中单位
---@return boolean
function _index:isAir()
    return self._moveType == attribute.unitMoveType.fly
end

--- 是否水里单位
---@return boolean
function _index:isWater()
    return self._moveType == attribute.unitMoveType.amphibious or self._moveType == attribute.unitMoveType.float
end

--- 是否近战
---@return boolean
function _index:isMelee()
    return self:attackRange() <= 200 and self:assault():mode() == "instant"
end

--- 是否远程
---@return boolean
function _index:isRanged()
    return false == self:isMelee()
end

--- 是否设定为建筑单位
--- 取决于三个参数：slk中的isbldg、uberSplat；自定义中的_splat
--- 当单位有地面纹理或指定为建筑时，会被认为是建筑
---@return boolean
function _index:isBuilding()
    return nil ~= self._building
end

--- 是否设定为不动单位
--- 取决于extra设定spd是否为0
---@return boolean
function _index:isImmovable()
    return true == self._immovable
end

--- 是否存活
---@return boolean
function _index:isAlive()
    return false == class.isDestroy(self) and false == superposition.is(self, "dead")
end

--- 是否死亡
---@return boolean
function _index:isDead()
    return class.isDestroy(self) or superposition.is(self, "dead")
end

--- 设置单位暂停与否
---@param status boolean
function _index:pause(status)
    sync.must()
    if (true == status) then
        superposition.plus(self, "pause")
    else
        superposition.minus(self, "pause")
    end
end

--- 判断单位是否暂停
---@return boolean
function _index:isPause()
    return superposition.is(self, "pause")
end

--- 判断单位是否隐藏
---@return boolean
function _index:isHide()
    return superposition.is(self, "hide")
end

--- 判断单位是否存在路径碰撞
---@return boolean
function _index:isPathing()
    return not superposition.is(self, "noPath")
end

--- 判断单位是否允许攻击
---@return boolean
function _index:isAttackAble()
    return not superposition.is(self, "noAttack")
end

--- 判断单位是否有蝗虫
---@return boolean
function _index:isLocust()
    return superposition.is(self, "locust")
end

--- 判断单位是否无敌
---@return boolean
function _index:isInvulnerable()
    return superposition.is(self, "invulnerable")
end

--- 判断单位是否隐身
---@return boolean
function _index:isInvisible()
    return superposition.is(self, "invisible")
end

--- 是否正在受伤
---@return boolean
function _index:isHurting()
    return superposition.is(self, "hurt")
end

--- 是否正在造成伤害
---@return boolean
function _index:isDamaging()
    return superposition.is(self, "damage")
end

--- 是否眩晕中
---@return boolean
function _index:isStunning()
    return superposition.is(self, "stun")
end

--- 是否被沉默
---@return boolean
function _index:isSilencing()
    return superposition.is(self, "silent")
end

--- 是否被缴械
---@return boolean
function _index:isUnArming()
    return superposition.is(self, "unArm")
end

--- 判断单位是否处于施法中止态
--- 暂停不属于施法中止态
--- 施法中止态定义：被销毁、死亡、眩晕、沉默
--- 详情可看 meta/superposition.lua/_conf
---@return boolean
function _index:isInterrupt()
    return superposition.is(self, "interrupt")
end

--- 吟唱中
---@return boolean
function _index:isCastChanting()
    return nil ~= self._abCap and nil ~= self._abCap.kind == "chant"
end

--- 是否持续施法中
---@return self|boolean
function _index:isCastKeeping()
    return nil ~= self._abCap and nil ~= self._abCap.kind == "keep"
end

--- 判断单位是否拥有某种技能
---@param whichTpl AbilityTpl 使用TPL来判别类别
---@return boolean
function _index:hasAbility(whichTpl)
    local slot = self:abilitySlot()
    return class.isObject(slot, AbilitySlotClass) and slot:has(whichTpl)
end

--- 判断单位是否拥有某种物品
---@param whichTpl ItemTpl 使用TPL来判别类别
---@return boolean
function _index:hasItem(whichTpl)
    local slot = self:itemSlot()
    return class.isObject(slot, ItemSlotClass) and slot:has(whichTpl)
end

--- 获取优先攻击模式
--- Unit对象时获取优先级最高的攻击模式对象
--- 攻击模式对象按优先级，从高到低获取
---@return Assault
function _index:assault()
    -- 获取攻击模式
    ---@type Assault[]
    local am = self._assaultList
    local at = self._assault
    local len = #am
    if (len == 0) then
        --- 没有push新的攻击模式，则调用tpl设定的，如还是没有，用默认攻击模式
        return at or AssaultDefault
    end
    local mc = am[len]
    for i = len - 1, 1, -1 do
        local m = am[i]
        if (m:priority() > mc:priority()) then
            mc = m
        end
    end
    if (at and at:priority() > mc:priority()) then
        mc = at
    end
    return mc
end

--- 增加可选攻击模式对象
---@param mode Assault
---@return self
function _index:assaultPush(mode)
    if (class.isObject(mode, AssaultClass)) then
        sync.must()
        local am = self._assaultList
        table.insert(am, mode)
    end
    return self
end

--- 删除可选攻击模式对象
--- 根据攻击模式对象ID删除(注意，相同ID会被全部删除)
---@param mode Assault
---@return self
function _index:assaultRemove(mode)
    if (class.isObject(mode, AssaultClass)) then
        sync.must()
        local modeId = mode._id
        ---@type Assault[]
        local am = self._assaultList
        if (#am > 0) then
            for i = #am, 1, -1 do
                if (am[i]._id == modeId) then
                    table.remove(am, i)
                end
            end
        end
    end
    return self
end

--- 获取最后受伤来源
---@return Unit|nil
function _index:lastHurtSource()
    return self._lastHurtSource
end

--- 获取最后伤害目标
---@return Unit|nil
function _index:lastDamageTarget()
    return self._lastDamageTarget
end

--- X坐标
---@return number
function _index:x()
    return J.GetUnitX(self:handle())
end

--- Y坐标
---@return number
function _index:y()
    return J.GetUnitY(self:handle())
end

--- Z坐标
---@return number
function _index:z()
    return japi.Z(self:x(), self:y())
end

--- H坐标[凌空]
---@return number
function _index:h()
    return self:z() + self:flyHeight() + self:collision() / 2
end

--- 移动单位到X,Y坐标
---@param x number
---@param y number
---@return void
function _index:position(x, y)
    sync.must()
    if (type(x) == "number" and type(y) == "number") then
        J.SetUnitPosition(self:handle(), x, y)
        if (class.is(self._splatImage, ImageClass)) then
            self._splatImage:position(x, y)
        end
    end
end

--- 面向角度
---@param angle number|nil 角度[0-360]
---@return self|number
function _index:facing(angle)
    if (nil ~= angle) then
        sync.must()
        J.SetUnitFacing(self:handle(), angle)
        return self
    end
    return J.GetUnitFacing(self:handle())
end

--- 杀死单位
---@return void
function _index:kill()
    sync.must()
    self:hpCur(-1)
end

--- 命令单位做动画动作，如 "attack"
--- 当动作为整型序号时，自动播放对应的序号行为(每种模型的序号并不一定一致)
---@param animate number|string
---@return void
function _index:animate(animate)
    sync.must()
    if (type(animate) == "string") then
        if (type(self._animateProperties) == "table") then
            J.SetUnitAnimation(self:handle(), animate .. ' ' .. table.concat(self._animateProperties, ' '))
        else
            J.SetUnitAnimation(self:handle(), animate)
        end
    elseif (type(animate) == "number") then
        J.SetUnitAnimationByIndex(self:handle(), math.floor(animate))
    end
end

--- 单位插入或删除动画动作
---@param animate string
---@param enable boolean true插入动画、false删除动画
---@return self
function _index:animateProperties(animate, enable)
    sync.must()
    must(type(animate) == "string", "animate@string")
    must(type(enable) == "boolean", "enable@boolean")
    if (nil == rawget(self, "_animateProperties")) then
        local oap = self._animateProperties
        local nap = {}
        if (type(oap) == "table") then
            for _, v in ipairs(oap) do
                nap[#nap + 1] = v
            end
        end
        self._animateProperties = nap
    end
    local has = table.includes(self._animateProperties, animate)
    if (true == enable) then
        if (false == has) then
            table.insert(self._animateProperties, animate)
            J.AddUnitAnimationProperties(self:handle(), animate, true)
        end
    else
        if (true == has) then
            table.delete(self._animateProperties, animate)
            J.AddUnitAnimationProperties(self:handle(), animate, false)
        end
    end
    return self
end

--- 单位发布停止命令
---@return void
function _index:orderStop()
    sync.must()
    J.IssueImmediateOrder(self:handle(), "stop")
end

--- 单位发布伫立命令
---@return void
function _index:orderHold()
    sync.must()
    J.IssueImmediateOrder(self:handle(), "holdposition")
end

--- 单位发布攻击命令
---@param x number
---@param y number
---@return void
function _index:orderAttack(x, y)
    sync.must()
    J.IssuePointOrder(self:handle(), "attack", x, y)
end

--- 单位发布命令跟随某目标单位
---@param targetUnit Unit
---@return void
function _index:orderFollowTargetUnit(targetUnit)
    sync.must()
    J.IssueTargetOrder(self:handle(), "move", targetUnit:handle())
end

--- 单位发布命令攻击某目标单位
---@param targetUnit Unit
---@return void
function _index:orderAttackTargetUnit(targetUnit)
    sync.must()
    J.IssueTargetOrder(self:handle(), "attack", targetUnit:handle())
end

--- 单位发布移动命令
---@param x number
---@param y number
---@return void
function _index:orderMove(x, y)
    sync.must()
    J.IssuePointOrder(self:handle(), "move", x, y)
end

--- 单位发布AI移动命令
---@param x number
---@param y number
---@return void
function _index:orderAIMove(x, y)
    sync.must()
    J.IssuePointOrderById(self:handle(), 851988, x, y)
end

--- 单位发布巡逻移动命令
---@param x number
---@param y number
---@return void
function _index:orderPatrol(x, y)
    sync.must()
    J.IssuePointOrderById(self:handle(), 851990, x, y)
end

--- 单位捡物品（存在捡取过程）
---@param targetItem Item
---@return void
function _index:pickItem(targetItem)
    sync.must()
    if (class.isObject(targetItem, ItemClass) and targetItem:instance()) then
        player.unitDistanceAction(self, targetItem, player.pickActionRadius, function()
            if (true == targetItem:instance()) then
                event.syncTrigger(targetItem, eventKind.itemPick, { triggerUnit = self })
                -- 防止物品被事件销毁
                if (false == class.isDestroy(targetItem)) then
                    event.syncTrigger(self, eventKind.unitItemPick, { triggerItem = targetItem })
                    -- 防止物品被事件销毁
                    if (false == class.isDestroy(targetItem)) then
                        local itemSlot = self:itemSlot()
                        if (nil == itemSlot or self:owner():pickMode() == player.pickMode.warehouseOnly) then
                            self:owner():warehouseSlot():insert(targetItem)
                        else
                            itemSlot:insert(targetItem)
                        end
                    end
                end
                async.call(self:owner(), function()
                    sound.vcm("war3_PickUpItem")
                end)
            end
        end)
    end
end

--- 构造单位对象
---@param force Player|Team 势力，支持玩家或队伍
---@param tpl UnitTpl
---@param x number 坐标X
---@param x number 坐标Y
---@param facing number 面向角度
---@return Unit
function Unit(force, tpl, x, y, facing)
    must(class.isObject(tpl, UnitTplClass), "tpl@UnitTpl")
    must(type(x) == "number", "x@number")
    must(type(y) == "number", "y@number")
    must(type(facing) == "number", "facing@number")
    -- 分析拥有者
    ---@type Player
    local owner = nil
    if (class.isObject(force, PlayerClass)) then
        owner = force
    elseif (class.isObject(force, TeamClass)) then
        local fi = force:index()
        must(fi > 0, "param force is invalid Team")
        owner = Player(fi)
    end
    must(nil ~= owner, "force@Player|Team")
    ---@type Unit
    local o = oVast({
        _tpl = tpl,
        _owner = owner,
        _teamColor = owner:teamColor(),
        _assaultList = {}, -- 攻击模式备选表
        _moveTyre = { status = 0 }, -- 移动状态
    }, _index, tpl)
    local h = J.CreateUnit(owner:handle(), tpl:slkId(), x, y, facing)
    J.HandleRef(h)
    class.handle(o, h)
    --- modifier do action
    VastModifierAct(o)
    --- preset
    if (true == tpl._preNoAttack) then
        superposition.plus(o, "noAttack")
    end
    if (true == tpl._preNoPath) then
        superposition.plus(o, "noPath")
    end
    if (true == tpl._preInvulnerable) then
        superposition.plus(o, "invulnerable")
    end
    if (true == tpl._preLocust) then
        superposition.plus(o, "locust")
    end
    -- 动画 animateProperties
    if (type(tpl._animateProperties) == "table") then
        for _, v in ipairs(tpl._animateProperties) do
            J.AddUnitAnimationProperties(h, v, true)
        end
    end
    -- 技能栏载入
    if (true ~= tpl._preNoAbilitySlot) then
        o._abilitySlot = AbilitySlot(o)
        if (tpl._preAbility) then
            for _, v in ipairs(tpl._preAbility) do
                o._abilitySlot:insert(Ability(v))
            end
        end
    end
    -- 物品栏载入
    if (true ~= tpl._preNoItemSlot) then
        o._itemSlot = ItemSlot(o)
        if (tpl._preItem) then
            for _, v in ipairs(tpl._preItem) do
                o._itemSlot:insert(Item(v))
            end
        end
    end
    --- TPL事件注册
    local es = tpl._onEvent
    if (type(es) == "table") then
        for _, e in ipairs(es) do
            event.syncRegister(o, table.unpack(e))
        end
    end
    Group(UnitClass):insert(o)
    return o
end