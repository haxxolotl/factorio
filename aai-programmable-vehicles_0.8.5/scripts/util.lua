local Util = {}

Util.min = math.min
Util.max = math.max
Util.floor = math.floor
Util.abs = math.abs
Util.sqrt = math.sqrt
Util.sin = math.sin
Util.cos = math.cos
Util.atan = math.atan
Util.pi = math.pi
Util.remove = table.remove
Util.insert = table.insert
Util.str_gsub = string.gsub

function Util.string_split (str, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(str, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function Util.string_join (str_table, sep)
  local str = ""
  for _, str_part in pairs(str_table) do
    if str ~= "" then
      str = str .. sep
    end
      str = str .. str_part
  end
  return str
end


function Util.dot_string_less_than(a, b, allow_equal)
  if allow_equal and a == b then return true end
  local a_parts = Util.string_split(a, ".")
  local b_parts = Util.string_split(b, ".")
  for i = 1, #a_parts do
    if tonumber(a_parts[i]) < tonumber(b_parts[i]) then
      return true
    elseif a_parts[i] ~= b_parts[i] then
      return false
    end
  end
  return false
end

function Util.dot_string_greater_than(a, b, allow_equal)
  if allow_equal and a == b then return true end
  local a_parts = Util.string_split(a, ".")
  local b_parts = Util.string_split(b, ".")
  for i = 1, #a_parts do
    if tonumber(a_parts[i]) > tonumber(b_parts[i]) then
      return true
    elseif a_parts[i] ~= b_parts[i] then
      return false
    end
  end
  return false
end


function Util.string_trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function Util.send_message(text)
    for _, player in pairs(game.players) do
        player.print(text)
    end
end

function Util.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function Util.table_contains(table, check)
  for k,v in pairs(table) do if v == check then return true end end
  return false
end

function Util.remove_from_table(list, item)
    local index = 0
    for _,_item in ipairs(list) do
        if item == _item then
            index = _
            break
        end
    end
    if index > 0 then
        Util.remove(list, index)
    end
end

---@param entity_a LuaEntity
---@param entity_b LuaEntity
function Util.transfer_burner (entity_a, entity_b)
    if entity_a.burner and entity_a.burner.currently_burning and entity_b.burner then
        entity_b.burner.currently_burning = entity_a.burner.currently_burning.name
        entity_b.burner.remaining_burning_fuel = entity_a.burner.remaining_burning_fuel
    end
end

---@param entity_a LuaEntity
---@param entity_b LuaEntity
---@param inventory_type defines.inventory
function Util.transfer_inventory_loose (entity_a, entity_b, inventory_type)
    local inv_a = entity_a.get_inventory(inventory_type)
    if inv_a then
        local contents = inv_a.get_contents()
        for _, item in pairs(contents) do
            entity_b.insert({name=item.name, count=item.count, quality=item.quality})
        end
    end
end

---@param entity_a LuaEntity
---@param entity_b LuaEntity
---@param inventory_type defines.inventory
---@param inventory_type_b defines.inventory?
function Util.transfer_inventory (entity_a, entity_b, inventory_type, inventory_type_b)
    local inv_a = entity_a.get_inventory(inventory_type)
    local inv_b = entity_b.get_inventory(inventory_type_b or inventory_type)
    if inv_a and inv_b then
        local contents = inv_a.get_contents()
        for _, item in pairs(contents) do
            inv_b.insert({name=item.name, count=item.count, quality=item.quality})
        end
    end
end

---@param entity_a LuaEntity
---@param entity_b LuaEntity
---@param inventory_type defines.inventory
function Util.transfer_inventory_filters (entity_a, entity_b, inventory_type)
    local inv_a = entity_a.get_inventory(inventory_type)
    local inv_b = entity_b.get_inventory(inventory_type)
    if inv_a and inv_b and inv_a.supports_filters() and inv_b.supports_filters() then
        for i = 1, Util.min(#inv_a, #inv_b) do
            local filter = inv_a.get_filter(i)
            if filter then
                inv_b.set_filter(i, filter)
            end
        end
    end
end



function Util.position_to_area(position, radius)
  return {{x = position.x - radius, y = position.y - radius},
          {x = position.x + radius, y = position.y + radius}}
end

function Util.position_to_tile(position)
    return {x = math.floor(position.x), y = math.floor(position.y)}
end
function Util.tile_to_position(tile_position)
    return {x = tile_position.x+0.5, y = tile_position.y+0.5}
end

function Util.position_to_xy_string(position)
    return Util.xy_to_string(position.x, position.y)
end

function Util.xy_to_string(x, y)
    return Util.floor(x) .. "_" .. Util.floor(y)
end

function Util.lerp_angles(a, b, alpha)
    local da = b - a

    if da < -0.5 then
        da = da + 1
    elseif da > 0.5 then
        da = da - 1
    end
    local na = a + da * alpha
    if na < 0 then
        na = na + 1
    elseif na > 1 then
        na = na - 1
    end
    return na
end

function Util.array_to_vector(array)
    return {x = array[1], y = array[2]}
end

function Util.vectors_delta(a, b)
    if not a and b then return 0 end
    return {x = b.x - a.x, y = b.y - a.y}
end

function Util.vectors_delta_length(a, b)
    return Util.vector_length_xy(b.x - a.x, b.y - a.y)
end

function Util.vector_length(a)
    return Util.sqrt(a.x * a.x + a.y * a.y)
end

function Util.vector_length_xy(x, y)
    return Util.sqrt(x * x + y * y)
end

function Util.vector_dot(a, b)
    return a.x * b.x + a.y * b.y
end

function Util.vector_dot_projection(a, b)
    local n = Util.vector_normalise(a)
    local d = Util.vector_dot(n, b)
    return {x = n.x * d, y = n.y * d}
end

function Util.vector_normalise(a)
    local length = Util.vector_length(a)
    return {x = a.x/length, y = a.y/length}
end

function Util.vector_set_length(a, length)
    local old_length = Util.vector_length(a)
    if old_length == 0 then return {x = 0, y = -length} end
    return {x = a.x/old_length*length, y = a.y/old_length*length}
end

function Util.orientation_from_to(a, b)
    return Util.vector_to_orientation_xy(b.x - a.x, b.y - a.y)
end

function Util.orientation_to_vector(orientation, length)
    return {x = length * Util.sin(orientation * 2 * Util.pi), y = -length * Util.cos(orientation * 2 * Util.pi)}
end

function Util.rotate_vector(orientation, a)
    return {
      x = -a.y * Util.sin(orientation * 2 * Util.pi) + a.x * Util.sin((orientation + 0.25) * 2 * Util.pi),
      y = a.y * Util.cos(orientation * 2 * Util.pi) -a.x * Util.cos((orientation + 0.25) * 2 * Util.pi)}
end

function Util.vectors_add(a, b)
    return {x = a.x + b.x, y = a.y + b.y}
end

function Util.lerp_vectors(a, b, alpha)
    return {x = a.x + (b.x - a.x) * alpha, y = a.y + (b.y - a.y) * alpha}
end

function Util.move_to(a, b, max_distance, eliptical)
    -- move from a to b with max_distance.
    -- if eliptical, reduce y change (i.e. turret muzzle flash offset)
    local eliptical_scale = 0.9
    local delta = Util.vectors_delta(a, b)
    if eliptical then
        delta.y = delta.y / eliptical_scale
    end
    local length = Util.vector_length(delta)
    if (length > max_distance) then
        local partial = max_distance / length
        delta = {x = delta.x * partial, y = delta.y * partial}
    end
    if eliptical then
        delta.y = delta.y * eliptical_scale
    end
    return {x = a.x + delta.x, y = a.y + delta.y}
end

function Util.vector_to_orientation(v)
    return Util.vector_to_orientation_xy(v.x, v.y)
end

function Util.vector_to_orientation_xy(x, y)
    if x == 0 then
        if y > 0 then
            return 0.5
        else
            return 0
        end
    elseif y == 0 then
        if x < 0 then
            return 0.75
        else
            return 0.25
        end
    else
        if y < 0 then
            if x > 0 then
                return Util.atan(x / -y) / Util.pi / 2
            else
                return 1 + Util.atan(x / -y) / Util.pi / 2
            end
        else
            return 0.5 + Util.atan(x / -y) / Util.pi / 2
        end
    end
end

function Util.direction_to_orientation(direction)
    if direction == defines.direction.north then
        return 0
    elseif direction == defines.direction.northeast then
        return 0.125
    elseif direction == defines.direction.east then
        return 0.25
    elseif direction == defines.direction.southeast then
        return 0.375
    elseif direction == defines.direction.south then
        return 0.5
    elseif direction == defines.direction.southwest then
        return 0.625
    elseif direction == defines.direction.west then
        return 0.75
    elseif direction == defines.direction.northwest then
        return 0.875
    end
    return 0
end

---@param signal SignalFilter.0
function Util.signal_to_string(signal)
  local type = signal.type or "item"
  local quality
  if signal.quality and signal.quality.name then
    quality = signal.quality.name
  else
    quality = signal.quality or "normal"
  end
  local comparator = signal.comparator or "="

  return type .. "__" .. signal.name .. "__" .. quality .. "__" .. comparator
end

-- function Util.section_container_add(container, section)
--     container.sections = container.sections or {}
--     if section then
--         container.sections[section] = true
--     end
-- end

---@param container table
---@param filter LogisticFilter
function Util.signal_container_add(container, filter) -- ex : filter = {value=signal.signal, min=signal.count}
  if filter then
    local type = filter.value.type or "item"
    local quality = filter.value.quality or "normal"
    local comparator = filter.value.comparator or "="
    if not container[type] then
      container[type] = {}
    end
    if not container[type][filter.value.name] then
      container[type][filter.value.name] = {}
    end
    if not container[type][filter.value.name][quality] then
      container[type][filter.value.name][quality] = {}
    end
    if container[type][filter.value.name][quality][comparator] then
        container[type][filter.value.name][quality][comparator].min = container[type][filter.value.name][quality][comparator].min + filter.min
    else
        container[type][filter.value.name][quality][comparator] = filter
    end
  end
end

---@param container table
---@param entity LuaEntity
---@param inventory defines.inventory
function Util.signal_container_add_inventory(container, entity, inventory)
    local inv = entity.get_inventory(inventory)
    if inv then
        local contents = inv.get_contents()
        for _, item_details in pairs(contents) do
            local filter = {
                value = {
                    type = "item",
                    name = item_details.name,
                    quality = item_details.quality,
                    comparator = "="
                },
                min = item_details.count
            } 
            Util.signal_container_add(container, filter)
        end
    end
end

---@param container table
---@param signal SignalFilter
function util.signal_container_get(container, signal)
  local type = signal.type or "item"
  local quality = signal.quality or "normal"
  local comparator = signal.comparator or "="
  if    container[type]
    and container[type][signal.name]
    and container[type][signal.name][quality]
    and container[type][signal.name][quality][comparator]
  then
    return container[type][signal.name][quality][comparator]
  end
end

Util.char_to_multiplier = {
    m = 0.001,
    c = 0.01,
    d = 0.1,
    h = 100,
    k = 1000,
    M = 1000000,
    G = 1000000000,
    T = 1000000000000,
    P = 1000000000000000,
}

function Util.string_to_number(str)
    str = ""..str
    local number_string = ""
    local last_char = nil
    for i = 1, #str do
        local c = str:sub(i,i)
        if c == "." or (c == "-" and string.len(number_string) == 0) or tonumber(c) ~= nil then
            number_string = number_string .. c
        else
            last_char = c
            break
        end
    end
    local number = tonumber(number_string)
    if not number then
        return 0
    end
    if last_char and Util.char_to_multiplier[last_char] then
        return number * Util.char_to_multiplier[last_char]
    end
    return number
end

function Util.replace(str, what, with)
    what = Util.str_gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
    with = Util.str_gsub(with, "[%%]", "%%%%") -- escape replacement
    return Util.str_gsub(str, what, with)
end


-- splits a string by spaces
function Util.just_words(str)
   --[[str = str
   local t = {}
   local function helper(word)
      table.insert(t, word)
      return ""
   end
   if not str:gsub("%w+", helper):find"%S" then
      return t
   end]]--
   local words = {}
   for w in str:gmatch("%S+") do
     if w  and w ~= "" then
       table.insert(words, w)
     end
   end
   if #words > 0 then
     return words
   end
end

---@param entity_a LuaEntity
---@param entity_b LuaEntity
function Util.copy_equipment_grid (entity_a, entity_b) -- NOTE: entity can be an item
  if not (entity_a.grid and entity_b.grid) then return end
  for _, a_eq in pairs(entity_a.grid.equipment) do
    if a_eq.type == "equipment-ghost" then
      entity_b.grid.put({name = a_eq.ghost_name, quality = a_eq.quality, position = a_eq.position, ghost = true})
    else
      local b_eq = entity_b.grid.put({name = a_eq.name, quality = a_eq.quality, position = a_eq.position})
      if b_eq and b_eq.valid then
        if a_eq.type == "energy-shield-equipment" then
          b_eq.shield = a_eq.shield
        end
        if a_eq.energy then
          b_eq.energy = a_eq.energy
        end
        if a_eq.burner then
          for i = 1, #a_eq.burner.inventory do
            b_eq.burner.inventory.insert(a_eq.burner.inventory[i])
          end
          for i = 1, #a_eq.burner.burnt_result_inventory do
            b_eq.burner.burnt_result_inventory.insert (a_eq.burner.burnt_result_inventory[i])
          end

          b_eq.burner.currently_burning = a_eq.burner.currently_burning
          b_eq.burner.heat = a_eq.burner.heat
          b_eq.burner.remaining_burning_fuel = a_eq.burner.remaining_burning_fuel
        end
      end
    end
  end
  entity_b.grid.inhibit_movement_bonus = entity_a.grid.inhibit_movement_bonus
end

---@param entity_a LuaEntity
---@param entity_b LuaEntity
function Util.transfer_equipment_grid (entity_a, entity_b)
  if not (entity_a.grid and entity_b.grid) then return end
  Util.copy_equipment_grid (entity_a, entity_b)
  entity_a.grid.clear()
end

---@param entity_a LuaEntity
---@param entity_b LuaEntity
function Util.copy_logistic_requests (entity_a, entity_b)
  if not (entity_a.grid and entity_b.grid) then return end
  local old_logi_point = entity_a.get_logistic_point(defines.logistic_member_index.character_requester)
  local new_logi_point = entity_b.get_logistic_point(defines.logistic_member_index.character_requester)
  if old_logi_point and new_logi_point then
    -- Ensure we are working from a clean slate. (New characters start with a default section)
    if new_logi_point and new_logi_point.sections_count > 0 then
      for i = 1, new_logi_point.sections_count do
        new_logi_point.remove_section(i)
      end
    end
    for i, logi_section in pairs(old_logi_point.sections) do
      local new_section
      if logi_section.group and logi_section.group ~= "" then
        new_section = new_logi_point.add_section(logi_section.group)
      else -- "[No group assigned]" section, needs to be duplicated slot by slot
        new_section = new_logi_point.add_section()
        ---@cast new_section -?
        for j, logi_filter in pairs(logi_section.filters) do
          new_section.set_slot(j, logi_filter)
        end
      end
      new_section.active = logi_section.active
      new_section.multiplier = logi_section.multiplier
    end
    new_logi_point.trash_not_requested = old_logi_point.trash_not_requested
    new_logi_point.enabled = old_logi_point.enabled
  end
end

function Util.table_map(source, process, ...)
    local output = {}
    for key, value in pairs(source) do
        output[key] = process(key, value, ...)
    end
    return output
end

function Util.table_filter (source, filter)
  local output = {}
  for key, value in pairs(source) do
    if filter(value) then
      output[key] = value
    end
  end
  return output
end

return Util
