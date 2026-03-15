data:extend({
    -- math
    {
        type = "noise-expression",
        name = "landing_spot_radius",
        expression = 128
    },
    {
        type = "noise-expression",
        name = "ancient_machine_distance",
        expression = 80
    },
    {
		type = "noise-expression",
		name = "volantus_center_ship",
		expression = "(landing_spot_radius - distance) / 50",
	},
    {
		type = "noise-expression",
		name = "volantus_ancient_machine",
		expression = "(abs(x) == 40)*(abs(y) == 40)",
	},

})