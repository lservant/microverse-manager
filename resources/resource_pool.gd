extends Resource
## Collects and describes resources.
class_name ResourcePool

signal resource_changed(resource_type: ResourceType, previous_amount: int, new_amount: int)

enum ResourceType {
  WATER,
  NUTRIENTS,
  SUNLIGHT,
  ORGANICS,
  OXYGEN,
  CARBON_DIOXIDE,
  VACCUUM,
}

const RESOURCE_TYPE_NAMES = {
  ResourceType.WATER: "Water",
  ResourceType.NUTRIENTS: "Nutrients",
  ResourceType.SUNLIGHT: "Sunlight",
  ResourceType.ORGANICS: "Organics",
  ResourceType.OXYGEN: "Oxygen",
  ResourceType.CARBON_DIOXIDE: "Carbon Dioxide",
  ResourceType.VACCUUM: "Vacuum",
}

const RESOURCE_TYPE_ABBREVIATIONS = {
  ResourceType.WATER: "H2O",
  ResourceType.NUTRIENTS: "NUT",
  ResourceType.SUNLIGHT: "LIT",
  ResourceType.ORGANICS: "ORG",
  ResourceType.OXYGEN: "OXY",
  ResourceType.CARBON_DIOXIDE: "CO2",
  ResourceType.VACCUUM: "VAC",
}

@export var resources: Array[ResourceInfo]


## Gets the amount of the given resource type in the resource pool.
func get_resource(resource_type: ResourceType) -> ResourceInfo:
  for resource in resources:
    if resource.resource_type == resource_type:
      return resource
  return ResourceInfo.new()

## Sets the amount of the given resource type in the resource pool.
## If the resource type does not exist, it will be created.
func set_resource(resource_type: ResourceType, amount: int) -> void:
  for resource in resources:
    if resource.resource_type == resource_type:
      resource.amount = amount
      return
  var new_resource = ResourceInfo.new()
  new_resource.resource_type = resource_type
  new_resource.amount = amount
  resources.append(new_resource)

## Adds amount of given resource type to the _resources pool.
## If the resource type does not exist, it will be created.
func add_resource(resource_type: ResourcePool.ResourceType, amount: int) -> void:
  var previous_amount = get_resource(resource_type).amount
  set_resource(resource_type, previous_amount + amount)
  var new_amount = get_resource(resource_type).amount
  resource_changed.emit(resource_type, previous_amount, new_amount)

## Removes amount of given resource type from the _resources pool. Returning true if successful.
## If the resource type does not exist or the amount to remove is greater than the current amount, it will return false.
func remove_resource(resource_type: ResourcePool.ResourceType, amount: int) -> bool:
  var current = get_resource(resource_type).amount
  if amount > current:
    return false

  set_resource(resource_type, current - amount)
  var new_amount = get_resource(resource_type).amount
  resource_changed.emit(resource_type, current, new_amount)
  return true

## Empties the resource pool of the given resource type and returns the amount removed.
func empty_resource(resource_type: ResourcePool.ResourceType) -> int:
  var resource = get_resource(resource_type)
  if resource:
    var amount = resource.amount
    remove_resource(resource_type, amount)
    return amount
  else:
    return 0

## Returns true if the resource pool is empty.
func is_empty() -> bool:
  for resource in resources:
    if resource.amount > 0:
      return false
  return true

## Returns the name of the given resource type.
static func get_resource_name(resource_type: ResourceType) -> String:
  if resource_type < 0 or resource_type >= ResourceType.keys().size():
    return "Unknown"
  if RESOURCE_TYPE_NAMES.has(resource_type):
    return RESOURCE_TYPE_NAMES[resource_type]
  return ResourceType.keys()[resource_type]

## Returns the abbreviation of the given resource type.
static func get_resource_abbreviation(resource_type: ResourceType) -> String:
  if resource_type < 0 or resource_type >= ResourceType.keys().size():
    return "UNK"
  if RESOURCE_TYPE_ABBREVIATIONS.has(resource_type):
    return RESOURCE_TYPE_ABBREVIATIONS[resource_type]
  return ResourceType.keys()[resource_type]

func _to_string() -> String:
  var result = ""
  for resource in resources:
    result += RESOURCE_TYPE_NAMES[resource.resource_type] + ": " + str(resource.amount) + "\n"
  return result
