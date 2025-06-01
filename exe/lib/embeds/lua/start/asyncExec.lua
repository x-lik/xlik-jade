--- AsyncExec
if (nil ~= japi._asyncExec[localPlayerIndex]) then
    for _, f in ipairs(japi._asyncExec[localPlayerIndex]) do
        promise(f)
    end
end
japi._asyncExec = {}