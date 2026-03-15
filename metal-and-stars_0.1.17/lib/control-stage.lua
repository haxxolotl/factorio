


---Intended to be called inside a build event. Cancels creation of the entity.
---Returns its item_to_place back to the player or spills it on the ground.
---@param entity LuaEntity
---@param player_index integer?
---@param message LocalisedString?
---@param color Color?
metal.cancel_creation = function(entity, player_index, message, color)
	local inserted = 0
	local items_to_place_this = entity.prototype.items_to_place_this
	local item_to_place = items_to_place_this and items_to_place_this[1]
	local surface = entity.surface
	local position = entity.position
	local quality = entity.quality.name
	local name = entity.name

	if player_index then
		local player = game.get_player(player_index)
		if player.mine_entity(entity, false) then
			inserted = 1

			-- remove from undo stack
			local undo_stack = player.undo_redo_stack
			local top
			for i = 1, undo_stack.get_undo_item_count() do
				top = undo_stack.get_undo_item(i)
				for j, action in pairs(top) do
					local target = action.target
					if target and target.name == name and serpent.line(target.position) == serpent.line(position) then
						undo_stack.remove_undo_action(i, j)
						break
					end
				end
			end
		elseif item_to_place then
			item_to_place.quality = quality
			inserted = player.insert(item_to_place)
		end
	end

	if inserted == 0 and item_to_place then
		item_to_place.quality = quality
		surface.spill_item_stack {
			position = position,
			stack = item_to_place,
			enable_looted = true,
			force = entity.force_index,
			allow_belts = false
		}
	end

	entity.destroy {raise_destroy = true}

	if not message then return end

	local tick = game.tick
	local last_message = storage._last_cancel_creation_message or 0
	if last_message + 60 < tick then
		for _, player in pairs(game.connected_players) do
			player.create_local_flying_text {
				text = message,
				position = position,
				color = color,
				create_at_cursor = player.index == player_index
			}
		end
		storage._last_cancel_creation_message = game.tick
	end
end