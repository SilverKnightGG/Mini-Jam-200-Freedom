class_name GameStage extends Node


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
