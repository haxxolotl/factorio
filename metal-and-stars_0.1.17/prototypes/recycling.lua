data:extend({
    {
        type = "recipe",
        name = "aspheric-lens-recycling",
        subgroup = "other",
        category = "recycling",
        hidden = true,
        enabled = true,
        unlock_results = false,
        icons = {
            {
              icon = "__quality__/graphics/icons/recycling.png"
            },
            {
              icon = "__metal-and-stars-graphics__/graphics/icons/glass-lens.png",
              scale = 0.4
            },
            {
              icon = "__quality__/graphics/icons/recycling-top.png"
            }
          },
        order = "c[lithium]-b[lithium-plate]",
        energy_required = 6.4,
        ingredients = {
          {type = "item", name = "aspheric-lens", amount = 1, ignored_by_stats = 1},
        },
        results = {
          {type = "item", name = "glass-billet", amount = 1, ignored_by_stats = 1},
        },
    },
    {
      type = "recipe",
      name = "depleted-fuel-cell-recycling",
      subgroup = "other",
      category = "recycling",
      hidden = true,
      enabled = true,
      unlock_results = false,
      
      icons = {
          {
            icon = "__quality__/graphics/icons/recycling.png"
          },
          {
            icon = "__metal-and-stars-graphics__/graphics/icons/empty-fuel-cell.png",
            scale = 0.4
          },
          {
            icon = "__quality__/graphics/icons/recycling-top.png"
          }
        },
      order = "c[lithium]-b[lithium-plate]",
      energy_required = 6.4,
      ingredients = {
        {type = "item", name = "depleted-fuel-cell", amount = 1, ignored_by_stats = 1},
      },
      results = {
        {type = "item", name = "stone", amount = 1, ignored_by_stats = 1},
        {type = "item", name = "iron-plate", amount = 1, ignored_by_stats = 1},
      },
    },
})
