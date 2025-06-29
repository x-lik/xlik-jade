--- 值对
--- 此模块定义了一个用于处理值对映射的类，主要功能包括定义值对类型、根据值获取标签描述以及获取所有值等。
---@class Mapping
---@field _type string 表示该对象的类型，固定为 "Mapping"
---@field _kind string 表示映射的种类，用于区分不同的映射集合
---@field _kv table 存储值对的键值对，键为值，值为包含值和标签等信息的对象
---@field _values string[]|number[] 存储所有值的数组
local _index = { _type = "Mapping" }

--- 定义值对类型
--- 该方法用于向映射中添加或更新一个值对，可携带额外数据信息。
---@class MappingValue:Mapping
---@field value number|string 值对中的值
---@field label string 值对中的标签描述
---@param value any 要添加或更新的值，必须为字符串或数字类型
---@param label string 值对应的标签描述，必须为字符串类型
---@param extras table<number,string[]> 额外数据信息，可选不常用，用于定义额外的信息，如模型、图标路径等
---@return MappingValue 返回添加或更新后的值对对象
function _index:set(value, label, extras)
    must(type(value) == "string" or type(value) == "number", "kind@string|number")
    must(type(label) == "string", "label@string")
    -- 获取存储值对的表
    local m = self._kv
    if (nil == m[value]) then
        m[value] = setmetatable({ value = value, label = label }, { __index = self })
        self._values[#self._values + 1] = value
    else
        m[value].label = label
    end
    -- 如果传入了额外数据信息
    if (type(extras) == "table") then
        for k, v in pairx(extras) do
            m[value][k] = v
        end
    end
    -- 返回添加或更新后的值对数据
    return m[value]
end

--- 根据 value 值获取 label 描述
--- 该方法用于从映射中根据给定的值获取对应的标签描述。
---@param value any 要查找的 value 值
---@return string 返回对应的 label 描述，如果未找到则返回空字符串
function _index:get(value)
    local m = self._kv
    if (nil == m[value]) then
        return ""
    end
    -- 返回该值对应的标签描述
    return m[value].label
end

--- 获取值对所有数值
--- 该方法用于获取映射中所有的值。
---@return string[]|number[] 返回存储所有值的数组
function _index:values()
    return self._values
end

--- cache data
-- 用于缓存不同种类的映射数据集
local _mapping = {}

--- 析出值对数据
--- 该方法用于获取或创建指定种类的映射对象。
---@param kind string 映射的种类，必须为字符串类型
---@return Mapping 返回指定种类的映射对象
function Mapping(kind)
    must(type(kind) == "string", "kind@string")
    if (nil == _mapping[kind]) then
        _mapping[kind] = setmetatable({ _kind = kind, _kv = {}, _values = {} }, { __index = _index })
    end
    return _mapping[kind]
end

--- 检测值对类型
--- 该方法用于检测一个对象是否为指定种类的映射对象。
---@param whichOne Mapping|any 要检测的对象
---@param whichKind string 要检测的映射种类，可选参数
---@return boolean 如果对象是指定种类的映射对象则返回 true，否则返回 false
function isMapping(whichOne, whichKind)
    if (type(whichOne) ~= "table") then
        return false
    end
    if (type(whichKind) == "string") then
        return whichOne._type == _index._type and whichOne._kind == whichKind
    end
    return whichOne._type == _index._type
end