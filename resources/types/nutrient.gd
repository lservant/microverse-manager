extends Rsrc
class_name Nutrients

const RSRC_TYPE = RsrcPool.RsrcType.NUTRIENTS

static func move(cell: BottleCell) -> void:
  var nuts = cell.resources.get_resource(RsrcPool.RsrcType.NUTRIENTS)
  var water = cell.resources.get_resource(RsrcPool.RsrcType.WATER)
  if nuts.is_empty():
    return

  var was_lifted = false
  if water.amount >= cell.RESOURCE_LIMIT or \
  (not cell.is_top() and cell.neighbors.top.resources.get_resource(RsrcPool.RsrcType.WATER).amount > 0):
    was_lifted = cell.lift_resource(RsrcPool.RsrcType.NUTRIENTS)

  var was_dropped = false
  if water.is_empty():
    was_dropped = cell.drop_resource(RsrcPool.RsrcType.NUTRIENTS)
  
  cell.spill_resource(RsrcPool.RsrcType.NUTRIENTS)
