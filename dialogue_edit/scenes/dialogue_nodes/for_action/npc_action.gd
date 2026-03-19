extends GraphNode

var state_index
const type : BroManager.DialNodeType = BroManager.DialNodeType.NPC_ACTION

@onready var add_items_k: PanelContainer = $VBoxContainer/add_items
@onready var take_items_k: PanelContainer = $VBoxContainer/take_items
@onready var change_atts_k: PanelContainer = $VBoxContainer/change_atts


func get_data():
	var res_data : Dictionary = {}
	
	var add_items = add_items_k.get_data() # arr[int] or null
	if add_items:
		res_data["add_item(s)"] = add_items
	
	var take_items = take_items_k.get_data() # arr[int] or null
	if take_items:
		res_data["take_items(s)"] = take_items
	
	var change_atts = change_atts_k.get_data() # arr[int] or null
	if change_atts:
		res_data["change_atts"] = change_atts
	
	return res_data

#var add_items_list = []

#func _on_add_item_pressed() -> void:
	#var new_node = ADD_ITEMS.instantiate()
	#add_child(new_node)
	#add_items_list.append(new_node)
	#
#
#func set_data(data : Dictionary):
	#var data_copy = data.duplicate()
	#dialogue = data_copy["dialogue"].pop_front()
	#
	#for line in data_copy["dialogue"]:
		#add_new_text_edit(line)
	#
	#if data_copy.find_key("text_width"):
		#text_width.value = data_copy["text_width"]
