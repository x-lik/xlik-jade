--- Z轴坐标初始化
do
    local loc = J.Location(0, 0)
    J.HandleRef(loc)
    local zi = 32
    local xMin = math.boundary(RegionPlayable:xMin() / zi)
    local yMin = math.boundary(RegionPlayable:yMin() / zi)
    local xMax = math.boundary(RegionPlayable:xMax() / zi)
    local yMax = math.boundary(RegionPlayable:yMax() / zi)
    local yh = math.ceil((yMax + yMin) / 2)
    local x = xMin
    local y1, y2 = yh, yh - 1
    local _z = function()
        if (y1 > yMax and y2 < yMin) then
            J.RemoveLocation(loc)
            J.HandleUnRef(loc)
            loc = nil
            return false
        end
        if (y1 <= yMax) then
            J.MoveLocation(loc, x * zi, y1 * zi)
            local z = math.ceil(J.Common["GetLocationZ"](loc))
            if (z ~= 0) then
                if (nil == japi._z[x]) then
                    japi._z[x] = {}
                end
                japi._z[x][y1] = z
            end
        end
        if (y2 >= yMin) then
            J.MoveLocation(loc, x * zi, y2 * zi)
            local z = math.ceil(J.Common["GetLocationZ"](loc))
            if (z ~= 0) then
                if (nil == japi._z[x]) then
                    japi._z[x] = {}
                end
                japi._z[x][y2] = z
            end
        end
        x = x + 1
        if (x > xMax) then
            x = xMin
            y1 = y1 + 1
            y2 = y2 - 1
        end
        return true
    end
    for _ = 1, 5000 do
        if (true ~= _z()) then
            break
        end
    end
    if (nil ~= loc) then
        time.setInterval(0.3, function(curTimer)
            for _ = 1, 5000 do
                if (true ~= _z()) then
                    class.destroy(curTimer)
                    break
                end
            end
        end)
    end
end