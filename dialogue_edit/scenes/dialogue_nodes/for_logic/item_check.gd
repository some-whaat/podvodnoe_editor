extends PanelContainer

@onready var item_id: SpinBox = $item_check/item_id/item_id
@onready var item_state: CheckBox = $item_check/item_state/item_state


func _on_item_state_toggled(toggled_on: bool) -> void:
    item_state.text = "has" if toggled_on else "dosn't have"

func get_item_id():
    return item_id.value

func get_item_state():
    return item_state.button_pressed

func set_data(data):
    item_id.value = data["needed_item_id"]
    item_state.button_pressed = data["needed_item_state"]
