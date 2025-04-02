class_name AutoTileMap extends TileMapLayer

@export var map_start:Vector2i = Vector2i(0,0)
@export var map_size:Vector2i = Vector2i(10,10)

var DIRECTIONS:Dictionary = {
	TOPLEFT = Vector2i(-1, -1),
	TOP = Vector2i(0, -1),
	TOPRIGHT = Vector2i(1, -1),
	LEFT = Vector2i(-1, 0),
	RIGHT = Vector2i(1, 0),
	BOTTOMLEFT = Vector2i(-1, 1),
	BOTTOM = Vector2i(0, 1),
	BOTTOMRIGHT = Vector2i(1,1),
}

@export var tile_coords:Dictionary = {
	full = Vector2i(3,1),
	empty = Vector2i(1,1),
	
	topleft = Vector2i(0,0),
	top = Vector2i(1,0),
	topright = Vector2i(2,0),
	left = Vector2i(0,1),
	right = Vector2i(2,1),
	bottomleft = Vector2i(0,2),
	bottom = Vector2i(1,2),
	bottomright = Vector2i(2,2),
	
	pathsingle = Vector2i(3,2),
	pathleft = Vector2i(3,0),
	pathhorizontal = Vector2i(4,0),
	pathright = Vector2i(5,0),
	pathtop = Vector2i(4,1),
	pathvertical = Vector2i(4,2),
	pathbottom = Vector2i(5,1),
}

@onready var tile_full:Vector2i = tile_coords.full
@onready var tile_empty:Vector2i = tile_coords.empty

@onready var grid:GridArray = GridArray.new(0,0)



func _input(event:InputEvent) -> void:
	if event.is_action_pressed("Map_Regen"):
		pass #generate()



func reset() -> void:
	clear()
	grid = GridArray.new(map_size.x, map_size.y, 0)


func carve_patches(grid_array:GridArray, patch_amount:int, patch_steps:int) -> void:
	for patch:int in range(patch_amount):
		var position_x:int = randi_range(0, grid_array.width-1)
		var position_y:int = randi_range(0, grid_array.height-1)
		for step:int in range(patch_steps):
			grid_array.set_value(Vector2i(position_x, position_y), 1)
			var possible_moves:Array[int] = [-1,1]
			var movement:int = possible_moves[randi() % possible_moves.size()]
			if randf() <= 0.5:
				position_x = clamp(position_x + movement, 0, grid_array.width-1)
			else:
				position_y = clamp(position_y + movement, 0, grid_array.height-1)


func fill_chunk_autotile(grid_array:GridArray, start_position:Vector2i, is_autotile_disabled:bool=false) -> void:
	var empty_tiles:Array[Vector2i] = grid_array.get_positions_of_value(1)
	# turn dirt tiles into autotiles
	for tile:Vector2i in empty_tiles:
		var current_position:Vector2i = start_position + tile
		
		if is_autotile_disabled:
			set_cell(current_position, 0, tile_empty)
			continue
		
		# are surrounding cells empty
		var is_top:bool = grid_array.get_value(tile + DIRECTIONS.TOP, true) == 0
		var is_left:bool = grid_array.get_value(tile + DIRECTIONS.LEFT, true) == 0
		var is_right:bool = grid_array.get_value(tile + DIRECTIONS.RIGHT, true) == 0
		var is_bottom:bool = grid_array.get_value(tile + DIRECTIONS.BOTTOM, true) == 0
		
		# CHECK FULL
		if is_top and is_left and is_right and is_bottom:
			set_cell(current_position, 0, tile_coords.pathsingle)
		
		# CHECK PATHS
		# check horizontal path
		elif is_top and is_bottom:
			var chosen:Vector2i = tile_coords.pathhorizontal
			if is_left:
				chosen = tile_coords.pathleft
			elif is_right:
				chosen = tile_coords.pathright
			set_cell(current_position, 0, chosen)
		# check vertical path
		elif is_left and is_right:
			var chosen:Vector2i = tile_coords.pathvertical
			if is_top:
				chosen = tile_coords.pathtop
			elif is_bottom:
				chosen = tile_coords.pathbottom
			set_cell(current_position, 0, chosen)
		
		# CHECK CORNERS
		# check if topleft corner
		elif is_left and is_top:
			set_cell(current_position, 0, tile_coords.topleft)
		# check if topright corner
		elif is_top and is_right:
			set_cell(current_position, 0, tile_coords.topright)
		# check if bottomright corner
		elif is_right and is_bottom:
			set_cell(current_position, 0, tile_coords.bottomright)
		# check if bottomleft corner
		elif is_bottom and is_left:
			set_cell(current_position, 0, tile_coords.bottomleft)
		
		# CHECK SIDES
		# check if top side
		elif is_top:
			set_cell(current_position, 0, tile_coords.top)
		# check if right side
		elif is_right:
			set_cell(current_position, 0, tile_coords.right)
		# check if bottom side
		elif is_bottom:
			set_cell(current_position, 0, tile_coords.bottom)
		# check if left side
		elif is_left:
			set_cell(current_position, 0, tile_coords.left)
		
		# EMPTY CELL
		else:
			set_cell(current_position, 0, tile_empty)


func fill_chunk_empty_cells(grid_array:GridArray, start_position:Vector2i, cell_atlas_coord:Vector2i) -> void:
	for x:int in range(grid_array.width):
		for y:int in range(grid_array.height):
			var current_position:Vector2i = start_position + Vector2i(x,y)
			var current_cell:int = grid_array.get_value(current_position)
			if current_cell == 0:
				set_cell(current_position, 0, cell_atlas_coord)


func generate() -> void:
	var patch_amount:int = ceil(map_size.x * map_size.y / 100.0) # 1% of total area
	var patch_size:int = 32
	reset()
	carve_patches(grid, patch_amount, patch_size)
	fill_chunk_autotile(grid, map_start, false)
	fill_chunk_empty_cells(grid, map_start, tile_full)
