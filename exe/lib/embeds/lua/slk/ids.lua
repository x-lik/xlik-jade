--- 单位token
LK_SLK_ID_UNIT_TOKEN = J.C2I(slk.n2i("LK_UNIT_TOKEN"))
--- 复活时间圈
LK_SLK_ID_UNIT_TOKEN_REBORN = J.C2I(slk.n2i("LK_UNIT_TOKEN_REBORN"))
-- 扎根技能
LK_SLK_ID_ABILITY_ZG = J.C2I(slk.n2i("LK_ZG"))
-- 默认无敌技能
LK_SLK_ID_ABILITY_INVULNERABLE = J.C2I("Avul")
-- 蝗虫技能
LK_SLK_ID_ABILITY_LOCUST = J.C2I("Aloc")
-- 风暴之鸦技能
LK_SLK_ID_ABILITY_FLY = J.C2I("Arav")
-- 无敌技能
LK_SLK_ID_ABILITY_INVISIBLE = J.C2I(slk.n2i("LK_ABILITY_INVISIBLE"))
-- 视野ADD范围组技能
LK_SLK_ID_SIGHT_ADD = {}
-- 视野SUB范围组技能
LK_SLK_ID_SIGHT_SUB = {}
-- 视野范围子值MAP
LK_SLK_ID_SIGHT_MAP = {}
local sights = { 1, 2, 3, 4, 5 }
local si = 1
while (si <= 1000) do
    for _, v in ipairs(sights) do
        v = math.floor(v * si)
        table.insert(LK_SLK_ID_SIGHT_MAP, v)
        LK_SLK_ID_SIGHT_ADD[v] = J.C2I(slk.n2i("LK_ABILITY_SIGHT_ADD_" .. v))
        LK_SLK_ID_SIGHT_SUB[v] = J.C2I(slk.n2i("LK_ABILITY_SIGHT_SUB_" .. v))
    end
    si = si * 10
end
table.sort(LK_SLK_ID_SIGHT_MAP, function(a, b)
    return a > b
end)
-- 反隐组技能
LK_SLK_ID_VISIBLE = {}
for j = 20, 1, -1 do
    local v = math.floor(100 * j)
    table.insert(LK_SLK_ID_VISIBLE, { v, J.C2I(slk.n2i("LK_ABILITY_VISIBLE_" .. v)) })
end