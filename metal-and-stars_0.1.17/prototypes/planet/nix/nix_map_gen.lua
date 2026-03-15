shipyard = function()
    return
    {
      property_expression_names =
      {
        elevation = "vulcanus_elevation",
        temperature = "vulcanus_temperature",
        moisture = "vulcanus_moisture",
        aux = "vulcanus_aux",
        -- cliffiness = "cliffiness_basic",
        -- cliff_elevation = "cliff_elevation_from_elevation",

      },
      autoplace_controls =
      {
        ["nix_copper_iron_ore"] = {},
        ["nix_coal_stone_ore"] = {},
        ["nix_crude_slush"] = {},
        ["nix_dark_matter"] = {},
        ["nix_enemy_base"] = {},
        --["rocks"] = {}, -- can't add the rocks control otherwise nauvis rocks spawn
      },
      autoplace_settings =
      {
        ["tile"] =
        {
          settings =
          {
            ["snow-flat"] = {},
            ["snow-crests"] = {},
            ["snow-lumpy"] = {},
            ["snow-patchy-grass"] = {},
            ["ice-rough-nix"] = {},
            ["ice-smooth-nix"] = {},
          }
        },
        ["decorative"] =
        {
          settings =
          {
            ["carbon-iceberg-medium"] = {},
            ["carbon-iceberg-small"] = {},
            ["carbon-iceberg-tiny"] = {},
            ["aqulio-ice-decal-blue"] = {},
            ["aqulio-snowy-decal"] = {},
            ["snow-drift-decal"] = {}
          }
        },
        ["entity"] =
        {
          settings =
          {
            ["jellyfish-spawner"] = {},
            ["dark-matter-vent"] = {},
            ["crude-slush"] = {},
            ["iron-copper-ore"] = {},
            ["coal-stone-ore"] = {},
            ["carbon-iceberg-huge"] = {},
            ["carbon-iceberg-big"] = {}

          }
        }
      }
    }
  end

return shipyard
