extends PanelContainer

var items_to_add : Array = []

@onready var v_box_container: VBoxContainer = $VBoxContainer

var availble_items := []

#func _ready() -> void:
	#$add_item_button.pressed.connect(_on_add_item_button_pressed)

func _on_add_item_button_pressed() -> void:
	add_item()

func add_item(item_id = null):
	var new_item_id_option = OptionButton.new()
	
	for attr_name in BroManager.ALL_DATA["layers"]["Player"]["Player"]["items"]:
		availble_items.append(attr_name)
		new_item_id_option.add_item(attr_name)
	
	if item_id != null:
		new_item_id_option.select(availble_items.find(item_id))
	
	v_box_container.add_child(new_item_id_option)
	
	items_to_add.append(new_item_id_option)

func import_data(data : Array):
	for item_id in data:
		add_item(item_id)

func get_data():
	
	if len(items_to_add) == 0:
		return
	
	var ret = []
	for item in items_to_add:
		ret.append(float(item.get_item_text(item.selected)))
	
	return ret
