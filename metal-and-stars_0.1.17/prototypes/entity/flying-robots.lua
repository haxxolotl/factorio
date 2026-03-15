local logistic_robot_emission_tint = {r = 153, g = 0, b = 255}
local construction_robot_emission_tint = {r = 153, g = 0, b = 255}

data:extend{
    {
      type = "logistic-robot",
      name = "antimatter-logistic-robot",
      icon = "__metal-and-stars-graphics__/graphics/icons/antimatter-logistic-robot.png",
      flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map"},
      minable = {hardness = 0.1, mining_time = 0.1, result = "antimatter-logistic-robot"},
      resistances = { { type = "fire", percent = 85 }, { type = "electric", percent = 100 } },
      max_health = 100,
      collision_box = {{0, 0}, {0, 0}},
      selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
      max_payload_size = 1,
      speed = 0.07,
      transfer_distance = 0.5,
      max_energy = "0MJ",
      energy_per_tick = "0kJ",
      speed_multiplier_when_out_of_energy = 1,
      energy_per_move = "0kJ",
      min_to_charge = 0,
      max_to_charge = 0,
      icon_size = 32,
      idle =
      {
        layers = {
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                y = 128
            },
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot-emission.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                draw_as_glow = true,
                blend_mode = "additive",
                tint = logistic_robot_emission_tint,
                y = 128
            },
        }
      },
      idle_with_cargo =
      {
        layers = {
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                y = 128
            },
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot-emission.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                draw_as_glow = true,
                blend_mode = "additive",
                tint = logistic_robot_emission_tint,
                y = 128
            },
        }
      },
      in_motion =
      {
        layers = {
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                y = 128
            },
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot-emission.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                draw_as_glow = true,
                blend_mode = "additive",
                tint = logistic_robot_emission_tint,
                y = 128
            },
        }
      },
      in_motion_with_cargo =
      {
        layers = {
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                y = 128
            },
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot-emission.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                draw_as_glow = true,
                blend_mode = "additive",
                tint = logistic_robot_emission_tint,
                y = 128
            },
        }
      },
      shadow_idle =
      {
        filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 1,
        shift = {0.0, 0.0},
        direction_count = 16
      },
      shadow_idle_with_cargo =
      {
        filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 1,
        shift = {0.0, 0.0},
        direction_count = 16
      },
      shadow_in_motion =
      {
        filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 1,
        shift = {0.0, 0.0},
        direction_count = 16
      },
      shadow_in_motion_with_cargo =
      {
        filename = "__metal-and-stars-graphics__/graphics/entity/logistic-robot/logistic-bot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 1,
        shift = {0.0, 0.0},
        direction_count = 16
      },
      working_sound = data.raw["logistic-robot"]["logistic-robot"].working_sound,
      cargo_centered = {0.0, 0.2},
    },
    {
      type = "construction-robot",
      name = "antimatter-construction-robot",
      icon = "__metal-and-stars-graphics__/graphics/icons/antimatter-construction-robot.png",
      flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map"},
      minable = {hardness = 0.1, mining_time = 0.1, result = "antimatter-construction-robot"},
      resistances = { { type = "fire", percent = 85 }, { type = "electric", percent = 100 } },
      max_health = 100,
      collision_box = {{0, 0}, {0, 0}},
      selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
      max_payload_size = 1,
      speed = 0.06,
      transfer_distance = 0.5,
      max_energy = "0MJ",
      energy_per_tick = "0kJ",
      speed_multiplier_when_out_of_energy = 1,
      energy_per_move = "0kJ",
      min_to_charge = 0,
      max_to_charge = 0,
      icon_size = 32,
      working_light = {intensity = 0.8, size = 3, color = construction_robot_emission_tint},
      idle =
      {
        layers = {
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/construction-robot/construction-bot.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                y = 128
            },
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/construction-robot/construction-bot-emission.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                draw_as_glow = true,
                blend_mode = "additive",
                tint = construction_robot_emission_tint,
                y = 128
            },
        }
      },
      in_motion =
      {
        layers = {
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/construction-robot/construction-bot.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                y = 128
            },
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/construction-robot/construction-bot-emission.png",
                priority = "high",
                line_length = 16,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 1,
                shift = {0.0, -0.0},
                direction_count = 16,
                draw_as_glow = true,
                blend_mode = "additive",
                tint = construction_robot_emission_tint,
                y = 128
            },
        }
      },
      shadow_idle =
      {
        filename = "__metal-and-stars-graphics__/graphics/entity/construction-robot/construction-bot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 1,
        shift = {0.0, 0.0},
        direction_count = 16
      },
      shadow_in_motion =
      {
        filename = "__metal-and-stars-graphics__/graphics/entity/construction-robot/construction-bot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 1,
        shift = {0.0, 0.0},
        direction_count = 16
      },
      working =
      {
        layers = {
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/construction-robot/construction-bot-working.png",
                priority = "high",
                line_length = 2,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 2,
                shift = {0.0, 0.0},
                direction_count = 16,
                animation_speed = 0.3,
            },
            {
                filename = "__metal-and-stars-graphics__/graphics/entity/construction-robot/construction-bot-working-emission.png",
                priority = "high",
                line_length = 2,
                width = 128,
                height = 128,
                scale = 0.5,
                frame_count = 2,
                shift = {0.0, 0.0},
                direction_count = 16,
                animation_speed = 0.3,
                draw_as_glow = true,
                blend_mode = "additive",
                tint = construction_robot_emission_tint,
            },
        }
      },
      shadow_working =
      {
        stripes = util.multiplystripes(2,
        {
          {
            filename = "__metal-and-stars-graphics__/graphics/entity/construction-robot/construction-bot-shadow.png",
            width_in_frames = 16,
            height_in_frames = 1,
          }
        }),
        priority = "high",
        width = 50,
        height = 24,
        scale = 0.5,
        frame_count = 2,
        shift = {1.09375, 0.59375},
        direction_count = 16
      },
      smoke =
      {
        filename = "__base__/graphics/entity/smoke-construction/smoke-01.png",
        width = 39,
        height = 32,
        frame_count = 19,
        line_length = 19,
        shift = {0.078125, -0.15625},
        animation_speed = 0.3,
      },
      sparks =
      {
        {
          filename = "__base__/graphics/entity/sparks/sparks-01.png",
          width = 39,
          height = 34,
          frame_count = 19,
          line_length = 19,
          shift = {-0.109375, 0.3125},
          tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
          animation_speed = 0.3,
        },
        {
          filename = "__base__/graphics/entity/sparks/sparks-02.png",
          width = 36,
          height = 32,
          frame_count = 19,
          line_length = 19,
          shift = {0.03125, 0.125},
          tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
          animation_speed = 0.3,
        },
        {
          filename = "__base__/graphics/entity/sparks/sparks-03.png",
          width = 42,
          height = 29,
          frame_count = 19,
          line_length = 19,
          shift = {-0.0625, 0.203125},
          tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
          animation_speed = 0.3,
        },
        {
          filename = "__base__/graphics/entity/sparks/sparks-04.png",
          width = 40,
          height = 35,
          frame_count = 19,
          line_length = 19,
          shift = {-0.0625, 0.234375},
          tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
          animation_speed = 0.3,
        },
        {
          filename = "__base__/graphics/entity/sparks/sparks-05.png",
          width = 39,
          height = 29,
          frame_count = 19,
          line_length = 19,
          shift = {-0.109375, 0.171875},
          tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
          animation_speed = 0.3,
        },
        {
          filename = "__base__/graphics/entity/sparks/sparks-06.png",
          width = 44,
          height = 36,
          frame_count = 19,
          line_length = 19,
          shift = {0.03125, 0.3125},
          tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
          animation_speed = 0.3,
        },
      },
      working_sound = data.raw["construction-robot"]["construction-robot"].working_sound,
      cargo_centered = {0.0, 0.2},
      construction_vector = {0.30, 0.22},
    }
}