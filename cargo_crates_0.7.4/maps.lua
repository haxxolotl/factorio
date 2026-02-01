-- Calculates some other maps/lookup tables for use in weight.lua

local maps = {}

local loaders = {}

-- Add items
table.insert(loaders, function()
	local items = {}

	for class, _ in pairs(defines.prototypes.item) do
		if data.raw[class] ~= nil then
			for _, item in pairs(data.raw[class]) do
				items[item.name] = item
			end
		end
	end

	maps.items = items
end)

-- Add fluids
table.insert(loaders, function()
	local fluids = {}

	for _, fluid in pairs(data.raw.fluid) do
		fluids[fluid.name] = fluid
	end

	maps.fluids = fluids
end)

-- Add recipes
table.insert(loaders, function()
	local recipes = {}

	for _, recipe in pairs(data.raw.recipe) do
		recipes[recipe.name] = recipe
	end
	maps.recipes = recipes
end)

-- Add recipe --> subgroup map
table.insert(loaders, function()
	local recipe_subgroup = {}

	local type_to_lookup = {
		item = maps.items,
		fluid = maps.fluids,
	}

	local function result_to_subgroup(result)
		if not result then
			return "other"
		end

		local result_type = result.type or "item"
		local result_name = result.name or result[1]

		if not result_name then
			return "other"
		end

		local lookup = type_to_lookup[result_type]
		if not lookup then
			return "other"
		end

		local prototype = lookup[result_name]
		if not prototype then
			return "other"
		end

		return prototype.subgroup or "other"
	end

	for _, recipe in pairs(maps.recipes) do
		if recipe.subgroup ~= nil then
			recipe_subgroup[recipe.name] = recipe.subgroup
		elseif recipe.results == nil then
			recipe_subgroup[recipe.name] = "other"
		elseif recipe.main_product ~= nil and recipe.main_product ~= "" then
			local found = false
			for _, result in pairs(recipe.results) do
				local result_name = result.name or result[1]
				if result_name == recipe.main_product then
					recipe_subgroup[recipe.name] = result_to_subgroup(result)
					found = true
					break
				end
			end
			if not found then
				recipe_subgroup[recipe.name] = "other"
			end
		elseif #recipe.results == 1 then
			recipe_subgroup[recipe.name] = result_to_subgroup(recipe.results[1])
		else
			recipe_subgroup[recipe.name] = "other"
		end
	end

	maps.recipe_subgroup = recipe_subgroup
end)

-- Mapping of item --> recipes that produce it
table.insert(loaders, function()
	local item_to_recipe = {}

	for _, item in pairs(maps.items) do
		item_to_recipe[item.name] = {}
	end

	for _, recipe in pairs(maps.recipes) do
		if recipe.results ~= nil then
			for _, result in pairs(recipe.results) do
				local result_type = result.type or "item"
				local result_name = result.name or result[1]
				if result_type == "item" and result_name then
					if item_to_recipe[result_name] then
						item_to_recipe[result_name][recipe.name] = true
					else
						log(
							"[cargo_crates] recipe '"
								.. recipe.name
								.. "' produces missing item '"
								.. result_name
								.. "' which mean it's declared in data-final-fixes. Please define your item earlier"
						)
					end
				end
			end
		end
	end

	maps.item_to_recipe = item_to_recipe
end)

-- Called at the start of weight calculation to populate maps
maps.call_loaders = function()
	for _, loader in pairs(loaders) do
		loader()
	end
end

return maps
