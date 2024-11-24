--- 任务执行
--- 构建业务队列，按序执行
---@class Task
local _index = Meta(TaskClass)

---@protected
function _index:destruct()
    self._object._task = nil
end

--- 制定一个任务并加入队列中
---@param name string 任务队列名
---@param task function
---@return void
function _index:develop(task)
    if (nil == self._queue) then
        self._queue = {}
        task()
    else
        table.insert(self._queue, task)
    end
end

--- 执行队列中的下一个任务
---@return void
function _index:next()
    if (type(self._queue) == "table") then
        if (#self._queue > 0) then
            local n = self._queue[1]
            table.remove(self._queue, 1)
            if (0 == #self._queue) then
                self._queue = nil
            end
            n()
        else
            self._queue = nil
        end
    end
end

--- 清空所有任务
---@return void
function _index:clear()
    self._queue = nil
end

--- 任务
---@param obj Player|Unit|Item|Ability 执行对象
---@return Task
function Task(obj)
    sync.must()
    must(class.inObject(obj, PlayerClass, UnitClass, ItemClass, AbilityClass), "obj@Player|Unit|Item|Ability")
    if (nil == obj._task) then
        obj._task = oMeta({ _object = obj }, _index)
    end
    return obj._task
end