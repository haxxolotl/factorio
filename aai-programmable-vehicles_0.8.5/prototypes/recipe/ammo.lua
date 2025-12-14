data:extend{
    {
        type = "recipe",
        name = "cannon-shell-precision",
        enabled = data.raw["technology"]["tank"] == nil,
        energy_required = 8,
        ingredients =
        {
            {type = "item", name = "steel-plate", amount = 4},
            {type = "item", name = "plastic-bar", amount = 2},
            {type = "item", name = "explosives", amount = 1},
        },
        results = {
            {type = "item", name = "cannon-shell-precision", amount = 2},
        }
    },
    {
        type = "recipe",
        name = "explosive-cannon-shell-precision",
        enabled = data.raw["technology"]["tank"] == nil,
        energy_required = 8,
        ingredients =
        {
            {type = "item", name = "steel-plate", amount = 3},
            {type = "item", name = "plastic-bar", amount = 2},
            {type = "item", name = "explosives", amount = 4},
        },
        results = {
            {type = "item", name = "explosive-cannon-shell-precision", amount = 1},
        }
    }
}
