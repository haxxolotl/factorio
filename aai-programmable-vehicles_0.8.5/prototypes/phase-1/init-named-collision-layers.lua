local function create_collision_layer_if_needed(collision_layer_name)
    if not data.raw["collision-layer"][collision_layer_name] then
        data:extend({
            {
                type = "collision-layer",
                name = collision_layer_name
            }
        })
    end
end

create_collision_layer_if_needed("flying")
create_collision_layer_if_needed("projectile")
create_collision_layer_if_needed("vehicle")
