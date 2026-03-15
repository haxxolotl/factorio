--List of recipes that need to be manually added to the list
--  Must be in the format of {"item type", "item name", "recipe name"}

-- pistol recipe is hidden in 2.0, but must be recycled
-- pacific mod removes pistol, so check if it exists first
if data.raw.gun.pistol and data.raw.recipe.pistol then
	table.insert(rf.custom_recycle, {"gun", "pistol", "pistol"})
end

--Added gas canister, gas barrel, energy cell, and kerosine from King Jo's Fuels mod
if mods["kj_fuel"] then
	if data.raw.item["kj_gascan"] and data.raw.recipe["kj_gascan_fill"] then
		table.insert(rf.custom_recycle, {"item", "kj_gascan", "kj_gascan_fill"})
	end
	if data.raw.item["kj_energy_cell"] and data.raw.recipe["kj_energy_cell_load"] then
		table.insert(rf.custom_recycle, {"item", "kj_energy_cell", "kj_energy_cell_load"})
	end
	if data.raw.item["kj_kerosine"] and data.raw.recipe["kj_kerosine_fill"] then
		table.insert(rf.custom_recycle, {"item", "kj_kerosine", "kj_kerosine_fill"})
	end
	if data.raw.item["kj_gasbarrel"] and data.raw.recipe["kj_gasbarrel_fill"] then
		table.insert(rf.custom_recycle, {"item", "kj_gasbarrel", "kj_gasbarrel_fill"})
	end
end

if mods["Hovercrafts"] then
	if data.raw["item-with-entity-data"]["hcraft-entity"] and data.raw.recipe["hcraft-recipe"] then
		table.insert(rf.custom_recycle, {"item-with-entity-data", "hcraft-entity", "hcraft-recipe"})
	end
	if data.raw["item-with-entity-data"]["mcraft-entity"] and data.raw.recipe["mcraft-recipe"] then
		table.insert(rf.custom_recycle, {"item-with-entity-data", "mcraft-entity", "mcraft-recipe"})
	end
	if data.raw["item-with-entity-data"]["lcraft-entity"] and data.raw.recipe["lcraft-recipe"] then
		table.insert(rf.custom_recycle, {"item-with-entity-data", "lcraft-entity", "lcraft-recipe"})
	end
end

if mods["SeaBlock"] then
	if data.raw.item["pellet-charcoal"] and data.raw.recipe["pellet-coke"] then
		table.insert(rf.custom_recycle, {"item", "pellet-charcoal", "pellet-coke"})
	end
	if data.raw.item["wood-charcoal"] and data.raw.recipe["sb-wood-bricks-charcoal"] then
		table.insert(rf.custom_recycle, {"item", "wood-charcoal", "sb-wood-bricks-charcoal"})
	end
end