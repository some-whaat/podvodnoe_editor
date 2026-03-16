extends PanelContainer

var items_to_add : Array = []

@onready var v_box_container: VBoxContainer = $VBoxContainer

#func _ready() -> void:
	#$add_item_button.pressed.connect(_on_add_item_button_pressed)

func _on_add_item_button_pressed() -> void:
	var new_item_id_option = OptionButton.new()
	
	for attr_name in BroManager.player_data["Player"]["items"]:
		new_item_id_option.add_item(attr_name)
		
	v_box_container.add_child(new_item_id_option)
	
	items_to_add.append(new_item_id_option)

func get_data():
	
	if len(items_to_add) == 0:
		return
	
	var ret = []
	for item in items_to_add:
		ret.append(float(item.get_item_text(item.selected)))
	
	return ret
