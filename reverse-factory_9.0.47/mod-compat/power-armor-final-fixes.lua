-- early exit script if power armor replacer mod is not enabled (plus space age)
if not (mods["Power-Armour-Replacer"] and mods["space-age"]) then return end

local Recipe = require('__kry_stdlib__/stdlib/data/recipe')
local par_list = {
	["par-armour-mk"] = "armor",
	["par-battery-mk"] = "item",
	["par-exoskeleton-mk"] = "item",
	["par-fission-reactor-mk"] = "item",
	["par-belt-immunity-mk"] = "item",
	["par-laser-mk"] = "item",
	["par-nightvision-mk"] = "item",
	["par-roboport-mk"] = "item",
	["par-shield-mk"] = "item",
	["par-solar-panel-mk"] = "item"
}

-- for each item in the previous list, check if matching item and recipe exists
for item_name, item_type in pairs(par_list) do
	for n = 1, 10 do
		local item = data.raw[item_type][item_name..n]
		local recipe = data.raw.recipe[item_name..n]
		-- create reverse recipe and remove the additional fluid input for balance
		if item and recipe then
			makeRecipe(item_type,item,recipe)
			Recipe("rf-"..item_name..n):remove_result("solid-fluoroketone-cold")
		end
	end
end