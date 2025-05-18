extends Resource
class_name BottleCell

var resources: ResourcePool = ResourcePool.new()

var _bottle_grid: Array = []
var cell_coords: Vector2i = Vector2(-1, -1)
func is_top() -> bool:
  return cell_coords.y == 0
func is_bottom() -> bool:
  return cell_coords.y == _bottle_grid.size() - 1
func is_left() -> bool:
  return cell_coords.x == 0
func is_right() -> bool:
  return cell_coords.x == _bottle_grid[cell_coords.y].size() - 1

var _tiles: TileCoords = TileCoords.new()
class TileCoords:
  var top_left: Vector2i = Vector2i(-1, -1)
  var top_right: Vector2i = Vector2i(-1, -1)
  var bottom_left: Vector2i = Vector2i(-1, -1)
  var bottom_right: Vector2i = Vector2i(-1, -1)

func has_tile(tile_pos: Vector2i) -> bool:
  return tile_pos == _tiles.top_left or \
  tile_pos == _tiles.top_right or \
  tile_pos == _tiles.bottom_left or \
  tile_pos == _tiles.bottom_right

var _neighbors: Neighbors = Neighbors.new()
class Neighbors:
  var top: BottleCell = null
  var top_right: BottleCell = null
  var right: BottleCell = null
  var bottom_right: BottleCell = null
  var bottom: BottleCell = null
  var bottom_left: BottleCell = null
  var left: BottleCell = null
  var top_left: BottleCell = null

  func is_empty() -> bool:
    return top == null and \
           top_right == null and \
           right == null and \
           bottom_right == null and \
           bottom == null and \
           bottom_left == null and \
           left == null and \
           top_left == null

  func _to_string() -> String:
    return """Neighbors:
  T:  %s
  TR: %s
  R:  %s
  BR: %s
  B:  %s
  BL: %s
  L:  %s
  TL: %s""" % [
    str(top),
    str(top_right),
    str(right),
    str(bottom_right),
    str(bottom),
    str(bottom_left),
    str(left),
    str(top_left)
  ]

func get_neighbors() -> Neighbors:
  if _neighbors.is_empty():
    if not is_top():
      _neighbors.top = _bottle_grid[cell_coords.y - 1][cell_coords.x]
    if not is_top() and not is_right():
      _neighbors.top_right = _bottle_grid[cell_coords.y - 1][cell_coords.x + 1]
    if not is_right():
      _neighbors.right = _bottle_grid[cell_coords.y][cell_coords.x + 1]
    if not is_bottom() and not is_right():
      _neighbors.bottom_right = _bottle_grid[cell_coords.y + 1][cell_coords.x + 1]
    if not is_bottom():
      _neighbors.bottom = _bottle_grid[cell_coords.y + 1][cell_coords.x]
    if not is_bottom() and not is_left():
      _neighbors.bottom_left = _bottle_grid[cell_coords.y + 1][cell_coords.x - 1]
    if not is_left():
      _neighbors.left = _bottle_grid[cell_coords.y][cell_coords.x - 1]
    if not is_top() and not is_left():
      _neighbors.top_left = _bottle_grid[cell_coords.y - 1][cell_coords.x - 1]
  return _neighbors

static func create(bottle_grid: Array, tl_tile: Vector2i, tile_offset: Vector2i) -> BottleCell:
  var cell = BottleCell.new()
  cell._bottle_grid = bottle_grid
  
  cell._tiles.top_left = Vector2i(tl_tile.x, tl_tile.y) + tile_offset
  cell._tiles.top_right = Vector2i(tl_tile.x + 1, tl_tile.y) + tile_offset
  cell._tiles.bottom_left = Vector2i(tl_tile.x, tl_tile.y + 1) + tile_offset
  cell._tiles.bottom_right = Vector2i(tl_tile.x + 1, tl_tile.y + 1) + tile_offset
  cell.cell_coords = tl_tile / 2
  return cell

func _to_string() -> String:
  return "BottleCell: " + str(cell_coords) + " Tiles: " + str(_tiles.top_left) + ", " + str(_tiles.top_right) + ", " + str(_tiles.bottom_left) + ", " + str(_tiles.bottom_right)