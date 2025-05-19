extends TileMapLayer
class_name BottleGrid

@export var resource_manager: ResourceManager

var tile_offset: Vector2i = Vector2(4, 3) # top left corner
var tile_grid_size: Vector2i = Vector2(55, 23)

var cell_size: Vector2i = tile_set.tile_size * 2
var cell_grid_size: Vector2i = tile_grid_size / 2 + Vector2i.ONE

var cell_grid_columns: Array[Array] = []

func _ready() -> void:
  build_cell_grid()

func build_cell_grid() -> void:
  print(cell_size)
  print(cell_grid_size)
  print(tile_grid_size)
  for x in range(cell_grid_size.x):
    cell_grid_columns.append([])
    for y in range(cell_grid_size.y):
      var tl_tile = Vector2i(x, y) * 2
      var cell = BottleCell.create(cell_grid_columns, tl_tile, tile_offset)
      debug_resources(cell)
      cell_grid_columns[x].append(cell)
      cell.tile_requested_update.connect(_on_tile_requested_update)

func debug_resources(cell):
  if cell.cell_coords.x != 1:
    return
  if cell.cell_coords.y < 5:
    cell.resources.set_resource(ResourcePool.ResourceType.WATER, 100)
  if cell.cell_coords.y == 5:
    cell.resources.set_resource(ResourcePool.ResourceType.WATER, 75)

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
    var cell = get_cell(tile_pos)

  # Trigger update_cells on right click (button_index 2 is right mouse button)
  # if event.button_index == MOUSE_BUTTON_RIGHT:
  #   update_cells()

func get_cell(tile_pos: Vector2i) -> BottleCell:
  for col in cell_grid_columns:
    for cell: BottleCell in col:
      if cell.has_tile(tile_pos):
        print(cell.resources.get_resource(ResourcePool.ResourceType.WATER).amount)
        return cell
  return null

func update_cells() -> void:
  for col in cell_grid_columns:
      for cell: BottleCell in col:
          cell.update_tiles()

func _on_tile_requested_update(tile_pos: Vector2i, resource: ResourcePool.ResourceType) -> void:
  var atlas_coords = {
    ResourcePool.ResourceType.WATER: Vector2i(0, 0),
    ResourcePool.ResourceType.VACCUUM: Vector2i(-1, -1),
  }
  self.set_cell(tile_pos, tile_set.get_source_id(0), atlas_coords[resource])

func _on_sim_timer_timeout() -> void:
  print("tick")
  update_cells()
