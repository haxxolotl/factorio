local animal_eggs = {
    cow = "cow-egg",
    chicken = "egg",
    sheep = "sheep-egg",
    psyduck = "duck_egg",
}

-- Set of animal names that should spawn on the "animals" force
local hatchable_animals = {
    cow = true,
    chicken = true,
    sheep = true,
    psyduck = true,
}

-- Create or get the "animals" force and configure its relationship with player
local function ensure_animals_force()
    if not game.forces["animals"] then
        game.create_force("animals")
    end
    local animals_force = game.forces["animals"]
    local player_force = game.forces["player"]
    
    -- Check the setting for hostile animals
    local hostile = settings.global["fruit-hostile-animals"].value
    
    if hostile then
        -- Make animals and player hostile to each other
        animals_force.set_friend(player_force, false)
        player_force.set_friend(animals_force, false)
        animals_force.set_cease_fire(player_force, false)
        player_force.set_cease_fire(animals_force, false)
    else
        -- Make animals and player mutually friendly
        animals_force.set_friend(player_force, true)
        player_force.set_friend(animals_force, true)
        animals_force.set_cease_fire(player_force, true)
        player_force.set_cease_fire(animals_force, true)
    end
    return animals_force
end

-- Initialize the animals force on game start
MyEvent.on_init(ensure_animals_force)
MyEvent.on_configuration_changed(ensure_animals_force)

-- Update force relationships when the setting changes
MyEvent.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting == "fruit-hostile-animals" then
        ensure_animals_force()
    end
end)

-- Handle animals spawning from hatched eggs
MyEvent.on_event(defines.events.on_trigger_created_entity, function(event)
    local entity = event.entity
    if entity and entity.valid and hatchable_animals[entity.name] then
        local animals_force = ensure_animals_force()
        entity.force = animals_force
    end
end)

local function egg_laying ()

    for k, surface in pairs(game.surfaces) do

        if surface.name and (string.find(surface.name, "^platform-") or string.find(surface.name, "^minime")) then

            --    skip
        else
            -- Find units
            --local units = surface.find_units({ area = { { -2000, -2000 }, { 2000, 2000 } }, force = "neutral", condition = "all" })
            local units = surface.find_entities_filtered({ type = "unit", force = { "neutral", "player", "animals" } })

            for k, unit in pairs(units) do

                if unit.name and animal_eggs[unit.name] then

                    -- 随机生成一个 1 或 2 的数字
                    local choice = math.random(1, 3)
                    if choice == 1 then
                        surface.spill_item_stack { position = unit.position, stack = { name = animal_eggs[unit.name], count = 1 } }
                    else
                        surface.spill_item_stack { position = unit.position, stack = { name = "poop", count = 1 } }
                    end

                end
            end
        end
    end
end

script.on_nth_tick(6003, egg_laying)
