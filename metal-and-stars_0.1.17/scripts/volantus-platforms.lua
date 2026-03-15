local size = 16.5 -- of the octagon

local PRESSURE_DOME_TILE = "volantus-platform-tile"

local check_size = size - 0.01
local DOME_POLYGON = {
    7, check_size,
    -7, check_size,
    -check_size, 7,
    -check_size, -7,
    -7, -check_size,
    7, -check_size,
    check_size, -7,
    check_size, 7,
}

-- By Pedro Gimeno, donated to the public domain
function is_point_in_polygon(x, y)
    if x > size or x < -size or y > size or y < -size then
        return false
    end

    local x1, y1, x2, y2
    local len = #DOME_POLYGON
    x2, y2 = DOME_POLYGON[len - 1], DOME_POLYGON[len]
    local wn = 0
    for idx = 1, len, 2 do
        x1, y1 = x2, y2
        x2, y2 = DOME_POLYGON[idx], DOME_POLYGON[idx + 1]

        if y1 > y then
            if (y2 <= y) and (x1 - x) * (y2 - y) < (x2 - x) * (y1 - y) then
                wn = wn + 1
            end
        else
            if (y2 > y) and (x1 - x) * (y2 - y) > (x2 - x) * (y1 - y) then
                wn = wn - 1
            end
        end
    end
    return wn % 2 ~= 0 -- even/odd rule
end

local function get_four_corners(entity)
    local position = entity.position
    local x, y = position.x, position.y
    local collision_box = entity.prototype.collision_box
    local orientation = entity.orientation

    if entity.type == "straight-rail" then
        orientation = (orientation + 0.25) % 1
    elseif entity.type == "cliff" then
        collision_box = {
            left_top = {x = -2, y = -2},
            right_bottom = {x = 2, y = 2},
        }
    else -- expand the collision box to the actual tile size
        collision_box = {
            left_top = {x = math.floor(collision_box.left_top.x * 2) / 2, y = math.floor(collision_box.left_top.y * 2) / 2},
            right_bottom = {x = math.ceil(collision_box.right_bottom.x * 2) / 2, y = math.ceil(collision_box.right_bottom.y * 2) / 2},
        }
    end

    local left_top = collision_box.left_top
    local right_bottom = collision_box.right_bottom

    if orientation == 0 then
        return {
            {x = x + left_top.x,     y = y + left_top.y},
            {x = x + right_bottom.x, y = y + left_top.y},
            {x = x + right_bottom.x, y = y + right_bottom.y},
            {x = x + left_top.x,     y = y + right_bottom.y},
        }
    end

    local cos = math.cos(orientation * 2 * math.pi)
    local sin = math.sin(orientation * 2 * math.pi)

    local corners = {}
    for _, corner in pairs {
        {x = left_top.x,     y = left_top.y},
        {x = right_bottom.x, y = left_top.y},
        {x = right_bottom.x, y = right_bottom.y},
        {x = left_top.x,     y = right_bottom.y},
    } do
        local corner_x, corner_y = corner.x, corner.y
        corners[#corners + 1] = {
            x = x + corner_x * cos - corner_y * sin,
            y = y + corner_x * sin + corner_y * cos,
        }
    end
    return corners
end

local function intersects_with_2x2_box(entity, box_location)
    local corners = get_four_corners(entity)

    local box_x, box_y = box_location.x, box_location.y
    local box_left_top = {x = box_x - 1, y = box_y - 1}
    local box_right_bottom = {x = box_x + 1, y = box_y + 1}

    for _, corner in pairs(corners) do
        local x, y = corner.x, corner.y
        if x >= box_left_top.x and x <= box_right_bottom.x and y >= box_left_top.y and y <= box_right_bottom.y then
            return true
        end
    end

    return false
end

local function count_points_in_dome(pressure_dome_data, entity)
    local dome_position = pressure_dome_data.position
    local x, y = dome_position.x, dome_position.y

    local count = 0
    for _, entity_corner in pairs(get_four_corners(entity)) do
        if is_point_in_polygon(entity_corner.x - x, entity_corner.y - y) then
            count = count + 1
        end
    end
    return count
end

local function place_tiles(pressure_dome_data)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end
    local position = pressure_dome_data.position
    local x, y = position.x, position.y

    local tiles = {}

    for xx = -math.floor(size), math.floor(size) do
        for yy = -math.floor(size), math.floor(size) do
            if is_point_in_polygon(xx + 0.5, yy) then
                local x, y = x + xx, y + yy
                tiles[#tiles + 1] = {name = PRESSURE_DOME_TILE, position = {x, y}}
            end
        end
    end

    surface.set_tiles(tiles, true, false, true, false)
end

local function check_can_build_dome(surface, position)
    local error_message = nil
    local contained_entities = {}
    local colliding_entities = {}
    local x, y = position.x, position.y

    local entities_inside_square = surface.find_entities_filtered {
        area = {
            {x - size, y - size},
            {x + size, y + size},
        },
        collision_mask = {["object"] = true},
    }

    for _, e in pairs(entities_inside_square) do
        local count = count_points_in_dome({position = position}, e)
        if count == 0 then
            -- pass
        elseif count == 4 then
            local layers = e.prototype.collision_mask.layers
            if e.force.name == "neutral" or layers[maraxsis_dome_collision_mask] then
                error_message = error_message or {"cant-build-reason.entity-in-the-way", e.localised_name}
                colliding_entities[#colliding_entities + 1] = e
            elseif layers.object and intersects_with_2x2_box(e, position) then
                error_message = error_message or {"cant-build-reason.entity-in-the-way", e.localised_name}
                colliding_entities[#colliding_entities + 1] = e
            else
                contained_entities[#contained_entities + 1] = e
            end
        else
            error_message = error_message or {"cant-build-reason.entity-in-the-way", e.localised_name}
            colliding_entities[#colliding_entities + 1] = e
        end
    end

    for xx = -math.floor(size) + x, math.floor(size) + x do
        for yy = -math.floor(size) + y, math.floor(size) + y do
            local tile = surface.get_tile(xx, yy)
            local tile_collision = tile.collides_with("object")
                or tile.collides_with(maraxsis_lava_collision_mask)
                or tile.collides_with(maraxsis_trench_entrance_collision_mask)
                
            if tile_collision and is_point_in_polygon(xx - x + 0.5, yy - y) then
                return false, colliding_entities, {"cant-build-reason.entity-in-the-way", tile.prototype.localised_name}, true
            end
        end
    end

    if error_message then
        return false, colliding_entities, error_message
    else
        return true, contained_entities, nil
    end
end


script.on_event(defines.events.on_script_trigger_effect, function(event)
	local effect_id = event.effect_id

	if effect_id == "on_built_small_volantus_platform" then
		local entity = event.target_entity

		if not (entity and entity.valid) then
			return
		end
	

    local surface, position = entity.surface, entity.position
    local can_build, contained_entities, error_msg, tile_collision = check_can_build_dome(surface, position)
    local force_index = entity.force_index
    local quality = entity.quality

    if tile_collision then
        metal.cancel_creation(entity, player and player.index, error_msg)
        return
    end

    if not can_build then
        local successfully_cleared_area = true
        local to_unmark = {}
        local undo_index = 0
        for _, colliding_entity in pairs(contained_entities) do
            if colliding_entity.valid and not colliding_entity.to_be_deconstructed() then
                local deconstructed
                if player then
                    deconstructed = pcall(colliding_entity.order_deconstruction, entity.force, player, undo_index)
                    undo_index = 1
                else
                    deconstructed = colliding_entity.order_deconstruction(entity.force)
                end
                successfully_cleared_area = successfully_cleared_area and deconstructed
                if deconstructed then to_unmark[#to_unmark + 1] = colliding_entity end
            end
        end
        if not successfully_cleared_area then
            for _, colliding_entity in pairs(to_unmark) do
                if colliding_entity.valid then colliding_entity.cancel_deconstruction(entity.force) end
            end
        end

        local tags = entity.tags
        metal.cancel_creation(entity, player and player.index, error_msg)

        if successfully_cleared_area then
            surface.create_entity {
                name = "entity-ghost",
                inner_name = "maraxsis-pressure-dome",
                tags = tags,
                force = force_index,
                position = position,
                player = player,
                quality = quality,
            }
        end
        return
    end


    local position1 = {x = position.x, y = position.y + 17.5}
    local position2 = {x = position.x + 11.5 , y = position.y + 11.5}
    local position3 = {x = position.x + -12.5 , y = position.y + 11.5}
    local shadowPosition = {x = position.x, y = position.y + 37.5}

    local health = entity.health
    entity.destroy()
    entity = rendering.draw_animation {
        animation = "vol-sprite",
        render_layer = "4",
        target = position1,
        surface = surface,
    }
    rendering.draw_animation {
        animation = "vol-sprite",
        render_layer = "4",
        target = position2,
        surface = surface,
    }
    rendering.draw_animation {
        animation = "vol-sprite",
        render_layer = "4",
        target = position3,
        surface = surface,
    }
    rendering.draw_sprite {
        sprite = "vol-shadow-sprite",
        render_layer = "3",
        target = shadowPosition,
        surface = surface,
    }

   

    local pressure_dome_data = {
        entity = entity,
        unit_number = entity.id,
        position = position,
        surface = surface,
        quality = quality,
        contained_entities = contained_entities,
        force_index = force_index,
        collision_boxes = {},
    }

    -- create_dome_light(pressure_dome_data)
    -- update_combinator(pressure_dome_data)
    -- place_collision_boxes(pressure_dome_data, health, player)
    place_tiles(pressure_dome_data)
    -- place_regulator(pressure_dome_data)

    if table_size(contained_entities) ~= 0 then
        for _, e in pairs(pressure_dome_data.collision_boxes) do
            e.minable = false
        end
    end

    storage.volantus_platforms = storage.volantus_platforms or {}

    storage.volantus_platforms[entity.id] = pressure_dome_data
    end
end
)

