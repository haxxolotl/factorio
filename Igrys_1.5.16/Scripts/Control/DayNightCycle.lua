require("Scripts.Control.CopperPlateMachine")
--require("Scripts.Control.EffectsDuringDay")

local darknessThreshold = 0.4

script.on_init(function()
    storage.day = true
end)

function Turn(day)
    storage.day = day

    --game.print("Turning " .. (day and "on" or "off") .. " day/night cycle")
    
    TurnCopperPlateMachines(day)
    --EffectsDuringDay(day)
end

script.on_nth_tick(60 * 5, function()
    local igrysSurface = game.surfaces["igrys"]
    if not igrysSurface then
        return
    end
    
    if storage.day then
        if igrysSurface.darkness > darknessThreshold then
            Turn(false)
        end
    else
        if igrysSurface.darkness < darknessThreshold then
            Turn(true)
        end
    end
end)