extends TalkZone

class_name Dunkel

var _requestFulfilled: bool = false
var _transitioning: bool = false
var _finished: bool = false
var _curTransitionTime: float = 0
var _maxTransitionTime: float = 1.0
var _pleaseDialogue: Array[GlobalEnums.Dialogue] = [GlobalEnums.Dialogue.DUNKELWANT1, GlobalEnums.Dialogue.DUNKELWANT2]
var _thanksDialogue: Array[GlobalEnums.Dialogue] = [GlobalEnums.Dialogue.DUNKELTHANKS]
@export var _FestivalDunkel: Node3D
@export var _sfx: AudioStreamPlayer
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
	
func player_exited(_obj: Object):
	_InteractIcon.visible = false
	_active = false

func _physics_process(delta: float) -> void:
	if (_transitioning):
		if (_curTransitionTime >= _maxTransitionTime):
			_transitioning = false
			_finished = true
			_InteractIcon.visible = false
			_active = false
			_Model.visible = false
			_FestivalDunkel.visible = true
			_seeya.emitting = true
			_TPSFX.play()
			_Collider.set_deferred("disabled", true)
			_TalkZone.set_deferred("disabled", true)
			_FCollider.set_deferred("disabled", false)
			_FTalkZone.set_deferred("disabled", false)
		_curTransitionTime += delta
		
	if (Input.is_action_just_pressed("speak")):
		if (_active):
			if !_requestFulfilled:
				for d in _pleaseDialogue:
					_pauseMenu.queue_dialogue(d)
				_pauseMenu.set_voice(GlobalEnums.Voices.DUNKEL)
				_pauseMenu.display_text()
				_active = false
			else:
				for d in _thanksDialogue:
					_pauseMenu.queue_dialogue(d)
				_pauseMenu.set_voice(GlobalEnums.Voices.DUNKEL)
				_pauseMenu.display_text()
				_active = false
				_transitioning = true
			_InteractIcon.visible = false
func playsound():
	_sfx.play()
