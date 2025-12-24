extends Node3D

const SAFE_SPAWN_HEIGHT: float = 500.0
const HOLE_SCENE: PackedScene = preload("uid://cavu31quu5n0w")


func _on_digging(location: Vector3):
	var new_hole: Decal = HOLE_SCENE.instantiate()
	new_hole.albedo_mix = 0.0
	%Holes.add_child(new_hole)
	new_hole.global_position = location
	new_hole.global_position.y = 500.0
	Snap.snap_to_floor(new_hole)
	Snap.set_decal_y(new_hole, PirateBody.DIG_OFFSET_DOWN)
	var hole_tween: Tween = get_tree().create_tween()
	hole_tween.tween_property(new_hole, "albedo_mix", 1.0, Globals.DIG_TIME)


func _ready():
	if not Globals.digging.is_connected(_on_digging):
		Globals.digging.connect(_on_digging)
