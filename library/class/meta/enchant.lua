--- 附魔(元素附着)
--- 模拟附魔，可以用于模拟不同元素的攻击
--- 如伤害可附着自定义元素类型的伤害
--- 在damageFlow中执行伤害类型的判定，并支持附着

--- 可模拟触发不同的元素反应
---@class Enchant:Meta
local _index = Meta(EnchantClass)

--- 获取key
---@return string
function _index:key()
    return self._key
end

--- 获取名称
---@return string
function _index:name()
    return self._name
end

--- 获取初始化时附带的该属性强化(%)，如5，默认0
---@return number
function _index:strengthen()
    return self._strengthen
end

--- 获取初始化时附带的该属性抵抗(%)，如-10，默认0
---@return number
function _index:resistance()
    return self._resistance
end

--- 获取附身特效
---@return Array
function _index:effectAppend()
    return self._effectAppend
end

--- 获取附魔反应处理
---@alias EnchantReactionEvtData {targetUnit:Unit,sourceUnit:Unit,from:"触发附魔元素",to:"条件附魔元素"}
---@alias EnchantReactionFunc fun(evtData:EnchantReactionEvtData):void
---@param reactEnchantKey string 反应对应的附魔类型，例如和水反应则填water
---@return EnchantReactionFunc|nil
function _index:reaction(reactEnchantKey)
    sync.must()
    ---@type Array
    local reacts = self._reaction
    if (nil == reacts) then
        return
    end
    return reacts:get(reactEnchantKey)
end

--- 设置名称
---@return string
function _index:setName(name)
    sync.must()
    self._name = name
end

--- 设置附身特效
---@param attach string 绑定位置
---@param path string 特效串
---@return void
function _index:setEffect(attach, path)
    sync.must()
    ---@type Array
    local eff = self._effectAppend
    if (nil == eff) then
        eff = Array()
        self._effectAppend = eff
    end
    if (attach and path) then
        eff:set(attach, path)
    end
end

--- 设置附魔反应处理
---@param reactEnchantKey string 反应对应的附魔类型，例如和水反应则填water
---@param reactFunc EnchantReactionFunc
---@return void
function _index:setReaction(reactEnchantKey, reactFunc)
    sync.must()
    ---@type Array
    local reacts = self._reaction
    if (nil == reacts) then
        reacts = Array()
        self._reaction = reacts
    end
    if (type(reactFunc) == "function") then
        reacts:set(reactEnchantKey, reactFunc)
    else
        reacts:set(reactEnchantKey, nil)
    end
end

--- 构造附魔对象
---@param key string
---@param name string 设置label名称，只有初始化生效
---@param strengthen number 设置初始化时附带的该属性强化(%)，如5，默认0，只有初始化生效
---@param resistance number 设置初始化时附带的该属性抵抗(%)，如-10，默认0，只有初始化生效
---@return Enchant
function Enchant(key, name, strengthen, resistance)
    must(type(key) == "string", "key@string")
    local cache = class.cache(EnchantClass)
    if (nil == cache[key]) then
        sync.must()
        cache[key] = oMeta({ _key = key, _name = name or key, _strengthen = strengthen or 0, _resistance = resistance or 0 }, _index)
        -- 关联伤害类型
        table.insert(injury.damageTypeKeys, key)
        injury.damageType[key] = {
            value = key,
            label = name
        }
    end
    return cache[key]
end

--- 是否配置了Enchant已实例
---@param key string 唯一key
---@return boolean
function isEnchant(key)
    if (type(key) ~= "string") then
        return false
    end
    return nil ~= class._cache[EnchantClass] and nil ~= class._cache[EnchantClass][key]
end

--- 遍历所有附魔种类
---@param call fun(eKey:string):void
---@return Enchant
function EnchantForeach(call)
    local dtk = injury.damageTypeKeys
    local l = #dtk
    if (l < 1) then
        return
    end
    for i = 2, l, 1 do
        call(dtk[i])
    end
end