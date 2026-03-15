local volantus_map_gen = require("__metal-and-stars__.prototypes.planet.volantus.volantus_map_gen")
local effects = require("__core__/lualib/surface-render-parameter-effects")
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local meld = require("meld")

local machina = {
    type = "planet",
    name = "volantus",
    icon = "__metal-and-stars-graphics__/graphics/icons/caelum-icon.png",
    starmap_icon = "__metal-and-stars-graphics__/graphics/icons/caelum-starmap.png",
    starmap_icon_size = 512,
    map_gen_settings = meld.overwrite(volantus_map_gen()),
    gravity_pull = 10,
    distance = 20,
    orientation = 0.400,
    magnitude = 1.0,
    label_orientation = 0.15,
    order = "e[machina]",
    subgroup = "planets",
    pollutant_type = nil,
    solar_power_in_space = 200,
    surface_properties =
    {
        ["magnetic-field"] = 110,
        pressure = 3000,
        ["solar-power"] = 100,
        gravity = 25
    },
    surface_render_parameters =
    {
        clouds = effects.default_clouds_effect_properties(),
        -- shadow_opacity = 0.0,
    },
    ticks_between_player_effects = 2
}

machina = meld(table.deepcopy(data.raw["planet"]["nauvis"]), machina)

data:extend({
    machina,
})
