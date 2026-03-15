local simulations = {}

local make_asteroid_simulation = function(name, wait)
  return
  [[
    require("__core__/lualib/story")
    game.simulation.camera_position = {0, 0}

    for x = -8, 8, 1 do
      for y = -3, 3 do
        game.surfaces[1].set_tiles{{position = {x, y}, name = "empty-space"}}
      end
    end

    for x = -1, 0, 1 do
      for y = -1, 0 do
        game.surfaces[1].set_chunk_generated_status({x, y}, defines.chunk_generated_status.entities)
      end
    end

    local story_table = {
      {
        {
          name = "start",
          action = function() game.surfaces[1].create_entity{name="]]..name..[[", position = {0, 0}, velocity = {0, 0.011}} end
        },
        {
          condition = story_elapsed_check(]]..wait..[[),
          action = function() story_jump_to(storage.story, "start") end
        }
      }
    }
    tip_story_init(story_table)
  ]]
end

simulations.factoriopedia_small_mirandite_asteroid = { hide_factoriopedia_gradient = true, init = make_asteroid_simulation("small-mirandite-asteroid", "7") }
simulations.factoriopedia_medium_mirandite_asteroid = { hide_factoriopedia_gradient = true, init = make_asteroid_simulation("medium-mirandite-asteroid", "9") }
simulations.factoriopedia_big_mirandite_asteroid = { hide_factoriopedia_gradient = true, init = make_asteroid_simulation("big-mirandite-asteroid", "11") }
simulations.factoriopedia_huge_mirandite_asteroid = { hide_factoriopedia_gradient = true, init = make_asteroid_simulation("huge-mirandite-asteroid", "18") }

return simulations