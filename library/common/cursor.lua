--- 指针行为定义
--- 调用开始时的预设执行,当返回false时(不包含nil)，跳过后面的流程
---@alias cursorQuoteStart fun():boolean
--- 调用结束时的预设执行
---@alias cursorQuoteOver fun():void
--- 刷新操作的预设执行
---@alias cursorQuoteRefresh fun(evtData:eventOnMouseMove):void
--- 左键点击操作的预设执行
---@alias cursorQuoteOnLeftClick fun(evtData:eventOnMouseLeftClick):void
--- 右键点击操作的预设执行
---@alias cursorQuoteOnRightClick fun(evtData:eventOnMouseRightClick):void
---@alias cursorQuoteOptions {start:cursorQuoteStart,over:cursorQuoteOver,refresh:cursorQuoteRefresh,leftClick:cursorQuoteOnLeftClick,rightClick:cursorQuoteOnRightClick}
---@class cursor
cursor = cursor or {}

---@type string 默认指针名
cursor._default = cursor._default or "default"
---@type table<string,cursorQuoteOptions>
cursor._list = cursor._list or {}
---@type table<string,boolean>
cursor._status = cursor._status or {}
---@type string 临时key
cursor._key = cursor._key or nil
---@type table 临时数据
cursor._data = cursor._data or nil

--- 预先设置引用指针是否生效
---@param key string
---@param status boolean
---@return void
function cursor.setStatus(key, status)
    sync.must()
    must(type(status) == "boolean", "status@boolean")
    cursor._status[key] = status
end

--- 获取引用指针生效状态，默认生效
---@param key string
---@return boolean
function cursor.getStatus(key)
    return cursor._status[key] or false
end

--- 预先配置引用指针
---@param key string
---@param options cursorQuoteOptions
---@return void
function cursor.setQuote(key, options)
    cursor._list[key] = options
    if (nil == cursor._status[key]) then
        cursor._status[key] = true -- 默认配置为生效
    end
end

--- 获取指针配置
---@param key string
---@return cursorQuoteOptions|nil
function cursor.getQuote(key)
    return cursor._list[key]
end

--- 对象调用指针
---@param key string
---@param data any
---@return void
function cursor.quote(key, data)
    async.must()
    --- 如果已存在调用，清理当前调用
    if (cursor.isQuoting()) then
        cursor.quoteOver()
    end
    local quote = cursor.getQuote(key)
    if (nil == quote) then
        return
    end
    local status = cursor.getStatus(key)
    if (true ~= status) then
        return
    end
    cursor._key = key
    cursor._data = data
    --- 当start流程返回false时(不包含nil)，跳过后面的流程
    if (type(quote.start) == "function") then
        if (false == quote.start()) then
            cursor.quoteOver()
            return
        end
    end
    if (type(quote.refresh) == "function") then
        quote.refresh({
            triggerPlayer = PlayerLocal(),
            rx = japi.MouseRX(),
            ry = japi.MouseRY(),
        })
        ---@param evtData eventOnMouseMove
        event.asyncRegister("mouse", eventKind.mouseMove, "lk_cs_mov", function(evtData)
            quote.refresh(evtData)
        end)
        camera.onChange("lk_cs_cam", function()
            quote.refresh({
                triggerPlayer = PlayerLocal(),
                rx = japi.MouseRX(),
                ry = japi.MouseRY(),
            })
        end)
    end
    if (type(quote.leftClick) == "function") then
        ---@param evtData eventOnMouseLeftClick
        event.asyncRegister("mouse", eventKind.mouseLeftClick, "lk_cs_lc", function(evtData)
            quote.leftClick(evtData)
            return false
        end)
    end
    if (type(quote.rightClick) == "function") then
        ---@param evtData eventOnMouseRightClick
        event.asyncRegister("mouse", eventKind.mouseRightClick, "lk_cs_rc", function(evtData)
            quote.rightClick(evtData)
            return false
        end)
    end
end

--- 强制终止当前调用指针
--- 如有默认指针，则尝试切回默认指针
---@param key string 限定终止某个key的指针，若当前指针key不是指定的key，则无效
---@return void
function cursor.quoteOver(key)
    async.must()
    if (nil == cursor._key) then
        return
    end
    if (type(key) == "string" and cursor._key ~= key) then
        return
    end
    local quote = cursor.getQuote(cursor._key)
    if (nil == quote) then
        return
    end
    event.asyncRegister("mouse", eventKind.mouseMove, "lk_cs_mov", nil)
    camera.onChange("lk_cs_cam", nil)
    event.asyncRegister("mouse", eventKind.mouseLeftClick, "lk_cs_lc", nil)
    event.asyncRegister("mouse", eventKind.mouseRightClick, "lk_cs_rc", nil)
    if (type(quote.over) == "function") then
        quote.over()
    end
    cursor._key = nil
    cursor._data = nil
    cursor.quote(cursor._default) -- 尝试切回默认指针
end

--- 配置默认指针
--- 当需要使用自定义默认指针时，使用此方法配置常驻的默认指针
---@param options cursorQuoteOptions
---@return void
function cursor.setDefault(options)
    cursor.setQuote(cursor._default, options)
    async.loc(function()
        cursor.quote(cursor._default) -- 默认指针默认启动
    end)
end

--- 当前调用指针的key
---@return string
function cursor.currentKey()
    async.must()
    return cursor._key
end

--- 当前调用指针的data
--- data都是根据业务变化的，预想的非标准数据
---@alias cursorDataAbility {ability:Ability,keyboard:number,mouseLeft:boolean,mouseRight:boolean}
---@alias cursorDataFollow {object:Object,ui:UI,texture:string,width:number,height:number}
---@alias cursorDataAmass {amassStart:number,amassDuration:number}
---@return cursorDataAbility|cursorDataFollow|cursorDataAmass
function cursor.currentData()
    async.must()
    return cursor._data or {}
end

--- [异步]蓄力比率[0.00-1.00]
---@param durFrames number|nil 蓄力经过帧数
---@return number
function cursor.amassRatio(durFrames)
    async.must()
    local data = cursor.currentData()
    if (type(data.amassStart) ~= "number" or false == class.isObject(data.ability, AbilityClass)) then
        return 0
    end
    if (data.ability:bindUnit() ~= PlayerLocal():selection()) then
        return 0
    end
    local dur = durFrames or data.amassDuration or (japi.AsyncInc() - data.amassStart)
    return math.min(1, dur / data.ability:amass())
end

--- 是否引用中
---@return boolean
function cursor.isQuoting()
    local k = cursor.currentKey()
    return nil ~= k and k ~= cursor._default
end

--- 是否拖拽中
--- 此方法需要setup中的cursor配合，本身无功能
--- 由于其性质特殊，故放在常规库内
---@return boolean
function cursor.isDragging()
    return cursor.currentKey() == "drag"
end

--- 是否跟踪图层中
--- 此方法需要setup中的cursor配合，本身无功能
--- 由于其性质特殊，故放在常规库内
---@return boolean
function cursor.isFollowing()
    return cursor.currentKey() == "follow"
end