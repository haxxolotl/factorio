
data:extend({
    -- math
    {
        type = "noise-expression",
        name = "ringworld_spot_size",
        expression = 16
    },
    {
        type = "noise-function",
        name = "ringworld_spot_noise",
        parameters = {"seed", "count", "skip_offset", "region_size", "density", "radius", "favorability", "max_y_bound"},
        expression = "spot_noise{x = x,\z
                                y = y,\z
                                seed0 = map_seed,\z
                                seed1 = seed,\z
                                candidate_spot_count = count,\z
                                suggested_minimum_candidate_point_spacing = 128,\z
                                skip_span = 3,\z
                                skip_offset = skip_offset,\z
                                region_size = region_size,\z
                                density_expression = density * (1 - min(1, max(0, ((y * y)^0.5 - max_y_bound) / max_y_bound))),\z
                                spot_quantity_expression = radius * radius,\z
                                spot_radius_expression = radius,\z
                                hard_region_target_quantity = 0,\z
                                spot_favorability_expression = favorability * (1 - min(1, max(0, ((y * y)^0.5 - max_y_bound) / max_y_bound))),\z
                                basement_value = -1,\z
                                maximum_spot_basement_radius = radius * 2}"
    },
    -- //left resources
    {
        type = "noise-expression",
        name = "ringworld_heavy_water_spots",
        expression = "ringworld_left_mask * ringworld_spot_noise{\z
            seed = 16875,\z
            count = 50,\z
            skip_offset = 0,\z
            region_size = 600 + 400 / control:ringworld_heavy_water:frequency,\z
            density = 1,\z
            radius = ringworld_spot_size * sqrt(control:ringworld_heavy_water:size),\z
            favorability = 1,\z
            max_y_bound = 34\z
        }"
    },
    {
        type = "noise-expression",
        name = "ringworld_heavy_water_probability",
        expression = "(control:ringworld_heavy_water:size > 0)\z
                        * (max(aquilo_starting_crude_oil * 0.02,\z
                                min(aquilo_starting_mask, ringworld_heavy_water_spots) * 0.015))"
    },
    {
        type = "noise-expression",
        name = "ringworld_heavy_water_richness",
        expression = "random_penalty(x, y, 9232 + (sqrt(x*x + y*y) / 10), 99, 1000) * control:ringworld_heavy_water:richness * 10"
    },
    {
        type = "noise-expression",
        name = "ringworld_detritus",
        expression = "ringworld_left_mask * ringworld_spot_noise{\z
            seed = 54321,\z
            count = 50,\z
            skip_offset = 0,\z
            region_size = 600 + 400 / control:ringworld_detritus:frequency,\z
            density = 1,\z
            radius = ringworld_spot_size * sqrt(control:ringworld_detritus:size),\z
            favorability = 1,\z
            max_y_bound = 34\z
        }"
    },
    {
        type = "noise-expression",
        name = "ringworld_detritus_richness",
        expression = "random_penalty(x, y, 9232 + (sqrt(x*x + y*y) / 10), 99, 1000) * control:ringworld_detritus:richness"
    },
    -- //right resources
    {
        type = "noise-expression",
        name = "ringworld_gold",
        expression = "ringworld_right_mask * ringworld_spot_noise{\z
            seed = 12345,\z
            count = 50,\z
            skip_offset = 0,\z
            region_size = 600 + 400 / control:ringworld_gold_sand:frequency,\z
            density = 1,\z
            radius = ringworld_spot_size * sqrt(control:ringworld_gold_sand:size),\z
            favorability = 1,\z
            max_y_bound = 34\z
        }"
    },
    {
        type = "noise-expression",
        name = "ringworld_gold_richness",
        expression = "random_penalty(x, y, 9232 + (sqrt(x*x + y*y) / 10), 99, 1000) * control:ringworld_gold_sand:richness"
    },
    {
        type = "noise-expression",
        name = "ringworld_weaponry",
        expression = "ringworld_right_mask * ringworld_spot_noise{\z
            seed = 56781,\z
            count = 50,\z
            skip_offset = 0,\z
            region_size = 600 + 400 / control:ringworld_military_scrap:frequency,\z
            density = 1,\z
            radius = ringworld_spot_size * sqrt(control:ringworld_military_scrap:size),\z
            favorability = 1,\z
            max_y_bound = 34\z
        }"
    },
    {
        type = "noise-expression",
        name = "ringworld_weaponry_richness",
        expression = "random_penalty(x, y, 9232 + (sqrt(x*x + y*y) / 10), 99, 1000) * control:ringworld_military_scrap:richness"
    },

    {
        type = "noise-expression",
        name = "ringworld_robot_enemy_base_spots",
        expression = "ringworld_right_mask * ringworld_spot_noise{\z
            seed = 83749,\z
            count = 50,\z
            skip_offset = 0,\z
            region_size = 600 + 400 / control:ringworld_robot_enemy_base:frequency,\z
            density = 1,\z
            radius = ringworld_spot_size * sqrt(control:ringworld_robot_enemy_base:size),\z
            favorability = 1,\z
            max_y_bound = 34\z
        }"
    },
    {
        type = "noise-expression",
        name = "ringworld_robot_enemy_base_probability",
        expression = "(control:ringworld_robot_enemy_base:size > 0) * \z
                                min(aquilo_starting_mask, ringworld_robot_enemy_base_spots) * 0.015"
    },

    
})