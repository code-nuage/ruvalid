local date_format = "^%d%d%d%d/%d%d/%d%d$"
local time_format = "^%d%d:%d%d:%d%d$"

local function parse_rules(pattern)
    local rules = {
        is_required = false,
        is_string = false,
        is_number = false,
        is_table = false,
        is_email = false,
        is_date = false,
        is_time = false,
        min = false,
        max = false
    }

    local parsed = {}
    for token in string.gmatch(pattern, "[^|]+") do
        token = token:match("^%s*(.-)%s*$")
        local key, value = token:match("([^:]+):(.+)")
        if key and value then
            if value == "true" then
                parsed[key] = true
            end
            if tonumber(value) then
                parsed[key] = tonumber(value)
            end
        else
            parsed[token] = true
        end
    end

    for rule, value in pairs(parsed) do
        if rule == "required" then
            rules.is_required = true
        end
        if rule == "is_string" then
            rules.is_string = true
        end
        if rule == "is_number" then
            rules.is_number = true
        end
        if rule == "is_table" then
            rules.is_table = true
        end
        if rule == "is_email" then
            rules.is_email = true
            rules.is_string = true
        end
        if rule == "is_date" then
            rules.is_date = true
            rules.is_string = true
        end
        if rule == "is_time" then
            rules.is_time = true
            rules.is_string = true
        end
        if rule == "min" then
            rules.min = value
        end
        if rule == "max" then
            rules.max = value
        end
    end

    return rules
end

return function(data, patterns)
    assert(type(data) == "table", "Argument <data> must be a table.")
    assert(type(patterns) == "table", "Argument <patterns> must be a table.")

    local function is_empty(v)
        return v == nil or v == ""
    end

    for key, pattern in pairs(patterns) do
        local rules = parse_rules(pattern)
        local value = data[key]

        if rules.is_required and is_empty(value) then
            return false, "Missing required data: " .. key
        end

        if not is_empty(value) then
            if rules.is_number then
                if type(value) ~= "number" then
                    return false, "Invalid type: <" .. key .. "> must be a number."
                end
            end
            if rules.is_string then
                if type(value) ~= "string" then
                    return false, "Invalid type: <" .. key .. "> must be a string."
                end
            end
            if rules.is_table then
                if type(value) ~= "table" then
                    return false, "Invalid type: <" .. key .. "> must be a table."
                end
            end
            if rules.is_email then
                if type(value) ~= "string" or not value:match("^[^@]+@[^@]+%.%w+$") then
                    return false, "Invalid email format: <" .. key .. ">."
                end
            end
            if rules.is_date then
                if not value:match(date_format) then
                    return false, "Invalid date format: <" .. key .. "> format must be " .. date_format .. "."
                end
            end
            if rules.is_time then
                if not value:match(time_format) then
                    return false, "Invalid time format: <" .. key .. "> format must be " .. time_format .. "."
                end
            end
            if rules.min then
                if type(value) == "string" and #value < rules.min then
                    return false, "Invalid length: <" .. key .. "> must be at least " .. rules.min .. " characters."
                elseif type(value) == "number" and value < rules.min then
                    return false, "Invalid value: <" .. key .. "> must be at least " .. rules.min .. "."
                end
            end
            if rules.max then
                if type(value) == "string" and #value > rules.max then
                    return false, "Invalid length: <" .. key .. "> must be at most " .. rules.max .. " characters."
                elseif type(value) == "number" and value > rules.max then
                    return false, "Invalid value: <" .. key .. "> must be at most " .. rules.max .. "."
                end
            end
        end
    end

    return true
end
