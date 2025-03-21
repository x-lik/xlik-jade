--- #单位 token
slk_unit({
    _xlik = 1,
    _parent = "ogru",
    Name = "LK_UNIT_TOKEN",
    file = ".mdl",
    abilList = "Avul,Aloc",
    special = 1,
    upgrade = "",
    unitShadow = "",
    collision = 0,
    Art = "",
    movetp = "",
    spd = 522,
    turnRate = 3.0,
    moveHeight = 0,
    moveFloor = 0,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 0,
    nsight = 0,
    Builds = "",
    upgrades = "",
    canFlee = 0,
})

--- #单位复活时间圈
slk_unit({
    _xlik = 1,
    _parent = "ogru",
    Name = "LK_UNIT_TOKEN_REBORN",
    file = "Framework\\clockRune.mdl",
    abilList = "Avul,Aloc",
    special = 1,
    upgrade = "",
    unitShadow = "",
    collision = 0,
    Art = "",
    modelScale = 1.00,
    movetp = "",
    moveHeight = 30,
    moveFloor = 30,
    spd = 0,
    turnRate = 0,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 250,
    nsight = 250,
    Builds = "",
    upgrades = "",
    maxPitch = 0,
    maxRoll = 0,
    canFlee = 0,
})

--- #模板扎根
slk_ability({
    _parent = "Aro2",
    Name = "LK_ZG",
    Buttonpos_1 = 0,
    Buttonpos_2 = -11,
    UnButtonpos_1 = 0,
    UnButtonpos_2 = -11,
    DataA = { 3 },
    DataC = { 1 },
})

-- #隐身
slk_ability({
    _parent = "Apiv",
    Name = "LK_ABILITY_INVISIBLE",
    Tip = "隐身",
    Ubertip = "隐身",
    Art = "",
    hero = 0,
    race = "other",
    DataA = { 0 },
    Dur = { 0 },
    HeroDur = { 0 },
})

--- #视野
local sights = { 1, 2, 3, 4, 5 }
local i = 1
while (i <= 1000) do
    for _, v in ipairs(sights) do
        v = math.floor(v * i)
        -- #视野+
        slk_ability({
            _parent = "AIsi",
            Name = "LK_ABILITY_SIGHT_ADD_" .. v,
            Art = "",
            levels = 1,
            DataA = { 1 * v },
        })
        -- #视野-
        slk_ability({
            _parent = "AIsi",
            Name = "LK_ABILITY_SIGHT_SUB_" .. v,
            Art = "",
            levels = 1,
            DataA = { -1 * v },
        })
    end
    i = i * 10
end

-- #反隐
for j = 1, 20, 1 do
    local v = math.floor(100 * j)
    slk_ability({
        _parent = "Adts",
        Name = "LK_ABILITY_VISIBLE_" .. v,
        Art = "",
        race = "other",
        checkDep = 0,
        Requires = "",
        CasterArt = "",
        Casterattach = "",
        Rng = v,
    })
end