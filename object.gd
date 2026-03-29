extends FoldableContainer

@onready var object_holder: VBoxContainer = $object_holder
const SUBCLASS = preload("res://main_editor/layer/subclass.tscn")

var class_type : String
var object_name : String

var subclasses : Dictionary = {} # class_type_name : obg

var type_of_rendering : String # Picture or AnimatbleObj

var main_main_editor : Container

func _ready() -> void:
	main_main_editor = get_tree().get_root().get_child(-1)

func initiate(_class_type : String, obj_name : String, data : Dictionary):
	title = obj_name
	object_name = obj_name
	class_type = _class_type
	
	for class_type_name in data: #BroManager.class_order:
		
		#if data.has(class_type_name):
		create_subclass(class_type_name, data[class_type_name])
		
		if class_type_name == "Picture" or class_type_name == "AnimatbleObj":
			type_of_rendering = class_type_name
		
		#if class_type_name == class_type:
			#break
	update_visuals()

func update_visuals():
	var export_image_arr : Array =[[]]
	var export_image_str : String
	var image_filename : String
	
	if type_of_rendering == "Picture":
		image_filename = subclasses["Picture"].export_data["sprite_filepame"].curr_file
		export_image_str = BroManager.load_text_file( "res://game/" + image_filename)
	elif type_of_rendering == "AnimatbleObj":
		image_filename = subclasses["AnimatbleObj"].export_data["animated_sprite_filepame"].curr_file
		export_image_str = BroManager.load_text_file( "res://game/" + image_filename)
		export_image_str = export_image_str.split('7')[0]
	else:
		print("type_of_rendering " + type_of_rendering + " is incorrect in object.gd")
	
	for image_char in export_image_str:
		#if image_char == '?':
			#export_image_arr[-1].append(' ')
		if image_char == '\n':
			export_image_arr.append([])
		elif image_char == '\t':
			export_image_arr[-1] += [' ', ' ', ' ', ' ']
		else:
			export_image_arr[-1].append(image_char)
	
	if len(export_image_arr[-1]) < 1:
		export_image_arr.pop_back()
	
	#print("from ", type_of_rendering, " ", object_name, " update_visuals()")
	#print(export_image_str)
	
	var pos = Vector2i(subclasses["Position"].export_data["x"].value, subclasses["Position"].export_data["y"].value)
	var add_paralax = subclasses["RendrbleObject"].export_data["add_paralax"].value
	var color = []
	for spinbox in subclasses["RendrbleObject"].export_data["color"]:
		color.append(spinbox.value)
		
	main_main_editor.update_visuals(object_name, export_image_arr, pos, color, add_paralax)

func create_subclass(class_type_name : String, data : Dictionary):
	var subclass = SUBCLASS.instantiate()
	object_holder.add_child(subclass)
	subclass.initiate(class_type_name, data, object_name)
	
	subclasses[class_type_name] = subclass
	
