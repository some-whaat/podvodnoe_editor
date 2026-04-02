extends Control


const MISSIONS_CHECK = preload("res://dialogue_edit/scenes/dialogue_nodes/for_logic/missions_check.tscn")
const REP_CHECK = preload("res://dialogue_edit/scenes/dialogue_nodes/for_logic/rep_check.tscn")

var added_missin_checks := []
var added_rep_checks := []


func _on_add_missions_check_pressed() -> void:
    var mis_check = MISSIONS_CHECK.instantiate()
    added_missin_checks.append(mis_check)
    
    add_child(mis_check)

func _on_add_rep_check_pressed() -> void:
    var rep_check = REP_CHECK.instantiate()
    added_rep_checks.append(rep_check)
    
    add_child(rep_check)
