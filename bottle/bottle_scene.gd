extends Node2D

@export var resources : ResourceManager

func _ready() -> void:
  print("Adding water")
  resources.add_resource(ResourcePool.ResourceType.WATER, 100)
  await get_tree().create_timer(1).timeout

  print("Adding nutrients")
  resources.add_resource(ResourcePool.ResourceType.NUTRIENTS, 50)
  await get_tree().create_timer(1).timeout
  
  print("Removing water")
  resources.remove_resource(ResourcePool.ResourceType.WATER, 20)
  await get_tree().create_timer(1).timeout
  
  print("Removing nutrients")
  resources.remove_resource(ResourcePool.ResourceType.NUTRIENTS, 60)
  await get_tree().create_timer(1).timeout
  
  print("Removing nutrients again")
  resources.remove_resource(ResourcePool.ResourceType.NUTRIENTS, 20)
  await get_tree().create_timer(1).timeout
  
  print("Emptying water")
  var remaining_water = resources.empty_resource(ResourcePool.ResourceType.WATER)
  print("Remaining water: ", remaining_water)

func _on_resource_manager_resource_changed(resource_type:ResourcePool.ResourceType, previous_amount:int, new_amount:int) -> void:
  print(ResourcePool.get_resource_name(resource_type), " changed from ", previous_amount, " to ", new_amount)
