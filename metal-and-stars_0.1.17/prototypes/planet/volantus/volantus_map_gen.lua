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
            ["clouds-lumpy"] = {},
            ["volantus-center-ship"] = {},
          }
        },
        ["decorative"] =
        {
          settings =
          {
            -- nauvis decoratives
            -- ["v-brown-carpet-grass"] = {},
            -- ["v-green-hairy-grass"] = {},
            -- ["v-brown-hairy-grass"] = {},
            -- ["v-red-pita"] = {},
            -- -- end of nauvis
            -- ["vulcanus-crack-decal-large"] = {},
            -- ["vulcanus-dune-decal"] = {},
            -- ["vulcanus-sand-decal"] = {},
            -- ["calcite-stain"] = {},
            -- ["calcite-stain-small"] = {},
            -- ["sulfur-stain"] = {},
            -- ["sulfur-stain-small"] = {},
            -- ["sulfuric-acid-puddle"] = {},
            -- ["sulfuric-acid-puddle-small"] = {},
            -- ["crater-small"] = {},
            -- ["crater-large"] = {},
            -- ["pumice-relief-decal"] = {},
            -- ["small-sulfur-rock"] = {},
            -- ["tiny-sulfur-rock"] = {},
            -- ["sulfur-rock-cluster"] = {},
            ["waves-decal"] = {},
          }
        },
        ["entity"] =
        {
          settings =
          {
            ["volantus-assembler"] = {},
          }
        }
      }
    }
  end

return shipyard
