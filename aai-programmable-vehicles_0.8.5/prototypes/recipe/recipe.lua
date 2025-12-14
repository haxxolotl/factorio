-- hand craft engine
if data.raw["recipe"]["engine-unit"] then
    data.raw["recipe"]["engine-unit"].category = "crafting"
    data.raw["recipe"]["engine-unit"].energy_required = 4
end

data:extend{
    {
        type = "recipe",
        name = "position-beacon",
        enabled = false,
        energy_required = 10,
        ingredients =
        {
            {type="item", name="electronic-circuit", amount=1},
            {type="item", name="stone-brick", amount=4}
        },
        results = {
            {type = "item", name="position-beacon", amount = 1},
        }
    },
    {
        type = "recipe",
        name = "vehicle-deployer",
        enabled = false,
        energy_required = 10,
        ingredients =
        {
            {type="item", name="electronic-circuit", amount=10},
            {type="item", name="iron-plate", amount=10},
            {type="item", name="stone-brick", amount=10},
        },
        results = {
            {type="item", name="vehicle-deployer", amount=1},
        }
    },
    {
        type = "recipe",
        name = "vehicle-depot",
        enabled = false,
        energy_required = 10,
        ingredients =
        {
            {type="item", name="iron-chest", amount=8},
            {type="item", name="electronic-circuit", amount=10},
            {type="item", name="iron-plate", amount=20},
            {type="item", name="stone-brick", amount=20},
        },
        results = {
            {type="item", name="vehicle-depot", amount=1},
        }
    },
}
if data.raw["technology"]["programmable-structures"] then
    data:extend{{
        type = "recipe",
        name = "unit-control",
        category = "crafting",
        enabled = data.raw["technology"]["circuit-network"] == nil,
        energy_required = 2,
        ingredients =
        {
            {type="item", name="electronic-circuit", amount=10},
            {type="item", name="stone-brick", amount=10}
        },
        results=
        {
            {type="item", name="unit-control", amount=1},
        },
    }}
    data:extend{{
        type = "recipe",
        name = "unitdata-scan",
        category = "crafting",
        enabled = data.raw["technology"]["circuit-network"] == nil,
        energy_required = 2,
        ingredients =
        {
            {type="item", name="electronic-circuit", amount=10},
            {type="item", name="stone-brick", amount=10}
        },
        results=
        {
            {type="item", name="unitdata-scan", amount=1},
        },
    }}
    data:extend{{
        type = "recipe",
        name = "unitdata-control",
        category = "crafting",
        enabled = data.raw["technology"]["circuit-network"] == nil,
        energy_required = 2,
        ingredients =
        {
            {type="item", name="electronic-circuit", amount=10},
            {type="item", name="stone-brick", amount=10}
        },
        results=
        {
            {type="item", name="unitdata-control", amount=1},
        },
    }}
    data:extend{{
        type = "recipe",
        name = "path-scan",
        category = "crafting",
        enabled = data.raw["technology"]["circuit-network"] == nil,
        energy_required = 2,
        ingredients =
        {
            {type="item", name="electronic-circuit", amount=10},
            {type="item", name="stone-brick", amount=10}
        },
        results=
        {
            {type="item", name="path-scan", amount=1},
        },
    }}
    data:extend{{
        type = "recipe",
        name = "path-control",
        category = "crafting",
        enabled = data.raw["technology"]["circuit-network"] == nil,
        energy_required = 2,
        ingredients =
        {
            {type="item", name="electronic-circuit", amount=10},
            {type="item", name="stone-brick", amount=10}
        },
        results=
        {
            {type="item", name="path-control", amount=1},
        },
    }}
end
