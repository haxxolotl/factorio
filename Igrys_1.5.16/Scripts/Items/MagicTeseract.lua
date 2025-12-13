require("Scripts.Other.Icons")

data:extend({
    {
        type="item",
        name="igrys-magic-teseract",
        icon = "__Igrys__/Assets/Items/magic-teseract.png",
        
        stack_size = 10,
        subgroup = "igrys-magic",
        weight = 1000 * 100,
        order = "c[igrys-magic-teseract]"
    }, {
        type="item",
        name="igrys-rich-magic-teseract",
        icons = RichIcons({
            icon = "__Igrys__/Assets/Items/magic-teseract.png",
            
        }),
        stack_size = 10,
        subgroup = "igrys-magic",
        weight = 1000 * 100,
        order = "e[igrys-magic-teseract]"
    }
})

PlanetsLib.set_default_import_location("igrys-magic-teseract", "igrys")
PlanetsLib.set_default_import_location("igrys-rich-magic-teseract", "igrys")
