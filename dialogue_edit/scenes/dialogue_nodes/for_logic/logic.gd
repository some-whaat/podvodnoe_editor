extends GraphNode


var state_index
const type : BroManager.DialNodeType = BroManager.DialNodeType.LOGIC

const ITEM_CHECK = preload("res://dialogue_edit/scenes/dialogue_nodes/for_logic/item_check.tscn")
const MISSIONS_CHECK = preload("res://dialogue_edit/scenes/dialogue_nodes/for_logic/missions_check.tscn")


var added_item_checks := []
var added_mission_check := []

func _on_add_item_check_pressed() -> void:
	var new_item_check := ITEM_CHECK.instantiate()
	add_child(new_item_check)
	
	added_item_checks.append(new_item_check)


func _on_add_mission_check_pressed() -> void:
	var new_mission_check := MISSIONS_CHECK.instantiate()
	add_child(new_mission_check)
	
	added_mission_check.append(new_mission_check)

func get_data():
	pass

func set_data(data : Dictionary):
	pass
