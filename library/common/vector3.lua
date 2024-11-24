--- 三维向量
--- 三维向量和二维向量类似，可以表示为三维平面中的一个箭头，
--- 只不过坐标变成了(x,y,z)

---@class vector3 三维向量
vector3 = vector3 or {}

--- 点积
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number
function vector3.dot(x1, y1, z1, x2, y2, z2)
    return x1 * x2 + y1 * y2 + z1 * z2
end

--- 长度
---@param x number
---@param y number
---@param z number
---@return number
function vector3.length(x, y, z)
    return math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
end

--- 范数模
--- 归一化
---@param x number
---@param y number
---@param z number
---@return number,number,number
function vector3.norm(x, y, z)
    local l = vector3.length(x, y, z)
    local xn = 0
    local yn = 0
    local zn = 0
    if l ~= 0 then
        xn = x / l
        yn = y / l
        zn = z / l
    end
    return x, y, z
end

--- 交叉乘积
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number,number,number
function vector3.cross(x1, y1, z1, x2, y2, z2)
    return
    y1 * z2 - z1 * y2,
    z1 * x2 - x1 * z2,
    x1 * y2 - y1 * x2
end

--- 获取两个坐标距离
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number
function vector3.distance(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

--- 极坐标位移
---@param x number
---@param y number
---@param z number
---@param distance number
---@param angleGround number
---@param angleAir number
---@return number,number
function vector3.polar(x, y, z, distance, angleGround, angleAir)
    local px = x + distance * math.cos(math._d2r * angleGround) * math.sin(math._d2r * angleAir)
    local py = y + distance * math.sin(math._d2r * angleGround) * math.sin(math._d2r * angleAir)
    local pz = z + distance * math.cos(math._d2r * angleAir)
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
    if (pz < 0) then
        pz = 0
    elseif (py > 3000) then
        py = 3000
    end
    return px, py, pz
end

-- 旋转
---@param x number
---@param y number
---@param z number
---@param xAxis number
---@param yAxis number
---@param zAxis number
---@param angle number 角度
---@return number,number,number
function vector3.rotate(x, y, z, xAxis, yAxis, zAxis, angle)
    local al = xAxis * xAxis + yAxis * yAxis + zAxis * zAxis
    local c = math.cos(math._d2r * angle)
    local s = math.sin(math._d2r * angle)
    if al == 0 then
        return 0, 0, 0
    end
    local f = (x * xAxis + y * yAxis + z * zAxis) / al
    local zx = xAxis * f
    local zy = yAxis * f
    local zz = zAxis * f
    local xx = x - zx
    local xy = y - zy
    local xz = z - zz
    al = math.sqrt(al)
    local yx = (yAxis * xz - zAxis * xy) / al
    local yy = (zAxis * xx - xAxis * xz) / al
    local yz = (xAxis * xy - yAxis * xx) / al
    return
    xx * c + yx * s + zx,
    xy * c + yy * s + zy,
    xz * c + yz * s + zz
end

--- 线性
---@param start number[] len:3
---@param stop number[] len:3
---@param t number range[0-1]
---@return number,number,number
function vector3.linear(start, stop, t)
    return
    curve.linear(start[1], stop[1], t),
    curve.linear(start[2], stop[2], t),
    curve.linear(start[3], stop[3], t)
end

--- 2次方贝塞尔
---@param start number[] len:3
---@param ctl number[] len:3
---@param stop number[] len:3
---@param t number range[0-1]
---@return number,number,number
function vector3.bezier2(start, ctl, stop, t)
    return
    curve.bezier2(start[1], ctl[1], stop[1], t),
    curve.bezier2(start[2], ctl[2], stop[2], t),
    curve.bezier2(start[3], ctl[3], stop[3], t)
end

--- 3次方贝塞尔
---@param start number[] len:3
---@param ctl1 number[] len:3
---@param ctl2 number[] len:3
---@param stop number[] len:3
---@param t number range[0-1]
---@return number,number,number
function vector3.bezier3(start, ctl1, ctl2, stop, t)
    return
    curve.bezier3(start[1], ctl1[1], ctl2[1], stop[1], t),
    curve.bezier3(start[2], ctl1[2], ctl2[2], stop[2], t),
    curve.bezier3(start[3], ctl1[3], ctl2[3], stop[3], t)
end