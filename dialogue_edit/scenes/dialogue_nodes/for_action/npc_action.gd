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

func set_data(data : Dictionary):
    
    if data.has("add_item(s)"):
        add_items_k.import_data(data["add_item(s)"])
    
    if data.has("take_items(s)"):
        take_items_k.import_data(data["take_items(s)"])
    
    if data.has("change_atts"):
        change_atts_k.import_data(data["change_atts"])
