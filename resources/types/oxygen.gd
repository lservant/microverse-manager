extends Rsrc
class_name Oxygen

const RSRC_TYPE = RsrcPool.RsrcType.OXYGEN

static func update(cell: BottleCell) -> void:
  move(cell)

static func move(cell: BottleCell) -> void:
  var minimum = 30
  var maximum = cell.RESOURCE_LIMIT / 2
  var oxygen = cell.resources.get_resource(RSRC_TYPE)
  if oxygen.amount <= minimum:
    return

  if oxygen.amount > maximum:
    cell.drop_resource(RSRC_TYPE)
  if oxygen.amount > minimum:
    cell.lift_resource(RSRC_TYPE)
  if oxygen.amount > minimum:
    cell.spill_resource(RSRC_TYPE)
