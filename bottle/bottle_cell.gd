extends Resource
class_name BottleCell

signal tile_requested_update(tile_pos: Vector2i, resource: ResourcePool.ResourceType)

var resources: ResourcePool = ResourcePool.new()

## Moves the given amount of resource from this cell to the destination cell.
func move_resource(resource_type: ResourcePool.ResourceType, amount: int, destination_cell: BottleCell) -> void:
  if amount <= 0:
    return
  if resources.remove_resource(resource_type, amount):
    destination_cell.resources.add_resource(resource_type, amount)

func move_water() -> void:
  var water = resources.get_resource(ResourcePool.ResourceType.WATER)
  if water.amount == 0:
    return
  var water_dropped = false
  if not is_bottom():
    water_dropped = drop_water()
  if water.amount <= 12 or water_dropped:
    return
  spill_water()

const MAX_WATER: int = 100
func spill_water() -> void:
  var water = resources.get_resource(ResourcePool.ResourceType.WATER)

  if neighbors.left != null and neighbors.right != null:
    var left_water = neighbors.left.resources.get_resource(ResourcePool.ResourceType.WATER)
    var right_water = neighbors.right.resources.get_resource(ResourcePool.ResourceType.WATER)
    var total: int = left_water.amount + right_water.amount + water.amount
    var avg: int = total / 3
    if left_water.amount < MAX_WATER and left_water.amount < avg:
      var amount_to_move = avg - left_water.amount
      if amount_to_move <= water.amount:
        move_resource(ResourcePool.ResourceType.WATER, amount_to_move, neighbors.left)
    if right_water.amount < MAX_WATER and right_water.amount < avg:
      var amount_to_move = avg - right_water.amount
      if amount_to_move <= water.amount:
        move_resource(ResourcePool.ResourceType.WATER, amount_to_move, neighbors.right)
  elif neighbors.left != null:
    var left_water = neighbors.left.resources.get_resource(ResourcePool.ResourceType.WATER)
    if left_water.amount < MAX_WATER && left_water.amount < water.amount:
      var total: int = left_water.amount + water.amount
      var amount_to_move = total / 2 - left_water.amount
      if amount_to_move <= water.amount:
        move_resource(ResourcePool.ResourceType.WATER, amount_to_move, neighbors.left)
  elif neighbors.right != null:
    var right_water = neighbors.right.resources.get_resource(ResourcePool.ResourceType.WATER)
    if right_water.amount < MAX_WATER && right_water.amount < water.amount:
      var total: int = right_water.amount + water.amount
      var amount_to_move = total / 2 - right_water.amount
      if amount_to_move <= water.amount:
        move_resource(ResourcePool.ResourceType.WATER, amount_to_move, neighbors.right)

func drop_water()-> bool:
  var water = resources.get_resource(ResourcePool.ResourceType.WATER)
  var bottom_water = neighbors.bottom.resources.get_resource(ResourcePool.ResourceType.WATER)
  if bottom_water.amount >= MAX_WATER:
    return false
  var amount_to_move = MAX_WATER - bottom_water.amount
  if amount_to_move > water.amount:
    amount_to_move = water.amount
  move_resource(ResourcePool.ResourceType.WATER, amount_to_move, neighbors.bottom)
  return true

func update_resources() -> void:
  move_water()

var _bottle_grid: Array[Array]
var _bottle_grid_size:
  get:
    return Vector2i(_bottle_grid.size(), _bottle_grid[0].size())

var cell_coords: Vector2i = Vector2(-1, -1)
var coords:
  get:
    return cell_coords
  set(value):
    cell_coords = value
func is_top() -> bool:
  return cell_coords.y <= 0
func is_bottom() -> bool:
  return cell_coords.y >= _bottle_grid_size.y - 1
func is_left() -> bool:
  return cell_coords.x <= 0
func is_right() -> bool:
  return cell_coords.x >= _bottle_grid_size.x - 1

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

## Check the resources in the cell and fire events for tiles that need updating
func update_tiles() -> void:
  update_resources()
  var water = resources.get_resource(ResourcePool.ResourceType.WATER)
  if water.amount <= 0:
    tile_requested_update.emit(_tiles.bottom_left, ResourcePool.ResourceType.VACCUUM)
    tile_requested_update.emit(_tiles.bottom_right, ResourcePool.ResourceType.VACCUUM)
  if water.amount > 0:
    tile_requested_update.emit(_tiles.bottom_left, ResourcePool.ResourceType.WATER)
    tile_requested_update.emit(_tiles.bottom_right, ResourcePool.ResourceType.WATER)
  if water.amount <= 50:
    tile_requested_update.emit(_tiles.top_left, ResourcePool.ResourceType.VACCUUM)
    tile_requested_update.emit(_tiles.top_right, ResourcePool.ResourceType.VACCUUM)
  if water.amount >= 75:
    tile_requested_update.emit(_tiles.top_left, ResourcePool.ResourceType.WATER)
    tile_requested_update.emit(_tiles.top_right, ResourcePool.ResourceType.WATER)

var _neighbors: Neighbors = Neighbors.new()
var neighbors:
  get:
    return get_neighbors()
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
      _neighbors.top = _bottle_grid[cell_coords.x][cell_coords.y - 1]
    if not is_top() and not is_right():
      _neighbors.top_right = _bottle_grid[cell_coords.x + 1][cell_coords.y - 1]
    if not is_right():
      _neighbors.right = _bottle_grid[cell_coords.x + 1][cell_coords.y]
    if not is_bottom() and not is_right():
      _neighbors.bottom_right = _bottle_grid[cell_coords.x + 1][cell_coords.y + 1]
    if not is_bottom():
      _neighbors.bottom = _bottle_grid[cell_coords.x][cell_coords.y + 1]
    if not is_bottom() and not is_left():
      _neighbors.bottom_left = _bottle_grid[cell_coords.x - 1][cell_coords.y + 1]
    if not is_left():
      _neighbors.left = _bottle_grid[cell_coords.x - 1][cell_coords.y]
    if not is_top() and not is_left():
      _neighbors.top_left = _bottle_grid[cell_coords.x - 1][cell_coords.y - 1]
  return _neighbors

func _to_string() -> String:
  return "BottleCell: " + str(cell_coords) + " Tiles: " + str(_tiles.top_left) + ", " + str(_tiles.top_right) + ", " + str(_tiles.bottom_left) + ", " + str(_tiles.bottom_right)

static func create(bottle_grid: Array[Array], tl_tile: Vector2i, tile_offset: Vector2i) -> BottleCell:
  var cell = BottleCell.new()
  cell._bottle_grid = bottle_grid
  
  cell._tiles.top_left = Vector2i(tl_tile.x, tl_tile.y) + tile_offset
  cell._tiles.top_right = Vector2i(tl_tile.x + 1, tl_tile.y) + tile_offset
  cell._tiles.bottom_left = Vector2i(tl_tile.x, tl_tile.y + 1) + tile_offset
  cell._tiles.bottom_right = Vector2i(tl_tile.x + 1, tl_tile.y + 1) + tile_offset
  cell.cell_coords = tl_tile / 2
  return cell