extends PathFollow3D

@export var _speed: float = 10.0
func _physics_process(delta: float) -> void:
	progress += _speed * delta
