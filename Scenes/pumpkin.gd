extends TalkZone

class_name Pumpkin
@export var _cShape: CollisionShape3D
var _initialPos: Vector3

func _ready() -> void:
	super()
	_initialPos = global_position
	global_position = _initialPos
	visible = true
	_cShape.set_deferred("disabled", false)
	_active = false
	
func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("speak")):
		if (_active):
			_player.hold_item(self)
			visible = false
			_cShape.set_deferred("disabled", true)
			_active = false
			
func drop():
	visible = true
	_cShape.set_deferred("disabled", false)
	global_position = _player.global_position - Vector3(0, 1.0, 0)
	_active = false

func resetPos():
	global_position = _initialPos
	visible = true
	_cShape.set_deferred("disabled", false)
	_active = false
	
func player_entered(_obj: Object):
	_InteractIcon.visible = true
	_active = true
	_player._inZone = true
	print_debug("AHHH")
	
func player_exited(_obj: Object):
	_InteractIcon.visible = false
	_active = false
	_player._inZone = false
