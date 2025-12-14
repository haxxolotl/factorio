local Informatron = {} -- informatron pages implementation.

function Informatron.menu(player_index)
  local player = game.players[player_index]
  local force = player.force
  local menu = {
    vehicles = 1,
    vehicle_ai = 1,
    unit_remote_controller = 1,
    path_remote_controller = 1,
    control_groups = 1,
    unit_identifiers = 1,
    unit_data = 1,
    inventory_transfer = 1,
    vehicle_depot = 1,
    vehicle_deployer = 1,
    position_beacon = 1,
  }
  return menu
end

function Informatron.page_content(page_name, player_index, element)
  local player = game.players[player_index]
  local force = player.force
  if page_name == "aai-programmable-vehicles" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_aai-programmable-vehicles_text_1"}}

  elseif page_name == "vehicle_ai" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_vehicle_ai_text_1"}}

  elseif page_name == "vehicles" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_vehicles_text_1"}}

  elseif page_name == "unit_remote_controller" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_unit_remote_controller_text_1"}}

  elseif page_name == "path_remote_controller" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_path_remote_controller_text_1"}}

  elseif page_name == "control_groups" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_control_groups_text_1"}}

  elseif page_name == "unit_identifiers" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_unit_identifiers_text_1"}}

  elseif page_name == "unit_data" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_unit_data_text_1"}}

  elseif page_name == "inventory_transfer" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_inventory_transfer_text_1"}}

    local image = element.add{type="button", name="image_1", style="programmable_vehicles_inventory_transfer_1"} -- image is the background
    image.style.top_margin = 10
    image.style.bottom_margin = 10

    element.add{type="label", name="text_2", caption={"aai-programmable-vehicles.page_inventory_transfer_text_2"}}

  elseif page_name == "vehicle_depot" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_vehicle_depot_text_1"}}

  elseif page_name == "vehicle_deployer" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_vehicle_deployer_text_1"}}

  elseif page_name == "position_beacon" then
    element.add{type="label", name="text_1", caption={"aai-programmable-vehicles.page_position_beacon_text_1"}}

  end

end

return Informatron
