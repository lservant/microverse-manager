extends FlowContainer
class_name ResourceList

@export var resource_manager: RsrcManager

var resources: Dictionary = {}

func _ready() -> void:
  for resource in resource_manager.get_resources():
    add_label(resource.abbreviation, resource.amount)
  resource_manager.resource_changed.connect(_on_resource_changed)

func add_label(abbr, amount) -> void:
  var label = Label.new()
  label.name = abbr
  add_child(label)
  resources[abbr] = label
  update_label(abbr, amount)

func _on_resource_changed(resource_type: RsrcPool.ResourceType, _previous_amount: int, new_amount: int) -> void:
  update_label(RsrcPool.get_resource_abbreviation(resource_type), new_amount)

func update_label(abbr, new_amount: int) -> void:
  if resources.has(abbr):
    var label = resources[abbr]
    label.text = str(abbr, ": ", new_amount)
  else:
    add_label(abbr, new_amount)
