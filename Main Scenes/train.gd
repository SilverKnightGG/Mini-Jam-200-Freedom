class_name Train extends Node

const BASE_TILE_TRAVERSE_TIME: float = 1.0

var security: float = 1.0
var danger: float = 1.0
var train_speed: float = 1.0

var cargo: Dictionary[Town.ExtractableResource, float] = {}

@export_range(0.0, 50.0, 1.0) var stolen_value_base: float = 5.0

@onready var tile_timer: Timer = %TileTimer


# TODO build this out to handle whatever happens when an upgrade for the train is purchased.
# Increases train cars, efficiency, etc...  (it might just be cars and efficiency, tbh)
func receive_item(item: Variant):
	pass


func resources_stolen():
	if not security < danger:
		return

	var losing_amount: float = danger/security * stolen_value_base

	# TODO tween effect for resources being stolen and deduct from a random resource (weighted based on stage parameters)
	# The concept of stolen resources needs more time to cook, for sure.


func resources_gained():
	# TODO I'll put the tween for gaining resources from tiles, here.
	pass


func embark():
	tile_timer.start(train_speed/BASE_TILE_TRAVERSE_TIME)


func _on_tile_traversed():
	resources_gained()
	resources_stolen()


func _ready():
	if not tile_timer.timeout.is_connected(_on_tile_traversed):
		tile_timer.timeout.connect(_on_tile_traversed)
