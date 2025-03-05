class_name GridArray extends Resource

# the types of border
enum BORDER_TYPE {UP, RIGHT, DOWN, LEFT}

# the 2D array containing all data, shouldn't be accessed outside of this script
var _grid_data:Array[Array] = []

# grid sizes, automatically set by init, full_clear, full_copy, etc.
# SHOULD BE READ-ONLY outside of this script
var width:int = 0
var height:int = 0

 

# constructor function
func _init(grid_width:int, grid_height:int, base_value:Variant=null) -> void:
	deep_clear(grid_width, grid_height, base_value)



# resets the grid data (array, width, height, etc.) based on grid_width and grid_height
func deep_clear(grid_width:int, grid_height:int, base_value:Variant=null) -> void:
	width = grid_width
	height = grid_height
	_grid_data = []
	for y:int in range(grid_height):
		_grid_data.append([])
		for x:int in range(grid_width):
			_grid_data[y].append(base_value)


# sets the entire existing cells to the base_value
func clear(base_value:Variant=null) -> void:
	for y:int in range(_grid_data.size()):
		if not _grid_data[y]:
			push_warning("No GridArray data found to clear")
			return
		for x:int in range(_grid_data[y].size()):
			_grid_data[y][x] = base_value


# checks if grid_position is out of bound
func is_out_of_bound(grid_position:Vector2i) -> bool:
	return grid_position.x<0 or grid_position.x>=width or grid_position.y<0 or grid_position.y>=height


# sets a value (whatever type) at a grid_position on the _grid_data
func set_value(grid_position:Vector2i, value:Variant, is_ignoring_out_of_bounds_error:bool=false) -> void:
	if is_out_of_bound(grid_position):
		if not is_ignoring_out_of_bounds_error:
			push_error("trying to set a GridArray value out of bound")
		return
	_grid_data[grid_position.y][grid_position.x] = value


# get the value stored at the _grid_data's grid_position
func get_value(grid_position:Vector2i, is_ignoring_out_of_bounds_error:bool=false) -> Variant:
	if is_out_of_bound(grid_position):
		if not is_ignoring_out_of_bounds_error:
			push_error("trying to get a GridArray value out of bound")
		return null
	return _grid_data[grid_position.y][grid_position.x]


# copies the values from another grid, but doesnt reset this GridArray's data
func copy_from_grid(grid:GridArray) -> void:
	for y:int in range(grid.height):
		for x:int in range(grid.width):
			var position:Vector2i = Vector2i(x, y)
			set_value(position, grid.get_value(position))


# reset this GridArray's data based on another grid, also copying all of it's values
func deep_copy_from_grid(grid:GridArray) -> void:
	width = grid.width
	height = grid.height
	_grid_data = []
	for y:int in range(grid.height):
		_grid_data.append([])
		for x:int in range(grid.width):
			_grid_data[y].append(grid.get_value(Vector2i(x, y)))


# checks if a grid_position is at the border/edge of the _grid_data (next to out-of-bound)
func is_border(grid_position:Vector2i) -> bool:
	return grid_position.x==0 or grid_position.x==width-1 or grid_position.y==0 or grid_position.y==height-1


# returns an Array of BORDER_TYPE depending of which borders/edge the grid_position is at
func get_border_types(grid_position:Vector2i) -> Array[BORDER_TYPE]:
	var border_types:Array[BORDER_TYPE] = []
	if grid_position.x==0:
		border_types.append(BORDER_TYPE.LEFT)
	if grid_position.x==width-1:
		border_types.append(BORDER_TYPE.RIGHT)
	if grid_position.y==0:
		border_types.append(BORDER_TYPE.UP)
	if grid_position.y==height-1:
		border_types.append(BORDER_TYPE.DOWN)
	return border_types


# returns an Array of all the Vector2i positions of any given value
func get_positions_of_value(value:Variant) -> Array[Vector2i]:
	var positions:Array[Vector2i] = []
	for y:int in range(_grid_data.size()):
		if not _grid_data[y]:
			push_warning("No GridArray data found to clear")
			return []
		for x:int in range(_grid_data[y].size()):
			var position:Vector2i = Vector2i(x,y)
			if get_value(position) == value:
				positions.append(position)
	return positions
