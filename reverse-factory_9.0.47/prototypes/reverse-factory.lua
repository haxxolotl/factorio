local item_sounds = require("__base__.prototypes.item_sounds")

local crafting_restrictions = {}
local placement_restrictions = {}
if mods["space-age"] then
	if rf.craft_limit == "nauvis" then
		crafting_restrictions = {
			{
				property = "pressure",
				min = 1000,	-- Nauvis only
				max = 1000
			}
		}
	elseif rf.craft_limit == "nauvis, gleba" then
		crafting_restrictions = {
			{
				property = "pressure",
				min = 1000,	-- Nauvis
				max = 2000	-- Gleba
			}
		}
	elseif rf.craft_limit == "nauvis, gleba, aquilo" then
		crafting_restrictions = {
			{
				property = "pressure",
				min = 300,	-- Aquilo, Nauvis (1000)
				max = 2000	-- Gleba
			},
			{
				property = "magnetic-field",
				max = 95	-- excludes Fulgora's 800 pressure
			}
		}
	elseif rf.craft_limit == "nauvis, gleba, vulcanus" then
		crafting_restrictions = {
			{
				property = "pressure",
				min = 1000,	-- Nauvis, Gleba (2000)
				max = 4000	-- Vulcanus
			}
		}
	elseif rf.craft_limit == "nauvis, gleba, aquilo, vulcanus" then
		crafting_restrictions = {
			{
				property = "pressure",
				min = 300,	-- Aquilo, Nauvis (1000)
				max = 4000	-- Gleba (2000), Vulcanus
			},
			{
				property = "magnetic-field",
				max = 95	-- excludes Fulgora's 800 pressure
			}
		}
	elseif rf.craft_limit == "all planets" then
		crafting_restrictions = {
			{
				property = "gravity",
				min = 1		-- excludes space only
			}
		}
	else -- no crafting restrictions, no need to change anything
	end
	
	if rf.place_limit == "nauvis" then
		placement_restrictions = {
			{
				property = "pressure",
				min = 1000,	-- Nauvis only
				max = 1000
			}
		}
	elseif rf.craft_limit == "nauvis, gleba" then
		placement_restrictions = {
			{
				property = "pressure",
				min = 1000,	-- Nauvis
				max = 2000	-- Gleba
			}
		}
	elseif rf.craft_limit == "nauvis, gleba, aquilo" then
		placement_restrictions = {
			{
				property = "pressure",
				min = 300,	-- Aquilo, Nauvis (1000)
				max = 2000	-- Gleba
			},
			{
				property = "magnetic-field",
				max = 95	-- excludes Fulgora's 800 pressure
			}
		}
	elseif rf.craft_limit == "nauvis, gleba, vulcanus" then
		placement_restrictions = {
			{
				property = "pressure",
				min = 1000,	-- Nauvis, Gleba (2000)
				max = 4000	-- Vulcanus
			}
		}
	elseif rf.craft_limit == "nauvis, gleba, aquilo, vulcanus" then
		placement_restrictions = {
			{
				property = "pressure",
				min = 300,	-- Aquilo, Nauvis (1000)
				max = 4000	-- Gleba (2000), Vulcanus
			},
			{
				property = "magnetic-field",
				max = 95	-- excludes Fulgora's 800 pressure
			}
		}
	elseif rf.craft_limit == "all planets" then
		placement_restrictions = {
			{
				property = "gravity",
				min = 1		-- excludes space only
			}
		}
	else -- no placement restrictions, no need to change anything
	end
	
end

local function rfItem(n)
	local item = {
		type = "item",
		name = "reverse-factory-"..n,
		icon = "__reverse-factory__/graphics/item/reverse-factory-"..n..".png",
		icon_size = 32,
		subgroup = "smelting-machine",
		order = "d[reverse-factory]-"..n,
		inventory_move_sound = item_sounds.electric_large_inventory_move,
		pick_sound = item_sounds.electric_large_inventory_pickup,
		drop_sound = item_sounds.electric_large_inventory_move,
		place_result = "reverse-factory-"..n,
		stack_size = 10
	}
	if mods["ShinyBobGFX"] then
		if settings.startup["add-powerbars"].value then
			item.icons = {
				{icon = "__reverse-factory__/graphics/item/reverse-factory-"..n..".png"},
				{icon = "__reverse-factory__/graphics/icon/rf-bar-"..n..".png"},
			}
		end
	end
	
	if n==1 then
		item.localised_description = 
		{"item-description.reverse-factory-1", rf.percent_efficiency.."%"}
	elseif n==2 then
		item.localised_description = 
		{"item-description.reverse-factory-2", rf.percent_efficiency.."%"}
	elseif n==3 then
		item.localised_description = 
		{"item-description.reverse-factory-3", rf.percent_efficiency.."%"}
	end

	return item
end


local function rfRecipe(n)
	local recipe = {
		type = "recipe",
		name = "reverse-factory-"..n,
		--energy_required = 5,
		enabled = false,
		ingredients = 
		{
			{type = "item", name = "iron-plate", amount = 10},
			{type = "item", name = "iron-gear-wheel", amount = 7},
			{type = "item", name = "electronic-circuit", amount = 5},
			{type = "item", name = "assembling-machine-1", amount = 2}
		},
		results = {{type="item", name="reverse-factory-"..n, amount=1}}
	}
	if n > 1 then -- make the previous tier an ingredient of the next tier
		table.insert(recipe.ingredients,{type = "item",name="reverse-factory-"..(n-1),amount=1})
	end
	-- Space age related limitations
	if mods["space-age"] then
		recipe.surface_conditions = crafting_restrictions
	end
	return recipe
end


local function rfEntity(n)
	--Effects copied from base game
	local hit_effects = require("__base__/prototypes/entity/hit-effects")
	local sounds = require("__base__/prototypes/entity/sounds")
	--Shorthand path for furnace graphics_set
	local rf_path = "__reverse-factory__/graphics/entity"
	local base_path = "__base__/graphics/entity/electric-furnace"
	local entity =
	{
		type = "furnace",
		name = "reverse-factory-"..n,
		icon = "__reverse-factory__/graphics/item/reverse-factory-"..n..".png",
		icon_size = 32,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		fast_transfer_modules_into_module_slots_only = true,
		minable = {mining_time = 0.2, result = "reverse-factory-"..n},
		-- starts at 150 for t1, increases to 300 for t4
		max_health = (100 + 50*n),
		corpse = "electric-furnace-remnants",
		dying_explosion = "electric-furnace-explosion",
		resistances = {
			{
			  type = "fire",
			  percent = 80
			}
		},
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		damaged_trigger_effect = hit_effects.entity(),
		module_slots = (n+1), -- 2, 3, 4
		icon_draw_specification = {shift = {0, -0.1}},
		icons_positioning =
		{
		  {inventory_index = defines.inventory.furnace_modules, shift = {0, 0.8}}
		},
		allowed_effects = {"consumption", "speed", "pollution"},
		crafting_categories = {"recycle-products"},
		result_inventory_size = 4,
		-- starts at 1 and increases linearly
		crafting_speed = n,
		-- starts at 150kw for t1, increases by 75kw per tier, ends at 300kw for t3
		energy_usage = (75+75*n).."kW",
		source_inventory_size = 1,
		custom_input_slot_tooltip_key = "reverse-factory-input-slot-tooltip",
		cant_insert_at_source_message_key = "inventory-restriction.rf-cant-recycle-yet",
		fast_replaceable_group = "reverse-factory",
	    energy_source = {
			type = "electric",
			usage_priority = "secondary-input",
			-- t1 starts at 5, then t2 at 4, t3 ends at 2 (more efficient)
			emissions_per_minute = { pollution = 6-math.floor(1.67*n) }
		},
		impact_category = "metal",
		open_sound = sounds.electric_large_open,
		close_sound = sounds.electric_large_close,
		working_sound = {
			sound =
			{
			filename = "__base__/sound/electric-furnace.ogg",
			volume = 0.85,
			modifiers = volume_multiplier("main-menu", 4.2),
			advanced_volume_control = {attenuation = "exponential"}
			},
			max_sounds_per_type = 4,
			audible_distance_modifier = 0.7,
			fade_in_ticks = 4,
			fade_out_ticks = 20
		},
	    graphics_set = {
			animation = {
			  layers =
			  {
				{
					filename = rf_path.."/reverse-factory-"..n..".png",
					priority = "high",
					width = 239,
					height = 219,
					--frame_count = 1,
					shift = util.by_pixel(0.75, 5.75),
					scale = 0.5
				},
				{
					filename = base_path.."/electric-furnace-shadow.png",
					priority = "high",
					width = 227,
					height = 171,
					frame_count = 1,
					draw_as_shadow = true,
					shift = util.by_pixel(11.25, 7.75),
					scale = 0.5
				}
			  }
			},
			working_visualisations = {
			  {
				fadeout = true,
				animation = {
				  layers = {
					{
						filename = rf_path.."/reverse-factory-heater.png",
						priority = "high",
						width = 60,
						height = 56,
						frame_count = 12,
						animation_speed = 1/n,
						draw_as_glow = true,
						shift = util.by_pixel(1.75, 32.75),
						scale = 0.5
					},
					{
						filename = base_path.."/electric-furnace-light.png",
						blend_mode = "additive",
						width = 202,
						height = 202,
						repeat_count = 12,
						draw_as_glow = true,
						shift = util.by_pixel(1, 0),
						scale = 0.5,
					},
				  }
				},
			  },
			  {
				fadeout = true,
				animation = {
					filename = base_path.."/electric-furnace-ground-light.png",
					blend_mode = "additive",
					width = 166,
					height = 124,
					draw_as_light = true,
					shift = util.by_pixel(3, 69),
					scale = 0.5,
				},
			  },
			  {
				animation = {
					filename = rf_path.."/reverse-factory-propeller-1.png",
					priority = "high",
					width = 37,
					height = 25,
					frame_count = 4,
					animation_speed = 1/n,
					shift = util.by_pixel(-20.5, -18.5),
					scale = 0.5
				}
			  },
			  {
				animation = {
					filename = rf_path.."/reverse-factory-propeller-2.png",
					priority = "high",
					width = 23,
					height = 15,
					frame_count = 4,
					animation_speed = 1/n,
					shift = util.by_pixel(3.5, -38),
					scale = 0.5
				}
			  }
			},
			water_reflection = {
				pictures = {
				  filename = "__base__/graphics/entity/electric-furnace/electric-furnace-reflection.png",
				  priority = "extra-high",
				  width = 24,
				  height = 24,
				  shift = util.by_pixel(5, 40),
				  variation_count = 1,
				  scale = 5
				},
				rotate = false,
				orientation_to_variation = false
			}
		}
	}
	--Updates allowed modules if necessary
	if rf.modules == "productivity" or rf.modules == "both" then
		table.insert(entity.allowed_effects,"productivity")
	end
	if rf.modules == "quality" or rf.modules == "both" then
		table.insert(entity.allowed_effects,"quality")
	end
	-- Undoes module slot count nerf
	if rf.undonerf then
		entity.module_slots = (2*n) -- 2, 4, 6
	end
	-- Updates next_upgrade, crafting categories, and localised description per tier.
	if n==1 then
		entity.next_upgrade = "reverse-factory-"..(n+1)
		entity.crafting_categories = {"recycle-products"}
		entity.localised_description = 
			{"entity-description.reverse-factory-1",rf.percent_efficiency.."%"}
	elseif n==2 then
		entity.next_upgrade = "reverse-factory-"..(n+1)
		entity.crafting_categories = {"recycle-products", "recycle-intermediates"}
		entity.localised_description =
			{"entity-description.reverse-factory-2", rf.percent_efficiency.."%"}
	elseif n==3 then
		entity.
		cant_insert_at_source_message_key = "inventory-restriction.rf-cant-recycle"
		entity.crafting_categories = {"recycle-products", "recycle-intermediates", "recycle-productivity"}
		entity.localised_description = 
		{"entity-description.reverse-factory-3", rf.percent_efficiency.."%"}
		--[[ just some fluid box stuff
		entity.fluid_boxes = {
			{
				production_type = "output",
				pipe_picture = rfpipepictures(),
				pipe_covers = pipecoverspictures(),
				base_level = 1,
				base_area = 10,
				pipe_connections = {{ position = {-1, -2},type="output"}}
			},
			{
				production_type = "output",
				pipe_picture = rfpipepictures(),
				pipe_covers = pipecoverspictures(),
				base_level = 1,
				base_area = 10,
				pipe_connections = {{ position = {1, -2},type="output"}}
			}
		}]]--
	end
	-- Space age related limitations
	if mods["space-age"] then
		entity.surface_conditions = placement_restrictions
	end
	return entity
end


local function rfTech(n)
	local tech = {
		type = "technology",
		name = "reverse-factory-"..n,
		icon = "__reverse-factory__/graphics/technology/reverse-factory.png",
		icon_size = 128,
		prerequisites = {},
		effects =
		{
			{
			  type = "unlock-recipe",
			  recipe = "reverse-factory-"..n,
			}
		},		 
		unit =
		{
			count = 80,
			ingredients =
			{
				{"automation-science-pack", 1},
			},
			time = 15
		}
	}
	if n > 1 then
		tech.prerequisites = {"reverse-factory-"..(n-1)}
	end

	return tech
end


for n=1,3 do
	data:extend({rfItem(n)})
	data:extend({rfRecipe(n)})
	data:extend({rfEntity(n)})
	data:extend({rfTech(n)})
end



