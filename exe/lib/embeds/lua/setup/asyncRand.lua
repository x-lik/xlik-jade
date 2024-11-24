--- 异步随机池
function LK_ASYNC_RAND(min, max)
    min = math.ceil(min)
    max = math.ceil(max)
    if (min == max) then
        return
    end
    if (min > max) then
        min, max = max, min
    end
    local t = table.section(min, max)
    local m = min .. '_' .. max
    for i = 1, BJ_MAX_PLAYER_SLOTS do
        japi._asyncRandPool.d[i][m] = table.rand(t, #t)
        japi._asyncRandPool.i[i][m] = math.rand(1, #japi._asyncRandPool.d[i][m])
    end
end
game.onPhase("process", function()
    ---lk:placeholder asyncRand
end)