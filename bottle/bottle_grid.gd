extends TileMapLayer
class_name BottleGrid

@export var resource_manager: RsrcManager

func _ready() -> void:
  # Connect the signal from the resource manager to this class
  resource_manager.tile_requested_update.connect(_on_tile_requested_update)

func _input(event):
  debug_mouseclick(event)

func debug_mouseclick(event: InputEvent) -> void:
  if event is not InputEventMouseButton:
    return
  if not event.is_pressed():
    return

  var tile_pos = local_to_map(event.position)
  if tile_pos != Vector2i(-1, -1):
    print("Tile:", tile_pos.x, ", ", tile_pos.y)
    var cell = resource_manager.get_cell(tile_pos)
    if cell == null:
      print("No cell found at tile position")
      return
    print(cell)
    print(cell.resources)

  # Trigger update_cells on right click (button_index 2 is right mouse button)
  if event.button_index == MOUSE_BUTTON_RIGHT:
    resource_manager.update_cells()

func _on_tile_requested_update(tile_pos: Vector2i, resource: RsrcPool.RsrcType) -> void:
  var atlas_coords = {
    RsrcPool.RsrcType.WATER: Vector2i(1, 0),
    RsrcPool.RsrcType.VACCUUM: Vector2i(0, 0),
    RsrcPool.RsrcType.NUTRIENTS: Vector2i(3, 0),
    RsrcPool.RsrcType.ORGANICS: Vector2i(4, 0),
    RsrcPool.RsrcType.OXYGEN: Vector2i(0, 1),
    RsrcPool.RsrcType.CARBON_DIOXIDE: Vector2i(1, 1),

  }
  self.set_cell(tile_pos, tile_set.get_source_id(0), atlas_coords[resource])
