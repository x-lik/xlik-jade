--- AsyncRefresh
for _, re in pairs(japi._asyncRefresh) do
    async._id = player.localIndex
    promise(re)
    async._id = 0
end