extends FoldableContainer

@onready var object_holder: VBoxContainer = $object_holder
const SUBCLASS = preload("res://main_editor/layer/subclass.tscn")

var class_type : String

var subclasses : Dictionary = {} # class_type_name : obg

func create_object(_class_type : String, obj_name : String, data : Dictionary):
	title = obj_name
	class_type = _class_type
	
	for class_type_name in data:#BroManager.class_order:
		
		#if data.has(class_type_name):
		create_subclass(class_type_name, data[class_type_name])
		
		#if class_type_name == class_type:
			#break

func create_subclass(class_type_name : String, data : Dictionary):
	var subclass = SUBCLASS.instantiate()
	subclass.initiate(class_type_name, data[class_type_name])
	
	object_holder.add_child(subclass)
