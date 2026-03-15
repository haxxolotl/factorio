local meld = require("meld")

-- Helper function to find the index of a value in a table
local function tableIndexOf(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

-- Helper function to remove a value from a table
local function tableRemoveValue(t, value)
    local index = tableIndexOf(t, value)
    if index then
        table.remove(t, index)
    end
end

if data.raw["lab"]["microgravity-lab"] and data.raw["lab"]["lab"] then
    data.raw["lab"]["microgravity-lab"].inputs = meld(data.raw["lab"]["microgravity-lab"].inputs, data.raw["lab"]["lab"].inputs)
    if settings.startup["is-micro-gravity-lab-all-science-enabled"].value == false then
        tableRemoveValue(data.raw["lab"]["microgravity-lab"].inputs, "automation-science-pack")
        tableRemoveValue(data.raw["lab"]["microgravity-lab"].inputs, "logistic-science-pack")
        tableRemoveValue(data.raw["lab"]["microgravity-lab"].inputs, "military-science-pack")
        tableRemoveValue(data.raw["lab"]["microgravity-lab"].inputs, "chemical-science-pack")
        tableRemoveValue(data.raw["lab"]["microgravity-lab"].inputs, "production-science-pack")
        tableRemoveValue(data.raw["lab"]["microgravity-lab"].inputs, "utility-science-pack")
    end

    table.insert(data.raw["lab"]["microgravity-lab"].inputs, "nanite-science-pack")
    table.insert(data.raw["lab"]["microgravity-lab"].inputs, "ring-science-pack")
    table.insert(data.raw["lab"]["microgravity-lab"].inputs, "anomaly-science-pack")
    table.insert(data.raw["lab"]["microgravity-lab"].inputs, "quantum-science-pack")
end

