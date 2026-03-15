local Data = require('__kry_stdlib__/stdlib/data/data')
local Recipe = require('__kry_stdlib__/stdlib/data/recipe')
local Technology = require('__kry_stdlib__/stdlib/data/technology')
local Debug = require('__kry_stdlib__/stdlib/utils/debug')

-- List of recipes that need to be manually added to the list
--  These technically could/should be added by the original mod author
--  but it's faster and eaaier to add them myself.
require("prototypes/added_manual_recipes")

-- moved up from data-updates for compatibility with PyMods
if mods["pypostprocessing"] then
	require("prototypes.solid-fluids")
end

--This function can be prevented from running by using "rf.prevent_final_fixes()" in data.lua
--DO NOT USE THIS FUNCTION IN YOUR MOD- DOWNLOAD reverse-factory-postprocess INSTEAD
function rf.final_fixes()

--List of item types to be recycled
local itemTypes = { --removed fluids from the list for now
	"ammo","armor","item","rail-planner","gun","capsule","module","tool","repair-tool","item-with-entity-data"--,"fluid"
}

--Automatic reverse recipe creation
for _, itemType in pairs(itemTypes) do
	addRecipes(itemType, data.raw[itemType])
end

--Manual recipes added
for _, recycle in pairs(rf.custom_recycle) do
	local itemType = recycle[1]
	local item = data.raw[itemType][recycle[2]]
	local recipe = data.raw.recipe[recycle[3]]
	makeRecipe(itemType, item, recipe)
	log("manual recipe added: "..item.name)
end

-- Additional mod compatibility scripts for other mods
require('mod-compat/power-armor-final-fixes')
require('mod-compat/scrappy-final-fixes')
require('mod-compat/space-age-final-fixes')

--Fix required for Factorio 2.0, to allow early recycling of barrels.
if Recipe("rf-barrel"):is_valid() then
	Recipe("rf-barrel").category = "recycle-products"
end

for n=1,3 do
	data.raw["furnace"]["reverse-factory-"..n].result_inventory_size = rf.maxResults[n]
	if mods["nullius"] then
		data.raw["furnace"]["nullius-reverse-factory-"..n].result_inventory_size = rf.maxResults[n]
	end
	-- also apply the changes to mini reverse factory
	if mods["mini-machines"] then
		if mini.rf then
		data.raw["furnace"]["mini-reverse-factory-"..n].result_inventory_size = rf.maxResults[n]
		end
	end
	-- also apply the changes to micro reverse factory
	if mods["micro-machines"] then
		if micro.rf then
		data.raw["furnace"]["micro-reverse-factory-"..n].result_inventory_size = rf.maxResults[n]
		end
	end
end
end

if not rf.prevented_final_fixes then
	rf.final_fixes()
end

--Debug.error(data.raw.item["rf-solid-fluorine"])
--Debug.error(data.raw.recipe["lava-cake"])