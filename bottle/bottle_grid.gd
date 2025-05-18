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
      cell_grid_columns[x].append(BottleCell.create(cell_grid_columns, tl_tile, tile_offset))
      

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

func get_cell(tile_pos: Vector2i) -> BottleCell:
  for col in cell_grid_columns:
    for cell: BottleCell in col:
      if cell.has_tile(tile_pos):
        print(cell)
        var neighbors = cell.get_neighbors()
        print(neighbors)
        return cell
  return null
