extends Container

@onready var tab_container: TabContainer = $TabContainer

signal add_editor_element(editor_element)


func _ready() -> void:
	add_editor_element.connect(_on_add_editor_element)
	

func _on_add_editor_element(editor_element):
	tab_container.add_child(editor_element)


func switch_to_tab_by_title(title: String):
	for i in range(tab_container.get_tab_count()):
		if tab_container.get_tab_title(i) == title:
			tab_container.current_tab = i
			return
	
	print("Tab not found: ", title)
