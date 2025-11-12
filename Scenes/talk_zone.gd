extends Area3D

class_name TalkZone

@export var _player: Player
@export var _pauseMenu: PauseMenu
@export var _InteractIcon: Sprite3D
@export var _dialogQueueing: Array[GlobalEnums.Dialogue]
@export var _voice: GlobalEnums.Voices = GlobalEnums.Voices.BUNGOO
var _active: bool = false

func _ready() -> void:
	body_entered.connect(player_entered)
	body_exited.connect(player_exited)
	
func player_entered(_obj: Object):
	_InteractIcon.visible = true
	_active = true
	
func player_exited(_obj: Object):
	_InteractIcon.visible = false
	_active = false

func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("speak")):
		if (_active):
			for d in _dialogQueueing:
				_pauseMenu.queue_dialogue(d)
			_pauseMenu.set_voice(_voice)
			_pauseMenu.display_text()
			_active = false
