extends Rsrc
class_name Water

const RSRC_TYPE = RsrcPool.RsrcType.WATER

static func update(cell: BottleCell) -> void:
  move(cell)

static func move(cell: BottleCell) -> void:
  var water = cell.resources.get_resource(RSRC_TYPE)
  if water.is_empty():
    return

  if water.amount > cell.RESOURCE_LIMIT or \
  (not cell.is_bottom() and cell.neighbors.bottom.resources.get_resource(RSRC_TYPE).amount >= cell.RESOURCE_LIMIT):
    cell.lift_resource(RsrcPool.RsrcType.WATER)
  
  cell.drop_resource(RsrcPool.RsrcType.WATER)
  if water.amount < 3:
    return
  cell.spill_resource(RsrcPool.RsrcType.WATER)