--- AsyncExec
if (nil ~= japi._asyncExec[player.localIndex]) then
    for _, f in ipairs(japi._asyncExec[player.localIndex]) do
        async._id = player.localIndex
        promise(f)
        async._id = 0
    end
end
japi._asyncExec = {}