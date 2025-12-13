local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({{
	type = "item-with-entity-data",
	name = "vehicle-hauler",
	icon = "__aai-vehicles-hauler__/graphics/icons/hauler.png",
	icon_size = 64, icon_mipmaps = 1,
	subgroup="transport",
	order = "ab[industrial]-b[hauler]",
	stack_size = 1,
	place_result = "vehicle-hauler",
	pick_sound = item_sounds.vehicle_inventory_pickup,
	drop_sound = item_sounds.vehicle_inventory_move,
	inventory_move_sound = item_sounds.vehicle_inventory_move,
}})
