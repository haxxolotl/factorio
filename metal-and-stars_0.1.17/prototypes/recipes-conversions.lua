data:extend({
    --///////////////// basic ores
    {
      type = "recipe",
      name = "iron-ore-from-stone",
      category = "quantum",
      subgroup = "quantum-conversion",
      order = "c[conversion]-b[iron-ore]",
      energy_required = 6.4,
      ingredients = {
        {type = "item", name = "stone", amount = 4},
        {type = "item", name = "quantite-a", amount = 1},
      },
      results = {{type="item", name="iron-ore", amount=1}},
      allow_productivity = true,
      auto_recycle = false,
      enabled = false
    },
    {
        type = "recipe",
        name = "copper-ore-from-iron-ore",
        category = "quantum",
        subgroup = "quantum-conversion",
        order = "c[conversion]-b[copper-ore]",
        energy_required = 6.4,
        ingredients = {
          {type = "item", name = "iron-ore", amount = 4},
          {type = "item", name = "quantite-b", amount = 1},
        },
        results = {{type="item", name="copper-ore", amount=1}},
        allow_productivity = true,
        auto_recycle = false,
        enabled = false
    },
    {
        type = "recipe",
        name = "stone-from-copper-ore",
        category = "quantum",
        subgroup = "quantum-conversion",
        order = "c[conversion]-b[stone]",
        energy_required = 6.4,
        ingredients = {
          {type = "item", name = "copper-ore", amount = 4},
          {type = "item", name = "quantite-c", amount = 1},
        },
        results = {{type="item", name="stone", amount=1}},
        allow_productivity = true,
        auto_recycle = false,
        enabled = false
    },
    
})