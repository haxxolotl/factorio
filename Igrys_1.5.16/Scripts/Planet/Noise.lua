data:extend({
    {
        type = "noise-expression",
        name = "igrys_neutral_raw",
        expression = [[multioctave_noise{
                x = x,
                y = y,
                persistence = 0.5,
                seed0 = map_seed,
                seed1 = 5116,
                octaves = 6,
                input_scale = 1/32,
                output_scale = 0.75
            }]]
    },{
        type = "noise-expression",
        name = "igrys_neutral_start",
        expression = "clamp(0.5 - distance * 0.002, 0, 0.5)"
    },
    {
        type = "noise-expression",
        name = "igrys_neutral",
        expression = "(igrys_neutral_start + igrys_neutral_raw + 0.75) * (noise_igrys_light_oil < 0)"
    },
    {
        type = "noise-expression",
        name = "noise_igrys_dirt",
        expression = "igrys_neutral"
    }, {
        type = "noise-expression",
        name = "noise_igrys_stone",
        expression = "igrys_neutral - 1.5" 
    },{
        type = "noise-expression",
        name = "noise_igrys_light_oil",
        expression = "noise_igrys_light_oil_raw - 0.5 - igrys_neutral_start"
    }, {
        type = "noise-expression",
        name = "noise_igrys_light_oil_raw",
        expression = [[multioctave_noise{
                x = x/200,
                y = y,
                persistence = 0.5,
                seed0 = map_seed,
                seed1 = 5115,
                octaves = 6,
                input_scale = 1/16,
                output_scale = 1
            }]]
    }
})