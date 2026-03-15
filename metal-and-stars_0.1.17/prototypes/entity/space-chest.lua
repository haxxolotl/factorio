local hit_effects = require("__base__.prototypes.entity.hit-effects")

data:extend({

    {
        type = "container",
        name = "space-chest-ms",
        icon = "__metal-and-stars-graphics__/graphics/icons/space-chest.png",
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 0.2, result = "space-chest-ms"},
        max_health = 350,
        corpse = "space-chest-ms-remnants",
        open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.23 },
        close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.23 },
        resistances =
        {
          {
            type = "fire",
            percent = 90
          },
          {
            type = "impact",
            percent = 60
          }
        },
        collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        damaged_trigger_effect = hit_effects.entity(),
        fast_replaceable_group = "container",
        inventory_size = 20,
        impact_category = "metal",
        icon_draw_specification = {scale = 0.7},
        picture =
        {
          layers =
          {
            {
              filename = "__metal-and-stars-graphics__/graphics/entity/space-chest/space-chest.png",
              priority = "extra-high",
              width = 66,
              height = 76,
              shift = util.by_pixel(-0.5, -0.5),
              scale = 0.5
            },
            {
              filename = "__base__/graphics/entity/iron-chest/iron-chest-shadow.png",
              priority = "extra-high",
              width = 110,
              height = 50,
              shift = util.by_pixel(10.5, 6),
              draw_as_shadow = true,
              scale = 0.5
            }
          }
        },
        circuit_connector = circuit_connector_definitions["chest"],
        circuit_wire_max_distance = default_circuit_wire_max_distance
      },

      {
        type = "corpse",
        name = "space-chest-ms-remnants",
        icon = "__metal-and-stars-graphics__/graphics/icons/space-chest.png",
        flags = {"placeable-neutral", "building-direction-8-way", "not-on-map"},
        hidden_in_factoriopedia = true,
        subgroup = "storage-remnants",
        order = "a-c-a",
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        tile_width = 1,
        tile_height = 1,
        selectable_in_game = false,
        time_before_removed = 60 * 60 * 15, -- 15 minutes
        expires = false,
        final_render_layer = "remnants",
        remove_on_tile_placement = false,
        animation =
        {
          filename = "__metal-and-stars-graphics__/graphics/entity/space-chest/space-chest-remnants.png",
          line_length = 1,
          width = 126,
          height = 78,
          direction_count = 1,
          shift = util.by_pixel(12, 0),
          scale = 0.5
        }
      },

})