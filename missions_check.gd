extends Control

const MISSION_CHECK = preload("res://dialogue_edit/scenes/dialogue_nodes/for_logic/mission_check.tscn")
@onready var missions_check: VBoxContainer = $missions_check

var mission_checks := []

func _on_button_pressed() -> void:
	var mis_check = MISSION_CHECK.instantiate()
	
	missions_check.add_child(mis_check)
	
	mission_checks.append(mis_check)
