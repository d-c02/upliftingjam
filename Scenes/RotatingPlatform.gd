extends Node3D

@export var _rotationSpeed: float = 1.0
func _physics_process(delta: float) -> void:
	rotate_x(_rotationSpeed * delta)
