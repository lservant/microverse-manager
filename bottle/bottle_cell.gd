extends Resource
class_name BottleCell

signal tile_requested_update(tile_pos: Vector2i, resource: ResourcePool.ResourceType)

var resources: ResourcePool = ResourcePool.new()
const RESOURCE_LIMIT: int = 100

func update_resources() -> void:
  move_water()
  move_nutrients()
  move_organics()

func move_water() -> void:
  var water = resources.get_resource(ResourcePool.ResourceType.WATER)
  if water.is_empty():
    return

  var was_lifted = false
  if water.amount > RESOURCE_LIMIT or \
  (not is_bottom() and neighbors.bottom.resources.get_resource(ResourcePool.ResourceType.WATER).amount >= RESOURCE_LIMIT):
    was_lifted = lift_resource(ResourcePool.ResourceType.WATER)
  
  var was_dropped = drop_resource(ResourcePool.ResourceType.WATER)
  if water.amount < 3:
    return
  spill_resource(ResourcePool.ResourceType.WATER)

func move_nutrients() -> void:
  var nuts = resources.get_resource(ResourcePool.ResourceType.NUTRIENTS)
  var water = resources.get_resource(ResourcePool.ResourceType.WATER)
  if nuts.is_empty():
    return

  var was_lifted = false
  if water.amount >= RESOURCE_LIMIT or \
  (not is_top() and neighbors.top.resources.get_resource(ResourcePool.ResourceType.WATER).amount > 0):
    was_lifted = lift_resource(ResourcePool.ResourceType.NUTRIENTS)

  var was_dropped = false
  if water.is_empty():
    was_dropped = drop_resource(ResourcePool.ResourceType.NUTRIENTS)
  
  spill_resource(ResourcePool.ResourceType.NUTRIENTS)

func move_organics() -> void:
  var organics = resources.get_resource(ResourcePool.ResourceType.ORGANICS)
  if organics.is_empty():
    return
  var was_dropped = drop_resource(ResourcePool.ResourceType.ORGANICS)
  if organics.amount < 50:
    return
  spill_resource(ResourcePool.ResourceType.ORGANICS)

func spill_resource(resource_type: ResourcePool.ResourceType) -> void:
  var rsrc = resources.get_resource(resource_type)
  if rsrc.is_empty():
    return
  if not is_left() and not is_right():
    var left_rsrc = neighbors.left.resources.get_resource(resource_type)
    var right_rsrc = neighbors.right.resources.get_resource(resource_type)
    var total: int = left_rsrc.amount + right_rsrc.amount + rsrc.amount
    var avg: int = total / 3
    
    if left_rsrc.amount < RESOURCE_LIMIT and left_rsrc.amount < avg:
      var amount_to_move = min(RESOURCE_LIMIT, avg - left_rsrc.amount)
      if amount_to_move <= rsrc.amount:
        move_resource(resource_type, amount_to_move, neighbors.left)
    if right_rsrc.amount < RESOURCE_LIMIT and right_rsrc.amount < avg:
      var amount_to_move = min(RESOURCE_LIMIT, avg - right_rsrc.amount)
      if amount_to_move <= rsrc.amount:
        move_resource(resource_type, amount_to_move, neighbors.right)

  elif not is_left():
    var left_rsrc = neighbors.left.resources.get_resource(resource_type)
    spill_one_side(left_rsrc, rsrc, neighbors.left)

  elif not is_right():
    var right_rsrc = neighbors.right.resources.get_resource(resource_type)
    spill_one_side(right_rsrc, rsrc, neighbors.right)

func spill_one_side(side_rsrc: ResourceInfo, rsrc: ResourceInfo, neighbor: BottleCell) -> void:
  if side_rsrc.amount < RESOURCE_LIMIT && side_rsrc.amount < rsrc.amount:
    var total: int = side_rsrc.amount + rsrc.amount
    var amount_to_move = min(RESOURCE_LIMIT, total / 2 - side_rsrc.amount)
    if amount_to_move <= rsrc.amount:
      move_resource(rsrc.resource_type, amount_to_move, neighbor)

func drop_resource(resource_type: ResourcePool.ResourceType) -> bool:
  if is_bottom():
    return false
  var rsrc = resources.get_resource(resource_type)
  var bottom_rsrc = neighbors.bottom.resources.get_resource(resource_type)
  if bottom_rsrc.amount >= RESOURCE_LIMIT:
    return false
  var amount_to_move = RESOURCE_LIMIT - bottom_rsrc.amount
  if amount_to_move > rsrc.amount:
    amount_to_move = rsrc.amount
  move_resource(resource_type, amount_to_move, neighbors.bottom)
  return true

func lift_resource(resource_type: ResourcePool.ResourceType) -> bool:
  if is_top():
    return false
  var rsrc = resources.get_resource(resource_type)
  if rsrc.is_empty():
    return false
  var top_rsrc = neighbors.top.resources.get_resource(resource_type)
  if top_rsrc.amount >= RESOURCE_LIMIT:
    return false
  var amount_to_move = min(rsrc.amount, RESOURCE_LIMIT - top_rsrc.amount)
  move_resource(resource_type, amount_to_move, neighbors.top)
  neighbors.top.update_tiles()
  return true

## Moves the given amount of resource from this cell to the destination cell.
func move_resource(resource_type: ResourcePool.ResourceType, amount: int, destination_cell: BottleCell) -> void:
  if amount <= 0:
    return
  if resources.remove_resource(resource_type, amount):
    destination_cell.resources.add_resource(resource_type, amount)

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
  var water = resources.get_resource(ResourcePool.ResourceType.WATER).amount
  var nutrients = resources.get_resource(ResourcePool.ResourceType.NUTRIENTS).amount
  var organics = resources.get_resource(ResourcePool.ResourceType.ORGANICS).amount
  var tiles = {
    "tl": ResourcePool.ResourceType.VACCUUM,
    "tr": ResourcePool.ResourceType.VACCUUM,
    "bl": ResourcePool.ResourceType.VACCUUM,
    "br": ResourcePool.ResourceType.VACCUUM
  }
  tiles["tl"] = ResourcePool.ResourceType.VACCUUM
  tiles["tr"] = ResourcePool.ResourceType.VACCUUM
  tiles["bl"] = ResourcePool.ResourceType.VACCUUM
  tiles["br"] = ResourcePool.ResourceType.VACCUUM
  if water > 0:
    tiles["bl"] = ResourcePool.ResourceType.WATER
    tiles["br"] = ResourcePool.ResourceType.WATER
  if water > RESOURCE_LIMIT / 2:
    tiles["tl"] = ResourcePool.ResourceType.WATER
    tiles["tr"] = ResourcePool.ResourceType.WATER
  if nutrients > 0:
    tiles["tl"] = ResourcePool.ResourceType.NUTRIENTS
    tiles["tr"] = ResourcePool.ResourceType.NUTRIENTS
  if organics > 0:
    tiles["bl"] = ResourcePool.ResourceType.ORGANICS
    tiles["br"] = ResourcePool.ResourceType.ORGANICS
  if water > RESOURCE_LIMIT:
    tiles["bl"] = ResourcePool.ResourceType.VACCUUM
    tiles["br"] = ResourcePool.ResourceType.VACCUUM
  tile_requested_update.emit(_tiles.top_left, tiles["tl"])
  tile_requested_update.emit(_tiles.top_right, tiles["tr"])
  tile_requested_update.emit(_tiles.bottom_left, tiles["bl"])
  tile_requested_update.emit(_tiles.bottom_right, tiles["br"])

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

func is_within_range(tl: Vector2i, br: Vector2i = tl) -> bool:
  return coords.x >= tl.x and \
         coords.x <= br.x and \
         coords.y >= tl.y and \
         coords.y <= br.y
