--- meta结构类对象结构，适用于仅需要简单设计的对象
--- 如Array等数据结构则可以使用Meta而不选Vast
---@class Meta
local _index = { _type = "Meta" }

---@param superName string
---@return self
function _index:extend(superName)
    must(type(superName) == "string", "superName@string")
    local cache = class.cache(_index._type)
    if (nil == cache[superName]) then
        class.extends(superName, self)
    else
        setmetatable(self, { __index = cache[superName] })
    end
    return self
end

---@param name string
---@param prototype table 原型数据
---@return Meta
function Meta(name, prototype)
    must(type(name) == "string", "name@string")
    local cache = class.cache(_index._type)
    if (nil == cache[name]) then
        if (nil == prototype) then
            prototype = {}
        end
        prototype._className = name
        cache[name] = setmetatable(prototype, { __index = _index })
        local extends = class.extends(name)
        if (type(extends) == "table") then
            for _, c in ipairs(extends) do
                setmetatable(c, { __index = cache[name] })
            end
            class.extends(name, false)
        end
    end
    return cache[name]
end