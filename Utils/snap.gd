class_name Snap


const MAX_SNAP_DISTANCE: float = 1500.0


static func snap_to_floor(node: Node3D):
	var space := node.get_world_3d().direct_space_state

	var aabb := get_visual_aabb(node)
	var bottom_offset := aabb.position.y

	var from := node.global_position
	var to := from - Vector3.UP * MAX_SNAP_DISTANCE

	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [node]

	var result := space.intersect_ray(query)
	if result:
		node.global_position.y = result.position.y - bottom_offset


static func get_visual_aabb(root: Node3D) -> AABB:
	var combined := AABB()
	var first := true

	for child in root.get_children():
		if not child is MeshInstance3D:
			return AABB(Vector3.ZERO, Vector3.ZERO)
		var child_mesh: MeshInstance3D = child as MeshInstance3D
		var aabb: AABB = child_mesh.get_aabb()
		aabb = aabb * child_mesh.transform

		if first:
			combined = aabb
			first = false
		else:
			combined = combined.merge(aabb)

	return combined
