extends CharacterBody3D


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var parent: Node3D = get_parent()

@export var speed: float = 10.0
@export var turn_speed: float = 30.0
@export var jump_impulse: float = 7.5

@onready var camera_horizontal: Node3D = %Horizontal
@onready var camera_vertical: Node3D = %Vertical

signal finished_kneeling
signal finished_cheering

enum AnimationState {IDLE, MOVE, DIG, CHEER, KNEEL, JUMPING, FALLING}
var animation_state: AnimationState = AnimationState.IDLE:
	set(new_state):
		last_state = animation_state
		animation_state = new_state

		match animation_state:
			AnimationState.IDLE:
				print("play 'idle'")
			AnimationState.MOVE:
				print("play 'move'")
			AnimationState.DIG:
				if Globals.dig_here(Vector2(global_position.x, global_position.z)):
					print("play 'dig'")
					%DigTimer.start(Globals.DIG_TIME)
				else:
					animation_state = AnimationState.IDLE
			AnimationState.CHEER:
				print("play 'cheer'")
				# TODO await AnimationPlayer's finished() to chain-emit finished_cheering
			AnimationState.KNEEL:
				print("play 'kneel'")
				# TODO await AnimationPlayer's finished() to chain-emit finished_kneeling
			AnimationState.JUMPING:
				print("play 'jump'")
			AnimationState.FALLING:
				print("play 'idle'")

@onready var last_state: AnimationState = animation_state


func _on_dig_success():
	animation_state = AnimationState.CHEER


func _on_dig_failure():
	animation_state = AnimationState.IDLE


func _on_dig_timer_timeout():
	Globals.dig_check(Globals.checking_quadrant)


func _ready():
	_connect_signals()
	capture_mouse()
	Globals.pirate = self


func _connect_signals():
	if not Globals.found_treasure.is_connected(_on_dig_success):
		Globals.found_treasure.connect(_on_dig_success)
	if not Globals.treasure_not_found.is_connected(_on_dig_failure):
		Globals.treasure_not_found.connect(_on_dig_failure)


func _process(delta):
	parent.position = position


func _physics_process(delta):
	var input_direction: Vector2 = Input.get_vector("LEFT", "RIGHT", "FORWARD", "REVERSE")
	var direction_from_camera: Vector3 = (camera_horizontal.transform.basis * Vector3(input_direction.x, 0.0, input_direction.y))

	if not is_on_floor():
		velocity.y -= gravity * delta
		if velocity.y < 0.0 and not animation_state == AnimationState.FALLING:
			animation_state = AnimationState.FALLING
	elif animation_state == AnimationState.FALLING:
		animation_state = last_state

	if animation_state == AnimationState.IDLE or animation_state == AnimationState.MOVE:
		if direction_from_camera:
			if not animation_state == AnimationState.MOVE:
				animation_state = AnimationState.MOVE
			velocity.x = direction_from_camera.x * speed
			velocity.z = direction_from_camera.z * speed
			rotation.y = lerp_angle(
				rotation.y,
				atan2(-direction_from_camera.x, -direction_from_camera.z),
				turn_speed * delta
			)
		else:
			if not animation_state == AnimationState.IDLE:
				animation_state = AnimationState.IDLE
			velocity.x = move_toward(velocity.x, 0.0, speed)
			velocity.z = move_toward(velocity.z, 0.0, speed)

		# TODO Add jump input here if desired
		if is_on_floor() and Input.is_action_just_pressed("JUMP"):
			# TODO add call to animation for jump
			animation_state = AnimationState.JUMPING

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("DIG") and not animation_state == AnimationState.DIG:
			animation_state = AnimationState.DIG


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
