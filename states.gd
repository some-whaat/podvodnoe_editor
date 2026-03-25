extends Control

#@onready var file_loader: HBoxContainer = $file_loader
var defult_state = 0
const DIALOGUE_GRATH = preload("res://dialogue_edit/dialogue_grath.tscn")

var states_data : Dictionary

var main_main_editor : Node

func _ready() -> void:
	main_main_editor = get_tree().get_root().get_child(-1)

func _on_edit_states_button_pressed() -> void:
	var new_dial_grath = DIALOGUE_GRATH.instantiate()
	
	main_main_editor._on_add_editor_element(new_dial_grath)
	new_dial_grath.import_from_states_data(states_data, defult_state)
