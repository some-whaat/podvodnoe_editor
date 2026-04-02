extends Control

@onready var mission_state: CheckBox = $mission_check/mission_state/mission_state

func _ready() -> void:
    mission_state.toggled.connect(_on_item_state_toggled)

func _on_item_state_toggled(toggled_on: bool) -> void:
    mission_state.text = "has" if toggled_on else "dosn't have"
