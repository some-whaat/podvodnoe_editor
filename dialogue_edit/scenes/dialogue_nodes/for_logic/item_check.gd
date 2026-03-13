extends PanelContainer

@onready var item_id: SpinBox = $item_id/item_id
@onready var item_state: CheckBox = $item_state/item_state


func _on_item_state_toggled(toggled_on: bool) -> void:
	item_state.text = "has" if toggled_on else "dosn't have"
