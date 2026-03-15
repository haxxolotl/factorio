shipyard = function()
    return
    {
      property_expression_names =
      {
        elevation = "vulcanus_elevation",
        temperature = "vulcanus_temperature",
        moisture = "vulcanus_moisture",
        aux = "vulcanus_aux",
        cliffiness = "cliffiness_basic",
        cliff_elevation = "cliff_elevation_from_elevation",

      },
      cliff_settings =
      {
        name = "cliff-vulcanus",
        cliff_elevation_interval = 120,
        cliff_elevation_0 = 70
      },
      autoplace_controls =
      {
        ["trees"] = {},
        --["rocks"] = {}, -- can't add the rocks control otherwise nauvis rocks spawn
      },
      autoplace_settings =
      {
        ["tile"] =
        {
          settings =
          {
            ["sand-1"] = {},
            ["sand-2"] = {},
            ["sand-3"] = {},
            -- ["brash-ice"] = {},
            -- ["ammoniacal-ocean"] = {},
            -- ["ammoniacal-ocean-2"] = {}

          }
        },
        ["decorative"] =
        {
          settings =
          {
            -- nauvis decoratives
            ["v-brown-carpet-grass"] = {},
            ["v-green-hairy-grass"] = {},
            ["v-brown-hairy-grass"] = {},
            ["v-red-pita"] = {},
            -- end of nauvis
            ["vulcanus-crack-decal-large"] = {},
            ["vulcanus-dune-decal"] = {},
            ["vulcanus-sand-decal"] = {},
            ["calcite-stain"] = {},
            ["calcite-stain-small"] = {},
            ["sulfur-stain"] = {},
            ["sulfur-stain-small"] = {},
            ["sulfuric-acid-puddle"] = {},
            ["sulfuric-acid-puddle-small"] = {},
            ["crater-small"] = {},
            ["crater-large"] = {},
            ["pumice-relief-decal"] = {},
            ["small-sulfur-rock"] = {},
            ["tiny-sulfur-rock"] = {},
            ["sulfur-rock-cluster"] = {},
            ["waves-decal"] = {},
          }
        },
        ["entity"] =
        {
          settings =
          {
            -- ["coal"] = {},
            -- ["calcite"] = {},
            -- ["sulfuric-acid-geyser"] = {},
            -- ["tungsten-ore"] = {},
            ["huge-volcanic-rock"] = {},
            ["big-volcanic-rock"] = {},
            ["crater-cliff"] = {},
            ["vulcanus-chimney"] = {},
            ["vulcanus-chimney-faded"] = {},
            ["vulcanus-chimney-cold"] = {},
            ["vulcanus-chimney-short"] = {},
            ["vulcanus-chimney-truncated"] = {},
          }
        }
      }
    }
  end

return shipyard
