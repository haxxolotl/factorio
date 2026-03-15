local hit_effects = require ("__base__.prototypes.entity.hit-effects")
local sounds = require ("__base__.prototypes.entity.sounds")
local decorative_trigger_effects = require("__base__.prototypes.decorative.decorative-trigger-effects")

--lithium
local lithium_rock_tint = {1, 1, 1}
local lithium_rock_rectange = nil --{{0, 0}, {1, 1}}
local lithium_rock_map_colour = {168, 188, 211}
local glowing_carbon_ice_tint = {100, 100, 100}

data:extend({
    {
        name = "carbon-iceberg-huge",
        type = "simple-entity",
        flags = {"placeable-neutral", "placeable-off-grid"},
        icon = "__space-age__/graphics/icons/lithium-iceberg-big.png",
        subgroup = "grass",
        order = "b[decorative]-l[rock]-k[lithium-iceberg]-d[big]",
        collision_mask =
        {
          layers=
          {
            item=true,
            object=true,
            player=true,
            water_tile=true
          },
        },
        collision_box = {{-1.85, -1.25}, {1.85, 1.25}},
        selection_box = {{-1.85, -1.25}, {1.85, 1.25}},
        drawing_box_vertical_extension = 2,
        damaged_trigger_effect = hit_effects.rock(),
        render_layer = "object",
        max_health = 1500,
        autoplace = {order = "a[rock]-a[huge]", probability_expression = "(aquilo_high_frequency_peaks - 0.8) * 0.1"},
        dying_trigger_effect = decorative_trigger_effects.big_rock(),
        minable =
        {
          mining_particle = "iron-ore-particle",
          mining_time = 2,
          results =
          {
            {type = "item", name = "ice", amount_min = 6, amount_max = 10},
            {type = "item", name = "coal", amount_min = 2, amount_max = 5},
            {type = "item", name = "ammoniac-bacteria", amount_min = 0, amount_max = 3}
          },
          mining_trigger =
          {
            {
              type = "direct",
              action_delivery =
              {
                {
                  type = "instant",
                  target_effects =
                  {
                    {
                      type = "play-sound",
                      sound = sound_variations("__space-age__/sound/particles/ice-particles", 5, 0.35),
                    }
                  }
                }
              }
            }
          }
        },
        resistances =
        {
          {
            type = "poison",
            percent = 100
          }
        },
        map_color = lithium_rock_map_colour,
        count_as_rock_for_filtered_deconstruction = true,
        mined_sound = sound_variations("__space-age__/sound/mining/mined-iceberg", 4, 0.7),
        mining_sound = sound_variations("__space-age__/sound/mining/axe-mining-iceberg", 7, 0.5),
        impact_category = "stone",
        pictures =
        {
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-huge/lithium-iceberg-huge-2.png",
            width = 444,
            height = 310,
            scale = 0.5,
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint,
            shift = {0.65,-0.75}
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-huge/lithium-iceberg-huge-5.png",
            width = 444,
            height = 310,
            scale = 0.5,
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint,
            shift = {1.15,-0.75}
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-huge/lithium-iceberg-huge-7.png",
            width = 444,
            height = 310,
            scale = 0.5,
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint,
            shift = {0.95,-0.25}
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-huge/lithium-iceberg-huge-11.png",
            width = 444,
            height = 310,
            scale = 0.5,
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint,
            shift = {0.65,-0.75},
            draw_as_glow = true
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-huge/lithium-iceberg-huge-12.png",
            width = 444,
            height = 310,
            scale = 0.5,
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint, 
            shift = {0.65,-0.75}
          },
        }
      },
      {
        name = "carbon-iceberg-big",
        type = "simple-entity",
        flags = {"placeable-neutral", "placeable-off-grid"},
        icon = "__space-age__/graphics/icons/lithium-iceberg-big.png",
        subgroup = "grass",
        order = "b[decorative]-l[rock]-k[lithium-iceberg]-d[big]",
        collision_mask =
        {
          layers=
          {
            item=true,
            object=true,
            player=true,
            water_tile=true
          },
        },
        collision_box = {{-1.0, -0.75}, {1.0, 0.75}},
        selection_box = {{-1.0, -0.75}, {1.0, 0.75}},
        damaged_trigger_effect = hit_effects.rock(),
        render_layer = "object",
        max_health = 500,
        autoplace = {order = "a[rock]-b[big]", probability_expression = "(aquilo_high_frequency_peaks - 0.7) * 0.8"},
        dying_trigger_effect = decorative_trigger_effects.big_rock(),
        minable =
        {
          mining_particle = "iron-ore-particle",
          mining_time = 2,
          results =
          {
            {type = "item", name = "ice", amount_min = 3, amount_max = 7},
            {type = "item", name = "coal", amount_min = 1, amount_max = 3}
          },
          mining_trigger =
          {
            {
              type = "direct",
              action_delivery =
              {
                {
                  type = "instant",
                  target_effects =
                  {
                    {
                      type = "play-sound",
                      sound = sound_variations("__space-age__/sound/particles/ice-particles", 5, 0.35),
                    }
                  }
                }
              }
            }
          }
        },
        resistances =
        {
          {
            type = "poison",
            percent = 100
          }
        },
        map_color = lithium_rock_map_colour,
        count_as_rock_for_filtered_deconstruction = true,
        mined_sound = sound_variations("__space-age__/sound/mining/mined-iceberg", 4, 0.7),
        mining_sound = sound_variations("__space-age__/sound/mining/axe-mining-iceberg", 7, 0.5),
        impact_category = "stone",
        pictures =
        {
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-1.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0.1,-0.25},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-2.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0,-0.25},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-3.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0,-0.25},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-4.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0,-0.25},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-5.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0.75,-0.25},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-6.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0,-0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-7.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0.1,-0.25},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-8.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0,0.05},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-9.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0.2,-0.25},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-10.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {-0.3,-0.25},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-11.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0,-0.35},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-12.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0.4,-0.35},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-13.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0,-0.35},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-14.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0,-0.35},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-big/lithium-iceberg-big-15.png",
            width = 230,
            height = 154,
            scale = 0.5,
            shift = {0,-0.25},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
        }
      },
      {
        name = "carbon-iceberg-medium",
        type = "optimized-decorative",
        order = "b[decorative]-l[rock]-k[lithium-iceberg]-c[medium]",
        collision_box = {{-1.1, -1.1}, {1.1, 1.1}},
        render_layer = "decorative",
        autoplace = {probability_expression = "(aquilo_high_frequency_peaks - 0.6) * 0.9"},
        trigger_effect = decorative_trigger_effects.medium_rock(),
        pictures =
        {
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-1.png",
            priority = base_decorative_sprite_priority,
            width = 114,
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-1.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-2.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-3.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-4.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-5.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-6.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-7.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-8.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-9.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-10.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-11.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-12.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-13.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-14.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-medium/lithium-iceberg-medium-15.png",
            priority = base_decorative_sprite_priority,
            width = 114,  
            height = 88,
            scale = 0.5,
            shift = {0.0, 0.0},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          }
        }
      },
      {
        name = "carbon-iceberg-small",
        type = "optimized-decorative",
        order = "b[decorative]-l[rock]-k[lithium-iceberg]-b[small]",
        collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
        render_layer = "decorative",
        walking_sound = sounds.pebble,
        autoplace = {probability_expression = "(aquilo_high_frequency_peaks - 0.35) * 0.7"},
        trigger_effect = decorative_trigger_effects.small_rock(),
        pictures =
        {
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-1.png",
            priority = base_decorative_sprite_priority,
            scale = 0.5,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-2.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-3.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-4.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-5.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-6.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-7.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-8.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-9.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-10.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-small/lithium-iceberg-small-11.png",
            priority = base_decorative_sprite_priority,
            width = 90,
            height = 56,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
        }
      },
      {
        name = "carbon-iceberg-tiny",
        type = "optimized-decorative",
        order = "b[decorative]-l[rock]-k[lithium-iceberg]-a[tiny]",
        collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
        render_layer = "decorative",
        walking_sound = sounds.pebble,
        autoplace = {probability_expression = "(aquilo_high_frequency_peaks - 0.2) * 0.5"},
        trigger_effect = decorative_trigger_effects.tiny_rock(),
        pictures =
        {
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-1.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-2.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-3.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-4.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-5.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-6.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-7.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-8.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-9.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-10.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-11.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
          {
            filename = "__space-age__/graphics/decorative/lithium-iceberg-tiny/lithium-iceberg-tiny-12.png",
            priority = base_decorative_sprite_priority,
            width = 46,
            height = 28,
            scale = 0.5,
            shift = {0.0390625, 0.0234375},
            draw_as_glow = true,
            tint = glowing_carbon_ice_tint
          },
        }
      },
})