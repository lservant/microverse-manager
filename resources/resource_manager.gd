extends Node
class_name ResourceManager

signal resource_changed(resource_type: ResourcePool.ResourceType, previous_amount: int, new_amount: int)

@export var resource_pool: ResourcePool

func _init() -> void:
  if resource_pool == null:
    resource_pool = ResourcePool.new()

func _ready() -> void:
  resource_pool.resource_changed.connect(_on_resource_changed)
  
## Adds amount of given resource type to the _resources pool.
## If the resource type does not exist, it will be created.
func add_resource(resource_type: ResourcePool.ResourceType, amount: int) -> void:
  resource_pool.add_resource(resource_type, amount)

## Removes amount of given resource type from the _resources pool. Returning true if successful.
## If the resource type does not exist or the amount to remove is greater than the current amount, it will return false.
func remove_resource(resource_type: ResourcePool.ResourceType, amount: int) -> bool:
  return resource_pool.remove_resource(resource_type, amount)

## Empties the resource pool of the given resource type and returns the amount removed.
func empty_resource(resource_type: ResourcePool.ResourceType) -> int:
  return resource_pool.empty_resource(resource_type)

## Returns the amount of the given resource type in the resource pool.
func get_resource(resource_type: ResourcePool.ResourceType) -> int:
  return resource_pool.get_resource(resource_type).amount

## Returns current resources in the resource pool.
func get_resources() -> Array[ResourceInfo]:
  return resource_pool.resources

func _on_resource_changed(resource_type: ResourcePool.ResourceType, previous_amount: int, new_amount: int) -> void:
  resource_changed.emit(resource_type, previous_amount, new_amount)