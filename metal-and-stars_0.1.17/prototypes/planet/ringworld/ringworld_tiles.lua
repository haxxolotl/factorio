
local tile_pollution = require("__space-age__/prototypes/tile/tile-pollution-values")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")

local tile_trigger_effects = require("__base__/prototypes/tile/tile-trigger-effects")

local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local tile_pollution = require("__space-age__/prototypes/tile/tile-pollution-values")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")

local sand_sounds = sound_variations("__base__/sound/walking/sand", 9, 0.8, volume_multiplier("main-menu", 2.9))
local sand_vehicle_speed_modifier = 1.8

local patch_for_inner_corner_of_transition_between_transition = tile_graphics.patch_for_inner_corner_of_transition_between_transition

local grass_vehicle_speed_modifier = 1.6

--recreating base locals

local grass_driving_sound =
{
  sound =
  {
    filename = "__base__/sound/driving/vehicle-surface-grass.ogg", volume = 0.5,
    advanced_volume_control = {fades = {fade_in = {curve_type = "cosine", from = {control = 0.5, volume_percentage = 0.0}, to = {1.5, 100.0 }}}}
  },
  fade_ticks = 6
}

local grass_sounds = sound_variations("__base__/sound/walking/grass", 10, 0.8, volume_multiplier("main-menu", 2.9))

local water_to_out_of_map_transition =
{
  to_tiles = out_of_map_tile_type_names,
  transition_group = out_of_map_transition_group_id,

  overlay_layer_group = "zero",
  apply_effect_color_to_overlay = true,

  background_layer_offset = 1,
  background_layer_group = "zero",
  offset_background_layer_by_tile_layer = true,

  spritesheet = "__base__/graphics/terrain/out-of-map-transition/water-out-of-map-transition-tintable.png",
  layout = tile_spritesheet_layout.transition_4_4_8_1_1,
  background_enabled = false,

  apply_waving_effect_on_masks = true,
  waving_effect_time_scale = 0.15 * 0.09,
  mask_enabled = true,
  mask_layout =
  {
    spritesheet = "__base__/graphics/terrain/masks/water-edge-transition.png",
    count = 1,
    double_side_count = 0,
    scale = 0.5,
    outer_corner_x = 64,
    side_x = 128,
    u_transition_x = 192,
    o_transition_x = 256,
    y = 0
  }
}

local grass_transitions =
{
  {
    to_tiles = water_tile_type_names,
    transition_group = water_transition_group_id,
    side_weights = { 1, 1, 1, 1,  0.25, 0.25, 1, 1,  1, 1, 0.125, 0.25,  1, 1, 1, 1 },

    spritesheet = "__base__/graphics/terrain/water-transitions/grass.png",
    layout = tile_spritesheet_layout.transition_16_16_16_4_8,
    background_enabled = false,
    effect_map_layout =
    {
      spritesheet = "__base__/graphics/terrain/effect-maps/water-grass-mask.png",
      o_transition_count = 1
    }
  },
  ground_to_out_of_map_transition
}

local grass_transitions_between_transitions =
{
  {
    transition_group1 = default_transition_group_id,
    transition_group2 = water_transition_group_id,

    spritesheet = "__base__/graphics/terrain/water-transitions/grass-transition.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0,
    background_enabled = false,
    effect_map_layout =
    {
      spritesheet = "__base__/graphics/terrain/effect-maps/water-grass-to-land-mask.png",
      o_transition_count = 0
    },
    water_patch = tile_graphics.patch_for_inner_corner_of_transition_between_transition
  },

  {
    transition_group1 = default_transition_group_id,
    transition_group2 = out_of_map_transition_group_id,

    background_layer_offset = 1,
    background_layer_group = "zero",
    offset_background_layer_by_tile_layer = true,

    spritesheet = "__base__/graphics/terrain/out-of-map-transition/grass-out-of-map-transition.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0,
    overlay_enabled = false
  },
  {
    transition_group1 = water_transition_group_id,
    transition_group2 = out_of_map_transition_group_id,

    background_layer_offset = 1,
    background_layer_group = "zero",
    offset_background_layer_by_tile_layer = true,

    spritesheet = "__base__/graphics/terrain/out-of-map-transition/grass-shore-out-of-map-transition.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0,
    effect_map_layout =
    {
      spritesheet = "__base__/graphics/terrain/effect-maps/water-grass-to-out-of-map-mask.png",
      o_transition_count = 0
    }
  }
}

local ground_to_out_of_map_transition =
{
  to_tiles = out_of_map_tile_type_names,
  transition_group = out_of_map_transition_group_id,

  background_layer_offset = 1,
  background_layer_group = "zero",
  offset_background_layer_by_tile_layer = true,

  spritesheet = "__base__/graphics/terrain/out-of-map-transition/out-of-map-transition.png",
  layout = tile_spritesheet_layout.transition_4_4_8_1_1,
  overlay_enabled = false
}

local sand_driving_sound =
{
  sound =
  {
    filename = "__base__/sound/driving/vehicle-surface-sand.ogg", volume = 0.8,
    advanced_volume_control = {fades = {fade_in = {curve_type = "cosine", from = {control = 0.5, volume_percentage = 0.0}, to = {1.5, 100.0 }}}}
  },
  fade_ticks = 6
}
local ground_to_out_of_map_transition =
{
  to_tiles = out_of_map_tile_type_names,
  transition_group = out_of_map_transition_group_id,

  background_layer_offset = 1,
  background_layer_group = "zero",
  offset_background_layer_by_tile_layer = true,

  spritesheet = "__base__/graphics/terrain/out-of-map-transition/out-of-map-transition.png",
  layout = tile_spritesheet_layout.transition_4_4_8_1_1,
  overlay_enabled = false
}
local sand_transitions =
{
  {
    to_tiles = water_tile_type_names,
    transition_group = water_transition_group_id,

    background_layer_group = "water",
    background_layer_offset = -5,
    masked_background_layer_offset = 1,
    offset_background_layer_by_tile_layer = false,

    spritesheet = "__base__/graphics/terrain/water-transitions/sand.png",
    layout = tile_spritesheet_layout.transition_16_16_16_4_8_short,
    background_enabled = false,
    effect_map_layout =
    {
      spritesheet = "__base__/graphics/terrain/effect-maps/water-sand-mask.png",
      --tile_height = 2,
      inner_corner_tile_height = 2,
      outer_corner_tile_height = 2,
      side_tile_height = 2,
      u_transition_tile_height = 2,
      o_transition_count = 1
    },
    background_mask_layout = tile_spritesheet_layout.simple_white_mask
  },
  ground_to_out_of_map_transition
}
local sand_transitions_between_transitions =
{
  {
    transition_group1 = default_transition_group_id,
    transition_group2 = water_transition_group_id,

    spritesheet = "__base__/graphics/terrain/water-transitions/sand-transition.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0_only_u_tall,
    background_enabled = false,
    effect_map_layout =
    {
      spritesheet = "__base__/graphics/terrain/effect-maps/water-sand-to-land-mask.png",
      inner_corner_tile_height = 2,
      outer_corner_tile_height = 2,
      side_tile_height = 2,
      o_transition_count = 0
    },
    water_patch = patch_for_inner_corner_of_transition_between_transition,
  },
  {
    transition_group1 = default_transition_group_id,
    transition_group2 = out_of_map_transition_group_id,

    background_layer_offset = 1,
    background_layer_group = "zero",
    offset_background_layer_by_tile_layer = true,

    spritesheet = "__base__/graphics/terrain/out-of-map-transition/sand-out-of-map-transition.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0,
    overlay_enabled = false
  },
  {
    transition_group1 = water_transition_group_id,
    transition_group2 = out_of_map_transition_group_id,

    background_layer_group = "water",
    background_layer_offset = -5,
    masked_background_layer_offset = 1,
    offset_background_layer_by_tile_layer = false,

    spritesheet = "__base__/graphics/terrain/out-of-map-transition/sand-shore-out-of-map-transition.png",
    layout = tile_spritesheet_layout.transition_3_3_3_1_0,
    effect_map_layout =
    {
      spritesheet = "__base__/graphics/terrain/effect-maps/water-sand-to-out-of-map-mask.png",
      o_transition_count = 0
    },
    background_mask_layout = tile_spritesheet_layout.simple_3_3_3_1_0_three_way_edge_mask,
    draw_simple_outer_corner_over_diagonal = false,
    apply_waving_effect_on_background_mask = true,
    waving_effect_time_scale = 0.15 * 0.09,
    water_patch = patch_for_inner_corner_of_transition_between_transition
  }
}
local water_to_out_of_map_transition =
{
  to_tiles = out_of_map_tile_type_names,
  transition_group = out_of_map_transition_group_id,

  overlay_layer_group = "zero",
  apply_effect_color_to_overlay = true,

  background_layer_offset = 1,
  background_layer_group = "zero",
  offset_background_layer_by_tile_layer = true,

  spritesheet = "__base__/graphics/terrain/out-of-map-transition/water-out-of-map-transition-tintable.png",
  layout = tile_spritesheet_layout.transition_4_4_8_1_1,
  background_enabled = false,

  apply_waving_effect_on_masks = true,
  waving_effect_time_scale = 0.15 * 0.09,
  mask_enabled = true,
  mask_layout =
  {
    spritesheet = "__base__/graphics/terrain/masks/water-edge-transition.png",
    count = 1,
    double_side_count = 0,
    scale = 0.5,
    outer_corner_x = 64,
    side_x = 128,
    u_transition_x = 192,
    o_transition_x = 256,
    y = 0
  }
}



    -----------///////////////////////////// NOISE STARTS
data:extend({
    {
        type = "noise-expression",
        name = "ringworld_mask",
        expression = "(y<=34) * (y>=-34)"
    },
    {
      type = "noise-expression",
      name = "ringworld_safe_zone",
      expression = "(x<128)*(x>-128)"
    },
    {
      type = "noise-expression",
      name = "ringworld_transition_lines",
      expression = "(x==128) + (x==-128)"
    },
    {
      type = "noise-expression",
      name = "ringworld_safe_mask",
      expression = "ringworld_mask*ringworld_safe_zone"
    },
    {
      type = "noise-expression",
      name = "ringworld_danger_mask",
      expression = "ringworld_mask*(1-ringworld_safe_zone)"
    },
    {
      type = "noise-expression",
      name = "ringworld_left_mask",
      expression = "(x<0) * ringworld_danger_mask"
    },
    {
      type = "noise-expression",
      name = "ringworld_right_mask",
      expression = "(x>0) * ringworld_danger_mask"
    },
    -- tiles
    {
      type = "noise-expression",
      name = "safe_grass",
      expression = "ringworld_safe_mask"
    },
    {
      type = "noise-expression",
      name = "safe_grass_light",
      expression = "ringworld_safe_mask"
    },
    {
      type = "noise-expression",
      name = "safe_grass_dark",
      expression = "ringworld_safe_mask"
    },
    {
      type = "noise-expression",
      name = "ring_sand_1",
      expression = "ringworld_right_mask * (max(expression_in_range_base(-10, -10, 0.25, 0.15),\z
                                                 expression_in_range(5, inf, elevation, aux, -1.5, 0.5, 1.5, 1)) +\z
                                             noise_layer_noise(36))"
    },
    {
      type = "noise-expression",
      name = "ring_sand_2",
      expression = "ringworld_right_mask - ring_sand_1"
    },
    {
      type = "noise-expression",
      name = "ring_undergrowth_thin",
      expression = "ringworld_left_mask"
    },
    {
      type = "noise-expression",
      name = "ring_undergrowth_thin_dark",
      expression = "ringworld_left_mask"
    },
    {
      type = "noise-expression",
      name = "ring_undergrowth_thick",
      expression = "ringworld_left_mask"
    },
    {
      type = "noise-expression",
      name = "ring_undergrowth_thick_dark",
      expression = "ringworld_left_mask"
    },
    -----------////////////////////////////////////////////////////////////// SAND-1
    {
      name = "sand-1-ringworld",
      type = "tile",
      order = "a[natural]-r[ring]-a[sand-1]",
      subgroup = "nauvis-tiles",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'ring_sand_1'},
      layer = 8,
  
      variants = tile_variations_template(
        "__base__/graphics/terrain/sand-1.png", "__base__/graphics/terrain/masks/transition-4.png",
        {
          max_size = 8,
          [2] = { probability = 0.39, weights = {0.025, 0.010, 0.013, 0.025, 0.025, 0.100, 0.100, 0.005, 0.010, 0.010, 0.005, 0.005, 0.001, 0.015, 0.020, 0.020} },
          [4] = { probability = 0.20, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} },
          [8] = { probability = 0.10, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
        }
      ),
  
      transitions = sand_transitions,
      transitions_between_transitions = sand_transitions_between_transitions,
  
      walking_sound = sand_sounds,
      driving_sound = sand_driving_sound,
      map_color={138, 103, 58},
      scorch_mark_color = {r = 0.588, g = 0.451, b = 0.272, a = 1.000},
      absorptions_per_second = tile_pollution.sand,
      vehicle_friction_modifier = sand_vehicle_speed_modifier,
  
      trigger_effect = tile_trigger_effects.sand_trigger_effect(),
  
    },
        -----------////////////////////////////////////////////////////////////// SAND-2
        {
          name = "sand-2-ringworld",
          type = "tile",
          order = "a[natural]-r[ring]-b[sand-2]",
          subgroup = "nauvis-tiles",
          collision_mask = tile_collision_masks.ground(),
          autoplace = {probability_expression = 'ring_sand_2'},
          layer = 9,
    
          variants = tile_variations_template(
            "__base__/graphics/terrain/sand-2.png", "__base__/graphics/terrain/masks/transition-4.png",
            {
              max_size = 8,
              [2] = { probability = 0.39, weights = {0.025, 0.010, 0.013, 0.025, 0.025, 0.100, 0.100, 0.005, 0.010, 0.010, 0.005, 0.005, 0.001, 0.015, 0.020, 0.020} },
              [4] = { probability = 0.20, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} },
              [8] = { probability = 0.10, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
            }
          ),
          factoriopedia_alternative = "sand-1",
    
          transitions = sand_transitions,
          transitions_between_transitions = sand_transitions_between_transitions,
    
          walking_sound = sand_sounds,
          driving_sound = sand_driving_sound,
          map_color={128, 93, 52},
          scorch_mark_color = {r = 0.600, g = 0.440, b = 0.252, a = 1.000},
          absorptions_per_second = tile_pollution.sand,
          vehicle_friction_modifier = sand_vehicle_speed_modifier,
    
          trigger_effect = tile_trigger_effects.sand_trigger_effect()
        },
    -----------//////////////////////////////////////////////////////////////GRASS-2 - potato
    {
    name = "blue-grass-2",
    type = "tile",
    order = "b[natural]-r[ring]-b[grass-2]",
    subgroup = "nauvis-tiles",
    collision_mask = tile_collision_masks.ground(),
    autoplace = {probability_expression = 'safe_grass'},
    layer = 28,
    variants = tile_variations_template(
      "__metal-and-stars-graphics__/graphics/terrain/grass-2.png", "__base__/graphics/terrain/masks/transition-3.png",
      {
        max_size = 4,
        [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
        [2] = { probability = 0.91, weights = {0.150, 0.150, 0.150, 0.150, 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025 }, },
        [4] = { probability = 0.75, weights = {0.085, 0.085, 0.085, 0.075, 0.057, 0.055, 0.085, 0.075, 0.035, 0.015, 0.001, 0.025, 0.005, 0.025, 0.045, 0.045 }, },
        --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
      }
    ),
    factoriopedia_alternative = "grass-1",

    transitions = grass_transitions,
    transitions_between_transitions = grass_transitions_between_transitions,

    walking_sound = grass_sounds,
    driving_sound = grass_driving_sound,
    map_color={66, 57, 15},
    scorch_mark_color = {r = 0.361, g = 0.251, b = 0.170, a = 1.000},
    absorptions_per_second = tile_pollution.grass,
    vehicle_friction_modifier = grass_vehicle_speed_modifier,
    can_be_part_of_blueprint = false,

    trigger_effect = tile_trigger_effects.grass_2_trigger_effect()
  },
  {
    name = "blue-grass-2-light",
    type = "tile",
    order = "b[natural]-r[ring]-b[grass-2]",
    subgroup = "nauvis-tiles",
    collision_mask = tile_collision_masks.ground(),
    autoplace = {probability_expression = 'safe_grass_light'},
    layer = 28,
    variants = tile_variations_template(
      "__metal-and-stars-graphics__/graphics/terrain/grass-2-light.png", "__base__/graphics/terrain/masks/transition-3.png",
      {
        max_size = 4,
        [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
        [2] = { probability = 0.91, weights = {0.150, 0.150, 0.150, 0.150, 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025 }, },
        [4] = { probability = 0.75, weights = {0.085, 0.085, 0.085, 0.075, 0.057, 0.055, 0.085, 0.075, 0.035, 0.015, 0.001, 0.025, 0.005, 0.025, 0.045, 0.045 }, },
        --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
      }
    ),
    factoriopedia_alternative = "grass-1",

    transitions = grass_transitions,
    transitions_between_transitions = grass_transitions_between_transitions,

    walking_sound = grass_sounds,
    driving_sound = grass_driving_sound,
    map_color={66, 57, 15},
    scorch_mark_color = {r = 0.361, g = 0.251, b = 0.170, a = 1.000},
    absorptions_per_second = tile_pollution.grass,
    vehicle_friction_modifier = grass_vehicle_speed_modifier,
    can_be_part_of_blueprint = false,

    trigger_effect = tile_trigger_effects.grass_2_trigger_effect()
  },
  {
    name = "blue-grass-2-dark",
    type = "tile",
    order = "b[natural]-r[ring]-b[grass-2]",
    subgroup = "nauvis-tiles",
    collision_mask = tile_collision_masks.ground(),
    autoplace = {probability_expression = 'safe_grass_dark'},
    layer = 28,
    variants = tile_variations_template(
      "__metal-and-stars-graphics__/graphics/terrain/grass-2-dark.png", "__base__/graphics/terrain/masks/transition-3.png",
      {
        max_size = 4,
        [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
        [2] = { probability = 0.91, weights = {0.150, 0.150, 0.150, 0.150, 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025 }, },
        [4] = { probability = 0.75, weights = {0.085, 0.085, 0.085, 0.075, 0.057, 0.055, 0.085, 0.075, 0.035, 0.015, 0.001, 0.025, 0.005, 0.025, 0.045, 0.045 }, },
        --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
      }
    ),
    factoriopedia_alternative = "grass-1",

    transitions = grass_transitions,
    transitions_between_transitions = grass_transitions_between_transitions,

    walking_sound = grass_sounds,
    driving_sound = grass_driving_sound,
    map_color={66, 57, 15},
    scorch_mark_color = {r = 0.361, g = 0.251, b = 0.170, a = 1.000},
    absorptions_per_second = tile_pollution.grass,
    vehicle_friction_modifier = grass_vehicle_speed_modifier,
    can_be_part_of_blueprint = false,

    trigger_effect = tile_trigger_effects.grass_2_trigger_effect()
  },

        ----------UNDERGROWTH TILES
        {
          name = "undergrowth-thin",
          type = "tile",
          order = "b[natural]-r[ring]-a[grass-1]",
          collision_mask = tile_collision_masks.ground(),
          autoplace = {probability_expression = 'ring_undergrowth_thin'},
          layer = 26,
          variants = tile_variations_template(
            "__metal-and-stars-graphics__/graphics/terrain/undergrowth-thin.png", "__base__/graphics/terrain/masks/transition-3.png",
            {
              max_size = 4,
              [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
              [2] = { probability = 0.91, weights = {0.150, 0.150, 0.150, 0.150, 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025 }, },
              [4] = { probability = 0.91, weights = {0.100, 0.80, 0.80, 0.100, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 }, },
              --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
            }
          ),
          subgroup = "nauvis-tiles",
      
          transitions = grass_transitions,
          transitions_between_transitions = grass_transitions_between_transitions,
      
          walking_sound = grass_sounds,
          driving_sound = grass_driving_sound,
          map_color={55, 53, 11},
          scorch_mark_color = {r = 0.318, g = 0.222, b = 0.152, a = 1.000},
          absorptions_per_second = tile_pollution.grass,
          vehicle_friction_modifier = grass_vehicle_speed_modifier,
      
          trigger_effect = tile_trigger_effects.grass_1_trigger_effect()
        },
        {
          name = "undergrowth-thin-dark",
          type = "tile",
          order = "b[natural]-r[ring]-a[grass-1]",
          collision_mask = tile_collision_masks.ground(),
          autoplace = {probability_expression = 'ring_undergrowth_thin_dark'},
          layer = 26,
          variants = tile_variations_template(
            "__metal-and-stars-graphics__/graphics/terrain/undergrowth-thin-dark.png", "__base__/graphics/terrain/masks/transition-3.png",
            {
              max_size = 4,
              [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
              [2] = { probability = 0.91, weights = {0.150, 0.150, 0.150, 0.150, 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025 }, },
              [4] = { probability = 0.91, weights = {0.100, 0.80, 0.80, 0.100, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 }, },
              --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
            }
          ),
          subgroup = "nauvis-tiles",
      
          transitions = grass_transitions,
          transitions_between_transitions = grass_transitions_between_transitions,
      
          walking_sound = grass_sounds,
          driving_sound = grass_driving_sound,
          map_color={55, 53, 11},
          scorch_mark_color = {r = 0.318, g = 0.222, b = 0.152, a = 1.000},
          absorptions_per_second = tile_pollution.grass,
          vehicle_friction_modifier = grass_vehicle_speed_modifier,
      
          trigger_effect = tile_trigger_effects.grass_1_trigger_effect()
        },
        {
          name = "undergrowth-thick",
          type = "tile",
          order = "b[natural]-r[ring]-a[grass-1]",
          collision_mask = tile_collision_masks.ground(),
          autoplace = {probability_expression = 'ring_undergrowth_thick'},
          layer = 26,
          variants = tile_variations_template(
            "__metal-and-stars-graphics__/graphics/terrain/undergrowth-thick.png", "__base__/graphics/terrain/masks/transition-3.png",
            {
              max_size = 4,
              [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
              [2] = { probability = 0.91, weights = {0.150, 0.150, 0.150, 0.150, 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025 }, },
              [4] = { probability = 0.91, weights = {0.100, 0.80, 0.80, 0.100, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 }, },
              --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
            }
          ),
          subgroup = "nauvis-tiles",
      
          transitions = grass_transitions,
          transitions_between_transitions = grass_transitions_between_transitions,
      
          walking_sound = grass_sounds,
          driving_sound = grass_driving_sound,
          map_color={55, 53, 11},
          scorch_mark_color = {r = 0.318, g = 0.222, b = 0.152, a = 1.000},
          absorptions_per_second = tile_pollution.grass,
          vehicle_friction_modifier = grass_vehicle_speed_modifier,
      
          trigger_effect = tile_trigger_effects.grass_1_trigger_effect()
        },
        {
          name = "undergrowth-thick-dark",
          type = "tile",
          order = "b[natural]-r[ring]-b[grass-2]",
          subgroup = "nauvis-tiles",
          collision_mask = tile_collision_masks.ground(),
          autoplace = {probability_expression = 'ring_undergrowth_thick_dark'},
          layer = 28,
          variants = tile_variations_template(
            "__metal-and-stars-graphics__/graphics/terrain/undergrowth-thick-dark.png", "__base__/graphics/terrain/masks/transition-3.png",
            {
              max_size = 4,
              [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
              [2] = { probability = 0.91, weights = {0.150, 0.150, 0.150, 0.150, 0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025 }, },
              [4] = { probability = 0.75, weights = {0.085, 0.085, 0.085, 0.075, 0.057, 0.055, 0.085, 0.075, 0.035, 0.015, 0.001, 0.025, 0.005, 0.025, 0.045, 0.045 }, },
              --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
            }
          ),
          factoriopedia_alternative = "grass-1",
      
          transitions = grass_transitions,
          transitions_between_transitions = grass_transitions_between_transitions,
      
          walking_sound = grass_sounds,
          driving_sound = grass_driving_sound,
          map_color={66, 57, 15},
          scorch_mark_color = {r = 0.361, g = 0.251, b = 0.170, a = 1.000},
          absorptions_per_second = tile_pollution.grass,
          vehicle_friction_modifier = grass_vehicle_speed_modifier,
          can_be_part_of_blueprint = false,
      
          trigger_effect = tile_trigger_effects.grass_2_trigger_effect()
        },

})




