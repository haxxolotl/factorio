local data_util = require("data-util")

require("prototypes/entity/entity-update")
require("prototypes/ai-vehicles")
require("prototypes/item-projectiles")

-- Aircraft Realism compatibility for AI vehicle variants (including modded planes)
-- Creates airborne counterparts for AI plane prototypes and registers them with Aircraft Realism.
if mods["AircraftRealism"] then
  local ok_a, ar_api = pcall(require, "__AircraftRealism__.api")
  local ok_u, ar_util = pcall(require, "__AircraftRealism__.logic.utility")
  if ok_a and ok_u and ar_api and ar_util then
    local plane_data = ar_util.getPlaneData()
    local grounded_index = plane_data.grounded or {}
    local plane_config = plane_data.data or {}

    local function strip_shadows(animation)
      if animation and animation.layers then
        local kept = {}
        for _, layer in pairs(animation.layers) do
          if not layer.draw_as_shadow then
            table.insert(kept, layer)
          end
        end
        animation.layers = kept
      end
    end

    local function register_ai_plane(ai_name, base_name, cfg)
      local grounded = data.raw.car[ai_name]
      if not grounded then return end
      if not (cfg and cfg.transitionSpeedSetting) then
        return
      end

      local function improve_turn_radius(entity)
        if entity and entity.rotation_speed then
          entity.rotation_speed = entity.rotation_speed * 3 -- tighter turning for AI aircraft
        end
      end

      grounded.collision_mask = { layers = {} } -- treat AI aircraft as flying: ignore terrain/buildings for pathing

      local flying = table.deepcopy(grounded)
      flying.name = ai_name .. "-flying"

      strip_shadows(flying.animation)
      strip_shadows(flying.light_animation)

      flying.collision_mask = { layers = {} } -- airborne version also ignores collisions
      if grounded.friction then
        flying.friction = grounded.friction / 6
      end
      if grounded.effectivity then
        flying.effectivity = grounded.effectivity / 4
      end

      improve_turn_radius(grounded)
      improve_turn_radius(flying)

      data:extend{ flying }

      local transition_setting = cfg.transitionSpeedSetting
      -- Some third-party planes (e.g., King Jo pack) may not provide a transition-speed setting; fall back to a safe default to avoid runtime asserts.
      if transition_setting and string.find(transition_setting, "transition-speed-kj_", 1, true) then
        transition_setting = "aai-ai-plane-transition-speed-default"
      end

      ar_api.register_plane{
        grounded_name = ai_name,
        airborne_name = flying.name,
        transition_speed_setting = transition_setting,
        shadow_sprite = cfg.shadowSprite or {},
        shadow_end_speed = cfg.shadowEndSpeed or (10 * ar_util.KPH2MPT),
      }
    end

    for base_name, idx in pairs(grounded_index) do
      local cfg = plane_config[idx]
      for ai_name, _ in pairs(data.raw.car) do
        if ai_name ~= base_name
          and string.sub(ai_name, 1, #base_name + 1) == (base_name .. "-")
          and not ar_util.isGroundedPlane(ai_name)
          and not ar_util.isAirbornePlane(ai_name) then
          register_ai_plane(ai_name, base_name, cfg)
        end
      end
    end
  end
end

--log( serpent.block( data.raw["projectile"], {comment = false, numformat = '%1.8g' } ) )
--log( serpent.block( data.raw["utility-sprites"], {comment = false, numformat = '%1.8g' } ) )

local construction_denial_range = 50

-- worms
for _, turret in pairs(data.raw.turret) do
  if string.find(turret.name, "worm", 1, true) then
    if turret.attack_parameters and turret.attack_parameters.range and turret.attack_parameters.range < (data_util.construction_denial_range - 5)  then
      turret.attack_parameters.range = math.min( (data_util.construction_denial_range - 5), (turret.attack_parameters.range + 5) * 1.25)
      turret.attack_parameters.prepare_range = turret.attack_parameters.range + 5
    end
  end
end
