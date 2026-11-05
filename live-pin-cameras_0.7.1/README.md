# Live Pin Cameras

This Factorio 2.0 mod adds independent persistent live camera windows.

## Use

1. Press **Ctrl+Shift+C** over an entity or world position to create a camera.
2. Change **Create live camera** in Controls > Mods to use a different key.
3. The shortcut-bar button opens a camera at the player. Cameras are independent
   of native bookmarks; there is no mode toggle to enable first.
4. Drag a window by its title bar. Scroll over its live view to zoom without
   also zooming the main viewport, or adjust **Zoom** on the control row.
   **Size** is applied when you finish adjusting it so the window stays stable.
5. Hold and drag with **Pan a live camera view** (**Shift+right mouse** by default and
   rebindable under Controls) to pan with live visual updates. Use the reset
   button beside X to return to the pinned target.
6. Hover entities to select them for Factorio's native entity information panel.
   Empty-hand left click opens the machine. Reachable machines use direct access;
   distant or cross-surface machines switch the main viewport to native remote
   view before opening, so Factorio supplies its normal logistics-only inventory
   behavior. Remote view stays active until you leave it using the game's controls.
   The mod never switches back to character mode while a distant inventory is open.
   Walking away from a directly opened inventory closes it; click again to inspect remotely.
   X hides the camera without deleting it; restore it from the camera list.
7. Hold a placeable item, cursor ghost or configured blueprint and left click in
   the camera to place **construction ghosts**, even on another surface. Items
   are not consumed; robots still need materials and coverage to build them.
   Shift-click uses forced blueprint placement (clears obstructing nature).
8. Hold a **deconstruction planner** and left click a target to mark it for
   robot removal. Shift-click cancels the order. Planner filters are respected.
   This never instantly destroys buildings or remotely takes their contents.
   Empty-hand right click also requests robot deconstruction of the target.
9. **Upgrade planners** work the same way. For an area deconstruction/upgrade,
   **Ctrl-click two opposite corners** with the planner. Add Shift on the second
   click to cancel orders instead. Changing tools, panning or zooming cancels
   an unfinished selection. This is a two-click selection, not native dragging.
10. **Ctrl+Shift+L**, or click **i**, opens the camera list. Rename views, hide/show
    individual or all cameras, delete saved cameras, enable **View only** to
    block building and inventory interaction, or open the target in native
    **Remote view** for the game's complete construction UI.

Wheel zoom keeps the world point beneath the cursor fixed. Window positions are
clamped on movement, resize and display-scale changes. Cameras on deleted
surfaces are removed. Hidden cameras retain their names, target, size and zoom.

Hover the **i** button for instructions. Empty camera space has no tooltip.
Existing camera windows are retained on upgrade. Existing native bookmarks
are left in place; new cameras create none.

## Factorio 2.0 API limitation

Factorio 2.0.77 GUI hover events report elements, not continuous cursor
coordinates. Panning therefore samples 16–32-GUI-pixel cells and still has visible
steps. Hover selects the entity overlapping that cell; at far zoom,
several small entities may share one cell. Clicks use exact cursor coordinates.
The native panel uses the game's tooltip positioning settings; it is not an
embedded tooltip window within the camera. The temporary selection settings
are restored when leaving the camera.

The pan input has a new identifier in 0.7.1 so an old saved unmodified-right-mouse
binding cannot override the requested Shift+right-mouse default. Rebind the new
control in Controls > Mods if desired. GUI dragging still uses coarse hover
events, not continuous native pointer samples; release outside the camera or
leave its boundary cancels the pan. Full native radar interaction is provided
by entering Remote view, not by replacing the GUI camera with a world viewport.

Construction is click-by-click, including single tiles; there is no area-drag,
drag-building or native placement preview inside the GUI camera. Item-backed
blueprint books use their active page; direct library blueprint records work.
Other library records and specialized tools need the main
remote view. Building through cameras always requests ghosts, even nearby.

## Performance and limits

The per-player saved-camera limit defaults to 12 (configurable from 1–32 in
Mod settings). Hidden views count toward the limit but have no camera/input GUI.
Existing views survive lowering the limit. More visible views still cost GPU
rendering time; hide unused views if FPS drops.

Input grids are capped at 1,024 cells per view (600 at maximum 960px width).
Hover queries only the cell beneath the pointer, refreshing it four times per
second while stationary. There are no full-factory hover-map scans. Unchanged
tracked targets no longer cause camera GUI writes every tick; disconnected
players and hidden views skip updates.

The camera GUI cannot reproduce continuous native cursor movement, placement
previews, drag-building, rail planning, or all blueprint-library tools. Use the
list's Remote view button for those. Mouse-wheel interception uses a global
custom input with world-zoom emulation outside GUIs; specialized world-wheel
bindings from other mods may conflict.

## Remote interface

For compatibility with other mods and test automation:

```lua
remote.call("live_pin_cameras", "find_entity_at_display", player_index, camera_id, {x = 960, y = 540})
remote.call("live_pin_cameras", "open_at", player_index, surface_index, {x = 0, y = 0}, 16)
remote.call("live_pin_cameras", "open_entity", player_index, entity, 16)
remote.call("live_pin_cameras", "set_preview_distance", player_index, camera_id, 32)
remote.call("live_pin_cameras", "set_window_width", player_index, camera_id, 640)
remote.call("live_pin_cameras", "set_camera_offset", player_index, camera_id, {x = 5, y = -3})
remote.call("live_pin_cameras", "close_all", player_index)
```
