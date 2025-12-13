function OnEntityBuild (event)
    event.entity.active = not storage.day
end

script.on_event(defines.events.on_built_entity, OnEntityBuild,
        {{filter = "name", name = "igrys-copper-plate-machine"}})
script.on_event(defines.events.on_robot_built_entity, OnEntityBuild,
        {{filter = "name", name = "igrys-copper-plate-machine"}})

function TurnCopperPlateMachines(day)
    local igrysSurface = game.surfaces["igrys"]
    for _, machine in ipairs(igrysSurface.find_entities_filtered{name = "igrys-copper-plate-machine"}) do
        machine.active = not day
        --game.print("Turning " .. tostring(machine.active) .. " machine.active")
    end
end