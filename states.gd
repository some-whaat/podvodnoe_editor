extends Control

#@onready var file_loader: HBoxContainer = $file_loader
var defult_state = 0
const DIALOGUE_GRATH = preload("res://dialogue_edit/dialogue_grath.tscn")

var states_data : Dictionary
var npc_name : String
var main_main_editor : Node

var dial_grath : Control
var dial_grath_name : String

func _ready() -> void:
    main_main_editor = get_tree().get_root().get_child(-1)

func _on_edit_states_button_pressed() -> void:
    
    #@export var layer_name : String
    #@export var character_name : String
    
    if not dial_grath:
        dial_grath = DIALOGUE_GRATH.instantiate()
        #dial_grath.character_name =  npc_name
        #dial_grath.layer_name = "NPCs"
        dial_grath_name = npc_name + " states editor"
        dial_grath.name = dial_grath_name
        main_main_editor._on_add_editor_element(dial_grath)
        dial_grath.import_from_states_data(states_data, defult_state, npc_name, "NPCs")
    else:
        main_main_editor.switch_to_tab_by_title(dial_grath_name)
