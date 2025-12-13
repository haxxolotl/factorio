function EffectsDuringDay(day)
    local igrysSurface = game.surfaces["igrys"]
    for _, machine in ipairs(igrysSurface.find_entities_filtered{type = "assembling-machine"}) do
        machine
        --game.print("Turning " .. tostring(machine.active) .. " machine.active")
    end
end