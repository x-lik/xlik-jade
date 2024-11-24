local _____ = {}
function ___(w)
    if (nil == _____[w]) then
        local n = {}
        local st, sp, ep, en = 1, 1, 1, 22
        local sl = string.sub(w, 1, en)
        local sw = string.sub(w, en + 1)
        while true do
            sp, ep = string.find(sw, sl, st, true)
            if not sp then
                break
            end
            table.insert(n, string.sub(sw, st, sp - 1))
            st = ep + 1
        end
        table.insert(n, string.sub(sw, st))
        local s = ''
        for i = #n, 1, -1 do
            local nn = string.reverse(n[i])
            while true do
                if (nil == ____[nn]) then
                    s = s .. nn
                    break
                else
                    nn = ____[nn]
                end
            end
        end
        _____[w] = s
    end
    return _____[w]
end