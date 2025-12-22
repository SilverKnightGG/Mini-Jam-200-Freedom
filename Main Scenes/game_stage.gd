class_name GameStage extends Node


## Size in meters of a quadrant square's side
const QUAD_SIZE: float = 5.0
## Distance in meters-across a circle the treasure can generate within
const SEARCH_DIAMETER: float = 320
const SEED_MULT: float = 521481


func _generate_treasure():
	var rng_seed: int = roundi(Globals.elapsed_time * SEED_MULT)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.set_seed(rng_seed)
	@warning_ignore("narrowing_conversion")
	Globals.treasure_quadrant = Vector2i(rng.randi() * SEARCH_DIAMETER, rng.randi() * SEARCH_DIAMETER)
	Globals.treasure_quadrant -= Vector2i(SEARCH_DIAMETER, SEARCH_DIAMETER) / 2


func _ready():
	_generate_treasure()
