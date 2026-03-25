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

func init(attr_name : String, data = null) -> void:
	add_att_el_butt.text = "+ " + attr_name
	
	if data != null:
		_on_check_button_toggled(data[0])
		
		for el in data[1]:
			add_new_att_el(el)

func _on_add_att_el_butt_pressed() -> void:
	add_new_att_el()

func add_new_att_el(el_data = null):
	var new_attr = SpinBox.new()
	v_box_container.add_child(new_attr)
	added_els.append(new_attr)
	
	if el_data != null:
		new_attr.value = el_data


func _on_check_button_toggled(toggled_on: bool) -> void:
	check_button.text = "add" if toggled_on else "remove"
