for index, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes
  
    recipes["gold-plate"].enabled = technologies["planet-discovery-secretas"].researched
    recipes["gold-plate-alt"].enabled = technologies["planet-discovery-secretas"].researched
  
    
  end