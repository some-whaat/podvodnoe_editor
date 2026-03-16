extends PanelContainer


@onready var add_att_el_butt: Button = $VBoxContainer/add_att_el_butt
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var check_button: CheckButton = $VBoxContainer/CheckButton

var added_els = []

func get_data():
	var res = []
	res[0] = check_button.button_pressed
	res[1] = []
	
	for el in added_els:
		res[1].append(el.value)
	
	return res

func init(attr_name : String) -> void:
	add_att_el_butt.text = "+ " + attr_name

func _on_add_att_el_butt_pressed() -> void:
	var new_attr = SpinBox.new()
	v_box_container.add_child(new_attr)
	added_els.append(new_attr)


func _on_check_button_toggled(toggled_on: bool) -> void:
	check_button.text = "add" if toggled_on else "remove"
