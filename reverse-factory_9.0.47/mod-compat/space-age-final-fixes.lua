-- early exit script if space age not enabled
if not mods["space-age"] then return end
-- early exit script if solid fluids is enabled (handled from that side)
if mods["kry-solid-fluids"] then return end
-- this setting exists only when solid fluids is not enabled, but early exit if it's false
if not settings.startup["rf-solid-fluids"].value then return end

-- finally, copy ice melting recipe to solid fluid melting group
-- seemingly the only way to keep ice melting in its original tab, and in the melting tab
local Recipe = require('__kry_stdlib__/stdlib/data/recipe')
new_recipe = Recipe("ice-melting"):krycopy("solid-ice-melting")
-- re-copy the results/ingredients as reference so it stays consistent
new_recipe.results = Recipe("ice-melting").results
new_recipe.ingredients = Recipe("ice-melting").ingredients
-- copy the order of water in case it has moved
new_recipe.order = data.raw.fluid.water.order
new_recipe.enabled = true
new_recipe.allow_productivity = false
new_recipe.allow_decomposition = false
new_recipe.allow_as_intermediate = false
new_recipe.hide_from_player_crafting = true
new_recipe.hidden_in_factoriopedia = true
new_recipe.group = "solids-into-fluids"
new_recipe.subgroup = "solids-into-fluids"
new_recipe.category = "solids-into-fluids"
-- finally modify the icon for consistency, adding melting symbol
if new_recipe.icons then
	table.insert(new_recipe.icons,
		{icon = "__reverse-factory__/graphics/icon/melting.png", icon_size = 64})
else
	new_recipe.icons = {
		{
			icon = new_recipe.icon,
			icon_size = new_recipe.icon_size or 64,
			icon_scale = new_recipe.icon_scale or 0.5,
		},
		{
			icon = "__reverse-factory__/graphics/icon/melting.png",
			icon_size = 64
		}
	}
end