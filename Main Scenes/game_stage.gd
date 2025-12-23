class_name GameStage extends Node

enum Actor {PIRATE, PARROT}
const DIALOGUE_TIME: float = 0.2 # seconds per 4 characters
## Size in meters of a quadrant square's side
const QUAD_SIZE: float = 5.0
## Radius in meters the treasure can generate within
const SEARCH_RADIUS: float = 160


func _generate_treasure():
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	@warning_ignore("narrowing_conversion")

	Globals.treasure_quadrant = Vector2i(rng.randi_range(-SEARCH_RADIUS, SEARCH_RADIUS), rng.randi_range(-SEARCH_RADIUS, SEARCH_RADIUS))
	prints("generated treasure at quadrant:", str(Globals.treasure_quadrant))


func _ready():
	_generate_treasure()
	%HourglassPanel.draining_state = %HourglassPanel.DrainingState.DRAINING # ew direct reference of enum state like this is gross, but works here
	Globals.starting.emit()

#region dialogue
var dialogue_lines_to_play: Array[Dictionary] = []
var index_playing: int = 0


func _on_play_dialogue_sequence(lines: Array[Dictionary]): # {Actor : String}
	index_playing = 0
	dialogue_lines_to_play.assign(lines)
	play_dialogue_line()


func play_dialogue_line():
	%DialogueDisplay.show()
	var actor: Actor = dialogue_lines_to_play[index_playing]["actor"]
	var line: String = dialogue_lines_to_play[index_playing]["line"]

	match actor:
		Actor.PIRATE:
			%ParrotPortrait.hide()
			%PiratePortrait.show()
			%DialogueLabel.horizontal_alignment = SIDE_LEFT
		Actor.PARROT:
			%PiratePortrait.hide()
			%ParrotPortrait.show()
			%DialogueLabel.horizontal_alignment = SIDE_RIGHT

	%DialogueLabel.text = line

	if index_playing < dialogue_lines_to_play.size() - 1:
		if %DialogueTimer.timeout.is_connected(_on_close_dialogue):
			%DialogueTimer.timeout.disconnect(_on_close_dialogue)
		if not %DialogueTimer.timeout.is_connected(play_dialogue_line):
			%DialogueTimer.timeout.connect(play_dialogue_line)
	else:
		if %DialogueTimer.timeout.is_connected(play_dialogue_line):
			%DialogueTimer.timeout.disconnect(play_dialogue_line)
		if not %DialogueTimer.timeout.is_connected(_on_close_dialogue):
			%DialogueTimer.timeout.connect(_on_close_dialogue)

	index_playing += 1

	%DialogueTimer.start(float(line.length() * DIALOGUE_TIME))


func _on_close_dialogue():
	%DialogueDisplay.hide()
#endregion dialogue
