--The part of the script that does everything
function checkinvs()
    --Run through every currently active surface
    for _, surface in pairs(game.surfaces) do
        --If at least one recycler in the storage list..
        if storage then if next(storage) then
            --Check every recycler in the storage list..
            for _, entity in pairs (storage) do
                --Resets the timer if the recycler is not stopped by input
                local noResetTimer = true
                --Entity[1] is the actual recycler, Entity[2] is its timer
                if entity[1] then --First check if entity [1] exists
					if entity[1].valid then --Then check if entity[1] is a valid entity
						--Then if the recycler has power..
						if entity[1].energy > 0 then
							--Then if the recycler is not currently recycling..
							if not entity[1].is_crafting() then
								--Then if the output is currently empty..
								if entity[1].get_output_inventory().is_empty() then
									--Then if the input is currently not empty..
									if entity[1].get_inventory(defines.inventory.assembling_machine_input).get_item_count() > 0 then
										--Decrement the timer, because the recycler is stopped with input
										entity[2] = countdown(entity[2])
										--Then if the timer has passed 0..
										if entity[2] < 0 then
											--Auto ingredient push and reset the timer if true
											pushIngredient(entity[1])
										--Do not reset the timer if the recycler is stopped by input
										else noResetTimer = false
										end
									end
								end
							end
                        end
                    end
                end
                --Resets the timer if the recycler was not stopped,
                --or if the recycler has already pushed to output
                if noResetTimer then
                    entity[2]=settings.global["rf-timer"].value
                end
            end
        end end
    end
end

--Auto ingredient push function
function pushIngredient(entity)	
	--Grab input contents, stored as table (pairs)
	local input = entity.get_inventory(defines.inventory.assembling_machine_input).get_contents()
	--game.players[1].print(serpent.block(input))
	item = input[1]
	if entity.get_output_inventory().can_insert(item) then
		entity.get_output_inventory().insert(item)
		entity.get_inventory(defines.inventory.assembling_machine_input).clear()
	end
end

--Countdown timer by the delay amount
function countdown(timer)
	local timer = timer - settings.global["rf-delay"].value
	return timer
end

--Check if the entity was an rf recycler, then add it to the list with its own timer
function addRecycler(entity)
	--If the storage table does not exist for whatever reason, recreate the table
	if not storage then
		scanworld()
	end
	if string.find(entity.name, "reverse") and string.find(entity.name, "factory") then
		local timer = settings.global["rf-timer"].value
		local new_entity = {entity,timer}
		--game.players[1].print("Recycler added")
		table.insert(storage,new_entity)
	end
end

--Check if the entity was a recycler, and if so, remove it from the list
function removeRecycler(entity)
	--If the storage table does not exist for whatever reason, recreate the table
	if not storage then
		scanworld()
	end
	if string.find(entity.name, "reverse") and string.find(entity.name, "factory") then
		for key, list_entity in pairs (storage) do
			if list_entity[1] == entity then
				--game.players[1].print("Recycler removed")
				table.remove(storage,key)
			end
		end
	end
end

function removeRecyclersFromSurface(surface)
	--game.players[1].print(serpent.block(surface))
	for n=1, 3 do
		--Check the list of entities for any placed recyclers
		local rfname = "reverse-factory-"..n
		local list = surface.find_entities_filtered{name=rfname}
		--And add them to the list for that specific surface
		for _, entity in pairs(list) do
			removeRecycler(entity)
		end
	end
end

--Runs on first load, and whenever autopush setting is enabled.
function scanworld()
	storage = {}
	for key, surface in pairs(game.surfaces) do
		for n=1, 3 do
			--Check the list of entities for any placed recyclers
			local rfname = "reverse-factory-"..n
			local list = game.surfaces[key].find_entities_filtered{name=rfname}
			--And add them to the list for that specific surface
			for _, entity in pairs(list) do
				addRecycler(entity)
			end
		end
	end
end

--Only ever runs on new save, or first mod load; simply creates the storage table.
script.on_init(function()
	scanworld()
end)

--Only ever runs when modlist is updated; simply creates the storage table.
script.on_configuration_changed(function()
	scanworld()
end)

--Runs whenever any mod settings are changed
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	-- but does nothing unless an rf-specific setting was changed
	if string.match(event.setting,"rf") then
		-- Only runs if the autopush setting was specifically changed to true
		if string.match(event.setting,"autopush") then
			if settings.global["rf-autopush"].value then
				scanworld()
			end
		end
		-- This also runs if any of the timers were changed
		enableOrDisableScriptEvents()
	end
end)

--This sets up the timer to check recycler inventories every nth tick (defined in settings)
--Initializes the function to be called on map load, and settings changed.
function setup_checkinvs()
    --Remove previously running on_nth_tick() handlers when mod settings are changed.
    script.on_nth_tick(nil)
	--Reapply the script ONLY if auto-ingredient push is still enabled.
	if settings.global["rf-autopush"].value then
		script.on_nth_tick(settings.global["rf-delay"].value, checkinvs)
		--[[script.on_nth_tick(120, function()
			game.players[1].print(serpent.block(storage))
		end)]]--
	end
end

--If autopush is enabled, enable all of the scripts
function enableOrDisableScriptEvents()
	setup_checkinvs()
	if settings.global["rf-autopush"].value then
		-- on player built entity, add recycler to list
		script.on_event(defines.events.on_built_entity, function(event)
			addRecycler(event.entity)
		end)
		-- on player mined entity, remove recycler from list
		script.on_event(defines.events.on_player_mined_entity, function(event)
			removeRecycler(event.entity)
		end)
		-- on bot built entity, add recycler to list
		script.on_event(defines.events.on_robot_built_entity, function(event)
			addRecycler(event.entity)
		end)
		-- on bot mined entity, remove recycler from list
		script.on_event(defines.events.on_robot_mined_entity, function(event)
			removeRecycler(event.entity)
		end)
		-- on platform built entity, add recycler to list
		script.on_event(defines.events.on_space_platform_built_entity, function(event)
			addRecycler(event.entity)
		end)
		-- on platform mined entity, add recycler to list
		script.on_event(defines.events.on_space_platform_mined_entity, function(event)
			removeRecycler(event.entity)
		end)
		-- on entity destroyed by damage, remove recycler from list
		script.on_event(defines.events.on_entity_died , function(event)
			removeRecycler(event.entity)
		end)
		-- on entity destroyed by script, remove recycler from list
		script.on_event(defines.events.script_raised_destroy, function(event)
			removeRecycler(event.entity)
		end)
		-- just before surface is cleared, remove all surface recyclers from list
		script.on_event(defines.events.on_pre_surface_cleared, function(event)
			removeRecyclersFromSurface(game.surfaces[event.surface_index])
		end)
		-- just before surface is deleted, remove all surface recyclers from list
		script.on_event(defines.events.on_pre_surface_deleted, function(event)
			removeRecyclersFromSurface(game.surfaces[event.surface_index])
		end)
	else
		script.on_event(defines.events.on_built_entity,nil)
		script.on_event(defines.events.on_player_mined_entity,nil)
		script.on_event(defines.events.on_robot_built_entity,nil)
		script.on_event(defines.events.on_robot_mined_entity,nil)
		script.on_event(defines.events.on_space_platform_built_entity,nil)
		script.on_event(defines.events.on_space_platform_mined_entity,nil)
		script.on_event(defines.events.on_entity_died,nil)
		script.on_event(defines.events.script_raised_destroy,nil)
		script.on_event(defines.events.on_pre_surface_cleared,nil)
		script.on_event(defines.events.on_pre_surface_deleted,nil)
	end
	
end

--This runs upon every load
enableOrDisableScriptEvents()
