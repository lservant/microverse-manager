extends Rsrc
class_name Organics

const RSRC_TYPE = RsrcPool.RsrcType.ORGANICS

static func move(cell: BottleCell) -> void:
  var organics = cell.resources.get_resource(RsrcPool.RsrcType.ORGANICS)
  if organics.is_empty():
    return
  var was_dropped = cell.drop_resource(RsrcPool.RsrcType.ORGANICS)
  if organics.amount < 50:
    return
  cell.spill_resource(RsrcPool.RsrcType.ORGANICS)