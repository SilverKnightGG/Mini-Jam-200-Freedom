extends Node

const STAGE_TIME: float = 60.0 # seconds


var time: float = STAGE_TIME

enum TimeState {TICKING, READY, PAUSED, FINISHED}
var time_state: TimeState = TimeState.READY

signal timeout
signal paused
var pause_emitted: bool = false


func _process(delta):
	match  time_state:
		TimeState.TICKING:
			time -= delta
			if not time > 0.0:
				timeout.emit()
				time_state = TimeState.FINISHED
			pause_emitted = false
		TimeState.READY:
			pass
		TimeState.PAUSED:
			if not pause_emitted:
				pause_emitted = true
				paused.emit()
		TimeState.FINISHED:
			pass
