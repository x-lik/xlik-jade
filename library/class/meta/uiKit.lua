--- UI套件
---@class UIKit:Meta
local _index = Meta(UIKitClass, {
    _protect = true,
    _started = false,
})

--- 当套件启动
--- 应覆盖重写此预设方法从而执行你的启动阶段操作
---@return void
function _index:onStart()
    print("UIKitStart:" .. self._kit)
end

--- 当套件进入配置
--- 应覆盖重写此预设方法从而执行你的配置阶段操作
---@return void
function _index:onSetup()
    print("UIKitSetup:" .. self._kit)
end

--- 获取套件的kit名
---@return string
function _index:kit()
    return self._kit
end

--- 执行设置
---@protected
---@return void
function _index:setup()
    self:onSetup()
    self._ltSetup = tostring(self.onSetup)
end

--- 执行启动
---@protected
---@return void
function _index:start()
    self:onStart()
    self._ltStart = tostring(self.onStart)
    self._started = true
end

--- 套件是否已start
---@return boolean
function _index:isStarted()
    return true == self._started
end

--- 重加载
---@return void
function _index:reload()
    if (self:isStarted()) then
        time.setTimeout(0, function()
            if (tostring(self.onSetup) ~= self._ltSetup) then
                self:setup()
            end
            if (tostring(self.onStart) ~= self._ltStart) then
                self:start()
            end
        end)
    end
end

--- 构建UIKit对象
--[[
    可为UIKit定义方法 onSetup、onStart
    定义的方法将在init过程中自动引用
    例子：(默认自带组方法，会打印流程的进出)
    local ui = UIKit(kit)
    function ui:onSetup() print("onSetup") end
    function ui:onStart() print("onStart") end
    -------------------------------
    UIKit不再进行定时执行的配置如：uiKit:onInterval(...)
    你可自由地在不同阶段自行运用设计
    例子：
    local ui = UIKit(kit)
    function ui:onStart()
        -- 同步
        time.setInterval...
        -- 异步
        async.loc(function()
            async.setInterval...
        end)
    end
]]
---@param kit string 套件唯一key
---@return UIKit
function UIKit(kit)
    must(type(kit) == "string", "kit@string")
    local cache = class.cache(UIKitClass)
    if (nil == cache[kit]) then
        sync.must()
        ---@type UIKit
        local o = oMeta({ _id = kit, _kit = kit }, _index)
        Pool(UIKitClass):insert(o)
        cache[kit] = o
    else
        if (LK_DEBUG and sync.is()) then
            cache[kit]:reload()
        end
    end
    return cache[kit]
end

--- 判定UI套件是否已实例
---@param kit string 套件唯一key
---@return boolean
function isUIKit(kit)
    if (type(kit) ~= "string") then
        return false
    end
    return nil ~= class._cache[UIKitClass] and nil ~= class._cache[UIKitClass][kit]
end