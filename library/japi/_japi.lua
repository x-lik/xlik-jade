--- JAPI通用库，编写定义通用及框架自带的api控制函数
--[[
    Api接口基本将尽可能地按照新的实现为标准
    * JAPI一切方法都会根据环境而变（包括框架自带的），环境问题请自行解决
    * 如果你所拥有的环境不匹配方法，将提示方法不存在
    
    函数名头指japi方法函数名称大写开头的标识
     - 自带方法 无
     - ydapi  YD_
     - dzapi  DZ_
     - kkapi  KK_
     
    ！注意
    因为旧DZ、新DZ、最新的KK三个版本的接口新旧混合，功能重复相互混合，管理得极其混乱不堪，故框架作出下列调整：
     - 自实现api 请查看 japi/lk.lua
     - ydapi 请查看 japi/yd.lua（如果你查找的方法以YDWE、EX开头，大概率在这里）
     - dzapi 请查看 japi/dz.lua（如果你查找的方法以Dz、DzApi开头，大概率在这里）
     - kkapi 请查看 japi/kk.lua（如果你查找的方法以KKApi开头，大概率在这里）
    注释中带有[别名]的api则是改掉了名字，你可以使用原来的名字来搜索它
    注释中带有[不明]的api表示无迹可寻API，注释功能说明为猜测不可尽信
    注释中带有[PRE]的api表示平台预体验API，可能该功能无法用于平台正式环境
]]
---@class japi
japi = japi or {}

---@type table<string,number>
japi._tips = japi._tips or {}

---@protected
---@param msg string
---@return void
function japi.Tips(msg)
    if (japi._tips[msg] ~= 1) then
        japi._tips[msg] = 1
        local err = SYMBOL_JAPI .. msg
        if (LK_DEBUG) then
            print(err)
        else
            echo(err)
        end
    end
end

---@protected
---@param method string
---@vararg any
---@return any
function japi.Exec(method, ...)
    if (type(method) ~= "string") then
        return false
    end
    if (nil == J.Japi) then
        return false
    end
    local call = J.Japi[method]
    if (type(call) ~= "function") then
        japi.Tips(method .. "NotExist")
        return false
    end
    return call(...)
end