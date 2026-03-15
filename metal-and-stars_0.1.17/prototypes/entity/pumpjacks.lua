local hit_effects = require("__base__.prototypes.entity.hit-effects")

data:extend({
  {
    type = "mining-drill",
    name = "pumpjack-mk2",
    icon = "__base__/graphics/icons/pumpjack.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.5, result = "pumpjack"},
    resource_categories = {"basic-fluid"},
    max_health = 200,
    corpse = "pumpjack-remnants",
    dying_explosion = "pumpjack-explosion",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    drawing_box_vertical_extension = 1,
    energy_source =
    {
      type = "electric",
      emissions_per_minute = { pollution = 10 },
      usage_priority = "secondary-input"
    },
    output_fluid_box =
    {
      volume = 1000,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        {
          direction = defines.direction.north,
          positions = {{1, -1}, {1, -1}, {-1, 1}, {-1, 1}},
          flow_direction = "output"
        }
      }
    },
    energy_usage = "90kW",
    mining_speed = 1,
    resource_searching_radius = 0.49,
    vector_to_place_result = {0, 0},
    resource_drain_rate_percent = 50,
    module_slots = 4,
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/pumpjack/pumpjack-radius-visualization.png",
      width = 12,
      height = 12
    },
    monitor_visualization_tint = {78, 173, 255},
    base_render_layer = "lower-object-above-shadow",
    base_picture =
    {
      sheets =
      {
        {
          filename = "__base__/graphics/entity/pumpjack/pumpjack-base.png",
          priority = "extra-high",
          width = 261,
          height = 273,
          shift = util.by_pixel(-2.25, -4.75),
          scale = 0.5
        },
        {
          filename = "__base__/graphics/entity/pumpjack/pumpjack-base-shadow.png",
          width = 220,
          height = 220,
          scale = 0.5,
          draw_as_shadow = true,
          shift = util.by_pixel(6, 0.5)
        }
      }
    },
    graphics_set =
    {
      animation =
      {
        north =
        {
          layers =
          {
            {
              priority = "high",
              filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead.png",
              animation_speed = 0.5,
              scale = 0.5,
              line_length = 8,
              width = 206,
              height = 202,
              frame_count = 40,
              shift = util.by_pixel(-4, -24)
            },
            {
              priority = "high",
              filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead-shadow.png",
              animation_speed = 0.5,
              draw_as_shadow = true,
              line_length = 8,
              width = 309,
              height = 82,
              frame_count = 40,
              scale = 0.5,
              shift = util.by_pixel(17.75, 14.5)
            }
          }
        }
      }
    },
    open_sound = {filename = "__base__/sound/open-close/pumpjack-open.ogg", volume = 0.5},
    close_sound = {filename = "__base__/sound/open-close/pumpjack-close.ogg", volume = 0.5},
    working_sound =
    {
      sound = {filename = "__base__/sound/pumpjack.ogg", volume = 0.7},
      max_sounds_per_type = 3,
      audible_distance_modifier = 0.6,
      fade_in_ticks = 4,
      fade_out_ticks = 10
    },
    fast_replaceable_group = "pumpjack",

    circuit_connector = circuit_connector_definitions["pumpjack"],
    circuit_wire_max_distance = default_circuit_wire_max_distance
  }

})