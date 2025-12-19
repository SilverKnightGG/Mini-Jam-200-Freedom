class_name Stage extends Node2D


var tile_grid: Dictionary[Vector2i, TileInfo] = {}
@export var grid_size: Vector2i = Vector2i(32, 32)

@onready var town: Node = %Town


func get_tile(tile_key: Vector2i) -> TileInfo:
	return tile_grid.get(tile_key)


## Gives a 'blank' tile grid its initial TileInfo resources.
func initialize_tile_grid(size: Vector2i):
	for x in size.x:
		for y in size.y:
			tile_grid[Vector2i(x, y)] = TileInfo.new()


## TODO Updates the texture region drawn for each tile.
func update_drawn_tiles():
	pass
