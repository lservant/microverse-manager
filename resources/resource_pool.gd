extends Resource
class_name ResourcePool

enum ResourceType {
  WATER,
  NUTRIENTS,
  SUNLIGHT,
  ORGANICS,
  OXYGEN,
  CARBON_DIOXIDE
}

const RESOURCE_TYPE_NAMES = {
  ResourceType.WATER: "Water",
  ResourceType.NUTRIENTS: "Nutrients",
  ResourceType.SUNLIGHT: "Sunlight",
  ResourceType.ORGANICS: "Organics",
  ResourceType.OXYGEN: "Oxygen",
  ResourceType.CARBON_DIOXIDE: "Carbon Dioxide"
}

@export var resources := {}

"""
Returns the name of the given resource type.
"""
func get_resource_name(resource_type: ResourceType) -> String:
  if resource_type < 0 or resource_type >= ResourceType.keys().size():
    return "Unknown"
  if RESOURCE_TYPE_NAMES.has(resource_type):
    return RESOURCE_TYPE_NAMES[resource_type]
  return ResourceType.keys()[resource_type]