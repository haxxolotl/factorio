--Data contains all functions contained in the Factorio stdlib
local Data = require('__kry_stdlib__/stdlib/data/data')
local Recipe = require('__kry_stdlib__/stdlib/data/recipe')
local Tech = require('__kry_stdlib__/stdlib/data/technology')

--Game should be mostly vanilla at this point
if rf.mods ~= "DIR3" then
	--t1 = 10 plate, 7 gears, 5 green circs, 2 assembler t1's
	--t2 = 10 pipe, 7 steel, 5 green circs, 1 chem plant, 1 assembler t2, + previous tier
	Recipe("reverse-factory-2"):replace_ingredient("iron-plate","pipe")
	Recipe("reverse-factory-2"):replace_ingredient("iron-gear-wheel","steel-plate")
	Recipe("reverse-factory-2"):replace_ingredient("assembling-machine-1","chemical-plant",1)
	Recipe("reverse-factory-2"):add_ingredient({name="assembling-machine-2",amount=1,type="item"})
	--t3 = 10 stone brick, 7 steel, 5 red circs, 2 elec furnaces, + previous tier
	Recipe("reverse-factory-3"):replace_ingredient("iron-plate","stone-brick")
	Recipe("reverse-factory-3"):replace_ingredient("iron-gear-wheel","steel-plate")
	Recipe("reverse-factory-3"):replace_ingredient("electronic-circuit","advanced-circuit")
	Recipe("reverse-factory-3"):replace_ingredient("assembling-machine-1","electric-furnace")
	-- add modules to recipe and tech requirements if allowed effects
	if rf.modules == "productivity" or rf.modules == "both" then
		Recipe("reverse-factory-3"):add_ingredient({name="productivity-module",amount=2,type="item"})
		Tech("reverse-factory-3"):add_prereq("productivity-module")
	end
	if rf.modules == "quality" or rf.modules == "both" then
		if not mods["no-quality"] then
			if mods["unquality"] and not settings.startup["unquality-modules"].value and not settings.startup["unquality-technology"].value then
				Recipe("reverse-factory-3"):add_ingredient({name="quality-module",amount=2,type="item"})
				Tech("reverse-factory-3"):add_prereq("quality-module")
			end
		end
	end
	-- tech changes
	Tech("reverse-factory-1"):add_prereq("automation")
	Tech("reverse-factory-2"):add_prereq("automation-2")
	Tech("reverse-factory-2"):add_prereq("oil-processing")
	Tech("reverse-factory-3"):add_prereq("advanced-material-processing-2")
	-- Sets the science cost to the desired prereq tech, then increases the cost a bit
	if Tech("reverse-factory-1"):copy_cost("automation") then
		Tech("reverse-factory-1"):multiply_cost(2)
	end
	if Tech("reverse-factory-2"):copy_cost("automation-2") then
		Tech("reverse-factory-2"):multiply_cost(2)
	end
	if Tech("reverse-factory-3"):copy_cost("advanced-material-processing-2") then
		Tech("reverse-factory-3"):multiply_cost(2)
	end
end

--Only one of the below conditions will ever be true at one time.
--Priority follows what is set under data.lua, so intercompatibility is not guaranteed

--If bobs intermediates is detected, then check if these items exist, and replace ingredients.
if rf.mods == "bobplates" then
	--t1 = 10 plate, 7 gears, 5 wood circs, 2 assembler t1's
	if data.raw.item["bob-basic-circuit-board"] then
		Recipe("reverse-factory-1"):rep_ing("electronic-circuit","bob-basic-circuit-board")
	end
	--t2 = 10 steel pipe, 7 steel gears, 5 green circs, 1 chem plant, 1 assembler t2, + previous
	if data.raw.item["steel-gear-wheel"] then
		Recipe("reverse-factory-2"):replace_ingredient("steel-plate","bob-steel-gear-wheel")
	end
	if data.raw.item["bob-steel-pipe"] then
		Recipe("reverse-factory-2"):replace_ingredient("pipe","bob-steel-pipe")
	end
	if data.raw.technology["bob-chemical-plant"] then
		Tech("reverse-factory-2"):remove_prereq("oil-processing")
		Tech("reverse-factory-2"):add_prereq("bob-chemical-plant")
	end
	--t3 = 10 stone brick, 7 titanium, 5 red circs, 1 elec furnace, 1 assembler t3, + previous tier
	Recipe("reverse-factory-3"):replace_ingredient("stone-brick","refined-concrete", 10)
	Tech("reverse-factory-3"):add_prereq("concrete")
	if data.raw.item["bob-titanium-plate"] then
		Recipe("reverse-factory-3"):replace_ingredient("steel-plate","bob-titanium-plate")
	end
	if mods["bobassembly"] then
		Recipe("reverse-factory-3"):multiply_ingredient("electric-furnace",0.5)
		Recipe("reverse-factory-3"):add_ingredient({name="assembling-machine-3",amount=1,type="item"})
		Tech("reverse-factory-3"):add_prereq("automation-3")
	end
end

if rf.mods == "DIR3" then
	Recipe("reverse-factory-1"):copy_ingredients("assembling-machine-1")
	--Recipe("reverse-factory-1"):add_ingredient("assembling-machine-1")
	
	Recipe("reverse-factory-2"):copy_ingredients("assembling-machine-2")
	Recipe("reverse-factory-2"):add_ingredient({name="reverse-factory-1",amount=1,type="item"})
	
	Recipe("reverse-factory-3"):copy_ingredients("assembling-machine-3")
	Recipe("reverse-factory-3"):add_ingredient({name="reverse-factory-2",amount=1,type="item"})
	
	Recipe("reverse-factory-4"):copy_ingredients("laser-assembler")
	Recipe("reverse-factory-4"):remove_ingredient("assembling-machine-3")
	Recipe("reverse-factory-4"):add_ingredient({name="reverse-factory-3",amount=1,type="item"})
	
	Tech("reverse-factory-1"):add_prereq("automation")
	Tech("reverse-factory-2"):add_prereq("automation-2")
	Tech("reverse-factory-3"):add_prereq("automation-3")
	Tech("reverse-factory-4"):add_prereq("automation-4")

	Tech("reverse-factory-1"):set_field("unit",Tech("automation"):get_field("unit"))
	Tech("reverse-factory-2"):set_field("unit",Tech("automation-2"):get_field("unit"))
	Tech("reverse-factory-3"):set_field("unit",Tech("automation-3"):get_field("unit"))
	Tech("reverse-factory-4"):set_field("unit",Tech("automation-4"):get_field("unit"))
end

--rf.debug(data.raw.recipe["assembling-machine-1"])
--rf.debug(data.raw.technology["automation"])







