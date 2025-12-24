extends AudioStreamPlayer


func _play_ambience():
	play()


func _ready():
	_play_ambience()


func _on_tree_exiting() -> void:
	stop()
