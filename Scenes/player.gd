extends CharacterBody3D

class_name Player

enum States {GROUNDED, IN_AIR, GRINDING, GLIDING}

var _state: States = States.GROUNDED

@export var _camera: Camera3D
@export var _meshPivot: Node3D
@export var _camera_pivot = Node3D

@export_group("Grounded")
@export var _jumpSpeed: float = 10.0
@export var _runSpeed: float = 7.0
@export var _groundAcceleration: float = 75.0
var _targetVelocity: Vector3 = Vector3.ZERO
var _cameraDifferenceVector: Vector3 = Vector3.FORWARD

@export_group("In Air")
@export var _idleSpeed: float = 7.0
@export var _idleAcceleration: float = 12.5
@export var _fallAcceleration: float = 25
var _floatFall: bool = false

@export_group("Gliding")

var _stateDict: Dictionary[States, Callable] = {
	States.GROUNDED:state_grounded,
	States.IN_AIR:state_inair,
	States.GLIDING:state_gliding,
	States.GRINDING:state_grinding
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	_stateDict[_state].call(delta)
	velocity = _targetVelocity
	move_and_slide()

func state_grounded(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	#if !(Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
	_cameraDifferenceVector = global_position - _camera.global_position
	_cameraDifferenceVector.y = 0
	_cameraDifferenceVector = _cameraDifferenceVector.normalized()
	var orthogonalCameraDifferenceVector: Vector3 = Vector3(-1 * _cameraDifferenceVector.z, 0, _cameraDifferenceVector.x).normalized()
	if (Input.is_action_pressed("move_right")):
		direction += orthogonalCameraDifferenceVector * Input.get_action_strength("move_right")
	if (Input.is_action_pressed("move_left")):
		direction -= orthogonalCameraDifferenceVector * Input.get_action_strength("move_left")
	if (Input.is_action_pressed("move_back")):
		direction -= _cameraDifferenceVector * Input.get_action_strength("move_back");
	if (Input.is_action_pressed("move_forward")):
		direction += _cameraDifferenceVector * Input.get_action_strength("move_forward");
	if (Input.is_action_just_pressed("jump")):
		_targetVelocity.y = _jumpSpeed;
		_floatFall = true
		_state = States.IN_AIR
	if (direction.length() < 0.1):
		direction = Vector3.ZERO;
	elif (direction != Vector3.ZERO):
		if (direction.length() >= 1):
			direction = direction.normalized();
			_meshPivot.look_at(position + direction, Vector3.UP);
			
	_targetVelocity.x = direction.x * _runSpeed;
	_targetVelocity.z = direction.z * _runSpeed;

	var groundVelocity: Vector2 = Vector2(_targetVelocity.x, _targetVelocity.z);
	var playerVelocity: Vector2 = Vector2(velocity.x, velocity.z)
	if (abs(playerVelocity.length() - groundVelocity.length()) > 1):
		if (playerVelocity.length() > groundVelocity.length()):
			var decelDirection: Vector2 = playerVelocity.normalized();
			_targetVelocity.x = velocity.x - (float)(_groundAcceleration * delta * decelDirection.x);
			_targetVelocity.z = velocity.z - (float)(_groundAcceleration * delta * decelDirection.y);
		elif (playerVelocity.length() < groundVelocity.length()):
			_targetVelocity.x = velocity.x + (float)(_groundAcceleration * delta * direction.x);
			_targetVelocity.z = velocity.z + (float)(_groundAcceleration * delta * direction.z);
	if (!is_on_floor()):
		_state = States.IN_AIR
	
func state_inair(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	#if !(Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
	_cameraDifferenceVector = global_position - _camera.global_position
	_cameraDifferenceVector.y = 0
	_cameraDifferenceVector = _cameraDifferenceVector.normalized()
	var orthogonalCameraDifferenceVector: Vector3 = Vector3(-1 * _cameraDifferenceVector.z, 0, _cameraDifferenceVector.x).normalized()
	if (Input.is_action_pressed("move_right")):
		direction += orthogonalCameraDifferenceVector * Input.get_action_strength("move_right")
	if (Input.is_action_pressed("move_left")):
		direction -= orthogonalCameraDifferenceVector * Input.get_action_strength("move_left")
	if (Input.is_action_pressed("move_back")):
		direction -= _cameraDifferenceVector * Input.get_action_strength("move_back");
	if (Input.is_action_pressed("move_forward")):
		direction += _cameraDifferenceVector * Input.get_action_strength("move_forward");
	if (Input.is_action_just_released("jump")):
		_floatFall = false
	if (Input.is_action_just_pressed("glide")):
		_state = States.GLIDING
	if (direction.length() < 0.1):
		direction = Vector3.ZERO;
	elif (direction != Vector3.ZERO):
		if (direction.length() >= 1):
			direction = direction.normalized();
			_meshPivot.look_at(position + direction, Vector3.UP);
			
	_targetVelocity.x = direction.x * _idleSpeed;
	_targetVelocity.z = direction.z * _idleSpeed;

	var groundVelocity: Vector2 = Vector2(_targetVelocity.x, _targetVelocity.z);
	var playerVelocity: Vector2 = Vector2(velocity.x, velocity.z)
	if (abs(playerVelocity.length() - groundVelocity.length()) > 1):
		if (playerVelocity.length() > groundVelocity.length()):
			var decelDirection: Vector2 = playerVelocity.normalized();
			_targetVelocity.x = velocity.x - (float)(_idleAcceleration * delta * decelDirection.x);
			_targetVelocity.z = velocity.z - (float)(_idleAcceleration * delta * decelDirection.y);
		elif (playerVelocity.length() < groundVelocity.length()):
			_targetVelocity.x = velocity.x + (float)(_idleAcceleration * delta * direction.x);
			_targetVelocity.z = velocity.z + (float)(_idleAcceleration * delta * direction.z);
	
	var tmpAccel: float = _fallAcceleration
	if (!_floatFall):
		tmpAccel *= 2
	_targetVelocity.y = _targetVelocity.y - (float)(tmpAccel * delta)
	if is_on_floor():
		_targetVelocity.y = 0
		_state = States.GROUNDED
		

@export_group("Gliding")
#@export var _glidingTurnAcceleration: float = 10.0
#@export var _glidingTurnDeceleration: float = 20.0
@export var _glidingTurnSpeed: float = 1.0
@export var _sideTiltVariation: float = 25.0
@export_subgroup("Tilting Parameters")
@export var _glidingUpMaxFallSpeed: float = 1.0
@export var _glidingDownMaxFallSpeed: float = 5.0
@export var _glidingUpMaxForwardSpeed: float = 2.0
@export var _glidingDownMaxForwardSpeed: float = 10.0
@export var _glidingAcceleration: float = 25.0
@export var _glidingDeceleration: float = 25.0
@export var _tiltVariation: float = 25.0
@export var _evilDebugLabel: Label

func state_gliding(delta: float):
	var direction: Vector2 = Vector2.ZERO
	if (Input.is_action_pressed("glide_right")):
		direction += Vector2.RIGHT
	if (Input.is_action_pressed("glide_left")):
		direction += Vector2.LEFT
	if (Input.is_action_pressed("glide_down")):
		direction.y -= 1
	if (Input.is_action_pressed("glide_up")):
		direction.y += 1
	if (Input.is_action_just_released("glide")):
		_state = States.IN_AIR
	if (is_on_floor()):	
		_state = States.GROUNDED
		
	_meshPivot.look_at(position + velocity)
	
	var tilt: float = (direction.y + 1.0) / 2
	var maxFallSpeed: float = lerpf(_glidingDownMaxFallSpeed, _glidingUpMaxFallSpeed, tilt)
	var maxForwardSpeed: float = lerpf(_glidingDownMaxForwardSpeed, _glidingUpMaxForwardSpeed, tilt)
	
	#if (abs(velocity.y - maxFallSpeed) < 1):
	if (velocity.y < -maxFallSpeed):
		var decelDirection: Vector3 = Vector3.UP;
		_targetVelocity = velocity + (_glidingDeceleration * decelDirection * delta)
	elif (velocity.y > -maxFallSpeed):
		var accelDirection: Vector3 = Vector3.UP;
		_targetVelocity = velocity - (_glidingAcceleration * accelDirection * delta)
	
	var hv: Vector3 = Vector3(velocity.x, 0, velocity.z)
	var horizontalVelocity: float = hv.length()
	#if (abs(horizontalVelocity - maxForwardSpeed) < 1):
	if (horizontalVelocity > maxForwardSpeed):
		var decelDirection: Vector3 = hv.normalized();
		_targetVelocity -= (_glidingDeceleration * decelDirection * delta)
	elif (horizontalVelocity < maxForwardSpeed):
		var accelDirection: Vector3 = hv.normalized();
		_targetVelocity += (_glidingAcceleration * accelDirection * delta)
		
	if (direction.x != 0):
		_targetVelocity = _targetVelocity.rotated(Vector3.UP, -direction.x * _glidingTurnSpeed * delta)
		_meshPivot.rotation.z = direction.x * _sideTiltVariation
		
		
	_evilDebugLabel.text = str(maxFallSpeed) + "\n" + str(maxForwardSpeed) + "\n" + str(_targetVelocity)
	_meshPivot.rotation.x = -direction.y * _tiltVariation
	
@export_group("Grinding")
var _rail: GrindRail
@export var _grindOffset: float = 1.0
@export var _grindSpeed: float = 10.0
var _grindDirection: int = 1
func state_grinding(delta: float):
	global_position = _rail._path.global_position
	global_position.y += _grindOffset
	_meshPivot.rotation = _rail._path.rotation
	_rail._path.progress += _grindDirection * _grindSpeed * delta
	if (Input.is_action_just_pressed("jump")):
		_targetVelocity.y = _jumpSpeed;
		_floatFall = true
		_state = States.IN_AIR
	
	
@export_group("Camera Controls")
@export_range(0.0, 1.0) var mouse_sensitivity = 0.005
@export var tilt_limit = deg_to_rad(75)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit / 2)
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
		
func rail_entered(body: Object, gr: GrindRail):
	#global_position = gr.to_global(gr.curve.get_closest_point(global_position))
	if (_state != States.GRINDING):
		gr.setInitialGrindPos(global_position)
		_state = States.GRINDING
		_rail = gr
		if _rail.getBackwardVector().dot(velocity.normalized()) > 0:
			_grindDirection = -1
		else:
			_grindDirection = 1
