extends Container

@onready var tab_container: TabContainer = $TabContainer

signal add_editor_element(editor_element)


func _ready() -> void:
	add_editor_element.connect(_on_add_editor_element)
	

func _on_add_editor_element(editor_element):
	tab_container.add_child(editor_element)
	
