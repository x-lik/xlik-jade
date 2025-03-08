local inc = 1

LK_SLK_I2V = {}
LK_SLK_N2I = {}
LK_GO_IDS = {}
LK_MAP_NAME = '(name)'

-- 用于反向补充slk优化造成的数据丢失问题
-- 如你遇到slk优化后（dist后）地图忽然报错问题，则有可能是优化丢失
LK_SLK_FIX = {
    ability = {},
    unit = { "sight", "nsight" },
    item = {},
    destructable = {},
    doodad = {},
    buff = {},
    upgrade = {},
}

-- setting
function LK_SETTING(_v)
    _v._id = LK_GO_IDS[inc]
    local id = _v._id
    local data = _v
    LK_SLK_I2V[id] = data[id] or {}
    LK_SLK_I2V[id]._type = LK_SLK_I2V[id]._type or "slk"
    if (nil ~= J.Slk["unit"][id]) then
        LK_SLK_I2V[id].slk = setmetatable({}, { __index = J.Slk["unit"][id] })
        for _, f in ipairs(LK_SLK_FIX.unit) do
            if (nil == LK_SLK_I2V[id].slk[f]) then
                LK_SLK_I2V[id].slk[f] = LK_SLK_I2V[id][f] or 0
            end
        end
    elseif (nil ~= J.Slk["ability"][id]) then
        LK_SLK_I2V[id].slk = setmetatable({}, { __index = J.Slk["ability"][id] })
        for _, f in ipairs(LK_SLK_FIX.ability) do
            if (nil == LK_SLK_I2V[id].slk[f]) then
                LK_SLK_I2V[id].slk[f] = LK_SLK_I2V[id][f] or 0
            end
        end
    elseif (nil ~= J.Slk["item"][id]) then
        LK_SLK_I2V[id].slk = setmetatable({}, { __index = J.Slk["item"][id] })
        for _, f in ipairs(LK_SLK_FIX.item) do
            if (nil == LK_SLK_I2V[id].slk[f]) then
                LK_SLK_I2V[id].slk[f] = LK_SLK_I2V[id][f] or 0
            end
        end
    elseif (nil ~= J.Slk["destructable"][id]) then
        LK_SLK_I2V[id].slk = setmetatable({}, { __index = J.Slk["destructable"][id] })
        for _, f in ipairs(LK_SLK_FIX.destructable) do
            if (nil == LK_SLK_I2V[id].slk[f]) then
                LK_SLK_I2V[id].slk[f] = LK_SLK_I2V[id][f] or 0
            end
        end
    elseif (nil ~= J.Slk["doodad"][id]) then
        LK_SLK_I2V[id].slk = setmetatable({}, { __index = J.Slk["doodad"][id] })
        for _, f in ipairs(LK_SLK_FIX.doodad) do
            if (nil == LK_SLK_I2V[id].slk[f]) then
                LK_SLK_I2V[id].slk[f] = LK_SLK_I2V[id][f] or 0
            end
        end
    elseif (nil ~= J.Slk["buff"][id]) then
        LK_SLK_I2V[id].slk = setmetatable({}, { __index = J.Slk["buff"][id] })
        for _, f in ipairs(LK_SLK_FIX.buff) do
            if (nil == LK_SLK_I2V[id].slk[f]) then
                LK_SLK_I2V[id].slk[f] = LK_SLK_I2V[id][f] or 0
            end
        end
    elseif (nil ~= J.Slk["upgrade"][id]) then
        LK_SLK_I2V[id].slk = setmetatable({}, { __index = J.Slk["upgrade"][id] })
        for _, f in ipairs(LK_SLK_FIX.upgrade) do
            if (nil == LK_SLK_I2V[id].slk[f]) then
                LK_SLK_I2V[id].slk[f] = LK_SLK_I2V[id][f] or 0
            end
        end
    end
    if (LK_SLK_I2V[id].slk) then
        local n = LK_SLK_I2V[id].slk.Name
        if (nil ~= n) then
            if (nil == LK_SLK_N2I[n]) then
                LK_SLK_N2I[n] = {}
            end
            table.insert(LK_SLK_N2I[n], id)
        end
    end
    inc = inc + 1
end

-- assets init
function LK_ASSETS_INIT()
---lk:placeholder assets
end