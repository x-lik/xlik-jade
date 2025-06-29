--- JAPI自kk库，包含kk平台引擎自带的japi方法，方法以 KK_ 开头

--- [别名]KKApiTriggerRegisterBackendLogicUpdata
--- 注册随机存档更新事件
--- 当玩家随机存档更新的时候触发该事件。用“当前变动的随机存档”来获取变动的随机存档key。
---@param trig number
---@return void
function japi.KK_TriggerRegisterBackendLogicUpdate(trig)
    japi.DZ_TriggerRegisterSyncData(trig, "DZBLU", true)
end

--- 注册随机存档删除事件
--- 当玩家随机存档删除的时候触发该事件。用“当前变动的随机存档”来获取变动的随机存档key。
---@param trig number
---@return void
function japi.KK_TriggerRegisterBackendLogicDelete(trig)
    japi.DZ_TriggerRegisterSyncData(trig, "DZBLD", true)
end

--- 获取变动的随机存档
--- 用在注册随机存档更新和删除事件之后
---@return string
function japi.KK_GetSyncBackendLogic()
    return japi.DZ_GetTriggerSyncData()
end

--- 注册天梯投降事件
--- 当玩家在天梯投降时候触发该事件。用“获取投降的队伍id”来获取。
---@param trig number
---@return void
function japi.KK_TriggerRegisterLadderSurrender(trig)
    japi.DZ_TriggerRegisterSyncData(trig, "DZSR", true)
end

--- 获取天梯投降的队伍ID
--- 用于天梯投降事件动作里
---@return number integer
function japi.KK_GetLadderSurrenderTeamId()
    return math.round(tonumber(japi.DZ_GetTriggerSyncData()))
end

--- 设置单位整数物编数据
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_SetUnitDataCacheInteger(whichUnit, id, v)
    japi.DZ_SetUnitDataCacheInteger(whichUnit, id, 0, v)
end

--- 设置单位物编数据(建筑升级)
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddUpgradesIds(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 94, id, v)
end

--- 设置单位物编数据(农民可建造建筑)
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddBuildsIds(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 100, id, v)
end

--- 设置单位物编数据(可研究的科技)
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddResearchesIds(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 112, id, v)
end

--- 设置单位物编数据(可训练的单位)
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddTrainsIds(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 106, id, v)
end

--- 设置单位物编数据(出售的单位)
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddSellsUnitIds(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 118, id, v)
end

--- 设置单位物编数据(出售的物品)
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddSellsItemIds(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 124, id, v)
end

--- 设置单位物编数据(制造的物品)
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddMakesItemIds(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 130, id, v)
end

--- 设置单位物编数据(科技需求)[单位]
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddRequiresUnitCode(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 166, id, v)
end

--- 设置单位物编数据(科技需求)[科技]
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddRequiresTechCode(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 166, id, v)
end

--- 设置单位物编数据(科技需求值)
---@param whichUnit number handle
---@param id number integer
---@param v number integer
---@return void
function japi.KK_UnitUIAddRequiresAmounts(whichUnit, id, v)
    japi.DZ_UnitUIAddLevelArrayInteger(whichUnit, 172, id, v)
end

--- 获取服务器存档限制余额
--- 获取指定服务器存档变量的天/周上限余额，需要在开发者平台配置服务器存档防刷。
--- 访问授权限制
--- 高级接口，需要授权后才允许使用。
---@param whichPlayer number
---@param key string
---@return number integer
function japi.KK_GetServerValueLimitLeft(whichPlayer, key)
    return japi.DZ_RequestExtraIntegerData(82, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 随机只读存档-生成随机数
--- 通知服务器端产生一个随机数，并将随机数保存至指定的只读型存档变量Key中。
--- 生成随机数时需要关联一个组ID，该组ID可以在开发者平台进行防刷分管理，同组ID下各个Key共享CD和次数。
---@param whichPlayer number
---@param key string
---@param groupKey string
---@return boolean
function japi.KK_RequestBackendLogic(whichPlayer, key, groupKey)
    return japi.DZ_RequestExtraBooleanData(83, whichPlayer, key, groupKey, false, 0, 0, 0)
end

--- 随机只读存档-判断随机数是否为空
--- 判断服务器端所生成的随机数是否为空。
---@param whichPlayer number
---@param key string
---@return boolean
function japi.KK_CheckBackendLogicExists(whichPlayer, key)
    return japi.DZ_RequestExtraBooleanData(84, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 随机只读存档-读取随机数的值
--- 读取服务器端所产生的随机数的值。
---@param whichPlayer number
---@param key string
---@return number
function japi.KK_GetBackendLogicIntResult(whichPlayer, key)
    return japi.DZ_RequestExtraIntegerData(85, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 获取后端逻辑生成结果 字符串
---@param whichPlayer number
---@param key string
---@return string
function japi.KK_GetBackendLogicStrResult(whichPlayer, key)
    return japi.DZ_RequestExtraStringData(86, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 随机只读存档-读取随机数的生成时间
--- 读取服务器端所产生随机数的生成时间。
---@param whichPlayer number
---@param key string
---@return number integer
function japi.KK_GetBackendLogicUpdateTime(whichPlayer, key)
    return japi.DZ_RequestExtraIntegerData(87, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 随机只读存档-读取随机数的组ID
--- 读取指定的随机只读存档变量Key最后一次是由哪个组ID所生成的。
---@param whichPlayer number
---@param key string
---@return string
function japi.KK_GetBackendLogicGroup(whichPlayer, key)
    return japi.DZ_RequestExtraStringData(88, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 随机只读存档-删除随机数
--- 删除指定的随机只读存档变量Key中所保存的随机数
---@param whichPlayer number
---@param key string
---@return boolean
function japi.KK_RemoveBackendLogicResult(whichPlayer, key)
    return japi.DZ_RequestExtraBooleanData(89, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 是否在平台正常游戏中
--- 主要试用于平台运行中区分正常游戏和观战模式，返回true代表是正常游戏模式，反之为观战模式
---@return boolean
function japi.KK_IsGameMode()
    return japi.DZ_RequestExtraBooleanData(90, nil, nil, nil, false, 0, 0, 0)
end

--- 初始化平台键位显示设置
--- 设置whichPlayer的第n套方案的键位key,设置描述data
--- 初始化键位设置会显示在平台改键界面上，最多2套方案
---@param whichPlayer number
---@param setIndex number integer
---@param k string
---@param data string
---@return boolean
function japi.KK_InitializeGameKey(whichPlayer, setIndex, k, data)
    local k1, v1 = '"' .. "name" .. '"', '"' .. data .. '"'
    local k2, v2 = '"' .. "key" .. '"', '"' .. k .. '"'
    return japi.DZ_RequestExtraBooleanData(91, whichPlayer, '[{' .. k1 .. ':' .. v1 .. ',' .. k2 .. ':' .. v2 .. '}]', nil, false, setIndex, 0, 0)
end

--- 获取当前玩家在平台的身份类型（主播/职业选手）
---@param whichPlayer number
---@param id number integer 3=主播，4=职业选手
---@return boolean
function japi.KK_IsPlayerIdentityType(whichPlayer, id)
    return japi.DZ_RequestExtraBooleanData(92, whichPlayer, nil, nil, false, id, 0, 0)
end

--- [别名]DzApi_Map_IsBlueVIP
--- 判断是否是蓝V
---@param whichPlayer number
---@return boolean
function japi.KK_Map_IsBlueVIP(whichPlayer)
    return japi.KK_IsPlayerIdentityType(whichPlayer, 3)
end

--- [别名]DzApi_Map_IsRedVIP
--- 判断是否是红V
---@param whichPlayer number
---@return boolean
function japi.KK_Map_IsRedVIP(whichPlayer)
    return japi.KK_IsPlayerIdentityType(whichPlayer, 4)
end

--- 转换时间戳为具体时间
--- 以时间戳1736413480例，返回值类似：2025-1-9 17:4:40
---@param timestamp number integer
---@return string
function japi.KK_GetTimeDateFromTimestamp(timestamp)
    local tt = os.date("*t", timestamp)
    return string.format("%d-%d-%d %d:%d:%d", tt.year, tt.month, tt.day, tt.hour, tt.min, tt.sec)
end

--- 获取时间戳年份
--- 以时间戳1736413480例，返回值类似：2025
---@param timestamp number integer
---@return number integer
function japi.KK_GetTimestampYear(timestamp)
    return os.date("*t", timestamp).year
end

--- 获取时间戳月份
--- 以时间戳1736413480例，返回值类似：1
---@param timestamp number integer
---@return number integer
function japi.KK_GetTimestampMonth(timestamp)
    return os.date("*t", timestamp).month
end

--- 获取时间戳日份
--- 以时间戳1736413480例，返回值类似：9
---@param timestamp number integer
---@return number integer
function japi.KK_GetTimestampDay(timestamp)
    return os.date("*t", timestamp).day
end

--- 获取玩家的平台ID
--- 返回的是一个32位的字符串
---@param whichPlayer number
---@return boolean
function japi.KK_PlayerGUID(whichPlayer)
    return japi.DZ_RequestExtraStringData(93, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 玩家地图任务状态
--- 获取玩家地图任务状态，需要先在作者之家创建地图任务并生成任务ID。
---@param whichPlayer number
---@param setIndex number integer
---@param taskStatus number integer 某状态
---@return boolean
function japi.KK_IsTaskInProgress(whichPlayer, setIndex, taskStatus)
    return japi.DZ_RequestExtraIntegerData(94, whichPlayer, nil, nil, false, setIndex, 0, 0) == taskStatus
end

--- 玩家地图任务当前进度
--- 获取玩家地图任务状态，需要先在作者之家创建地图任务并生成任务ID。
---@param whichPlayer number
---@param setIndex number integer
---@return boolean
function japi.KK_QueryTaskCurrentProgress(whichPlayer, setIndex)
    return japi.DZ_RequestExtraIntegerData(95, whichPlayer, nil, nil, false, setIndex, 0, 0)
end

--- 玩家地图任务总进度
--- 获取玩家地图任务状态，需要先在作者之家创建地图任务并生成任务ID。
---@param whichPlayer number
---@param setIndex number integer
---@return boolean
function japi.KK_QueryTaskTotalProgress(whichPlayer, setIndex)
    return japi.DZ_RequestExtraIntegerData(96, whichPlayer, nil, nil, false, setIndex, 0, 0)
end

--- 获取玩家成就是否完成
---@param whichPlayer number
---@param id string 成就id
---@return boolean
function japi.KK_IsAchievementCompleted(whichPlayer, id)
    return japi.DZ_RequestExtraBooleanData(98, whichPlayer, id, nil, false, 0, 0, 0)
end

--- 获取玩家地图成就点数
---@param whichPlayer number
---@return number integer
function japi.KK_AchievementPoints(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(99, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 判断游戏时长是否满足条件
---@param whichPlayer number
---@param minHours number integer 最小小时数
---@param maxHours number integer 最大小时数，0表示不限制
---@return number integer
function japi.KK_PlayedTime(whichPlayer, minHours, maxHours)
    return japi.DZ_RequestExtraBooleanData(100, whichPlayer, nil, nil, false, minHours, maxHours, 0)
end

--- 获取随机存档剩余次数
--- 今日的剩余次数
---@param whichPlayer number
---@param groupKey string
---@return boolean
function japi.KK_RandomSaveGameCount(whichPlayer, groupKey)
    return japi.DZ_RequestExtraIntegerData(101, whichPlayer, groupKey, nil, false, 0, 0, 0)
end

--- 开始批量保存存档
--- 对添加批量保存存档条目进行保存
---@param whichPlayer number
---@return boolean
function japi.KK_BeginBatchSaveArchive(whichPlayer)
    return japi.DZ_RequestExtraBooleanData(102, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 添加批量保存存档条目
---@param whichPlayer number
---@param key string 条目
---@param value string 数据
---@param caseInsensitive boolean 区分大小写
---@return boolean
function japi.KK_AddBatchSaveArchive(whichPlayer, key, value, caseInsensitive)
    return japi.DZ_RequestExtraBooleanData(103, whichPlayer, key, value, caseInsensitive, 0, 0, 0)
end

--- 结束批量保存存档
---@param whichPlayer number
---@param abandon boolean
---@return boolean
function japi.KK_EndBatchSaveArchive(whichPlayer, abandon)
    return japi.DZ_RequestExtraBooleanData(104, whichPlayer, nil, nil, abandon, 0, 0, 0)
end

--- 获取玩家所在公会等级
---@param whichPlayer number
---@return number integer
function japi.KK_GetGuildLevel(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(106, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取宠物探险次数
---@param whichPlayer number
---@return number integer
function japi.KK_MapExplorationNum(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(107, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 宠物探险时间
---@param whichPlayer number
---@return number integer
function japi.KK_MapExplorationTime(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(108, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 测试大厅预约人数
---@return number integer
function japi.KK_MapOrderNum()
    return japi.DZ_RequestExtraIntegerData(109, nil, nil, nil, false, 0, 0, 0)
end

--- 获取商城道具最后变动的数量（新增/删除）
--- 事件响应 - 商城道具最后变动的数量
--- 获取的是当次玩家商城背包新增或消耗的数量，如果是时效型道具获取的是剩余时间
--- 可以用于【玩家获取商城道具事件】、【玩家消耗使用商城道具事件】和【玩家删除商城道具事件】后
---@param whichPlayer number
---@param key string 商城道具
---@return number integer 最后更新的数量
function japi.KK_GetMallItemUpdateCount(whichPlayer, key)
    return japi.DZ_RequestExtraIntegerData(110, whichPlayer, key, nil, false, 0, 0, 0)
end

--- 获取地图版本号
---@return string
function japi.KK_GetMapVersion()
    return japi.DZ_RequestExtraStringData(111, nil, nil, nil, false, 0, 0, 0)
end

--- 获取赛事RPG地图游戏模式
---@return string
function japi.KK_GetCompetitionGameMode()
    return japi.DZ_RequestExtraStringData(112, nil, nil, nil, false, 0, 0, 0)
end

--- 获取当天游戏局数
---@param whichPlayer number 玩家
---@return number integer
function japi.KK_DayRounds(whichPlayer)
    return japi.DZ_RequestExtraIntegerData(113, whichPlayer, nil, nil, false, 0, 0, 0)
end

--- 获取会员等级（测试功能）
---@param whichPlayer number 玩家
---@param mapId number integer 地图ID
---@return number integer
function japi.KK_ConsumeLevel(whichPlayer, mapId)
    return japi.DZ_RequestExtraIntegerData(115, whichPlayer, nil, nil, false, mapId, 0, 0)
end

--- 发送云脚本数据
---@param whichPlayer number 玩家
---@param eventName string 事件
---@param payload string 数据
---@return boolean
function japi.KK_MlScriptEvent(whichPlayer, eventName, payload)
    return japi.DZ_RequestExtraBooleanData(1009, whichPlayer, eventName, payload, false, 0, 0, 0)
end