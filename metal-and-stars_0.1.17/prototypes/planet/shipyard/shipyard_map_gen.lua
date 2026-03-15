shipyard = function()
    return
    {
        property_expression_names =
        {
            elevation = "gleba_elevation",
            aux = "gleba_aux",
            moisture = "gleba_moisture",
            temperature = "gleba_temperature",
        },
        autoplace_controls =
        {
            
        },
        autoplace_settings =
        {
            ["tile"] =
            {
                settings =
                {
                    ["space-platform-foundation-shipyard"] = {},
                    ["empty-space-shipyard"] = {},
                    ["gray-goo-tile"] = {}
                }

            },
            -- ["decorative"] =
            -- {
            --     settings =
            --     {

            --     }
            -- },
            ["entity"] =
            {
                settings =
                {
                    ["microgravity-assembler"] = {},
                    ["neumann-conduit"] = {}
                }
            }
        }
    }
end

return shipyard
