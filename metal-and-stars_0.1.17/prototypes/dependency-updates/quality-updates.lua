if mods["quality"] then
    if data.raw["technology"]["module-productivity-basic"] ~= nil then
        table.insert(data.raw["technology"]["module-productivity-basic"].effects,   {type = "change-recipe-productivity", recipe = "quality-module", change = 0.1})
    end

    if data.raw["technology"]["module-productivity-intermediate"] ~= nil then
        table.insert(data.raw["technology"]["module-productivity-intermediate"].effects,   {type = "change-recipe-productivity", recipe = "quality-module-2", change = 0.1})
    end

    if data.raw["technology"]["module-productivity-advanced"] ~= nil then
        table.insert(data.raw["technology"]["module-productivity-advanced"].effects,   {type = "change-recipe-productivity", recipe = "quality-module-3", change = 0.1})
    end
end