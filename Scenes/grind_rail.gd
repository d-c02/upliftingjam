extends Path3D

class_name GrindRail

@export var _path: PathFollow3D
@export var _player: Player
@export var _polygon: CSGPolygon3D
@export var _hitbox: CollisionShape3D
@export var _area: Area3D

func _ready() -> void:
	_hitbox.shape = _polygon.bake_collision_shape()
	_area.body_entered.connect(_player.rail_entered.bind(self))
	
func setInitialGrindPos(pos: Vector3):
	_path.progress_ratio = curve.get_closest_offset(to_local(pos)) / curve.get_baked_length()
	
func getForwardVector():
	if (_path.progress_ratio <= 0.99 or _path.loop == true):
		var pr: float = _path.progress_ratio
		var pos1: Vector3 = _path.global_position
		_path.progress_ratio += 0.01
		var pos2: Vector3 = _path.global_position
		_path.progress_ratio = pr
		return (pos2 - pos1).normalized()
	else:
		#this is a bad place to be
		return Vector3.FORWARD
		
func getBackwardVector():
	if (_path.progress_ratio >= 0.01 or _path.loop == true):
		var pr: float = _path.progress_ratio
		var pos1: Vector3 = _path.global_position
		_path.progress_ratio -= 0.01
		var pos2: Vector3 = _path.global_position
		_path.progress_ratio = pr
		return (pos2 - pos1).normalized()
	else:
		#this is a bad place to be
		return Vector3.BACK
