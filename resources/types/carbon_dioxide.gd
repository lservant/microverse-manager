extends Rsrc
class_name CarbonDioxide

const RSRC_TYPE = RsrcPool.RsrcType.CARBON_DIOXIDE

static func update(cell: BottleCell) -> void:
  move(cell)

static func move(cell: BottleCell) -> void:
  var minimum = 30
  var maximum = cell.RESOURCE_LIMIT / 2
  var rsrc = cell.resources.get_resource(RSRC_TYPE)
  if rsrc.amount <= minimum:
    return

  if rsrc.amount >= maximum:
    cell.lift_resource(RSRC_TYPE)
  if rsrc.amount > minimum:
    cell.drop_resource(RSRC_TYPE)
  if rsrc.amount > minimum:
    cell.spill_resource(RSRC_TYPE)
