data:extend({
--Categories for reverse recipes, used to define tiers
	{
		type = "recipe-category",
		name = "recycle-products"
	},
	{
		type = "recipe-category",
		name = "recycle-intermediates"
	},
	{
		type = "recipe-category",
		name = "recycle-productivity"
	},
--Hidden group and subgroup which contains the reverse recipes
	{
		type = "item-group",
		name = "recycling",
		icon = "__reverse-factory__/graphics/technology/reverse-factory.png",
		icon_size = 128,
		order = "z",
	},
	{
		type = "item-subgroup",
		name = "recycling",
		group = "recycling",
		order = "z",
	}
})

if not mods["kry-solid-fluids"] then 
--New category and new set of subgroups for solid fluid items
	data:extend({
		{
			type = "recipe-category",
			name = "solids-into-fluids",
			group = "solids-into-fluids",
		},
		{
			type = "item-group",
			name = "solids-into-fluids",
			icon = "__reverse-factory__/graphics/item-group/melting.png",
			icon_size = 128,
			order = "z-a",
		},
		{
			type = "item-subgroup",
			name = "solids-into-fluids",
			group = "solids-into-fluids",
			order = "z-a",
		},
		{
			type = "item-subgroup",
			name = "fluid-items",
			group = "intermediate-products",
			order = "z-a",
		}
	})
end