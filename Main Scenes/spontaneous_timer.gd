extends Timer

const START_TIME: float = 12.0
const MAX_TIME: float = 42.0
const MIN_TIME: float = 18.0


func _on_timeout() -> void:
	start(randf_range(MIN_TIME, MAX_TIME))
	Globals.spontaneous_dialogue_play()


func _ready():
	start(START_TIME)
