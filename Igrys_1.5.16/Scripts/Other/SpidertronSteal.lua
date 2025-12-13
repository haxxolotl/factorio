if settings.startup["igrys-steal-spidertron"].value then
    local tech = data.raw["technology"]["spidertron"]

    for i, prereq in ipairs(tech.prerequisites) do
        if prereq == "rocket-turret" then
            table.remove(tech.prerequisites, i)
            break
        end
    end

    table.insert(tech.prerequisites, "igrys-rich-magic-teseract")

    for i, prereq in ipairs(tech.unit.ingredients) do
        if prereq[1] == "agricultural-science-pack" then
            table.remove(tech.unit.ingredients, i)
            break
        end
    end

    table.insert(tech.unit.ingredients, {"igrys-mineral-science-pack", 1})


    local recipe = data.raw["recipe"]["spidertron"]

    for i, prereq in ipairs(recipe.ingredients) do
        if prereq.name == "rocket-turret" then
            table.remove(recipe.ingredients, i)
            break
        end
    end

    table.insert(recipe.ingredients, {type="item", name="igrys-rich-magic-teseract", amount=2e0})
end 