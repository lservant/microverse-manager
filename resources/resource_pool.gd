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

const RESOURCE_TYPE_ABBREVIATIONS = {
  ResourceType.WATER: "H2O",
  ResourceType.NUTRIENTS: "NUT",
  ResourceType.SUNLIGHT: "LIT",
  ResourceType.ORGANICS: "ORG",
  ResourceType.OXYGEN: "OXY",
  ResourceType.CARBON_DIOXIDE: "CO2"
}

@export var resources: Array[ResourceInfo]

"""
Gets the amount of the given resource type in the resource pool.
"""
func get_resource(resource_type: ResourceType) -> ResourceInfo:
  for resource in resources:
    if resource.resource_type == resource_type:
      return resource
  return ResourceInfo.new()

"""
Sets the amount of the given resource type in the resource pool.
If the resource type does not exist, it will be created.
"""
func set_resource(resource_type: ResourceType, amount: int) -> void:
  for resource in resources:
    if resource.resource_type == resource_type:
      resource.amount = amount
      return
  var new_resource = ResourceInfo.new()
  new_resource.resource_type = resource_type
  new_resource.amount = amount
  resources.append(new_resource)

"""
Returns the name of the given resource type.
"""
static func get_resource_name(resource_type: ResourceType) -> String:
  if resource_type < 0 or resource_type >= ResourceType.keys().size():
    return "Unknown"
  if RESOURCE_TYPE_NAMES.has(resource_type):
    return RESOURCE_TYPE_NAMES[resource_type]
  return ResourceType.keys()[resource_type]

"""
Returns the abbreviation of the given resource type.
"""
static func get_resource_abbreviation(resource_type: ResourceType) -> String:
  if resource_type < 0 or resource_type >= ResourceType.keys().size():
    return "UNK"
  if RESOURCE_TYPE_ABBREVIATIONS.has(resource_type):
    return RESOURCE_TYPE_ABBREVIATIONS[resource_type]
  return ResourceType.keys()[resource_type]