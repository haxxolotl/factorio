data:extend({

    {
        name = "ringworld-sand-dune-decal",
        type = "optimized-decorative",
        order = "b[decorative]-b[red-desert-decal]",
        collision_box = {{-1.78125, -1.34375}, {1.78125, 1.34375}},
        collision_mask = {layers={doodad=true, water_tile=true}, not_colliding_with_itself=true},
        render_layer = "decals",
        tile_layer = 255,
        autoplace =
        {
          probability_expression = "ringworld_right_mask * (-0.8 - 0.4 * min(0.5, abs(grass_noise)) + 0.04 * noise_layer_noise('sand-decal')\z
                                          + min(range_select(moisture, 0, 0.15, 0.4, -10, 1),\z
                                                range_select(aux, 0.0, 0.25, 0.4, -10, 1)))"
        },
        pictures =
        {
          --dune
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-00.png",
            width = 212,
            height = 168,
            shift = util.by_pixel(-8, 0),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-01.png",
            width = 211,
            height = 148,
            shift = util.by_pixel(5.75, -3.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-02.png",
            width = 260,
            height = 184,
            shift = util.by_pixel(3, 1),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-03.png",
            width = 129,
            height = 181,
            shift = util.by_pixel(0.75, 1.75),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-04.png",
            width = 196,
            height = 184,
            shift = util.by_pixel(-3.5, -1.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-05.png",
            width = 215,
            height = 184,
            shift = util.by_pixel(-1.25, -1),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-06.png",
            width = 218,
            height = 179,
            shift = util.by_pixel(6.5, 4.25),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-07.png",
            width = 250,
            height = 183,
            shift = util.by_pixel(17.5, 3.25),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-08.png",
            width = 260,
            height = 176,
            shift = util.by_pixel(5, 0.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-09.png",
            width = 260,
            height = 184,
            shift = util.by_pixel(-5.5, -1),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-10.png",
            width = 233,
            height = 183,
            shift = util.by_pixel(-13.75, 1.25),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-11.png",
            width = 172,
            height = 184,
            shift = util.by_pixel(-9.5, 2),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-12.png",
            width = 260,
            height = 166,
            shift = util.by_pixel(2.5, -6.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-13.png",
            width = 259,
            height = 172,
            shift = util.by_pixel(4.75, -1),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-14.png",
            width = 199,
            height = 184,
            shift = util.by_pixel(-2.25, -2),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-15.png",
            width = 214,
            height = 184,
            shift = util.by_pixel(8.5, -3),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-16.png",
            width = 162,
            height = 182,
            shift = util.by_pixel(-8, -4.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-17.png",
            width = 222,
            height = 153,
            shift = util.by_pixel(-3, -0.25),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-18.png",
            width = 247,
            height = 184,
            shift = util.by_pixel(4.25, -2.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-19.png",
            width = 211,
            height = 184,
            shift = util.by_pixel(-5.75, -3),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-20.png",
            width = 248,
            height = 183,
            shift = util.by_pixel(-1.5, 2.25),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-21.png",
            width = 176,
            height = 184,
            shift = util.by_pixel(6.5, 1.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-22.png",
            width = 208,
            height = 185,
            shift = util.by_pixel(9, -1.75),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-23.png",
            width = 227,
            height = 184,
            shift = util.by_pixel(-3.75, -1.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-24.png",
            width = 158,
            height = 186,
            shift = util.by_pixel(4.5, -1),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-25.png",
            width = 260,
            height = 184,
            shift = util.by_pixel(1.5, -1.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-26.png",
            width = 134,
            height = 184,
            shift = util.by_pixel(-0.5, -1),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-27.png",
            width = 127,
            height = 165,
            shift = util.by_pixel(26.25, 1.25),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-28.png",
            width = 258,
            height = 158,
            shift = util.by_pixel(-2.5, -4.5),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/decorative/sand-dune-decal/sand-dune-decal-29.png",
            width = 180,
            height = 184,
            shift = util.by_pixel(-3.5, -2),
            scale = 0.5
          }
        }
      },

})