extends TalkZone

class_name Pumpkin
@export var _cShape: CollisionShape3D
func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("speak")):
		if (_active):
			_player.hold_item(self)
			visible = false
			_cShape.set_deferred("disabled", true)
			_active = false
			#GODOT SUCKS FIX THIS LATER
			#for d in _dialogQueueing:
			#	_pauseMenu.queue_dialogue(d)
			
func drop():
	visible = true
	_cShape.set_deferred("disabled", false)
	global_position = _player.global_position - Vector3(0, 1.0, 0)
	_active = false
			#AHHHHHHHHHHHHHHHHH
