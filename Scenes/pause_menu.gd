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
	GlobalEnums.Dialogue.BUNGOOWANT:"I want to go out for Halloween this year, but I would like to wear a pumpkin as a costume... could you get me one?",
	GlobalEnums.Dialogue.BUNGOOTHANKS:"That looks perfect!!! Thank you for the costume, see you at the town square for the party!",
	GlobalEnums.Dialogue.BUNGOOFESTIVAL:"This is so fun! My costume looks awesome and it's such a nice night. Thank you for inviting me!",
	GlobalEnums.Dialogue.YAHIEWANT: "Halloween sounds fun, but you're not even wearing a costume! Why should I go out this year if you're not even wearing a costume?",
	GlobalEnums.Dialogue.YAHIETHANKS: "Woah, that hat looks fantastic! Okay, maybe I'll go out this year. See you at the town square?",
	GlobalEnums.Dialogue.YAHIEFESTIVAL: "Nice costume! This is a ton of fun!!!",
	GlobalEnums.Dialogue.DUNKELWANT1: "I want to go out this year for Halloween, but I'm scared of the dark... maybe I'd go out if the lights in the square were on.",
	GlobalEnums.Dialogue.DUNKELWANT2: "I heard there's an issue with the windmill causing the power issue. Maybe you can fix that and then I'll come out with you?",
	GlobalEnums.Dialogue.DUNKELTHANKS: "Wow, the lights look so great! Okay, I'll come have some fun. See you at the town square!",
	GlobalEnums.Dialogue.DUNKELFESTIVAL: "Thanks for turning on the lights for me, Halloween is so fun!",
	GlobalEnums.Dialogue.WINDMILLSWITCH: "Looks like some halloween candy was stuck on the gear. Trick or treat!",
	GlobalEnums.Dialogue.TOOPOOR: "This hat costs 3 coins! Better start saving up.",
	GlobalEnums.Dialogue.HATACQUIRED: "Here's your hat. Enjoy your purchase!"
}

var _curVoice: GlobalEnums.Voices = GlobalEnums.Voices.BUNGOO
@export var _BungooVoice: DialogueReader
@export var _DunkelVoice: DialogueReader
@export var _YahieVoice: DialogueReader

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
						if _curVoice == GlobalEnums.Voices.BUNGOO:
							_BungooVoice.Speak(aword.length(), true)
						elif _curVoice == GlobalEnums.Voices.YAHIE:
							_YahieVoice.Speak(aword.length(), true)
						elif _curVoice == GlobalEnums.Voices.DUNKEL:
							_DunkelVoice.Speak(aword.length(), true)
					else:
						if _curVoice == GlobalEnums.Voices.BUNGOO:
							_BungooVoice.Speak(aword.length())
						elif _curVoice == GlobalEnums.Voices.YAHIE:
							_YahieVoice.Speak(aword.length())
						elif _curVoice == GlobalEnums.Voices.DUNKEL:
							_DunkelVoice.Speak(aword.length())
					
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
					_curDialogue = _dialogueStrings[_dialogueQueue.pop_front()]
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
	
func set_voice(v: GlobalEnums.Voices):
	_curVoice = v
	
