extends Resource
class_name ResourceInfo

@export var resource_type : ResourcePool.ResourceType
@export var amount : int = 0

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