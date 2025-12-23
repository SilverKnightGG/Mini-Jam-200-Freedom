extends Node

const STAGE_TIME: float = 60.0 # seconds
const DIG_TIME: float = 2.0 # seconds
const DIG_RADIUS_SAFE_ZONE_BUFFER: int = 100


var time: float = STAGE_TIME

enum TimeState {TICKING, READY, PAUSED, FINISHED}
var time_state: TimeState = TimeState.READY

# State signals
signal starting
signal timeout
signal paused
signal digging
signal found_treasure
signal treasure_not_found

# Sound signals
signal dig_sound
signal walk_sound
signal dialogue_play(lines: Array[Dictionary])

var pause_emitted: bool = false
var elapsed_time: float = 0.0
var treasure_quadrant: Vector2i = Vector2i.ZERO
var checking_quadrant: Vector2i = Vector2i.ZERO

var pirate: CharacterBody3D


## Returns true if dig attempt is within bounds.
func dig_here(xyz_position: Vector3) -> bool:
	var xz_position: Vector2 = Vector2(xyz_position.x, xyz_position.z)
	if xz_position.length_squared() > float(pow(GameStage.QUAD_SIZE * (GameStage.SEARCH_RADIUS + DIG_RADIUS_SAFE_ZONE_BUFFER), 2.0)):
		return false

	digging.emit(xyz_position)
	dig_sound.emit()
	checking_quadrant = Vector2i(xz_position / GameStage.QUAD_SIZE)
	#dig_check() # test bypass (TODO remove after testing)
	return true


func dig_check():
	if checking_quadrant == treasure_quadrant:
		print("treasure found!")
		found_treasure.emit()
		dialogue_play.emit(Dialogue.select_dialogue(DialogueType.SUCCESS))
	else:
		print("treasure not found...")
		treasure_not_found.emit()
		dialogue_play.emit(Dialogue.select_dialogue(DialogueType.FAILURE))
		#prints("distance:", str(treasure_quadrant.distance_to(checking_quadrant)))



enum DialogueType {SQUABBLE, SPONTANEOUS, FAILURE, SUCCESS, GAME_OVER, START}


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


# Added for testing only TODO remove once testing is completed
func _ready():
	time_state = TimeState.TICKING
