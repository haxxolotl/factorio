local meld = require("__core__.lualib.meld")

local tile = meld(table.deepcopy(data.raw.tile["concrete"]), {
    name = "volantus-platform-tile",
    is_foundation = true,
    minable = {
        mining_time = 2 ^ 63 - 1, -- weird hack needed to make this a "top" tile. top tiles require minable properties however these dome tiles actually should not be minable
        results = {},
    },
    variants = {
        transition = data.raw.tile["concrete"].variants.transition,
        material_background =
        {
            picture = "__metal-and-stars-graphics-2__/graphics/terrain/rusty-tile.png",
            count = 8,
            scale = 0.5
        },
    },
    --collision_mask = {layers = {[maraxsis_dome_collision_mask] = true, [maraxsis_fishing_tower_collision_mask] = true}},
    map_color = {r = 0.5, g = 0.5, b = 0.75},
    can_be_part_of_blueprint = false,
    layer_group = "ground-artificial"
})
data:extend {tile}

local platform_thruster = {
    filename = "__metal-and-stars-graphics-2__/graphics/entity/volantus-platform/platform-thruster.png",
    width = 149,
    height = 105,
    frame_count = 1,
    repeat_count = 8,
}

local platform_thruster_emission = {
    filename = "__metal-and-stars-graphics-2__/graphics/entity/volantus-platform/platform-thruster-emission.png",
    width = 149,
    height = 105,
    draw_as_glow = true,
    blend_mode = "additive",
    frame_count = 1,
    repeat_count = 8,
}

local platform_thruster_flame = {
  filename = "__base__/graphics/entity/rocket-silo/10-jet-flame.png",
  width = 172,
  height = 256,
  draw_as_glow = true,
  blend_mode = "additive",
  frame_count = 8,
  animation_speed = 0.5,
  shift = {.2, 3.75}
}

local platform_shadow = {
    filename = "__metal-and-stars-graphics-2__/graphics/entity/volantus-platform/platform-shadow.png",
    width = 1344,
    height = 1344,
  }


data:extend ({
    {
        type = "animation",
        name = "vol-sprite",
        layers = {platform_thruster_flame, platform_thruster, platform_thruster_emission},
    },
    {
        type = "sprite",
        name = "vol-shadow-sprite",
        layers = {platform_shadow},
    },
    {
        type = "recipe",
        name = "volantus-platform-small",
        enabled = true,
        ingredients = {
            {type = "item", name = "pipe",                 amount = 30},
            {type = "item", name = "tungsten-plate",       amount = 100},
        },
        results = {
            {type = "item", name = "volantus-platform-small", amount = 1},
        },
        energy_required = 10,
    },
    {
        type = "item",
        name = "volantus-platform-small",
        icon = "__space-age__/graphics/icons/jellynut.png",
        icon_size = 64,
        place_result = "volantus-platform-small",
        stack_size = 10,
    },
    {
        type = "simple-entity-with-owner",
        name = "volantus-platform-small",
        factoriopedia_alternative = "volantus-platform-small",
        localised_name = {"entity-name.volantus-platform-small"},
        icon = "__space-age__/graphics/icons/jellynut.png",
        quality_indicator_scale = 0,
        icon_size = 64,
        hidden = true,
        flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map", "building-direction-8-way", "not-blueprintable"},
        max_health = 10000,
        collision_box = {{-7, -0.3}, {7, 0.3}},
        selection_box = {{-7, -0.5}, {7, 0.5}},
        drawing_box = {{0, 0}, {0, 0}},
        -- collision_mask = {layers = {
        --     ["water_tile"] = true,
        --     ["object"] = true,
        --     ["item"] = true,
        --     [maraxsis_collision_mask] = true,
        --     [maraxsis_dome_collision_mask] = true
        -- }},
        created_effect = {
            type = 'direct',
            action_delivery = {
                type = 'instant',
                source_effects = {
                    type = 'script',
                    effect_id = 'on_built_small_volantus_platform'
                }
            }
        },
        minable = {mining_time = 1, result = "volantus-platform-small"},
        placeable_by = {{item = "volantus-platform-small", count = 1}},
        resistances = {
            {
                type = "acid",
                percent = 90
            },
            {
                type = "fire",
                percent = 100
            },
        }
    },
    {
        type = "simple-entity-with-owner",
        name = "volantus-platform-small-collision",
        factoriopedia_alternative = "volantus-platform-small",
        localised_name = {"entity-name.volantus-platform-small"},
        icon = "__space-age__/graphics/icons/jellynut.png",
        quality_indicator_scale = 0,
        icon_size = 64,
        hidden = true,
        flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map", "building-direction-8-way", "not-blueprintable"},
        max_health = 10000,
        collision_box = {{-7, -0.3}, {7, 0.3}},
        selection_box = {{-7, -0.5}, {7, 0.5}},
        drawing_box = {{0, 0}, {0, 0}},
        -- collision_mask = {layers = {
        --     ["water_tile"] = true,
        --     ["object"] = true,
        --     ["item"] = true,
        --     [maraxsis_collision_mask] = true,
        --     [maraxsis_dome_collision_mask] = true
        -- }},
        squeak_behaviour = false,
        minable = {mining_time = 1, result = "volantus-platform-small"},
        placeable_by = {{item = "volantus-platform-small", count = 1}},
        resistances = {
            {
                type = "acid",
                percent = 90
            },
            {
                type = "fire",
                percent = 100
            },
        }
    }
})