if mods["enemyracemanager"] then
   data.raw["unit-spawner"]["enemy--armoured-biter-spawner--1"].autoplace = {probability_expression ="ringworld_snapper_enemy_base_probability", force = "ringworld_snappers"}

   local ringworld_map_settings = data.raw.planet.ringworld.map_gen_settings
   ringworld_map_settings.autoplace_settings.entity.settings["armoured-biter-spawner"] = nil
   ringworld_map_settings.autoplace_settings.entity.settings["enemy--armoured-biter-spawner--1"] = {}
end