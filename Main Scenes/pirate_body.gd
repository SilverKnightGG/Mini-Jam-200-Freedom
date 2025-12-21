extends CharacterBody3D


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var parent: Node3D = get_parent()

@export var speed: float = 10.0
@export var turn_speed: float = 30.0
@export var jump_impulse: float = 10.0

@onready var camera_horizontal: Node3D = %Horizontal
@onready var camera_vertical: Node3D = %Vertical

enum AnimationState {IDLE, MOVE, DIG, CHEER, DIE, JUMPING, FALLING}
var animation_state: AnimationState = AnimationState.IDLE


func _ready():
	capture_mouse()


func _process(delta):
	parent.position = position


func _physics_process(delta):
	var input_direction: Vector2 = Input.get_vector("LEFT", "RIGHT", "FORWARD", "REVERSE")
	var direction_from_camera: Vector3 = (camera_horizontal.transform.basis * Vector3(input_direction.x, 0.0, input_direction.y))

	if not is_on_floor():
		velocity.y -= gravity * delta
		# TODO play falling animation (if needed)

	# NOTE Uncomment the following and use for animations once we have them
	#else:
		#match animation_state:
			#AnimationState.IDLE:

			#AnimationState.MOVE:

			#AnimationState.DIG:

			#AnimationState.CHEER:

			#AnimationState.DIE:


	if direction_from_camera:
		velocity.x = direction_from_camera.x * speed
		velocity.z = direction_from_camera.z * speed
		rotation.y = lerp_angle(
			rotation.y,
			atan2(-direction_from_camera.x, -direction_from_camera.z),
			turn_speed * delta
		)
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)

	# TODO Add jump input here if desired
	if is_on_floor() and Input.is_action_just_pressed("JUMP"):
		# TODO add call to animation for jump
		velocity.y = jump_impulse
		animation_state = AnimationState.JUMPING

	move_and_slide()




func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
