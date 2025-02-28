--- 流程管理
--- 游戏进度段的管理切片
---@type Process 当前运行流程
ProcessCurrent = ProcessCurrent or nil

---@class Process:Meta
local _index = Meta(ProcessClass)

---@protected
function _index:destruct()
    self:over()
end

--- 当进入流程
--- 应覆盖重写此预设方法从而执行你的进入阶段操作
---@return void
function _index:onStart()
    print("ProcessStart:" .. self._key)
end

--- 当结束流程
--- 应覆盖重写此预设方法从而执行你的结束阶段操作
---@return void
function _index:onOver()
    print("ProcessOver:" .. self._key)
end

--- 泡影数据
---@return table
function _index:bubble()
    sync.must()
    return self._bubble
end

--- 清空泡影数据
---@return table
function _index:bubbleClear()
    sync.must()
    local bubble = self._bubble
    for _, v in pairx(bubble) do
        if (class.is(v)) then
            class.destroy(v)
        elseif (effector.isAgile(v)) then
            effector.destroy(v)
        end
    end
    self._bubble = {}
end

--- 开始进入此流程
---@type fun():void
function _index:start()
    sync.must()
    if (ProcessCurrent == self) then
        return
    end
    if (ProcessCurrent) then
        ProcessCurrent:over()
    end
    ProcessCurrent = self
    self._bubble = {}
    self:onStart()
end

--- 重新进入此流程
---@return void
function _index:restart()
    self:over()
    self:start()
end

--- 获取此流程的上一个流程
---@return Process
function _index:prev()
    return self._prev
end

--- 去往下一个流程
---@param nextStageName string
---@return void
function _index:next(nextStageName)
    self:over()
    if (nil ~= nextStageName) then
        local n = Process(nextStageName)
        if (n) then
            n._prev = self
            n:start()
        end
    end
end

--- 结束此流程
---@return void
function _index:over()
    sync.must()
    if (self == ProcessCurrent) then
        self:onOver()
        self:bubbleClear()
        ProcessCurrent = nil
    end
end

--- 构造流程管理对象
--[[
    为流程定义onStart、onOver可绑定进入流程
    例子：(默认自带组方法，会打印流程的进出)
    local p = Process("test")
    function p:onStart()  print("onStart")  end
    function p:onOver()  print("onOver")  end
]]
---@param key string 唯一key
---@return Process
function Process(key)
    sync.must()
    must(type(key) == "string", "key@string")
    local cache = class.cache(ProcessClass)
    if (nil == cache[key]) then
        cache[key] = oMeta({ _key = key, _bubble = {} }, _index)
    end
    return cache[key]
end