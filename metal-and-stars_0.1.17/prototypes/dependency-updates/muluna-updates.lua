if mods["planet-muluna"] then
    if data.raw["recipe"]["rocket-part-muluna"] ~= nil then
        data.raw["recipe"]["rocket-part-muluna"].localised_name = nil
    end
    
    if data.raw["recipe"]["thruster-fuel-from-rocket-fuel"] ~= nil then
        table.insert(data.raw["technology"]["space-fuel-productivity"].effects,   {type = "change-recipe-productivity", recipe = "thruster-fuel-from-rocket-fuel", change = 0.1})
    end

end