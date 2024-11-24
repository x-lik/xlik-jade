--- 曲线方法
--- 可看成空间质点运动的轨迹。
---@class curve 曲线
curve = curve or {}

--- 线性
---@param start number
---@param stop number
---@param t number range[0-1]
---@return number
function curve.linear(start, stop, t)
    return start + (stop - start) * t
end

--- 2次方贝塞尔
---@param start number
---@param ctl number
---@param stop number
---@param t number range[0-1]
---@return number
function curve.bezier2(start, ctl, stop, t)
    return start + 2 * (ctl - start) * t + (stop - 2 * ctl + start) * t ^ 2
end

--- 3次方贝塞尔
---@param start number
---@param ctl1 number
---@param ctl2 number
---@param stop number
---@param t number range[0-1]
---@return number
function curve.bezier3(start, ctl1, ctl2, stop, t)
    return start + 3 * t * (ctl1 - start) + 3 * t ^ 2 * (ctl2 - 2 * ctl1 + start) + t ^ 3 * (3 * (ctl1 - ctl2) + stop - start)
end

--- 埃尔米特
---@param start number
---@param stop number
---@param tangent1 number
---@param tangent2 number
---@param t number range[0-1]
---@return number
function curve.hermite(start, stop, tangent1, tangent2, t)
    local h1 = 8 * t * t ^ 2 - 9 * t ^ 2
    local h2 = h1 * -1
    local h3 = t ^ 2 * (t - 2) + t
    local h4 = t ^ 2 * (t - 1)
    h1 = h1 + 1
    return h1 * start + h2 * stop + h3 * tangent1 + h4 * tangent2
end

--- 内切
---@param p1 number 使用2个点时，p1=0
---@param p2 number
---@param p3 number
---@param p number 张力，指定转弯的幅度
---@param c number 连续性，指定速度和方向之间的变化率
---@param b number 偏差，指定曲线的方向
---@return number
function curve.tangentIn(p1, p2, p3, p, c, b)
    return (1 - p) * (1 - c) * (1 + b) * (p2 - p1) / 2 + (1 - p) * (1 + c) * (1 - b) * (p3 - p2) / 2
end

--- 外切
---@param p1 number 使用2个点时，p1=0
---@param p2 number
---@param p3 number
---@param p number 张力，指定转弯的幅度
---@param c number 连续性，指定速度和方向之间的变化率
---@param b number 偏差，指定曲线的方向
---@return number
function curve.tangentOut(p1, p2, p3, p, c, b)
    return (1 - p) * (1 + c) * (1 + b) * (p2 - p1) / 2 + (1 - p) * (1 - c) * (1 - b) * (p3 - p2) / 2
end
