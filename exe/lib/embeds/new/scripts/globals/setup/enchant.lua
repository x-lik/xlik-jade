--- 方便伤害类型引用
---@alias damageTypeSetter {value:string,label:string}

---@type damageTypeSetter
injury.damageType.fire = nil
---@type damageTypeSetter
injury.damageType.rock = nil
---@type damageTypeSetter
injury.damageType.water = nil
---@type damageTypeSetter
injury.damageType.ice = nil
---@type damageTypeSetter
injury.damageType.wind = nil
---@type damageTypeSetter
injury.damageType.light = nil
---@type damageTypeSetter
injury.damageType.dark = nil
---@type damageTypeSetter
injury.damageType.grass = nil
---@type damageTypeSetter
injury.damageType.thunder = nil
---@type damageTypeSetter
injury.damageType.poison = nil
---@type damageTypeSetter
injury.damageType.steel = nil

-- 附魔设定
local fire = Enchant("fire", "火")
fire:setEffect("origin", "BreathOfFireDamage")
Enchant("rock", "岩")
Enchant("water", "水")
Enchant("ice", "冰")
Enchant("wind", "风")
Enchant("light", "光")
Enchant("dark", "暗")
Enchant("grass", "草")
Enchant("thunder", "雷")
Enchant("poison", "毒")
Enchant("steel", "钢")