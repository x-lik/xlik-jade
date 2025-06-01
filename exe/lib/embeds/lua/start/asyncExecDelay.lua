--- AsyncExecDelay
japi._asyncInc = japi._asyncInc + 1
local eds = japi._asyncExecDelay[japi._asyncInc]
if (nil ~= eds) then
    if (nil ~= eds[localPlayerIndex]) then
        for _, f in pairs(eds[localPlayerIndex]) do
            promise(f)
        end
    end
    japi._asyncExecDelay[japi._asyncInc] = nil
end