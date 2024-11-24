--- 多字节字符串方法
--- 提供了针对多字节字符串的函数，能够处理多字节编码
---@class mbstring 多字节字符串
mbstring = mbstring or {}

--- 计算对一组字符进行编码所产生的字节数
---@param str string
---@param i number
---@return number
function mbstring.byteLen(str, i)
    local b = string.byte(str, i)
    local c = 1
    if b >= 240 and b <= 247 then
        c = 4 -- 4字节字符，汉字，特殊符号等
    elseif b >= 224 and b <= 239 then
        c = 3 -- 3字节字符，汉字等
    elseif b >= 192 and b <= 223 then
        c = 2 -- 2字节字符
    else
        c = 1
    end
    return c
end

--- 获取多字节字符串真实长度
---@param str string
---@return number
function mbstring.len(str)
    local lenInByte = #str
    local width = 0
    local i = 1
    while (i <= lenInByte) do
        local byteLen = mbstring.byteLen(str, i)
        i = i + byteLen -- 重置下一字节的索引
        width = width + 1 -- 字符的个数（长度）
    end
    return width
end

--- 多字节字符串截取
---@param s string
---@param i number
---@param j number
---@return string
function mbstring.sub(s, i, j)
    if (type(i) ~= "number") then
        return s
    end
    if (i < 1) then
        return ''
    end
    if (type(j) == "number") then
        if (j < i) then
            return ''
        end
    else
        j = nil
    end
    local lenInByte = #s
    if (lenInByte <= 0) then
        return ''
    end
    local count = 0
    local s1, s2 = 0, 0
    local k = 1
    while (k <= lenInByte) do
        local byteLen = mbstring.byteLen(s, k)
        count = count + 1 -- 字符的个数（长度）
        if (count == i) then
            s1 = k
        end
        k = k + byteLen -- 下一字节的索引
        if (s1 ~= 0) then
            if (nil == j or j >= lenInByte) then
                s2 = lenInByte
                break
            elseif (j == count) then
                s2 = k - 1
                break
            end
        end
    end
    return string.sub(s, s1, s2)
end

--- 分隔多字节字符串
---@param str string
---@param size number 每隔[size]个字切一次
---@return string[]
function mbstring.split(str, size)
    local sp = {}
    local lenInByte = #str
    if (lenInByte <= 0) then
        return sp
    end
    size = size or 1
    local count = 0
    local i0 = 1
    local i = 1
    while (i <= lenInByte) do
        local byteLen = mbstring.byteLen(str, i)
        count = count + 1 -- 阶段字符的个数（长度）
        i = i + byteLen -- 下一字节的索引
        if (count >= size) then
            table.insert(sp, string.sub(str, i0, i - 1))
            i0 = i
            count = 0
        elseif (i > lenInByte) then
            table.insert(sp, string.sub(str, i0, lenInByte))
        end
    end
    return sp
end