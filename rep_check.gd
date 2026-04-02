extends VSplitContainer

@onready var rep_state: CheckButton = $rep_state/rep_state


func _on_rep_state_toggled(toggled_on: bool) -> void:
    rep_state.text = "more" if toggled_on else "less"
