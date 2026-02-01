require('__kry_stdlib__/stdlib/data/data').Util.create_data_globals()

has_dlc = feature_flags["spoiling"] and true or false

local DEBUG = false

--log("==========================flag==================================")
--print(serpent.block(feature_flags))

-- 定义一个函数来计算两个包含键值对的表的差集
local function difference(a, b)
    -- 创建一个空表来存储差集结果
    local diff = {}

    -- 遍历第一个表中的每个键值对
    for key, _ in pairs(a) do
        -- 检查该键是否不在第二个表中，或者在第二个表中但值不为 true
        if not (b[key]) then
            -- 如果键不在第二个表中，或者在第二个表中但值不为 true，则将其添加到差集结果中
            diff[key] = true
        end
    end

    -- 返回差集结果
    return diff
end
raw_item = {}

if DEBUG then

    for name, v in pairs(data.raw.item) do
        raw_item[name] = true
    end

end

orders_recipe = {}
orders_recipe.restaurant = {}
function orders_recipe.add_restaurant(name, bonus)
    table.insert(orders_recipe.restaurant, { name = name, bonus = bonus or 0 })
end

require("data.const")
require("data.group")
require("data.technology")
require("data.fruit")
require("data.vegetable")
require("data.animal_products")
require("data.products")
require("data.item")
require("data.plant")
require("data.recipe")
require("data.entity")
require("data.juice")
require("data.farm")
require("data.generator")
require("data.egg")
require("data.corehub")
require("data.card-upgrader")
require("data.commercial.restaurant")
require("data.processing.cocoa")
require("data.processing.rice")
require("data.processing.wheat")
require("data.processing.yarn")
require("data.processing.coffee")
require("data.processing.potato")

require("data.processing.drying")
require("data.recipe2")

if DEBUG then

    raw_item2 = {}

    for name, v in pairs(data.raw.item) do
        raw_item2[name] = true
    end

    local difference_item = difference(raw_item2, raw_item)

    for name, recipe in pairs(data.raw.recipe) do
        if recipe.category ~= "fruit_plant" and recipe.category ~= "farming" then
            if recipe.results then
                for k, result in pairs(recipe.results) do
                    difference_item[result.name] = nil
                end
            end
        end
    end

    -- 最终缺失的配方
    print("==========================最终缺失的配方==================================")

    for key, _ in pairs(difference_item) do
        if data.raw.item[key].subgroup ~= "fruit" and data.raw.item[key].subgroup ~= "vegetable" then

            print(key)  -- 输出: a
        end
    end
end
