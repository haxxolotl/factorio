local Data = require('__kry_stdlib__/stdlib/data/data')
local Recipe = require('__kry_stdlib__/stdlib/data/recipe')
local Technology = require('__kry_stdlib__/stdlib/data/technology')
local Debug = require('__kry_stdlib__/stdlib/utils/debug')

-- early exit script if setting is disabled or solid fluids mod is enabled
if not rf.solidfluids then return end
if mods["kry-solid-fluids"] then return end

--Overrides default gray fluid icons with custom ones (only for vanilla/space age)
local customFluidIcons = {"crude-oil","heavy-oil","light-oil","petroleum-gas","lubricant","sulfuric-acid"}
--Override default crafting machine tint with ones copied from vanilla/space age
local customFluidTints = {"crude-oil","heavy-oil","light-oil","petroleum-gas","lubricant","sulfuric-acid"}
--Override default recipe conditions with ones copied from space age (none in vanilla so far)
local customFluidRecipe = {}

--Add space age exclusive fluids to the override lists
if mods["space-age"] then
	-- Custom Icons
	table.insert(customFluidIcons,"electrolyte")
	table.insert(customFluidIcons,"holmium-solution")
	table.insert(customFluidIcons,"ammoniacal-solution")
	table.insert(customFluidIcons,"ammonia")
	table.insert(customFluidIcons,"lithium-brine")
	table.insert(customFluidIcons,"fluoroketone-cold")
	-- Custom Tints
	--table.insert(customFluidTints,"thruster-fuel")
	--table.insert(customFluidTints,"thruster-oxidizer")
	--table.insert(customFluidRecipe,"thruster-fuel")
	--table.insert(customFluidRecipe,"thruster-oxidizer")
else
	table.insert(customFluidIcons,"water")
end

-- Makes item versions of every non-blacklisted fluid in the game
for _, fluid in pairs(data.raw.fluid) do
	local blacklisted = false
	for _, name in pairs(rf.nofluid_items) do
		if fluid.name==name then
			blacklisted = true
		end
	end
	if not blacklisted then
		if not fluid.hidden then
			makeFluidItem(fluid)
		end
	end
end

--Update the fluids
for _, fluid in pairs(customFluidIcons) do
	overrideFluidIcon(fluid)
end
for _, fluid in pairs(customFluidTints) do
	overrideFluidTint(fluid)
end
for _, fluid in pairs(customFluidRecipe) do
	overrideFluidRecipe(fluid)
end

local function addCraftingCategory(entity_name, entity_types, category)
	for _, entity_type in pairs(entity_types) do
		local entity = Data(entity_name, entity_type)
		if entity:is_valid() then
			entity.crafting_categories = entity.crafting_categories or {}
			for _, existing_category in pairs(entity.crafting_categories) do
				if existing_category == category then
					return true
				end
			end
			table.insert(entity.crafting_categories, category)
			return true
		end
	end
	return false
end

-- Add the fluid conversion recipes to the auto-barreling machines below
if mods["auto-barrel"] then
	addCraftingCategory("unbarreling-machine", {"furnace"}, "solids-into-fluids")
end
if mods["fct-barreling-machine"] then
	addCraftingCategory("barreling-machine", {"furnace"}, "solids-into-fluids")
end
if mods["pelagos"] then
	-- Older Pelagos versions used "barreling-machine"; newer ones use barreling_machines entities.
	addCraftingCategory("barreling-machine", {"furnace", "assembling-machine"}, "solids-into-fluids")
	addCraftingCategory("burner-barreling-machine", {"assembling-machine"}, "solids-into-fluids")
	addCraftingCategory("electric-barreling-machine", {"assembling-machine"}, "solids-into-fluids")
	addCraftingCategory("diesel-barreling-machine", {"assembling-machine"}, "solids-into-fluids")
	-- if Pelagos enabled, barreling machine is locked behind another planet
	-- so we should just allow solid fluids in chemical plants regardless
	rf.allow_chemplant = true
end
-- This is always true when above mods are not installed
if rf.allow_chemplant then
	-- Check all assembling machines, if chemical plant, add solid-fluid recipe category
	for name, _ in pairs(data.raw["assembling-machine"]) do
		if string.find(name,"chemical-plant",1,true) then
			table.insert(Data(name,"assembling-machine").crafting_categories, "solids-into-fluids")
		end
	end
end

--Debug.error(data.raw.item["rf-solid-fluorine"])
--Debug.error(data.raw.recipe["lava-cake"])