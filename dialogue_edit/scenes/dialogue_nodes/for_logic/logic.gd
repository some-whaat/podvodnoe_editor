extends GraphNode

@onready var add_item_check: Button = $HSplitContainer/add_item_check
@onready var add_mission_check: Button = $HSplitContainer/add_mission_check
@onready var check_atts: PanelContainer = $check_atts

var state_index
const type : BroManager.DialNodeType = BroManager.DialNodeType.LOGIC

const ITEM_CHECK = preload("res://dialogue_edit/scenes/dialogue_nodes/for_logic/item_check.tscn")
const MISSIONS_CHECK = preload("res://dialogue_edit/scenes/dialogue_nodes/for_logic/missions_check.tscn")


var added_item_checks := []
#var added_mission_check := []

func _on_add_item_check_pressed() -> void:
    add_item_check_()

func add_item_check_():
    if not len(added_item_checks) > 0:
        var new_item_check := ITEM_CHECK.instantiate()
        add_child(new_item_check)
        
        added_item_checks.append(new_item_check)
        add_item_check.text = "- item check"
        return new_item_check
    else:
        for ch in added_item_checks:
            ch.queue_free()
            
        added_item_checks = []
        
        add_item_check.text = "+ item check"
        return
        
func _ready() -> void:
    check_atts.arr_attr_on_str = "should have"
    check_atts.arr_attr_off_str = "should not have"
    check_atts.single_int_str = "=="

#
#func _on_add_mission_check_pressed() -> void:
    #if not len(added_mission_check) > 0:
        #var new_mission_check := MISSIONS_CHECK.instantiate()
        #add_child(new_mission_check)
        #
        #added_mission_check.append(new_mission_check)
        #add_mission_check.text = "- mission check"
    #else:
        #for ch in added_mission_check:
            #ch.queue_free()
            #
        #added_mission_check = []
        #add_mission_check.text = "+ mission check"

func get_data():
    var res_data := {}
    
    for item_check in added_item_checks:
        res_data["item_check"] = {"needed_item_id": item_check.get_item_id(), "needed_item_state" : item_check.get_item_state()}
    
    var attr_check = check_atts.get_data()
    
    if attr_check:
        res_data["attributes_check"] = attr_check
    
    return res_data
    

func set_data(data : Dictionary):
    if data.has("item_check"):
        var ich = add_item_check_()
        ich.set_data(data["item_check"])
        
    if data.has("attributes_check"):
        check_atts.import_data(data["attributes_check"])
    
