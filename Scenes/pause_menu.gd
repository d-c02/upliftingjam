extends CanvasLayer

class_name PauseMenu

@export_group("Transitions")
@export var _transitioningOut: bool = false
@export var _transitioningIn: bool = true
@export var _transitionWipeOut: ColorRect
@export var _transitionWipeIn: ColorRect
@export var _wipeSpeed: float = 1.0
@export var _material: ShaderMaterial
@export var _materialIn: ShaderMaterial

@export_group("Text")
@export var _textBox: TextureRect
@export var _label: Label

var _dialogueStrings: Dictionary[GlobalEnums.Dialogue, String] = {
	GlobalEnums.Dialogue.GREEN1:"I want to go out for halloween this year, but I would like to wear a pumpkin as a costume... could you get me one?"
}

@export var _voices: Dictionary[GlobalEnums.Voices, DialogueReader] = {}
@export var FUCK_SHIT_FUCK_YOU: DialogueReader
var _curVoice: GlobalEnums.Voices = GlobalEnums.Voices.GREEN

var _dialogueQueue: Array[GlobalEnums.Dialogue]
var _readingDialogue: bool = false
var _curDialogue: String
@export var _wordReadTime: float = 0.15
@export var _letterReadTime: float = 0.05
var _curDialogueTime: float = 0.01
var _curReadTime: float = 0
@export var _readSpeedUp: float = 2.0
var _wordDelay: bool = false
var _inNonWordZone: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_transitioningIn = true
	_transitionWipeIn.visible = true
	

func StartDrownPause(obj: Object):
	process_mode = Node.PROCESS_MODE_ALWAYS
	_transitioningOut = true
	_transitionWipeOut.visible = true
	
func _process(delta: float) -> void:
	if (_transitioningIn):
		var progress = _materialIn.get_shader_parameter("progress")
		_materialIn.set_shader_parameter("progress", progress + (_wipeSpeed * delta))
		if (progress >= 1.5):
			_transitioningIn = false
			process_mode = Node.PROCESS_MODE_WHEN_PAUSED
			_transitionWipeIn.visible = false
	
	if (_transitioningOut):
		var progress = _material.get_shader_parameter("progress")
		_material.set_shader_parameter("progress", progress - (_wipeSpeed * delta))
		if (progress <= -0.5):
			_transitioningOut = false
			process_mode = Node.PROCESS_MODE_WHEN_PAUSED
			get_tree().reload_current_scene()
			
	if (_readingDialogue):
		if (_curDialogue.length() > 0):
			if _curReadTime > _curDialogueTime:
				if (_curDialogueTime == _wordReadTime):
					var word: String = _curDialogue.get_slice(" ", 0)
					var aword: String = ""
					for c in word:
						if c.is_valid_ascii_identifier():
							aword += c
					if Input.is_action_pressed("advance_dialogue"):
						FUCK_SHIT_FUCK_YOU.Speak(aword.length(), true)
					else:
						FUCK_SHIT_FUCK_YOU.Speak(aword.length())
					
				_label.text += _curDialogue.left(1)
				_curDialogue = _curDialogue.substr(1)
				_curReadTime = 0
				if (_curDialogue.length() > 0):
					if _curDialogue.left(1).is_valid_ascii_identifier():
						if _inNonWordZone:
							_curDialogueTime = _wordReadTime
							_inNonWordZone = false
						else:
							_curDialogueTime = _letterReadTime
					else:
						_inNonWordZone = true
						_curDialogueTime = _letterReadTime
			else:
				if Input.is_action_pressed("advance_dialogue"):
					_curReadTime +=	delta * _readSpeedUp
				else:
					_curReadTime += delta
		else:
			if Input.is_action_just_pressed("advance_dialogue"):
				if _dialogueQueue.size() > 0:
					_curDialogue = _dialogueQueue.pop_front()
					_label.text = ""
				else:
					_readingDialogue = false
					_textBox.visible = false
					process_mode = Node.PROCESS_MODE_WHEN_PAUSED
					get_tree().paused = false
					_label.text = ""
	
func display_text():
	if (_dialogueQueue.size() > 0):
		process_mode = Node.PROCESS_MODE_ALWAYS
		_textBox.visible = true
		_readingDialogue = true
		get_tree().paused = true
		_curDialogue = _dialogueStrings[_dialogueQueue.pop_front()]
		
	
func queue_dialogue(d: GlobalEnums.Dialogue):
	_dialogueQueue.push_back(d)
	
