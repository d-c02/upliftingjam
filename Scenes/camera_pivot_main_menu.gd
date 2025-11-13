extends Node3D

@export var _rotationSpeed: float = 0.1
func _process(delta: float) -> void:
	rotate_y(_rotationSpeed * delta)
