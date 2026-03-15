--Data contains all functions contained in the Factorio stdlib
local Data = require('__kry_stdlib__/stdlib/data/data')
local Recipe = require('__kry_stdlib__/stdlib/data/recipe')
local Table = require('__kry_stdlib__/stdlib/utils/table')
local Debug = require('__kry_stdlib__/stdlib/utils/debug')

--Used for Yuoki mod compatibility
local yuoki = "-recipe"
local fluidBlacklist = {}
if mods["space-age"] then
	table.insert(fluidBlacklist,"water") -- becomes ice in space age
	table.insert(fluidBlacklist,"molten-iron") -- becomes solid iron
	table.insert(fluidBlacklist,"molten-copper") -- becomes solid copper
	table.insert(fluidBlacklist,"fluoroketone-hot") -- becomes cold variant
end

--Check all recipes in category, and create a reverse recipe for any items in that category
function addRecipes(itemType, group)
	for itemName, item in pairs(group) do
		--Check if a canon recipe exists for the item in question
		local recipe = data.raw.recipe[itemName] and (data.raw.recipe[itemName] or data.raw.recipe[itemName..yuoki])
		--Fix for items from 248k mod
		if rf.mod248k and string.match(itemName,"_item") then
			recipeName = shorten248k(itemName)
			recipe = data.raw.recipe[recipeName]
		end
		if recipe then
			--If recipes are hidden from the player, they should not be checked for recycling
			if not recipe.hidden then
				local hasIngredients = false
				local hasResults = false
				--Recipe must have at least one proper ingredient to be uncraftable
				if recipe.ingredients then
					if recipe.ingredients[1] then
						hasIngredients = true
					end
				else log("Recipe did not have ingredients: "..recipe.name)
				end
				--Recipe must have at least one proper result to be uncraftable
				if recipe.results then
					if recipe.results[1] then
						hasResults = true
					end
				else log("Recipe did not have results: "..recipe.name)
				end
				--Recipe must not use probability, not be blacklisted
				if hasIngredients and hasResults then
					if checkProbs(recipe,item) then
						if noRecycle(recipe,item) then
							makeRecipe(itemType,item,recipe)
						end
					end
				end
			else log("Recipe was marked as hidden: "..recipe.name)
			end
		end
	end
end

--Check if recipe uses probability or has multiple products (do NOT attempt to reeycle)
function checkProbs(recipe,item)
	-- always allow scrappy recipes with multiple products, if recipe has main_product
	if mods["scrap-industry"] and recipe.main_product then return true end
	local noProb = true
	if recipe.results then
		if #recipe.results > 1 then
			noProb = false
			log("Recipe with multiple results not allowed: "..recipe.name)
		end
		for _, ingred in ipairs(recipe.results) do
			if ingred.probability then
				noProb = false
				log("Recipe with probability not allowed: "..recipe.name)
			end
		end
	end
	return noProb
end

--Check if recipe should be recyclable.
function noRecycle(recipe,item)
	uncraft = true
	--List of items and categories not to recycle; can be added to by other mods.
	for _, itemName in pairs(rf.norecycle_items) do
		if recipe.name == itemName then
			uncraft = false
			log("Item was blacklisted: "..itemName)
			break
		end
	end
	for _, category in pairs(rf.norecycle_categories) do
		if recipe.category == category then
			uncraft = false
			log(category.." category was blacklisted for this recipe: "..recipe.name)
			break
		end
	end
	for _, subgroup in pairs(rf.norecycle_subgroups) do
		if item.subgroup == subgroup
			then uncraft = false
			log(subgroup.." subgroup was blacklisted for this item: "..item.name)
			break
		end
		if recipe.subgroup == subgroup then
			uncraft = false
			log(subgroup.." subgroup was blacklisted for this recipe: "..recipe.name)
			break
		end
	end
	return uncraft
end

--Create a reverse recipe for input recipe
function makeRecipe(itemType,item,recipe)
	if not item then error(item) end
	local nrec = "rf-"..item.name
	local rfCategory, count = checkResults(itemType,item,recipe)
	local toAdd = {
		category = rfCategory,
		subgroup = "recycling",
		enabled = true,
		hidden = true,
		additional_categories = nil,
		allow_decomposition = false,
		allow_as_intermediate  = false,
		unlock_results = false,
		auto_recycle = false,
		energy_required = (recipe.energy_required or 1)/8
	}
	
	local rf_recipe = Recipe(recipe):krycopy(nrec)
	rf_recipe.ingredients = {}
	--Copy icon or icons from item if recipe did not have it set
	if not recipe.icon and not recipe.icons then
		if data.raw[itemType][item.name].icon then
			rf_recipe:set_field("icon",data.raw[itemType][item.name].icon)
		end
		if data.raw[itemType][item.name].icons then
			rf_recipe:set_field("icons",data.raw[itemType][item.name].icons)
		end
		if data.raw[itemType][item.name].icon_size then
			rf_recipe:set_field("icon_size",data.raw[itemType][item.name].icon_size)
		end
		if data.raw[itemType][item.name].icon_mipmaps then
			rf_recipe:set_field("icon_mipmaps",data.raw[itemType][item.name].icon_mipmaps)
		end
	end
	
	--Left in the recycled fluid handling logic just in case
	if itemType == "fluid" then
		rf_recipe:add_ingredient({name=item.name, amount=count, type="fluid"})
	else
		rf_recipe:add_ingredient({name=item.name, amount=count, type="item"})
	end

	rf_recipe:set_enabled(true)
	rf_recipe:set_fields(toAdd)
	
	--Sets the name of the recipe to a localized name
	local localised_name
	if itemType == "fluid" then
		localised_name = "fluid-name." .. item.name
	elseif item.place_result then
		localised_name = "entity-name." .. item.place_result
	elseif item.place_as_tile then
		localised_name = "tile-name." .. item.place_as_tile.result
	elseif item.placed_as_equipment_result then
		localised_name = "equipment-name." .. item.placed_as_equipment_result
	else
		localised_name = "item-name." .. item.name
	end
	rf_recipe.localised_name = {"recipe-name.reverse-factory-recycling", { localised_name }}
	
	rf_recipe:clear_surface_conditions()
	rf_recipe.results = {}
	rf_recipe:remove_main_product()
	recycleResults(nrec,recipe)
	fixMaxResults(nrec,rfCategory)
	--Debug.error(data.raw.recipe[nrec])
	--if nrec == "rf-retrovirus" then Debug.error(data.raw.recipe["retrovirus"]) end
	
	if mods ["nullius"] then
		rf_recipe:set_field("order","nullius-b")
	end
end

--Check recipe for result count and gate beind specific tier
function checkResults(itemType,item,recipe)
	--Default values for count and category
	--if not recipe.results[1] then error(serpent.block(recipe)) end
	local count = recipe.results[1].amount and recipe.results[1].amount or 1
	local category = "recycle-products"
	--If solid fluids are enabled, check the ingredient list for any fluids not yet added
	if rf.solidfluids then
		for _, ingredient in ipairs(recipe.ingredients) do
			if ingredient.type == "fluid" then
				--if item.name == "retrovirus" then error(serpent.block(ingredient)) end
				-- check if already added
				if data.raw.item["solid-"..ingredient.name] then
					goto continue
				end
				-- then check if blacklisted for any reason
				for _, blacklisted in pairs(fluidBlacklist) do
					if ingredient.name == blacklisted then -- if match, fluid is blacklisted
						log('Fluid ingredient was blacklisted from solid item conversion')
						goto continue  -- so immediately exit all loops and skip to below
					end
				end
				if data.raw.fluid[ingredient.name] then
					makeFluidItem(data.raw.fluid[ingredient.name]) -- if no match, create fluid item
					log('Created new fluid item: '..ingredient.name)
				else
					log('Unable to create fluid item: '..ingredient.name..
					", which appeared in this recipe: "..recipe.name)
				end
				::continue::
			end
		end
	end

	-- Only needed when intermediates recycling is gated
	if rf.prodgate then
		--Recycling intermediate products are tier 2
		if data.raw[itemType][item.name].subgroup then
			if string.match(data.raw[itemType][item.name].subgroup, "intermediate") then
				category = "recycle-intermediates"
			elseif string.match(data.raw[itemType][item.name].subgroup, "raw") then
				category = "recycle-intermediates"
			end
		end

		if recipe.results then
			--Recycling fluids into items are tier 2
			if recipe.results.type == "fluid" then
				category = "recycle-intermediates"
			end
		end
		if recipe.ingredients then
			--Recycling items into fluids are tier 2
			for _, ingredient in ipairs(recipe.ingredients) do
				if ingredient.type == "fluid" then
					category = "recycle-intermediates"
				end
			end
		end

		--Recycling fluids in general are tier 2
		if itemType == "fluid" then
			category = "recycle-intermediates"
		end
		
		-- if the recipe allows productivity, becomes tier 3
		if recipe.allow_productivity then
			category = "recycle-productivity"
		end
	end
	
	return category, count
end

--Goes through each ingredient, calculates their efficiency, and adds to results table.
function recycleResults(nrec,recipe)
	local nrecData = data.raw.recipe[nrec]
	if recipe.ingredients then
		for _, ingred in pairs(recipe.ingredients) do
			if not (ingred.type == "fluid") then	-- always add if not a fluid
				local newResult = calculateEfficiency(ingred)
				table.insert(nrecData.results, newResult)
			elseif (ingred.type == "fluid") and rf.solidfluids then -- only add fluid if enabled
				-- check if already added
				if data.raw.item["solid-"..ingred.name] then
					goto continue
				end
				-- then check if blacklisted for any reason
				for _, blacklisted in pairs(fluidBlacklist) do
					if ingred.name == blacklisted then -- if match, fluid is blacklisted
						goto continue  -- so immediately exit all loops and skip to below
					end
				end
				if data.raw.fluid[ingred.name] then
					makeFluidItem(data.raw.fluid[ingred.name]) -- if no match, create fluid item
					log('Created new fluid item: '..ingred.name)
				else
					log('Unable to create fluid item: '..ingred.name..
					", which appeared in this recipe: "..recipe.name)
				end
				::continue::
				local newResult = calculateEfficiency(ingred)
				table.insert(nrecData.results, newResult)
			end
		end
	end
end

function calculateEfficiency(ingred)
	-- This efficiency calculation is a simplified version of the official recycler
	--  but it uses a user-defined value, instead of a static 1/4 (25%)
	local efficiency = rf.efficiency
	if ingred.type then
		local remainder = ingred.amount % efficiency
		local final_amount = ingred.amount / efficiency
		local final_extra_fraction = remainder / efficiency
		local newName = ingred.name
		local newType = ingred.type
		if string.match(ingred.type,"fluid") then
			--Fluid ingredients are generally 10 times denser than solid ingrdedients
			-- so we compress the solid by a factor of 10 by default
			newName = "solid-"..ingred.name
			remainder = ingred.amount / 10 % efficiency
			final_amount = ingred.amount / 10 / efficiency
			final_extra_fraction = remainder / efficiency
			if ingred.name == "water" or ingred.name == "steam" then
				if mods["space-age"] then
					--Steam is 1:1 water efficient, but 1 water = 20 ice
					-- so we compress these by 20 instead of the usual 10
					remainder = ingred.amount / 20 % efficiency
					final_amount = ingred.amount / 20 / efficiency
					final_extra_fraction = remainder / efficiency
					newName = "ice"
				else
					newName = "solid-water"
				end
			end
			if ingred.name == "fluoroketone-hot" then -- fluoroketone
				--If hot fluoroketone is ever used in a recipe
				-- make it become solid cold instead
				newName = "solid-fluoroketone-cold"
			end
			if string.match(ingred.name,"molten") then
				--Molten metals have a 1:10 solid to fluid ratio
				-- so no number changes required, just becomes plate instead
				if string.match(ingred.name,"iron") then
					newName = "iron-plate"
				elseif string.match(ingred.name,"copper") then
					newName = "copper-plate"
				elseif string.match(ingred.name,"tungsten") then
					newName = "tungsten-plate"
				end
			end
		end
		newResult = {type="item", name=newName, amount=final_amount, extra_count_fraction=final_extra_fraction}
		--Check for non-stackable items and set max result amount to 1
		if checkNonStackable(newResult.name) or checkForGrids(newResult.name) then
			newResult.amount = math.min(1, newResult.amount)
		end
	end
	return newResult
end

--Ensure that t2 recyclers make enough room for t1 and t2 recipes, and so on for each tier.
function fixMaxResults(nrec,rfCategory)
	local nrecData = data.raw.recipe[nrec]
	if rfCategory == "recycle-products" then
		rf.maxResults[1] = math.max(rf.maxResults[1],#nrecData.results)
	elseif rfCategory == "recycle-intermediates" then
		rf.maxResults[2] = math.max(rf.maxResults[2],#nrecData.results)
	elseif rfCategory == "recycle-productivity" then
		rf.maxResults[3] = math.max(rf.maxResults[3],#nrecData.results)
	end
	rf.maxResults[2] = math.max(rf.maxResults[1],rf.maxResults[2])
	rf.maxResults[3] = math.max(rf.maxResults[1],rf.maxResults[2],rf.maxResults[3])
end

function checkForGrids(ingredient)
	local possibleGrid = false
	if data.raw.armor[ingredient] then
		if data.raw.armor[ingredient].equipment_grid then
			possibleGrid = true
		end
	end
	if data.raw.car[ingredient] then
		if data.raw.car[ingredient].equipment_grid then
			possibleGrid = true
		end
	end
	if data.raw["spider-vehicle"][ingredient] then
		if data.raw["spider-vehicle"][ingredient].equipment_grid then
			possibleGrid = true
		end
	end
	return possibleGrid
end

function checkNonStackable(ingredient)
	local nonStackable = false
	if data.raw.item[ingredient] and data.raw.item[ingredient].flags then
		for _, flag in pairs(data.raw.item[ingredient].flags) do
			if flag == "not-stackable" then
				nonStackable = true
				break
			end
		end
	end
	return nonStackable
end

-- This section dedicated to recycled fluids as solid items handling
function makeFluidItem(fluid)
	local fluidName = fluid.name or rf.debug(fluid)
	--if fluidName == "fluoroketone-cold" then error("TEST") end
	local iconSize = fluid.icon_size or 64
	local new_item = {
		type = "item",
		name = "solid-"..fluidName,
		icons = {  -- placeholder fluid icon
			{icon = "__reverse-factory__/graphics/fluid/default.png", icon_size = 64},
		},
		subgroup = "fluid-items",
		order = Data(fluid,"fluid"):get_field("order") or "z",
		stack_size = 50,
		weight = 1 * kg,
		hidden_in_factoriopedia = true,
		localised_name = {"item-name.reverse-factory-fluids", {"fluid-name."..fluidName}}
	}
	if mods["space-age"] then
		-- also using the ice sound effects from space age
		local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")
		new_item.inventory_move_sound = space_age_item_sounds.ice_inventory_move
		new_item.pick_sound = space_age_item_sounds.ice_inventory_pickup
		new_item.drop_sound = space_age_item_sounds.ice_inventory_move
	end
	if fluid.icons then
		for _, added_icon in pairs (fluid.icons) do
			-- we assume that added_icon is just the fluid
			local extra_icon = Table.deepcopy(added_icon)
			extra_icon.scale = (extra_icon.scale or 0.5) * 0.9
			table.insert(new_item.icons,extra_icon)
		end
	elseif fluid.icon then
		local iconFile = fluid.icon
		local iconSize = fluid.icon_size or 64
		local iconScale = fluid.scale or 0.5
		table.insert(new_item.icons,{icon=iconFile,icon_size=iconSize,scale=iconScale})
	end
	data:extend({new_item})
	makeFluidRecipe(fluid)
	log("item: "..fluidName.."\n"..serpent.block(data.raw.item[fluidName]))
end

function makeFluidRecipe(fluid)
	local fluidName = fluid.name
	local iconSize = fluid.icon_size or 64
	local new_recipe = {
		type = "recipe",
		name = fluid.name.."-melting",
		icons = {
			{icon = "__reverse-factory__/graphics/recipe/default.png", icon_size = 64},
		},
		subgroup = "solids-into-fluids",
		category = "solids-into-fluids",
		order = Data(fluid,"fluid"):get_field("order") or "z",
		energy_required = 0.25,
		ingredients = {
			{type="item",name="solid-"..fluid.name, amount=1}
		},
		results = {
			{type="fluid",name=fluid.name,amount=10}
		},
		allow_productivity = false,
		allow_decomposition = false,
		allow_as_intermediate = false,
		hide_from_player_crafting = true,
		hidden_in_factoriopedia = true,
		localised_name = {"recipe-name.solid-into-fluid", {"fluid-name."..fluidName}},
		crafting_machine_tint = -- copied from space-age coal-synthesis
		{
		  primary = {r = 0.207, g = 0.177, b = 0.177, a = 1.000}, -- #342d2dff
		  secondary = {r = 0.301, g = 0.276, b = 0.196, a = 1.000}, -- #4c4632ff
		  tertiary = {r = 0.790, g = 0.722, b = 0.478, a = 1.000}, -- #c9b879ff
		  quaternary = {r = 0.554, g = 0.540, b = 0.540, a = 1.000}, -- #8d8989ff
		}
	}
	if fluid.icons then
		for _, added_icon in pairs (fluid.icons) do
			-- we assume that added_icon is just the fluid
			local extra_icon = table.deepcopy(added_icon)
			extra_icon.scale = (extra_icon.scale or 0.5) * 0.7
			-- then we apply the melting/freezing icon on top of them both
			local melting = {icon = "__reverse-factory__/graphics/icon/melting.png", icon_size = 64}
			table.insert(new_recipe.icons,extra_icon)
			table.insert(new_recipe.icons,melting)
		end
	elseif fluid.icon then
		local iconFile = fluid.icon
		local iconSize = fluid.icon_size or 64
		local iconScale = fluid.scale or 0.5
		local melting = {icon = "__reverse-factory__/graphics/icon/melting.png", icon_size = 64}
		table.insert(new_recipe.icons,{icon=iconFile,icon_size=iconSize,scale=iconScale,shift={0,4}})
		table.insert(new_recipe.icons,melting)
	end
	data:extend({new_recipe})
	log("recipe: "..fluidName.."\n"..serpent.block(data.raw.recipe[fluidName]))
end

function overrideFluidIcon(fluidName)
	local solidName = "solid-"..fluidName
	local recipeName = fluidName.."-melting"
	local solidFilename = "__reverse-factory__/graphics/fluid/"..fluidName..".png"
	local recipeFilename = "__reverse-factory__/graphics/recipe/"..fluidName..".png"
	if data.raw.item[solidName] then
		data.raw.item[solidName].icons[1].icon = solidFilename
	end
	if data.raw.recipe[recipeName] then
		data.raw.recipe[recipeName].icons[1].icon = recipeFilename
	end
end

function overrideFluidTint(fluidName)
	local recipeName = fluidName.."-melting"
	-- if recipe does not exist, something went wrong but this prevents an error on load
	if not data.raw.recipe[recipeName] then return end
	if string.match(fluidName,"heavy") and string.match(fluidName,"oil") then
		local tint = data.raw.recipe["solid-fuel-from-heavy-oil"].crafting_machine_tint
		data.raw.recipe[recipeName].crafting_machine_tint = tint
	end
	if string.match(fluidName,"light") and string.match(fluidName,"oil") then
		local tint = data.raw.recipe["solid-fuel-from-light-oil"].crafting_machine_tint
		data.raw.recipe[recipeName].crafting_machine_tint = tint
	end
	if string.match(fluidName,"petroleum") and string.match(fluidName,"gas") then
		local tint = data.raw.recipe["solid-fuel-from-petroleum-gas"].crafting_machine_tint
		data.raw.recipe[recipeName].crafting_machine_tint = tint
	end
	--If petroleum, use light
	if string.match(fluidName,"sulfuric") and string.match(fluidName,"acid") then
		local tint = data.raw.recipe["light-oil-cracking"].crafting_machine_tint
		data.raw.recipe[recipeName].crafting_machine_tint = tint
	end
	if string.match(fluidName,"lubricant")  then
		local tint = data.raw.recipe["lubricant"].crafting_machine_tint
		data.raw.recipe[recipeName].crafting_machine_tint = tint
	end
	if string.match(fluidName,"thruster") and string.match(fluidName,"fuel") then
		local tint = data.raw.recipe["advanced-thruster-fuel"].crafting_machine_tint
		data.raw.recipe[recipeName].crafting_machine_tint = tint
	end
	if string.match(fluidName,"thruster") and string.match(fluidName,"oxidizer") then
		local tint = data.raw.recipe["advanced-thruster-oxidizer"].crafting_machine_tint
		data.raw.recipe[recipeName].crafting_machine_tint = tint
	end
end

function overrideFluidRecipe(fluidName)
	local recipeName = fluidName.."-melting"
	if string.match(fluidName,"thruster") and string.match(fluidName,"fuel") then
		local subgroup = data.raw.recipe["advanced-thruster-fuel"].subgroup
		local order = data.raw.recipe["advanced-thruster-fuel"].order
		data.raw.recipe[recipeName].subgroup = subgroup
		data.raw.recipe[recipeName].order = order.."-1"
		data.raw.recipe[recipeName].surface_conditions = surface_conditions
	end
	if string.match(fluidName,"thruster") and string.match(fluidName,"oxidizer") then
		local subgroup = data.raw.recipe["advanced-thruster-oxidizer"].subgroup
		local order = data.raw.recipe["advanced-thruster-oxidizer"].order
		data.raw.recipe[recipeName].subgroup = subgroup
		data.raw.recipe[recipeName].order = order.."-1"
		data.raw.recipe[recipeName].surface_conditions = surface_conditions
	end
end

--[[
function removeFromAllTechs(recipe)
	tech = seekTech(recipe)
	while tech do
		Recipe(recipe):remove_unlock(tech)
		tech = seekTech(recipe)
	end
end

function seekTech(recipe)
	for _, tech in pairs(data.raw.technology) do
		if tech.effects and (not string.find(tech.name, "demo-")) then
			for _, effect in pairs (tech.effects) do
				if recipe == effect.recipe then
					return tech.name
				end			
			end
		end
	end
end
]]--

function strReplace(str, what, with)
    what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
    with = string.gsub(with, "[%%]", "%%%%") -- escape replacement
    return string.gsub(str, what, with)
end

function nulliusRecycling()
	for n = 1,4 do
		oldRecipe = "reverse-factory-"..n
		newRecipe = "nullius-reverse-factory-"..n
		Data(oldRecipe, "item"):krycopy(newRecipe)
		Data(oldRecipe, "recipe"):krycopy(newRecipe)
		Data(oldRecipe, "technology"):krycopy(newRecipe)
		Data(oldRecipe, "furnace"):krycopy(newRecipe)
		Data(newRecipe, "item"):set_field("order", "nullius-dd")
		Data(newRecipe, "technology"):set_field("order", "nullius-dd")
		Data(newRecipe, "technology"):set_field("effects",
		{
			{
			  type = "unlock-recipe",
			  recipe = "nullius-reverse-factory-"..n,
			}
		})
		if n > 1 then
			Data(newRecipe, "technology"):set_field("prerequisites",
			{"nullius-reverse-factory-"..(n-1)})
		end
	end
end

function shorten248k (itemName)
	recipeName = string.gsub(itemName,"_item","_recipe")
	--val = string.strfind(itemName,"-item")
	--recipeName = strsub(itemName, 0, val)
	return recipeName
end









