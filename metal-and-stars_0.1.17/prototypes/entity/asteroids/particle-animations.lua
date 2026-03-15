local particle_animations = {}

-------------------------------------------------------------------------------
--mirandite-asteroid-particles

particle_animations.get_mirandite_asteroid_particle_small_pictures = function(options)
  local options = options or {}
  return {
    sheet = {
      filename = "__metal-and-stars-graphics__/graphics/particle/asteroid-particle/mirandite-asteroid-particle-small.png",
      priority = "extra-high",
      width = 14,
      height = 16,
      frame_count = 12,
      animation_speed = 0.3,
      variation_count = 10,
      tint = options.tint,
      shift = util.add_shift(util.by_pixel(0.0,0.5), options.shift),
      scale = 0.5
    }
  }
end

particle_animations.get_mirandite_asteroid_particle_medium_pictures = function(options)
  local options = options or {}
  return {
    sheet = {
      filename = "__metal-and-stars-graphics__/graphics/particle/asteroid-particle/mirandite-asteroid-particle-medium.png",
      priority = "extra-high",
      width = 22,
      height = 22,
      frame_count = 12,
      animation_speed = 0.3,
      variation_count = 10,
      tint = options.tint,
      shift = util.add_shift(util.by_pixel(0.0,0.0), options.shift),
      scale = 0.5
    }
  }
end

particle_animations.get_mirandite_asteroid_particle_big_pictures = function(options)
  local options = options or {}
  return {
    sheet = {
      filename = "__metal-and-stars-graphics__/graphics/particle/asteroid-particle/mirandite-asteroid-particle-big.png",
      priority = "extra-high",
      width = 36,
      height = 36,
      frame_count = 12,
      animation_speed = 0.3,
      variation_count = 10,
      tint = options.tint,
      shift = util.add_shift(util.by_pixel(0.0,0.5), options.shift),
      scale = 0.5
    }
  }
end

particle_animations.get_mirandite_asteroid_particle_top_small_pictures = function(options)
  local options = options or {}
  return {
    sheet = {
      filename = "__metal-and-stars-graphics__/graphics/particle/asteroid-particle/mirandite-asteroid-particle-top-small.png",
      priority = "extra-high",
      width = 58,
      height = 56,
      frame_count = 16,
      animation_speed = 0.2,
      variation_count = 6,
      tint = options.tint,
      shift = util.add_shift(util.by_pixel( 0.5, 0.0), options.shift),
      scale = 0.5
    }
  }
end

particle_animations.get_mirandite_asteroid_particle_top_big_pictures = function(options)
  local options = options or {}
  return {
    sheet = {
      filename = "__metal-and-stars-graphics__/graphics/particle/asteroid-particle/mirandite-asteroid-particle-top-big.png",
      priority = "extra-high",
      width = 82,
      height = 82,
      frame_count = 16,
      animation_speed = 0.2,
      variation_count = 6,
      tint = options.tint,
      shift = util.add_shift(util.by_pixel( 0.5, 0.5), options.shift),
      scale = options.scale or 0.5
    }
  }
end

return particle_animations