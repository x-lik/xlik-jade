SLK_ID_ALREADY = {}
SLK_ID_COUNT = {}
GO_RESULT = {
    selection = "Common",
    font = "default",
    loading = "default",
    preview = "",
    font = "default",
    terrain = "",
    image = {},
    textures = {},
    model = {},
    speech = {},
    bgm = {},
    vcm = {},
    v3d = {},
    vwp = {},
    ui = {},
    slk = {},
}

function GO_SLK_INI(ini)
    local iniJson = json.decode(ini)
    for _, v in pairs(iniJson) do
        SLK_ID_ALREADY[v] = true
    end
end

function GO_SLK_SET(data)
    for k, v in pairs(data) do
        if (type(v) == "function") then
            data[k] = nil
        end
    end
    table.insert(GO_RESULT.slk, data)
end

local idPrefix = {
    ability = "K",
    buff = "P",
    destructable = "D",
    doodad = "O",
    item = "I",
    unit = "V",
    upgrade = "U",
}

local _convert = nil

--- 10进制数字转2/8/10/16/36进制
---@param dec number
---@param cvt number 默认16;2|8|10|16|36
---@return string
function convert(dec, cvt)
    if (dec == 0) then
        return "0"
    end
    cvt = cvt or 16
    if (nil == _convert) then
        _convert = {
            [2] = string.split("01", 1),
            [8] = string.split("01234567", 1),
            [10] = string.split("0123456789", 1),
            [16] = string.split("0123456789ABCDEF", 1),
            [36] = string.split("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", 1),
        }
    end
    if (nil == _convert[cvt]) then
        return "0"
    end
    local numStr = ""
    while (dec ~= 0) do
        local yu = math.floor((dec % cvt) + 1)
        numStr = _convert[cvt][yu] .. numStr
        dec = math.floor(dec / cvt)
    end
    return numStr
end

local idLimit = 46655 -- zzz

function SLK_CREATE_ID(_v)
    local _parent = _v._parent
    local _class = _v._class
    local _id_force = _v._id_force
    -- 如果自定义的ID可用，返回设定的ID
    if (nil ~= _id_force and string.len(_id_force) == 4 and true ~= SLK_ID_ALREADY[_id_force]) then
        local b = string.byte(_id_force, 1, 1)
        if (b >= 48 and b <= 57) then
            print("ID FORCE:<" .. _id_force .. "> The first character should not be a number!")
        else
            SLK_ID_ALREADY[_id_force] = true
            return _id_force
        end
    end
    local prefix = idPrefix[_class]
    if (nil == prefix) then
        prefix = "X"
    end
    if (nil == SLK_ID_COUNT[prefix]) then
        SLK_ID_COUNT[prefix] = 0
    end
    local sid = nil
    while (true) do
        local id = convert(SLK_ID_COUNT[prefix], 36)
        SLK_ID_COUNT[prefix] = SLK_ID_COUNT[prefix] + 1
        if (SLK_ID_COUNT[prefix] > idLimit) then
            sid = "ZZZZ"
            break
        end
        if string.len(id) == 1 then
            id = "00" .. id
        elseif string.len(id) == 2 then
            id = "0" .. id
        end
        sid = prefix .. id
        if true ~= SLK_ID_ALREADY[sid] then
            SLK_ID_ALREADY[sid] = true
            break
        end
    end
    if (_class == "unit") then
        local p1st = string.sub(_parent, 1, 1)
        if (string.lower(p1st) == p1st) then
            sid = string.lower(sid)
        end
    end
    return sid
end

function GO_SLK_ALL()
    return json.encode(GO_RESULT.slk)
end

function GO_ASSETS_ALL()
    return json.encode({
        selection = GO_RESULT.selection,
        font = GO_RESULT.font,
        loading = GO_RESULT.loading,
        preview = GO_RESULT.preview,
        terrain = GO_RESULT.terrain,
        image = GO_RESULT.image,
        model = GO_RESULT.model,
        bgm = GO_RESULT.bgm,
        vcm = GO_RESULT.vcm,
        v3d = GO_RESULT.v3d,
        vwp = GO_RESULT.vwp,
        ui = GO_RESULT.ui,
    })
end