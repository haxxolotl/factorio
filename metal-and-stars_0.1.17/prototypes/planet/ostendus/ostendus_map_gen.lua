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
        ["ostendus-mirandite"] = {},
        ["trees"] = {},
        --["rocks"] = {}, -- can't add the rocks control otherwise nauvis rocks spawn
      },
      autoplace_settings =
      {
        ["tile"] =
        {
          settings =
          {
            ["leaf-cover"] = {},            --["volcanic-folds"] = {},
            ["leaf-cover-dark"] = {},       --["volcanic-folds-flat"] = {},
            ["teal-grass-3"] = {}, --["volcanic-pumice-stones"] = {},
            ["leaf-cover-light"] = {},        --["volcanic-jagged-ground"] = {},
            ["teal-grass-3-dark"] = {}, --["volcanic-smooth-stone"] = {},
            ["teal-grass-3-light"] = {}, --["volcanic-ash-cracks"] = {},
            --nauvis tiles
            ["blue-grass-1-dark"] = {},
            ["blue-grass-1-light"] = {},
            ["blue-grass-1"] = {},
            --end of nauvis tiles
            ["blue-grass-2-dark"] = {},
            ["blue-grass-2-light"] = {},
            ["blue-grass-2"] = {},
            --["volcanic-cracks"] = {},
            ["crater-water"] = {},
            ["crater-water-deep"] = {},
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
