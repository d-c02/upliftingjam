extends TalkZone

class_name Shop
var _cost: int = 3
#@export var _cShape: CollisionShape3D
@export var _yahie: Yahie
func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("speak")):
		if (_active):
			if (_player._coins < _cost):
				_pauseMenu.queue_dialogue(GlobalEnums.Dialogue.TOOPOOR)
				_pauseMenu.set_voice(_voice)
				_pauseMenu.display_text()
				_active = false
			else:
				_pauseMenu.queue_dialogue(GlobalEnums.Dialogue.HATACQUIRED)
				_player.wear_hat()
				_pauseMenu.set_voice(_voice)
				_pauseMenu.display_text()
				_yahie._requestFulfilled = true
				_active = false
				visible = false
				queue_free()
