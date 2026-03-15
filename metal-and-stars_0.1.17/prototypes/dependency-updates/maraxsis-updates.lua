if mods.maraxsis then

    if data.raw["rocket-silo"]["rocket-silo"] ~= nil then
        data.raw["rocket-silo"]["rocket-silo"].fixed_recipe = nil
    end

    if data.raw["recipe"]["maraxsis-rocket-part"] ~= nil then
        data.raw["recipe"]["maraxsis-rocket-part"].localised_name = nil
    end

end
