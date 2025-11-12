extends AnimatedSprite3D
@export var _area: Area3D
@export var _player: Player

func _ready() -> void:
	_area.body_entered.connect(self.collect)
	
func collect(obj: Object):
	_player.collect_coin()
	queue_free()
