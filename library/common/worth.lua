--- 价值财物处理方法
--- 可自定义货币系统
---@class worth 价值财物操作
worth = worth or {}

---@type Array
worth._rule = worth._rule or nil
---@type Array
worth._convert = worth._convert or nil

--- 获取游戏财物规则
---@param key string
---@return Array|number
function worth.get(key)
    if (nil == worth._rule) then
        sync.must()
        worth._rule = Array()
    end
    if (nil == key) then
        return worth._rule
    end
    return worth._rule:get(key)
end

--- 配置游戏财物规则
--- example1: worth.set("lumber","木头",{"gold",1000000})
--- example2: worth.set("gold","黄金")
---@param key string 财物key
---@param name string 财物名词
---@param convert table 等价物
---@return void
function worth.set(key, name, convert)
    sync.must()
    local rule = worth.get()
    if (nil ~= key and nil ~= name) then
        rule:set(key, { name = name, convert = convert })
        -- set时自动填补转换机制
        -- 机制根据所有规则分析而来，故需清空重新计算
        local cov = Array()
        rule:forEach(function(k, v)
            if (nil ~= v.convert) then
                cov:set(v.convert[1], { k, v.convert[2] })
            end
        end)
        worth._convert = cov
    end
end

--- 获取游戏财物转化规则
---@param key string
---@return Array|table
function worth.convert(key)
    local cov = worth._convert
    must(nil ~= cov, "worth convert rules missing, please use worth.set()")
    if (nil == key) then
        return cov
    end
    return cov:get(key)
end

--- 游戏财物换算（Upper 2 Lower）
--- 将上级财物尽可能地换算为下级财物单位
--- data = { gold = 1,silver = 1,copper = 0}
--- 得到 { gold = 0, silver = 0, copper = 10100 }
---@param data table
---@return table
function worth.u2l(data)
    local turn = {}
    if (type(data) == "table") then
        local cvt = worth.convert()
        local rule = worth.get()
        local rev = {}
        rule:forEach(function(key, _)
            local value = cvt:get(key)
            if (value) then
                rev[value[1]] = { key, value[2] }
                turn[key] = data[key] or 0
            else
                turn[key] = data[key]
            end
        end)
        local keys = rule:keys()
        local run = true
        while (run) do
            local count = 0
            for _, k in ipairs(keys) do
                if (nil ~= rev[k]) then
                    if (nil == turn[rev[k][1]]) then
                        turn[rev[k][1]] = 0
                    end
                    if (nil ~= turn[k] and 0 ~= turn[k]) then
                        turn[rev[k][1]] = turn[rev[k][1]] + turn[k] * rev[k][2]
                        turn[k] = 0
                        count = count + 1
                    end
                end
            end
            run = (count > 0)
        end
    end
    return turn
end

--- 游戏财物换算（Lower 2 Upper）
--- 将下级财物尽可能地换算为上级财物单位
--- data = { copper = 10100}
--- 得到 { gold = 1,silver = 1,copper = 0}
---@param data table
---@return table
function worth.l2u(data)
    local turn = {}
    if (type(data) == "table") then
        local cvt = worth.convert()
        local rule = worth.get()
        local rev = {}
        rule:forEach(function(key, _)
            local value = cvt:get(key)
            if (value) then
                rev[key] = { value[1], value[2] }
                turn[key] = data[key] or 0
            else
                turn[key] = data[key]
            end
        end)
        local keys = rule:keys()
        local run = true
        while (run) do
            local count = 0
            for _, k in ipairs(keys) do
                if (nil ~= rev[k]) then
                    for i = 10, 0, -1 do
                        local d = math.floor(10 ^ i)
                        local rd = rev[k][2] * d
                        while (turn[k] >= rd) do
                            turn[k] = turn[k] - rd
                            turn[rev[k][1]] = (turn[rev[k][1]] or 0) + d
                            count = count + 1
                        end
                    end
                end
            end
            run = (count > 0)
        end
    end
    return turn
end

--- 游戏财物比例计算,如:
--- 乘除可算比例，加减可算相互计算
--- worthCale({gold=100}, "*", 0.5)
--- worthCale({gold=100}, "/", 2)
--- worthCale(3, "*", {gold=100})
--- worthCale({gold=100}, "+", {gold=100})
--- worthCale({gold=100}, "-", {gold=100})
---@param data1 table|number
---@param operator string|"+"|"-"|"*"|"/"
---@param data2 table|number
---@return Array|table
function worth.cale(data1, operator, data2)
    local rule = worth.get()
    local keys = rule:keys()
    local res = nil
    if (operator == "*" or operator == "/") then
        local ratio = 0
        if (type(data1) == "table" or type(data2) == "number") then
            res = worth.u2l(data1)
            ratio = data2
        end
        if (type(data1) == "number" or type(data2) == "table") then
            res = worth.u2l(data2)
            ratio = data1
        end
        for _, k in ipairs(keys) do
            if (type(res[k]) == "number") then
                if (operator == "*") then
                    res[k] = res[k] * ratio
                elseif (operator == "/") then
                    res[k] = res[k] / ratio
                end
            end
        end
    elseif (operator == "+" or operator == "-") then
        if (type(data1) == "table" and type(data2) == "table") then
            res = worth.u2l(data1)
            data2 = worth.u2l(data2)
            for _, k in ipairs(keys) do
                res[k] = res[k] or 0
                if (type(data2[k]) == "number") then
                    if (operator == "+") then
                        res[k] = res[k] + data2[k]
                    elseif (operator == "-") then
                        res[k] = res[k] - data2[k]
                    end
                end
            end
        end
    end
    if (nil == res) then
        print("wrong cale")
        return data1
    end
    return worth.l2u(res)
end

--- 采取 floor 的取整结果
---@param data table
---@return table
function worth.floor(data)
    data = worth.u2l(data)
    for _, k in ipairs(worth.get():keys()) do
        if (type(data[k]) == "number") then
            data[k] = math.floor(data[k])
        end
    end
    return worth.l2u(data)
end

--- 采取 ceil 的取整结果
---@param data table
---@return table
function worth.ceil(data)
    data = worth.u2l(data)
    for _, k in ipairs(worth.get():keys()) do
        if (type(data[k]) == "number") then
            data[k] = math.ceil(data[k])
        end
    end
    return worth.l2u(data)
end

--- 采取 round 的取整结果
---@param data table
---@return table
function worth.round(data)
    data = worth.u2l(data)
    for _, k in ipairs(worth.get():keys()) do
        if (type(data[k]) == "number") then
            data[k] = math.round(data[k])
        end
    end
    return worth.l2u(data)
end

--- 在财物转化规则下，比较两个数据集的大小
--- 1大于2 返回true
--- 1小于2 返回false
--- 相等 返回 0（数据不相应时，没法比较）
--- 没法比较 返回nil
--[[ 如
    data1 = { gold = 1,silver = 1,copper = 0}
    data2 = { gold = 0,silver = 77,copper = 33}
    1 > 2
]]
---@param data1 table
---@param data2 table
---@return boolean|nil
function worth.compare(data1, data2)
    if (nil == data1 or nil == data2) then
        return nil
    end
    local lower1 = worth.u2l(data1)
    local lower2 = worth.u2l(data2)
    local keys = worth.get():keys()
    local result = { g = 0, l = 0 }
    for _, k in ipairs(keys) do
        local d1 = lower1[k] or 0
        local d2 = lower2[k] or 0
        if (d1 > d2) then
            result.g = result.g + 1
        elseif (d1 < d2) then
            result.l = result.l + 1
        end
    end
    if (result.g == 0 and result.l == 0) then
        return 0
    end
    if (result.g > 0 and result.l > 0) then
        return nil
    end
    if (result.g > 0) then
        return true
    end
    if (result.l > 0) then
        return false
    end
end

--- 判断财物1是否 等价于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function worth.equal(data1, data2)
    return 0 == worth.compare(data1, data2)
end

--- 判断财物1是否 大于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function worth.greater(data1, data2)
    return true == worth.compare(data1, data2)
end

--- 判断财物1是否 小于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function worth.less(data1, data2)
    return false == worth.compare(data1, data2)
end

--- 判断财物1是否 大于等于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function worth.equalOrGreater(data1, data2)
    local res = worth.compare(data1, data2)
    return true == res or 0 == res
end

--- 判断财物1是否 小于等于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function worth.equalOrLess(data1, data2)
    local res = worth.compare(data1, data2)
    return false == res or 0 == res
end