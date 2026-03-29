extends Container

@onready var tab_container: TabContainer = $TabContainer
@onready var world_preview: RichTextLabel

signal add_editor_element(editor_element)
const WORLD_PREVIEW = preload("res://dialogue_edit/scenes/world_preview.tscn")


func _ready() -> void:
	#world_preview = WORLD_PREVIEW.instantiate()
	#tab_container.add_child(world_preview)
	
	add_editor_element.connect(_on_add_editor_element)
	

func _on_add_editor_element(editor_element):
	tab_container.add_child(editor_element)


func switch_to_tab_by_title(title: String):
	for i in range(tab_container.get_tab_count()):
		if tab_container.get_tab_title(i) == title:
			tab_container.current_tab = i
			return
	
	print("Tab not found: ", title)



func update_visuals(obj_name : String, image_arr : Array, pos : Vector2i, color : Array, add_paralax):
	$TabContainer/world_preview.update_visuals(obj_name, image_arr, pos, color, add_paralax)
