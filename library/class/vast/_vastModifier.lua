---[[:use library/class/vast/ability]]
---[[:use library/class/vast/abilityTpl]]
---[[:use library/class/vast/item]]
---[[:use library/class/vast/player]]
---[[:use library/class/vast/unit]]
---[[:use library/class/vast/unitTpl]]
--- Vast对象修改模式
local modifier = {
    [AbilityTplClass] = {
        ---@param obj AbilityTpl
        ---@param newVal number
        _castPotTimes = function(obj, _, newVal)
            obj._castPotRemain = newVal
        end,
    },
    [AbilityClass] = {
        ---@param obj Ability
        ---@param oldVal Unit
        ---@param newVal Unit
        _bindUnit = function(obj, oldVal, newVal)
            if (class.isObject(oldVal, UnitClass)) then
                event.syncTrigger(obj, eventKind.abilityLose, { triggerUnit = oldVal })
                if (false == class.isDestroy(obj)) then
                    event.syncTrigger(oldVal, eventKind.unitAbilityLose, { triggerAbility = obj })
                end
                local index = obj:abilitySlotIndex()
                if (nil ~= index) then
                    local slot = oldVal:abilitySlot()
                    slot._storage[index] = nil
                    slot:triggerChange()
                end
            end
            if (class.isObject(newVal, UnitClass)) then
                event.syncTrigger(obj, eventKind.abilityGet, { triggerUnit = newVal })
                if (false == class.isDestroy(obj)) then
                    event.syncTrigger(newVal, eventKind.unitAbilityGet, { triggerAbility = obj })
                end
            else
                obj._abilitySlotIndex = nil
                obj._bindUnit = nil
            end
        end,
        ---@param oldVal Item
        _bindItem = function(_, oldVal, _)
            if (class.isObject(oldVal, ItemClass)) then
                oldVal._bindAbility = nil
            end
        end,
        ---@param obj Ability
        ---@param oldVal table
        ---@param newVal table
        _attributes = function(obj, oldVal, newVal)
            local eKey = "attributes"
            event.syncUnregister(obj, eventKind.abilityGet, eKey)
            event.syncUnregister(obj, eventKind.abilityLose, eKey)
            event.syncUnregister(obj, eventKind.abilityLevelChange, eKey)
            if (type(newVal) == "table") then
                for i = #newVal, 1, -1 do
                    local method = newVal[i][1]
                    local base = newVal[i][2]
                    local vary = newVal[i][3]
                    if (type(method) ~= "string" or (nil == base and nil == vary)) then
                        table.remove(newVal, i)
                    end
                    newVal[i][1] = attribute.enParam(method)
                end
                if (type(oldVal) == "table") then
                    for i = #oldVal, 1, -1 do
                        oldVal[i][1] = attribute.enParam(oldVal[i][1])
                    end
                    local u = obj:bindUnit()
                    if (class.isObject(u, UnitClass)) then
                        local lv = obj:level()
                        attribute.comp(oldVal, u, lv, -lv)
                        attribute.comp(newVal, u, 0, lv)
                    end
                end
                ---@param getData eventOnAbilityGet
                obj:onEvent(eventKind.abilityGet, eKey, function(getData)
                    attribute.comp(newVal, getData.triggerUnit, 0, getData.triggerAbility:level())
                end)
                ---@param loseData eventOnAbilityLose
                obj:onEvent(eventKind.abilityLose, eKey, function(loseData)
                    attribute.comp(newVal, loseData.triggerUnit, loseData.triggerAbility:level(), -loseData.triggerAbility:level())
                end)
                ---@param lvcData eventOnAbilityLevelChange
                obj:onEvent(eventKind.abilityLevelChange, eKey, function(lvcData)
                    attribute.comp(newVal, lvcData.triggerUnit, lvcData.old, lvcData.new - lvcData.old)
                end)
            end
        end,
        ---@param obj Ability
        ---@param newVal any
        _abilitySlotIndex = function(obj, _, newVal)
            obj._hotkey = keyboard.abilityHotkey(newVal)
        end,
        ---@param obj Ability
        ---@param newVal number
        _exp = function(obj, _, newVal)
            local lv = obj._level or 0
            if (lv >= 1) then
                local lvn = game.abilityExpToLevel(newVal)
                if (lvn ~= lv) then
                    obj:level(lvn)
                end
            end
        end,
        ---@param obj Ability
        ---@param oldVal number
        ---@param newVal number
        _level = function(obj, oldVal, newVal)
            local bu = obj:bindUnit()
            event.syncTrigger(obj, eventKind.abilityLevelChange, { triggerUnit = bu, old = oldVal, new = newVal })
            if (false == class.isDestroy(obj)) then
                event.syncTrigger(bu, eventKind.unitAbilityLevelChange, { triggerAbility = obj, old = oldVal, new = newVal })
            end
            if (false == class.isDestroy(obj)) then
                if ((obj:exp() or 0) > 0) then
                    if ((newVal > 1 and newVal > oldVal) or newVal < oldVal) then
                        obj._exp = game.abilityExpNeeds(newVal)
                    end
                end
            end
        end,
    },
    [ItemClass] = {
        ---@param obj Item
        ---@param oldVal Unit
        ---@param newVal Unit
        _bindUnit = function(obj, oldVal, newVal)
            if (class.isObject(oldVal, UnitClass)) then
                event.syncTrigger(obj, eventKind.itemLose, { triggerUnit = oldVal })
                if (false == class.isDestroy(obj)) then
                    event.syncTrigger(oldVal, eventKind.unitItemLose, { triggerItem = obj })
                end
                local index = obj:itemSlotIndex()
                if (nil ~= index) then
                    local slot = oldVal:itemSlot()
                    slot._storage[index] = nil
                    slot:triggerChange()
                end
            end
            local ab = obj:bindAbility()
            if (class.isObject(newVal, UnitClass)) then
                event.syncTrigger(obj, eventKind.itemGet, { triggerUnit = newVal })
                if (false == class.isDestroy(obj)) then
                    event.syncTrigger(newVal, eventKind.unitItemGet, { triggerItem = obj })
                end
                if (false == class.isDestroy(obj) and class.isObject(ab, AbilityClass)) then
                    ab:bindUnit(newVal)
                end
            else
                obj._itemSlotIndex = nil
                obj._bindUnit = nil
                if (class.isObject(ab, AbilityClass)) then
                    ab:setNil("bindUnit")
                end
            end
        end,
        ---@param obj Item
        ---@param oldVal Ability
        ---@param newVal Ability
        _bindAbility = function(obj, oldVal, newVal)
            local bu = obj:bindUnit()
            if (class.isObject(oldVal, AbilityClass)) then
                oldVal:setNil("bindUnit")
                oldVal:setNil("bindItem")
                class.destroy(oldVal)
            end
            if (false == class.isDestroy(obj) and class.isObject(newVal, AbilityClass)) then
                newVal:bindItem(obj)
                newVal:bindUnit(bu)
            end
        end,
        ---@param obj Item
        ---@param oldVal table
        ---@param newVal table
        _attributes = function(obj, oldVal, newVal)
            local eKey = "attributes"
            event.syncUnregister(obj, eventKind.itemGet, eKey)
            event.syncUnregister(obj, eventKind.itemLose, eKey)
            event.syncUnregister(obj, eventKind.itemLevelChange, eKey)
            if (type(newVal) == "table") then
                for i = #newVal, 1, -1 do
                    local method = newVal[i][1]
                    local base = newVal[i][2]
                    local vary = newVal[i][3]
                    if (type(method) ~= "string" or (nil == base and nil == vary)) then
                        table.remove(newVal, i)
                    end
                    newVal[i][1] = attribute.enParam(method)
                end
                if (type(oldVal) == "table") then
                    for i = #oldVal, 1, -1 do
                        oldVal[i][1] = attribute.enParam(oldVal[i][1])
                    end
                    local u = obj:bindUnit()
                    if (class.isObject(u, UnitClass)) then
                        local lv = obj:level()
                        attribute.comp(oldVal, u, lv, -lv)
                        attribute.comp(newVal, u, 0, lv)
                    end
                end
                ---@param getData eventOnItemGet
                obj:onEvent(eventKind.itemGet, eKey, function(getData)
                    attribute.comp(newVal, getData.triggerUnit, 0, getData.triggerItem:level())
                end)
                ---@param loseData eventOnItemLose
                obj:onEvent(eventKind.itemLose, eKey, function(loseData)
                    attribute.comp(newVal, loseData.triggerUnit, loseData.triggerItem:level(), -loseData.triggerItem:level())
                end)
                ---@param lvcData eventOnItemLevelChange
                obj:onEvent(eventKind.itemLevelChange, eKey, function(lvcData)
                    attribute.comp(newVal, lvcData.triggerUnit, lvcData.old, lvcData.new - lvcData.old)
                end)
            end
        end,
        ---@param obj Item
        ---@param newVal any
        _itemSlotIndex = function(obj, _, newVal)
            local hk = keyboard.itemHotkey(newVal)
            obj._hotkey = hk
            local ab = obj:bindAbility()
            if (class.isObject(ab, AbilityClass)) then
                ab._hotkey = hk
            end
        end,
        ---@param obj Item
        ---@param newVal boolean
        _instance = function(obj, _, newVal)
            local x, y = obj._x, obj._y
            if (true == newVal) then
                if (nil == obj._handle) then
                    local e = effector.agile(obj:model(), x, y, obj._z)
                    obj._handle = e
                    effector.rotateZ(e, 270)
                    effector.alpha(e, 125)
                    effector.size(e, obj:modelScale())
                    effector.speed(e, obj:animateScale())
                    Grid(ItemClass):insert(obj)
                end
            else
                if (nil ~= obj._handle) then
                    Grid(ItemClass):remove(obj)
                    effector.destroy(obj._handle, true)
                    obj._handle = nil
                    datum.freePosition(x, y)
                    obj._x = 0
                    obj._y = 0
                    obj._z = 0
                end
            end
            -- 清除掉绑定的数据和对象
            if (class.isObject(obj._bindPlayer, PlayerClass)) then
                obj._bindPlayer:warehouseSlot():remove(obj._warehouseSlotIndex)
            end
            if (class.isObject(obj._bindUnit, UnitClass)) then
                local slot = obj._bindUnit:itemSlot()
                if (class.isObject(slot, ItemSlotClass)) then
                    slot:remove(obj._itemSlotIndex)
                end
            end
            obj._itemSlotIndex = nil
        end,
        ---@param obj Item
        ---@param newVal number
        _modelScale = function(obj, _, newVal)
            if (nil ~= obj._handle) then
                effector.size(obj._handle, newVal)
            end
        end,
        ---@param obj Item
        ---@param newVal number
        _animateScale = function(obj, _, newVal)
            if (nil ~= obj._handle) then
                effector.speed(obj._handle, newVal)
            end
        end,
        ---@param obj Item
        ---@param newVal number
        _duration = function(obj, _, newVal)
            if (class.isObject(obj._durationTimer, TimerClass)) then
                class.destroy(obj._durationTimer)
                obj._durationTimer = nil
            end
            if (newVal > 0) then
                obj._durationTimer = time.setTimeout(newVal, function()
                    class.destroy(obj)
                end)
            end
        end,
        ---@param obj Item
        ---@param newVal boolean
        _autoUse = function(obj, _, newVal)
            if (true == newVal) then
                ---@param pickData eventOnItemPick
                obj:onEvent(eventKind.itemPick, "_autoUse", function(pickData)
                    local it = pickData.triggerItem
                    it:spell({ triggerItem = it, triggerUnit = pickData.triggerUnit })
                    class.destroy(it)
                end)
            else
                obj:onEvent(eventKind.itemPick, "_autoUse", nil)
            end
        end,
        ---@param obj Item
        ---@param newVal number
        _exp = function(obj, _, newVal)
            local lv = obj._level or 0
            if (lv >= 1) then
                local lvn = game.itemExpToLevel(newVal)
                if (lvn ~= lv) then
                    obj:level(lvn)
                end
            end
        end,
        ---@param obj Item
        ---@param newVal number
        _level = function(obj, oldVal, newVal)
            local bu = obj:bindUnit()
            local ab = obj:bindAbility()
            if class.isObject(ab, AbilityClass) then
                if (ab:levelMax() < newVal) then
                    ab:levelMax(newVal)
                end
                if (ab:level() ~= newVal) then
                    ab:level(newVal)
                end
            end
            event.syncTrigger(obj, eventKind.itemLevelChange, { triggerUnit = bu, old = oldVal, new = newVal })
            if (false == class.isDestroy(obj)) then
                event.syncTrigger(bu, eventKind.unitItemLevelChange, { triggerItem = obj, old = oldVal, new = newVal })
            end
            if (false == class.isDestroy(obj)) then
                if ((obj:exp() or 0) > 0) then
                    if ((newVal > 1 and newVal > oldVal) or newVal < oldVal) then
                        obj._exp = game.itemExpNeeds(newVal)
                    end
                end
            end
        end,
    },
    [PlayerClass] = {
        ---@param obj Player
        ---@param newVal string
        _name = function(obj, _, newVal)
            J.SetPlayerName(obj._handle, newVal)
        end,
        ---@param oldVal string
        ---@param newVal string
        _race = function(_, oldVal, newVal)
            -- 如果游戏皮肤设置跟随种族，则继续跟随修改
            if (game.skin == oldVal) then
                game.skin = newVal
            end
        end,
        ---@param obj Player
        ---@param newVal number
        _teamColor = function(obj, _, newVal)
            J.SetPlayerColor(obj._handle, PLAYER_COLOR[newVal])
        end,
        ---@param oldVal table
        ---@param newVal table
        _worth = function(obj, oldVal, newVal)
            event.syncTrigger(obj, eventKind.playerWorthChange, {
                old = oldVal,
                new = newVal
            })
        end,
        ---@param obj Player
        ---@param oldVal Unit|Item
        ---@param newVal Unit|Item
        _selection = function(obj, oldVal, newVal)
            if (nil ~= oldVal) then
                event.syncTrigger("player", eventKind.playerDeSelect, {
                    triggerPlayer = obj,
                    triggerUnit = oldVal
                })
            end
            event.syncTrigger("player", eventKind.playerSelect, {
                triggerPlayer = obj,
                old = oldVal,
                new = newVal
            })
        end,
    },
    [UnitTplClass] = {
        ---@param obj UnitTpl
        ---@param newVal string
        _slkId = function(obj, _, newVal)
            local newData = slk.i2v(newVal)
            if (type(newData) == "table") then
                obj._collision = math.round(newData.slk.collision)
                obj._building = (1 == math.round(newData.slk.isbldg or 0)) or (type(newData.slk.uberSplat) == "string" and string.len(newData.slk.uberSplat) > 0)
                obj._sightBase = math.round(newData.slk.sight)
                obj._sightDiff = math.round(newData.slk.sight) - math.round(newData.slk.nsight)
                obj._sight = obj._sightBase
                obj._nsight = obj._sightBase - obj._sightDiff
                obj._turnSpeed = tonumber(newData.slk.turnRate)
                obj._corpse = tonumber(newData.slk.death or 3)
                local spd = math.round(newData.slk.spd or 0)
                if (spd <= 0) then
                    spd = 0
                end
                obj._immovable = spd <= 0
                obj._move = spd
                obj._attackSpaceBase = math.round(newData.slk.cool1 or 0)
                obj._attackRangeAcquire = math.round(newData.slk.acquire)
                obj._attackRange = math.round(newData.slk.rangeN1 or 0)
                obj._model = newData.slk.file
                obj._modelScale = math.trunc(newData.slk.modelScale or 1, 2)
                obj._scale = math.trunc(newData.slk.scale or 1, 2)
                obj._rgba = { math.round(newData.slk.red), math.round(newData.slk.green), math.round(newData.slk.blue), 255 }
                obj._flyHeight = math.round(newData.slk.moveHeight or 0)
                if (obj._flyHeight > 0) then
                    obj:moveType(newData.unitMoveType.fly)
                end
                obj._icon = newData.slk.Art or X_UI_QUESTION
            else
                print("slkData fetch failed! SlkId:" .. newVal)
            end
        end,
        ---@param obj UnitTpl
        ---@param newVal string
        _flyHeight = function(obj, _, newVal)
            if (newVal > 0) then
                if (obj._moveType == attribute.unitMoveType.foot) then
                    obj._moveType = attribute.unitMoveType.fly
                elseif (obj._moveType == attribute.unitMoveType.amphibious) then
                    obj._moveType = attribute.unitMoveType.float
                end
            else
                if (obj._moveType == attribute.unitMoveType.fly) then
                    obj._moveType = attribute.unitMoveType.foot
                elseif (obj._moveType == attribute.unitMoveType.float) then
                    obj._moveType = attribute.unitMoveType.amphibious
                end
            end
        end,
        ---@param obj UnitTpl
        ---@param newVal number
        _hp = function(obj, _, newVal)
            obj._hpCur = newVal
        end,
        ---@param obj UnitTpl
        ---@param newVal number
        _mp = function(obj, _, newVal)
            obj._mpCur = newVal
        end,
        ---@param obj UnitTpl
        ---@param newVal number
        _shield = function(obj, _, newVal)
            obj._shieldCur = newVal
        end,
        ---@param obj UnitTpl
        ---@param newVal number
        _punish = function(obj, _, newVal)
            obj._punishCur = newVal
        end,
        ---@param obj UnitTpl
        ---@param newVal number
        _sight = function(obj, _, newVal)
            obj._nsight = newVal - obj._sightDiff
        end,
        ---@param obj UnitTpl
        ---@param newVal number
        _nsight = function(obj, _, newVal)
            obj._sight = newVal + obj._sightDiff
        end,
    },
    [UnitClass] = {
        ---@param obj Unit
        ---@param newVal string
        _slkId = function(obj, oldVal, newVal)
            if (oldVal ~= newVal) then
                if (false == class.isDestroy(obj) and obj:isAlive()) then
                    local newData = slk.i2v(newVal)
                    if (type(newData) == "table") then
                        obj._collision = math.round(newData.slk.collision)
                        obj._building = (1 == math.round(newData.slk.isbldg or 0)) or (type(newData.slk.uberSplat) == "string" and string.len(newData.slk.uberSplat) > 0)
                        obj._sightBase = math.round(newData.slk.sight)
                        obj._sightDiff = math.round(newData.slk.sight) - math.round(newData.slk.nsight)
                        obj._turnSpeed = tonumber(newData.slk.turnRate)
                        obj._corpse = tonumber(newData.slk.death or 3)
                        obj._attackSpaceBase = math.round(newData.slk.cool1 or 0)
                        local spd = math.round(newData.slk.spd or 0)
                        if (spd <= 0) then
                            spd = 0
                        end
                        obj._immovable = spd <= 0
                        if (nil == oldVal) then
                            obj._sight = obj._sightBase
                            obj._nsight = obj._sightBase - obj._sightDiff
                            obj._move = spd
                            obj._attackRangeAcquire = math.round(newData.slk.acquire)
                            obj._attackRange = math.round(newData.slk.rangeN1 or 0)
                            obj._model = newData.slk.file
                            obj._modelScale = math.trunc(newData.slk.modelScale or 1, 2)
                            obj._scale = math.trunc(newData.slk.scale or 1, 2)
                            obj._rgba = { math.round(newData.slk.red), math.round(newData.slk.green), math.round(newData.slk.blue), 255 }
                            obj._flyHeight = math.round(newData.slk.moveHeight or 0)
                            if (obj._flyHeight > 0) then
                                obj:moveType(newData.unitMoveType.fly)
                            end
                            obj._icon = newData.slk.Art or X_UI_QUESTION
                        else
                            local oldData = slk.i2v(oldVal)
                            if (newData.slk.sight ~= oldData.slk.sight) then
                                obj:sight("+=" .. tonumber(newData.slk.sight) - tonumber(oldData.slk.sight))
                            end
                            if (newData.slk.spd ~= oldData.slk.spd) then
                                obj:move("+=" .. tonumber(newData.slk.spd) - tonumber(oldData.slk.spd))
                            end
                            if (newData.slk.cool1 ~= oldData.slk.cool1) then
                                obj:attackSpaceBase("+=" .. tonumber(newData.slk.cool1) - tonumber(oldData.slk.cool1))
                            end
                            if (newData.slk.acquire ~= oldData.slk.acquire) then
                                obj:attackRangeAcquire("+=" .. tonumber(newData.slk.acquire) - tonumber(oldData.slk.acquire))
                            end
                            if (newData.slk.rangeN1 ~= oldData.slk.rangeN1) then
                                obj:attackRange("+=" .. tonumber(newData.slk.rangeN1) - tonumber(oldData.slk.rangeN1))
                            end
                            if (newData.slk.scale ~= oldData.slk.scale) then
                                obj:scale("+=" .. tonumber(newData.slk.scale) - tonumber(oldData.slk.scale))
                            end
                            if (newData.slk.moveHeight ~= oldData.slk.moveHeight) then
                                obj:flyHeight("+=" .. tonumber(newData.slk.moveHeight) - tonumber(oldData.slk.moveHeight))
                            end
                            if (newData.slk.Art ~= oldData.slk.Art and obj._icon == oldData.slk.Art) then
                                obj._icon = newData.slk.Art or X_UI_QUESTION
                            end
                        end
                        -- 如果需要条件跟随物编的额外数据，可以尝试下面注释的代码
                        -- japi.DZ_SetUnitID(obj:handle(), newVal)
                    else
                        print("slkData fetch failed! SlkId:" .. newVal)
                    end
                end
            end
        end,
        ---@param obj Unit
        ---@param newVal string
        _speech = function(obj, _, newVal)
            local s = japi.AssetsSpeech(newVal)
            if (type(s) == "string") then
                local id = nil
                if (type(obj._speechExtra) == "string" and obj._speechExtra ~= '') then
                    id = slk.n2i(s .. "|EX|" .. obj._speechExtra)
                end
                if (nil == id) then
                    id = slk.n2i(s .. "|D")
                end
                obj:set("slkId", J.C2I(id))
            end
        end,
        ---@param obj Unit
        ---@param newVal string
        _speechExtra = function(obj, _, newVal)
            local s = japi.AssetsSpeech(obj._speech)
            if (type(s) == "string") then
                local id = nil
                if (type(newVal) == "string" and newVal ~= '') then
                    id = slk.n2i(s .. "|EX|" .. newVal)
                end
                if (nil == id) then
                    id = slk.n2i(s .. "|D")
                end
                obj:set("slkId", J.C2I(id))
            end
        end,
        ---@param obj Unit
        ---@param newVal string
        _model = function(obj, _, newVal)
            local m = japi.AssetsModel(newVal)
            if (type(m) == "string") then
                japi.DZ_SetUnitModel(obj._handle, m)
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _modelScale = function(obj, _, newVal)
            J.SetUnitScale(obj._handle, newVal, newVal, newVal)
        end,
        ---@param obj Unit
        ---@param newVal boolean
        _building = function(obj, _, newVal)
            -- 如果建筑的转向速度大于0，添加扎根解决转向问题
            if (true == newVal and obj._turnSpeed > 0) then
                J.UnitAddAbility(obj._handle, LK_SLK_ID_ABILITY_ZG)
                J.UnitRemoveAbility(obj._handle, LK_SLK_ID_ABILITY_ZG)
            end
        end,
        ---@param obj Unit
        ---@param newVal boolean
        _visible = function(obj, _, newVal)
            ability.visible(obj, newVal)
        end,
        ---@param obj Unit
        ---@param newVal Player
        _owner = function(obj, _, newVal)
            J.SetUnitOwner(obj._handle, newVal._handle, true)
        end,
        ---@param obj Unit
        ---@param newVal number
        _teamColor = function(obj, _, newVal)
            J.SetUnitColor(obj._handle, PLAYER_COLOR[newVal])
        end,
        ---@param obj Unit
        ---@param newVal number
        _animateScale = function(obj, _, newVal)
            J.SetUnitTimeScale(obj._handle, newVal)
        end,
        ---@param obj Unit
        ---@param newVal number
        _turnSpeed = function(obj, _, newVal)
            J.SetUnitTurnSpeed(obj._handle, newVal)
        end,
        ---@param obj Unit
        ---@param newVal number
        _moveType = function(obj, _, newVal)
            time.setTimeout(0, function()
                if (obj:isAlive()) then
                    if (newVal == attribute.unitMoveType.foot) then
                        japi.YD_SetUnitMoveType(obj._handle, MOVE_TYPE_FOOT)
                    elseif (newVal == attribute.unitMoveType.fly) then
                        japi.YD_SetUnitMoveType(obj._handle, MOVE_TYPE_FLY)
                    elseif (newVal == attribute.unitMoveType.amphibious) then
                        japi.YD_SetUnitMoveType(obj._handle, MOVE_TYPE_AMPH)
                    elseif (newVal == attribute.unitMoveType.float) then
                        japi.YD_SetUnitMoveType(obj._handle, MOVE_TYPE_FLOAT)
                    end
                end
            end)
        end,
        ---@param obj Unit
        ---@param oldVal table
        ---@param newVal table
        _attributes = function(obj, oldVal, newVal)
            local eKey = "attributes"
            event.syncUnregister(obj, eventKind.unitBorn, eKey)
            event.syncUnregister(obj, eventKind.unitLevelChange, eKey)
            if (type(newVal) == "table") then
                for i = #newVal, 1, -1 do
                    local method = newVal[i][1]
                    local base = newVal[i][2]
                    local vary = newVal[i][3]
                    if (type(method) ~= "string" or (nil == base and nil == vary)) then
                        table.remove(newVal, i)
                    end
                    newVal[i][1] = attribute.enParam(method)
                end
                if (type(oldVal) == "table") then
                    for i = #oldVal, 1, -1 do
                        oldVal[i][1] = attribute.enParam(oldVal[i][1])
                    end
                    local lv = obj:level()
                    attribute.comp(oldVal, obj, lv, -lv)
                    attribute.comp(newVal, obj, 0, lv)
                end
                ---@param getData eventOnUnitBorn
                obj:onEvent(eventKind.unitBorn, eKey, function(getData)
                    attribute.comp(newVal, getData.triggerUnit, 0, getData.triggerUnit:level())
                end)
                ---@param lvcData eventOnUnitLevelChange
                obj:onEvent(eventKind.unitLevelChange, eKey, function(lvcData)
                    attribute.comp(newVal, lvcData.triggerUnit, lvcData.old, lvcData.new - lvcData.old)
                end)
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _period = function(obj, _, newVal)
            if (class.isObject(obj._periodTimer, TimerClass)) then
                class.destroy(obj._periodTimer)
                obj._periodTimer = nil
            end
            if (newVal > 0) then
                obj._periodTimer = time.setTimeout(newVal, function(pt)
                    class.destroy(pt)
                    obj._periodTimer = nil
                    obj:kill()
                end)
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _duration = function(obj, _, newVal)
            if (class.isObject(obj._durationTimer, TimerClass)) then
                class.destroy(obj._durationTimer)
                obj._durationTimer = nil
            end
            if (newVal > 0) then
                obj._durationTimer = time.setTimeout(newVal, function()
                    class.destroy(obj)
                end)
            end
        end,
        ---@param obj Unit
        ---@param newVal boolean
        _alerter = function(obj, _, newVal)
            if (true == newVal) then
                ---@param spellData eventOnAbilitySpell
                obj:onEvent(eventKind.unitAbilitySpell, "_alerter", function(spellData)
                    local ab = spellData.triggerAbility
                    local tt = ab:targetType()
                    if (tt == ability.targetType.pas) then
                        return
                    end
                    local name = colour.hex(colour.red, '[' .. spellData.triggerUnit:name() .. ']')
                    local abName = colour.hex(colour.violet, '[' .. ab:name() .. ']')
                    echo(name .. "准备施放" .. abName)
                    local dur = ab:castChant()
                    if (dur <= 0) then
                        dur = 1
                    end
                    if (tt == ability.targetType.loc) then
                        local x, y = spellData.triggerUnit:x(), spellData.triggerUnit:y()
                        local angle = vector2.angle(x, y, spellData.targetX, spellData.targetY)
                        alerter.line(x, y, ab:castDistance(), angle, dur)
                    elseif (tt == ability.targetType.none) then
                        local castRadius = ab:castRadius()
                        if (castRadius > 0) then
                            local x, y = spellData.triggerUnit:x(), spellData.triggerUnit:y()
                            alerter.circle(x, y, ab:castRadius(), dur)
                        end
                    elseif (tt == ability.targetType.unit) then
                        local castRadius = ab:castRadius()
                        if (castRadius > 0) then
                            alerter.follow(spellData.targetUnit, ab:castRadius(), dur)
                        end
                    elseif (tt == ability.targetType.circle) then
                        local x, y = spellData.targetX, spellData.targetY
                        alerter.circle(x, y, ab:castRadius(), dur)
                    elseif (tt == ability.targetType.square) then
                        local x, y = spellData.targetX, spellData.targetY
                        alerter.square(x, y, ab:castWidth(), ab:castHeight(), dur)
                    end
                end)
            else
                obj:onEvent(eventKind.unitAbilitySpell, "_alerter", nil)
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _exp = function(obj, _, newVal)
            local lv = obj:get("level") or 0
            if (lv >= 1) then
                local lvn = game.unitExpToLevel(newVal)
                if (lvn ~= lv) then
                    obj:level(lvn)
                end
            end
        end,
        ---@param obj Unit
        ---@param oldVal number
        ---@param newVal number
        _level = function(obj, oldVal, newVal)
            if (type(oldVal) == "number") then
                if (newVal > 1 and newVal > oldVal) then
                    effector.unit("AIemTarget", obj, 0)
                    obj._exp = game.unitExpNeeds(newVal)
                elseif (newVal < oldVal) then
                    effector.unit("DispelMagicTarget", obj, 0)
                    obj._exp = game.unitExpNeeds(newVal)
                end
                event.syncTrigger(obj, eventKind.unitLevelChange, { old = oldVal, new = newVal })
            else
                if (newVal > 1) then
                    obj._exp = game.unitExpNeeds(newVal)
                end
            end
        end,
        ---@param obj Unit
        ---@param oldVal number[] len:4
        ---@param newVal number[] len:4
        _rgba = function(obj, oldVal, newVal)
            if (oldVal) then
                newVal[1] = newVal[1] or oldVal[1]
                newVal[2] = newVal[2] or oldVal[2]
                newVal[3] = newVal[3] or oldVal[3]
                newVal[4] = newVal[4] or oldVal[4]
            end
            J.SetUnitVertexColor(obj._handle, table.unpack(newVal))
        end,
        ---@param obj Unit
        ---@param newVal number
        _move = function(obj, _, newVal)
            newVal = math.min(522, math.max(0, newVal))
            if (obj:isImmovable()) then
                newVal = 0
            end
            J.SetUnitMoveSpeed(obj._handle, newVal)
        end,
        ---@param obj Unit
        ---@param newVal string
        _flyHeight = function(obj, _, newVal)
            local h = obj._handle
            J.UnitAddAbility(h, LK_SLK_ID_ABILITY_FLY)
            J.UnitRemoveAbility(h, LK_SLK_ID_ABILITY_FLY)
            J.SetUnitFlyHeight(h, newVal, 9999)
            J.SetUnitFacing(h, J.GetUnitFacing(h))
            if (newVal > 0) then
                if (obj._moveType == attribute.unitMoveType.foot) then
                    obj:set("moveType", attribute.unitMoveType.fly)
                elseif (obj._moveType == attribute.unitMoveType.amphibious) then
                    obj:set("moveType", attribute.unitMoveType.float)
                end
            else
                if (obj._moveType == attribute.unitMoveType.fly) then
                    obj:set("moveType", attribute.unitMoveType.foot)
                elseif (obj._moveType == attribute.unitMoveType.float) then
                    obj:set("moveType", attribute.unitMoveType.amphibious)
                end
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _sight = function(obj, _, newVal)
            obj._nsight = newVal - obj._sightDiff
            ability.sight(obj, newVal)
        end,
        ---@param obj Unit
        ---@param newVal number
        _nsight = function(obj, _, newVal)
            obj._sight = newVal + obj._sightDiff
            ability.sight(obj, obj._sight)
        end,
        ---@param obj Unit
        ---@param newVal number
        _attackSpace = function(obj, _, newVal)
            japi.YD_SetUnitState(obj._handle, UNIT_STATE_ATTACK_SPACE, newVal)
        end,
        ---@param obj Unit
        ---@param newVal number
        _attackSpaceBase = function(obj, _, newVal)
            local spd = obj:get("attackSpeed") or 0
            if (spd ~= 0) then
                spd = math.max(-80, spd)
                spd = math.min(400, spd)
            end
            obj:set("attackSpace", math.trunc(newVal / (1 + spd * 0.01)))
        end,
        ---@param obj Unit
        ---@param newVal number
        _attackSpeed = function(obj, _, newVal)
            if (newVal ~= 0) then
                newVal = math.max(-80, newVal)
                newVal = math.min(400, newVal)
            end
            obj:set("attackSpace", math.trunc(obj:get("attackSpaceBase") / (1 + newVal * 0.01)))
        end,
        ---@param obj Unit
        ---@param newVal number
        _attackRangeAcquire = function(obj, _, newVal)
            local min = 100 + (obj:get("attackRange") or 0)
            newVal = math.max(min, newVal)
            newVal = math.min(9999, newVal)
            newVal = math.floor(newVal)
            J.SetUnitAcquireRange(obj._handle, newVal)
        end,
        ---@param obj Unit
        ---@param newVal number
        _attackRange = function(obj, _, newVal)
            newVal = math.max(0, newVal)
            newVal = math.min(9999, newVal)
            newVal = math.floor(newVal)
            japi.YD_SetUnitState(obj._handle, UNIT_STATE_ATTACK_RANGE, newVal)
            local ara = obj:get("attackRangeAcquire")
            local min = newVal + 100
            if (nil == ara or ara < min) then
                obj._attackRangeAcquire = min
            end
        end,
        ---@param obj Unit
        ---@param oldVal number
        ---@param newVal number
        _hp = function(obj, oldVal, newVal)
            if (type(oldVal) == "number" and oldVal > 0) then
                local cur = obj:get("hpCur") or newVal
                local percent = math.trunc(cur / oldVal)
                obj:set("hpCur", math.max(1, math.min(1, percent) * newVal))
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _hpCur = function(obj, _, newVal)
            if (newVal <= 0) then
                event.syncTrigger(obj, eventKind.unitBeKill, { sourceUnit = obj._lastHurtSource })
            end
            local hp = obj:get("hp")
            if (nil ~= hp) then
                local v = newVal / hp * 1e4
                J.SetUnitState(obj._handle, UNIT_STATE_LIFE, v)
                if (newVal <= 0) then
                    monitor.ignore("hp_regen", obj)
                    J.KillUnit(obj._handle)
                    return
                end
                local regen = obj:get("hpRegen")
                if (newVal < hp) then
                    if (regen > 0) then
                        monitor.listen("hp_regen", obj)
                    elseif (regen < 0 and newVal > 0) then
                        monitor.listen("hp_regen", obj)
                    else
                        monitor.ignore("hp_regen", obj)
                    end
                else
                    if (regen >= 0) then
                        monitor.ignore("hp_regen", obj)
                    else
                        monitor.listen("hp_regen", obj)
                    end
                end
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _hpRegen = function(obj, _, newVal)
            if (nil ~= newVal and 0 ~= newVal) then
                monitor.listen("hp_regen", obj)
            else
                monitor.ignore("hp_regen", obj)
            end
        end,
        ---@param obj Unit
        ---@param oldVal number
        ---@param newVal number
        _mp = function(obj, oldVal, newVal)
            if (newVal == 0) then
                obj:set("mpCur", 0)
            else
                if (type(oldVal) == "number" and oldVal > 0) then
                    local cur = obj:get("mpCur") or newVal
                    local percent = math.trunc(cur / oldVal)
                    obj:mpCur(math.max(1, math.min(1, percent) * newVal))
                end
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _mpCur = function(obj, _, newVal)
            local mp = obj:get("mp")
            if (nil ~= mp and mp > 0) then
                local v = newVal / mp * 1e4
                J.SetUnitState(obj._handle, UNIT_STATE_MANA, v)
                local regen = obj:get("mpRegen")
                if (newVal < mp) then
                    if (regen > 0) then
                        monitor.listen("mp_regen", obj)
                    elseif (regen < 0 and newVal > 0) then
                        monitor.listen("mp_regen", obj)
                    else
                        monitor.ignore("mp_regen", obj)
                    end
                else
                    if (regen >= 0) then
                        monitor.ignore("mp_regen", obj)
                    else
                        monitor.listen("mp_regen", obj)
                    end
                end
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _mpRegen = function(obj, _, newVal)
            if (nil ~= newVal and 0 ~= newVal) then
                monitor.listen("mp_regen", obj)
            else
                monitor.ignore("mp_regen", obj)
            end
        end,
        ---@param obj Unit
        ---@param newVal Array
        _attach = function(obj, oldVal, newVal)
            if (nil ~= oldVal) then
                effector.clearAttach(obj)
            end
            local at = {}
            if (isArray(newVal)) then
                ---@param e attachEffect
                newVal:forEach(function(_, e)
                    at[#at + 1] = { e._model, e._position, e._duration }
                end)
            end
            if (#at > 0) then
                for _, a in ipairs(at) do
                    effector.attach(obj, a[1], a[2], a[3])
                end
            end
        end,
        ---@param obj Unit
        ---@param newVal number
        _scale = function(obj, _, newVal)
            -- 根据选择圈大小处理纹理大小
            if (nil ~= obj._splatImage) then
                local s = newVal * 128
                obj._splatImage:size(s, s)
            end
        end,
        ---@param obj Unit
        ---@param newVal string
        _splat = function(obj, _, newVal)
            -- 有splat数据的单位的视为建筑，修改_building数据
            if (nil ~= newVal) then
                obj._building = true
                VastModifier(obj, "_building", nil, true)
            end
            -- 处理纹理，纹理大小根据选择圈大小而定
            local s = obj._scale * 128
            if (nil == obj._splatImage) then
                obj._splatImage = Image(newVal, s, s)
            end
            obj._splatImage:texture(newVal)
            obj._splatImage:size(s, s)
            obj._splatImage:position(obj:x(), obj:y())
            obj._splatImage:rgba(255, 255, 255, 110)
            obj._splatImage:show(true)
        end,
    },
}
local modifierKeys = {}
for k, v in pairx(modifier) do
    modifierKeys[k] = {}
    for k2, _ in pairx(v) do
        table.insert(modifierKeys[k], k2)
    end
end

--- Vast对象修改模执行
---@param obj Vast
---@param key string
---@param oldVal any
---@param newVal any
function VastModifier(obj, key, oldVal, newVal)
    local vast = modifier[obj._className]
    if (type(vast) == "table") then
        local call = vast[key]
        if (type(call) == "function") then
            call(obj, oldVal, newVal)
        end
    end
end

--- Vast对象修改模重新执行
---@param obj Vast
---@param keys string[] 需要执行的参数key，可为nil，自动取该类全部可执行keys
---@return void
function VastModifierAct(obj, keys)
    if (nil == keys) then
        keys = modifierKeys[obj._className]
    end
    if (type(keys) == "table") then
        local vast = modifier[obj._className]
        for _, k in ipairs(keys) do
            local call = vast[k]
            if (type(call) == "function") then
                local v = obj:get(k, '')
                if (nil ~= v) then
                    call(obj, v, v)
                end
            end
        end
    end
end