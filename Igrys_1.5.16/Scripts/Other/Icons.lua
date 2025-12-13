function RichIcons(icon)
    return{
        icon,
        {
            icon = "__Igrys__/Assets/Other/rich-icon.png",
            icon_size = 16,
            scale = 1,
            shift = {8, 8},
            --tint = {r = 0, g = 0, b = 0, a = 0.5}
        },
    }
end

function MadeFromIcons(iconFile, madeFromIconFile)
    icon = {icon = iconFile}
    madeFromIcon = {icon = madeFromIconFile}
    madeFromIcon.scale = 0.4
    madeFromIcon.shift = {12, 12}
    return{
        icon,
        madeFromIcon
    }
end

function MadeFromIconsTech(iconFile, madeFromIconFile)
    icon = {icon = iconFile}
    madeFromIcon = {icon = madeFromIconFile}
    madeFromIcon.scale = 1
    madeFromIcon.shift = {40, 40}
    return{
        icon,
        madeFromIcon
    }
end