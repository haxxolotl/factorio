
--much of this graciously taken from Maraxsis mod

--- Sentinel values for defining groups of events
maraxsis.events = {
	--- Called after an entity is constructed.
	--- Note: Using this event may be bad practice. Consider instead defining `created_effect` in the entity prototype.
	---
	--  entity.created_effect = {
	--  	type = 'direct',
	--  	action_delivery = {
	--  		type = 'instant',
	--  		source_effects = {
	-- 			type = 'script',
	--  			effect_id = 'on_built_[ENTITY NAME]'
	--  		}
	--  	}
	--  }
	on_built = function()
		return {
			defines.events.on_built_entity,
			defines.events.on_robot_built_entity,
			defines.events.script_raised_built,
			defines.events.script_raised_revive,
			defines.events.on_space_platform_built_entity,
			defines.events.on_biter_base_built
		}
	end,
	--- Called after the results of an entity being mined are collected just before the entity is destroyed. [...]
	on_destroyed = function()
		return {
			defines.events.on_player_mined_entity,
			defines.events.on_robot_mined_entity,
			defines.events.on_entity_died,
			defines.events.script_raised_destroy,
			defines.events.on_space_platform_mined_entity
		}
	end,
	--- Called after a tile is built.
	on_built_tile = function()
		return {
			defines.events.on_robot_built_tile,
			defines.events.on_player_built_tile,
			defines.events.on_space_platform_built_tile,
		}
	end,
	on_mined_tile = function()
		return {
			defines.events.on_player_mined_tile,
			defines.events.on_robot_mined_tile,
			defines.events.on_space_platform_mined_tile,
		}
	end,
	--- Called for on_init and on_configuration_changed
	on_init = function()
		return "ON INIT EVENT"
	end,
	--- Custom event for when a player clicks on an entity
	on_entity_clicked = function()
		return "build"
	end
}