@tool
class_name DecorGroup extends Node3D


const MIN_RADIUS: float = 4.0
const MAX_RADIUS: float = 60.0

@export_range(MIN_RADIUS, MAX_RADIUS, MIN_RADIUS) var scatter_radius: float

@export_tool_button("Scatter") var scatter_button = scatter_decorations
@export_tool_button("Random Rotation") var random_rotation_button = self_random_rotation
@export_tool_button("Snap to Ground") var snap_to_ground_button = snap_children_to_ground


func scatter_decorations():
	for child: Node3D in get_children():
		var random_xz: Vector2 = Vector2.RIGHT * randf_range(MIN_RADIUS, scatter_radius)
		random_xz = random_xz.rotated(randf_range(0.0, TAU))

		child.set_position(Vector3(random_xz.x, 0.0, random_xz.y))

	notify_property_list_changed()


func self_random_rotation():
	rotation.y = randf_range(0.0, TAU)

	notify_property_list_changed()


func snap_children_to_ground():
	for child in get_children():
		if not child is MeshInstance3D:
			continue

		Snap.snap_to_floor(child)

	notify_property_list_changed()
