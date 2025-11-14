extends TalkZone

class_name CreditsTrigger
@export var _cShape: CollisionShape3D

func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("speak")):
		if (_active):
			_pauseMenu.StartLoadCredits()

var _target: int = 3
var _count: int = 0
func increment():
	_count += 1
	if (_count > _target):
		_cShape.disabled = false
		visible = true
