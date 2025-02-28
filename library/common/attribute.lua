--- 属性，用于设置、定义、计算自定义属性数据的方法
--- 掌管项目的属性信息，核心模块，与Attribute强关联
---@class attribute
attribute = attribute or {}

---@type table<string,string>
attribute._labels = attribute._labels or {}
---@type table<string,boolean>
attribute._antis = attribute._antis or {}
---@type table<string,string>
attribute._forms = attribute._forms or {}
---@type table<string,string>
attribute._icons = attribute._icons or {}

--- 单位材质
attribute.unitMaterial = {
    flesh = { value = "flesh", label = "肉体" },
    metal = { value = "metal", label = "金属" },
    rock = { value = "rock", label = "石头" },
    wood = { value = "wood", label = "木头" },
}

--- 单位移动类型
attribute.unitMoveType = {
    foot = { value = MOVE_NAME_FOOT, label = "步行" },
    fly = { value = MOVE_NAME_FLY, label = "飞行" },
    float = { value = MOVE_NAME_FLOAT, label = "漂浮" },
    amphibious = { value = MOVE_NAME_AMPH, label = "两栖" },
}

--- 单位核心
attribute.unitPrimary = {
    str = { value = "str", label = "力量" },
    agi = { value = "agi", label = "敏捷" },
    int = { value = "int", label = "智力" },
}

--- 属性参数名处理
--- 将无下划线的参数名分析并自动加入下划线，不影响SYMBOL参数
---@param name string
---@return string
function attribute.enParam(name)
    local n = name[1]
    if (n ~= '<' and n ~= '_') then
        name = '_' .. name
    end
    return name
end

--- 属性参数名处理
--- 将带下划线_的参数名规整为无下划线，不影响SYMBOL参数
---@param name string
---@return string
function attribute.deParam(name)
    if (name[1] == '_') then
        name = name(2, string.len(name))
    end
    return name
end

--- 配置属性名称、单位范式、是否反属性等
---@param anti boolean 是否反属性（指增加反而不好的属性）*必填
---@param key string 键值 *必填
---@param label string 名称 ~选填
---@param form string 单位范式 ~选填
---@param icon string buff图标 ~选填
---@return void
function attribute.conf(anti, key, label, form, icon)
    sync.must()
    must(type(anti) == "boolean", "anti@boolean")
    must(type(key) == "string", "key@string")
    key = attribute.deParam(key)
    attribute._antis[key] = anti
    attribute._antis[SYMBOL_AMP .. key] = anti
    if (type(label) == "string") then
        attribute._labels[key] = label
        attribute._labels[SYMBOL_AMP .. key] = label
        attribute._forms[SYMBOL_AMP .. key] = '%'
    end
    if (type(form) == "string") then
        attribute._forms[key] = form
    end
    if (type(icon) == "string") then
        attribute._icons[key] = japi.AssetsImage(icon)
    end
end

--- 获取属性名称
---@param key string
---@return string
function attribute.label(key)
    return attribute._labels[attribute.deParam(key)] or "???"
end

--- 获取属性单位
---@param key string
---@return string
function attribute.form(key)
    return attribute._forms[attribute.deParam(key)] or ''
end

--- 获取属性（buff）图标
---@param key string
---@return string
function attribute.icon(key)
    return attribute._icons[attribute.deParam(key)] or X_UI_QUESTION
end

--- 是否百分比属性
---@param key string
---@return boolean
function attribute.isPercent(key)
    key = attribute.deParam(key)
    return type(key) == "string" and (attribute._forms[key] == '%')
end

--- 是否反式属性（指增加反而不好的属性）
---@param key string
---@return boolean
function attribute.isAnti(key)
    key = attribute.deParam(key)
    return type(key) == "string" and (attribute._antis[key] or false)
end

--- 属性字符串简单格式构建
--- 并不适合复杂情形
---@param key string
---@param value number
---@param label string|nil
---@return string
function attribute.format(key, value, label)
    must(type(key) == "string", "key@string")
    must(type(value) == "number", "value@number")
    local txt = nil
    local la, form, anti = attribute.label(key), attribute.form(key), attribute.isAnti(key)
    local l = label or la
    if (value == 0) then
        txt = colour.hex(colour.darkgray, l .. ": " .. value .. form)
    elseif (value > 0) then
        if (anti) then
            txt = colour.hex(colour.indianred, l .. ": +" .. value .. form)
        else
            txt = colour.hex(colour.lawngreen, l .. ": +" .. value .. form)
        end
    else
        if (anti) then
            txt = colour.hex(colour.lawngreen, l .. ": " .. value .. form)
        else
            txt = colour.hex(colour.indianred, l .. ": " .. value .. form)
        end
    end
    return txt
end

--- 复合属性计算
---@param attributes table 属性集
---@param targetUnit Unit
---@param lv number 当前等级
---@param diff number 等级差值
---@return void
function attribute.comp(attributes, targetUnit, lv, diff)
    sync.must()
    if (false == class.isObject(targetUnit, UnitClass)) then
        return
    end
    if (class.isObject(targetUnit, UnitClass)) then
        for _, a in ipairs(attributes) do
            local param = a[1]
            local t1 = a[2] or 0
            local d1 = nil
            local d2 = nil
            local sets = {}
            if (type(t1) == "number") then
                d1 = t1
                d2 = a[3] or 0
            elseif (type(t1) == "string") then
                d1 = a[3] or 0
                d2 = a[4] or 0
                table.insert(sets, t1)
            end
            local v = 0
            if (diff > 0) then
                if (lv <= 0) then
                    v = d1 + (diff - 1) * d2
                else
                    v = diff * d2
                end
            elseif (diff < 0) then
                if (lv + diff < 0) then
                    diff = -lv
                end
                if (lv + diff == 0) then
                    v = -d1 + (diff + 1) * d2
                else
                    v = diff * d2
                end
            end
            if (v > 0) then
                table.insert(sets, "+=" .. v)
            elseif (v < 0) then
                table.insert(sets, "-=" .. -v)
            end
            targetUnit:set(param, table.unpack(sets), 0, '')
        end
    end
end