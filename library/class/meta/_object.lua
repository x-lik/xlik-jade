--- 构造Meta型Object
---@param params table
---@param index table
---@return Object|Meta
function oMeta(params, index)
    local o = setmetatable(params, { __index = index, __reality = true })
    class.debug(o)
    return o
end