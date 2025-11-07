extends Area3D

@export var _player: Player
@export var _pause_menu: PauseMenu

func _ready() -> void:
	body_entered.connect(_player.drown)
	body_entered.connect(_pause_menu.StartDrownPause)
