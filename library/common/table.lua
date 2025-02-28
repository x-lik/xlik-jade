--- 表方法，提供了一些常见通用的表处理方法

--- 生成整数段
--- 如果 n2 == n1 或 n2 == nil，生成1到n1的整数段
--- 如果 n1 > n2，生成倒序整数段
---@param n1 number integer
---@param n2 number integer
---@return number[]
function table.section(n1, n2)
    n1 = math.floor(n1)
    n2 = math.floor(n2 or n1)
    local s = {}
    if (n1 == n2) then
        n2 = nil
    end
    if (nil == n2) then
        for i = 1, n1 do
            table.insert(s, i)
        end
    else
        if (n1 < n2) then
            for i = n1, n2, 1 do
                table.insert(s, i)
            end
        else
            for i = n1, n2, -1 do
                table.insert(s, i)
            end
        end
    end
    return s
end

--- 随机在数组内取N个
--- 如果 n == 1, 则返回某值
--- 如果 n > 1, 则返回table
---@param arr any[]
---@return nil|any|any[]
function table.rand(arr, n)
    if (type(arr) ~= "table") then
        return
    end
    n = n or 1
    if (n < 1) then
        return
    end
    if (n == 1) then
        return arr[math.rand(1, #arr)]
    end
    local res = {}
    local l = #arr
    while (#res < n) do
        local rge = {}
        for i = 1, l do
            rge[i] = arr[i]
        end
        for i = 1, l do
            local j = math.rand(i, #rge)
            table.insert(res, rge[j])
            if (#res >= n) then
                break
            end
            rge[i], rge[j] = rge[j], rge[i]
        end
    end
    return res
end

--- 洗牌
---@param arr any[]
---@return any[]
function table.shuffle(arr)
    local result = table.clone(arr)
    local length = #result
    local times = length
    local temp = nil
    local random = nil
    while (times > 1) do
        random = math.rand(1, length)
        temp = result[times]
        result[times] = result[random]
        result[random] = temp
        times = times - 1
    end
    return result
end

--- 倒序
---@param arr any[]
---@return any[]
function table.reverse(arr)
    local r = {}
    for i = #arr, 1, -1 do
        if (type(arr[i]) == "table") then
            table.insert(r, table.reverse(arr[i]))
        else
            table.insert(r, arr[i])
        end
    end
    return r
end

--- 去重table
---@param arr any[]
---@return any[]
function table.unique(arr)
    if (type(arr) ~= "table") then
        return arr
    end
    local r = {}
    local uni = {}
    for _, value in ipairs(arr) do
        if (nil == uni[value]) then
            uni[value] = true
            r[#r + 1] = value
        end
    end
    return r
end

--- 重复table
---@param params any
---@param times number integer
---@return any[]
function table.repeater(params, times)
    times = math.floor(times or 1)
    local r = {}
    for _ = 1, times do
        r[#r + 1] = params
    end
    return r
end

--- 克隆table
---@param arr any[]
---@return any[]
function table.clone(arr)
    local function _cp(arr2, res)
        local max = #arr2
        for k = 1, max, 1 do
            if type(arr2[k]) ~= "table" then
                res[k] = arr2[k]
            else
                res[k] = {}
                _cp(arr2[k], res[k])
            end
        end
    end
    local res = {}
    _cp(arr, res)
    return res
end

--- 合并table
---@vararg any[]
---@return any[]
function table.merge(...)
    local tempTable = {}
    local tables = { ... }
    if (nil == tables) then
        return {}
    end
    for _, tn in ipairs(tables) do
        if (type(tn) == "table") then
            if (nil == J.Common) then
                for k, v in pairs(tn) do
                    tempTable[k] = v
                end
            else
                for _, v in ipairs(tn) do
                    tempTable[#tempTable + 1] = v
                end
            end
        end
    end
    return tempTable
end

--- 在数组内
---@param arr any[]
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

--- 删除数组一次某个值(qty次,默认删除全部)
---@param arr any[]
---@param val any
---@param qty number
function table.delete(arr, val, qty)
    qty = qty or -1
    local q = 0
    for k, v in ipairs(arr) do
        if (v == val) then
            q = q + 1
            table.remove(arr, k)
            k = k - 1
            if (qty ~= -1 and q >= qty) then
                break
            end
        end
    end
end

--- 根据key从数组table返回一个对应值的数组
---@param arr any[]
---@param key string
---@return table
function table.value(arr, key)
    local values = {}
    if (nil ~= arr and nil ~= key and #arr > 0) then
        for _, v in ipairs(arr) do
            if (nil ~= v[key]) then
                values[#values + 1] = v[key]
            end
        end
    end
    return values
end

--- 比较两个数组是否相同（地址可以不同，数据相同）
---@param arr1 any[]
---@param arr2 any[]
---@return boolean
function table.equal(arr1, arr2)
    if (nil == arr1 and nil == arr2) then
        return true
    end
    if (nil == arr1 or nil == arr2) then
        return false
    end
    if (type(arr1) == "table" and type(arr2) == "table") then
        if (#arr1 ~= #arr2) then
            return false
        end
        if (#arr1 == 0) then
            return arr1 == arr2
        end
        local res = true
        if (nil ~= arr1._id or nil ~= arr2._id) then
            res = arr1._id == arr2._id
        else
            for i, v in ipairs(arr1) do
                if (type(v) == "table") then
                    res = table.equal(v, arr2[i])
                else
                    res = (v == arr2[i])
                end
                if (false == res) then
                    break
                end
            end
        end
        return res
    end
    return false
end

--- 计算数组平均数，如果某值不是number，会先强制转换，失败以0计算
---@param arr number[]
---@return number
function table.average(arr)
    if (type(arr) ~= "table" or #arr == 0) then
        return 0
    end
    local avg = 0
    local aci = 0
    for _, v in ipairs(arr) do
        if (type(v) ~= "number") then
            v = tonumber(v, 10)
            if (nil == v) then
                v = 0
            end
        end
        avg = avg + v
        aci = aci + 1
    end
    return avg / aci
end

--- 数组轮序偏移
---@param arr any[]
---@param offset number
---@return any[]
function table.wheel(arr, offset)
    offset = offset or 0
    if (type(arr) ~= "table") then
        return {}
    end
    local l = #arr
    if (l == 0) then
        return {}
    end
    local s = offset % l
    if (s < 0) then
        s = s + l
    end
    local new = {}
    for i = 1, l do
        s = s + 1
        if (s > l) then
            s = 1
        end
        new[i] = arr[s]
    end
    return new
end

--- 数组切片
---@param arr any[]
---@param i number 起始索引
---@param j number 终止索引，当j小于i时将反向切片
---@return any[]
function table.slice(arr, i, j)
    if (type(arr) ~= "table" or type(i) ~= "number" or type(j) ~= "number") then
        return {}
    end
    local l = #arr
    if (l == 0) then
        return {}
    end
    local slice = {}
    if (i < j) then
        for k = i, j, 1 do
            slice[#slice + 1] = arr[k]
        end
    elseif (i > j) then
        for k = i, j, -1 do
            slice[#slice + 1] = arr[k]
        end
    end
    return slice
end