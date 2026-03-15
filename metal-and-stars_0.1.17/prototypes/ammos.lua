local sounds = require("__base__.prototypes.entity.sounds")
local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local simulations = require("__base__.prototypes.factoriopedia-simulations")

data:extend({
    {
        type = "ammo",
        name = "gauss-rocket",
        icon = "__metal-and-stars-graphics__/graphics/icons/gauss-rocket.png",
        ammo_category = "rocket",
        ammo_type =
        {
          action =
          {
            type = "direct",
            action_delivery =
            {
              type = "projectile",
              projectile = "gauss-rocket",
              starting_speed = 0.1,
              source_effects =
              {
                type = "create-explosion",
                entity_name = "explosion-gunshot"
              }
            }
          }
        },
        subgroup = "ammo",
        order = "d[rocket-launcher]-a[gauss]",
        inventory_move_sound = item_sounds.ammo_large_inventory_move,
        pick_sound = item_sounds.ammo_large_inventory_pickup,
        drop_sound = item_sounds.ammo_large_inventory_move,
        stack_size = 100,
        weight = 40*kg
    },
    {
        type = "recipe",
        name = "gauss-rocket",
        icon = "__metal-and-stars-graphics__/graphics/icons/gauss-rocket.png",
        enabled = false,
        energy_required = 40,
        ingredients =
        {
          {type = "item", name = "iron-plate", amount = 10},
          {type = "item", name = "neodymium-plate", amount = 1}
        },
        results = {{type="item", name="gauss-rocket", amount=10}}
    },
    {
        type = "projectile",
        name = "gauss-rocket",
        flags = {"not-on-map"},
        hidden = true,
        acceleration = 0.01,
        turn_speed = 0.003,
        turning_speed_increases_exponentially_with_projectile_speed = true,
        action =
        {
          type = "direct",
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = {amount = 2200, type = "physical"}
              },
              {
                type = "create-entity",
                entity_name = "explosion-hit",
                offsets = {{0, 1}},
                offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}}
              },
            }
          }
        },
        --light = {intensity = 0.5, size = 4},
        animation = 
        {
          util.sprite_load("__base__/graphics/entity/rocket/rocket", {
            scale = 0.5,
            repeat_count = 8,
            frame_count = 1,
            rotate_shift = true,
            priority = "high"
          })
        },
        shadow = require("__base__.prototypes.entity.rocket-projectile-pictures").shadow,
        -- smoke = require("__base__.prototypes.entity.rocket-projectile-pictures").smoke,
      },
      {
        type = "recipe",
        name = "thorium-rounds-magazine",
        enabled = false,
        energy_required = 10,
        auto_recycle = false,
        ingredients =
        {
          {type = "item", name = "piercing-rounds-magazine", amount = 1},
          {type = "item", name = "thorium", amount = 1}
        },
        results = {{type="item", name="uranium-rounds-magazine", amount=1}}
      },
      {
        type = "recipe",
        name = "thorium-cannon-shell",
        auto_recycle = false,
        enabled = false,
        energy_required = 12,
        ingredients =
        {
          {type = "item", name = "cannon-shell", amount = 1},
          {type = "item", name = "thorium", amount = 1}
        },
        results = {{type="item", name="uranium-cannon-shell", amount=1}}
      },
      {
        type = "recipe",
        name = "gauss-rocket-casting",
        icon = "__metal-and-stars-graphics__/graphics/icons/gauss-rocket.png",
        category = "metallurgy",
        subgroup = "ammo",
        order = "d[rocket-launcher]-a[gauss]",
        auto_recycle = false,
        energy_required = 6.4,
        ingredients = {
          {type = "fluid", name = "molten-iron", amount = 100},
          {type = "item", name = "neodymium-plate", amount = 1},
        },
        results = {{type="item", name="gauss-rocket", amount=10}},
        allow_productivity = true,
        enabled = false
      },
})