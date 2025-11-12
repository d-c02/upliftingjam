extends TalkZone

class_name Bungoo

var _requestFulfilled: bool = false
var _transitioning: bool = false
var _finished: bool = false
var _curTransitionTime: float = 0
var _maxTransitionTime: float = 1.0
var _pleaseDialogue: Array[GlobalEnums.Dialogue] = [GlobalEnums.Dialogue.BUNGOOWANT]
var _thanksDialogue: Array[GlobalEnums.Dialogue] = [GlobalEnums.Dialogue.BUNGOOTHANKS]
@export var _FestivalBungoo: Node3D
@export var _seeya: CPUParticles3D
@export var _Model: Node3D
@export var _FTalkZone: CollisionShape3D
@export var _FCollider: CollisionShape3D
@export var _TalkZone: CollisionShape3D
@export var _Collider: CollisionShape3D
@export var _TPSFX: AudioStreamPlayer

func player_entered(_obj: Object):
	if (!_transitioning and !_finished):
		_InteractIcon.visible = true
		_active = true
		_player._inZone = true
	
func player_exited(_obj: Object):
	_InteractIcon.visible = false
	_active = false
	_player._inZone = false

func _physics_process(delta: float) -> void:
	if (_transitioning):
		if (_curTransitionTime >= _maxTransitionTime):
			_transitioning = false
			_finished = true
			_InteractIcon.visible = false
			_active = false
			_Model.visible = false
			_FestivalBungoo.visible = true
			_seeya.emitting = true
			_TPSFX.play()
			_Collider.set_deferred("disabled", true)
			_TalkZone.set_deferred("disabled", true)
			_FCollider.set_deferred("disabled", false)
			_FTalkZone.set_deferred("disabled", false)
		_curTransitionTime += delta
		
	if (Input.is_action_just_pressed("speak")):
		if (_active):
			if !_player._holding:
				for d in _pleaseDialogue:
					_pauseMenu.queue_dialogue(d)
				_pauseMenu.set_voice(GlobalEnums.Voices.BUNGOO)
				_pauseMenu.display_text()
				_active = false
			else:
				for d in _thanksDialogue:
					_pauseMenu.queue_dialogue(d)
				_pauseMenu.set_voice(GlobalEnums.Voices.BUNGOO)
				_pauseMenu.display_text()
				_active = false
				_transitioning = true
				_player.eradicate_pumpkin()
			_InteractIcon.visible = false
