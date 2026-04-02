extends PanelContainer

@onready var attr_name_option: OptionButton = $VBoxContainer/HSplitContainer/attr_name
#@onready var h_split_container: HSplitContainer = $VBoxContainer/HSplitContainer
@onready var v_box_container: VBoxContainer = $VBoxContainer
const SPIN_BOX_WITH_GET_DATA = preload("res://dialogue_edit/scenes/spin_box_with_get_data.tscn")

#var added_atts_arrs = []
#var added_atts_not_arrs = []

var added_atts : Dictionary = {}

const CHANGE_ATTS_ARRS = preload("res://dialogue_edit/scenes/dialogue_nodes/for_action/change_atts_arrs.tscn")

var arr_attr_on_str : String = "add"
var arr_attr_off_str : String = "remove"
var single_int_str : String = " +="


#@onready var attrs_names = BroManager.player_data["Player"]["attributes"].keys()
func _ready() -> void:
    for attr_name in BroManager.ALL_DATA["layers"]["Player"]["Player"]["attributes"]:
        attr_name_option.add_item(attr_name)

#func cosmetics(arr_attr_on_str : String, arr_attr_off_str : String, single_int_str : String):
    #

func _on_button_pressed() -> void:
    var attr_to_add_text = attr_name_option.get_item_text(attr_name_option.selected)
    
    spawn_attr(attr_to_add_text)
    #else:
        #text_edit.text = "Player does not have this attribute"
    #

func spawn_attr(attr_to_add_text : String, data = null) -> void:
    if typeof(BroManager.ALL_DATA["layers"]["Player"]["Player"]["attributes"][attr_to_add_text]) == TYPE_ARRAY:
        var new_attr_arr = CHANGE_ATTS_ARRS.instantiate()
        new_attr_arr.arr_attr_on_str = arr_attr_on_str
        new_attr_arr.arr_attr_off_str = arr_attr_off_str
        v_box_container.add_child(new_attr_arr)
        new_attr_arr.init(attr_to_add_text, data)
        
        if not added_atts.find_key(attr_to_add_text):
            added_atts[attr_to_add_text] = []
        added_atts[attr_to_add_text].append(new_attr_arr)
        #added_atts_arrs.append(new_attr_arr)
    
    else:
        var n_hsc = HSplitContainer.new()
        v_box_container.add_child(n_hsc)
        
        var lable = Label.new()
        lable.text = attr_to_add_text + single_int_str
        n_hsc.add_child(lable)
        
        var spinbox = SPIN_BOX_WITH_GET_DATA.instantiate()
        n_hsc.add_child(spinbox)
        ''' NOT GOOD '''
        if typeof(data) == TYPE_ARRAY:
            spinbox.set_value(data[1])
            spinbox.add_check_butt(data[0])
            
        elif data:
            spinbox.set_value(data)
        
        if not added_atts.find_key(attr_to_add_text):
            added_atts[attr_to_add_text] = []
        added_atts[attr_to_add_text].append(spinbox)
        #added_atts_not_arrs.append(spinbox)

func get_data():
    if len(added_atts) == 0:
        return
    
    var res = {}
    
    for att_name in added_atts:
        res[att_name] = added_atts[att_name][0].get_data()
    
    return res

func import_data(data : Dictionary):
    for attr_key_name in data:
        spawn_attr(attr_key_name, data[attr_key_name])
