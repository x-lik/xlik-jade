---@private
---@param _v slkUnitData
function slk_unit(_v)
    _v._class = "unit"
    if (nil == _v._parent) then
        _v._parent = "nfrp"
    end
    if (1 == _v._xlik) then
        _v.goldcost = 0
        _v.lumbercost = 0
        _v.fmade = 0
        _v.fused = 0
        _v.regenMana = 0
        _v.regenHP = 0
        _v.regenType = "none"
        _v.tilesets = "*"
        _v.sides1 = 1
        _v.dice1 = 1
        _v.def = 0
        _v.HP = 1e4
        _v.manaN = 1e4
        _v.defType = "large"
        _v.Art = _v.Art or "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
        _v.unitSound = _v.unitSound or ""
        _v.unitShadow = _v.unitShadow or "ShadowFlyer"
        _v.scale = _v.scale or 1.00
        _v.dmgpt1 = _v.dmgpt1 or 0.3
        _v.backSw1 = _v.backSw1 or 0.3
        _v.castpt = _v.castpt or 0.1
        _v.castbsw = _v.castbsw or 0.1
        _v.targs1 = _v.targs1 or "vulnerable,ground,structure,organic,air" --攻击目标
        _v.movetp = _v.movetp or "foot"
        _v.moveHeight = _v.moveHeight or 0
        _v.spd = _v.spd or 1
        _v.turnRate = _v.turnRate or 3.0
        _v.rangeN1 = _v.rangeN1 or 100
        _v.acquire = _v.acquire or math.max(600, (_v.rangeN1 + 100))
        _v.dmgplus1 = _v.dmgplus1 or 1
        _v.cool1 = _v.cool1 or 2.0
        _v.race = _v.race or "other"
        _v.sight = _v.sight or 1500
        _v.nsight = _v.nsight or 1000
        _v.weapsOn = _v.weapsOn or 1
        _v.collision = _v.collision or 32
        if (nil == _v.abilList) then
            _v.abilList = ""
        else
            _v.abilList = _v.abilList
        end
        if (_v.weapsOn == 1) then
            _v.weapTp1 = "instant"
            _v.weapType1 = "" -- 攻击声音
            _v.Missileart_1 = "" -- 箭矢模型
            _v.Missilespeed_1 = 99999 -- 箭矢速度
            _v.Missilearc_1 = 0
        else
            _v.weapTp1 = ""
            _v.weapType1 = ""
            _v.Missileart_1 = ""
            _v.Missilespeed_1 = 0
            _v.Missilearc_1 = 0
        end
    end
    _v._id = SLK_CREATE_ID(_v)
    GO_SLK_SET(_v)
    return _v
end

---@private
---@param _v slkItemData
function slk_item(_v)
    _v._class = "item"
    if (nil == _v._parent) then
        _v._parent = "rat9"
    end
    _v._id = SLK_CREATE_ID(_v)
    GO_SLK_SET(_v)
    return _v
end

---@private
---@param _v slkAbilityData
function slk_ability(_v)
    _v._class = "ability"
    if (nil == _v._parent) then
        _v._parent = "ANcl"
    end
    _v._id = SLK_CREATE_ID(_v)
    GO_SLK_SET(_v)
    return _v
end

---@private
---@param _v slkDestructableData
function slk_destructable(_v)
    _v._class = "destructable"
    if (nil == _v._parent) then
        _v._parent = "BTsc"
    end
    _v._id = SLK_CREATE_ID(_v)
    GO_SLK_SET(_v)
    return _v
end

---@private
---@param _v slkDoodadData
function slk_doodad(_v)
    _v._class = "doodad"
    if (nil == _v._parent) then
        _v._parent = "AOgs"
    end
    _v._id = SLK_CREATE_ID(_v)
    GO_SLK_SET(_v)
    return _v
end

---@private
---@param _v slkBuffData
function slk_buff(_v)
    _v._class = "buff"
    if (nil == _v._parent) then
        _v._parent = "BHbd"
    end
    _v._id = SLK_CREATE_ID(_v)
    GO_SLK_SET(_v)
    return _v
end

---@private
---@param _v slkUpgradeData
function slk_upgrade(_v)
    _v._class = "upgrade"
    if (nil == _v._parent) then
        _v._parent = "Rhme"
    end
    _v._id = SLK_CREATE_ID(_v)
    GO_SLK_SET(_v)
    return _v
end