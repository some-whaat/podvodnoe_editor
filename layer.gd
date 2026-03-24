extends FoldableContainer

var layer_ind : int

var layer_class_arrs : Dictionary # array by classes like Picture, NPC, ecs
var layer_class_arrs_objs : Dictionary

func initiate(layer_data : Dictionary):
	
	for key_class_name in layer_data:
		if key_class_name == "layer_ind":
			layer_ind = layer_data["layer_ind"]
			continue
		
		#var class_type : BroManager.ObjClass = BroManager.classnamestring_to_enum[key_class_name]
		
		layer_class_arrs[key_class_name] = layer_data[key_class_name]
		
		add_layer(key_class_name, layer_data[key_class_name])

func add_layer(class_type : String, data : Dictionary):
	
	for obj_key_name in data:
		create_object(class_type, obj_key_name, data[obj_key_name])
	
func create_object(class_type : String, obj_name : String, data : Dictionary):
	pass
