extends Node2D

@export var resources : RsrcManager

func _ready() -> void:
  pass

func _process(delta: float) -> void:
  $UI/FPS.text = str(Engine.get_frames_per_second(), "fps")
func _on_resource_manager_resource_changed(resource_type:RsrcPool.RsrcType, previous_amount:int, new_amount:int) -> void:
  print(RsrcPool.get_resource_name(resource_type), " changed from ", previous_amount, " to ", new_amount)
