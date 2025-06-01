--- 二维向量
--- 一个二维向量可以用一个箭头来表示
--- 这个箭头起始于原点(0,0)，
--- 终点坐标(x,y)分别为向量中的两个元素

---@class vector2 二维向量
vector2 = vector2 or {}

--- 获取两个坐标间角度，如果其中一个单位为空 返回0
--- 返回的范围是[0-360(0)]
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function vector2.angle(x1, y1, x2, y2)
    return math.trunc((math._r2d * math.atan(y2 - y1, x2 - x1) + 360) % 360, 4)
end

--- 长度
---@param x number
---@param y number
---@return number
function vector2.length(x, y)
    return math.sqrt(x ^ 2 + y ^ 2)
end

--- 范数模；归一化
---@param x number
---@param y number
---@return number,number
function vector2.norm(x, y)
    local l = vector2.length(x, y)
    local xn = 0
    local yn = 0
    if l > 0 then
        xn = x / l
        yn = y / l
    end
    return xn, yn
end

--- 点积
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function vector2.dot(x1, y1, x2, y2)
    return x1 * x2 + y1 * y2
end

--- 获取两个坐标距离
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function vector2.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

--- 极坐标位移
---@param x number
---@param y number
---@param distance number
---@param angle number
---@return number,number
function vector2.polar(x, y, distance, angle)
    local px = x + distance * math.cos(math._d2r * angle)
    local py = y + distance * math.sin(math._d2r * angle)
    if (px < RegionPlayable:xMin()) then
        px = RegionPlayable:xMin()
    elseif (px > RegionPlayable:xMax()) then
        px = RegionPlayable:xMax()
    end
    if (py < RegionPlayable:yMin()) then
        py = RegionPlayable:yMin()
    elseif (py > RegionPlayable:yMax()) then
        py = RegionPlayable:yMax()
    end
    return px, py
end

--- 旋转
---@param x number
---@param y number
---@param angle number
---@return number,number
function vector2.rotate(x, y, angle)
    local c = math.cos(math._d2r * angle)
    local s = math.sin(math._d2r * angle)
    local xr = x * c - y * s
    local yr = x * s + y * c
    return xr, yr
end

--- 判断两个单位是否接近平行同方向，本质上是两单位面向角度接近
---@param x1 number 当前向量X
---@param y1 number 当前向量Y
---@param x2 number 目标向量X
---@param y2 number 目标向量Y
---@param facing1 number 第1个单位的面向角度
---@param facing2 number 第2个单位的面向角度
---@param maxDistance number 最大相对距离
---@param forcedOrder boolean 是否强制顺序，也就是主观上必须 1 站在前，2在后
---@return boolean
function vector2.isParallel(x1, y1, x2, y2, facing1, facing2, maxDistance, forcedOrder)
    maxDistance = maxDistance or math.huge
    if (vector2.distance(x1, y1, x2, y2) > maxDistance) then
        return false
    end
    if (type(forcedOrder) == "boolean" and true == forcedOrder) then
        return math.abs(facing1 - facing2) < 50 and math.abs(vector2.angle(x2, y2, x1, y1) - facing2) < 90
    end
    return math.abs(facing1 - facing2) < 50
end

--- 判断两个单位是否"正对着"或"背对着"，本质上是两单位面向极度相反
---@param x1 number 当前向量X
---@param y1 number 当前向量Y
---@param x2 number 目标向量X
---@param y2 number 目标向量Y
---@param facing1 number 第1个单位的面向角度
---@param facing2 number 第2个单位的面向角度
---@param maxDistance number 最大相对距离
---@param face2face boolean 是否【面对面】而不是【背对背】
---@return boolean
function vector2.isIntersect(x1, y1, x2, y2, facing1, facing2, maxDistance, face2face)
    maxDistance = maxDistance or math.huge
    if (vector2.distance(x1, y1, x2, y2) > maxDistance) then
        return false
    end
    if (type(face2face) == "boolean" and true == face2face) then
        return math.abs((math.abs(facing1 - facing2) - 180)) < 50 and math.abs(vector2.angle(x2, y2, x1, y1) - facing2) < 90
    end
    return math.abs((math.abs(facing1 - facing2) - 180)) < 50
end

--- 线性
---@param start number[] len:2
---@param stop number[] len:2
---@param t number
---@return number,number
function vector2.linear(start, stop, t)
    return
    curve.linear(start[1], stop[1], t),
    curve.linear(start[2], stop[2], t)
end

--- 2次方贝塞尔
---@param start number[] len:2
---@param ctl number[] len:2
---@param stop number[] len:2
---@param t number range[0-1]
---@return number,number
function vector2.bezier2(start, ctl, stop, t)
    return
    curve.bezier2(start[1], ctl[1], stop[1], t),
    curve.bezier2(start[2], ctl[2], stop[2], t)
end

--- 3次方贝塞尔
---@param start number[] len:2
---@param ctl1 number[] len:2
---@param ctl2 number[] len:2
---@param stop number[] len:2
---@param t number range[0-1]
---@return number,number
function vector2.bezier3(start, ctl1, ctl2, stop, t)
    return
    curve.bezier3(start[1], ctl1[1], ctl2[1], stop[1], t),
    curve.bezier3(start[2], ctl1[2], ctl2[2], stop[2], t)
end