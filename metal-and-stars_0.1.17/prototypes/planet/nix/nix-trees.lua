--hoping to make some nice glowy pine trees eventually

local sounds = require("__base__.prototypes.entity.sounds")
local tree_emissions = { pollution = -0.001 }
local dead_tree_emissions = { pollution = -0.0001 }
local leaf_sound = sounds.tree_leaves

local leaf_sound_trigger =
{
  {
    type = "play-sound",
    sound = leaf_sound,
    damage_type_filters = "fire"
  }
}

local tree_types =
{
  { -- tree-01
    { -- a
      trunk =
      {
        width = 140,
        height = 340,
        shift = util.by_pixel(2, -69),
        scale = 0.5
      },
      stump =
      {
        width = 76,
        height = 68,
        shift = util.by_pixel(-1, -1),
        scale = 0.5
      },
      shadow =
      {
        width = 324,
        height = 134,
        shift = util.by_pixel(61, -2),
        scale = 0.5
      },
      leaves =
      {
        width = 184,
        height = 306,
        shift = util.by_pixel(-1, -74),
        scale = 0.5
      },
      normal =
      {
        width = 184,
        height = 290,
        shift = util.by_pixel(-0.5, -76),
        scale = 0.5
      }
    },
    { -- b
      trunk =
      {
        width = 132,
        height = 326,
        shift = util.by_pixel(4, -66),
        scale = 0.5
      },
      stump =
      {
        width = 72,
        height = 66,
        shift = util.by_pixel(0, -1),
        scale = 0.5
      },
      shadow =
      {
        width = 312,
        height = 126,
        shift = util.by_pixel(64, 0),
        scale = 0.5
      },
      leaves =
      {
        width = 182,
        height = 316,
        shift = util.by_pixel(1, -72),
        scale = 0.5
      },
      normal =
      {
        width = 180,
        height = 300,
        shift = util.by_pixel(2, -75),
        scale = 0.5
      }
    },
    { -- c
      trunk =
      {
        width = 136,
        height = 330,
        shift = util.by_pixel(-4, -68),
        scale = 0.5
      },
      stump =
      {
        width = 74,
        height = 62,
        shift = util.by_pixel(0, -1),
        scale = 0.5
      },
      shadow =
      {
        width = 306,
        height = 132,
        shift = util.by_pixel(59, 0),
        scale = 0.5
      },
      leaves =
      {
        width = 180,
        height = 308,
        shift = util.by_pixel(0, -72),
        scale = 0.5
      },
      normal =
      {
        width = 182,
        height = 306,
        shift = util.by_pixel(0.5, -70),
        scale = 0.5
      }
    },
    { -- d
      trunk =
      {
        width = 108,
        height = 324,
        shift = util.by_pixel(2, -67),
        scale = 0.5
      },
      stump =
      {
        width = 82,
        height = 68,
        shift = util.by_pixel(0, -3),
        scale = 0.5
      },
      shadow =
      {
        width = 288,
        height = 130,
        shift = util.by_pixel(59, -3),
        scale = 0.5
      },
      leaves =
      {
        width = 188,
        height = 310,
        shift = util.by_pixel(1, -72),
        scale = 0.5
      },
      normal =
      {
        width = 188,
        height = 286,
        shift = util.by_pixel(2, -75.5),
        scale = 0.5
      }
    },
    { -- e
      trunk =
      {
        width = 138,
        height = 324,
        shift = util.by_pixel(2, -66),
        scale = 0.5
      },
      stump =
      {
        width = 78,
        height = 62,
        shift = util.by_pixel(0, -1),
        scale = 0.5
      },
      shadow =
      {
        width = 314,
        height = 136,
        shift = util.by_pixel(67, 1),
        scale = 0.5
      },
      leaves =
      {
        width = 190,
        height = 300,
        shift = util.by_pixel(3, -71),
        scale = 0.5
      },
      normal =
      {
        width = 190,
        height = 280,
        shift = util.by_pixel(4, -68),
        scale = 0.5
      }
    },
    { -- f
      trunk =
      {
        width = 118,
        height = 326,
        shift = util.by_pixel(-4, -65),
        scale = 0.5
      },
      stump =
      {
        width = 76,
        height = 70,
        shift = util.by_pixel(0, -1),
        scale = 0.5
      },
      shadow =
      {
        width = 304,
        height = 140,
        shift = util.by_pixel(56, 1),
        scale = 0.5
      },
      leaves =
      {
        width = 190,
        height = 304,
        shift = util.by_pixel(-3, -67),
        scale = 0.5
      },
      normal =
      {
        width = 190,
        height = 278,
        shift = util.by_pixel(-2, -71),
        scale = 0.5
      }
    },
    { -- g
      trunk =
      {
        width = 142,
        height = 294,
        shift = util.by_pixel(-2, -59),
        scale = 0.5
      },
      stump =
      {
        width = 72,
        height = 62,
        shift = util.by_pixel(-1, -1),
        scale = 0.5
      },
      shadow =
      {
        width = 252,
        height = 130,
        shift = util.by_pixel(41, -2),
        scale = 0.5
      },
      leaves =
      {
        width = 184,
        height = 274,
        shift = util.by_pixel(-3, -61),
        scale = 0.5
      },
      normal =
      {
        width = 186,
        height = 248,
        shift = util.by_pixel(-2.5, -62),
        scale = 0.5
      }
    },
    { -- h
      trunk =
      {
        width = 116,
        height = 296,
        shift = util.by_pixel(4, -60),
        scale = 0.5
      },
      stump =
      {
        width = 70,
        height = 64,
        shift = util.by_pixel(-1, -2),
        scale = 0.5
      },
      shadow =
      {
        width = 266,
        height = 130,
        shift = util.by_pixel(55, -3),
        scale = 0.5
      },
      leaves =
      {
        width = 180,
        height = 282,
        shift = util.by_pixel(1, -63),
        scale = 0.5
      },
      normal =
      {
        width = 180,
        height = 244,
        shift = util.by_pixel(1.5, -61),
        scale = 0.5
      }
    },
    { -- i
      trunk =
      {
        width = 120,
        height = 244,
        shift = util.by_pixel(0, -49),
        scale = 0.5
      },
      stump =
      {
        width = 82,
        height = 68,
        shift = util.by_pixel(2, -5),
        scale = 0.5
      },
      shadow =
      {
        width = 228,
        height = 118,
        shift = util.by_pixel(50, 3),
        scale = 0.5
      },
      leaves =
      {
        width = 152,
        height = 234,
        shift = util.by_pixel(-2, -52),
        scale = 0.5
      },
      normal =
      {
        width = 152,
        height = 196,
        shift = util.by_pixel(-1.5, -56.5),
        scale = 0.5
      }
    },
    { -- j
      trunk =
      {
        width = 110,
        height = 250,
        shift = util.by_pixel(0, -50),
        scale = 0.5
      },
      stump =
      {
        width = 74,
        height = 74,
        shift = util.by_pixel(3, -6),
        scale = 0.5
      },
      shadow =
      {
        width = 212,
        height = 104,
        shift = util.by_pixel(50, -3),
        scale = 0.5
      },
      leaves =
      {
        width = 134,
        height = 228,
        shift = util.by_pixel(0, -51),
        scale = 0.5
      },
      normal =
      {
        width = 134,
        height = 194,
        shift = util.by_pixel(1.5, -58.5),
        scale = 0.5
      }
    },
    { -- k
      trunk =
      {
        width = 258,
        height = 224,
        shift = util.by_pixel(10, -13),
        scale = 0.5
      },
      stump =
      {
        width = 86,
        height = 78,
        shift = util.by_pixel(-9, 4),
        scale = 0.5
      },
      shadow =
      {
        width = 256,
        height = 212,
        shift = util.by_pixel(13, -13),
        scale = 0.5
      },
      leaves =
      {
        width = 250,
        height = 206,
        shift = util.by_pixel(10, -12),
        scale = 0.5
      },
      normal =
      {
        width = 186,
        height = 150,
        shift = util.by_pixel(26, -26),
        scale = 0.5
      }
    },
    { -- l
      trunk =
      {
        width = 620,
        height = 116,
        shift = util.by_pixel(32, 7),
        scale = 0.5
      },
      stump =
      {
        width = 396,
        height = 202,
        shift = util.by_pixel(88, 31),
        scale = 0.5
      },
      shadow =
      {
        width = 366,
        height = 94,
        shift = util.by_pixel(-29, 5),
        scale = 0.5
      },
      leaves =
      {
        width = 354,
        height = 114,
        shift = util.by_pixel(-31, 0),
        scale = 0.5
      },
      normal =
      {
        width = 240,
        height = 112,
        shift = util.by_pixel(-52.5, 1),
        scale = 0.5
      }
    }
  },
}

local tree_autoplace = {
    ['tree-01'] = {
      control = "trees",
      order = "a[tree]-b[forest]-a[wet]-c[cold]",
      probability_expression = "tree_01",
      richness_expression = "clamp(random_penalty_at(6, 1), 0, 1)"
    },
}

local tree_data = {}

local function define_trees(data)
  for _, v in ipairs(data) do
    tree_data[#tree_data + 1] = v
  end
end

define_trees{
    {
      -- olive green trees.  seem to like desert edges
      type = 1,
      variation_weights = { 1, 1, 1, 1, 1, 1, 1, 1, 0.3, 0.3, 0.05, 0.05},
      enabled = true,
      autoplace = tree_autoplace['tree-01'], --tree_autoplace(30, 5, 0.75, 0.25),
      colors =
      {
        -- olive green, yellowish
        {r = 156, g = 255, b = 224},
        {r = 118, g = 243, b = 152},
        {r = 116, g = 215, b = 227},
        {r = 221, g = 209, b =  80},
        {r = 131, g = 242, b =  90},
        {r =  83, g = 185, b = 138},
        {r =  71, g = 224, b =  74},
        {r = 230, g = 242, b =  41}
      },
      get_water_reflection = tree_01_reflection
    },
}


local function index_to_letter(index, starting_at)
    return string.char(string.byte(starting_at or "a", 1) - 1 + index)
  end

local tree_flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"}
local tree_corpse_flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"}

for i, tree_data in ipairs(tree_data) do if tree_data.enabled then
  local type_number = string.format("%02d", tree_data.type)
  local type_name = "tree-" .. type_number
  local name = type_name
  local localised_name = {"entity-name.tree"}
  if tree_data.identifier then
    name = name .. "-" .. tree_data.identifier
    localised_name = {"entity-name.tree-"..tree_data.identifier}
  end
  if tree_data.autoplace == nil then error(name .. " missing autoplace") end
  local order = index_to_letter(i) .. "[" .. name .. "]"

  local tree_variations = {}
  for variation_index, variation in ipairs(tree_types[tree_data.type]) do
    local variation_letter = index_to_letter(variation_index)
    local variation_path = type_number .. "/" .. type_name .. "-" .. variation_letter

    local newTree =
    {
      trunk =
      {
        filename = "__base__/graphics/entity/tree/" .. variation_path .. "-trunk.png",
        flags = { "mipmap" },
        width = variation.trunk.width,
        height =  variation.trunk.height,
        frame_count = variation.shadow and 1 or 4,
        shift = variation.trunk.shift,
        scale = variation.trunk.scale
      },
      leaves =
      {
        filename = "__base__/graphics/entity/tree/" .. variation_path .. "-leaves.png",
        flags = { "mipmap" },
        width = variation.leaves.width,
        height = variation.leaves.height,
        frame_count = 3,
        shift = variation.leaves.shift,
        scale = variation.leaves.scale
      },
      leaf_generation =
      {
        type = "create-particle",
        particle_name = "leaf-particle",
        offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
        initial_height = 2,
        initial_vertical_speed = 0.01,
        initial_height_deviation = 0.05,
        speed_from_center = 0.01,
        speed_from_center_deviation = 0.01
      },
      branch_generation =
      {
        type = "create-particle",
        particle_name = "branch-particle",
        offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
        initial_height = 2,
        initial_height_deviation = 2,
        initial_vertical_speed = 0.01,
        -- initial_vertical_speed_deviation = 0.05,
        speed_from_center = 0.03,
        speed_from_center_deviation = 0.01,
        frame_speed = 0.4,
        repeat_count = 15
      }
    }
    if variation.normal then
      newTree.normal =
      {
        filename = "__base__/graphics/entity/tree/" .. variation_path .. "-normal.png",
        width = variation.normal.width,
        height = variation.normal.height,
        frame_count = 3,
        scale = variation.normal.scale,
        shift = variation.normal.shift
      }
    end

    if variation.shadow then
      newTree.shadow =
      {
        filename = "__base__/graphics/entity/tree/" .. variation_path .. "-shadow.png",
        flags = { "mipmap", "shadow" },
        width = variation.shadow.width,
        height = variation.shadow.height,
        frame_count = 4,
        shift = variation.shadow.shift,
        scale = variation.shadow.scale,
        draw_as_shadow = true,
        disable_shadow_distortion_beginning_at_frame = 2
      }
    end

    if tree_data.get_water_reflection then
      newTree.water_reflection = tree_data.get_water_reflection(variation_index - 1)
    end

    tree_variations[#tree_variations + 1] = newTree
  end
  local factoriopedia_alternative = nil
  local factoriopedia_simulation = nil
  if name ~= "tree-01" then
    deconstruction_alternative = "tree-01"
    factoriopedia_alternative = "tree-01"
    ambient_sounds_group = "tree-01"
    ambient_sounds = nil
  else
    ambient_sounds_group = nil
    ambient_sounds = { sounds.tree_ambient, sounds.tree_ambient_night, sounds.tree_insects_night, sounds.tree_ambient_leaves }
    -- factoriopedia_simulation = simulations.factoriopedia_tree
  end

  if name == "tree-06" or name == "tree-06-brown" then
    ambient_sounds_group = nil
  end
  data:extend(
  {
    {
      type = "tree",
      name = name,
      localised_name = localised_name,
      deconstruction_alternative = deconstruction_alternative,
      factoriopedia_alternative = factoriopedia_alternative,
      factoriopedia_simulation = factoriopedia_simulation,
      icon = "__base__/graphics/icons/" .. name .. ".png",
      flags = tree_flags,
      minable =
      {
        mining_particle = "wooden-particle",
        mining_time = 0.55,
        result = "wood",
        count = 4,
        mining_trigger =
        {
          {
            type = "direct",
            action_delivery =
            {
              {
                type = "instant",
                target_effects = leaf_sound_trigger
              }
            }
          }
        }
      },
      corpse = type_name .. "-stump",
      damaged_trigger_effect = leaf_sound_trigger,
      mined_sound = sounds.tree_mined,
      remains_when_mined = type_name .. "-stump",
      emissions_per_second = tree_emissions,
      max_health = 50,
      map_generator_bounding_box = {{-0.8, -0.8}, {0.8, 0.8}},
      collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
      selection_box = {{-0.9, -2.2}, {0.9, 0.6}},
      drawing_box_vertical_extension = tree_data.drawing_box_vertical_extension or 1.8,
      subgroup = "trees",
      order = "a[tree]-a[nauvis]-a[regular]-" .. order,
      impact_category = "tree",
      autoplace = tree_data.autoplace,
      variations = tree_variations,
      variation_weights = tree_data.variation_weights,
      colors = tree_data.colors,
      darkness_of_burnt_tree = 0.5,
      -- water_reflection = tree_data.water_reflection
      ambient_sounds_group = ambient_sounds_group,
      ambient_sounds = ambient_sounds
    }
  })
end end