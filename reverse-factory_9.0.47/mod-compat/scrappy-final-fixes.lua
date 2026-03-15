-- early exit script if scrappy industry not enabled
if not mods["scrap-industry"] then return end

local Recipe = require('__kry_stdlib__/stdlib/data/recipe')
local scrappy_recipes = {
	["iron-plate-from-scrap"] = true,
	["copper-plate-from-scrap"] = true,
	["steel-plate-from-scrap"] = true,
	["sort-mech-scrap"] = true,
	["lithium-plate-from-powder"] = true,
	["lead-plate-from-scrap"] = true,
	["titanium-plate-from-scrap"] = true,
}

for name, _ in pairs(scrappy_recipes) do
	-- recipe ==> Recipe(name) only if valid recipe, otherwise recipe ==> false
	local r = Recipe(name)
	local recipe = r:is_valid() and r or false
	-- if recipe exists, either add to additional_categories list, or create the list
	if recipe then
		if recipe.additional_categories then
			table.insert(recipe.additional_categories, "recycle-intermediates")
		else recipe.additional_categories = {"recycle-intermediates"}
		end
	end
end