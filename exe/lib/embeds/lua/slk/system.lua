--- #单位 token
slk_unit({ _parent = "ogru" })

--- #单位复活时间圈
slk_unit({ _parent = "ogru" })

--- #模板扎根
slk_ability({ _parent = "Aro2" })

-- #隐身
slk_ability({ _parent = "Apiv" })

--- #回避(伤害)+
slk_ability({ _parent = "AIlf" })
--- #回避(伤害)-
slk_ability({ _parent = "AIlf" })

--- #视野
local sightBase = { 1, 2, 3, 4, 5 }
local i = 1
while (i <= 1000) do
    for _ = 1, #sightBase do
        -- #视野+|-
        slk_ability({ _parent = "AIsi" })
        slk_ability({ _parent = "AIsi" })
    end
    i = i * 10
end

-- #反隐
for _ = 1, 20, 1 do
    slk_ability({ _parent = "Adts" })
end
