extends Node

const STAGE_TIME: float = 60.0 # seconds


var time: float = STAGE_TIME

enum TimeState {TICKING, READY, PAUSED, FINISHED}
var time_state: TimeState = TimeState.READY

signal timeout
signal paused
signal found_treasure
signal treasure_not_found
var pause_emitted: bool = false
var elapsed_time: float = 0.0
var treasure_quadrant: Vector2i = Vector2i.ZERO


## Returns true if dig attempt is within bounds.
func dig_here(xz_position: Vector2) -> bool:
	if xz_position.length_squared() > float(pow(GameStage.QUAD_SIZE * (GameStage.SEARCH_DIAMETER / 2), 2.0)):
		return false

	var checking_quadrant: Vector2i = Vector2i(xz_position / GameStage.QUAD_SIZE)
	if checking_quadrant == treasure_quadrant:
		found_treasure.emit()
	else:
		treasure_not_found.emit()

	return true


func _process(delta):
	elapsed_time += delta

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
