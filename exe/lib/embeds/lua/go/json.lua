--[[
    json.lua
    A compact pure-Lua JSON library.
    The main functions are: json.encode, json.decode.
    ## json.encode:
    This expects the following to be true of any tables being encoded:
     * They only have string or number keys. Number keys must be represented as
       strings in json; this is part of the json spec.
     * They are not recursive. Such a structure cannot be specified in json.
    A Lua table is considered to be an array if and only if its set of keys is a
    consecutive sequence of positive integers starting at 1. Arrays are encoded like
    so: `[2, 3, false, "hi"]`. Any other type of Lua table is encoded as a json
    object, encoded like so: `{"key1": 2, "key2": false}`.
    Because the Lua nil value cannot be a key, and as a table value is considerd
    equivalent to a missing key, there is no way to express the json "null" value in
    a Lua table. The only way this will output "null" is if your entire input obj is
    nil itself.
    An empty Lua table, {}, could be considered either a json object or array -
    it's an ambiguous edge case. We choose to treat this as an object as it is the
    more general type.
    To be clear, none of the above considerations is a limitation of this code.
    Rather, it is what we get when we completely observe the json specification for
    as arbitrary a Lua object as json is capable of expressing.
    ## json.decode:
    This function parses json, with the exception that it does not pay attention to
    \u-escaped unicode code points in strings.
    It is difficult for Lua to return null as a value. In order to prevent the loss
    of keys with a null value in a json string, this function uses the one-off
    table value json.null (which is just an empty table) to indicate null values.
    This way you can check if a value is null with the conditional
    `val == json.null`.
    If you have control over the data and are using Lua, I would recommend just
    avoiding null values in your data to begin with.
--]]
json = {}

-- Internal functions.

local function kindOf(obj)
    if type(obj) ~= "table" then
        return type(obj)
    end
    local i = 0
    for _ in pairs(obj) do
        i = i + 1
    end
    if i == #obj then
        return "array"
    else
        return "table"
    end
end

local function escapeStr(s)
    local in_char = { "\\", '"', "/", "\b", "\f", "\n", "\r", "\t" }
    local out_char = { "\\", '"', "/", "b", "f", "n", "r", "t" }
    for i, c in ipairs(in_char) do
        s = s:gsub(c, "\\" .. out_char[i])
    end
    return s
end

-- Returns pos, did_find; there are two cases:
-- 1. Delimiter found: pos = pos after leading space + delim; did_find = true.
-- 2. Delimiter not found: pos = pos after leading space;     did_find = false.
-- This throws an error if err_if_missing is true and the delim is not found.
local function skipDelim(str, pos, delim, err_if_missing)
    pos = pos + #str:match("^%s*", pos)
    if str:sub(pos, pos) ~= delim then
        if err_if_missing then
            error("Expected " .. delim .. " near position " .. pos)
        end
        return pos, false
    end
    return pos + 1, true
end

-- Expects the given pos to be the first character after the opening quote.
-- Returns val, pos; the returned pos is after the closing quote character.
local function parseStrVal(str, pos, val)
    val = val or ""
    local early_end_error = "End of input found while parsing string."
    if pos > #str then
        error(early_end_error)
    end
    local c = str:sub(pos, pos)
    if c == '"' then
        return val, pos + 1
    end
    if c ~= "\\" then
        return parseStrVal(str, pos + 1, val .. c)
    end
    -- We must have a \ character.
    local esc_map = { b = "\b", f = "\f", n = "\n", r = "\r", t = "\t" }
    local nextc = str:sub(pos + 1, pos + 1)
    if not nextc then
        error(early_end_error)
    end
    return parseStrVal(str, pos + 2, val .. (esc_map[nextc] or nextc))
end

-- Returns val, pos; the returned pos is after the number's final character.
local function parseNumVal(str, pos)
    local num_str = str:match("^-?%d+%.?%d*[eE]?[+-]?%d*", pos)
    local val = tonumber(num_str)
    if not val then
        error("Error parsing number at position " .. pos .. ".")
    end
    return val, pos + #num_str
end

json.null = {} -- This is a one-off table to represent the null value.

-- Public values and functions.

function json.encode(obj, as_key)
    local sss = {}
    local ss = {}
    local kind = kindOf(obj) -- This is 'array' if it's an array or type(obj) otherwise.
    local into = function(str)
        ss[#ss + 1] = str
        if (#ss >= 100) then
            table.insert(sss, ss)
            ss = {}
        end
    end
    if kind == "array" then
        if as_key then
            error("Can't encode array as key.")
        end
        into("[")
        for i, val in ipairs(obj) do
            if #sss > 0 or i > 1 then
                into(", ")
            end
            into(json.encode(val))
        end
        into("]")
    elseif kind == "table" then
        if as_key then
            error("Can't encode table as key.")
        end
        into("{")
        for k, v in pairs(obj) do
            if #sss > 0 or #ss > 1 then
                into(", ")
            end
            into(json.encode(k, true))
            into(":")
            into(json.encode(v))
        end
        into("}")
    elseif kind == "string" then
        return '"' .. escapeStr(obj) .. '"'
    elseif kind == "number" then
        if as_key then
            return '"' .. tostring(obj) .. '"'
        end
        return tostring(obj)
    elseif kind == "boolean" then
        return tostring(obj)
    elseif kind == "nil" then
        return "null"
    else
        error("Unjsonifiable type: " .. kind .. ".")
    end
    if (#ss > 0) then
        table.insert(sss, ss)
    end
    ss = nil
    local concat = ""
    for _, s in ipairs(sss) do
        concat = concat .. table.concat(s)
    end
    return concat
end

function json.decode(str, pos, end_delim)
    pos = pos or 1
    if nil == str then
        stack()
        error("json str is nil.")
    end
    if pos > #str then
        stack()
        error("Reached unexpected end of input.")
    end
    local pos2 = pos + #str:match("^%s*", pos) -- Skip whitespace.
    local first = str:sub(pos2, pos2)
    if first == "{" then
        -- Parse an object.
        local obj, key, delim_found = {}, true, true
        pos2 = pos2 + 1
        while true do
            key, pos2 = json.decode(str, pos2, "}")
            if nil == key then
                return obj, pos2
            end
            if not delim_found then
                error("Comma missing between object items.")
            end
            pos2 = skipDelim(str, pos2, ":", true) -- true -> error if missing.
            obj[key], pos2 = json.decode(str, pos2)
            pos2, delim_found = skipDelim(str, pos2, ",")
        end
    elseif first == "[" then
        -- Parse an array.
        local arr, val, delimFound = {}, true, true
        pos2 = pos2 + 1
        while true do
            val, pos2 = json.decode(str, pos2, "]")
            if nil == val then
                return arr, pos2
            end
            if not delimFound then
                error("Comma missing between array items.")
            end
            arr[#arr + 1] = val
            pos2, delimFound = skipDelim(str, pos2, ",")
        end
    elseif first == '"' then
        -- Parse a string.
        return parseStrVal(str, pos2 + 1)
    elseif first == "-" or first:match("%d") then
        -- Parse a number.
        return parseNumVal(str, pos2)
    elseif first == end_delim then
        -- End of an object or array.
        return nil, pos2 + 1
    else
        -- Parse true, false, or null.
        local literals = { ["true"] = true, ["false"] = false, ["null"] = json.null }
        for lit_str, lit_val in pairs(literals) do
            local lit_end = pos2 + #lit_str - 1
            if str:sub(pos2, lit_end) == lit_str then
                return lit_val, lit_end + 1
            end
        end
        error("Invalid json syntax starting at " .. "position " .. pos2 .. ": " .. str:sub(pos2, pos2 + 10))
    end
end
