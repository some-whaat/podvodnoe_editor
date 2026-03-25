extends FoldableContainer

var layer_ind : int

var layer_class_arrs : Dictionary # array by classes like Picture, NPC, ecs
var layer_class_arrs_objs : Dictionary

const OBJECT = preload("res://main_editor/layer/object.tscn")
@onready var layer_vbox: VBoxContainer = $layer_vbox

func initiate(layer_data : Dictionary, layer_name : String):
	
	title = layer_name
	if layer_name != "Player":
		for key_class_name in layer_data:
			print("from ", name, " ",  layer_name, ", key_class_name -- ", key_class_name)
			if key_class_name == "layer_ind":
				layer_ind = layer_data["layer_ind"]
				continue
			if key_class_name == "do_needs_player":
				continue
			#var class_type : BroManager.ObjClass = BroManager.classnamestring_to_enum[key_class_name]
			
			layer_class_arrs[key_class_name] = layer_data[key_class_name]
			
			add_layer(key_class_name, layer_data[key_class_name])

func add_layer(class_type : String, data : Dictionary):
	
	for obj_key_name in data:
		if class_type != "ParticleSystem":
			create_object(class_type, obj_key_name, data[obj_key_name])
	
func create_object(class_type : String, obj_name : String, data : Dictionary):
	var new_obj = OBJECT.instantiate()
	layer_vbox.add_child(new_obj)
	new_obj.initiate(class_type, obj_name, data)
