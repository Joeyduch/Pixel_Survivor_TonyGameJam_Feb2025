class_name RandomSelector extends Resource

## item format: [value:Variant, chance:float]
@export var item_list:Array[Array] = []: set = set_item_list



func _init(list:Array[Array]) -> void:
	set_item_list(list)



func set_item_list(new_item_list:Array[Array]) -> void:
	# save copy of list and update to new list
	var old_list:Array[Array] = item_list.duplicate()
	item_list = new_item_list
	# make sure new_item_list is valid, otherwise revert to old list
	if new_item_list.size() <= 0:
		item_list = old_list
	elif new_item_list[0].size() != 2:
		push_error("new_item_list sub arrays should have a length of 2 ([value, chance])")
		item_list = old_list


func roll_item() -> Variant:
	if item_list.size() <= 0: return null
	# sort list by chance
	var sort_function:Callable = func(a:Array[Variant],b:Array[Variant]) -> bool: return bool(a[1] < b[1])
	var sorted_list:Array[Array] = item_list.duplicate()
	sorted_list.sort_custom(sort_function)
	
	# roll chance for all items
	var chosen_value:Variant = sorted_list[sorted_list.size()-1][0] # defaults at most probable item
	var chance_weight:float = 0
	for item:Variant in sorted_list:
		if item.size() >= 3: continue
		var value:Variant = item[0];
		var chance:float = item[1]
		
		chance_weight += chance
		var random:float = randf()
		if random <= chance_weight:
			chosen_value = value
			break
	
	# returns chosen item
	return chosen_value
