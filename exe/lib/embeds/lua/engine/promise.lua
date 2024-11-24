--- 保证
---@param execute function
---@param fail function
---@param done function
---@vararg any
---@return any
function promise(execute, fail, done, ...)
    if (type(execute) == "function") then
        local r, i = xpcall(execute, LK_ERROR, ...)
        if (true == r) then
            if (type(done) == "function") then
                done()
            end
            return i
        else
            if (type(fail) == "function") then
                fail()
            end
        end
    end
end