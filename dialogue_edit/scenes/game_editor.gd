extends VBoxContainer

var all_els : Dictionary

func _ready():
	import_from_file("res://game/World.json")
	
	
	#var child1 = create_item(root)
	#child1.set_text(0, "child1")
	##var child2 = create_item(root)
	#var subchild1 = create_item(child1)
	#subchild1.set_text(0, "Subchild1")


func create_spinbox_and_lable_return_spinbox(parent : Control, lable_text : String, curr_value : int) -> SpinBox:
	var hbox_cont = HBoxContainer.new()
	parent.add_child(hbox_cont)
	
	var lable = Label.new()
	lable.text = lable_text
	hbox_cont.add_child(lable)
	
	var spinbox = SpinBox.new()
	spinbox.value = curr_value
	hbox_cont.add_child(spinbox)
	
	return spinbox

func create_foldble_return_vbox(parent : Control, fold_name : String) -> VBoxContainer:
	var foldble = FoldableContainer.new()
	foldble.title = fold_name
	parent.add_child(foldble)
	
	var vbox = VBoxContainer.new()
	foldble.add_child(vbox)
	
	return vbox

func import_from_file(filename : String) -> void:
	BroManager.import_all_data_from_file(filename)
	
	
	if BroManager.ALL_DATA.find_key("camera_speed"):
		all_els["camera_speed"] = create_spinbox_and_lable_return_spinbox(self, "camera speed", BroManager.ALL_DATA["camera_speed"])
	
	if BroManager.ALL_DATA.find_key("border_poses"):
		all_els["border_poses"] = create_spinbox_and_lable_return_spinbox(self, "border poses", BroManager.ALL_DATA["border_poses"])
	
	
	var layers = create_foldble_return_vbox(self, "layers")
	
	for layer_name in BroManager.ALL_DATA["layers"]:

		var new_layer = create_foldble_return_vbox(layers, layer_name)
		
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
	match type:
		TYPE_DICTIONARY:
			var arr = create_foldble_return_vbox(parent, attr_name)
			var arr_links = []
			for key_el in arr_in_json:
				arr_links.append(create_input_control(arr, typeof(arr_in_json[key_el]), arr_in_json[key_el], key_el, arr_in_json[key_el]))
			
			return arr
		
		TYPE_ARRAY:
			var arr = create_foldble_return_vbox(parent, attr_name)
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
			parent.add_child(line)
			return line
			
		TYPE_BOOL:
			var check = CheckBox.new()
			check.button_pressed = current_value
			return check
	return Control.new()  # fallback
