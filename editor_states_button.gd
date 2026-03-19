extends Button

var data_path
const DIALOGUE_GRATH = preload("res://dialogue_edit/dialogue_grath.tscn")
var where_spawn_grath_edit : Node

var dial_grath_instance

func _on_pressed() -> void:
	dial_grath_instance = DIALOGUE_GRATH.instantiate()
	dial_grath_instance
	
	where_spawn_grath_edit
