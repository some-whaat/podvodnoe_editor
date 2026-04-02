extends FoldableContainer

var class_type : String
var data : Dictionary
var export_data : Dictionary

@onready var subclass_vbox: VBoxContainer = $subclass_vbox
const FILE_LOADER = preload("res://main_editor/layer/file_loader.tscn")
const NPC_STATES = preload("res://main_editor/layer/npc_states.tscn")



func initiate(class_type_name : String, _data : Dictionary, parent_name : String):
    data = _data
    class_type = class_type_name
    
    title = class_type_name
    
    match class_type_name:
        "Position":
            var x = create_spinbox_and_lable_return_spinbox(subclass_vbox, "x", data["x"])
            var y = create_spinbox_and_lable_return_spinbox(subclass_vbox, "y", data["y"])
            export_data["x"] = x
            export_data["y"] = y
            
        "RendrbleObject":
            # "color": [ 0, 0, 1 ]
            var r = create_spinbox_and_lable_return_spinbox(subclass_vbox, "r", data["color"][0])
            var g = create_spinbox_and_lable_return_spinbox(subclass_vbox, "g", data["color"][1])
            var b = create_spinbox_and_lable_return_spinbox(subclass_vbox, "b", data["color"][2])
            
            export_data["color"] = []
            export_data["color"].append(r)
            export_data["color"].append(g)
            export_data["color"].append(b)
            
            # "is_render": true
            var is_render = create_checkbutton_and_lable_return_checkbutton(subclass_vbox, "is_render", data["is_render"])
            export_data["is_render"] = is_render
            
            # "add_paralax": 0
            var add_paralax = create_spinbox_and_lable_return_spinbox(subclass_vbox, "add_paralax", data["add_paralax"])
            export_data["add_paralax"] = add_paralax
            
        "Picture":
            # "sprite_filepame": "beach_s.txt"
            var sprite_filepame = FILE_LOADER.instantiate()
            subclass_vbox.add_child(sprite_filepame)
            sprite_filepame.set_filepath(data["sprite_filepame"])
            export_data["sprite_filepame"] = sprite_filepame
            
            
        "AnimatbleObj":
            # "animated_sprite_filepame": "big_fish.txt"
            var animated_sprite_filepame = FILE_LOADER.instantiate()
            subclass_vbox.add_child(animated_sprite_filepame)
            animated_sprite_filepame.set_filepath(data["animated_sprite_filepame"])
            export_data["animated_sprite_filepame"] = animated_sprite_filepame
            
            # "anim_speed": 77
            var anim_speed  = create_spinbox_and_lable_return_spinbox(subclass_vbox, "anim_speed", data["anim_speed"])
            export_data["anim_speed"] = anim_speed
            
        "MovingObj":
            pass
            
        "NPC":
            # "does_has_dialogue_on": true
            if data.has("does_has_dialogue_on"):
                var does_has_dialogue_on = create_checkbutton_and_lable_return_checkbutton(subclass_vbox, "does_has_dialogue_on", data["does_has_dialogue_on"])
                export_data["does_has_dialogue_on"] = does_has_dialogue_on
            
            # "defult_state": 0,
            #"states": {}
            var states = NPC_STATES.instantiate()
            subclass_vbox.add_child(states)
            states.npc_name = parent_name
            states.defult_state = data["defult_state"] if data.has("defult_state") else 0
            states.states_data = data["states"]
        
        


func create_checkbutton_and_lable_return_checkbutton(parent : Control, lable_text : String, curr_value : bool) -> CheckButton:
    var hbox_cont = HBoxContainer.new()
    parent.add_child(hbox_cont)
    hbox_cont.set_meta("title", lable_text)
    
    var lable = Label.new()
    lable.text = lable_text
    hbox_cont.add_child(lable)
    
    var checkbutton = CheckButton.new()
    checkbutton.button_pressed = curr_value
    hbox_cont.add_child(checkbutton)
    checkbutton.set_meta("title", lable_text)
    
    return checkbutton

func create_spinbox_and_lable_return_spinbox(parent : Control, lable_text : String, curr_value) -> SpinBox:
    var hbox_cont = HBoxContainer.new()
    parent.add_child(hbox_cont)
    hbox_cont.set_meta("title", lable_text)
    
    var lable = Label.new()
    lable.text = lable_text
    hbox_cont.add_child(lable)
    
    var spinbox = SpinBox.new()
    spinbox.step = 0.1
    spinbox.value = curr_value
    hbox_cont.add_child(spinbox)
    spinbox.set_meta("title", lable_text)
    
    return spinbox

func create_foldble_return_vbox(parent : Control, fold_name : String) -> VBoxContainer:
    var foldble = FoldableContainer.new()
    foldble.title = fold_name
    #foldble.folded = true
    foldble.set_meta("title", fold_name)
    parent.add_child(foldble)
    
    var vbox = VBoxContainer.new()
    foldble.add_child(vbox)
    vbox.set_meta("title", fold_name)
    
    return vbox
