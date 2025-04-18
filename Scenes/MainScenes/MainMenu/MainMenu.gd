class_name MainMenu extends CanvasLayer

const scene_main_game:PackedScene = preload("res://Scenes/MainScenes/Game/Main.tscn")

@onready var audio_selection:AudioStreamPlayer = $Audio/SelectionAudio
@onready var audio_confirm:AudioStreamPlayer = $Audio/ConfirmAudio

@onready var background_map:AutoTileMap = $BackgroundMap
@onready var color_overlay:UIColorOverlay = $MenuContainer/UIColorOverlay
@onready var choices_container:MainMenuChoicesContainer = $MenuContainer/Menu/ChoicesContainer

const map_sizes:Array[Array] = [
	["small", Vector2i(20, 12)],
	["medium", Vector2i(32, 24)],
	["large", Vector2i(48, 32)],
	["x-large", Vector2i(64, 48)]
]

var map_size_index:int = 0: set = set_map_size_index, get = get_map_size_index

var is_ignoring_inputs:bool = false



func _ready() -> void:
	color_overlay.fade_out()
	background_map.generate()
	
	choices_container.connect("selection_confirmed", _on_choices_container_selection_confirmed)
	map_size_index = 1


func _input(event:InputEvent) -> void:
	if is_ignoring_inputs: return
	
	if event.is_action_pressed("Control_Down"):
		audio_selection.play()
		choices_container.select_next()
	
	elif event.is_action_pressed("Control_Up"):
		audio_selection.play()
		choices_container.select_previous()
	
	elif event.is_action_pressed("Control_A"):
		audio_confirm.play()
		choices_container.confirm_selection()



func set_map_size_index(index:int) -> void:
	var map_sizes_amount:int = map_sizes.size()
	if map_sizes_amount == 0:
		map_size_index = map_size_index
		return
	
	if index < 0:
		index = map_sizes_amount-1
	if index >= map_sizes_amount:
		index = 0
	
	map_size_index = index
	
	var new_map_size_name:String = map_sizes[map_size_index][0]
	var new_map_size:Vector2i = map_sizes[map_size_index][1]
	choices_container.map_choice_label.text = "map size: %s" % [new_map_size_name]
	GameData.settings["map_size"] = new_map_size

func get_map_size_index() -> int:
	return map_size_index



func _on_choices_container_selection_confirmed(selected_menu_label:String) -> void:
	if selected_menu_label == "New":
		is_ignoring_inputs = true
		color_overlay.fade_in()
		await color_overlay.animation_player.animation_finished
		get_tree().change_scene_to_packed(scene_main_game)
	
	elif selected_menu_label == "Map":
		map_size_index += 1
	
	elif selected_menu_label == "Quit":
		is_ignoring_inputs = true
		color_overlay.fade_in()
		await color_overlay.animation_player.animation_finished
		get_tree().quit()
