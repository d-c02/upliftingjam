extends CanvasLayer

class_name PauseMenu

@export var _transitioning: bool = false
@export var _transitionWipe: ColorRect
@export var _wipeSpeed: float = 1.0
@export var _material: ShaderMaterial
func StartDrownPause(obj: Object):
	process_mode = Node.PROCESS_MODE_ALWAYS
	_transitioning = true
	_transitionWipe.visible = true
	
func _process(delta: float) -> void:
	var progress = _material.get_shader_parameter("progress")
	if (_transitioning):
		_material.set_shader_parameter("progress", progress - (_wipeSpeed * delta))
		if (progress <= -0.5):
			_transitioning = false
			process_mode = Node.PROCESS_MODE_WHEN_PAUSED
			get_tree().paused = true
