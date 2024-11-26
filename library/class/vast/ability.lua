--- 技能对象
--- 此对象在实例化时再继承对应的AbilityTpl对象
--- 当Tpl对象数据改动时，也会跟随改动，但独立设置数据后不再变动跟随
---@class Ability:AbilityTpl
local _index = Vast(AbilityClass)

---@protected
function _index:destruct()
    local bindUnit = self:bindUnit()
    if (class.isObject(bindUnit, UnitClass)) then
        local slot = bindUnit:abilitySlot()
        if (slot) then
            slot:remove(self:abilitySlotIndex())
        end
    end
    self._abilitySlotIndex = nil
    self._bindUnit = nil
    self._bindItem = nil
    class.destroy(self._coolDownTimer)
    self._coolDownTimer = nil
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

--- 预设单位事件数据数组
---@see eventKind
---@param evt string 事件类型字符，参考eventKind
---@vararg string|function 可以填写(function)或(string, function)当有string参数时作为事件的key
---@return self
function _index:onUnitEvent(evt, ...)
    local opt = { ... }
    local key
    local callFunc
    if (type(opt[1]) == "function") then
        key = self:id() .. evt
        callFunc = opt[1]
    elseif (type(opt[1]) == "string" and type(opt[2]) == "function") then
        key = self:id() .. evt .. opt[1]
        callFunc = opt[2]
    end
    if (nil ~= key) then
        local eKey = "ue#" .. key
        if (nil == callFunc) then
            event.syncUnregister(self, eventKind.abilityGet, eKey)
            event.syncUnregister(self, eventKind.abilityLose, eKey)
        else
            ---@param getData eventOnAbilityGet
            self:onEvent(eventKind.abilityGet, eKey, function(getData)
                event.syncRegister(getData.triggerUnit, evt, eKey, function(callData)
                    callData.triggerAbility = getData.triggerAbility
                    callFunc(callData)
                end)
            end)
            ---@param loseData eventOnAbilityLose
            self:onEvent(eventKind.abilityLose, eKey, function(loseData)
                event.syncUnregister(loseData.triggerUnit, evt, eKey)
            end)
        end
    end
    return self
end

--- 根据设置指针条件返回一个结果，一般为integer
--- 如果没有条件，默认返回0，全允许
---@param data AbilityCursorData
---@return number integer
function _index:cursorCondResult(data)
    local c = self:get("cursorCond")
    if (type(c) == "function") then
        return c(data)
    end
    return 0
end

--- 技能TPL
---@return AbilityTpl
function _index:tpl()
    return self._tpl
end

--- 当前热键字符串
---@return number|nil
function _index:hotkey()
    return self._hotkey
end

--- 当前绑定单位
---@param variety Unit|nil
---@return self|Unit
function _index:bindUnit(variety)
    return self:modify("bindUnit", variety)
end

--- 当前绑定物品
---@param variety Item|nil
---@return self|Item
function _index:bindItem(variety)
    return self:modify("bindItem", variety)
end

--- 当前技能栏位置
---@param variety number|nil
---@return self|number|nil
function _index:abilitySlotIndex(variety)
    return self:modify("abilitySlotIndex", variety)
end

--- 技能不能使用的原因
--- 而设置了原因的技能等同禁用[看isBan]
---@return string|void
function _index:banReason()
    local bu = self:bindUnit()
    if (class.isObject(bu, UnitClass)) then
        if (bu:isCastChanting()) then
            return "吟唱中"
        end
        if (bu:isCastKeeping()) then
            return "施法中"
        end
    end
    if (self:isCooling()) then
        return "冷却中"
    end
    local advRe
    local costAdv = self:get("costAdv")
    if (isArray(costAdv)) then
        costAdv:forEach(function(k, v)
            if (true ~= v.cond(self)) then
                advRe = v.reason or (string.upper(k) .. "不足")
                return false
            end
        end)
    end
    if (advRe) then
        return advRe
    end
    if (class.isObject(bu, UnitClass)) then
        if (bu:isStunning()) then
            return "被眩晕"
        end
        if (bu:isSilencing()) then
            return "被沉默"
        end
    end
end

--- 技能是否被禁用，无法起效
--- 有原因则为禁用
---@return boolean
function _index:isBan()
    local br = self:banReason()
    return type(br) == "string"
end

--- 是否施法目标允许
---@param targetObj nil|Unit
---@return boolean
function _index:isCastTarget(targetObj)
    local tt = self:targetType()
    if (tt == ability.targetType.unit and false == class.isObject(targetObj, UnitClass)) then
        return false
    end
    local cta = self:targetFilter()
    if (nil == cta or type(cta) ~= "function") then
        return false
    end
    return cta(self, targetObj)
end

--- 触发技能变动机制
---@param evtData nil|{triggerUnit:Unit,triggerItem:Item}
---@return void
function _index:triggerChange(evtData)
    if (nil == evtData) then
        evtData = { triggerUnit = self:bindUnit(), triggerAbility = self }
    end
    if (nil == evtData.triggerAbility) then
        evtData.triggerAbility = self
    end
    local tu = evtData.triggerUnit
    if (nil ~= tu) then
        event.syncTrigger(tu, eventKind.unitAbilityChange, evtData)
        if (nil == evtData.triggerItem) then
            evtData.triggerItem = self:bindItem()
        end
        if (nil ~= evtData.triggerItem) then
            event.syncTrigger(tu, eventKind.unitItemChange, evtData)
        end
    end
end

--- 技能启动（检测阶段）
--- 技能效果要启动分为这多种阶段
--- 常规施法过程：检测、吟唱（可停止施法中止过程）、冷却、施法瞬间、效果发生
--- 持续施法过程：检测、吟唱（可停止施法中止过程）、冷却、施法瞬间、周期性效果发生（可停止施法中止过程）、施法结束（完整结束）
--- 详情可看下方castEnter、chantingEnter等阶段分解
--- targetUnit 对单位时存在
--- targetX 对单位、点、范围时存在
--- targetY 对单位、点、范围时存在
--- targetZ 对单位、点、范围时存在
---@alias AbilitySpellEvtData {triggerUnit:Unit,targetUnit:Unit,targetX:number,targetY:number,targetZ:number}
---@param evtData AbilitySpellEvtData
---@return void
function _index:spell(evtData)
    sync.must()
    evtData = evtData or {}
    local triggerUnit = evtData.triggerUnit or self:bindUnit()
    if (false == class.isObject(triggerUnit, UnitClass)) then
        return
    end
    local tt = self:targetType()
    if (tt == ability.targetType.unit and class.isObject(evtData.targetUnit, UnitClass)) then
        if (false == self:isCastTarget(evtData.targetUnit)) then
            return
        end
    end
    if (true == self:isBan() or triggerUnit:isInterrupt() or triggerUnit:isPause()) then
        return
    end
    local triggerOwner = triggerUnit:owner()
    if (tt ~= ability.targetType.pas) then
        async.call(triggerOwner, function()
            cursor.quoteOver()
        end)
    end
    evtData.triggerAbility = self
    evtData.triggerUnit = triggerUnit
    if (nil == evtData.targetX or nil == evtData.targetY or nil == evtData.targetZ) then
        if (class.isObject(evtData.targetUnit, UnitClass)) then
            evtData.targetX = evtData.targetUnit:x()
            evtData.targetY = evtData.targetUnit:y()
            evtData.targetZ = evtData.targetUnit:z()
        end
    end
    if (type(evtData.targetX) == "number" and type(evtData.targetY) == "number" and nil == evtData.targetZ) then
        evtData.targetZ = japi.Z(evtData.targetX, evtData.targetY)
    end
    if (tt == ability.targetType.pas or tt == ability.targetType.none) then
        --- 进入施法流程
        self:spellStart(evtData)
    else
        --- 非无视距离类型需要进行距离判断
        local castDistance = self:castDistance()
        local distTarget
        if (class.isObject(evtData.targetUnit, UnitClass)) then
            distTarget = evtData.targetUnit
        elseif (evtData.targetX and evtData.targetY) then
            distTarget = { evtData.targetX, evtData.targetY }
        else
            distTarget = triggerUnit
        end
        player.unitDistanceAction(triggerUnit, distTarget, castDistance, function()
            --- 进入施法流程
            self:spellStart(evtData)
        end)
    end
end

--- 进入施法流程
---@private
---@param evtData AbilitySpellEvtData
---@return void
function _index:spellStart(evtData)
    sync.must()
    local costAdv = self:get("costAdv")
    local check = true
    if (isArray(costAdv)) then
        costAdv:forEach(function(_, v)
            if (false == v.cond(self)) then
                check = false
                return false
            end
        end)
    end
    if (false == check) then
        return
    end
    --- 预执行
    if (isArray(costAdv)) then
        costAdv:forEach(function(_, v)
            v.deplete(self)
        end)
    end
    local triggerUnit = evtData.triggerUnit
    --- 有目标坐标时，改一下面向角度
    if (evtData.targetX and evtData.targetY) then
        triggerUnit:facing(vector2.angle(triggerUnit:x(), triggerUnit:y(), evtData.targetX, evtData.targetY))
    end
    --- 触发使用物品
    evtData.triggerItem = self:bindItem()
    if (class.isObject(evtData.triggerItem, ItemClass)) then
        if (evtData.triggerItem:charges() <= 0 and evtData.triggerItem:consumable()) then
            return
        end
        event.syncTrigger(evtData.triggerItem, eventKind.itemUsed, evtData)
        if (false == class.isDestroy(evtData.triggerItem)) then
            event.syncTrigger(triggerUnit, eventKind.unitItemUsed, evtData)
        end
    end
    --- 技能开始施放（但未生效）
    event.syncTrigger(self, eventKind.abilitySpell, evtData)
    if (false == class.isDestroy(self)) then
        event.syncTrigger(triggerUnit, eventKind.unitAbilitySpell, evtData)
    end
    if (false == class.isDestroy(self)) then
        --- 进入吟唱过程
        self:chanting(evtData)
    end
end

--- 预开启单位技能过程的动态捕捉
---@private
---@param kind string
---@param evtData AbilitySpellEvtData
---@param period number 执行预周期（秒）
---@param revert fun(goon:boolean) 顺利完整执行后回调（goon为true）
---@param call function|nil 动态过程中每秒执行
---@return void
function _index:capture(kind, evtData, period, revert, call)
    must(type(kind) == "string", "kind@string")
    must(type(period) == "number" and period > 0, "period@number")
    local triggerUnit = evtData.triggerUnit
    if (class.isObject(triggerUnit, UnitClass)) then
        local interruptible = (kind ~= "cool") -- 是否可中断
        if (nil == self._abCap) then
            self._abCap = {}
        end
        local _cap = self._abCap[kind]
        local _rev = function(...)
            class.destroy(_cap.timer)
            if (type(revert) == "function") then
                revert(...)
            end
        end
        if (nil == _cap) then
            _cap = {
                kind = kind,
                i = 0,
                period = period,
                limit = period * 10,
                revert = _rev,
                call = call,
            }
            _cap.timer = time.setInterval(0.1, function(curTimer)
                if (interruptible and triggerUnit:isInterrupt()) then
                    class.destroy(curTimer)
                    _cap.revert(false)
                else
                    _cap.i = _cap.i + 1
                    if (_cap.i >= _cap.limit) then
                        class.destroy(curTimer)
                        _cap.revert(true)
                        triggerUnit._abCap = nil
                        self._abCap[kind] = nil
                    end
                    if (type(_cap.call) == "function" and 0 == _cap.i % 10) then
                        _cap.call()
                    end
                end
                self:triggerChange(evtData)
            end)
            self._abCap[kind] = _cap
            if (interruptible) then
                triggerUnit._abCap = _cap
            end
        else
            _cap.i = 0
            _cap.period = period
            _cap.limit = period * (1 / 0.1)
            _cap.revert = _rev
            _cap.call = call
            if (interruptible) then
                triggerUnit._abCap = _cap
            end
        end
    end
end

--- 进入吟唱过程
---@private
---@param evtData AbilitySpellEvtData
---@return void
function _index:chanting(evtData)
    local period = 0
    local tt = self:targetType()
    if (tt ~= ability.targetType.pas) then
        period = self:castChant()
    end
    local triggerUnit = evtData.triggerUnit
    if (period > 0) then
        superposition.plus(triggerUnit, "pause")
        local ca = triggerUnit:spellAnimation() or self:spellAnimation()
        if (ca) then
            time.setTimeout(0, function()
                triggerUnit:animate(ca)
            end)
        end
        local animateScale = triggerUnit:animateScale()
        triggerUnit:animateScale(1 / period)
        effector.attach(triggerUnit, self:castChantEffect(), "origin", period)
        self:capture("chant", evtData, period, function(goon)
            triggerUnit:animateScale(animateScale)
            superposition.minus(triggerUnit, "pause")
            if (goon) then
                --- 进入生效过程
                self:effective(evtData)
            else
                --- 停止施法过程
                self:spellStop(evtData)
            end
        end)
        ---@param interruptInData eventOnAbilityEffective
        triggerUnit:onEvent(eventKind.unitInterruptIn, "lk_chanting", function(interruptInData)
            event.syncUnregister(triggerUnit, eventKind.unitInterruptIn, "lk_chanting")
            interruptInData.triggerUnit:abilityCaptureRevert()
        end)
    else
        --- 进入生效过程
        self:effective(evtData)
    end
end

--- 停止施法过程
---@private
---@param evtData AbilitySpellEvtData
---@return void
function _index:spellStop(evtData)
    sync.must()
    event.syncTrigger(self, eventKind.abilityStop, evtData) --触发技能被停止
    if (false == class.isDestroy(self)) then
        event.syncTrigger(evtData.triggerUnit, eventKind.unitAbilityStop, evtData) --触发单位停止施放技能
    end
end

--- 持续施法的执行
---@private
---@param evtData AbilitySpellEvtData
---@return void
function _index:casting(evtData)
    sync.must()
    local triggerUnit = evtData.triggerUnit
    local ka = triggerUnit:castKeepAnimation() or self:castKeepAnimation()
    if (ka) then
        triggerUnit:animate(ka)
    end
    event.syncTrigger(self, eventKind.abilityCasting, evtData) --触发技能持续每周期做动作时
    if (false == class.isDestroy(self)) then
        event.syncTrigger(triggerUnit, eventKind.unitAbilityCasting, evtData) --触发技能持续每周期做动作时
    end
end

--- 进入生效过程
--- 冷却时间在此过程中开始计算
---@private
---@param evtData AbilitySpellEvtData
---@return void
function _index:effective(evtData)
    sync.must()
    local tt = self:targetType()
    if (tt == ability.targetType.unit) then
        if (class.isDestroy(evtData.targetUnit) or evtData.targetUnit:isDead()) then
            return
        end
    end
    local triggerUnit = evtData.triggerUnit
    --- 进入冷却过程
    self:cooling()
    event.syncTrigger(self, eventKind.abilityEffective, evtData) --触发技能被施放
    if (false == class.isDestroy(self)) then
        event.syncTrigger(triggerUnit, eventKind.unitAbilityEffective, evtData) --触发单位施放了技能
    end
    self:triggerChange(evtData)
    if (false == class.isDestroy(self)) then
        --- 进入持续过程
        self:keeping(evtData)
    end
end

--- 进入持续过程
---@private
---@param evtData AbilitySpellEvtData
---@return void
function _index:keeping(evtData)
    sync.must()
    local triggerUnit = evtData.triggerUnit
    local period = self:castKeep()
    if (period > 0) then
        superposition.plus(triggerUnit, "pause")
        self:capture("keep", evtData, period, function(goon)
            superposition.minus(triggerUnit, "pause")
            if (goon) then
                event.syncTrigger(self, eventKind.abilityOver, evtData) --触发持续技能结束
                if (false == class.isDestroy(self)) then
                    event.syncTrigger(triggerUnit, eventKind.unitAbilityOver, evtData) --触发单位持续技能结束
                end
            else
                --- 停止施法过程
                self:spellStop(evtData)
            end
        end, function()
            --- 持续施法的后续执行
            self:casting(evtData)
        end)
        --- 首次施法的后续执行
        self:casting(evtData)
        ---@param interruptInData eventOnAbilityEffective
        triggerUnit:onEvent(eventKind.unitInterruptIn, "lk_keeping", function(interruptInData)
            event.syncUnregister(triggerUnit, eventKind.unitInterruptIn, "lk_keeping")
            interruptInData.triggerUnit:abilityCaptureRevert()
        end)
    end
end

--- 进入冷却过程
---@private
---@return void
function _index:cooling()
    local cd = self:coolDown()
    if (cd > 0) then
        local revert
        local evtData = { triggerUnit = self:bindUnit() }
        local pot = self:castPotTimes()
        if (pot > 0 and self._castPotRemain > 0) then
            local tp = self:castPotType()
            self._castPotRemain = self._castPotRemain - 1
            if (self._castPotRemain > 0) then
                -- 当还有剩余次数时
                -- 分析内部额外冷却并中断主冷却流程
                if (tp == 1) then
                    -- 施法匣类型 1 第1次施法后就开始发生冷却，直到全部次数补满
                    if (nil == self._castPotTimer) then
                        self._castPotTimer = time.setInterval(cd, function(curTimer)
                            self._castPotRemain = self._castPotRemain + 1
                            if (self._castPotRemain >= pot) then
                                class.destroy(curTimer)
                                self._castPotTimer = nil
                            end
                            self:triggerChange(evtData)
                        end)
                    end
                elseif (tp == 2) then
                    -- 施法匣类型 2 全部施法才发生冷却，但会开启一个内部计时，当施法次数在超过冷却时间仍未使用全部次数，技能恢复满次数
                    class.destroy(self._castPotTimer)
                    self._castPotTimer = time.setTimeout(cd, function()
                        self._castPotRemain = pot
                        self:triggerChange(evtData)
                    end)
                end
                self:triggerChange(evtData)
                return
            else
                -- 当没有剩余次数时
                if (tp == 1) then
                    -- 施法匣类型 1 以最短冷却时间瞬间切回主冷却计时，后续再开启内部计时
                    if (nil ~= self._castPotTimer) then
                        local cdShort = self._castPotTimer:remain()
                        class.destroy(self._castPotTimer)
                        self._castPotTimer = time.setInterval(cd, function(curTimer)
                            self._castPotRemain = self._castPotRemain + 1
                            if (self._castPotRemain >= pot) then
                                class.destroy(curTimer)
                                self._castPotTimer = nil
                            end
                            self:triggerChange(evtData)
                        end)
                        cd = cdShort
                    end
                    revert = function()
                        self._castPotRemain = self._castPotRemain + 1
                        if (self._castPotRemain >= pot) then
                            class.destroy(curTimer)
                            self._castPotTimer = nil
                        end
                    end
                else
                    -- 施法匣类型 2 清除所有内部计时，不需要两重冷却计时，直接回归主冷却计时
                    class.destroy(self._castPotTimer)
                    self._castPotTimer = nil
                    revert = function()
                        self._castPotRemain = pot
                    end
                end
            end
        end
        self:capture("cool", evtData, cd, revert)
    end
end

--- 获取施法匣剩余次数
---@return number
function _index:castPotRemain()
    return self._castPotRemain
end

--- 获取施法匣内部冷却时间
---@return number
function _index:castPotCoolingRemain()
    if (class.isObject(self._castPotTimer, TimerClass)) then
        return self._castPotTimer:remain()
    end
    return 0
end

--- 获取冷却过程剩余时间
---@return number
function _index:coolingRemain()
    if (self:isCooling()) then
        return 0.1 * (self._abCap.cool.limit - self._abCap.cool.i)
    end
    return 0
end

--- 瞬间冷却
---@return void
function _index:coolingInstant()
    if (self:isCooling()) then
        self._abCap.cool.i = self._abCap.cool.limit
    end
end

--- 是否冷却中
---@return boolean
function _index:isCooling()
    return nil ~= self._abCap and nil ~= self._abCap.cool
end

--- 技能对象
--- 继承tpl创建技能
---@param tpl AbilityTpl
---@return Ability
function Ability(tpl)
    must(class.isObject(tpl, AbilityTplClass), "tpl@AbilityTpl")
    ---@type Ability
    local o = oVast({ _tpl = tpl }, _index, tpl)
    --- modifier do action
    VastModifierAct(o)
    --- 事件注册
    if (type(tpl._onEvent) == "table") then
        for _, e in ipairs(tpl._onEvent) do
            o:onEvent(table.unpack(e))
        end
    end
    --- 单位事件注册
    if (type(tpl._onUnitEvent) == "table") then
        for _, e in ipairs(tpl._onUnitEvent) do
            o:onUnitEvent(table.unpack(e))
        end
    end
    return o
end