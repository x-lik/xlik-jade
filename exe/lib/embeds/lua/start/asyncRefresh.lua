--- AsyncRefresh
for _, re in pairs(japi._asyncRefresh) do
    promise(re)
end