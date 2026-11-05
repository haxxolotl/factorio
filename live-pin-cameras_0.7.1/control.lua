local INPUT_NAME = "live-pin-cameras-create"
local PAN_INPUT_NAME = "live-pin-cameras-pan-shift"
local INTERACT_INPUT_NAME = "live-pin-cameras-interact"
local ZOOM_IN_INPUT_NAME = "live-pin-cameras-zoom-in"
local ZOOM_OUT_INPUT_NAME = "live-pin-cameras-zoom-out"
local SHORTCUT_NAME = "live-pin-cameras-toggle"
local REMOTE_NAME = "live_pin_cameras"
local MANAGER_NAME = "live_pin_cameras_manager"
local show_manager
local find_entity_at

local WINDOW_PREFIX = "live_pin_cameras_window_"
local CAMERA_PREFIX = "live_pin_cameras_camera_"
local CONTROLS_PREFIX = "live_pin_cameras_controls_"
local DISTANCE_SLIDER_PREFIX = "live_pin_cameras_distance_slider_"
local DISTANCE_FIELD_PREFIX = "live_pin_cameras_distance_"
local SIZE_SLIDER_PREFIX = "live_pin_cameras_size_slider_"
local SIZE_FIELD_PREFIX = "live_pin_cameras_size_"
local PAN_OVERLAY_PREFIX = "live_pin_cameras_pan_overlay_"
local PAN_CELL_PREFIX = "live_pin_cameras_pan_cell_"

local DEFAULT_CAMERA_WIDTH = 384
local MIN_CAMERA_WIDTH = 320
local MAX_CAMERA_WIDTH = 960
local CAMERA_WIDTH_STEP = 32
local FRAME_EXTRA_WIDTH = 16
local CAMERA_OFFSET_X = 8
local CAMERA_OFFSET_Y = 36
local MIN_DISTANCE = 4
local MAX_DISTANCE = 128
local DEFAULT_DISTANCE = 16
local WHEEL_ZOOM_FACTOR = 1.25
local WORLD_ZOOM_FACTOR = 1.1
local OVERLAY_CELL_SIZE = 16
local SIZE_COMMIT_DELAY = 12
local refresh_overlay_tooltips

local function clamp(value, minimum, maximum)
  return math.max(minimum, math.min(maximum, value))
end

local function distance_to_zoom(distance, camera_width)
  -- A Factorio tile is 32 source pixels. Preview distance is treated as a
  -- radius, matching the terminology and behavior of the native pin editor.
  return clamp(camera_width / (distance * 64), 0.05, 2)
end

local function normalize_camera_width(value)
  local stepped = math.floor((value / CAMERA_WIDTH_STEP) + 0.5) * CAMERA_WIDTH_STEP
  return clamp(stepped, MIN_CAMERA_WIDTH, MAX_CAMERA_WIDTH)
end

local function camera_height(camera_width)
  return math.floor(camera_width * 2 / 3)
end

local function copy_position(position)
  local x, y = position.x or position[1], position.y or position[2]
  assert(type(x)=="number" and type(y)=="number" and x==x and y==y
    and math.abs(x)<math.huge and math.abs(y)<math.huge, "Expected a finite map position")
  return {x = x, y = y}
end

local function ensure_storage()
  storage.live_pin_cameras = storage.live_pin_cameras or {players = {}}
  storage.live_pin_cameras.players = storage.live_pin_cameras.players or {}
  return storage.live_pin_cameras
end

local function player_state(player_index)
  local root = ensure_storage()
  local state = root.players[player_index]
  if not state then
    state = {
      enabled = false,
      next_id = 1,
      windows = {}
    }
    root.players[player_index] = state
  end
  state.windows = state.windows or {}
  state.next_id = state.next_id or 1
  return state
end

local function window_name(id)
  return WINDOW_PREFIX .. id
end

local function camera_name(id)
  return CAMERA_PREFIX .. id
end

local function controls_name(id)
  return CONTROLS_PREFIX .. id
end

local function distance_slider_name(id)
  return DISTANCE_SLIDER_PREFIX .. id
end

local function distance_field_name(id)
  return DISTANCE_FIELD_PREFIX .. id
end

local function size_slider_name(id)
  return SIZE_SLIDER_PREFIX .. id
end

local function size_field_name(id)
  return SIZE_FIELD_PREFIX .. id
end

local function pan_overlay_name(id)
  return PAN_OVERLAY_PREFIX .. id
end

local function pan_cell_name(id, index)
  return PAN_CELL_PREFIX .. id .. "_" .. index
end

local function window_title(window)
  if window.entity and window.entity.valid then
    return {"", {"live-pin-cameras.window-title"}, " — ", window.entity.localised_name}
  end
  return {
    "",
    {"live-pin-cameras.window-title"},
    " — ",
    string.format("%.1f, %.1f", window.position.x, window.position.y)
  }
end

local function short_window_title(window)
  if window.label and window.label ~= "" then return window.label end
  if window.entity and window.entity.valid then
    local name = window.entity.name
    if #name > 27 then
      name = name:sub(1, 26) .. "…"
    end
    return {"", {"live-pin-cameras.window-title"}, " — ", name}
  end
  return {
    "",
    {"live-pin-cameras.window-title"},
    " — ",
    string.format("%.1f, %.1f", window.position.x, window.position.y)
  }
end

local function camera_center(window)
  local offset = window.offset or {x = 0, y = 0}
  return {
    x = window.position.x + offset.x,
    y = window.position.y + offset.y
  }
end

local function default_location(player, id, camera_width)
  local scale = player.display_scale
  if not scale or scale <= 0 then
    scale = 1
  end
  local screen_width = player.display_resolution.width / scale
  local screen_height = player.display_resolution.height / scale
  local offset = ((id - 1) % 8) * 28
  local window_width = camera_width + FRAME_EXTRA_WIDTH
  local window_height = camera_height(camera_width) + 112
  return {
    x = math.max(0, math.floor(((screen_width - window_width) / 2 + offset - 98) * scale)),
    y = math.max(0, math.floor(((screen_height - window_height) / 2 + offset - 70) * scale))
  }
end

local function clamp_location(player, frame, window)
  local scale = player.display_scale
  local location = frame.location
  local x = clamp(location.x, 0, math.max(0, player.display_resolution.width - (window.camera_width + 16) * scale))
  local y = clamp(location.y, 0, math.max(0, player.display_resolution.height - (camera_height(window.camera_width) + 86) * scale))
  if x ~= location.x or y ~= location.y then frame.location = {x = x, y = y} end
  window.location = {x = x, y = y}
end

local function apply_camera_target(camera, window)
  window.offset = window.offset or {x = 0, y = 0}
  if window.entity and window.entity.valid then
    window.position = copy_position(window.entity.position)
    window.surface_index = window.entity.surface.index
    camera.surface_index = window.surface_index
    if window.offset.x == 0 and window.offset.y == 0 then
      camera.position = window.position
      camera.entity = window.entity
    else
      camera.entity = nil
      camera.position = camera_center(window)
    end
  else
    window.entity = nil
    camera.entity = nil
    camera.surface_index = window.surface_index
    camera.position = camera_center(window)
  end
  camera.zoom = distance_to_zoom(window.preview_distance, window.camera_width)
end


local function pan_overlay_location(frame)
  local player = game.get_player(frame.player_index)
  local scale = player and player.display_scale or 1
  return {
    x = frame.location.x + math.floor(CAMERA_OFFSET_X * scale + 0.5),
    y = frame.location.y + math.floor(CAMERA_OFFSET_Y * scale + 0.5)
  }
end

local function end_camera_hover(player)
  local state = player_state(player.index)
  if state.hover then
    player.game_view_settings.update_entity_selection = state.hover.update_selection
    player.game_view_settings.show_entity_tooltip = state.hover.show_tooltip
    if player.selected == state.hover.entity then
      player.selected = nil
    end
    state.hover = nil
  end
end

local function show_native_details(player, id, index, entity)
  local state = player_state(player.index)
  if not state.hover then
    state.hover = {
      update_selection = player.game_view_settings.update_entity_selection,
      show_tooltip = player.game_view_settings.show_entity_tooltip
    }
  end
  state.hover.id = id
  state.hover.index = index
  state.hover.entity = entity and entity.valid and entity or nil
  player.game_view_settings.update_entity_selection = false
  player.game_view_settings.show_entity_tooltip = true
  player.selected = state.hover.entity
end

local function can_interact(player, entity)
  -- The remote controller can access distant entities. Direct inventory access
  -- here must instead pass the physical character's reach check.
  local character = player.character
  return entity and entity.valid and entity.operable
    and character and character.valid and character.surface == entity.surface
    and character.can_reach_entity(entity) and player.can_reach_entity(entity)
end

local function can_inspect_remotely(player, entity)
  return entity and entity.valid and entity.operable
    and player.controller_type == defines.controllers.remote
    and player.surface == entity.surface and player.can_reach_entity(entity)
end

local function open_camera_entity(player, entity)
  if not (entity and entity.valid and entity.operable) then return false end
  local group = player.permission_group
  if group and not group.allows_action(defines.input_action.open_gui) then return false end
  local remote = player.controller_type == defines.controllers.remote or not can_interact(player, entity)
  if remote then
    if group and (not group.allows_action(defines.input_action.remote_view_surface)
      or not group.allows_action(defines.input_action.remote_view_entity)) then return false end
    -- Keep the real remote controller active for the entire GUI lifetime. Setting
    -- opened from the character controller bypasses native remote inventory rules.
    local ok = pcall(function()
      player.set_controller{type=defines.controllers.remote, surface=entity.surface, position=entity.position}
    end)
    if not ok or not can_inspect_remotely(player, entity) then return false end
  end
  local ok = pcall(function() player.opened = entity end)
  if ok and player.opened == entity then
    player_state(player.index).opened_from_camera = entity
    return true
  end
  return false
end

local function check_opened_camera(player)
  local state = player_state(player.index)
  local entity = state.opened_from_camera
  if not entity then return end
  if not entity.valid or player.opened ~= entity then
    state.opened_from_camera = nil
  elseif not can_interact(player, entity) and not can_inspect_remotely(player, entity) then
    -- Walk-away and controller/surface changes must not leave direct access open.
    player.opened = nil
    state.opened_from_camera = nil
  end
end

local function sync_pan_overlay(player, id, window, bring_to_front)
  local frame = player.gui.screen[window_name(id)]
  if not (frame and frame.valid) then
    return
  end

  local overlay = player.gui.screen[pan_overlay_name(id)]
  if overlay and overlay.valid then
    local tags = overlay.tags
    if tags.live_pin_cameras_width ~= window.camera_width then
      overlay.destroy()
      overlay = nil
    end
  end
  if not (overlay and overlay.valid) then
    local width = window.camera_width
    local height = camera_height(width)
    local cell_size = OVERLAY_CELL_SIZE
    while math.ceil(width / cell_size) * math.ceil(height / cell_size) > 1024 do cell_size = cell_size + 8 end
    local columns = math.ceil(width / cell_size)
    local rows = math.ceil(height / cell_size)
    overlay = player.gui.screen.add({
      type = "table",
      name = pan_overlay_name(id),
      style = "live_pin_cameras_camera_overlay_grid",
      column_count = columns,
      tags = {live_pin_cameras_id = id, live_pin_cameras_width = width}
    })
    local index = 0
    for row = 1, rows do
      local cell_height = math.min(cell_size, height - (row - 1) * cell_size)
      for column = 1, columns do
        index = index + 1
        local cell_width = math.min(cell_size, width - (column - 1) * cell_size)
        local cell = overlay.add({
          type = "button",
          name = pan_cell_name(id, index),
          style = "live_pin_cameras_camera_overlay",
          mouse_button_filter = {"left-and-right", "middle", "button-4", "button-5", "button-6", "button-7", "button-8", "button-9"},
          tags = {
            live_pin_cameras_action = "camera",
            live_pin_cameras_id = id,
            live_pin_cameras_cell_index = index,
            live_pin_cameras_cell_x = (column - 1) * cell_size + cell_width / 2,
            live_pin_cameras_cell_y = (row - 1) * cell_size + cell_height / 2,
            live_pin_cameras_cell_size = cell_size
          }
        })
        cell.style.width = cell_width
        cell.style.height = cell_height
        cell.raise_hover_events = true
      end
    end
  end

  overlay.location = pan_overlay_location(frame)
  window.tooltip_dirty = true
  if bring_to_front then
    frame.bring_to_front()
    overlay.bring_to_front()
  end
end

local function camera_element_id(element)
  if not (element and element.valid) then
    return nil
  end
  local tags = element.tags
  if tags.live_pin_cameras_action == "camera" then
    return tags.live_pin_cameras_id
  end
  return nil
end

local function camera_element_center(player, element)
  local id = camera_element_id(element)
  local overlay = id and player.gui.screen[pan_overlay_name(id)] or nil
  if not (overlay and overlay.valid) then
    return nil
  end
  local scale = player.display_scale
  if not scale or scale <= 0 then
    scale = 1
  end
  local tags = element.tags
  return {
    x = overlay.location.x + tags.live_pin_cameras_cell_x * scale,
    y = overlay.location.y + tags.live_pin_cameras_cell_y * scale
  }
end

local function build_window(player, id, window)
  local state = player_state(player.index)
  if state.hover and state.hover.id == id then end_camera_hover(player) end
  local old = player.gui.screen[window_name(id)]
  if old and old.valid then
    old.destroy()
  end
  local old_overlay = player.gui.screen[pan_overlay_name(id)]
  if old_overlay and old_overlay.valid then
    old_overlay.destroy()
  end
  window.hover_entities = nil
  if window.hidden then return end

  local frame = player.gui.screen.add({
    type = "frame",
    name = window_name(id),
    direction = "vertical",
    tags = {live_pin_cameras_id = id}
  })
  frame.style.width = window.camera_width + FRAME_EXTRA_WIDTH

  local titlebar = frame.add({type = "flow", direction = "horizontal"})
  titlebar.style.vertical_align = "center"

  local title = titlebar.add({
    type = "label",
    caption = short_window_title(window),
    tooltip = window_title(window),
    style = "frame_title"
  })
  title.style.single_line = true
  title.style.maximal_width = math.max(100, window.camera_width - 138)

  local dragger = titlebar.add({
    type = "empty-widget",
    style = "draggable_space"
  })
  dragger.style.horizontally_stretchable = true
  dragger.style.height = 24
  dragger.drag_target = frame

  titlebar.add({
    type = "button",
    caption = "i",
    style = "frame_action_button",
    tooltip = {"live-pin-cameras.camera-help"},
    tags = {live_pin_cameras_action = "info", live_pin_cameras_id = id}
  })

  titlebar.add({
    type = "sprite-button",
    sprite = "utility/reset",
    style = "frame_action_button",
    tooltip = {"live-pin-cameras.reset-pan"},
    tags = {live_pin_cameras_action = "reset-pan", live_pin_cameras_id = id}
  })

  titlebar.add({
    type = "sprite-button",
    sprite = "utility/close",
    style = "frame_action_button",
    tooltip = {"live-pin-cameras.hide-camera"},
    tags = {live_pin_cameras_action = "close", live_pin_cameras_id = id}
  })

  local camera = frame.add({
    type = "camera",
    name = camera_name(id),
    position = window.position,
    surface_index = window.surface_index,
    zoom = distance_to_zoom(window.preview_distance, window.camera_width)
  })
  camera.style.width = window.camera_width
  camera.style.height = camera_height(window.camera_width)
  apply_camera_target(camera, window)

  local controls = frame.add({
    type = "flow",
    name = controls_name(id),
    direction = "horizontal"
  })
  controls.style.top_margin = 6
  controls.style.vertical_align = "center"
  controls.add({
    type = "label",
    caption = {"live-pin-cameras.preview-distance-short"},
    tooltip = {"live-pin-cameras.preview-distance"}
  })

  local slider = controls.add({
    type = "slider",
    name = distance_slider_name(id),
    minimum_value = MIN_DISTANCE,
    maximum_value = MAX_DISTANCE,
    value = window.preview_distance,
    value_step = 1,
    discrete_values = true,
    tags = {live_pin_cameras_action = "distance", live_pin_cameras_id = id}
  })
  slider.style.horizontally_stretchable = true
  slider.style.minimal_width = 60

  local field = controls.add({
    type = "textfield",
    name = distance_field_name(id),
    text = tostring(window.preview_distance),
    numeric = true,
    allow_decimal = false,
    allow_negative = false,
    tags = {live_pin_cameras_action = "distance-text", live_pin_cameras_id = id}
  })
  field.style.width = 44

  controls.add({
    type = "label",
    caption = {"live-pin-cameras.window-width-short"},
    tooltip = {"live-pin-cameras.window-width"}
  })

  local size_slider = controls.add({
    type = "slider",
    name = size_slider_name(id),
    minimum_value = MIN_CAMERA_WIDTH,
    maximum_value = MAX_CAMERA_WIDTH,
    value = window.camera_width,
    value_step = CAMERA_WIDTH_STEP,
    discrete_values = true,
    tags = {live_pin_cameras_action = "size", live_pin_cameras_id = id}
  })
  size_slider.style.horizontally_stretchable = true
  size_slider.style.minimal_width = 60

  local size_field = controls.add({
    type = "textfield",
    name = size_field_name(id),
    text = tostring(window.camera_width),
    numeric = true,
    allow_decimal = false,
    allow_negative = false,
    tags = {live_pin_cameras_action = "size-text", live_pin_cameras_id = id}
  })
  size_field.style.width = 52

  frame.location = window.location or default_location(player, id, window.camera_width)
  clamp_location(player, frame, window)
  sync_pan_overlay(player, id, window, true)
  refresh_overlay_tooltips(player, id)
end

local function open_window(player, target)
  local state = player_state(player.index)
  local count = 0
  for _ in pairs(state.windows) do count = count + 1 end
  if count >= settings.get_player_settings(player)["live-pin-cameras-limit"].value then
    player.print({"live-pin-cameras.limit-reached"})
    return nil
  end
  local id = state.next_id
  state.next_id = id + 1

  local distance = clamp(math.floor((target.preview_distance or DEFAULT_DISTANCE) + 0.5), MIN_DISTANCE, MAX_DISTANCE)
  local window = {
    entity = target.entity,
    surface_index = target.surface_index,
    position = copy_position(target.position),
    preview_distance = distance,
    camera_width = normalize_camera_width(target.camera_width or DEFAULT_CAMERA_WIDTH),
    offset = {x = 0, y = 0},
    location = nil
  }
  state.windows[id] = window
  build_window(player, id, window)
  if player.gui.screen[MANAGER_NAME] then show_manager(player) end
  return id
end

local function close_window(player, id)
  local state = player_state(player.index)
  if state.hover and state.hover.id == id then end_camera_hover(player) end
  state.windows[id] = nil
  local frame = player.gui.screen[window_name(id)]
  if frame and frame.valid then
    frame.destroy()
  end
  local overlay = player.gui.screen[pan_overlay_name(id)]
  if overlay and overlay.valid then
    overlay.destroy()
  end
  if state.pan and state.pan.id == id then state.pan = nil end
  if state.area_order and state.area_order.id == id then state.area_order = nil end
end

local function hide_window(player, id, hidden)
  local window = player_state(player.index).windows[id]
  if not window then return end
  window.hidden = hidden
  player_state(player.index).pan = nil
  player_state(player.index).area_order = nil
  build_window(player, id, window)
end

show_manager = function(player)
  local old = player.gui.screen[MANAGER_NAME]
  local location = old and old.location
  if old then old.destroy() end
  local frame = player.gui.screen.add{type="frame", name=MANAGER_NAME, direction="vertical",
    caption={"live-pin-cameras.manager-title"}}
  frame.auto_center = true
  if location then frame.location = location end
  local bar = frame.add{type="flow"}
  for _, action in ipairs{"show-all", "hide-all", "manager-close"} do
    bar.add{type="button", caption={"live-pin-cameras."..action}, tags={live_pin_cameras_action=action}}
  end
  local pane = frame.add{type="scroll-pane"}
  pane.style.maximal_height = 420
  local state = player_state(player.index)
  local ids = {}
  for id in pairs(state.windows) do ids[#ids+1] = id end
  table.sort(ids)
  for _, id in ipairs(ids) do
    local window = state.windows[id]
    local row = pane.add{type="flow"}
    local tags = {live_pin_cameras_id=id, live_pin_cameras_action="rename"}
    local name = row.add{type="textfield", text=window.label or ("Camera "..id), tooltip=window_title(window), tags=tags}
    name.style.width = 150
    row.add{type="checkbox", state=window.read_only or false, caption={"live-pin-cameras.read-only"},
      tags={live_pin_cameras_id=id, live_pin_cameras_action="read-only"}}
    for _, action in ipairs{window.hidden and "show" or "hide", "remote-view", "delete"} do
      row.add{type="button", caption={"live-pin-cameras."..action}, tags={live_pin_cameras_id=id, live_pin_cameras_action=action}}
    end
  end
  player.opened = frame
end

local function set_distance(player, id, value)
  local state = player_state(player.index)
  local window = state.windows[id]
  if not window then
    return
  end

  local distance = clamp(math.floor(value + 0.5), MIN_DISTANCE, MAX_DISTANCE)
  window.preview_distance = distance
  window.tooltip_dirty = true

  local frame = player.gui.screen[window_name(id)]
  if not (frame and frame.valid) then
    return
  end

  local camera = frame[camera_name(id)]
  if camera and camera.valid then
    camera.zoom = distance_to_zoom(distance, window.camera_width)
  end
  local controls = frame[controls_name(id)]
  if controls and controls.valid then
    local slider = controls[distance_slider_name(id)]
    if slider and slider.valid and slider.slider_value ~= distance then
      slider.slider_value = distance
    end
    local field = controls[distance_field_name(id)]
    if field and field.valid and field.text ~= tostring(distance) then
      field.text = tostring(distance)
    end
  end
end

local function wheel_zoom(player, id, zoom_in)
  local state = player_state(player.index)
  local window = state.windows[id]
  if not window then
    return
  end

  local current = window.preview_distance or DEFAULT_DISTANCE
  local scaled = zoom_in and (current / WHEEL_ZOOM_FACTOR) or (current * WHEEL_ZOOM_FACTOR)
  local distance = clamp(math.floor(scaled + 0.5), MIN_DISTANCE, MAX_DISTANCE)
  if distance == current then
    distance = clamp(current + (zoom_in and -1 or 1), MIN_DISTANCE, MAX_DISTANCE)
  end
  set_distance(player, id, distance)
end


local function set_camera_width(player, id, value)
  local state = player_state(player.index)
  local window = state.windows[id]
  if not window then
    return
  end

  local width = normalize_camera_width(value)
  window.camera_width = width
  window.pending_camera_width = nil
  window.pending_camera_width_tick = nil

  local frame = player.gui.screen[window_name(id)]
  if not (frame and frame.valid) then
    return
  end

  frame.style.width = width + FRAME_EXTRA_WIDTH
  local titlebar = frame.children[1]
  local title = titlebar and titlebar.valid and titlebar.children[1] or nil
  if title and title.valid then
    title.style.maximal_width = math.max(100, width - 138)
  end

  local camera = frame[camera_name(id)]
  if camera and camera.valid then
    camera.style.width = width
    camera.style.height = camera_height(width)
    camera.zoom = distance_to_zoom(window.preview_distance, width)
  end

  local controls = frame[controls_name(id)]
  if controls and controls.valid then
    local slider = controls[size_slider_name(id)]
    if slider and slider.valid and slider.slider_value ~= width then
      slider.slider_value = width
    end
    local field = controls[size_field_name(id)]
    if field and field.valid and field.text ~= tostring(width) then
      field.text = tostring(width)
    end
  end
  sync_pan_overlay(player, id, window, true)
  clamp_location(player, frame, window)
  sync_pan_overlay(player, id, window, false)
end

local function schedule_camera_width(player, id, value)
  local window = player_state(player.index).windows[id]
  if not window then
    return
  end
  local width = normalize_camera_width(value)
  window.pending_camera_width = width
  window.pending_camera_width_tick = game.tick

  local frame = player.gui.screen[window_name(id)]
  local controls = frame and frame.valid and frame[controls_name(id)] or nil
  if controls and controls.valid then
    local slider = controls[size_slider_name(id)]
    if slider and slider.valid and slider.slider_value ~= width then
      slider.slider_value = width
    end
    local field = controls[size_field_name(id)]
    if field and field.valid and field.text ~= tostring(width) then
      field.text = tostring(width)
    end
  end
end

local function commit_camera_width(player, id)
  local window = player_state(player.index).windows[id]
  if window and window.pending_camera_width then
    set_camera_width(player, id, window.pending_camera_width)
  end
end


local function set_camera_offset(player, id, offset)
  local state = player_state(player.index)
  local window = state.windows[id]
  if not window then
    return
  end
  window.offset = {x = offset.x, y = offset.y}
  window.tooltip_dirty = true
  local frame = player.gui.screen[window_name(id)]
  local camera = frame and frame.valid and frame[camera_name(id)] or nil
  if camera and camera.valid then
    apply_camera_target(camera, window)
  end
end


local function camera_geometry(player, id)
  local state = player_state(player.index)
  local window = state.windows[id]
  local frame = player.gui.screen[window_name(id)]
  if not (window and frame and frame.valid) then
    return nil
  end

  local scale = player.display_scale
  if not scale or scale <= 0 then
    scale = 1
  end
  local top_left = pan_overlay_location(frame)
  return window, {
    left = top_left.x,
    top = top_left.y,
    width = window.camera_width * scale,
    height = camera_height(window.camera_width) * scale,
    pixels_per_tile = 32 * distance_to_zoom(window.preview_distance, window.camera_width) * scale
  }
end

local function display_to_world(player, id, display_location)
  local window, geometry = camera_geometry(player, id)
  if not window then
    return nil
  end
  local center = camera_center(window)
  return {
    x = center.x + (display_location.x - geometry.left - geometry.width / 2) / geometry.pixels_per_tile,
    y = center.y + (display_location.y - geometry.top - geometry.height / 2) / geometry.pixels_per_tile
  }
end

-- Query only the cell actually being hovered, never rasterize the whole factory.
refresh_overlay_tooltips = function(player, id)
  local window = player_state(player.index).windows[id]
  local overlay = player.gui.screen[pan_overlay_name(id)]
  if not (window and overlay and overlay.valid) then return end
  local state = player_state(player.index)
  if state.hover and state.hover.id == id then
    local cell = overlay.children[state.hover.index]
    if cell and cell.valid then
      local entity = find_entity_at(player, id, camera_element_center(player, cell), cell.tags.live_pin_cameras_cell_size)
      show_native_details(player, id, state.hover.index, entity)
    end
  end
  window.tooltip_dirty = false
end

find_entity_at = function(player, id, display_location, cell_size)
  local position = display_to_world(player, id, display_location)
  local window = player_state(player.index).windows[id]
  local surface = window and game.surfaces[window.surface_index] or nil
  if not (position and surface) then
    return nil
  end

  local radius = cell_size and cell_size / (64 * distance_to_zoom(window.preview_distance, window.camera_width)) or 0
  local function contains(box)
    return box
      and position.x + radius >= box.left_top.x and position.x - radius <= box.right_bottom.x
      and position.y + radius >= box.left_top.y and position.y - radius <= box.right_bottom.y
  end

  local best = nil
  local best_priority = -1
  local best_distance = math.huge
  -- Area queries include large entities whose centers lie far outside the cell.
  local search = radius + 2
  for _, entity in pairs(surface.find_entities_filtered({area = {
    {position.x-search, position.y-search}, {position.x+search, position.y+search}
  }})) do
    if entity.valid and entity.prototype.selectable_in_game
      and (contains(entity.selection_box) or contains(entity.secondary_selection_box)) then
      local priority = entity.prototype.selection_priority or 0
      local dx = entity.position.x - position.x
      local dy = entity.position.y - position.y
      local distance = dx * dx + dy * dy
      if priority > best_priority or (priority == best_priority and distance < best_distance) then
        best = entity
        best_priority = priority
        best_distance = distance
      end
    end
  end
  return best
end

local function begin_pan(player, id, display_location, element)
  local state = player_state(player.index)
  local window = state.windows[id]
  if not window then
    return
  end
  state.pan_leave_tick = nil
  state.pan = {
    id = id,
    start_display = {x = display_location.x, y = display_location.y},
    start_cell = camera_element_center(player, element),
    start_offset = copy_position(window.offset or {x = 0, y = 0}),
    tick = game.tick
  }
end

local function update_pan(player, id, display_location, finished)
  local state = player_state(player.index)
  local pan = state.pan
  if not (pan and pan.id == id) then
    return false
  end
  local _, geometry = camera_geometry(player, id)
  if not geometry then
    state.pan = nil
    return false
  end
  local origin = not finished and pan.start_cell or pan.start_display
  origin = origin or pan.start_display
  set_camera_offset(player, id, {
    x = pan.start_offset.x - (display_location.x - origin.x) / geometry.pixels_per_tile,
    y = pan.start_offset.y - (display_location.y - origin.y) / geometry.pixels_per_tile
  })
  if finished then
    state.pan = nil
    state.pan_leave_tick = nil
  end
  return true
end


local function finish_pan(player, id, display_location)
  return update_pan(player, id, display_location, true)
end

local function has_cursor_tool(player)
  local stack = player.cursor_stack
  return (stack and stack.valid_for_read) or player.cursor_ghost or player.cursor_record
end

local function camera_construction(player, id, event)
  if not has_cursor_tool(player) then return end
  local position = display_to_world(player, id, event.cursor_display_location)
  local window = player_state(player.index).windows[id]
  local surface = window and game.surfaces[window.surface_index]
  if not (position and surface) then return end
  if window.read_only then return end

  local stack = player.cursor_stack
  local item = stack and stack.valid_for_read and stack or nil
  while item and item.is_blueprint_book do
    local inventory = item.get_inventory(defines.inventory.item_main)
    item = item.active_index and inventory[item.active_index] or nil
    if item and not item.valid_for_read then item = nil end
  end
  local record = player.cursor_record
  local blueprint = item and item.is_blueprint and item
    or record and record.type == "blueprint" and record
  local deconstruct = item and item.is_deconstruction_item
  local upgrade = item and item.is_upgrade_item
  local action = deconstruct and (event.shift and defines.input_action.cancel_deconstruct or defines.input_action.deconstruct)
    or upgrade and (event.shift and defines.input_action.cancel_upgrade or defines.input_action.upgrade)
    or defines.input_action.build
  if player.permission_group and not player.permission_group.allows_action(action) then return end

  if deconstruct or upgrade then
    local state = player_state(player.index)
    local start = position
    if event.control then
      if not state.area_order or state.area_order.id ~= id or state.area_order.tool ~= item.name then
        state.area_order = {id=id, tool=item.name, position=position}
        player.print({"live-pin-cameras.area-started"})
        return
      end
      start = state.area_order.position
    end
    state.area_order = nil
    -- Use the planner itself so filters, tile selection and normal robot rules apply.
    local args = {
      area = {{math.min(start.x,position.x) - 0.01, math.min(start.y,position.y) - 0.01},
        {math.max(start.x,position.x) + 0.01, math.max(start.y,position.y) + 0.01}},
      force = player.force, player = player, item = item, skip_fog_of_war = true
    }
    if upgrade then
      if event.shift then surface.cancel_upgrade_area(args) else surface.upgrade_area(args) end
    elseif event.shift then surface.cancel_deconstruct_area(args)
    else surface.deconstruct_area(args) end
  else
    local temporary
    local ok, err = pcall(function()
      if not blueprint then
        local ghost = not item and player.cursor_ghost or nil
        local prototype = item and item.prototype or ghost and ghost.name
        local entity = prototype and prototype.place_result
        local tile = prototype and prototype.place_as_tile_result
        if not (entity or tile) then
          player.print({"live-pin-cameras.unsupported-tool"})
          return
        end
        -- Never swap/consume the player's cursor stack or temporarily change controller.
        -- A one-item blueprint lets the engine handle ghost collision, grid and undo rules.
        temporary = game.create_inventory(1)
        blueprint = temporary[1]
        blueprint.set_stack{name = "blueprint", count = 1}
        if entity then
          blueprint.set_blueprint_entities{{entity_number = 1, name = entity.name,
            position = {0, 0}, quality = item and item.quality.name or (ghost.quality and ghost.quality.name or "normal")}}
        else
          blueprint.set_blueprint_tiles{{name = tile.result.name, position = {0, 0}}}
        end
      end
      if blueprint.is_blueprint_setup() then
        local built = blueprint.build_blueprint{
          surface = surface, force = player.force, by_player = player,
          position = position, direction = player_state(player.index).cursor_direction or defines.direction.north,
          build_mode = event.shift and defines.build_mode.forced or defines.build_mode.normal,
          skip_fog_of_war = true
        }
        if #built == 0 then player.print({"live-pin-cameras.placement-blocked"}) end
      end
    end)
    if temporary then temporary.destroy() end
    if not ok then
      log("Live Pin Cameras construction failed: " .. tostring(err))
      player.print({"live-pin-cameras.build-failed"})
    end
  end
  window.tooltip_dirty = true
end

local function interact_with_camera(player, id, display_location)
  if has_cursor_tool(player) then return end
  if player_state(player.index).windows[id].read_only then return end
  local entity = find_entity_at(player, id, display_location)
  if not entity then
    return
  end
  player.selected = entity
  if not open_camera_entity(player, entity) then
    check_opened_camera(player)
    player.print({"live-pin-cameras.remote-failed"})
  end
end

local function initialize_player(player)
  player_state(player.index)
  player.set_shortcut_available(SHORTCUT_NAME, true)
end

local function rebuild_player(player)
  end_camera_hover(player)
  check_opened_camera(player)
  initialize_player(player)
  local state = player_state(player.index)
  state.pan = nil
  state.area_order = nil
  for id, window in pairs(state.windows) do
    if window.entity and not window.entity.valid then
      window.entity = nil
    end
    window.preview_distance = clamp(window.preview_distance or DEFAULT_DISTANCE, MIN_DISTANCE, MAX_DISTANCE)
    window.camera_width = normalize_camera_width(window.camera_width or DEFAULT_CAMERA_WIDTH)
    window.offset = window.offset or {x = 0, y = 0}
    if window.surface_index and game.surfaces[window.surface_index] then
      build_window(player, id, window)
    else
      state.windows[id] = nil
    end
  end
end

script.on_init(function()
  ensure_storage()
  for _, player in pairs(game.players) do
    initialize_player(player)
  end
end)

script.on_configuration_changed(function()
  ensure_storage()
  for _, player in pairs(game.players) do
    rebuild_player(player)
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  initialize_player(game.get_player(event.player_index))
end)

script.on_event(defines.events.on_player_removed, function(event)
  local root = ensure_storage()
  root.players[event.player_index] = nil
end)

script.on_event(defines.events.on_pre_player_left_game, function(event)
  local player = game.get_player(event.player_index)
  end_camera_hover(player)
  player_state(player.index).pan = nil
  player_state(player.index).area_order = nil
end)

script.on_event(defines.events.on_player_joined_game, function(event)
  local player = game.get_player(event.player_index)
  end_camera_hover(player)
  player_state(player.index).pan = nil
  player_state(player.index).area_order = nil
end)

script.on_event({
  defines.events.on_player_changed_position,
  defines.events.on_player_changed_surface,
  defines.events.on_player_controller_changed
}, function(event)
  check_opened_camera(game.get_player(event.player_index))
end)

script.on_event(defines.events.on_lua_shortcut, function(event)
  if event.prototype_name ~= SHORTCUT_NAME then
    return
  end
  local player = game.get_player(event.player_index)
  open_window(player, {
    surface_index = player.surface.index,
    position = player.position,
    preview_distance = DEFAULT_DISTANCE
  })
end)

script.on_event(INPUT_NAME, function(event)
  local player = game.get_player(event.player_index)
  if event.in_gui then
    return
  end

  local target = {
    entity = nil,
    surface_index = player.surface.index,
    position = copy_position(event.cursor_position),
    preview_distance = DEFAULT_DISTANCE
  }

  local selected = player.selected
  if selected and selected.valid then
    target.entity = selected
    target.surface_index = selected.surface.index
    target.position = copy_position(selected.position)
  end

  open_window(player, target)
end)

script.on_event(PAN_INPUT_NAME, function(event)
  local element = event.element
  local id = event.in_gui and camera_element_id(element) or nil
  if not id then
    return
  end

  local player = game.get_player(event.player_index)
  local state = player_state(event.player_index)
  state.area_order = nil
  end_camera_hover(player)
  if not (state.pan and state.pan.id == id) then
    begin_pan(player, id, event.cursor_display_location, element)
  end
end)

script.on_event(INTERACT_INPUT_NAME, function(event)
  local id = event.in_gui and camera_element_id(event.element) or nil
  if id then
    local state = player_state(event.player_index)
    state.pan = nil
    state.cursor_direction = event.cursor_direction
    interact_with_camera(game.get_player(event.player_index), id, event.cursor_display_location)
  end
end)

script.on_event("live-pin-cameras-manage", function(event)
  local player = game.get_player(event.player_index)
  local manager = player.gui.screen[MANAGER_NAME]
  if manager then manager.destroy() else show_manager(player) end
end)

script.on_event(defines.events.on_gui_closed, function(event)
  if event.element and event.element.valid and event.element.name == MANAGER_NAME then event.element.destroy() end
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
  player_state(event.player_index).area_order = nil
end)

script.on_event(defines.events.on_gui_checked_state_changed, function(event)
  local element = event.element
  if element.tags.live_pin_cameras_action ~= "read-only" then return end
  local player = game.get_player(event.player_index)
  local state = player_state(player.index)
  local window = state.windows[element.tags.live_pin_cameras_id]
  if window then window.read_only = element.state end
  state.area_order = nil
  if state.opened_from_camera and player.opened == state.opened_from_camera then player.opened = nil end
  state.opened_from_camera = nil
end)

script.on_event({defines.events.on_player_display_resolution_changed, defines.events.on_player_display_scale_changed}, function(event)
  rebuild_player(game.get_player(event.player_index))
end)

script.on_event(defines.events.on_pre_surface_deleted, function(event)
  for index, state in pairs(ensure_storage().players) do
    local player = game.get_player(index)
    if player then
      local remove = {}
      for id, window in pairs(state.windows) do
        if window.surface_index == event.surface_index then remove[#remove+1] = id end
      end
      for _, id in ipairs(remove) do close_window(player, id) end
      if player.gui.screen[MANAGER_NAME] then show_manager(player) end
    end
  end
end)

local function handle_wheel_zoom(event, zoom_in)
  local element = event.element
  local id = event.in_gui and camera_element_id(element) or nil
  local player = game.get_player(event.player_index)
  if not id then
    if not event.in_gui then
      player.zoom = player.zoom * (zoom_in and WORLD_ZOOM_FACTOR or (1 / WORLD_ZOOM_FACTOR))
    end
    return
  end

  local before = display_to_world(player, id, event.cursor_display_location)
  wheel_zoom(player, id, zoom_in)
  local after = display_to_world(player, id, event.cursor_display_location)
  local window = player_state(player.index).windows[id]
  if before and after and window then
    set_camera_offset(player, id, {x=window.offset.x+before.x-after.x, y=window.offset.y+before.y-after.y})
  end
  player_state(event.player_index).pan = nil
  player_state(event.player_index).area_order = nil
end

script.on_event(ZOOM_IN_INPUT_NAME, function(event)
  handle_wheel_zoom(event, true)
end)

script.on_event(ZOOM_OUT_INPUT_NAME, function(event)
  handle_wheel_zoom(event, false)
end)

script.on_event(defines.events.on_gui_click, function(event)
  local element = event.element
  if not (element and element.valid) then
    return
  end
  local action = element.tags.live_pin_cameras_action
  local player = game.get_player(event.player_index)
  local id = element.tags.live_pin_cameras_id
  if action == "camera" then
    if event.button == defines.mouse_button_type.left then
      camera_construction(player, id, event)
    elseif event.button == defines.mouse_button_type.right then
      local was_panning = finish_pan(player, id, event.cursor_display_location)
      local window = player_state(player.index).windows[id]
      if not was_panning and not event.shift and window and not window.read_only and not has_cursor_tool(player) then
        local entity = find_entity_at(player, id, event.cursor_display_location)
        if entity and (not player.permission_group or player.permission_group.allows_action(defines.input_action.deconstruct)) then
          -- Camera removal is a robot order, never instant remote mining.
          local position = entity.position
          entity.surface.deconstruct_area{area={{position.x-0.01,position.y-0.01},{position.x+0.01,position.y+0.01}},
            force=player.force, player=player, skip_fog_of_war=true}
          window.tooltip_dirty = true
        end
      end
    end
  elseif action == "close" then
    hide_window(player, id, true)
    if player.gui.screen[MANAGER_NAME] then show_manager(player) end
  elseif action == "reset-pan" then
    set_camera_offset(player, id, {x = 0, y = 0})
  elseif action == "info" then
    show_manager(player)
  elseif action == "manager-close" then
    player.gui.screen[MANAGER_NAME].destroy()
  elseif action == "show" or action == "hide" then
    hide_window(player, id, action == "hide")
    show_manager(player)
  elseif action == "delete" then
    close_window(player, id)
    show_manager(player)
  elseif action == "show-all" or action == "hide-all" then
    for camera_id in pairs(player_state(player.index).windows) do hide_window(player, camera_id, action == "hide-all") end
    show_manager(player)
  elseif action == "remote-view" then
    local window = player_state(player.index).windows[id]
    if window and (not player.permission_group or player.permission_group.allows_action(defines.input_action.remote_view_surface)) then
      end_camera_hover(player)
      local ok = pcall(function()
        player.set_controller{type=defines.controllers.remote, surface=window.surface_index, position=camera_center(window)}
      end)
      if ok then player.gui.screen[MANAGER_NAME].destroy()
      else player.print({"live-pin-cameras.remote-failed"}) end
    end
  end
end)

script.on_event(defines.events.on_gui_hover, function(event)
  local element = event.element
  local id = camera_element_id(element)
  if not id then
    local state = player_state(event.player_index)
    state.pan = nil
    state.pan_leave_tick = nil
    return
  end
  local player = game.get_player(event.player_index)
  local display_location = camera_element_center(player, element)
  if not display_location then
    return
  end
  local state = player_state(event.player_index)
  state.pan_leave_tick = nil
  if state.pan and state.pan.id == id then
    update_pan(player, id, display_location, false)
    end_camera_hover(player)
  else
    local window = state.windows[id]
    local index = element.tags.live_pin_cameras_cell_index
    local entity = window and find_entity_at(player, id, display_location, element.tags.live_pin_cameras_cell_size)
    show_native_details(player, id, index, entity)
  end
end)

script.on_event(defines.events.on_gui_value_changed, function(event)
  local element = event.element
  if not (element and element.valid) then
    return
  end
  local action = element.tags.live_pin_cameras_action
  if action == "distance" then
    set_distance(game.get_player(event.player_index), element.tags.live_pin_cameras_id, element.slider_value)
  elseif action == "size" then
    schedule_camera_width(game.get_player(event.player_index), element.tags.live_pin_cameras_id, element.slider_value)
  end
end)

script.on_event(defines.events.on_gui_text_changed, function(event)
  local element = event.element
  if not (element and element.valid) then
    return
  end
  local value = tonumber(element.text)
  local action = element.tags.live_pin_cameras_action
  if action == "rename" then
    local player = game.get_player(event.player_index)
    local id = element.tags.live_pin_cameras_id
    local window = player_state(player.index).windows[id]
    if window then
      window.label = element.text:sub(1, 80)
      local frame = player.gui.screen[window_name(id)]
      if frame then frame.children[1].children[1].caption = short_window_title(window) end
    end
    return
  end
  if value and action == "distance-text" then
    set_distance(game.get_player(event.player_index), element.tags.live_pin_cameras_id, value)
  elseif value and action == "size-text" then
    schedule_camera_width(game.get_player(event.player_index), element.tags.live_pin_cameras_id, value)
  end
end)

script.on_event(defines.events.on_gui_confirmed, function(event)
  local element = event.element
  if element and element.valid and element.tags.live_pin_cameras_action == "size-text" then
    commit_camera_width(game.get_player(event.player_index), element.tags.live_pin_cameras_id)
  end
end)

script.on_event(defines.events.on_gui_leave, function(event)
  local element = event.element
  if not (element and element.valid) then
    return
  end
  local action = element.tags.live_pin_cameras_action
  if action == "camera" then
    local player = game.get_player(event.player_index)
    local state = player_state(event.player_index)
    local window = state.windows[element.tags.live_pin_cameras_id]
    local tags = element.tags
    local half = (tags.live_pin_cameras_cell_size or OVERLAY_CELL_SIZE) / 2
    -- Leaving an interior input cell is normal while dragging, not leaving the
    -- camera. A later hover cancels the boundary grace period when moving inward.
    if window and (tags.live_pin_cameras_cell_x <= half or tags.live_pin_cameras_cell_y <= half
      or tags.live_pin_cameras_cell_x + half >= window.camera_width
      or tags.live_pin_cameras_cell_y + half >= camera_height(window.camera_width)) then
      state.pan_leave_tick = game.tick
    end
    end_camera_hover(player)
  end
  if action == "size" or action == "size-text" then
    commit_camera_width(game.get_player(event.player_index), element.tags.live_pin_cameras_id)
  end
end)

script.on_event(defines.events.on_gui_location_changed, function(event)
  local element = event.element
  if not (element and element.valid) then
    return
  end
  if element.name:sub(1, #WINDOW_PREFIX) ~= WINDOW_PREFIX then
    return
  end
  local id = element.tags.live_pin_cameras_id
  local window = player_state(event.player_index).windows[id]
  if window then
    clamp_location(game.get_player(event.player_index), element, window)
    sync_pan_overlay(game.get_player(event.player_index), id, window, true)
  end
end)

script.on_event(defines.events.on_tick, function()
  local root = ensure_storage()
  for player_index, state in pairs(root.players) do
    local player = game.get_player(player_index)
    if player and player.valid and player.connected then
      check_opened_camera(player)
      if state.hover then
        local frame = player.gui.screen[window_name(state.hover.id)]
        if not (frame and frame.valid) then
          end_camera_hover(player)
        elseif state.hover.entity and not state.hover.entity.valid then
          player.selected = nil
          state.hover.entity = nil
        end
      end
      if state.pan_leave_tick and game.tick > state.pan_leave_tick + 3 then
        state.pan = nil
        state.pan_leave_tick = nil
      end
      if state.pan and game.tick - state.pan.tick > 600 then
        state.pan = nil
      end
      for id, window in pairs(state.windows) do
        if not window.hidden then
        if state.hover and state.hover.id == id and game.tick % 15 == 0 then window.tooltip_dirty = true end
        if window.tooltip_dirty and not (state.pan and state.pan.id == id) then
          refresh_overlay_tooltips(player, id)
        end
        if window.pending_camera_width
          and game.tick - (window.pending_camera_width_tick or game.tick) >= SIZE_COMMIT_DELAY then
          set_camera_width(player, id, window.pending_camera_width)
        end
        if window.entity then
          if window.entity.valid then
            local position = window.entity.position
            local surface_index = window.entity.surface.index
            if position.x ~= window.position.x or position.y ~= window.position.y or surface_index ~= window.surface_index then
              window.position = copy_position(position)
              window.surface_index = surface_index
              window.tooltip_dirty = true
              local frame = player.gui.screen[window_name(id)]
              local camera = frame and frame[camera_name(id)]
              if camera then apply_camera_target(camera, window) end
            end
          else
            window.entity = nil
            local frame = player.gui.screen[window_name(id)]
            local camera = frame and frame[camera_name(id)]
            if camera and camera.valid then
              camera.entity = nil
              camera.surface_index = window.surface_index
              camera.position = camera_center(window)
            end
          end
        end
        end
      end
    end
  end
end)

remote.add_interface(REMOTE_NAME, {
  find_entity_at_display = function(player_index, id, display_location)
    local player = game.get_player(player_index)
    if not player then
      error("Invalid player index: " .. tostring(player_index))
    end
    if not player_state(player_index).windows[id] then
      error("Invalid live camera ID: " .. tostring(id))
    end
    return find_entity_at(player, id, display_location)
  end,
  open_at = function(player_index, surface_index, position, preview_distance)
    local player = game.get_player(player_index)
    if not player then
      error("Invalid player index: " .. tostring(player_index))
    end
    local surface = game.surfaces[surface_index]
    if not surface then
      error("Invalid surface index: " .. tostring(surface_index))
    end
    return open_window(player, {
      surface_index = surface.index,
      position = position,
      preview_distance = preview_distance or DEFAULT_DISTANCE
    })
  end,
  open_entity = function(player_index, entity, preview_distance)
    local player = game.get_player(player_index)
    if not player then
      error("Invalid player index: " .. tostring(player_index))
    end
    if not (entity and entity.valid) then
      error("A valid entity is required")
    end
    return open_window(player, {
      entity = entity,
      surface_index = entity.surface.index,
      position = entity.position,
      preview_distance = preview_distance or DEFAULT_DISTANCE
    })
  end,
  close_all = function(player_index)
    local player = game.get_player(player_index)
    if not player then
      error("Invalid player index: " .. tostring(player_index))
    end
    local state = player_state(player_index)
    local ids = {}
    for id in pairs(state.windows) do
      ids[#ids + 1] = id
    end
    for _, id in pairs(ids) do
      close_window(player, id)
    end
  end,
  set_preview_distance = function(player_index, id, preview_distance)
    local player = game.get_player(player_index)
    if not player then
      error("Invalid player index: " .. tostring(player_index))
    end
    local state = player_state(player_index)
    if not state.windows[id] then
      error("Invalid live camera ID: " .. tostring(id))
    end
    set_distance(player, id, preview_distance)
  end,
  set_window_width = function(player_index, id, camera_width)
    local player = game.get_player(player_index)
    if not player then
      error("Invalid player index: " .. tostring(player_index))
    end
    local state = player_state(player_index)
    if not state.windows[id] then
      error("Invalid live camera ID: " .. tostring(id))
    end
    set_camera_width(player, id, camera_width)
  end,
  set_camera_offset = function(player_index, id, offset)
    local player = game.get_player(player_index)
    if not player then
      error("Invalid player index: " .. tostring(player_index))
    end
    local state = player_state(player_index)
    if not state.windows[id] then
      error("Invalid live camera ID: " .. tostring(id))
    end
    set_camera_offset(player, id, offset)
  end
})
