--- 返回数据类型字符串
--- 与原生type方法有所差异：
--- 对 number 类型进行拓展，整型返回integer，浮点数返回float
--- 对 string 类型拓展，数字形字符串返回string_numeric
--- 对 function 类型拓展，由C语言实现的函数返回function_c，lua实现的返回function_lua
--- 对 table 类型拓展，当有_type值时该_type值，如Meta|UI|Vast
--- 对 thread 类型拓展，协程时返回thread_coroutine
---@param v any
---@return string
function typeof(v)
    local to = type(v)
    if to == "number" then
        if v == math.floor(v) then
            return "integer"
        else
            return "float"
        end
    elseif to == "string" then
        if tonumber(v) then
            return "string_numeric"
        end
    elseif to == "function" then
        if debug.getinfo(v, "S").what == "C" then
            return "function_c"
        else
            return "function_lua"
        end
    elseif to == "table" then
        if nil ~= v._type then
            return v._type
        end
    elseif to == "thread" then
        local s = coroutine.status(v)
        if nil ~= s and (s == "suspended" or s == "running" or s == "normal" or s == "dead") then
            return "thread_coroutine"
        end
    end
    return to
end