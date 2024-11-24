--- AsyncExecDelay
japi._asyncInc = japi._asyncInc + 1
local eds = japi._asyncExecDelay[japi._asyncInc]
if (nil ~= eds) then
    if (nil ~= eds[player.localIndex]) then
        for _, f in pairs(eds[player.localIndex]) do
            async._id = player.localIndex
            promise(f)
            async._id = 0
        end
    end
    japi._asyncExecDelay[japi._asyncInc] = nil
end