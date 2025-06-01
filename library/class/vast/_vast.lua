--- Vast大型复合对象结构
--- 适用于功能设计复杂的对象
--- 如Tpl等复合数据处理类
--- 异步set方法不应设计在Vast类中
---@class Vast
local _index = { _type = "Vast" }

---@protected
function _index:destruct()
    sync.must()
    event.syncTrigger(self, eventKind.classDestruct, { triggerObject = self })
end

--- 继承
---@protected
---@param superName string
---@return self
function _index:extend(superName)
    must(type(superName) == "string", "superName@string")
    local cache = class.cache(_index._type)
    must(cache[superName] ~= nil, self._className .. " extended super does not exist")
    setmetatable(self, { __index = cache[superName] })
    return self
end

--- 获取对象ID
---@return string
function _index:id()
    return self._id
end

---@private
---@return void
function _index:modifier(isDyn, key, changeVal)
    sync.must()
    must(type(key) == "string", "key@string")
    local dynKey = SYMBOL_DYN .. key
    local oldVal, newVal
    if (isDyn) then
        if (type(self[key]) == "number" and type(changeVal) == "number") then
            oldVal = self[key] + self[dynKey] or 0
            newVal = self[key] + changeVal
        else
            oldVal = self[key]
            newVal = changeVal
        end
    else
        if (type(self[key]) == "number" and type(self[dynKey]) == "number") then
            oldVal = self[key] + self[dynKey]
        elseif (nil ~= self[dynKey]) then
            oldVal = self[dynKey]
        else
            oldVal = self[key]
        end
        if (type(changeVal) == "number" and type(self[dynKey]) == "number") then
            newVal = changeVal + self[dynKey]
        elseif (nil ~= self[dynKey]) then
            newVal = self[dynKey]
        else
            newVal = changeVal
        end
    end
    local name = attribute.deParam(key)
    if (key[1] == '_') then
        local amp = self:get(name, SYMBOL_AMP) or 0
        if (amp ~= 0) then
            if (type(oldVal) == "number" and oldVal > 0) then
                oldVal = datum.ternary(amp <= -100, 0, oldVal * (1 + amp * 0.01))
            end
            if (type(newVal) == "number" and newVal > 0) then
                newVal = datum.ternary(amp <= -100, 0, newVal * (1 + amp * 0.01))
            end
        end
    end
    if (false == datum.equal(oldVal, newVal)) then
        local changeData = { triggerObject = self, old = oldVal, new = newVal, name = name }
        event.syncTrigger(self, eventKind.classBeforeChange .. name, changeData)
        -- 处理 AMPL
        local isAmp = (1 == string.subPos(key, SYMBOL_AMP))
        local aName, aOldVal
        if (isAmp) then
            aName = string.gsub(key, SYMBOL_AMP, '')
            aOldVal = self:get(aName)
        end
        -- 执行数值修改
        if (isDyn) then
            self[dynKey] = changeVal
        else
            self[key] = changeVal
        end
        -- 当参数值真确修改时执行的modifier回调函数
        VastModifier(self, key, oldVal, newVal)
        -- 回调 AMPL
        if (nil ~= aOldVal) then
            local aNewVal = self:get(aName)
            local aKey = '_' .. aName
            VastModifier(self, aKey, aOldVal, aNewVal)
        end
        event.syncTrigger(self, eventKind.classAfterChange .. name, changeData)
    end
end

--- 强制设置内部参为nil并执行修改处理
--- 此方法与self.any=nil的区别在于会尝试执行VastModifier
---@param name string 参数名
---@return void
function _index:setNil(name)
    local key = attribute.enParam(name)
    VastModifier(self, key, self[key], nil)
    self[key] = nil
end

--- 设置内部参
---@param name string 参数名
---@param variety any
---@param duration number
---@param domain string|nil
---@return void
function _index:set(name, variety, duration, domain)
    sync.must()
    must(type(name) == "string", "name@string")
    must(nil ~= variety, "variety is nil")
    if (type(variety) == "string") then
        local var = string.explode(";", variety)
        if (#var == 2) then
            local dur = tonumber(var[2])
            if (type(dur) == "number") then
                duration = math.max(0, dur)
                variety = var[1]
            end
        end
    end
    if (type(duration) ~= "number") then
        duration = 0
    end
    if (type(domain) ~= "string") then
        domain = '_'
    end
    local key = domain .. name
    local caleVal, diff = math.cale(variety, self[key])
    if (nil == caleVal) then
        return
    end
    -- 增幅 raise
    if (type(diff) == "number") then
        if (diff ~= 0 and domain == '_') then
            local raise = self:get(name, SYMBOL_RAI) or 0
            if raise ~= 0 then
                caleVal = caleVal - diff
                diff = diff * (raise * 0.01 + 1)
                caleVal = caleVal + diff
            end
        end
    end
    -- Cur后缀边界处理，如hpCur
    local kl = string.len(key)
    if (kl > 3 and key(kl - 2, kl) == "Cur") then
        local k = key(2, kl - 3)
        caleVal = math.min(caleVal, self:get(k))
        caleVal = math.max(caleVal, 0)
    end
    if duration <= 0 then
        self:modifier(false, key, caleVal)
    else
        local dynKey = SYMBOL_DYN .. key
        local dynVal = nil
        if (type(diff) == "number") then
            if (diff == 0) then
                return self, false
            end
            dynVal = (self[dynKey] or 0) + diff
        else
            dynVal = caleVal
        end
        -- 挂载Buff
        local desc = {}
        local form, anti = attribute.form(key), attribute.isAnti(key)
        local signal = nil
        if (type(diff) == "number") then
            if (diff >= 0) then
                if (anti) then
                    signal = buffSignal.down
                    desc[#desc + 1] = colour.hex(colour.indianred, "变化: +" .. diff .. form)
                else
                    signal = buffSignal.up
                    desc[#desc + 1] = colour.hex(colour.lawngreen, "变化: +" .. diff .. form)
                end
            else
                if (anti) then
                    signal = buffSignal.up
                    desc[#desc + 1] = colour.hex(colour.lawngreen, "变化: " .. diff .. form)
                else
                    signal = buffSignal.down
                    desc[#desc + 1] = colour.hex(colour.indianred, "变化: " .. diff .. form)
                end
            end
        end
        desc[#desc + 1] = "持续: " .. colour.hex(colour.skyblue, string.format("%0.1f", duration) .. " 秒")
        local bf = nil
        bf = Buff({
            key = key,
            object = self,
            signal = signal,
            duration = duration,
            description = desc,
            ---@param o Vast
            purpose = function(o)
                o:modifier(true, key, dynVal)
            end,
            ---@param o Vast
            rollback = function(o)
                local val = o[dynKey]
                if (type(val) == "number") then
                    o:modifier(true, key, val - diff)
                else
                    local cs = BuffCatch(o, {
                        forward = false,
                        key = key,
                        limit = 1,
                        filter = function(enumBuff)
                            return enumBuff._id ~= bf._id
                        end,
                    })
                    if (#cs > 0) then
                        cs[1]._purpose(o)
                    else
                        o[dynKey] = nil
                        VastModifier(o, key, nil, o:get(name, domain))
                    end
                end
            end
        })
    end
end

--- 获取内部参
---@param name string 参数名
---@param domain string|nil 参域
---@return any
function _index:get(name, domain)
    must(type(name) == "string", "name@string")
    if (type(domain) ~= "string") then
        domain = '_'
    end
    local key = domain .. name
    local val = self[key]
    local dyn = self[SYMBOL_DYN .. key]
    if (nil ~= dyn) then
        if (type(dyn) == "number") then
            val = (val or 0) + dyn
        else
            val = dyn
        end
    end
    if (type(val) == "number") then
        if (val > 0 and domain == '_') then
            local amp = self:get(name, SYMBOL_AMP) or 0
            if (amp ~= 0) then
                if (amp <= -100) then
                    val = 0
                else
                    val = val * (1 + amp * 0.01)
                end
            end
        end
    end
    return val
end

--- 双向内部参
---@param name string 参数名
---@param variety any 为nil时走get路线返回该值，不为nil时走set路线返回self
---@param duration number 参数修改持续时间，默认0
---@param domain string|nil 参定义域，可指定SYMBOL_RAI等，默认nil将在参数名前加_符号，也是prototype原型参数名的命名法
---@param default any
---@return self|any
function _index:modify(name, variety, duration, domain, default)
    if (nil == variety) then
        return datum.default(self:get(name, domain), default)
    else
        duration = duration or 0
        self:set(name, variety, duration, domain)
        return self
    end
end

--- 设置过程增幅，作用于[修改过程]的[改变]数值的百分比增减
--- 只会影响常规参域'_'的数据
---@param name string 参数名
---@param variety number
---@param duration number
---@return self|number
function _index:raise(name, variety, duration)
    return self:modify(name, variety, duration, SYMBOL_RAI)
end

--- 设置终结增幅，作用于[获取时]的[终结]数值的百分比增减
--- 只会影响常规参域'_'的数据
---@param name string 参数名
---@param variety number
---@param duration number
---@return self|number
function _index:ampl(name, variety, duration)
    return self:modify(name, variety, duration, SYMBOL_AMP)
end

--- 构造Vast对象
---@param name string
---@param prototype table 原型数据
---@return Vast
function Vast(name, prototype)
    sync.must()
    must(type(name) == "string", "name@string")
    local cache = class.cache(_index._type)
    if (nil == cache[name]) then
        if (nil == prototype) then
            prototype = {}
        end
        prototype._className = name
        cache[name] = setmetatable(prototype, { __index = _index })
    end
    return cache[name]
end