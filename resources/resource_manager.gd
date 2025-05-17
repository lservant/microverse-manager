extends Node
class_name ResourceManager

signal resource_changed(resource_type: ResourcePool.ResourceType, previous_amount: int, new_amount: int)

@export var resource_pool: ResourcePool

func _init() -> void:
  if resource_pool == null:
    resource_pool = ResourcePool.new()

"""
Adds amount of given resource type to the _resources pool.
If the resource type does not exist, it will be created.
"""
func add_resource(resource_type: ResourcePool.ResourceType, amount: int) -> void:
  var previous_amount = get_resource(resource_type)
  resource_pool.set_resource(resource_type, previous_amount + amount)
  var new_amount = get_resource(resource_type)

  resource_changed.emit(resource_type, previous_amount, new_amount)

"""
Removes amount of given resource type from the _resources pool. Returning true if successful.
If the resource type does not exist or the amount to remove is greater than the current amount, it will return false.
"""
func remove_resource(resource_type: ResourcePool.ResourceType, amount: int) -> bool:
  var current = get_resource(resource_type)
  if amount > current:
    return false

  resource_pool.set_resource(resource_type, current - amount)
  var new_amount = get_resource(resource_type)

  resource_changed.emit(resource_type, current, new_amount)
  return true

"""
Empties the resource pool of the given resource type and returns the amount removed.
"""
func empty_resource(resource_type: ResourcePool.ResourceType) -> int:
  var resource = resource_pool.get_resource(resource_type)
  if resource:
    var amount = resource.amount
    remove_resource(resource_type, amount)
    return amount
  else:
    return 0

"""
Returns the amount of the given resource type in the resource pool.
"""
func get_resource(resource_type: ResourcePool.ResourceType) -> int:
  return resource_pool.get_resource(resource_type).amount