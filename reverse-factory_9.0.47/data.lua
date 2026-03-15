rf = {}
rf.recipes = {}
--Defines balance settings, default is vanilla
if string.match(settings.startup["rf-balance"].value,"vanilla") then
	rf.efficiency = 4		--25%
	rf.percent_efficiency = 25
	rf.prodgate = true	-- prod loop gated behind tier 3 machines
	rf.undonerf = false
	if mods["quality"] then
		rf.modules = "quality"
	else
		rf.modules = "none"
	end
	if mods["space-age"] then
		rf.craft_limit = "nauvis"
		rf.place_limit = "nauvis, gleba, aquilo"
	end
--If no balance whatsover
elseif string.match(settings.startup["rf-balance"].value,"no") then
	rf.efficiency = 1		--100%
	rf.percent_efficiency = 100
	rf.prodgate = false		-- all ingredients can be recycled at any tier
	rf.undonerf = true
	if mods["quality"] then
		rf.modules = "both"
	else
		rf.modules = "productivity"
	end
	if mods["space-age"] then
		rf.craft_limit = "no restrictions"
		rf.place_limit = "no restrictions"
	end
--Otherwise, set user-defined balance
else
	rf.efficiency = 100/settings.startup["rf-efficiency"].value
	rf.percent_efficiency = settings.startup["rf-efficiency"].value
	rf.prodgate = settings.startup["rf-intermediates"].value
	rf.modules = settings.startup["rf-modules"].value
	rf.undonerf = settings.startup["rf-revert-modules"].value
	if mods["space-age"] then
		rf.craft_limit = settings.startup["rf-craft-limit"].value
		rf.place_limit = settings.startup["rf-place-limit"].value
	end
end
-- If this setting does not exist, it's because Solid Fluids mod exists
if settings.startup["rf-solid-fluids"] then
	rf.solidfluids = settings.startup["rf-solid-fluids"].value
else rf.solidfluids = true
end
if settings.startup["rf-allow-chemplant"] then
	rf.allow_chemplant = settings.startup["rf-allow-chemplant"].value
else rf.allow_chemplant = true
end
rf.norecycle_items = {}
rf.nofluid_items = {}
rf.norecycle_categories = {}
rf.norecycle_subgroups = {}
rf.custom_recycle = {}  --Format of {item-type, item-name, recipe-name}
rf.maxResults = {5,5,5,5}
rf.mod248k = false
--Setup for the reverse factory item, entity, recipe, and technology
require("prototypes.pipe-covers")
require("prototypes.reverse-factory")
--Setup for the reverse recipe groups and categories
require("prototypes.catgroups")
--Insantiating tables needed for the rest of the mod to function

--Prevents this mod's data-final-fixes from fully loading
rf.prevented_final_fixes = false
--If another mod lists this mod as an optional dependency (space-exploration-postprocess)
--Allows them to prevent this mod from loading, by running this in their data.lua
--Then, they can run this mod's final-fixes during their own final-fixes via "rf.final_fixes()"
--DO NOT USE THIS FUNCTION - DOWNLOAD reverse-factory-postprocess INSTEAD
function rf.prevent_final_fixes()
	rf.prevented_final_fixes = true
end

--If certain mods are detected, change some recipes later
if mods ["nullius"] then
	rf.mods = "nullius"
elseif mods["bobplates"] then
	rf.mods = "bobplates"
elseif mods["IndustrialRevolution"] then
	rf.mods = "DIR"
elseif mods["IndustrialRevolution3"] then
	rf.mods = "DIR3"
elseif mods["Fantario"] then
	rf.mods = "fantario"
elseif mods["bobassembly"] then
	rf.mods = "bobassembly"
end
if mods ["248k"] then
	rf.mod248k = true
end

--This is where the magic happens
require('func')

--[[
    Construction Drones adds equipment grid to light armor
    This prevents light armor from being used in reverse recipe
    Robot Army uses light armor in droid-flame recipe
    Therefore, remove droid-flame recipe from being recycled in only this case
]]--
if mods["Construction_Drones"] and mods["robotarmy"] then
	table.insert(rf.norecycle_items, "droid-flame")
end
--Attach notes creates item version of this fluid, which does not have a canon recipe
if mods["bobplates"] and mods["attach-notes"] then
	table.insert(rf.norecycle_items, "heavy-water")
end
if mods["warptorio2"] then
	table.insert(rf.norecycle_items, "warptorio-armor")
end
if mods["anarchy"] then
	table.insert(rf.norecycle_items, "ultra-armor")
end
if mods["spaceblock"] then
	table.insert(rf.norecycle_items, "coal")
	table.insert(rf.norecycle_items, "copper-ore")
	table.insert(rf.norecycle_items, "iron-ore")
	table.insert(rf.norecycle_items, "stone")
	table.insert(rf.norecycle_items, "uranium-ore")
end
if mods["homeworld_redux"] then
	table.insert(rf.norecycle_categories, "seeder")
	table.insert(rf.norecycle_categories, "terraformer")
end
if mods ["pyhardmode"] then
	table.insert(rf.norecycle_items, "sweater")
end
if mods ["alkashGun"] then
	table.insert(rf.norecycle_items, "k-o")
end
if mods ["nullius"] then
	nulliusRecycling()
end

-- Prevent duplication of crushed stone
table.insert(rf.norecycle_items, "stone-crushed")

-- Prevent duplication of scrap recipes
table.insert(rf.norecycle_subgroups, "smelting_fantario")

-- Prevent recycling of barrels when solid fluids enabled
if rf.solidfluids then
	table.insert(rf.norecycle_subgroups, "fill-barrel")
	table.insert(rf.norecycle_subgroups, "empty-barrel")
end

--table.insert(rf.norecycle_subgroups, "petrochem-catalysts")
table.insert(rf.norecycle_categories, "seed-extractor")
table.insert(rf.norecycle_categories, "fu_tokamak_reactor_crafting_category")

--Prevent these fluids from becoming items
for n=0,9 do
	table.insert(rf.nofluid_items, "parameter-"..n)
end
table.insert(rf.nofluid_items, "steam")
--These hidden fluids are ignored by default now
--table.insert(rf.nofluid_items, "fluid-unknown")
--table.insert(rf.nofluid_items, "ee-super-pump-speed-fluid")

--Disable water if space age is detected, use ice instead
if mods["space-age"] then
	table.insert(rf.nofluid_items,"water")
	table.insert(rf.nofluid_items,"lava")
	table.insert(rf.nofluid_items,"molten-iron")
	table.insert(rf.nofluid_items,"molten-copper")
	table.insert(rf.nofluid_items,"thruster-fuel")
	table.insert(rf.nofluid_items,"thruster-oxidizer")
	table.insert(rf.nofluid_items,"fusion-plasma")
	--table.insert(rf.nofluid_items,"fluorine")
	table.insert(rf.nofluid_items,"fluoroketone-hot")
end

--Examples for adding custom recipes to reverse-factory, for external mod use.
--table.insert(rf.custom_recycle, {"item", "droid-smg-dummy", "droid-smg-deploy"})
--table.insert(rf.custom_recycle, {"item", "terminator-dummy", "terminator-deploy"})