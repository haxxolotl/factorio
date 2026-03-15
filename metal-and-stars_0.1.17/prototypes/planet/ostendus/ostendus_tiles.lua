
local tile_pollution = require("__space-age__/prototypes/tile/tile-pollution-values")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")

local tile_trigger_effects = require("__base__/prototypes/tile/tile-trigger-effects")

local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

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

table.insert(data.raw.item.landfill.place_as_tile.tile_condition, "crater-water");
table.insert(data.raw.item.landfill.place_as_tile.tile_condition, "crater-water-deep");

data:extend({
  {
    type = "tile",
    name = "crater-water",
    order = "a[water]-a[water]",
    collision_mask = tile_collision_masks.water(),
    subgroup = "nauvis-tiles",
    fluid = "water",
    autoplace = {probability_expression = "max(lava_basalts_range, lava_mountains_range)"},
    effect = "water",
    effect_color = { 21, 147, 167 },
    effect_color_secondary = { 49, 80, 14 },
    particle_tints = tile_graphics.water_particle_tints,
    layer_group = "water",
    layer = 3,
    variants =
    {
      main =
      {
        {
          picture = "__base__/graphics/terrain/water/water1.png",
          count = 1,
          scale = 0.5,
          size = 1
        },
        {
          picture = "__base__/graphics/terrain/water/water2.png",
          count = 1,
          scale = 0.5,
          size = 2
        },
        {
          picture = "__base__/graphics/terrain/water/water4.png",
          count = 1,
          scale = 0.5,
          size = 4
        }
      },
      empty_transitions = true
    },
    transitions = { water_to_out_of_map_transition },
    map_color={51, 83, 95},
    absorptions_per_second = tile_pollution.water,

    trigger_effect = tile_trigger_effects.water_trigger_effect(),

    default_cover_tile = "landfill",

    ambient_sounds =
    {
      sound =
      {
        variations = sound_variations("__base__/sound/world/water/waterlap", 10, 0.6 ),
        advanced_volume_control =
        {
          fades = { fade_in = { curve_type = "S-curve", from = { control = 0.5, volume_percentage = 0.0 }, to = { 1.5, 100.0 } } }
        }
      },
      radius = 7.5,
      min_entity_count = 10,
      max_entity_count = 30,
      entity_to_sound_ratio = 0.1,
      average_pause_seconds = 3
    }
  },
  ----------- "DEEP" water
  {
    type = "tile",
    name = "crater-water-deep",
    order = "a[water]-b[deep-water]",
    subgroup = "nauvis-tiles",
    transition_merges_with_tile = "water",
    collision_mask = tile_collision_masks.water(),
    fluid = "water",
    autoplace = {probability_expression = "max(lava_hot_basalts_range, lava_hot_mountains_range)"},
    effect = "water",
    effect_color = {0.135, 0.507, 0.583},--{ 23, 111, 129 }, -- { 30, 76, 94 }
    effect_color_secondary = { 45, 68, 25 },
    particle_tints = tile_graphics.deepwater_particle_tints,
    layer_group = "water",
    layer = 3,
    variants =
    {
      main =
      {
        {
          picture = "__base__/graphics/terrain/deepwater/deepwater1.png",
          count = 1,
          scale = 0.5,
          size = 1
        },
        {
          picture = "__base__/graphics/terrain/deepwater/deepwater2.png",
          count = 1,
          scale = 0.5,
          size = 2
        },
        {
          picture = "__base__/graphics/terrain/deepwater/deepwater4.png",
          count = 1,
          scale = 0.5,
          size = 4
        }
      },
      empty_transitions = true
    },
    --transitions = { deepwater_out_of_map_transition },
    --transitions_between_transitions = deepwater_transitions_between_transitions,
    allowed_neighbors = { "water" },
    map_color={38, 64, 73},
    absorptions_per_second = tile_pollution.water,

    trigger_effect = tile_trigger_effects.water_trigger_effect(),

    default_cover_tile = "landfill",

    ambient_sounds =
    {
      sound =
      {
        variations = sound_variations("__base__/sound/world/water/waterlap", 10, 0.4 ),
        advanced_volume_control =
        {
          fades = { fade_in = { curve_type = "S-curve", from = { control = 0.5, volume_percentage = 0.0 }, to = { 1.5, 100.0 } } }
        }
      },
      radius = 7.5,
      min_entity_count = 10,
      max_entity_count = 30,
      entity_to_sound_ratio = 0.1,
      average_pause_seconds = 3
    }
  },
    -----------//////////////////////////////////////////////////////////////GRASS-1
    {
      name = "blue-grass-1",
      type = "tile",
      order = "b[natural]-a[grass]-a[grass-1]",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'volcanic_ash_soil_range'},
      layer = 26,
      variants = tile_variations_template(
        "__metal-and-stars-graphics__/graphics/terrain/grass-1.png", "__base__/graphics/terrain/masks/transition-3.png",
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
      name = "blue-grass-1-light",
      type = "tile",
      order = "b[natural]-a[grass]-a[grass-1]",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'volcanic_soil_light_range'},
      layer = 26,
      variants = tile_variations_template(
        "__metal-and-stars-graphics__/graphics/terrain/grass-1.png", "__base__/graphics/terrain/masks/transition-3.png",
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
      name = "blue-grass-1-dark",
      type = "tile",
      order = "b[natural]-a[grass]-a[grass-1]",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'volcanic_soil_dark_range'},
      layer = 26,
      variants = tile_variations_template(
        "__metal-and-stars-graphics__/graphics/terrain/grass-1.png", "__base__/graphics/terrain/masks/transition-3.png",
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

    -----------//////////////////////////////////////////////////////////////GRASS-3
    {
      name = "teal-grass-3",
      type = "tile",
      order = "b[natural]-a[grass]-c[grass-3]",
      subgroup = "nauvis-tiles",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'volcanic_pumice_stones_range+volcanic_cracks_cold_range'},
      layer = 29,
      variants = tile_variations_template(
        "__metal-and-stars-graphics__/graphics/terrain/grass-3.png", "__base__/graphics/terrain/masks/transition-3.png",
        {
          max_size = 4,
          [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
          [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
        }
      ),
      factoriopedia_alternative = "grass-1",
  
      transitions = grass_transitions,
      transitions_between_transitions = grass_transitions_between_transitions,
  
      walking_sound = grass_sounds,
      driving_sound = grass_driving_sound,
      map_color={65, 52, 28},
      scorch_mark_color = {r = 0.353, g = 0.244, b = 0.155, a = 1.000},
      absorptions_per_second = tile_pollution.grass,
      vehicle_friction_modifier = grass_vehicle_speed_modifier,
  
      trigger_effect = tile_trigger_effects.grass_3_trigger_effect()
    },
    {
      name = "teal-grass-3-dark",
      type = "tile",
      order = "b[natural]-a[grass]-c[grass-3]",
      subgroup = "nauvis-tiles",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'volcanic_smooth_stone_range'},
      layer = 29,
      variants = tile_variations_template(
        "__metal-and-stars-graphics__/graphics/terrain/grass-3-dark.png", "__base__/graphics/terrain/masks/transition-3.png",
        {
          max_size = 4,
          [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
          [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
        }
      ),
      factoriopedia_alternative = "grass-1",
  
      transitions = grass_transitions,
      transitions_between_transitions = grass_transitions_between_transitions,
  
      walking_sound = grass_sounds,
      driving_sound = grass_driving_sound,
      map_color={65, 52, 28},
      scorch_mark_color = {r = 0.353, g = 0.244, b = 0.155, a = 1.000},
      absorptions_per_second = tile_pollution.grass,
      vehicle_friction_modifier = grass_vehicle_speed_modifier,
  
      trigger_effect = tile_trigger_effects.grass_3_trigger_effect()
    },
    {
      name = "teal-grass-3-light",
      type = "tile",
      order = "b[natural]-a[grass]-c[grass-3]",
      subgroup = "nauvis-tiles",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'volcanic_ash_cracks_range'},
      layer = 29,
      variants = tile_variations_template(
        "__metal-and-stars-graphics__/graphics/terrain/grass-3-dark.png", "__base__/graphics/terrain/masks/transition-3.png",
        {
          max_size = 4,
          [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
          [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
        }
      ),
      factoriopedia_alternative = "grass-1",
  
      transitions = grass_transitions,
      transitions_between_transitions = grass_transitions_between_transitions,
  
      walking_sound = grass_sounds,
      driving_sound = grass_driving_sound,
      map_color={65, 52, 28},
      scorch_mark_color = {r = 0.353, g = 0.244, b = 0.155, a = 1.000},
      absorptions_per_second = tile_pollution.grass,
      vehicle_friction_modifier = grass_vehicle_speed_modifier,
  
      trigger_effect = tile_trigger_effects.grass_3_trigger_effect()
    },
  -----------//////////////////////////////////////////////////////////////GRASS-4
    {
      name = "leaf-cover",
      type = "tile",
      order = "b[natural]-a[grass]-d[grass-4]",
      subgroup = "nauvis-tiles",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'volcanic_folds_range'},
      layer = 30,
      variants = tile_variations_template(
        "__metal-and-stars-graphics__/graphics/terrain/leaf-cover.png", "__base__/graphics/terrain/masks/transition-3.png",
        {
          max_size = 4,
          [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
          [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          [4] = { probability = 0.5, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
        }
      ),
      factoriopedia_alternative = "grass-1",
  
      transitions = grass_transitions,
      transitions_between_transitions = grass_transitions_between_transitions,
  
      walking_sound = grass_sounds,
      driving_sound = grass_driving_sound,
      map_color={59, 40, 18},
      scorch_mark_color = {r = 0.325, g = 0.242, b = 0.133, a = 1.000},
      absorptions_per_second = tile_pollution.grass,
      vehicle_friction_modifier = grass_vehicle_speed_modifier,
  
      trigger_effect = tile_trigger_effects.grass_4_trigger_effect()
    },
    {
      name = "leaf-cover-light",
      type = "tile",
      order = "b[natural]-a[grass]-d[grass-4]",
      subgroup = "nauvis-tiles",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'volcanic_jagged_ground_range'},
      layer = 30,
      variants = tile_variations_template(
        "__metal-and-stars-graphics__/graphics/terrain/leaf-cover-light.png", "__base__/graphics/terrain/masks/transition-3.png",
        {
          max_size = 4,
          [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
          [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          [4] = { probability = 0.5, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
        }
      ),
      factoriopedia_alternative = "grass-1",
  
      transitions = grass_transitions,
      transitions_between_transitions = grass_transitions_between_transitions,
  
      walking_sound = grass_sounds,
      driving_sound = grass_driving_sound,
      map_color={59, 40, 18},
      scorch_mark_color = {r = 0.325, g = 0.242, b = 0.133, a = 1.000},
      absorptions_per_second = tile_pollution.grass,
      vehicle_friction_modifier = grass_vehicle_speed_modifier,
  
      trigger_effect = tile_trigger_effects.grass_4_trigger_effect()
    },
    {
      name = "leaf-cover-dark",
      type = "tile",
      order = "b[natural]-a[grass]-d[grass-4]",
      subgroup = "nauvis-tiles",
      collision_mask = tile_collision_masks.ground(),
      autoplace = {probability_expression = 'volcanic_folds_flat_range'},
      layer = 30,
      variants = tile_variations_template(
        "__metal-and-stars-graphics__/graphics/terrain/leaf-cover-dark.png", "__base__/graphics/terrain/masks/transition-3.png",
        {
          max_size = 4,
          [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
          [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          [4] = { probability = 0.5, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
        }
      ),
      factoriopedia_alternative = "grass-1",
  
      transitions = grass_transitions,
      transitions_between_transitions = grass_transitions_between_transitions,
  
      walking_sound = grass_sounds,
      driving_sound = grass_driving_sound,
      map_color={59, 40, 18},
      scorch_mark_color = {r = 0.325, g = 0.242, b = 0.133, a = 1.000},
      absorptions_per_second = tile_pollution.grass,
      vehicle_friction_modifier = grass_vehicle_speed_modifier,
  
      trigger_effect = tile_trigger_effects.grass_4_trigger_effect()
    },


})




