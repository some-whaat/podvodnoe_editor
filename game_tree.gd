extends Tree


var all_els : Dictionary

func _ready():
	import_from_file("res://game/World.json")
	
	
	#var child1 = create_item(root)
	#child1.set_text(0, "child1")
	##var child2 = create_item(root)
	#var subchild1 = create_item(child1)
	#subchild1.set_text(0, "Subchild1")

func import_from_file(filename : String) -> void:
	BroManager.import_all_data_from_file(filename)
	
	var root = create_item()
	hide_root = true
	
	if BroManager.ALL_DATA.find_key("camera_speed"):
		var camera_speed = create_item(root)
		camera_speed.set_text(0, "camera speed")
	
	if BroManager.ALL_DATA.find_key("border_poses"):
		var border_poses = create_item(root)
		border_poses.set_text(0, "border_poses")
	
	var layers = create_item(root)
	layers.set_text(0, "layers")
	
	for layer_name in BroManager.ALL_DATA["layers"]:
		var new_layer =  create_item(layers)
		new_layer.set_text(0, layer_name)
		
		for layer_el_name in BroManager.ALL_DATA["layers"][layer_name]:
			var new_layer_el =  create_item(new_layer)
			new_layer_el.set_text(0, layer_el_name)
