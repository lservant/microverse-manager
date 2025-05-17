extends TileMapLayer
class_name BottleGrid

@export var resource_manager: ResourceManager

var tile_offset: Vector2i = Vector2(4, 3) #top left corner
var tile_grid_size: Vector2i = Vector2(55, 23)

var cell_size: Vector2i = tile_set.tile_size * 2
var cell_grid_size: Vector2i = tile_grid_size / 2

var cell_grid_columns = []

func _ready() -> void:
  print(cell_size)
  print(cell_grid_size)
  # Initialize the cell grid with empty cells
  for x in range(cell_grid_size.x):
    cell_grid_columns.append([])
    for y in range(cell_grid_size.y):
      cell_grid_columns[x].append(null)

func _input(event):
  debug_mouseclick(event)

func debug_mouseclick(event: InputEvent) -> void:
  if event is not InputEventMouseButton:
    return
  if not event.is_pressed():
    return

  var cell_pos = local_to_map(event.position)
  if cell_pos != Vector2i(-1, -1):
    var tile = get_cell_atlas_coords(cell_pos)
    print("Tile at ", cell_pos.x, ", ", cell_pos.y, ": ", tile)
    get_cell(cell_pos)

func get_cell(tile_pos: Vector2i) -> Variant:
  var x = tile_pos.x / 2 - tile_offset.x / 2
  var y = tile_pos.y / 2 - tile_offset.y / 2
  if x < 0 \
  or x >= cell_grid_size.x \
  or y < 0 \
  or y >= cell_grid_size.y:
    return -1
  print("get_cell: ", x, ", ", y)
  return cell_grid_columns[x][y]
