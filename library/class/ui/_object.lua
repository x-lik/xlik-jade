--- 构造UI型Object
---@param params { _key:string, _parent:UI, _fdfName:string, _fdfType:string }
---@param index table
---@return Object|UI
function oUI(params, index)
    must(type(params._key) == "string", "params._key@string")
    ---@type UI
    local o = setmetatable(params, { __index = index, __reality = true })
    -- 由:号(冒号)分割切段字符组时，自动对应kit，如 key 是 xlik_debug 或 xlik_debug:myBar 或 xlik_debug:myBar:3 ，这3种自动对应套件 kit 都是 xlik_debug
    local ks = string.explode(":", params._key)
    if (#ks > 0) then
        o._kit = ks[1]
    end
    --- ID
    class.id(o, true)
    o._tag = japi.UITagIndex()
    o._handle = japi.DZ_CreateFrameByTagName(params._fdfType, o._tag, params._parent._handle, params._fdfName, 0)
    must(type(o._handle) == "number" and o._handle > 0, "DZ_CreateFrameByTagName failed") -- 检测handle
    --- 子UI记录
    if (nil == params._parent._children) then
        params._parent._children = {}
    end
    local child = params._parent._children
    if (nil == child[o._id]) then
        child[o._id] = o
    end
    if (true == params._parent._adaptive) then
        o:adaptive(true)
    end
    --- construct
    do
        local construct
        construct = function(c)
            local super = getmetatable(c)
            if (nil ~= super and nil ~= super.__index) then
                construct(super.__index)
            end
            if rawget(c, "construct") then
                c.construct(o)
            end
        end
        construct(index)
    end
    --- debug
    class.debug(o)
    return o
end