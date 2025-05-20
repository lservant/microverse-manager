extends Resource
class_name RsrcInfo

@export var resource_type: RsrcPool.RsrcType
@export var amount: int = 0

var name:
  get:
    return RsrcPool.get_resource_name(resource_type)
var abbreviation:
  get:
    return RsrcPool.get_resource_abbreviation(resource_type)

func _operator_add(value):
  var result = self.duplicate()
  result.amount += value
  return result
func _operator_subtract(value):
  var result = self.duplicate()
  result.amount -= value
  return result

func add(value):
  amount += value
  return self
func subtract(value):
  amount -= value
  return self

func is_empty() -> bool:
  return amount <= 0
