--- 分隔字符串
---@param str string
---@param size number 每隔[size]字符切一次
---@return string
function string.split(str, size)
    local sp = {}
    local len = string.len(str)
    if (len <= 0) then
        return sp
    end
    size = size or 1
    local i = 1
    while (i <= len) do
        table.insert(sp, string.sub(str, i, i + size - 1))
        i = i + size
    end
    return sp
end

--- 把字符串以分隔符打散为数组
---@param delimeter string
---@param str string
---@return string[]
function string.explode(delimeter, str)
    if (delimeter == '') then
        return string.split(str, 1)
    end
    local res = {}
    local s, a, b = 1, 1, 1
    while true do
        a, b = string.find(str, delimeter, s, true)
        if not a then
            break
        end
        table.insert(res, string.sub(str, s, a - 1))
        s = b + 1
    end
    table.insert(res, string.sub(str, s))
    return res
end

--- 移除字符串两侧的空白字符或其他预定义字符
---@param str string
---@return string
function string.trim(str)
    local res = string.gsub(str, "^%s*(.-)%s*$", "%1")
    return res
end

--- 获取一个table的正确长度
---@param table table
---@return number
function table.len(table)
    local len = 0
    for _, _ in pairs(table) do
        len = len + 1
    end
    return len
end

--- 在数组内
---@param arr table
---@param val any
---@return boolean
function table.includes(arr, val)
    local isIn = false
    if (nil == val or #arr <= 0) then
        return isIn
    end
    for _, v in ipairs(arr) do
        if (v == val) then
            isIn = true
            break
        end
    end
    return isIn
end

--- 合并table
---@vararg table
---@return table
function table.merge(...)
    local temp = {}
    local tables = { ... }
    if (nil == tables) then
        return temp
    end
    for _, tn in ipairs(tables) do
        if (type(tn) == "table") then
            for k, v in pairs(tn) do
                temp[k] = v
            end
        end
    end
    return temp
end

--- 四舍五入取整
---@param decimal number
---@return number integer
function math.round(decimal)
    return math.floor(decimal + 0.5)
end

--- 打印栈
function stack()
    print(debug.traceback('', 2))
end

--- 输出详尽内容
---@param value any 输出的table
---@param description string 调试信息格式
---@param nesting number 输出时的嵌套层级，默认为 10
function dump(value, description, nesting)
    if type(nesting) ~= 'number' then nesting = 10 end
    local lookup = {}
    local result = {}
    local traceback = string.explode('\n', debug.traceback('', 2))
    local str = '- dump from: ' .. string.trim(traceback[3])
    local _format = function(v)
        if type(v) == 'string' then
            v = '\'' .. v .. '\''
        end
        return tostring(v)
    end
    local _dump
    _dump = function(val, desc, indent, nest, keyLen)
        desc = desc or '<var>'
        local spc = ''
        if type(keyLen) == 'number' then
            spc = string.rep(' ', keyLen - string.len(_format(desc)))
        end
        if type(val) ~= 'table' then
            result[#result + 1] = string.format('%s%s%s = %s', indent, _format(desc), spc, _format(val))
        elseif lookup[tostring(val)] then
            result[#result + 1] = string.format('%s%s%s = *REF*', indent, _format(desc), spc)
        else
            lookup[tostring(val)] = true
            if nest > nesting then
                result[#result + 1] = string.format('%s%s = *MAX NESTING*', indent, _format(desc))
            else
                result[#result + 1] = string.format('%s%s = {', indent, _format(desc))
                local indent2 = indent .. '    '
                local keys = {}
                local kl = 0
                local values = {}
                for k, v in pairs(val) do
                    if k ~= '___message' then
                        keys[#keys + 1] = k
                        local vk = _format(k)
                        local vkl = string.len(vk)
                        if vkl > kl then kl = vkl end
                        values[k] = v
                    end
                end
                table.sort(keys, function(a, b)
                    if type(a) == 'number' and type(b) == 'number' then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, kl)
                end
                result[#result + 1] = string.format('%s}', indent)
            end
        end
    end
    _dump(value, description, ' ', 1)
    str = str .. '\n' .. table.concat(result, '\n')
    print(str)
end

---@generic K, V
---@param t table<K, V>|V[]
---@return fun(tbl: table<K, V>):K, V
function pairx(t)
    local sx = {}
    for k in pairs(t) do
        sx[#sx + 1] = k
    end
    table.sort(sx)
    local i = 0
    return function()
        i = i + 1
        return sx[i], t[sx[i]]
    end
end