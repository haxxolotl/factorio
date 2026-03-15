
local tile_pollution = require("__space-age__/prototypes/tile/tile-pollution-values")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")

local tile_trigger_effects = require("__base__/prototypes/tile/tile-trigger-effects")

local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local tile_pollution = require("__space-age__/prototypes/tile/tile-pollution-values")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")

local snow_sounds = sound_variations("__space-age__/sound/walking/snow", 10, 0.8, volume_multiplier("main-menu", 2.9))
local icy_snow_sounds = sound_variations("__space-age__/sound/walking/icy-snow", 10, 0.8, volume_multiplier("main-menu", 2.9))
local ice_sounds = sound_variations("__space-age__/sound/walking/ice", 10, 0.8, volume_multiplier("main-menu", 2.9))
local smooth_ice_sounds = sound_variations("__space-age__/sound/walking/smooth-ice", 9, 0.8)
local frozen_concrete_sounds = sound_variations("__space-age__/sound/walking/frozen-concrete", 11, 0.8)

local floating_cloud_variants = tile_variations_template(
  "__metal-and-stars-graphics-2__/graphics/terrain/clouds-floating.png", "__base__/graphics/terrain/masks/transition-4.png",
  {
    max_size = 4,
    [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
    [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
    [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015 }, },
  }
)
floating_cloud_variants.draw_background_layer_under_tiles = true


data:extend({
    {
        type = "tile",
        name = "clouds-lumpy",
        subgroup = "aquilo-tiles",
        order = "b[natural]-i[ice]-a[snow]",
        collision_mask = tile_collision_masks.water(),
        autoplace = {probability_expression = .5},
        tint = {255, 182, 182},
        layer =  0,
        variants = tile_variations_template(
          "__metal-and-stars-graphics-2__/graphics/terrain/volantus-surface.png", "__base__/graphics/terrain/masks/transition-4.png",
          {
            max_size = 4,
            [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
            [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
            [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015 }, },
          }
        ),
        walking_sound = snow_sounds,
        landing_steps_sound = tile_sounds.landing.snow,
        map_color = {255, 182, 182},
        scorch_mark_color = {r = 0.318, g = 0.222, b = 0.152, a = 1.000},
        absorptions_per_second = tile_pollution.ice,
    
        trigger_effect = tile_trigger_effects.grass_1_trigger_effect()
      },
      {
        type = "tile",
        name = "volantus-center-ship",
        subgroup = "aquilo-tiles",
        order = "b[natural]-i[ice]-a[snow]",
        collision_mask = tile_collision_masks.ground(),
        autoplace = {probability_expression = "volantus_center_ship"},
        tint = {5, 5, 5},
        layer =  5,
        variants = tile_variations_template(
          "__metal-and-stars-graphics-2__/graphics/terrain/clouds-crests.png", "__base__/graphics/terrain/masks/transition-4.png",
          {
            max_size = 4,
            [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
            [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
            [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015 }, },
            --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
          }
        ),

    
        walking_sound = snow_sounds,
        landing_steps_sound = tile_sounds.landing.snow,
        map_color = {255, 182, 182},
        scorch_mark_color = {r = 0.318, g = 0.222, b = 0.152, a = 1.000},
        absorptions_per_second = tile_pollution.ice,
    
        trigger_effect = tile_trigger_effects.grass_1_trigger_effect()
      },
})




