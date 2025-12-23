extends Timer

var can_emit: bool = true


func _on_dirt_emit():
	if not can_emit:
		stop()
		return

	prints("dirt particles should be emitting")
	%DirtParticles.emitting = true


func _on_emit_off():
	can_emit = false
