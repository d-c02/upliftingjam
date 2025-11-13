extends TalkZone

@export var _lights: Array[Node3D]
@export var _dunkel: Dunkel
@export var _windmillAnim: AnimationPlayer
func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("speak")):
		if (_active):
			#GODOT SUCKS FIX THIS LATER
			#for d in _dialogQueueing:
			#	_pauseMenu.queue_dialogue(d)
			_pauseMenu.queue_dialogue(GlobalEnums.Dialogue.WINDMILLSWITCH)
			
			#AHHHHHHHHHHHHHHHHH
			
			_pauseMenu.set_voice(_voice)
			_pauseMenu.display_text()
			_active = false
			for light in _lights:
				light.visible = true
			_dunkel._requestFulfilled = true
			_dunkel.playsound()
			_windmillAnim.current_animation = "Working"
			queue_free()
