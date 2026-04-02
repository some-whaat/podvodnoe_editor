extends Control

@onready var spin_box_with_get_data: SpinBox = $SpinBoxWithGetData
var check_butt
var check_butt_on_text = "has"
var check_butt_off_text = "doesn't have"

func get_data():
    if check_butt:
        return [check_butt.button_pressed, spin_box_with_get_data.value]
        
    return spin_box_with_get_data.value

func add_check_butt(state : bool, on_str : String = "has", off_str : String = "doesn't have"):
    check_butt_on_text = on_str
    check_butt_off_text = off_str
    
    check_butt = CheckButton.new()
    add_child(check_butt)
    check_butt.toggled.connect(_on_check_butt_toggled)
    
func set_value(val):
    spin_box_with_get_data.value = val

func _on_check_butt_toggled(state : bool):
    check_butt.text = check_butt_on_text if state else check_butt_off_text
