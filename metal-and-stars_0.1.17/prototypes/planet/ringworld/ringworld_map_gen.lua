shipyard = function()
    return
    {
      property_expression_names =
      {
        ["entity:tungsten-ore:probability"] = "vulcanus_tungsten_ore_probability",
        ["entity:tungsten-ore:richness"] = "vulcanus_tungsten_ore_richness",
        ["entity:coal:probability"] = "vulcanus_coal_probability",
        ["entity:coal:richness"] = "vulcanus_coal_richness",
        ["entity:calcite:probability"] = "vulcanus_calcite_probability",
        ["entity:calcite:richness"] = "vulcanus_calcite_richness",
        ["entity:sulfuric-acid-geyser:probability"] = "vulcanus_sulfuric_acid_geyser_probability",
        ["entity:sulfuric-acid-geyser:richness"] = "vulcanus_sulfuric_acid_geyser_richness",
      },
      autoplace_controls =
      {
        ["ringworld_heavy_water"] = {},
        ["ringworld_gold_sand"] = {},
        ["ringworld_detritus"] = {},
        ["ringworld_military_scrap"] = {},
        ["ringworld_snapper_enemy_base"] = {},
        ["ringworld_robot_enemy_base"] = {},
      },
      autoplace_settings =
      {
        ["tile"] =
        {
          settings =
          {
            ["empty-space-shipyard"] = {},
            --safe center
            ["blue-grass-2-dark"] = {},
            ["blue-grass-2-light"] = {},
            ["blue-grass-2"] = {},
            --vines left
            ["undergrowth-thin"] = {},
            ["undergrowth-thin-dark"] = {},
            ["undergrowth-thick"] = {},
            ["undergrowth-thick-dark"] = {},
            --desert right
            ["sand-1-ringworld"] = {},   
            ["sand-2-ringworld"] = {},
       
          }
        },
        ["decorative"] =
        {
          settings =
          {
            -- nauvis decoratives
            ["ringworld-sand-dune-decal"] = {},
          }
        },
        ["entity"] =
        {
          settings =
          {
            ["heavy-water-vent"] = {},
            ["gold-sands"] = {},
            ["military-scrap"] = {},
            ["ringworld-detritus"] = {},
            ["armoured-biter-spawner"] = {},
            ["robot-spawner"] = {},
          }
        }
      }
    }
  end

return shipyard
