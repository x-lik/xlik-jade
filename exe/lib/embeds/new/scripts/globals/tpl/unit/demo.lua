--- 单位例子
TPL_UNIT.DEMO = UnitTpl("Footman", "avatar")
    :preAbility({ TPL_ABILITY.DEMO2 })
    :preItem({ TPL_ITEM.DEMO })
    :name("步兵")
    :model("Footman")
    :weaponSound("metal_slice_medium")
    :move(200)
    :attack(10)
    :hp(150)
    :hpRegen(3)
    :reborn(3)

--- 单位敌人
TPL_UNIT.DEMO2 = UnitTpl("Knight", "avatar")
    :name("骑士")
    :model("Knight")
    :weaponSound("metal_slice_medium")
    :move(200)
    :attack(20)
    :hp(2000)

--- 无语音单位
TPL_UNIT.DEMO3 = UnitTpl()

--- 固定不可移动型单位
TPL_UNIT.DEMO4 = UnitTpl(nil, "immovable"):model("Rifleman")

--- 建筑型单位
TPL_UNIT.DEMO5 = UnitTpl(nil, "building"):model("MortarTeam")