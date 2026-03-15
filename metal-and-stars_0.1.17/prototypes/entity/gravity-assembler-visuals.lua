
return {
    icons = {
        --technology
        technology_icon = "__metal-and-stars-graphics__/graphics/icons/gravity-assembler.png",
        technology_icon_size = 256,
        --item
        item_icon = "__metal-and-stars-graphics__/graphics/icons/gravity-assembler.png",
        item_icon_size = 64,
    },

    entity_data = {
        collision_box = {{-2.4, -2.4}, {2.4, 2.4}},
        selection_box = {{-2.5, -2.5}, {2.5, 2.5}},

        circuit_wire_connection_points = circuit_connector_definitions["electric-mining-drill"].points,
        circuit_connector_sprites = circuit_connector_definitions["electric-mining-drill"].sprites,

        graphics_set = {
            circuit_connector_layer = "object",
                circuit_connector_secondary_draw_order = { north = 14, east = 30, south = 30, west = 30 },
            animation = {
              layers = {
                {
                  filename = "__metal-and-stars-graphics__/graphics/entity/gravity-assembler/gravity-assembler-hr-shadow.png",
                  priority = "high",
                  width = 520,
                  height = 500,
                  frame_count = 1,
                  repeat_count = 99,
                  animation_speed = 0.5,
                  --shift = {2 + 3/32, 1 + 22/32},
                  draw_as_shadow = true,
                  scale = 0.5,
                },
                {
                  priority = "high",
                  width = 320,
                  height = 320,
                  frame_count = 99,
                  animation_speed = 0.5,
                  --shift = {0, -8/32},
                  scale = 0.5,
                  stripes =
                  {
                    {
                      filename = "__metal-and-stars-graphics__/graphics/entity/gravity-assembler/gravity-assembler-hr-animation-1.png",
                      width_in_frames = 8,
                      height_in_frames = 8,
                    },
                    {
                      filename = "__metal-and-stars-graphics__/graphics/entity/gravity-assembler/gravity-assembler-hr-animation-2.png",
                      width_in_frames = 8,
                      height_in_frames = 8,
                    },
                  },
                },
              }
            },
            working_visualisations = {
              {
                animation = {
                  priority = "high",
                  width = 320,
                  height = 320,
                  frame_count = 99,
                  animation_speed = 0.5,
                  --shift = {0, -8/32},
                  scale = 0.5,
                  draw_as_glow = true,
                  blend_mode = "additive",
                  stripes =
                  {
                    {
                      filename = "__metal-and-stars-graphics__/graphics/entity/gravity-assembler/gravity-assembler-hr-animation-emission-1.png",
                      width_in_frames = 8,
                      height_in_frames = 8,
                    },
                    {
                      filename = "__metal-and-stars-graphics__/graphics/entity/gravity-assembler/gravity-assembler-hr-animation-emission-2.png",
                      width_in_frames = 8,
                      height_in_frames = 8,
                    },
                  },
                },
              }
            }
          }
    },
}
