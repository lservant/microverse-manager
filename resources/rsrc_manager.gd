extends Node
class_name RsrcManager

signal resource_changed(resource_type: RsrcPool.RsrcType, previous_amount: int, new_amount: int)
signal tile_requested_update(tile_pos: Vector2i, resource: RsrcPool.RsrcType)

@export var resource_pool: RsrcPool
var tile_offset: Vector2i = Vector2(4, 3) # top left corner
var tile_grid_size: Vector2i = Vector2(48, 22)

var cell_size: Vector2i = Vector2(16, 16)
var cell_grid_size: Vector2i = tile_grid_size / 2 + Vector2i.ONE
var cell_grid_columns: Array[Array] = []

func _init() -> void:
  if resource_pool == null:
    resource_pool = RsrcPool.new()

func _ready() -> void:
  build_cell_grid()
  resource_pool.resource_changed.connect(_on_resource_changed)
  $Timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta: float) -> void:
  # Update cells every frame
  update_cells()
  
## Adds amount of given resource type to the _resources pool.
## If the resource type does not exist, it will be created.
func add_resource(resource_type: RsrcPool.RsrcType, amount: int) -> void:
  resource_pool.add_resource(resource_type, amount)

## Removes amount of given resource type from the _resources pool. Returning true if successful.
## If the resource type does not exist or the amount to remove is greater than the current amount, it will return false.
func remove_resource(resource_type: RsrcPool.RsrcType, amount: int) -> bool:
  return resource_pool.remove_resource(resource_type, amount)

## Empties the resource pool of the given resource type and returns the amount removed.
func empty_resource(resource_type: RsrcPool.RsrcType) -> int:
  return resource_pool.empty_resource(resource_type)

## Returns the amount of the given resource type in the resource pool.
func get_resource(resource_type: RsrcPool.RsrcType) -> int:
  return resource_pool.get_resource(resource_type).amount

## Returns current resources in the resource pool.
func get_resources() -> Array[RsrcInfo]:
  return resource_pool.resources

func _on_resource_changed(resource_type: RsrcPool.RsrcType, previous_amount: int, new_amount: int) -> void:
  resource_changed.emit(resource_type, previous_amount, new_amount)

func build_cell_grid() -> void:
  for x in range(cell_grid_size.x):
    cell_grid_columns.append([])
    for y in range(cell_grid_size.y):
      var tl_tile = Vector2i(x, y) * 2
      var cell = BottleCell.create(cell_grid_columns, tl_tile, tile_offset)
      debug_resources(cell)
      cell_grid_columns[x].append(cell)
      cell.tile_requested_update.connect(_on_tile_requested_update)

func debug_resources(cell):
  if cell.cell_coords.x < 10:
    cell.resources.set_resource(RsrcPool.RsrcType.WATER, 100)
    cell.resources.add_resource(RsrcPool.RsrcType.OXYGEN, 50)
    cell.resources.add_resource(RsrcPool.RsrcType.CARBON_DIOXIDE, 50)
  if cell.cell_coords.y == 5:
    cell.resources.set_resource(RsrcPool.RsrcType.NUTRIENTS, 75)
    cell.resources.set_resource(RsrcPool.RsrcType.ORGANICS, 50)

func get_cell(tile_pos: Vector2i) -> BottleCell:
  for col in cell_grid_columns:
    for cell: BottleCell in col:
      if cell.has_tile(tile_pos):
        return cell
  return null

func update_cells() -> void:
  for col in cell_grid_columns:
    for cell: BottleCell in col:
      cell.update_tiles()

func update_resources() -> void:
  for col in cell_grid_columns:
    for cell: BottleCell in col:
      cell.update_resources()

func _on_tile_requested_update(tile_pos: Vector2i, resource: RsrcPool.RsrcType) -> void:
  tile_requested_update.emit(tile_pos, resource)

func _on_timer_timeout() -> void:
  update_resources()