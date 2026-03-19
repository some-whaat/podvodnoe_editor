extends VBoxContainer

var all_els : Dictionary

func _ready():
	import_from_file("res://game/World_test.json")
	
	
	#var child1 = create_item(root)
	#child1.set_text(0, "child1")
	##var child2 = create_item(root)
	#var subchild1 = create_item(child1)
	#subchild1.set_text(0, "Subchild1")

func create_checkbutton_and_lable_return_checkbutton(parent : Control, lable_text : String, curr_value : bool) -> CheckButton:
	var hbox_cont = HBoxContainer.new()
	parent.add_child(hbox_cont)
	hbox_cont.set_meta("title", lable_text)
	
	var lable = Label.new()
	lable.text = lable_text
	hbox_cont.add_child(lable)
	
	var checkbutton = CheckButton.new()
	checkbutton.button_pressed = curr_value
	hbox_cont.add_child(checkbutton)
	checkbutton.set_meta("title", lable_text)
	
	return checkbutton

func create_spinbox_and_lable_return_spinbox(parent : Control, lable_text : String, curr_value : int) -> SpinBox:
	var hbox_cont = HBoxContainer.new()
	parent.add_child(hbox_cont)
	hbox_cont.set_meta("title", lable_text)
	
	var lable = Label.new()
	lable.text = lable_text
	hbox_cont.add_child(lable)
	
	var spinbox = SpinBox.new()
	spinbox.value = curr_value
	hbox_cont.add_child(spinbox)
	spinbox.set_meta("title", lable_text)
	
	return spinbox

func create_foldble_return_vbox(parent : Control, fold_name : String) -> VBoxContainer:
	var foldble = FoldableContainer.new()
	foldble.title = fold_name
	#foldble.folded = true
	foldble.set_meta("title", fold_name)
	parent.add_child(foldble)
	
	var vbox = VBoxContainer.new()
	foldble.add_child(vbox)
	vbox.set_meta("title", fold_name)
	
	return vbox

func import_from_file(filename : String) -> void:
	BroManager.import_all_data_from_file(filename)
	
	
	if BroManager.ALL_DATA.find_key("camera_speed"):
		all_els["camera_speed"] = create_spinbox_and_lable_return_spinbox(self, "camera speed", BroManager.ALL_DATA["camera_speed"])
	
	if BroManager.ALL_DATA.find_key("border_poses"):
		all_els["border_poses"] = create_spinbox_and_lable_return_spinbox(self, "border poses", BroManager.ALL_DATA["border_poses"])
	
	
	var layers = create_foldble_return_vbox(self, "layers")
	layers.set_meta("is_arr", false)
	
	for layer_name in BroManager.ALL_DATA["layers"]:

		var new_layer = create_foldble_return_vbox(layers, layer_name)
		new_layer.set_meta("is_arr", false)
		
		all_els[layer_name] = {}
		
		for layer_el_name in BroManager.ALL_DATA["layers"][layer_name]:
			print(layer_el_name)
			var el = BroManager.ALL_DATA["layers"][layer_name][layer_el_name]
			var el_type = typeof(el)
			
			var el_instance = create_input_control(new_layer, el_type, el, layer_el_name, BroManager.ALL_DATA["layers"][layer_name][layer_el_name])
			all_els[layer_name][layer_el_name] = el_instance
			
			#if el_type == TYPE_ARRAY or el_type == TYPE_DICTIONARY:
				#print("el_type == TYPE_ARRAY or el_type == TYPE_DICTIONARY")
				#var new_layer_el_ = FoldableContainer.new()
				#new_layer_el_.title = layer_el_name
				#new_layer.add_child(new_layer_el_)
			#else:
				#var el_instance = create_input_control(new_layer, el_type, el, layer_el_name, BroManager.ALL_DATA["layers"][layer_name][layer_el_name])
				#all_els[layer_name][layer_el_name] = el_instance
				#




func create_input_control(parent : Control, type: Variant.Type, current_value, attr_name : String = "", arr_in_json = null) -> Control:
	if attr_name == "states":
		var butt = Button.new()
		butt.text = "states" + arr_in_json
		
		return butt
	
	match type:
		TYPE_DICTIONARY:
			var arr = create_foldble_return_vbox(parent, attr_name)
			arr.set_meta("is_arr", false)
			var arr_links = []
			for key_el in arr_in_json:
				arr_links.append(create_input_control(arr, typeof(arr_in_json[key_el]), arr_in_json[key_el], key_el, arr_in_json[key_el]))
			
			return arr
		
		TYPE_ARRAY:
			var arr = create_foldble_return_vbox(parent, attr_name)
			arr.set_meta("is_arr", true)
			var arr_links = []
			for el in arr_in_json:
				if typeof(el) == TYPE_ARRAY or typeof(el) == TYPE_DICTIONARY:
					arr_links.append(create_input_control(arr, typeof(el), el, "", current_value))
				else:
					arr_links.append(create_input_control(arr, typeof(el), el))
			return arr
		
		TYPE_INT:
			return create_spinbox_and_lable_return_spinbox(parent, attr_name, current_value)
			
		TYPE_FLOAT:
			return create_spinbox_and_lable_return_spinbox(parent, attr_name, current_value)
			
		TYPE_STRING:
			#if hint == PROPERTY_HINT_ENUM:
				#var option = OptionButton.new()
				#var enum_string = hint_string  # you'd need to pass hint_string as well
				## parse enum_string and add items...
				## option.select(option.get_item_index(current_value))
				#return option
			#else:
			
			var line = LineEdit.new()
			line.text = current_value
			line.set_meta("title", attr_name)
			parent.add_child(line)
			return line
			
		TYPE_BOOL:
			return create_checkbutton_and_lable_return_checkbutton(parent, attr_name, current_value)
			
	return Control.new()  # fallback

func get_data_from_node(node : Node):
	if node.has_method("get_data"):
		return node.get_data()
	
	match node.get_class():
		
		"HBoxContainer":
			return get_data_from_node(node.get_child(1))
		
		"FoldableContainer":
			return get_data_from_node(node.get_child(0))
		
		"VBoxContainer":
			var res
			
			print(node.get_meta("is_arr", true))
			if node.get_meta("is_arr", true):
				res = []
				for child in node.get_children():
					res.append(get_data(child))
				
			else:
				res = {}
				for child in node.get_children():
					res[child.get_meta("title", "")] = get_data(child)
			return res
		
		"LineEdit":
			return node.text
		
		"CheckBox":
			return node.button_pressed
		
		"SpinBox":
			return node.value
	
	print(node.get_class())


func get_data(el):
	if typeof(el) == TYPE_OBJECT:
		return get_data_from_node(el)
	
	var parsed_data : Dictionary = {}
	
	for key_name in el:
		parsed_data[key_name] = get_data(el[key_name])
		
	return parsed_data
	


func _on_save_butt_pressed() -> void:
	var save_data = {}
	save_data["layers"]= get_data(all_els)
	
	BroManager.save_to_json_file(save_data, "res://game/World_test.json")
