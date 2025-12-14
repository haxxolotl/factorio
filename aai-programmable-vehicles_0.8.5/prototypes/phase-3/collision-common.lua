-- Collisions shared between SE, combat mechanics overhaul & alien biomes

for _, tile in pairs(data.raw.tile) do
  if string.find(tile.name, "water") then
    table.insert(tile.collision_mask, "item-layer")
  end
end

table.insert(data.raw.tile.landfill.collision_mask, "resource-layer") -- prevent regenerated ores from spawning on landfill

-- make vehicles collide with trees and pipes (train-layer)
-- stop characters colliding with pipes (player-layer)
for _, type in pairs({"pipe", "pipe-to-ground"}) do
  for _, prototype in pairs(data.raw[type]) do
    prototype.collision_mask = collision_mask_util.get_mask(prototype)
    prototype.collision_mask.layers.player = nil
    prototype.collision_mask.layers.vehicle = true
  end
end

for _, type in pairs({"car"}) do
  for _, prototype in pairs(data.raw[type]) do
    prototype.collision_mask = collision_mask_util.get_mask(prototype)
    if prototype.collision_mask.layers.player then
      prototype.collision_mask.layers.vehicle = true
    end
  end
end

-- make trees collide with resources so they won't be placed on top
-- make trees collide with vehicles (train-layer) but not characters (player-layer)
for _, type in pairs({"tree"}) do
  for _, prototype in pairs(data.raw[type]) do
    if string.find(prototype.name, "tree", 1, true) then
      prototype.collision_mask = collision_mask_util.get_mask(prototype)
      if prototype.collision_mask.layers.player then
        prototype.collision_mask.layers.player = nil
        prototype.collision_mask.layers.vehicle = true
      end
      prototype.collision_mask.layers.resource = true
      if prototype.collision_box
       and ((prototype.collision_box[1][1] == -1/32 and prototype.collision_box[1][2] == -1/32 -- AB tree
       and prototype.collision_box[2][1] == 1/32  and prototype.collision_box[2][2] == 1/32)
       or (prototype.collision_box[1][1] == -0.080000000000000018 and prototype.collision_box[1][2] == -0.080000000000000018 -- squeak tree
       and prototype.collision_box[2][1] == 0.080000000000000018  and prototype.collision_box[2][2] == 0.080000000000000018)) then
        prototype.collision_box = {{-0.4, -0.4}, {0.4, 0.4}}
      end
    end
  end
end

for _, leg in pairs(data.raw["spider-leg"]) do
  leg.collision_mask = {
    layers = {
      object = true,
      player = true,
      water_tile = true,
      rail = true,
    },
  }
end
