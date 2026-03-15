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
-- Add the fluid conversion recipes to the auto-barreling machines below
if mods["auto-barrel"] then
	table.insert(Data("unbarreling-machine","furnace").crafting_categories,"solids-into-fluids")
end
if mods["fct-barreling-machine"] then
	table.insert(Data("barreling-machine","furnace").crafting_categories,"solids-into-fluids")
end
if mods["pelagos"] then
	-- Pelagos may update in future (hopefully!) to make barreling machine a furnace-type entity
	local entity_type = "furnace"
	if not Data("barreling-machine", entity_type):is_valid() then
		entity_type = "assembling-machine"
	end
	table.insert(Data("barreling-machine",entity_type).crafting_categories,"solids-into-fluids")
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