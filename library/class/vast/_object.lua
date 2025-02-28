--- 构造Vast型Object
---@param params table
---@vararg table
---@return Object|Vast
function oVast(params, ...)
    sync.must()
    local indexes = { ... }
    must(#indexes > 0, "{...} index metatable missing")
    local o = params
    if (#indexes == 1) then
        setmetatable(o, { __index = indexes[1], __reality = true })
    else
        setmetatable(o, {
            __reality = true,
            __indexes = indexes,
            __index = function(_, key)
                local v = nil
                for _, es in ipairs(indexes) do
                    v = es[key]
                    if (nil ~= v) then
                        break
                    end
                end
                return v
            end
        })
    end
    --- ID
    class.id(o, true)
    --- construct
    do
        local construct = nil
        construct = function(c)
            local super = getmetatable(c)
            if type(super) == "table" then
                if super.__indexes then
                    for i = #super.__indexes, 1, -1 do
                        construct(super.__indexes[i])
                    end
                elseif super.__index then
                    construct(super.__index)
                end
            end
            if rawget(c, "construct") then
                c.construct(o)
                event.syncTrigger(c._className, eventKind.classConstruct, { triggerObject = o })
            end
        end
        construct(o)
    end
    --- debug
    class.debug(o)
    return o
end