class_name MainMenuChoicesContainer extends VBoxContainer

signal selection_confirmed(selection_menu_label:String)

@onready var label_settings:Dictionary[String,LabelSettings] = {
	"TextDefault": preload("res://Assets/LabelSettings/LSText.tres"),
	"TextSelected": preload("res://Assets/LabelSettings/LSTextYellow.tres")
}

@onready var map_choice_label:MenuChoiceLabel = $ChoiceMap

var selection_index:int = 0: set = set_selection_index, get = get_selection_index



func _ready() -> void:
	selection_index = 0



# ----------
# METHODS
# ----------

# selection

func set_selection_index(index:int) -> void:
	var choice_labels:Array[MenuChoiceLabel] = get_choice_labels()
	var old_index:int = selection_index
	
	var max_index:int = choice_labels.size() -1
	if max_index < 0: return
	
	if index < 0:
		index = max_index
	elif index > max_index:
		index = 0
	
	selection_index = index
	
	choice_labels[old_index].label_settings = label_settings["TextDefault"]
	choice_labels[selection_index].label_settings = label_settings["TextSelected"]

func get_selection_index() -> int: return selection_index


func select_next() -> void:
	selection_index += 1

func select_previous() -> void:
	selection_index -= 1


func confirm_selection() -> void:
	var choice_menu_label:String = get_menu_label_from_index(selection_index)
	if choice_menu_label == "ERROR": return
	
	selection_confirmed.emit(choice_menu_label)


# fetching

func get_choice_labels() -> Array[MenuChoiceLabel]:
	var labels:Array[MenuChoiceLabel] = []
	var children:Array[Node] = get_children()
	
	for node:Node in children:
		if node is MenuChoiceLabel:
			labels.append(node)
	
	return labels


func get_menu_label_from_index(index:int) -> String:
	var labels:Array[MenuChoiceLabel] = get_choice_labels()
	if index < 0 or index >= labels.size(): return "ERROR"
	return labels[index].menu_label
