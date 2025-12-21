extends Node3D

const MOUSE_CAMERA_SENSITIVITY: float = 0.005


var twist_input: float = 0.0
var pitch_input: float = 0.0
var input_direction: Vector2

@onready var twist_pivot: Node3D = %Horizontal
@onready var pitch_pivot: Node3D = %Vertical


func _physics_process(delta):
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)

	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(-90.0),
		deg_to_rad(45.0)
	)

	twist_input = 0.0
	pitch_input = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * MOUSE_CAMERA_SENSITIVITY
		pitch_input = -event.relative.y * MOUSE_CAMERA_SENSITIVITY
