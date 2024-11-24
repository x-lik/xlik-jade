---@generic K, V
---@param t table<K, V>|V[]
---@return fun(tbl: table<K, V>):K, V
function pairx(t)
    local sx = {}
    for k in pairs(t) do
        sx[#sx + 1] = k
    end
    table.sort(sx)
    local i = 0
    return function()
        i = i + 1
        return sx[i], t[sx[i]]
    end
end