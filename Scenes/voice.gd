extends Node

class_name DialogueReader
var _shortWordSounds: Array[AudioStreamPlayer]
var _medWordSounds: Array[AudioStreamPlayer]
var _longWordSounds: Array[AudioStreamPlayer]
var _shortWordSoundsFast: Array[AudioStreamPlayer]
var _medWordSoundsFast: Array[AudioStreamPlayer]
var _longWordSoundsFast: Array[AudioStreamPlayer]
@export var _shortWords: Node
@export var _medWords: Node
@export var _longWords: Node
@export var _shortWordsFast: Node
@export var _medWordsFast: Node
@export var _longWordsFast: Node
@export var _volumeShift: float = -15.0
var _shortLength = 3
var _medLength = 7

func _ready() -> void:
	for child in _shortWords.get_children():
		_shortWordSounds.push_back(child as AudioStreamPlayer)
		_shortWordSounds[_shortWordSounds.size() - 1].volume_db = _volumeShift
	for child in _medWords.get_children():
		_medWordSounds.push_back(child as AudioStreamPlayer)
		_medWordSounds[_medWordSounds.size() - 1].volume_db = _volumeShift
	for child in _longWords.get_children():
		_longWordSounds.push_back(child as AudioStreamPlayer)
		_longWordSounds[_longWordSounds.size() - 1].volume_db = _volumeShift
	for child in _shortWordsFast.get_children():
		_shortWordSoundsFast.push_back(child as AudioStreamPlayer)
		_shortWordSoundsFast[_shortWordSoundsFast.size() - 1].volume_db = _volumeShift
	for child in _medWordsFast.get_children():
		_medWordSoundsFast.push_back(child as AudioStreamPlayer)
		_medWordSoundsFast[_medWordSoundsFast.size() - 1].volume_db = _volumeShift
	for child in _longWordsFast.get_children():
		_longWordSoundsFast.push_back(child as AudioStreamPlayer)
		_longWordSoundsFast[_longWordSoundsFast.size() - 1].volume_db = _volumeShift

func Speak(wordSize: int, speedUp: bool = false):
	if !speedUp:
		if wordSize <= _shortLength:
			_shortWordSounds[randi_range(0, _shortWordSounds.size() - 1)].play()
		elif wordSize <= _medLength:
			_medWordSounds[randi_range(0, _medWordSounds.size() - 1)].play()
		else:
			_longWordSounds[randi_range(0, _longWordSounds.size() - 1)].play()
	else:
		if wordSize <= _shortLength:
			_shortWordSoundsFast[randi_range(0, _shortWordSoundsFast.size() - 1)].play()
		elif wordSize <= _medLength:
			_medWordSoundsFast[randi_range(0, _medWordSoundsFast.size() - 1)].play()
		else:
			_longWordSoundsFast[randi_range(0, _longWordSoundsFast.size() - 1)].play()
