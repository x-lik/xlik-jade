--- slk数据管理
--- 桥接WE数据，除制作原生地图外一般不需要自行使用
slk = slk or {}

--- 根据ID获取slk数据
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
--- id后参数可选接多层key，直接获取级层key的值，如使用slk.i2v("slk","Primary")获得结果"STR"
---@param id string|number
---@vararg string
---@return table|nil
function slk.i2v(id, ...)
    if (nil == id) then
        return
    end
    if (type(id) == "number") then
        id = J.I2C(id)
    end
    if (nil == LK_SLK_I2V[id]) then
        return
    end
    local n = select("#", ...)
    if (n > 0) then
        local val = LK_SLK_I2V[id]
        for i = 1, n, 1 do
            local k = select(i, ...)
            if (nil ~= val[k]) then
                val = val[k]
            else
                val = nil
            end
            if (nil == val) then
                break
            end
        end
        return val
    end
    return LK_SLK_I2V[id]
end

--- 根据名称获取ID
--- 根据名称只对应一个ID，返回string
--- 根据名称如对应多个ID，返回table
---@param name string
---@return string|table|nil
function slk.n2i(name)
    if (type(name) ~= "string") then
        return
    end
    if (nil == LK_SLK_N2I[name] or type(LK_SLK_N2I[name]) ~= "table") then
        return
    end
    if (#LK_SLK_N2I[name] == 1) then
        return LK_SLK_N2I[name][1]
    end
    return LK_SLK_N2I[name]
end

--- 根据图标路径转成DIS图标路径
---@param path string
---@return string
function slk.disIconPath(path)
    if (type(path) == "string") then
        path = string.gsub(path, "CommandButtons\\BTN", "CommandButtonsDisabled\\DISBTN", 1)
    end
    return path
end
