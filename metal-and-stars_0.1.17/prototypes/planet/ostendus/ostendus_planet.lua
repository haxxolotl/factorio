local ostendus_map_gen = require("__metal-and-stars__.prototypes.planet.ostendus.ostendus_map_gen")
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local meld = require("meld")

local machina = {
    type = "planet",
    name = "ostendus",
    icon = "__metal-and-stars-graphics__/graphics/icons/ostendus-icon.png",
    starmap_icon = "__metal-and-stars-graphics__/graphics/icons/ostendus-starmap.png",
    starmap_icon_size = 512,
    map_gen_settings = meld.overwrite(ostendus_map_gen()),
    gravity_pull = 10,
    distance = 20,
    orientation = 0.400,
    magnitude = 1.0,
    label_orientation = 0.15,
    order = "e[machina]",
    subgroup = "planets",
    pollutant_type = nil,
    solar_power_in_space = 60,
    surface_properties =
    {
        ["day-night-cycle"] = 20 * minute,
        ["magnetic-field"] = meld.delete(),
        pressure = 3000,
        ["solar-power"] = 4000,
        gravity = 30
    },
    surface_render_parameters =
    {
        shadow_opacity = 0.0,
    },
    ticks_between_player_effects = 2
}

machina = meld(table.deepcopy(data.raw["planet"]["vulcanus"]), machina)

data:extend({
    machina,
})
